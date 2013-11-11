class AddTitleToMusicUrls < ActiveRecord::Migration
  def change
    add_column :music_urls, :title, :string
  end
end
