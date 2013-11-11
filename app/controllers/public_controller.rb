class PublicController < ApplicationController

  def index
    if user_signed_in?
      redirect_to '/friend_maps/friends_feed'
      return
    end
  end

  def tour
    render :layout => "tour"
  end
end
