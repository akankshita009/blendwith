class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.references :albumize, :polymorphic => true
      t.references :collection

      t.timestamps
    end
    add_index :containers, :albumize_id
    add_index :containers, :albumize_type
    add_index :containers, :collection_id
  end
end
