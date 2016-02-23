require 'rails_helper'

def weak_image_data_hash
  { data: { tags: ['one', 'two'], likes: { count: 11 }, created_time: '1456244825' } }
end

def strong_image_data_hash
  { data: { tags: ['one', 'two'], likes: { count: 110 }, created_time: '1456244825' } }
end

describe ImageImporter do
  describe "import" do
    it "saves the image with the correct data for an image with 100 likes or more" do
      ImageImporter.import(strong_image_data_hash)
      expect(Image.last.ig_publish_time).to eq '1456244825'
      expect(Image.last.number_of_likes).to eq 110
      expect(Image.last.hashtags.count).to eq 2
    end

    it "saves the hashtags for an image with 100 likes or more" do
      ImageImporter.import(strong_image_data_hash)
      expect(Hashtag.count).to eq 2
      expect(Hashtag.first.label).to eq 'one'
      expect(Hashtag.last.label).to eq 'two'
      expect(Hashtag.first.raw_related_hashtags).to eq ['one', 'two']
      expect(Hashtag.last.raw_related_hashtags).to eq ['one', 'two']
    end

    it "updates the correct timeslot" do
      ImageImporter.import(strong_image_data_hash)
      expect(Timeslot.count).to eq 336
      image_hashtags = Image.first.hashtags
      image_hashtags.each do |tag|
        expect(tag.timeslots.where(slot_name: 'tue_18').first.number_of_photos).to eq 1
        expect(tag.timeslots.where(slot_name: 'tue_18').first.number_of_likes).to eq 110
      end
    end

    it "does not import the image for an image with 99 likes or less" do
      ImageImporter.import(weak_image_data_hash)
      expect(Image.count).to eq 0
    end

    it "does not save any hashtags for an image with 99 likes or less" do
      ImageImporter.import(weak_image_data_hash)
      expect(Hashtag.count).to eq 0
    end
  end
end