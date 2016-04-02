class AddCompleteQueriesToRequestBatches < ActiveRecord::Migration
  def change
    add_column :request_batches, :complete_queries, :integer, default: 0
  end
end