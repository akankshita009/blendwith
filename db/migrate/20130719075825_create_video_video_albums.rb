class CreateVideoVideoAlbums < ActiveRecord::Migration
  def change
    create_table :video_video_albums do |t|
      t.references :video
      t.references :video_album

      t.timestamps
    end

    add_index :video_video_albums, :video_id
    add_index :video_video_albums, :video_album_id
  end
end
