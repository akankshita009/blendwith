class AddTypeToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :type, :string, :default => "ImagePlaylist"
  end
end
