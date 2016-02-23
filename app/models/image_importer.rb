class ImageImporter
  def fetch_data
    # this is where the API call will be made
  end

  def self.import data_hash
    data = data_hash[:data]
    uid, likes, created_time = data[:id], data[:likes][:count], data[:created_time]
    slot_name = TimeConverter.new(created_time).get_slot_name

    return unless likes.to_i > 99

    saved_image = Image.create(ig_media_id: uid, ig_publish_time: created_time, number_of_likes: likes)
    saved_image.create_hashtags(data[:tags])

    saved_image.hashtags.each do |tag|
      correct_slot = tag.timeslots.where(slot_name: slot_name).first
      correct_slot.number_of_likes += likes
      correct_slot.number_of_photos += 1
      correct_slot.save
    end
  end
end