class QueriesController < ApplicationController
  before_action :fetch_current_user
  before_action :bounce_guests
  before_action :prepare_results
  before_action :prepare_hashtags
  before_action :ensure_search_is_allowed, only: [:search]

  def new
  end

  def search
    request_batch = record_batch_request

    @query_tags.each do |tag|
      @results << HashtagImporter.fetch_hashtag(tag, @current_user.id, request_batch)
    end

    if !@results.include?(:instagram_query_in_progress)
      return redirect_to query_waiting_path
    else
      return redirect_to query_waiting_path
    end
  end

  def waiting
  end

  def record_batch_request
    batch = @current_user.request_batches.create(query_terms: @query_tags)
    return batch.id
  end

  private

  def ensure_search_is_allowed
    return true if @current_user.can_search?
    flash[:notice] = 'You are not allowed to do that'
    redirect_to root_path
  end

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