class PhotosController < ApplicationController
  
  before_filter :authenticate_user!

  def update
    @photo  = Photo.find(params[:id])
    @photo.caption = params[:caption]
    @photo.tag_list = params[:tags]
    @photo.save
    redirect_to :back || playlists_path
  end
  
  def destroy
    Photo.find(params[:id]).destroy
    redirect_to :back || playlists_path
  end
end
