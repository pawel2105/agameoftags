require 'rails_helper'
require 'sidekiq/testing'

describe HashtagImporter do
  describe "import" do
    before :each do
      user   = create(:user)
      @batch = create(:request_batch, user: user)
      Sidekiq::Testing.inline!
    end

    it "saves the hashtags returned in the data hash" do
      importer = HashtagImporter.fetch_hashtag 'car', @batch.id
      expect(Hashtag.count).to eq 2
    end

    it "saves the correct hashtag information" do
      importer = HashtagImporter.fetch_hashtag 'car', @batch.id
      expect(Hashtag.first.label).to eq 'car'
      expect(Hashtag.first.total_count_on_ig).to eq 43590
      expect(Hashtag.last.total_count_on_ig).to eq 3264
      expect(Hashtag.last.label).to eq 'snowyday'
    end

    it "updates existing hashtags" do
      Hashtag.create(total_count_on_ig: 123, label: 'snowy')
      importer = HashtagImporter.fetch_hashtag 'car', @batch.id
      expect(Hashtag.first.label).to eq 'snowy'
      expect(Hashtag.first.total_count_on_ig).to eq 43590
    end
  end
end