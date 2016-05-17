class HomeController < ApplicationController
  before_action :fetch_current_user
  before_action :redirect_logged_in_user

  def intro
  end

  private

  def redirect_logged_in_user
    if @current_user
      return redirect_to new_query_path
    end
  end
end