class AddPlayerDescriptionToUser < ActiveRecord::Migration
  def change
    add_column :users, :player_description, :text
  end
end
