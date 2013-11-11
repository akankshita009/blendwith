class VideosController < ApplicationController




  def update
    @video  = Video.find(params[:id])
    @video.title = params[:caption]
    @video.tag_list = params[:tags]
    @video.save!
    redirect_to :back || playlists_path
  end




  def preview
    klass = params[:network].try(:classify)
    klass = "Video" if klass.eql?("Youtube")
    klass = "VideoUrl" if klass.eql?("YoutubeUrl")
    @video = Kernel.const_get(klass).find(params[:id])
  end

end
