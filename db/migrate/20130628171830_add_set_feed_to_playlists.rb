class AddSetFeedToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :set_feed, :boolean, default: true
  end
end
