class AddCanEmbedPlayerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :embed_code_privacy, :integer, :limit => 1, :default => 0
  end
end
