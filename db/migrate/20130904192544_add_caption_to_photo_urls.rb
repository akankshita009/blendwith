class AddCaptionToPhotoUrls < ActiveRecord::Migration
  def change
    add_column :photo_urls, :caption, :string, :default => ""
  end
end
