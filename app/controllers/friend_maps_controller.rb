class FriendMapsController < ApplicationController

  layout 'friend'

  before_filter :authenticate_user!

  protect_from_forgery :only => :index

  def index
    name = "%#{params[:name]}%"
    @search_users = User.where("first_name ilike ? or last_name ilike ?", name, name).order("first_name").page params[:page]
    respond_to do |format|
      format.html do
        @pending_count = FriendMap.where(user_id: current_user.id, is_confirmed: false).count
        @friend_count = FriendMap.where(user_id: current_user.id, is_confirmed: true).count
        @request_count = FriendMap.where(friend_id: current_user.id, is_confirmed: false).count
      end
      format.js
    end
  end

  def pending_friends
    @pending_friends = FriendMap.where(user_id: current_user.id, is_confirmed: false).page(params[:page])#.map {|friend| friend.friend }
  end

  def friends
    @friends = FriendMap.where(user_id: current_user.id, is_confirmed: true).page(params[:page])#.map {|friend| friend.friend }
  end

  def request_friends
    @request_friends = FriendMap.where(friend_id: current_user.id, is_confirmed: false).page(params[:page])#.map {|friend| friend.user }
  end

  def add_friend
    render :json => {result: current_user.add_friend(params[:friend_id])}
  end

  def agree_request
    render :json => {result: current_user.agree_request(params[:user_id])}
  end

  def friend_profile
    @user = User.find(params[:id])
  end

  def friends_feed
    @photourls = current_user.photo_urls #to check if user are added image url
    if !session[:tour].eql?(false)
      session[:tour] = true if @photourls.count.eql?(0)
    end
    logger.debug conditions = { user_id: FriendMap.where(user_id:  current_user.id).pluck(:friend_id) }

    @friend_feeds = FriendFeed.includes(:item => [:itemizable => :content_control]).where(conditions).
      order("created_at DESC").limit(20).offset(params[:page].to_i*20 || 0)
    respond_to do |format|
      format.html
      format.json { render json: {html: render_to_string(:partial => '/friend_maps/feed_partial', :formats => [:html])} }
    end
  end

  #def my_friends
  #  @friend_confirms = current_user.friend_wait_confirm
  #  @friends = current_user.friends
  #  render :json => {:html => render_to_string(:partial => "/friend_maps/my_friends", :format => [:html])}
  #end
  #
  #def invite_friends
  #  if current_user.profile
  #    user_name = "#{current_user.profile.first_name} #{current_user.profile.last_name}"
  #  else
  #    user_name = current_user.name
  #  end
  #  FriendMailer.invite_friend(user_name, params[:email]).deliver
  #  render :json => {:result => "OK"}
  #end
  #
  #def destroy_friend
  #  map = FriendMap.where(:user_id => current_user.id, :friend_id => params[:friend_id], :is_confirmed => true).first
  #  if map
  #    map.destroy
  #  end
  #  render :nothing => true
  #end
  #
  #def view_friend_profile
  #  @profile = Profile.find_by_user_id(params[:id])
  #  @friend_cv_page = true
  #  render :view_friend_profile, :layout => false
  #end
  
  def update_tour
    session[:tour] = false
    render :nothing => true
  end

end
