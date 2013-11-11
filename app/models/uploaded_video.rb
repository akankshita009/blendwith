class UploadedVideo < ActiveRecord::Base
  attr_accessible :panda_video_id, :title, :user_id
  validates_presence_of :panda_video_id
  has_one :content_control, :as => :itemizable, :dependent => :destroy

  acts_as_taggable


  belongs_to :user

  after_destroy { panda_video.delete }

  def panda_video
    @panda_video ||= Panda::Video.find(panda_video_id)
  end

  def encode_success?
    panda_video.encodings["h264"].status == "success"
  end

  def ori_video_url
    panda_video.encodings["h264"].url
  end

  alias url ori_video_url


  def ori_video_img
    panda_video.encodings["h264"].screenshots[0]
  end

  alias image_url ori_video_img

end
