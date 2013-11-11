class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :itemizable, polymorphic: { default: "Photo" }
      t.references :playlist

      t.timestamps
    end
    add_index :items, [:itemizable_id, :itemizable_type]
    add_index :items, :playlist_id
  end
end
