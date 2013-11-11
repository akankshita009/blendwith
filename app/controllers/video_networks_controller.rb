class VideoNetworksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_youtube_client, :only => [:youtube]
  layout 'blendwith'

  def youtube
    @video_ids = @client.video_ids[0]
  end

end
