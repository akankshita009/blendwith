class ImagePlaylistsController < PlaylistsController

  skip_before_filter :verify_authenticity_token, :only => [:image_playlist_by_id, :background_music_list]

  layout 'photo_dried'

  def index
    @playlists = [] || current_user.image_playlists.association_includer
    @image_items = current_user.image_items.includes(:itemizable => [:tags, :content_control]).order("items.created_at DESC")
    @playlist = current_user.image_playlists.where(social_network: 'AllPhotos').first
  end

  def recent
    @playlist = current_user.image_playlists.where(social_network: 'RecentPhotos').first
    @image_items = current_user.image_items.includes(:itemizable => [:tags, :content_control]).limit(20)
  end

  def show
    if request.fullpath.in? %w(/facebook /instagram /googleplus /twitter /flickr)
      network = request.fullpath == '/googleplus' ? 'Picasa' : request.fullpath[1..100].capitalize
      @playlist = current_user.image_playlists.where(social_network: network).first
      @show_feed = false
    else
      @playlist = current_user.image_playlists.where(:id => params[:id]).includes(:items => [:itemizable => :content_control]).first
      @show_feed = true
    end
    @image_items = current_user.image_items.includes(:itemizable => [:tags, :content_control]).where(playlist_id: @playlist.id)
  end

  def create
    playlist = current_user.image_playlists.create(params[:image_playlist])
    respond_to do |format|
      format.js
      format.json {render :json => {result: playlist_result(playlist, "image")}}
    end
  end

  def update
    playlist = ImagePlaylist.find(params[:id])
    if playlist.update_attributes params[:image_playlist]
      redirect_to :back
    else
      #render
    end
  end

  def destroy
    playlist = ImagePlaylist.find(params[:id])
    playlist.items.each {|item| item.itemizable.delete_self if item.itemizable }
    playlist.items.delete_all
    playlist.delete
    redirect_to image_playlists_url
  end

  def image_playlist_by_id
    @playlist_show = current_user.image_playlists.find(params[:id])
    render :json => {html: render_to_string(:partial => '/shared/image_playlist_setting')}
  end

  def background_music_list
    load_all_music
    render :json => {html: render_to_string(:partial => '/shared/image_playlist_setting_music')}
  end

  def add_item
    playlist_id, type, object_id = params[:id], params[:type], params[:object_id]
    playlist = current_user.image_playlists.where(:id => playlist_id).first

    p object = params[:type].classify.constantize.find(object_id)

    network = params[:network].to_s.inquiry
    if network.picasa?
      playlist.add_items_from_picasa(type, object_id)
    elsif network.facebook?
      playlist.add_items_from_facebook(type, object_id)
    elsif network.instagram?
      playlist.add_items_from_instagram(object_id)
    elsif network.twitter?
      playlist.add_item_from_twitter(object_id)
    elsif network.flickr?
      playlist.add_items_from_flickr(type, object_id)
    elsif network.plusurl?
      playlist.add_items_from_url(type, object_id)
    elsif network.upload?
      playlist.add_items_from_upload(type, object_id)
    elsif type == "album"
      playlist.add_items_from_playlist_album(object_id)
    elsif type == "photo"
      playlist.add_items_from_playlist_photo(object_id)
    end
  end

  def delete_media
    item = Item.find params[:item_id]
    item.itemizable.delete_self
    item.delete
    render :nothing => true
  end
end
