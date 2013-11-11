class Photo < ActiveRecord::Base
  attr_accessible :caption, :image_url, :private, :network, :social_network_id

  has_one :item, :as => :itemizable, :dependent => :destroy
  has_one :playlist, :through => :item

  has_one :content_control, :as => :itemizable, :dependent => :destroy

  #has_many :photo_albums, :dependent => :destroy
  #has_many :albums, :through => :photo_albums
  has_one :photo_album, :dependent => :destroy
  has_one :album, :through => :photo_album

  acts_as_taggable

  def build_feed
    FriendFeed.create_friend_feed playlist.user, caption, network, 'photo', item, image_url
  end

  def delete_self
    self.delete
  end
end
