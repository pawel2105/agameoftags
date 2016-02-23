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

require 'rails_helper'

describe Hashtag do
  describe "creation" do
    it "new hashtag comes with 168 timeslots" do
      hashtag = Hashtag.create
      expect(hashtag.timeslots.count).to eq(168)
    end
  end
end
