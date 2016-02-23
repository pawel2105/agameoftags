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

def data_hash
  { data: { tags: ['one', 'two'], likes: { count: 11 }, created_time: '1337' } }
end

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

  describe "import" do
    it "saves the image with the correct data" do
      Image.import(data_hash)
      expect(Image.last.ig_publish_time).to eq '1337'
      expect(Image.last.number_of_likes).to eq 11
      expect(Image.last.hashtags.count).to eq 2
    end

    it "saves the hashtags" do
      Image.import(data_hash)
      expect(Hashtag.count).to eq 2
      expect(Hashtag.first.label).to eq 'one'
      expect(Hashtag.last.label).to eq 'two'
      expect(Hashtag.first.raw_related_hashtags).to eq ['one', 'two']
      expect(Hashtag.last.raw_related_hashtags).to eq ['one', 'two']
    end
  end
end