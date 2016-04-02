require 'net/http'

class HashtagImporter
  def self.fetch_hashtag tag, request
    @tag = tag
    @request_id = request.id

    importer = new()
    importer.fetch_hashtag
  end

  def fetch_hashtag
    request = SearchRequest.where(query: @tag)

    if searched_for_within_last_hour?(request)
      request.first.increment!(:search_count)
    elsif request.any?
      new_count = request.first.search_count + 1
      request.first.update_attributes(search_count: new_count, last_api_search: Time.now)
      perform_async
    else
      record_query
      perform_async
    end
  end

  def perform_async
    HashtagWorker.perform_async(@tag, @request_id)
    return :instagram_query_in_progress
  end

  def searched_for_within_last_hour? request
    request.any? && request.last_api_search > (Time.now - 1.hour)
  end

  def fetch_and_save_data_for_single_tag api_fetcher, tag
    data_for_tag = api_fetcher.single_tag_data(tag)
    import(tag, data_for_tag)
  end

  def fetch_and_save_recent_related_images_for_tag object, tag
    ImageImporter.import(object)
    Hashtag.update_siblings(tag, object)
  end

  def record_query
    SearchRequest.create(query: @tag, last_api_search: Time.now)
  end

  def increment_completeness_of_search_request_batch request_id
    RequestBatch.increment_completeness_for request_id
  end

  def make_api_request_for tag, request_id
    api_fetcher = FakeInstagram.new(user)
    fetch_and_save_data_for_single_tag(api_fetcher, tag)

    api_fetcher.hashtag_media.each do |ig_object|
      fetch_and_save_recent_related_images_for_tag object, tag
    end
  end

  def import tag, data_hash
    data_hash.each do |obj|
      current_tag = Hashtag.update_or_create(tag, obj[1])
    end
  end
end