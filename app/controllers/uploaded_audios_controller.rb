class UploadedAudiosController < ApplicationController

  layout 'blendwith'
  skip_before_filter :verify_authenticity_token

  def new
    @audios = current_user.uploaded_audios
    @playlist = current_user.music_playlists.where(social_network: 'Upload').first_or_create(name: 'Uploaded Music')
    @music_items = current_user.music_items.association_includer.with_playlist(@playlist)
  end

  def create
    audio = current_user.uploaded_audios.create(params[:audio])
    MetaWorker.perform_async(audio.id)
    redirect_to new_uploaded_audio_url
  end

  def update
    @track = UploadedAudio.find params[:id]
    if params[:tags]
      @track.title = params[:caption]
      @track.tag_list = params[:tags]
      @track.save
      redirect_to :back || new_uploaded_audio_url
    else
      @audio.update_attributes(params[:uploaded_audio])
      redirect_to new_uploaded_audio_url
    end
  end

  def destroy
    UploadedAudio.find(params[:id]).destroy
    render :nothing => true
  end

  def authorize_upload
    payload = JSON.parse(params['payload'])
    upload = Panda.post('/videos/upload.json', {
        file_name: payload['filename'],
        file_size: payload['filesize'],
        profiles: "mp3",
    })
    render :json => {:upload_url => upload['location']}
  end
  
end
