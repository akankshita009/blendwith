class AddPlayerTitleToUser < ActiveRecord::Migration
  def change
    add_column :users, :player_title, :string
  end
end
