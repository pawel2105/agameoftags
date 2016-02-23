# == Schema Information
#
# Table name: hashtags
#
#  id                   :integer          not null, primary key
#  image_id             :integer
#  label                :string
#  raw_related_hashtags :text             default("{}"), is an Array
#  related_hashtags     :text             default("{}"), is an Array
#  related_hashtag_ids  :text             default("{}"), is an Array
#  total_count_on_ig    :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
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
