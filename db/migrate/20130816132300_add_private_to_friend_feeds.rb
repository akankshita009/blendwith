class AddPrivateToFriendFeeds < ActiveRecord::Migration
  def change
    add_column :friend_feeds, :private, :boolean, :default => false
  end
end
