class AddPlayerTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :player_token, :string
  end
end
