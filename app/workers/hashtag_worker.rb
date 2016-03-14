class HashtagWorker
  include Sidekiq::Worker

  def perform tag, request
    importer = HashtagImporter.new
    importer.make_api_request_for(tag, request)
  end
end