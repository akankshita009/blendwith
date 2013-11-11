class PlaylistsController < ApplicationController

  before_filter :authenticate_user!
  # before_filter :set_graph, :except => [:create, :add_item, :index, :show]
  skip_before_filter :verify_authenticity_token, :except => [:create]

  layout 'blendwith'

  def update
    Playlist.find(params[:id]).update_attribute :name, params[:name]
    render :nothing => true
  end

  def destroy
    Playlist.find(params[:id]).destroy
    render :nothing => true
  end

  def toggle_feed
    playlist = Playlist.find params[:id]
    playlist.update_attribute :set_feed, !playlist.set_feed
    render :nothing => true
  end

end
