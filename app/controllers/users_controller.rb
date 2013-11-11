class UsersController < ApplicationController

  layout 'user_edit'

  protect_from_forgery :only => :show

  before_filter :only => [:user_gallery, :ajax_gallery, :user_gallery_album, :player] do
    @user = User.find(params[:user_id])
  end

  before_filter :build_user_for_show, :only => :show
  before_filter :check_privacy_for_show, :only => :show
  before_filter :check_privacy_for_embed, :only => :embed

  before_filter :authorize_user, :only => :edit
  before_filter :must_current_user, :only => :edit


  def build_user_for_show
    if params[:username]
      @user = User.find_by_username params[:username]
      redirect_to root_path and return unless @user
    else
      @user = User.find(params[:id])
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.soft_delete
    redirect_to root_url
  end

  def check_privacy_for_show
    if current_user.nil?
      redirect_to root_path unless (@user.privacy.nil? || @user.privacy == 'Public')
    else
      if @user.privacy == 'Private'
        redirect_to root_path unless current_user.id == @user.id
      end
      if @user.privacy == 'Friends Only'
        redirect_to root_path unless (current_user.id == @user.id || current_user.is_friend_of(@user))
      end
    end
  end

  def check_privacy_for_embed
    @user = User.find_by_player_token(params[:token])
    unless @user
      render :text => 'The player has been removed.'
      return
    end
    if current_user.nil?
      render :text => 'You can not access this player.' unless (@user.privacy.nil? || @user.privacy == 'Public')
    else
      if @user.privacy == 'Private'
        render :text => 'You can not access this player.' unless current_user.id == @user.id
      end
      if @user.privacy == 'Friends Only'
        render :text => 'You can not access this player.' unless (current_user.id == @user.id || current_user.is_friend_of(@user))
      end
    end
  end

  def show
    @image_playlists =  @user.image_playlists.where(:social_network => %w(AllPhotos RecentPhotos MyPhotos URL))
    @playlists = @user.playlists
    @image_lists = @user.image_playlists.where('social_network is null or social_network not in (?)', %w(AllPhotos RecentPhotos MyPhotos URL)).to_a.sort { |x, y| (Playlist::NAME_VALUE_HASH[y.social_network] || 0) <=> (Playlist::NAME_VALUE_HASH[x.social_network] || 0) }
    @video_lists = @user.video_playlists.where('social_network is null or social_network not in (?)', %w(AllVideos RecentVideos MyVideos VideosURL)).to_a.sort { |x, y| (Playlist::NAME_VALUE_HASH[y.social_network] || 0) <=> (Playlist::NAME_VALUE_HASH[x.social_network] || 0) }
    @audio_lists = @user.music_playlists.to_a.sort { |x, y| (Playlist::NAME_VALUE_HASH[y.social_network] || 0) <=> (Playlist::NAME_VALUE_HASH[x.social_network] || 0) }

    @friends = @user.friend_maps.includes(:friend).limit(6).map { |map| map.friend }

    if params[:feed]
      item = FriendFeed.find(params[:feed]).item
      # item may be deleted
      if item
        object = item.itemizable
        if object.class == TrackAlbum
          @media = object.tracks.first
        elsif object.class == VideoAlbum
          @media = object.videos.first
        else
          @media = object
        end

        @playlist_for_setting = item.playlist # photo need
      else
        flash[:notice] = 'The media has been deleted.'
        @media = nil
      end
    else
      @media = nil
    end

    render :layout => "friend"
  end

  # users/:id/comments
  def user_comments
    @user = User.find params[:id]
  end

  def embed
    @image_lists = @user.image_playlists.where('social_network is null or social_network not in (?)', %w(AllPhotos RecentPhotos MyPhotos URL)).to_a.sort { |x, y| (Playlist::NAME_VALUE_HASH[y.social_network] || 0) <=> (Playlist::NAME_VALUE_HASH[x.social_network] || 0) }
    @video_lists = @user.video_playlists.to_a.sort { |x, y| (Playlist::NAME_VALUE_HASH[y.social_network] || 0) <=> (Playlist::NAME_VALUE_HASH[x.social_network] || 0) }
    @audio_lists = @user.music_playlists.to_a.sort { |x, y| (Playlist::NAME_VALUE_HASH[y.social_network] || 0) <=> (Playlist::NAME_VALUE_HASH[x.social_network] || 0) }

    render :layout => nil
  end

  def edit
    @cover_photo = CoverPhoto.new
    @collapse_one_height = 0
    @collapse_seven_height = 0
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes params[:user]
      redirect_to edit_user_url(@user)
    else
      @collapse_seven_height = 0
      @collapse_one_height = 'auto'
      render :edit
    end
  end

  def privacy
    current_user.update_attribute(:privacy, params[:privacy])
    render :nothing => true
  end

  def friend_request
    current_user.update_attribute(:no_need_confirm, params[:no_need_confirm])
    render :nothing => true
  end

  def connect_social_network
    network = params['social_network']
    unless network.in? %w(facebook instagram soundcloud twitter flickr youtube picasa)
      redirect_to root_path
      return
    end
    # if the service exist
    # that must be youtube picasa or facebok
    if service = current_user.try(network.to_sym)
      service.update_attribute :disconnected, false
      # the service expired
      if service.expired?
        if network == 'youtube' || network == 'picasa'
          # refresh token
          service.refresh_google_token
        end
      end
      redirect_to "/#{network}"
    else
      # if the service not exist
      if network == 'youtube' || network == 'picasa'
        session[:google_service] = network
        redirect_to user_omniauth_authorize_url(:google_oauth2)
      else
        redirect_to user_omniauth_authorize_url(network.to_sym)
      end
    end
  end

  def disconnect_social_network
    network = params['social_network']
    social_network = current_user.try(network.to_sym)
    #youtube picasa
    if social_network
      if network.in? %w(youtube picasa)
        social_network.update_attribute :disconnected, true
      else
        social_network.destroy
      end
    end
    render :nothing => true
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to edit_user_url(@user)
    else
      @collapse_one_height = 0
      @collapse_seven_height = 'auto'
      render :edit
    end
  end

  def new_twitter_user
    render :new_twitter_user, :layout => 'application'
  end

  def create_twitter_user
    twitter_user_id = session[:twitter_user_id]
    auth = TwitterUser.find(twitter_user_id).twitter_user
    @user = User.create_from_twitter auth, params[:email], twitter_user_id
    if @user.errors.count == 0
      unless @user.approved
        redirect_to '/users/sign_in', :notice => I18n.t('devise.sessions.user.not_approved')
        return
      end
      # sync social network data
      Service.delay.twitter @user
      sign_in_and_redirect @user, notice: "Signed in!"
    else
      render :new_twitter_user, :layout => 'application'
    end
  end

  def user_gallery
    if params[:playlist_type] == 'video'
      user_gallery_video
    elsif params[:playlist_type] == 'photo'
      user_gallery_photo
    elsif params[:playlist_type] == 'audio'
      user_gallery_audio
    end
  end

  def user_gallery_video
    # for medias in social network playlist, load them all at once, will not load when ajax request
    if params[:playlist_id].in? %w(Recent_Videos All_Videos)
      @playlists = @user.video_playlists.where('social_network in (?)', %w(Youtube))
    end
    if params[:playlist_id].in? %w(Recent_Videos All_Videos Uploaded_Videos)
      @uploaded_videos = @user.uploaded_videos.limit(12).offset(0)
    end
    if params[:playlist_id].in? %w(Recent_Videos All_Videos URL_Videos)
      @video_urls = @user.video_urls.limit(12).offset(0).map { |video| video.video_url }
    end
    # for user created playlist
    unless params[:playlist_id].in? %w(Recent_Videos All_Videos Uploaded_Videos URL_Videos Youtube)
      @items = Playlist.find(params[:playlist_id]).items.limit(12).offset(0)
    end
    render :partial => 'player/user_gallery_new'
  end

  def ajax_gallery_video
    # for medias in social network playlist, load them all at once, will not load when ajax request
    if params[:playlist_id].in? %w(Recent_Videos All_Videos)
      @playlists = []
    end
    if params[:playlist_id].in? %w(Recent_Videos All_Videos Uploaded_Videos)
      @uploaded_videos = @user.uploaded_videos.limit(12).offset(params['offset_value'])
    end
    if params[:playlist_id].in? %w(Recent_Videos All_Videos URL_Videos)
      @video_urls = @user.video_urls.limit(12).offset(params['offset_value']).map { |video| video.video_url }
    end
    # for user created playlist
    unless params[:playlist_id].in? %w(Recent_Videos All_Videos Uploaded_Videos URL_Videos Youtube)
      @items = Playlist.find(params[:playlist_id]).items.limit(12).offset(params['offset_value'])
    end
    render :partial => 'player/items_new/videos'
  end

  def user_gallery_photo
    # for medias in social network playlist, load them all at once, will not load when ajax request
    if params[:playlist_id].in? %w(Recent_Photos All_Photos)
      @playlists = @user.image_playlists.where('social_network in (?)', %w(Facebook Twitter Instagram Flickr Picasa))
    end
    if params[:playlist_id].in? %w(Recent_Photos All_Photos URL_Photos)
      @url_photos = @user.photo_urls.allowed.limit(12).offset(0)
    end
    if params[:playlist_id].in? %w(Recent_Photos All_Photos Uploaded_Photos)
      @uploaded_photos = @user.uploaded_photos.allowed.limit(12).offset(0)
    end
    # for user created playlist
    unless params[:playlist_id].in? %w(Recent_Photos All_Photos URL_Photos Uploaded_Photos)
      playlist = Playlist.find(params[:playlist_id]) 
      @items = playlist.items.allowed.limit(12).offset(0)
    end
    render :partial => 'player/user_gallery_new'
  end

  def user_gallery_album
    @item = Item.find(params[:item_id])
    @photos = @item.itemizable.photos.order('created_at desc')#.limit(12).offset(0)
    render :partial => 'player/album/album_photos'
  end

  def ajax_gallery_photo
    # for medias in social network playlist, load them all at once, will not load when ajax request
    if params[:playlist_id].in? %w(Recent_Photos All_Photos)
      @playlists = []
    end
    if params[:playlist_id].in? %w(Recent_Photos All_Photos URL_Photos)
      @url_photos = @user.photo_urls.limit(12).offset(params['offset_value'])
    end
    if params[:playlist_id].in? %w(Recent_Photos All_Photos Uploaded_Photos)
      @uploaded_photos = @user.uploaded_photos.limit(12).offset(params['offset_value'])
    end
    # for user created playlist
    unless params[:playlist_id].in? %w(Recent_Photos All_Photos URL_Photos Uploaded_Photos)
      @items = Playlist.find(params[:playlist_id]).items.allowed.limit(12).offset(params['offset_value'])
    end
    render :partial => 'player/items_new/photos'
  end

  def user_gallery_audio
    # for medias in social network playlist, load them all at once, will not load when ajax request
    if params[:playlist_id].in? %w(Recent_Music All_Music)
      @playlists = @user.music_playlists.where('social_network in (?)', %w(Soundcloud))
    end
    if params[:playlist_id].in? %w(Recent_Music All_Music URL_Audios)
      @audio_urls = @user.music_urls.limit(12).offset(0)
    end
    if params[:playlist_id].in? %w(Recent_Music All_Music Uploaded_Audios)
      @uploaded_audios = @user.uploaded_audios.limit(12).offset(0)
    end
    # for user created playlist
    unless params[:playlist_id].in? %w(Recent_Music All_Music URL_Audios Uploaded_Audios)
      @items = Playlist.find(params[:playlist_id]).items.limit(12).offset(0)
    end
    render :partial => 'player/user_gallery_new'
  end

  def ajax_gallery_audio
    # for medias in social network playlist, load them all at once, will not load when ajax request
    if params[:playlist_id].in? %w(Recent_Music All_Music)
      @playlists = []
    end
    if params[:playlist_id].in? %w(Recent_Music All_Music URL_Audios)
      @audio_urls = @user.music_urls.limit(12).offset(params['offset_value'])
    end
    if params[:playlist_id].in? %w(Recent_Music All_Music Uploaded_Audios)
      @uploaded_audios = @user.uploaded_audios.limit(12).offset(params['offset_value'])
    end
    # for user created playlist
    unless params[:playlist_id].in? %w(Recent_Music All_Music URL_Audios Uploaded_Audios)
      @items = Playlist.find(params[:playlist_id]).items.limit(12).offset(params['offset_value'])
    end
    render :partial => 'player/items_new/audios'
  end

  def ajax_gallery
    if params[:playlist_id].in? %w(Recent_Photos Recent_Videos Recent_Music)
      render :nothing => true
    elsif params[:playlist_type] == 'video'
      ajax_gallery_video
    elsif params[:playlist_type] == 'photo'
      ajax_gallery_photo
    elsif params[:playlist_type] == 'audio'
      ajax_gallery_audio
    end
  end

  def player
    #if params[:playlist_id].in? ['Twitter', 'Instagram', 'Flickr', 'URL_Photos', 'Uploaded_Photos']
    #  @image_url = params[:item_id]
    #  render :partial => 'player/single/twitter_photo'
    ##elsif params[:playlist_id] == 'Facebook'
    #  facebook_player
    #elsif params[:playlist_id] == 'Picasa'
    #  picasa_player
    #if params[:playlist_id].in? ['URL_Photos', 'Uploaded_Photos']
    #  @image_url = params[:item_id]
    #  render :partial => 'player/single/twitter_photo'
    #els
    if params[:playlist_id] == 'Youtube'
      render :partial => 'player/single/youtube'
    elsif params[:playlist_id] == 'URL_Videos'
      render :partial => 'player/single/youtube'
    elsif params[:playlist_id] == 'Uploaded_Videos'
      @video_url = params[:item_id]
      render :partial => 'player/single/uploaded_video'
    elsif params[:playlist_id] == 'Soundcloud'
      soundcloud_player
    elsif params[:playlist_id] == 'URL_Audios'
      @music_url = MusicUrl.find params[:item_id]
      render :partial => 'player/single/audio_url'
    elsif params[:playlist_id] == 'Uploaded_Audios'
      @upload_audio = UploadedAudio.find params[:item_id]
      render :partial => 'player/single/uploaded_audio'
    elsif params[:playlist_id] == 'photo_playlist'
      playlist_photo_player
    elsif params[:playlist_id] == 'photo_album'
      album_photo_player
    elsif params[:playlist_id] == 'single_photo'
      @image_url = params[:item_id]
      render :partial => 'player/single/twitter_photo'
    else
      # no photo, must be music or video
      render :partial => 'player/single/player'
    end
  end

  # for url photos and uploaded photos
  def playlist_photo_player
    # Recent_Photos
    image_playlist_setting params[:item_id]
    if params[:item_id] == 'All_Photos' || params[:item_id] == 'Recent_Photos'
      uploads = @user.uploaded_photos.allowed.map {|photo| photo.image.url }
      urls = @user.photo_urls.allowed.map {|photo| photo.image_url }
      @image_url = uploads + urls
      @playlists = @user.image_playlists.where('social_network in (?)', %w(Facebook Twitter Instagram Flickr Picasa))
      render :partial => 'player/single/multi_playlist_photo'
    elsif params[:item_id] == 'Uploaded_Photos'
      @image_url = @user.uploaded_photos.allowed.map {|photo| photo.image.url }
      render :partial => 'player/single/twitter_photo'
    elsif params[:item_id] == 'URL_Photos'
      @image_url = @user.photo_urls.allowed.map {|photo| photo.image_url }
      render :partial => 'player/single/twitter_photo'
    else
      @media = ImagePlaylist.find(params[:item_id])
      render :partial => 'player/single/player'
    end
  end

  #
  def album_photo_player
    @media = Item.find(params[:item_id]).itemizable
    @playlist_for_setting = params[:track_id_or_url].nil? ? @media.playlist : Playlist.find(params[:track_id_or_url]) 
    render :partial => 'player/single/player'
  end

  protected

  def soundcloud_player
    soundcloud_media do
      @track = @client.get("/tracks/#{params[:item_id]}", :limit => 12)
      render :partial => 'player/single/soundcloud'
    end
  end

  def soundcloud_media
    if service = @user.soundcloud
      @client = Soundcloud.new(access_token: service.access_token, client_id: CONFIG[:soundcloud][:client_id])
      yield
    else
      render :nothing => true
    end
  end

  def image_playlist_setting playlist_id
    if playlist_id == 'Recent_Photos'
      @playlist_for_setting = @user.image_playlists.where(social_network: 'RecentPhotos').first
    elsif playlist_id == 'All_Photos'
      @playlist_for_setting = @user.image_playlists.where(social_network: 'AllPhotos').first
    elsif playlist_id == 'URL_Photos'
      @playlist_for_setting = @user.image_playlists.where(social_network: 'URL').first
    elsif playlist_id == 'Uploaded_Photos'
      @playlist_for_setting = @user.image_playlists.where(social_network: 'MyPhotos').first
    else
      @playlist_for_setting = Playlist.find(playlist_id)
    end
  end


  def user_logged_in?
    request.env["warden"].user(:user).present?
  end
end
