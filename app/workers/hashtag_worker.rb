class HashtagWorker
  include Sidekiq::Worker

  def perform tag, request_id
    importer = HashtagImporter.new(tag, request_id)
    importer.make_api_request
    importer.increment_completeness_of_search_request_batch
  end
end