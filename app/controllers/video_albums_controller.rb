class VideoAlbumsController < ApplicationController

  layout 'blendwith'

  before_filter :authorize_user

  skip_before_filter :verify_authenticity_token, :only => :delete_video

  def show
    @video_album = VideoAlbum.find(params[:id].to_i)
    @playlist = current_user.video_playlists.where(social_network: "Youtube").first
  end

  def delete_video
    video = Video.find params[:video_id]
    video.destroy
    render :nothing => true
  end

end
