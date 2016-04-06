class QueriesController < ApplicationController
  before_action :fetch_current_user
  before_action :prepare_results
  before_action :prepare_hashtags

  def new
  end

  def search
    # add before filter to ensure all 3 hashtags.
    # add JS validation in the form to ensure all 3 hashtags are requested.
    # limit to 2 requests per day

    request_batch = record_batch_request

    @query_tags.each do |tag|
      @results << HashtagImporter.fetch_hashtag(tag, request_batch)
    end

    if @results.include?(:instagram_query_in_progress)
      return redirect_to query_waiting_path
    else
      # data is recent enough, display it
    end
  end

  def waiting
  end

  def record_batch_request
    batch = @current_user.request_batches.create(query_terms: @query_tags)
    batch.id
  end

  private

  def prepare_results
    @results = []
  end

  def prepare_hashtags
    one = params["hashtag_one"]
    two = params["hashtag_two"]
    three = params["hashtag_three"]
    @query_tags = [one, two, three].uniq.compact
  end
end