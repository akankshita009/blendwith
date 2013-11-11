class AddBackgroundMusicToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :background_music_id, :string
    add_column :playlists, :background_music_type, :string
    add_column :playlists, :background_music_url, :string
    add_column :playlists, :background_music_title, :string
  end
end
