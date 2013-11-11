class AddMediaTypeToFriendFeed < ActiveRecord::Migration
  def change
    add_column :friend_feeds, :media_type, :string
  end
end
