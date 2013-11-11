class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :name
      t.references :player
      t.integer :items_count

      t.timestamps
    end
    add_index :playlists, :player_id
  end
end
