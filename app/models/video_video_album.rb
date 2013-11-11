class VideoVideoAlbum < ActiveRecord::Base

  belongs_to :video
  belongs_to :video_album

end