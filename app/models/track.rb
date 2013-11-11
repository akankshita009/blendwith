class Track < ActiveRecord::Base
  attr_accessible :private, :title, :track_object, :network, :audio_url, :social_network_id #, :image_url

  serialize :track_object, HashWithIndifferentAccess

  has_one :item, :as => :itemizable, :dependent => :destroy
  has_one :playlist, :through => :item

  has_one :content_control, :as => :itemizable, :dependent => :destroy

  has_many :containers, :as => :albumize, :dependent => :destroy
  has_many :collections, :through => :containers

  acts_as_taggable

  def build_feed
    FriendFeed.create_friend_feed playlist.user, title, network, 'audio', item
  end

  def music_url
    return audio_url if audio_url?
    "#{track_object[:stream_url]}?client_id=#{CONFIG[:soundcloud][:client_id]}"
  end

  def track_info 
    {
      title: track_object[:title],
      artist: track_object[:user][:username],
      photo: track_object[:user][:avatar_url],
      artwork_url: track_object[:artwork_url],
      waveform_url: track_object[:waveform_url],
      stream: "#{track_object[:stream_url]}?client_id=#{CONFIG[:soundcloud][:client_id]}"
    }
  end 
  
  def image_url
    return track_object[:image_url] if track_object? and network == 'feed'
    track_info[:artwork_url] || track_info[:waveform_url] ||
      "https://a1.sndcdn.com/images/default_avatar_large.png?3eddc42" rescue "https://a1.sndcdn.com/images/default_avatar_large.png?3eddc42"
  end
  

  #def image_url
  #  if track_object?
  #    track_object[:user][:avatar_url] || ""
  #  else
  #    "https://a1.sndcdn.com/images/default_avatar_large.png?3eddc42"
  #  end
  #end

end
