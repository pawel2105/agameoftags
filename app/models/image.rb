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

  def self.import data_hash
    data = data_hash[:data]
    uid, likes, created_time = data[:id], data[:likes][:count], data[:created_time]
    saved_image = Image.create(ig_media_id: uid, ig_publish_time: created_time, number_of_likes: likes)
    saved_image.create_hashtags(data[:tags])
  end

  def create_hashtags tags
    tags.each { |tag| hashtags.create(raw_related_hashtags: tags, label: tag) }
  end
end