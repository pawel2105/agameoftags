class ResultsController < ApplicationController
  before_action :fetch_current_user

  def show
    batch    = @current_user.request_batches.find(params[:id])
    @results = ResultBuilder.new(batch).results
  end
end