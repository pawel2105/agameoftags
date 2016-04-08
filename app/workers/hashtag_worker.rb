class HashtagWorker
  include Sidekiq::Worker

  def perform tag, user_id, request_id
    importer = HashtagImporter.new(tag, user_id, request_id)
    importer.make_api_request
    importer.fetch_details_for_related_tags
    importer.increment_completeness_of_search_request_batch
  end
end