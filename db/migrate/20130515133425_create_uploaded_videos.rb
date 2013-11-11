class CreateUploadedVideos < ActiveRecord::Migration
  def change
    create_table :uploaded_videos do |t|
      t.string :title
      t.integer :user_id
      t.string :panda_video_id

      t.timestamps
    end
  end
end
