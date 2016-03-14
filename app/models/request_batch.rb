# == Schema Information
#
# Table name: request_batches
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  query_terms :text             default("{}"), is an Array
#  complete    :boolean          default("false")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class RequestBatch < ActiveRecord::Base
  belongs_to :user
end
