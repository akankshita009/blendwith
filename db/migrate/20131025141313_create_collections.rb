class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :title
      t.text :image_url
      t.string :network
      t.string :social_netowrk_id

      t.timestamps
    end
  end
end
