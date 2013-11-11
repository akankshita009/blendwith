class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name, :null => false, :default => ""
      t.integer :user_id

      t.timestamps
    end
    add_index :players, :user_id
  end
end
