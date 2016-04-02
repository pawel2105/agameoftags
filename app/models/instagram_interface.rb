require 'open-uri'

class InstagramInterface
  def initialize user
    @token = user.ig_access_token
  end

  # https://api.instagram.com/v1/tags/{tag-name}/media/recent?access_token=ACCESS-TOKEN
  def hashtag_media letter=nil
    if Rails.env.test?
      return media_fixtures_for_test_environment letter=nil
    else
      return real_instagram_results_for_media
    end
  end

  # https://api.instagram.com/v1/tags/{tag-name}?access_token=ACCESS-TOKEN
  def single_tag_data tag
    if Rails.env.test?
      return fixture_for_test_environment tag
    else
      return real_instagram_result
    end
  end

  private

  def real_instagram_result
    response = open("https://api.instagram.com/v1/tags/#{tag}?access_token=#{@token}").read
    response_object = JSON.parse(response)
    return response_object
  end

  def real_instagram_results_for_media
    results_list = []

    response = open("https://api.instagram.com/v1/tags/#{tag}/media/recent?access_token=#{@token}").read
    response_object = JSON.parse(response)

    response_object["data"].each do |image_object|
      single_image = {}
      single_image[:type]       = 'image'
      single_image[:likes]      = { count: image_object['likes']['count'] }
      single_image[:tags]       = image_object['tags']
      single_image[:id]         = image_object['id']
      single_image[:created_at] = image_object['created_time']

      results_list.push single_image
    end

    return results_list
  end

  def fixture_for_test_environment tag
    return { "data": { media_count: rand(4000), name: tag } }
  end

  def media_fixtures_for_test_environment letter=nil

    results_list  = []
    chosen_letter = letter || 'c'

    10.times do
      random_tags = []
      rand(20).times do
        random_tags.push ALL_WORDS.select { |x| x[0] == chosen_letter }.sample
      end

      random_tags = random_tags.uniq
      hash = { type: "image", tags: random_tags, likes: { count: rand(4000) },
               id: rand(10000000).to_s, created_at: Time.at(rand * Time.now.to_i).to_i }
      results_list.push hash
    end

    return results_list
  end
end