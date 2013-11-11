class AddDisconnectedToServices < ActiveRecord::Migration
  def change
    add_column :services, :disconnected, :boolean, default: false
  end
end
