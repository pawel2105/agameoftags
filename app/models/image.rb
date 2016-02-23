# == Schema Information
#
# Table name: images
#
#  id              :integer          not null, primary key
#  ig_media_id     :string
#  ig_publish_time :datetime
#  number_of_likes :integer          default("0")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Image < ActiveRecord::Base
  has_many :hashtags

  def age_in_hours_since_first_fetched
    (self.created_at.to_i - self.ig_publish_time.to_i) / 3600
  end
end
