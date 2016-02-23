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

require 'rails_helper'

describe Image do
  describe "age_in_hours_since_first_fetched" do
    it "has zero number_of_photos" do
      frozen_time = Time.local(2015, 1, 1, 12, 0, 0)

      Timecop.freeze(frozen_time) do
        pub_time = (frozen_time - 6.days).to_i
        @image = Image.create(ig_publish_time: pub_time)
      end

      expect(@image.age_in_hours_since_first_fetched).to eq 144
    end
  end
end