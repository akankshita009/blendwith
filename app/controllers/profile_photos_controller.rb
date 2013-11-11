class ProfilePhotosController < ApplicationController

  def index
    
  end

  def upload_photos
    if (@profile_photo = current_user.profile_photo)
      result = @profile_photo.update_attributes :profile_photo => params[:profile_photo][:profile_photo]
    else
      @profile_photo = ProfilePhoto.new(:profile_photo => params[:profile_photo][:profile_photo])
      @profile_photo.user = current_user
      result = @profile_photo.save
    end
    if result
      render :json => {:id => @profile_photo.id, :image_url => @profile_photo.profile_photo.url.to_s}
    else
      render :json => {:error => true, :messages => @profile_photo.errors.full_messages}
    end
  end
  
end
