class ImageImporter
  def self.import data
    uid, likes, created_time, tags = data[:id], data[:likes][:count], data[:created_time], data[:tags]
    return unless likes.to_i > 99
    return false if Image.where(ig_media_id: uid).any?
    self.create_image(uid, likes, created_time, tags)
  end

  def self.create_image uid, likes, created_time, tags
    slot_name   = TimeConverter.new(created_time).get_slot_name
    saved_image = Image.create(ig_media_id: uid, ig_publish_time: created_time, number_of_likes: likes)
    saved_image.create_hashtags(tags)
    saved_image.update_hashtag_info(slot_name, likes)
  end
end