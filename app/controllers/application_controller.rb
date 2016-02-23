class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def fetch_current_user
    cookie_key = cookies.permanent[:session_key]
    return false unless cookie_key
    @current_user = User.where(auth_digest: cookie_key).first
  end
end