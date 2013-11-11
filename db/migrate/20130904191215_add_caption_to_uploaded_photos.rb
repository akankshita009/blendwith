class AddCaptionToUploadedPhotos < ActiveRecord::Migration
  def change
    add_column :uploaded_photos, :caption, :string, :default => ""
  end
end
