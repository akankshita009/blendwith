class AddArtistToUploadedAudio < ActiveRecord::Migration
  def change
    add_column :uploaded_audios, :artist, :string
    add_column :uploaded_audios, :album, :string
    add_column :uploaded_audios, :genre, :string
  end
end
