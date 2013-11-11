class AddSocialNetworkIdToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :social_network_id, :string
  end
end
