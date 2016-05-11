class FaqController < ApplicationController
  before_action :fetch_current_user, only: [:faq]
  before_action :bounce_guests, only: [:faq]

  def faq
  end

  def privacy
  end

  def terms
  end
end