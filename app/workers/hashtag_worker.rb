class HashtagWorker
  include Sidekiq::Worker

  def perform tag, request_id
    importer = HashtagImporter.new
    importer.make_api_request_for(tag, request_id)
    importer.increment_completeness_of_search_request_batch(request_id)
  end
end