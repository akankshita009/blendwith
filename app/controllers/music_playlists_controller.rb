class MusicPlaylistsController < PlaylistsController

  # before_filter :authenticate_user!

  layout 'blendwith'

  def index
    load_all_music
    
    @tracks_soundclouds = []

    if current_user.soundcloud
      @tracks = current_user.music_playlists.where(:social_network => "Soundcloud").first.tracks
      @tracks.any? { |track| track.track_object.nil? } and update_track
      @music_items = current_user.music_items.association_includer
      @playlist = current_user.music_playlists.where(social_network: 'AllMusic').first_or_create(name: 'All Music')
      @tracks_soundclouds = @tracks.map(&:track_info)
    end
  end

  def update_tracks
    client = Soundcloud.new(access_token: current_user.soundcloud.access_token, client_id: CONFIG[:soundcloud][:client_id])
    tracks = Service.soundcloud_helper client, '/me/tracks' # fetch tracks
    tracks.each do |track|
      track_soundcloud = Track.where(:network => "soundcloud", :social_network_id => id).first
      track_soundcloud.update_attribute(:track_object, HashWithIndifferentAccess.new(track))
    end
  end

  

  def show
    if request.fullpath.in? %w(/soundcloud)
      @playlists = current_user.music_playlists.where(social_network: 'Soundcloud')
    else
      @playlists = current_user.music_playlists.where(:id => params[:id]).includes(:items => :itemizable)
    end
    @playlist = @playlists.first
    @music_items = current_user.music_items.association_includer.with_playlist(@playlist)
    render :index
  end

  def create
    playlist = current_user.music_playlists.create(params[:music_playlist])
    respond_to do |format|
      format.js {render :json => {result: playlist_result(playlist, "music")}}
    end
  end


  def update
  end


  def add_item
    playlist_id, type, object_id = params[:id], params[:type], params[:object_id]
    @playlist = current_user.music_playlists.where(:id => playlist_id).first
    network = params[:network].to_s.inquiry
    # for soundcloud track, it doesnt have a item_id, because it maybe in album
    if network.soundcloud? && type == 'track'
      @playlist.add_items_from_soundcloud_track(object_id)
    elsif network.soundcloud? && type == 'track_album'
      @playlist.add_items_from_soundcloud_album(object_id)
    elsif network.url?
      @playlist.add_items_from_url(object_id)
    elsif network.upload?
      @playlist.add_items_from_upload(object_id)
    end
  end

  def delete_item
    item = Item.find params[:item_id]
    item.itemizable.destroy
    render :nothing => true
  end
  
  def update_track
    @track = current_user.playlists.where(:id => params[:id]).first.tracks.where(:id => params[:track_id]).first
    @track.caption = params[:caption]
    @track.tag_list = params[:tags]
    @track.save
    redirect_to :back || uploader_url
  end

end
