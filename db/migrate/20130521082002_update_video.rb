class UpdateVideo < ActiveRecord::Migration
  def change
    remove_column :videos, :video_object
    add_column :videos, :network, :string
    add_column :videos, :video_id, :string
  end
end
