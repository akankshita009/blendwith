class FriendFeed < ActiveRecord::Base

  attr_accessible :user_id, :first_name, :last_name, :title, :network, :media_type, :image_url, :item_id

  belongs_to :item
  belongs_to :user

  # media: photo, album, video, music
  def self.create_friend_feed user, title, network, media_type, item, img_url = nil
    FriendFeed.create(user_id: user.id, first_name: user.first_name, last_name: user.last_name,
                      title: title, network: network, media_type: media_type, item_id: item.id, image_url: img_url)
  end
end
