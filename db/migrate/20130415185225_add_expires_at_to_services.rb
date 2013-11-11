class AddExpiresAtToServices < ActiveRecord::Migration
  def change
    add_column :services, :expires_at, :datetime
  end
end
