class AddMusicPhotoToUploadedAudio < ActiveRecord::Migration
  def change
    add_column :uploaded_audios, :music_photo_file_name, :string
    add_column :uploaded_audios, :music_photo_content_type, :string
    add_column :uploaded_audios, :music_photo_file_size, :string
    add_column :uploaded_audios, :music_photo_updated_at, :string
  end
end
