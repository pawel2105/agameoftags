# == Schema Information
#
# Table name: request_batches
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  query_terms      :text             default("{}"), is an Array
#  complete         :boolean          default("false")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  complete_queries :integer          default("0")
#

FactoryGirl.define do
  factory :request_batch do
  end
end
