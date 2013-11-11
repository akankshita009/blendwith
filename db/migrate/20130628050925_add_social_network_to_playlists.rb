class AddSocialNetworkToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :social_network, :string
  end
end
