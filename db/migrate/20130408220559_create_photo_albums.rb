class CreatePhotoAlbums < ActiveRecord::Migration
  def change
    create_table :photo_albums do |t|
      t.references :photo
      t.references :album

      t.timestamps
    end
    add_index :photo_albums, :photo_id
    add_index :photo_albums, :album_id
  end
end
