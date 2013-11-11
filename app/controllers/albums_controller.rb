class AlbumsController < ApplicationController

  layout 'blendwith'

  skip_before_filter :verify_authenticity_token

  def show
    @playlists = current_user.image_playlists.select("id, name").association_includer
    @album = Album.where(:id => params[:id].to_i).includes([:photos, :tags]).first
    render :dashboard
  end

  def update
    @album = Album.where(:id => params[:id].to_i).first
    @album.name = params[:caption]
    @album.tag_list = params[:tags]
    @album.save(:validate => false)
    redirect_to :back || album_url(@album)
  end
  
  def destroy
    Album.where(:id => params[:id].to_i).first.destroy
    redirect_to :back || playlists_path
  end

  def delete_photo
    photo_album = PhotoAlbum.find params[:photo_album_id]
    photo_album.photo.delete
    photo_album.delete
    render :nothing => true
  end
end
