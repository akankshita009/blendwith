class AddUserIdToUploadedPhotos < ActiveRecord::Migration
  def change
    add_column :uploaded_photos, :user_id, :integer
  end
end
