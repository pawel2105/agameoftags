# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  auth_digest     :text
#  last_login_time :string
#  uid             :string
#  ig_username     :string
#  ig_access_token :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  has_many :request_batches

  def self.find_or_create_from_uid auth_hash
    time_of_request = DateTime.current.to_i
    uid, username, access_token = self.attrs_from(auth_hash)

    if user = User.where(uid: uid).first
      user.update(last_login_time: time_of_request)
      user
    else
      User.create(uid: uid, ig_username: username, ig_access_token: access_token, last_login_time: time_of_request)
    end
  end

  private

  def self.attrs_from hash
    [hash.uid, hash.info.nickname, hash.credentials.token]
  end
end
