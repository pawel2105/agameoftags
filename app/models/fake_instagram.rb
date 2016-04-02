require 'open-uri'

class FakeInstagram
  def initialize user
    @token = user.ig_access_token
  end

  # https://api.instagram.com/v1/tags/{tag-name}/media/recent?access_token=ACCESS-TOKEN
  def hashtag_media
    results_list = []

    response = open("https://api.instagram.com/v1/tags/#{tag}/media/recent?access_token=#{@token}").read
    response_object = JSON.parse(response)

    response_object["data"].each do |image_object|
      single_image = {}
      single_image['type']       = 'image'
      single_image['likes']      = { 'count' => image_object['likes']['count'] }
      single_image['tags']       = image_object['tags']
      single_image['id']         = image_object['id']
      single_image['created_at'] = image_object['created_time']

      results_list.push single_image
    end

    return results_list
  end

  # https://api.instagram.com/v1/tags/{tag-name}?access_token=ACCESS-TOKEN
  def single_tag_data tag
    response = open("https://api.instagram.com/v1/tags/#{tag}?access_token=#{@token}").read
    response_object = JSON.parse(response)
    return response_object
  end
end