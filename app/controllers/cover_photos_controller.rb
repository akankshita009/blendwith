class CoverPhotosController < ApplicationController

  def index
    
  end

  def upload_photos
    if (@cover_photo = current_user.cover_photo)
      result = @cover_photo.update_attributes :cover_photo => params[:cover_photo][:cover_photo]
    else
      @cover_photo = CoverPhoto.new(:cover_photo => params[:cover_photo][:cover_photo])
      @cover_photo.user = current_user
      result = @cover_photo.save
    end
    if result
      render :json => {:id => @cover_photo.id, :image_url => @cover_photo.cover_photo.url.to_s}
    else
      render :json => {:error => true, :messages => @cover_photo.errors.full_messages}
    end
  end
  
end
