require 'rss'
require 'open-uri'

class MusicUrlsController < ApplicationController
  #before_filter :authenticate_user!, :only => :new
  layout 'blendwith'
  protect_from_forgery :only => :new

  def new
    @playlist = current_user.music_playlists.where(social_network: 'URL').first_or_create(name: 'URL Music')
    @music_items = current_user.music_items.association_includer.with_playlist(@playlist)
  end


  def update
    @track  = MusicUrl.find(params[:id])
    @track.title = params[:caption]
    @track.tag_list = params[:tags]
    @track.save
    redirect_to :back || new_music_url_url
  end

  def create
    url = params[:music_url]
    begin
      feed = open(url) { |rss| RSS::Parser.parse(rss) }
    rescue => e
      result, message = "fail", "visit rss error"
    end
    if feed
      @playlist = current_user.music_playlists.where(social_network: 'URL').first_or_create(name: 'URL Music')
      @playlist.create_collection_and_add_item feed
      result, message = "success", "added success"
    end
    render :json => {result: result, message: message}
  end

  def create_all
    url = params[:music_url]
    feed = open(url) { |rss| RSS::Parser.parse(rss) }
    if feed.items.length <= 1
      result, message = "fail", "something wrong"
    else
      @playlist = current_user.music_playlists.where(social_network: 'URL').first_or_create(name: 'URL Music')
      @playlist.create_collection_and_add_item feed
      result, message = "success", "added success"
    end
    render :json => {result: result, message: message}
  end

  def destroy
    url = MusicUrl.find(params[:id])
    url.destroy
    render :nothing => true
  end

end
