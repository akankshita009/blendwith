class AddRefreshTokenToServices < ActiveRecord::Migration
  def change
    add_column :services, :refresh_token, :string
  end
end
