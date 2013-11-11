class CreateCoverPhotos < ActiveRecord::Migration
  def change
    create_table :cover_photos do |t|
      t.integer :user_id
      t.string :cover_photo_file_name
      t.string :cover_photo_content_type
      t.integer :cover_photo_file_size
      t.datetime :cover_photo_updated_at

      t.timestamps
    end
  end
end
