class VideoPlaylistsController < ApplicationController

  layout 'blendwith'
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token, :only => [:add_item, :delete_item]

  def index
    @uploaded_videos = current_user.uploaded_videos.limit(12).offset(0)
    @video_urls = current_user.video_urls.limit(12).offset(0)
    @playlists = current_user.video_playlists.where('social_network in (?)', %w(Youtube))
    @playlist = current_user.video_playlists.where(social_network:  'AllVideos').first_or_create(name: "All Videos")
  end

  def show
    if request.fullpath == '/youtube'
    @playlist = current_user.video_playlists.where('social_network in (?)', %w(Youtube)).first
    else
      @playlist = current_user.video_playlists.where(:id => params[:id]).includes(:items => :itemizable).first
    end
  end

  def create
    playlist = current_user.video_playlists.create(params[:video_playlist])
    respond_to do |format|
      format.js
      format.json {render :json => {result: playlist_result(playlist, "video")}}
    end
  end


  def update
  end


  def add_item
    playlist_id, type, object_id = params[:id], params[:type], params[:object_id]
    @playlist = current_user.video_playlists.where(:id => playlist_id).first
    network = params[:network].to_s.inquiry
    if network.youtube? && type == 'video'
      @playlist.add_items_from_youtube_video(object_id)
    elsif network.youtube? && type == 'video_album'
      @playlist.add_items_from_youtube_album(object_id)
    elsif network.uploaded_video?
      @playlist.add_items_from_uploaded_video(object_id)
    elsif network.youtube_url?
      @playlist.add_item_from_youtube_url(object_id)
    end
  end

  def delete_item
    item = Item.find params[:item_id]
    item.itemizable.destroy
    render :nothing => true
  end

end
