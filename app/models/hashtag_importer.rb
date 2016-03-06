require 'net/http'

class HashtagImporter
  def self.fetch_hashtag tag
    request_for_tag = SearchRequest.where(query: tag).first
    importer = new()

    if request_for_tag && request_for_tag.last_api_search > (Time.now - 24.hours)
      new_count = request_for_tag.search_count + 1
      request_for_tag.update_attributes(search_count: new_count)
      return false
    elsif request_for_tag
      new_count = request_for_tag.search_count + 1
      request_for_tag.update_attributes(search_count: new_count, last_api_search: Time.now)
      importer.make_api_request_for(tag)
      return true
    else
      SearchRequest.create(query: tag, last_api_search: Time.now)
      importer.make_api_request_for(tag)
      return true
    end
  end

  def make_api_request_for tag
    data_for_tag = FakeInstagram.single_tag_data(tag)
    import(tag, data_for_tag)

    data_hash = FakeInstagram.hashtag_media
    data_hash[:data].each do |ig_object|
      ImageImporter.import(ig_object)
    end
  end

  def import tag, data_hash
    data_array = data_hash[:data]

    data_array.each do |obj|
      Hashtag.update_or_create(tag, obj[1])
    end
  end
end