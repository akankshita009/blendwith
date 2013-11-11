class AddSocialNetworkIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :social_network_id, :string
  end
end
