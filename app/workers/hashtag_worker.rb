class HashtagWorker
  include Sidekiq::Worker

  def perform tag
    importer = HashtagImporter.new
    importer.make_api_request_for(tag)
  end
end