class CreatePhotoUrls < ActiveRecord::Migration
  def change
    create_table :photo_urls do |t|
      t.string :image_url      

      t.timestamps
    end
  end
end
