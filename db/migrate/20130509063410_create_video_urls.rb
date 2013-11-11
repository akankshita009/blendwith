class CreateVideoUrls < ActiveRecord::Migration
  def change
    create_table :video_urls do |t|
      t.string :video_url

      t.timestamps
    end
  end
end
