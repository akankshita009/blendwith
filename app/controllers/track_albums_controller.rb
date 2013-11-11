class TrackAlbumsController < ApplicationController

  layout 'blendwith'

  before_filter :authorize_user

  skip_before_filter :verify_authenticity_token, :only => :delete_track

  def show
    @track_album = TrackAlbum.find(params[:id].to_i)
  end

  def delete_track
    track = Track.find params[:track_id]
    track.destroy
    render :nothing => true
  end

end
