class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.references :image
      t.text :raw_related_hashtag
      t.text :related_hashtags
      t.text :related_hashtag_ids
      t.integer :total_count_on_ig
      t.timestamps null: false
    end
  end
end
