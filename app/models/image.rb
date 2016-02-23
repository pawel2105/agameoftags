# == Schema Information
#
# Table name: images
#
#  id              :integer          not null, primary key
#  ig_media_id     :string
#  ig_publish_time :string
#  number_of_likes :integer          default("0")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Image < ActiveRecord::Base
  has_many :hashtags

  def age_in_hours_since_first_fetched
    (self.created_at.to_i - self.ig_publish_time.to_i) / 3600
  end

  def create_hashtags tags
    tags.each { |tag| hashtags.create(raw_related_hashtags: tags, label: tag) }
  end

  def update_hashtag_info slot_name, likes
    self.hashtags.each do |tag|
      correct_slot = tag.timeslots.where(slot_name: slot_name).first
      correct_slot.number_of_likes += likes
      correct_slot.number_of_photos += 1
      correct_slot.save
    end
  end
end