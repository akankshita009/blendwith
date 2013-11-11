class CollectionsController < ApplicationController

  protect_from_forgery :only => :none

  before_filter :authenticate_user!
  layout 'blendwith'

  def show
    @collection = Collection.find params[:id]
    @playlist = @collection.playlist
    @music_items = Item.where(playlist_id: @playlist.id, itemizable_type: 'Track', itemizable_id: @collection.track_ids)
    @collection_items = @collection.containers
  end

  def update
    @track  = Collection.find(params[:id])
    @track.title = params[:caption]
    @track.tag_list = params[:tags]
    @track.save
    redirect_to :back || collection_url(@track)
  end

end
