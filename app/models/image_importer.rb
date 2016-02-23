class ImageImporter
  def self.import data_hash
    data = data_hash[:data]
    uid, likes, created_time = data[:id], data[:likes][:count], data[:created_time]

    saved_image = Image.create(ig_media_id: uid, ig_publish_time: created_time, number_of_likes: likes)
    saved_image.create_hashtags(data[:tags])
  end
end