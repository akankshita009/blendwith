class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :caption
      t.text :image_url
      t.boolean :private, :default => false

      t.timestamps
    end
  end
end
