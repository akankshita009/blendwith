class AddNetworkToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :network, :string
  end
end
