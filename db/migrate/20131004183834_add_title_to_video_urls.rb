class AddTitleToVideoUrls < ActiveRecord::Migration
  def change
    add_column :video_urls, :title, :string
  end
end
