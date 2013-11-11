class CreateMusicUrls < ActiveRecord::Migration
  def change
    create_table :music_urls do |t|
      t.string :music_url
      t.integer :user_id

      t.timestamps
    end
  end
end
