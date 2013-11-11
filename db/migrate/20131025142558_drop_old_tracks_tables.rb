class DropOldTracksTables < ActiveRecord::Migration
  def up
    #drop_table :track_track_albums
    #drop_table :track_albums
  end

  def down

    create_table :track_track_albums do |t|
      t.integer :track_id
      t.integer :track_album_id
      t.timestamps
    end

    create_table :track_albums do |t|
      t.string :name
      t.text :image_url
      t.string :network
      t.string :social_network_id
      t.timestamps
    end
  end
end
