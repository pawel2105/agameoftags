require 'rails_helper'

def data_hash
  { data: { tags: ['one', 'two'], likes: { count: 11 }, created_time: '1337' } }
end

describe ImageImporter do
  describe "import" do
    it "saves the image with the correct data" do
      ImageImporter.import(data_hash)
      expect(Image.last.ig_publish_time).to eq '1337'
      expect(Image.last.number_of_likes).to eq 11
      expect(Image.last.hashtags.count).to eq 2
    end

    it "saves the hashtags" do
      ImageImporter.import(data_hash)
      expect(Hashtag.count).to eq 2
      expect(Hashtag.first.label).to eq 'one'
      expect(Hashtag.last.label).to eq 'two'
      expect(Hashtag.first.raw_related_hashtags).to eq ['one', 'two']
      expect(Hashtag.last.raw_related_hashtags).to eq ['one', 'two']
    end
  end
end