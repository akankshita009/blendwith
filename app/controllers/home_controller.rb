class HomeController < ApplicationController

  before_filter :authenticate_user!, :find_playlists, except: [:playlist_box_session, :social_login]
  before_filter :set_soundcloud_client, :only => [:soundcloud]
  protect_from_forgery except: :playlist_box_session

  layout 'blendwith'



  def dashboard
    if params[:playlist_id]
      @playlists = current_user.image_playlists.where(:id => params[:playlist_id]).includes(:items => { :itemizable => :tags})
    else
      @playlists = current_user.image_playlists.includes(:items => { :itemizable => :tags})
    end
  end

  def playlist_box_session
    if params["media_type"].in? %w(image_box video_box music_box)
      session[params["media_type"]] = true
    end
    render :nothing => true
  end

  def social_login
    if current_user.try(params[:social])
      redirect_to request.referrer
    else
      redirect_to user_omniauth_authorize_url(params[:social])
    end
  end

end
