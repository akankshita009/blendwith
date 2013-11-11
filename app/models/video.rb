class Video < ActiveRecord::Base
  attr_accessible :private, :title, :network, :video_id, :social_network_id, :image_url

  #serialize :video_object, HashWithIndifferentAccess

  has_one :item, :as => :itemizable, :dependent => :destroy
  has_one :playlist, :through => :item
  has_one :content_control, :as => :itemizable, :dependent => :destroy

  has_one :video_video_album, :dependent => :destroy


  def url
    @url ||= "http://www.youtube.com/watch?v=#{video_id}"
  end

  def image_url
    "http://img.youtube.com/vi/#{video_id}/0.jpg"
  end

  acts_as_taggable

  # youtube and +url are the same
  def build_feed_youtube
    FriendFeed.create_friend_feed playlist.user, title, network, 'video', item, image_url
  end

  def build_feed_upload
    image_url = UploadedVideo.find(video_id).panda_video.encodings["h264"].screenshots[0]
    FriendFeed.create_friend_feed playlist.user, title, network, 'video', item, image_url
  end

  def copy_self_to_create
    Video.create(title: title, video_id: video_id, network: network, social_network_id: social_network_id, image_url: image_url)
  end
end
