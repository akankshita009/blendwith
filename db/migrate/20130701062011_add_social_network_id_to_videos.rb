class AddSocialNetworkIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :social_network_id, :string
  end
end
