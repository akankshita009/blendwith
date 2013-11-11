require 'google/api_client'
class Youtube

  attr_accessor :access_token
  attr_accessor :youtube
  attr_accessor :favorites_playlist_ids, :uploads_playlist_ids

  def initialize(options={})
    @client ||= client = ::Google::APIClient.new
    @access_token = options[:access_token]
    @client.authorization = nil
    self.youtube = @client.discovered_api('youtube', 'v3')
    @client
  end

  def youtube_response api_method, params
     @client.execute(api_method: api_method, parameters: params, headers: headers)
  end

  def playlist_ids
    parameters = { mine: true, part: 'snippet,contentDetails' }
    response = youtube_response youtube.channels.list, parameters
    @favorites_playlist_ids = response.data.items.map do |item|
      item.contentDetails.relatedPlaylists.favorites
    end
    @uploads_playlist_ids = response.data.items.map do |item|
      item.contentDetails.relatedPlaylists.uploads
    end
  end
  
  [:favorites, :uploads].each do |playlist_name|
    playlist_ids_method_name = "#{playlist_name}_playlist_ids"

    # def favorites_playlist_ids, def uploads_playlist_ids
    define_method playlist_ids_method_name do
      instance_variable_get("@#{playlist_ids_method_name}") || playlist_ids and
        instance_variable_get("@#{playlist_ids_method_name}")
    end

    video_ids_method_name = "#{playlist_name}_video_ids"

    # def favorites_video_ids, def uploads_video_ids
    define_method video_ids_method_name do |max_results = 50, page_token = nil|

      parameters = { playlistId: send(playlist_ids_method_name), 
                     part: 'snippet', maxResults: max_results }
      paramsmeters[:pageToken] = page_token unless page_token.nil?
      response = youtube_response youtube.playlist_items.list, parameters
      return response.data.items.map do |item|
        item.snippet.resourceId.videoId
      end, (response.data.nextPageToken if response.data.respond_to? :nextPageToken)
    end

  end

  def favorites_uploads_playlists
    p parameters = {
      id: [uploads_playlist_ids, favorites_playlist_ids].flatten.compact,
      part: 'snippet'
    }
    response = youtube_response youtube.playlists.list, parameters
  end

  def self.fetch user_id = nil
    user = User.find(user_id || 5)
    service = user.youtube
    service.expired? and  service.refresh_google_token
    client = Youtube.new(access_token: service.access_token) 
    client.all_playlists
  end


  # def favorites_playlist_ids
    # @favorites_playlist_ids || playlist_ids
  # end

  # def uploads_playlist_ids
    # @uploads_playlist_ids || playlist_ids
  # end

#  def favorites_video_ids max_results = 50, page_token = nil 
#    parameters = { playlistId: favorites_playlist_ids, 
#               part: 'snippet', maxResults: max_results }
#    paramsmeters[:pageToken] = page_token unless page_token.nil?
#    response = youtube_response youtube.playlist_items.list, parameters
#    response.data.items.map do |item|
#      item.snippet.resourceId.videoId
#    end
#  end
#
#  def uploads_video_ids max_results = 50, page_token = nil
#    parameters = { playlistId: uploads_playlist_ids, 
#               part: 'snippet', maxResults: max_results }
#    paramsmeters[:pageToken] = page_token unless page_token.nil?
#    response = youtube_response youtube.playlist_items.list, parameters
#    response.data.items.map do |item|
#      item.snippet.resourceId.videoId
#    end
#  end

  alias channel_ids uploads_playlist_ids




  def video_ids maxResults = 50, pageToken = nil
    params = {"playlistId" => channel_ids, "part" => "snippet", "maxResults" => maxResults}
    params["pageToken"] = pageToken if pageToken
    playlist_items = self.get_response(youtube.playlist_items.list, params)
    puts playlist_items
    videos = playlist_items['items'].map do |video|
      video['snippet']['resourceId']['videoId']
    end
    return videos, playlist_items["nextPageToken"]
  end

  
  def get_response(api_method, params)
    response = @client.execute(api_method: api_method, parameters: params, headers: headers)
    JSON.parse(response.body)
  end


  def video_by_id(video_id)
    videos = self.get_response(youtube.videos.list, {part: 'id,snippet,contentDetails', id: video_id})
    videos['items'].detect { |video| video['id'] == video_id } if videos && videos['items']
  end


  def headers
    raise "Access Token is Missing " if access_token.nil?
    {Authorization: "Bearer #{access_token}"}
  end

  ############################
  
  def get_favorite_playlist
    get_response youtube.playlists.list, {part: 'snippet', id: favorites_playlist_ids.compact}
  end

  def all_playlists
    favorite_ones = get_favorite_playlist
    playlists = favorite_ones['items']
    result = get_playlist
    next_page_token = result['nextPageToken']
    playlists += result['items']
    loop do
      break if next_page_token.nil?
      result = get_playlist next_page_token
      next_page_token = result['nextPageToken']
      playlists += result['items']
    end
    playlists
  end

  def get_playlist pageToken = nil
    get_response(youtube.playlists.list, {mine: true, part: 'snippet', maxResults: 50, pageToken: pageToken})
  end

  # get videos of a playlist
  def all_videos_of_one_playlist playlist_id
    result = get_videos playlist_id
    next_page_token = result['nextPageToken']
    videos = result['items']
    loop do
      break if next_page_token.nil?
      result = get_videos(playlist_id, next_page_token)
      next_page_token = result['nextPageToken']
      videos += result['items']
    end
    videos
  end

  def get_videos playlist_id, pageToken = nil
    get_response(youtube.playlist_items.list, {part: 'snippet', playlistId: playlist_id, maxResults: 50, pageToken: pageToken})
  end

end
