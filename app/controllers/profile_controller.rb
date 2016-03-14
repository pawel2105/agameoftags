class ProfileController < ApplicationController
  before_action :fetch_current_user

  def searches
    @searches = @current_user.request_batches.reverse
  end
end