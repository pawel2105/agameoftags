class TransactionMailer < ActionMailer::Base
  append_view_path("#{Rails.root}/app/views/mailers")
  default from: "Admin from AGOT <admin@agameoftags.com>"

  def notify_subscriber batch_id
    @batch = RequestBatch.find(batch_id)
    @user  = @batch.user
    mail(to: @user.email, subject: 'Your hashtags are ready!')
  end
end