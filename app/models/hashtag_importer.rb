require 'net/http'

class HashtagImporter
  def self.fetch_hashtag tag, user_id, request_batch_id=nil
    importer = new(tag, user_id, request_batch_id)
    importer.fetch_hashtag(:primary_tag)
  end

  def initialize tag, user_id, request_batch_id=nil
    @tag = tag
    @user_id = user_id
    @request_batch_id = request_batch_id
  end

  def fetch_details_for_related_tags
    puts "fetch_details_for_related_tags for #{@tag}"
    parent_tag = Hashtag.where(label: @tag).first

    if parent_tag
      parent_tag.related_hashtags.each do |related_tag|
        fetch_hashtag(:related_tag, related_tag)
      end
    end
  end

  def check_how_to_perform_request tag_type, request_id, related_tag=nil
    if tag_type == :related_tag
      make_api_request_for(related_tag)
    else
      perform_async(request_id)
    end
  end

  def fetch_hashtag tag_type, related_tag=nil
    tag_to_check = related_tag || @tag
    request = SearchRequest.where(query: tag_to_check)

    if searched_for_within_last_hour?(request)
      request.first.increment!(:search_count)
    elsif request.any?
      new_count = request.first.search_count + 1
      request.first.update_attributes(search_count: new_count, last_api_search: Time.now)
      check_how_to_perform_request(tag_type, request.first.id, related_tag)
    else
      record_query
      check_how_to_perform_request(tag_type, @request_batch_id, related_tag)
    end
  end

  def perform_async request_id
    HashtagWorker.perform_async(@tag, @user_id, request_id)
    return :instagram_query_in_progress
  end

  def searched_for_within_last_hour? request
    return false unless request.any?
    request.last.last_api_search > (Time.now - 1.hour)
  end

  def fetch_and_save_data_for_single_tag api_fetcher, tag
    data_for_tag = api_fetcher.single_tag_data(tag)

    if data_for_tag == :ig_status_429
      HashtagWorker.perform_in(30.minutes, tag, @user_id, @request_batch_id)
      return :ig_status_429
    else
      import(tag, data_for_tag)
    end
  end

  def fetch_and_save_recent_related_images_for_tag ig_data_object, tag
    ImageImporter.import(ig_data_object)
    Hashtag.update_siblings(tag, ig_data_object)
  end

  def record_query
    SearchRequest.create(query: @tag, last_api_search: Time.now, search_count: 1)
  end

  def increment_completeness_of_search_request_batch
    RequestBatch.increment_completeness_for @request_batch_id
  end

  def make_api_request_for related_tag
    api_fetcher = InstagramInterface.new(@user_id, related_tag)
    puts "running fetch_and_save_data_for_single_tag for RELATED TAG: #{related_tag}"
    result = fetch_and_save_data_for_single_tag(api_fetcher, related_tag)

    if result != :ig_status_429
      api_fetcher.hashtag_media.each do |ig_data_object|
        fetch_and_save_recent_related_images_for_tag ig_data_object, related_tag
      end
    end
  end

  def make_api_request
    request = RequestBatch.find(@request_batch_id)
    api_fetcher = InstagramInterface.new(request.user.id, @tag)
    result = fetch_and_save_data_for_single_tag(api_fetcher, @tag)

    if result != :ig_status_429
      all_media = api_fetcher.hashtag_media

      all_media.each do |ig_data_object|
        puts "running fetch_and_save_recent_related_images_for_tag for #{@tag} hashtag media"
        fetch_and_save_recent_related_images_for_tag ig_data_object, @tag
      end

      all_media.each do |ig_data_object|
        puts "updating self as primary tag"
        Hashtag.update_own_related_tags(@tag, ig_data_object)
      end
    end
  end

  def import tag, data_hash
    data_hash.each do |obj|
      if obj[0] == 'data'
        media_count = obj[1][:media_count] || obj[1]['media_count']
        Hashtag.update_or_create(tag, media_count)
      end
    end
  end
end