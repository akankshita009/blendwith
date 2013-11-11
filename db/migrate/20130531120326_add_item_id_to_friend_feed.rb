class AddItemIdToFriendFeed < ActiveRecord::Migration
  def change
    add_column :friend_feeds, :item_id, :integer
  end
end
