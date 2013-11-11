class CreateTwitterUsers < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.text :twitter_user

      t.timestamps
    end
  end
end
