class AddNetworkToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :network, :string
  end
end
