class VideoPlaylist <  Playlist


  with_options :through => :items, :source => :itemizable, :extend => ContentControlLinkedToUser do |assoc|

    assoc.has_many :videos, :source_type => "Video"
    assoc.has_many :video_albums, :source_type => "VideoAlbum"
    assoc.has_many :video_urls, :source_type => "VideoUrl"
    assoc.has_many :uploaded_videos, :source_type => "UploadedVideos"
  end


  #def add_items_from_youtube(object_id)
  #  object = youtube_client.video_by_id(object_id)
  #  title = object['snippet']['title'] if object
  #  video = Video.create(title: title, network: "youtube", video_id: object_id)
  #  self.videos << video
  #  video.build_feed_youtube
  #end

  def add_item_from_youtube_url(object_id)
    video = Video.create(network: "youtube", video_id: object_id)
    self.videos << video
    video.build_feed_youtube
  end

  def add_items_from_youtube_video(object_id)
    video_from = Video.find object_id
    video = video_from.copy_self_to_create
    self.videos << video
    video.build_feed_youtube
  end

  def add_items_from_youtube_album(object_id)
    album_from = VideoAlbum.find object_id
    album = VideoAlbum.create(name: album_from.name, image_url: album_from.image_url, network: album_from.network,
                              social_network_id: album_from.social_network_id)
    album_from.videos.each do |video_from|
      video = video_from.copy_self_to_create
      album.videos << video
    end
    self.video_albums << album
    album.build_feed
  end

  def add_items_from_uploaded_video(object_id)
    object = UploadedVideo.find(object_id)
    title = object.title
    video = Video.create(title: title, network: "uploaded_video", video_id: object_id)
    self.videos << video
    video.build_feed_upload
  end

  private 

  def youtube_client
    service = self.user.picasa
    service.expired? and service.refresh_google_token
    @youtube_client = Youtube.new(access_token: service.access_token) 
  end
end
