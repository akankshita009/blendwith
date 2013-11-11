class TracksController < ApplicationController

  def update
    @track  = Track.find(params[:id])
    @track.title = params[:caption]
    @track.tag_list = params[:tags]
    @track.save
    redirect_to :back || tracks_path
  end
end
