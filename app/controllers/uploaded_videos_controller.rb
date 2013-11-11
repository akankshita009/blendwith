class UploadedVideosController < ApplicationController

  layout 'blendwith'
  skip_before_filter :verify_authenticity_token

  def new
    @videos = current_user.uploaded_videos
    @playlist = current_user.video_playlists.where(social_network:  'MyVideos').first_or_create(name: "My Videos")
  end

  def create
    current_user.uploaded_videos.create(params[:video])
    redirect_to new_uploaded_video_url
  end

  def update
    video = UploadedVideo.find params[:id]
    if params[:caption]
      video.title = params[:caption]
      video.tag_list = params[:tags]
      video.save!
      redirect_to :back || playlists_path
    else
      video.update_attributes(params[:uploaded_video])
      redirect_to new_uploaded_video_url
    end
  end

  def destroy
    UploadedVideo.find(params[:id]).destroy
    render :nothing => true
  end

  def authorize_upload
    payload = JSON.parse(params['payload'])
    upload = Panda.post('/videos/upload.json', {
        file_name: payload['filename'],
        file_size: payload['filesize'],
        profiles: "h264",
    })
    render :json => {:upload_url => upload['location']}
  end
  
end
