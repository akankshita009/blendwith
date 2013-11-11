class CreateUploadedAudio < ActiveRecord::Migration
  def change
    create_table :uploaded_audios do |t|
      t.string :title
      t.integer :user_id
      t.string :panda_audio_id

      t.timestamps
    end
  end
end
