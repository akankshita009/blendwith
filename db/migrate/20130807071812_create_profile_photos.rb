class CreateProfilePhotos < ActiveRecord::Migration
  def change
    create_table :profile_photos do |t|
      t.integer :user_id
      t.string :profile_photo_file_name
      t.string :profile_photo_content_type
      t.integer :profile_photo_file_size
      t.datetime :profile_photo_updated_at

      t.timestamps
    end
  end
end