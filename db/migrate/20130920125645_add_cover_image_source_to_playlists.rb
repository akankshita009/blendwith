class AddCoverImageSourceToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :cover_image_source, :string
  end
end
