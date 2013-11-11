class CreateFriendFeed < ActiveRecord::Migration
  def change
    create_table :friend_feeds do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :network
      t.string :title
      t.string :image_url

      t.timestamps
    end
  end
end
