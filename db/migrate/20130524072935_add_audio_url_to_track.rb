class AddAudioUrlToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :audio_url, :string
  end
end
