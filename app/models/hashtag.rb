# == Schema Information
#
# Table name: hashtags
#
#  id                  :integer          not null, primary key
#  image_id            :integer
#  raw_related_hashtag :text
#  related_hashtags    :text
#  related_hashtag_ids :text
#  total_count_on_ig   :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Hashtag < ActiveRecord::Base
  belongs_to :image
  has_many :timeslots

  after_create :add_timeslots

  private

  def add_timeslots
    TIMESLOT_LABELS.each { |slot| self.timeslots.create(slot_name: slot) }
  end
end
