class UploadedPhotosController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => ['destroy']

  def index
    
  end
  
  def upload_photos
    @uploaded_photo = current_user.uploaded_photos.build(:image => params[:uploaded_photo][:image])
    if @uploaded_photo.save!
      render :json => {:id => @uploaded_photo.id, :image_url => @uploaded_photo.image.url(:thumb).to_s}
    end      
  end

  def destroy
    photo = UploadedPhoto.find(params[:id])
    photo.image.destroy
    photo.delete
    render :nothing => true
  end
  
end
