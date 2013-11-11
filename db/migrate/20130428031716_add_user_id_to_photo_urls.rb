class AddUserIdToPhotoUrls < ActiveRecord::Migration
  def change
    add_column :photo_urls, :user_id, :integer
  end
end
