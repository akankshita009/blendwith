class CreateVideoAlbums < ActiveRecord::Migration
  def change
    create_table :video_albums do |t|
      t.string :name
      t.text :image_url
      t.string :network
      t.string :social_network_id

      t.timestamps
    end
  end
end
