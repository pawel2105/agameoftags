class TransactionMailer < ActionMailer::Base
  append_view_path("#{Rails.root}/app/views/mailers")
  default from: "Pawel from AGOT <pawel@agameoftags.com>"

  def notify_subscriber email
    @user = User.where(email: email).first
    mail(to: @user.email, subject: 'Confirm your credentials')
  end
end