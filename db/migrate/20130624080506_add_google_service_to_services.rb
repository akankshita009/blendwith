class AddGoogleServiceToServices < ActiveRecord::Migration
  def change
    add_column :services, :google_service, :string
  end
end
