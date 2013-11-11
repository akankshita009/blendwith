class MusicUrl < ActiveRecord::Base
  attr_accessible :music_url, :title


  acts_as_taggable
  belongs_to :user

  default_scope order("created_at desc")

  has_one :item, :as => :itemizable, :dependent => :destroy
  has_one :playlist, :through => :item
  has_one :content_control, :as => :itemizable, :dependent => :destroy

  def image_url
    "https://a1.sndcdn.com/images/default_avatar_large.png?3eddc42"
  end

  after_create  :add_to_playlist
  def add_to_playlist
    playlist = user.music_playlists.where(social_network: 'URL').first_or_create(:name => "Music URL")
    playlist.music_urls << self
  end

end
