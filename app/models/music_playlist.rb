class MusicPlaylist < Playlist
    

  with_options :through => :items, :source => :itemizable, :extend => ContentControlLinkedToUser do |assoc|

    assoc.has_many :tracks, :source_type => "Track"
    assoc.has_many :collections, :source_type => "Collection"
    assoc.has_many :music_urls, :source_type => "MusicUrl"
    assoc.has_many :uploaded_audios, :source_type => "UploadedAudio"

  end

  def create_collection_and_add_item feed
    collection_image = feed.image
    collection = self.collections.create(title: collection_image.title, image_url: collection_image.url)
    feed.items.each do |item|
      parameters = {
        title: item.title,
        audio_url: item.enclosure.url,
        track_object: HashWithIndifferentAccess.new(image_url: collection_image.url),
        network: 'feed'
      }
      collection.tracks.create(parameters)
    end
  end


  class << self

    def music_for_first_page user
      playlists = user.music_playlists.where('social_network in (?)', %w(Soundcloud))
      audio_urls = user.music_urls.offset(0)
      uploaded_audios = user.uploaded_audios.offset(0)
      return playlists, audio_urls, uploaded_audios
    end

  end

  def update_soundcloud_tracks user
    client = Soundcloud.new(access_token: user.soundcloud.access_token, client_id: CONFIG[:soundcloud][:client_id])
    tracks = Service.soundcloud_helper client, '/me/tracks' # fetch tracks
    tracks.each do |track|
      split_url = track["stream_url"].split("/")
      id = split_url[split_url.count-2]
      if track_soundcloud = Track.where(:network => "soundcloud", :social_network_id => id).first
        track_soundcloud.update_attributes( :track_object => HashWithIndifferentAccess.new(track),
          :audio_url => track['download_url'])
      else
        self.tracks.create(:network => "soundcloud", :social_network_id => id, 
          :title => track["title"], :track_object => HashWithIndifferentAccess.new(track),
          :audio_url => track['download_url'])
      end
    end
  end


  #def add_items_from_soundcloud(object_id)
  #  object = soundcloud_client.get("/tracks/#{object_id}")
  #  track = Track.create(title: object['title'], track_object: HashWithIndifferentAccess.new(object), network: 'soundcloud')
  #  self.tracks << track
  #  track.build_feed
  #end
  #
  #def add_items_from_item(object_id)
  #  object = Item.find(object_id).itemizable
  #  if object.class == Track
  #    add_items_from_soundcloud_track(object)
  #  elsif object.class == TrackAlbum
  #    add_items_from_soundcloud_album(object)
  #  end
  #end
  
  def add_items_from_soundcloud_track(track_id)
    track_from = Track.find track_id
    track = Track.create(title: track_from.title, track_object: track_from.track_object, private: track_from.private,
                         network: track_from.network, audio_url: track_from.audio_url, social_network_id: track_from.social_network_id)
    self.tracks << track
    track.build_feed
  end

  # note the parameter is item_id
  def add_items_from_soundcloud_album(item_id)
    album_from = Item.find(item_id).itemizable
    # add track album
    album = TrackAlbum.create(name: album_from.name, image_url: album_from.image_url, network: album_from.network, social_network_id: album_from.social_network_id)
    self.track_albums << album
    # add tracks
    album_from.tracks.each do |track_from|
      track = Track.create(title: track_from.title, track_object: track_from.track_object, private: track_from.private,
                           network: track_from.network, audio_url: track_from.audio_url, social_network_id: track_from.social_network_id)
      album.tracks << track
    end
    # feed
    album.build_feed
  end

  def add_items_from_url(object_id)
    music_url = MusicUrl.find(object_id)
    track = Track.create(title: music_url.title, audio_url: music_url.music_url, network: 'url')
    self.tracks << track
    track.build_feed
  end

  def add_items_from_upload(object_id)
    track = Track.create(title: object_id['title'], audio_url: object_id['music_url'], network: 'upload')
    self.tracks << track
    track.build_feed
  end

  private

  def soundcloud_client
    service = self.user.soundcloud
    @soundcloud_clinet ||= Soundcloud.new(access_token: service.access_token)
  end

end
