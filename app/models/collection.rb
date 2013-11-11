class Collection < ActiveRecord::Base
  attr_accessible :image_url, :network, :social_netowrk_id, :title
  
  has_many :containers, :dependent => :destroy
  has_many :tracks, :through => :containers, :source => :albumize, :source_type => "Track"
  has_many :uploaded_audios, :through => :containers, :source => :albumize, :source_type => "UploadedAudio"

  has_one :item, :as => :itemizable, :dependent => :destroy
  has_one :playlist, :through => :item
  has_one :content_control, :as => :itemizable, :dependent => :destroy


  acts_as_taggable

  def music_url; end



end
