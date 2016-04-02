class AddUsersToSearchRequests < ActiveRecord::Migration
  def change
    add_column :search_requests, :user_id, :integer
  end
end