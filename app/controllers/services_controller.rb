class ServicesController < ApplicationController

  before_filter :authenticate_user!, :only => :instagram

  def facebook
    auth = request.env['omniauth.auth']
    if current_user
      current_user.add_or_update_social_service_from_omniauth(auth)
      # sync social network data, just for facebook, because the user has already been login
      Service.delay.facebook current_user
      redirect_to facebook_url
    else
      user = User.find_or_create_from_omniauth(auth)
      if user.nil?
        redirect_to '/users/sign_in', :notice => I18n.t('devise.sessions.user.deleted')
        return
      elsif not user.approved?
        redirect_to '/users/sign_in', :notice => I18n.t('devise.sessions.user.not_approved')
        return
      end
      # sync social network data, for all social network, because the facebook account is for log into our app now
      SocialWorker.perform_async user.id
      # refresh google token
      RefreshOauthWorker.perform_async user.id
      sign_in_and_redirect user, notice: "Signed in!"
    end
  end

  def twitter
    auth = request.env['omniauth.auth']
    if current_user
      current_user.add_or_update_social_service_from_omniauth(auth)
      # sync social network data, just for twitter
      Service.delay.twitter current_user
      redirect_to twitter_url
    else
      user = User.find_by_provider_and_uid(auth[:provider], auth[:uid])
      if user
        user.add_or_update_social_service_from_omniauth(auth)
        unless user.approved
          redirect_to '/users/sign_in', :notice => I18n.t('devise.sessions.user.not_approved')
          return
        end
        # sync social network data, for all social network
        SocialWorker.perform_async user.id
        # refresh google token
        RefreshOauthWorker.perform_async user.id
        sign_in_and_redirect user, notice: "Signed in!"
      else
        if User.unscoped.find_by_provider_and_uid(auth[:provider], auth[:uid]).present?
          redirect_to '/users/sign_in', :notice => I18n.t('devise.sessions.user.deleted')
          return
        end
        twitter_user = TwitterUser.create(:twitter_user => auth)
        session[:twitter_user_id] = twitter_user.id
        redirect_to new_twitter_user_users_url
      end
    end
  end

  # The following social networks are not used for login

  def flickr
    auth = request.env['omniauth.auth']
    current_user.add_or_update_social_service_from_omniauth(auth)
    # sync social network data
    Service.delay.flickr current_user
    redirect_to flickr_url
  end

  def soundcloud
    auth = request.env['omniauth.auth']
    current_user.add_or_update_social_service_from_omniauth(auth)
    # sync social network data
    Service.delay.soundcloud current_user
    redirect_to soundcloud_url
  end

  # check if the response have refresh token
  # if there are refresh token, just save it
  # otherwise fetch the refresh token of youtube/G+
  def google_oauth2
    auth = request.env['omniauth.auth']
    current_user.add_or_update_social_service_from_omniauth(auth, session[:google_service])
    service = session[:google_service]
    # sync social network data
    Service.delay.try(service, current_user)
    redirect_to "/#{service}"
  end

  def  instagram
    auth = request.env['omniauth.auth']
    current_user.add_or_update_social_service_from_omniauth(auth)
    # sync social network data
    Service.delay.instagram current_user
    redirect_to instagram_url
  end

  def failure
    render :text => request.env['omniauth.auth'].to_yaml
  end
end
