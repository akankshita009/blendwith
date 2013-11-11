class AddNetworkToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :network, :string
  end
end
