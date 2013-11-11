class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :uid
      t.text :provider
      t.references :user
      t.string :access_token

      t.timestamps
    end
    add_index :services, :user_id
  end
end
