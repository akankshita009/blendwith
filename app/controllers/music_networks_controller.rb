class MusicNetworksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_soundcloud_client, :only => [:soundcloud]
  layout 'blendwith'

  # default limit is 50
  def soundcloud
    @tracks = @client.get('/me/tracks', :limit => 200) + @client.get('/me/favorites', :limit => 200)
    @client.get('/me/followings', :limit => 200).each do |user|
      @tracks += @client.get("/users/#{user.id}/tracks", :limit => 200)
    end
  end
end
