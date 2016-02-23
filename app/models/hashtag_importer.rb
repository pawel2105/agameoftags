class HashtagImporter
  def fetch_hashtags
    # this is where the API call will be made
    # use the tags/search endpoint to get:
  end

  def self.import data_hash
    data_array = data_hash[:data]
    data_array.each do |obj|
      Hashtag.update_or_create(obj[:name], obj[:media_count])
    end
  end
end