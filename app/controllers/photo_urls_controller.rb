class PhotoUrlsController < ApplicationController

  protect_from_forgery :only => [:new, :create]

  layout 'blendwith'

  def new
    @photo_url = current_user.photo_urls.build
    @playlist = current_user.image_playlists.where(social_network: 'URL').first
    @image_items = current_user.image_items.includes(:itemizable => [:tags, :content_control]).where(playlist_id: @playlist.id)
    render :layout => 'photo_dried'
  end


  def update
    @photo = current_user.photo_urls.where(:id => params[:id]).first
    @photo.caption = params[:caption]
    @photo.tag_list = params[:tags]
    @photo.save
    redirect_to :back || new_photo_url_path
  end

  def create
    photo_url = current_user.photo_urls.build(:image_url => params[:photo_url][:image_url])
    photo_url.save
    redirect_to new_photo_url_path
  end

  def destroy
    PhotoUrl.find(params[:id]).delete
    render :nothing => true
  end
end
