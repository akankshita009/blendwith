class PhotoUrl < ActiveRecord::Base
  attr_accessible :image_url
  
  validates :image_url, presence: true
  has_one :content_control, :as => :itemizable, :dependent => :destroy
  
  def self.allowed
  end
  belongs_to :user


  acts_as_taggable

  after_create  :add_to_playlist
  def add_to_playlist
    playlist = user.image_playlists.where(social_network: 'URL').first_or_create(:name => "Photo URL")
    playlist.photo_urls << self
  end
    
end
