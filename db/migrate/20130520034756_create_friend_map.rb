class CreateFriendMap < ActiveRecord::Migration
  def change
    create_table :friend_maps do |t|
      t.integer :user_id
      t.integer :friend_id
      t.boolean :is_confirmed, :default => false

      t.timestamps
    end
  end
end
