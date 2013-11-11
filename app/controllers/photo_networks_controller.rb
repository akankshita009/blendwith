class PhotoNetworksController < ApplicationController

  before_filter :set_graph, :only => [:facebook]
  before_filter :set_client, :only => [:instagram]
  before_filter :set_google_client, :only => [:picasa]
  before_filter :set_twitter_client, :only => [:twitter]
  before_filter :set_flickr_client, :only => [:flickr]

  layout 'blendwith'



  def dashboard
    if params[:playlist_id]
      @playlists = current_user.image_playlists.where(:id => params[:playlist_id]).includes(:items => { :itemizable => :tags})
    else
      @playlists = current_user.image_playlists.includes(:items => { :itemizable => :tags})
    end
  end


  def flickr
    @photos = @client.photos.search(user_id: @service.uid, :extras => "url_sq, url_t, url_s, url_q, url_m, url_n, url_z, url_c, url_l, url_o")
  end


  def twitter
    tweets = @client.user_timeline(:trim_user => true, :count => 200)
    @photos = photos_from(tweets)
  end

  def instagram
    @photos = @client.user_recent_media
  end

  def picasa
    if params[:album_id]
      @photos = @client.album.show(params[:album_id]).photos
    else
      @albums = @client.album.list.albums
    end
  end

  def facebook
    if params[:album_id]
      @photos = @graph.get_connections(params[:album_id], "photos", :fields => "id, source, name")
    elsif params[:photo_id]
      @photo = @graph.get_object(params[:photo_id])
    else
      @albums = @graph.get_connections('me', 'albums', :fields => "photos.limit(1).fields(id,picture)")
    end
  end
  
  def uploader
    @upload_photo = UploadedPhoto.new
    @uploaded_photos = current_user.uploaded_photos
    @playlist_show = current_user.image_playlists.where(social_network: 'MyPhotos').first
  end

  def update_uploader
    @photo = current_user.uploaded_photos.where(:id => params[:id]).first
    @photo.caption = params[:caption]
    @photo.tag_list = params[:tags]
    @photo.save
    redirect_to :back || uploader_url
  end


  private

  def  find_playlists
    @playlists ||= current_user.image_playlists.order(:name)
  end
end
