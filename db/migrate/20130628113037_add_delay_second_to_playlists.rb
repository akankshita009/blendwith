class AddDelaySecondToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :delay_second, :integer, default: 5
    remove_column :playlists, :delay
  end
end
