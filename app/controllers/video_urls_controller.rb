class VideoUrlsController < ApplicationController
  before_filter :authenticate_user!
  layout 'blendwith'

  skip_before_filter :verify_authenticity_token

  def new
    @video_urls = current_user.video_urls
    @playlist = current_user.video_playlists.where(social_network:  'VideosURL').first_or_create(name: "Videos URL")
    @video_url = VideoUrl.new
  end

  def create
    url, final_url = params[:video_url][:video_url], nil
    if url.include? "youtube.com"
      final_url = url.slice (url.rindex('=')+1)..-1
    elsif url.include? "youtu.be"
      final_url = url.slice (url.rindex('/')+1)..-1
    else
      flash[:error] = "Unsupported"
    end
    if final_url
      @video_url = current_user.video_urls.build(:video_url => final_url)
      @video_url.save
    end
    redirect_to new_video_url_url
  end

  def update
    @video  = VideoUrl.find(params[:id])
    @video.title = params[:caption]
    @video.tag_list = params[:tags]
    @video.save!
    redirect_to :back || playlists_path
  end

  def destroy
    VideoUrl.find(params[:id]).delete
    render :nothing => true
  end

end
