require 'rails_helper'

def data_hash
  { "data": [ { "media_count": 43590, "name": "snowy" }, { "media_count": 3264, "name": "snowyday" } ]}
end

describe HashtagImporter do
  describe "import" do
    it "saves the hashtags returned in the data hash" do
      HashtagImporter.import(data_hash)
      expect(Hashtag.count).to eq 2
    end

    it "saves the correct hashtag information" do
      HashtagImporter.import(data_hash)
      expect(Hashtag.first.total_count_on_ig).to eq 43590
      expect(Hashtag.first.label).to eq 'snowy'
      expect(Hashtag.last.total_count_on_ig).to eq 3264
      expect(Hashtag.last.label).to eq 'snowyday'
    end

    it "updates existing hashtags" do
      Hashtag.create(total_count_on_ig: 123, label: 'snowy')
      HashtagImporter.import(data_hash)
      expect(Hashtag.first.total_count_on_ig).to eq 43590
      expect(Hashtag.first.label).to eq 'snowy'
    end
  end
end