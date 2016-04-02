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

class RequestBatch < ActiveRecord::Base
  belongs_to :user

  def self.increment_completeness_for request_id
    request   = RequestBatch.find(request_id)
    new_count = request.complete_queries + 1
    request.update(complete_queries: new_count)

    request.mark_as_complete! if new_count == 3
  end

  def mark_as_complete!
    update(complete: true)
  end
end