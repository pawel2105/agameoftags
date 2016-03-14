require 'net/http'

class HashtagImporter
  def self.fetch_hashtag tag, request
    @tag = tag
    @request = request
    importer = new()
    importer.fetch_hashtag
  end

  def fetch_hashtag
    request_for_tag = SearchRequest.where(query: @tag).first

    if request_for_tag && request_for_tag.last_api_search > (Time.now - 1.hour)
      new_count = request_for_tag.search_count + 1
      request_for_tag.update_attributes(search_count: new_count)
    elsif request_for_tag
      new_count = request_for_tag.search_count + 1
      request_for_tag.update_attributes(search_count: new_count, last_api_search: Time.now)
      HashtagWorker.perform_async(@tag, @request)
      return :instagram_query_in_progress
    else
      record_query
      HashtagWorker.perform_async(@tag, @request)
      return :instagram_query_in_progress
    end
  end

  def record_query
    SearchRequest.create(query: @tag, last_api_search: Time.now)
  end

  def make_api_request_for tag, request
    data_for_tag = FakeInstagram.single_tag_data(tag)
    import(tag, data_for_tag)

    data_hash = FakeInstagram.hashtag_media
    data_hash[:data].each do |ig_object|
      ImageImporter.import(ig_object)
      Hashtag.update_siblings(tag, ig_object)
    end

    # find all hashtags being updated for the `request` object
    # once they are all completed, mark the request object complete as true using its internal method
    # pump all the hashtags into that batch request
  end

  def import tag, data_hash
    data_array = data_hash[:data]

    data_array.each do |obj|
      current_tag = Hashtag.update_or_create(tag, obj[1])
    end
  end
end