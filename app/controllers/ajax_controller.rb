class AjaxController < ApplicationController

  before_filter :authenticate_user!
  before_filter :set_soundcloud_client, :only => [:soundcloud_embed]


  def soundcloud_embed
    track_url = params[:track_url]
    @embed_info = @client.get('/oembed', url: track_url, auto_play: true)
    respond_to(&:js)
  end


  # def feed_item_toggler
  #   @feed = current_user.friend_feeds.where(item_id: params[:item_id]).first
  #   @feed.toggle!(:private)
  #   respond_to(&:js)
  # end


  def feed_item_toggler
    conditions = { itemizable_id: params[:item_id], itemizable_type: params[:item_type] }
    @feed = current_user.content_controls.where(conditions).first_or_initialize
    @feed.persisted? ? @feed.destroy : @feed.save!
    respond_to(&:js)
  end

  def change_playlist_cover_from_media
    @playlist = current_user.playlists.where(id: params[:playlist_id]).first
    if params[:item_type].present?
      @media = Kernel.const_get(params[:item_type]).where(id: params[:item_id]).first
      if @media.respond_to? :image_url
        url = @media.image_url
      elsif @media.instance_of?(UploadedPhoto)
        url = @media.image.url
      end
    else
      @item = @playlist.items.where(id: params[:item_id]).first
      if @item.nil?
        @original_playlist = current_user.playlists.where(id: params[:original_playlist_id]).first
        @item = @original_playlist.items.where(id: params[:item_id]).first
      end
      @media = @item.itemizable
      url = @media.image_url
    end
    @playlist.cover_image_from( url, @media)  unless url.nil?
  end

=begin
  def feed_item_toggler
    item_id = params[:item_id]
    item = Item.where(:id => item_id).includes(:itemizable).first
    itemizable = item.itemizable
    type = itemizable.class.name.downcase

    attributes = { first_name: current_user.first_name,
      last_name: current_user.last_name, network: itemizable.network,
      media_type: type, image_url: itemizable.image_url, title: itemizable.caption }

    feed = current_user.friend_feeds.where(item_id: item_id).first_or_initialize(attributes)
    feed.persisted? ? feed.destroy : feed.save!
    render :json => {destroyed: feed.frozen?}
  end
=end
end
