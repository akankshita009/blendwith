class AddSocialNetworkIdToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :social_network_id, :string
  end
end
