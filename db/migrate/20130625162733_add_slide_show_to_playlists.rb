class AddSlideShowToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :slide_show, :boolean, default: true
    add_column :playlists, :transition, :string, default: "Slide"
    add_column :playlists, :delay, :integer, default: 5
  end
end
