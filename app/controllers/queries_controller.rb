class QueriesController < ApplicationController
  before_action :prepare_results
  before_action :prepare_hashtags

  def search
    # add before filter to ensure all 3 hashtags.
    # add JS validation in the form to ensure all 3 hashtags are requested.

    @query_tags.each do |tag|
      @results << HashtagImporter.fetch_hashtag(tag)
    end

    if @results.include?(true)
      return redirect_to query_waiting_path
    else
      # data is recent enough, display it
    end
  end

  def waiting
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