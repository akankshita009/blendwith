class VideoAlbum < ActiveRecord::Base
  attr_accessible :image_url, :name, :network, :social_network_id

  acts_as_taggable

  has_one :item, :as => :itemizable, :dependent => :destroy
  has_one :playlist, :through => :item
  has_one :content_control, :as => :itemizable, :dependent => :destroy

  has_many :video_video_albums, :dependent => :destroy
  has_many :videos, :through => :video_video_albums, :dependent => :destroy

  def to_param
    if name
      "#{id}-#{name.parameterize}"
    else
      id
    end
  end

  def build_feed
    FriendFeed.create_friend_feed playlist.user, name, network, 'video_album', item, image_url
  end

end
