require 'net/http'

class HashtagImporter
  def self.fetch_hashtag tag
    @tag = tag
    importer = new()
    importer.fetch_hashtag
  end

  def fetch_hashtag
    request_for_tag = SearchRequest.where(query: @tag).first

    if request_for_tag && request_for_tag.last_api_search > (Time.now - 24.hours)
      new_count = request_for_tag.search_count + 1
      request_for_tag.update_attributes(search_count: new_count)
    elsif request_for_tag
      new_count = request_for_tag.search_count + 1
      request_for_tag.update_attributes(search_count: new_count, last_api_search: Time.now)
      HashtagWorker.perform_async(@tag)
      return :instagram_query_in_progress
    else
      record_query
      HashtagWorker.perform_async(@tag)
      return :instagram_query_in_progress
    end
  end

  def record_query
    SearchRequest.create(query: @tag, last_api_search: Time.now)
  end

  def make_api_request_for tag
    data_for_tag = FakeInstagram.single_tag_data(tag)
    import(tag, data_for_tag)

    data_hash = FakeInstagram.hashtag_media
    data_hash[:data].each do |ig_object|

      Rails.logger.warn ig_object.inspect

      ImageImporter.import(ig_object)
      Hashtag.update_siblings(tag, ig_object)
    end
  end

  def import tag, data_hash
    data_array = data_hash[:data]

    data_array.each do |obj|
      current_tag = Hashtag.update_or_create(tag, obj[1])
    end
  end
end