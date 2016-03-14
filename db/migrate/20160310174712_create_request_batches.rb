class CreateRequestBatches < ActiveRecord::Migration
  def change
    create_table :request_batches do |t|
      t.references :user
      t.text :query_terms, array:true, default: []
      t.boolean :complete, default: false
      t.timestamps null: false
    end
  end
end
