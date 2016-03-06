class FakeInstagram

  # https://api.instagram.com/v1/tags/{tag-name}/media/recent?access_token=ACCESS-TOKEN
  def self.hashtag_media letter=nil
    final_hash = { "data": [] }

    random_letter = letter || ALL_WORDS.sample[0]

    10.times do
      random_tags = []
      rand(20).times do
        random_tags.push ALL_WORDS.select { |x| x[0] == random_letter }.sample
      end
      random_tags = random_tags.uniq
      hash = { "type": "image", "tags": random_tags, "likes": { "count": rand(4000) },
               "id": rand(10000000).to_s, "created_at": Time.at(rand * Time.now.to_i).to_i }
      final_hash[:data].push hash
    end

    return final_hash
  end

  # https://api.instagram.com/v1/tags/{tag-name}?access_token=ACCESS-TOKEN
  def self.single_tag_data tag
    return { "data": { "media_count": rand(4000), "name": tag } }
  end
end