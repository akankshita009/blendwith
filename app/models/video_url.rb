class VideoUrl < ActiveRecord::Base
  attr_accessible :video_url
  has_one :content_control, :as => :itemizable, :dependent => :destroy

  default_scope order("created_at desc")

  acts_as_taggable


  def url
    video_url
  end

  def image_url
    "http://img.youtube.com/vi/#{video_url}/0.jpg"
  end

end
