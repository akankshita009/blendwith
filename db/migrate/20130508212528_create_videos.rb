class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :video_object
      t.boolean :private, :default => false

      t.timestamps
    end
  end
end
