class AddUserIdToVideoUrls < ActiveRecord::Migration
  def change
    add_column :video_urls, :user_id, :integer
  end
end
