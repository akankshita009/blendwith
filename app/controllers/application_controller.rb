class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  protected 

  def set_twitter_client
    if service = current_user.twitter
      cred = service.data[:credentials]
      @client = Twitter::Client.new(oauth_token: cred[:token], oauth_token_secret: cred[:secret])
    else
      redirect_to user_omniauth_authorize_url(:twitter)
    end
  end

  def set_youtube_client
    #puts "&&&&&&&:#{user_omniauth_authorize_url(:google_oauth2)}"
    session[:google_service] = 'youtube'
    if service = current_user.youtube
      service.expired? and (service.refresh_google_token or (redirect_to user_omniauth_authorize_url(:google_oauth2) and return))
      access_token = service.access_token
      @client = Youtube.new(access_token: access_token)
    else
      redirect_to user_omniauth_authorize_url(:google_oauth2)
    end
  end

  def set_google_client
    session[:google_service] = 'picasa'
    if service = current_user.picasa
      service.expired? and (service.refresh_google_token or (redirect_to user_omniauth_authorize_url(:google_oauth2) and return))
      email = service.data[:info][:email]
      access_token = service.access_token
      @client = Picasa::Client.new(user_id: email, authorization_header: "Bearer #{access_token}")
    else
      redirect_to user_omniauth_authorize_url(:google_oauth2)
    end
  end

  def set_soundcloud_client
    if service = current_user.soundcloud
      @client = Soundcloud.new(access_token: service.access_token, client_id:  CONFIG[:soundcloud][:client_id])
    else 
      redirect_to user_omniauth_authorize_url(:soundcloud)
    end
  end

  def set_flickr_client
    if @service = current_user.flickr
      cred = @service.data[:credentials]
      @client =  FlickRaw::Flickr.new
      @client.access_token = cred[:token]
      @client.access_secret = cred[:secret]
      @client
    else
      redirect_to user_omniauth_authorize_url(:flickr)
    end
  end

  def set_client
    if access_token = current_user.instagram.try(:access_token)
      @client = Instagram.client(access_token: access_token)
    else
      redirect_to user_omniauth_authorize_url(:instagram)
    end
  end

  def set_graph
    if access_token = current_user.facebook.try(:access_token)
      @graph = Koala::Facebook::API.new(access_token)
    else
      redirect_to user_omniauth_authorize_url(:facebook)
    end
  end

  def playlist_result playlist, media_type
    %(
    <li class="playlist-user-add ui-droppable" data-id="#{playlist.id}">
    <a href="/#{media_type}_playlists/#{playlist.to_param}" data-id="#{playlist.id}">#{playlist.name}</a>
        <a href="#" class="playlist-setting" style="display: none;"></a>
    </li>
    )
  end

  def photos_from(tweets)
    photos = tweets.map do |tweet|
      if media = tweet.attrs[:entities][:media] and media.any? { |media| media[:type] === 'photo' }
        [tweet.id, tweet.attrs[:entities][:media] ]
      end
    end.compact
    Hash[photos]
  end

  def authorize_user
    unless user_signed_in?
      redirect_to :root, :alert => "You are not authorized to view this page"
    end
  end

  def must_current_user
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      redirect_to :root, :alert => "You are not authorized to view this page"
    end
  end

  def load_all_music
    @playlists, @audio_urls, @uploaded_audios = MusicPlaylist.music_for_first_page(current_user)
  end

end
