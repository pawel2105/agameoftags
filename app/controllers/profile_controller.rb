class ProfileController < ApplicationController
  before_action :fetch_current_user
  before_action :bounce_guests

  def searches
    @searches = @current_user.request_batches.reverse
  end
end