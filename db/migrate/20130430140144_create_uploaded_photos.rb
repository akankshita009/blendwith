class CreateUploadedPhotos < ActiveRecord::Migration
  def change
    create_table :uploaded_photos do |t|

      t.timestamps
    end
  end
end
