class Service < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid, :access_token, :expires_at, :data
  serialize :data, HashWithIndifferentAccess


  def refresh_google_token
    if data and credentials = data[:credentials]
      refresh_token = self.refresh_token
      cred = {
        client_id: CONFIG[:google][:client_id],
        client_secret: CONFIG[:google][:client_secret],
        refresh_token: refresh_token,
        grant_type: 'refresh_token'
      }


      response = JSON.parse(HTTParty.post("https://accounts.google.com/o/oauth2/token", :body => cred).response.body)

      if token = response['access_token']
        self.expires_at = Time.now + response['expires_in']
        self.access_token = token
        self.save
      end

    end
  end

  def expired?
    Time.at(expires_at) < Time.now.utc if expires_at?
  end

  class << self

    def facebook user
      playlist = user.image_playlists.where(social_network: 'Facebook').first
      if playlist && playlist.set_feed && (access_token = user.facebook.try(:access_token)) && !user.facebook.expired?
        graph = Koala::Facebook::API.new(access_token)
        facebook_albums = graph.get_connections('me', 'albums', :fields => "name,cover_photo,photos.fields(id, source, name)")
        user_albums = playlist.albums
        facebook_ids = facebook_albums.map {|album| album['id'] }
        user_ids = user_albums.map {|album| album.social_network_id }
        # added
        (facebook_ids - user_ids).each do |social_network_id|
          added_album = facebook_albums.select {|album| album["id"] == social_network_id }[0]
          if added_album["cover_photo"]
            url = added_album["photos"]["data"].select {|photo| photo["id"] == added_album["cover_photo"] }[0]['source']
            album = playlist.albums.create(name: added_album['name'], image_url:url, social_network_id: added_album['id'], network: 'facebook')
            added_album["photos"]["data"].each do |photo|
              album.photos.create(caption: photo['name'], image_url: photo['source'], social_network_id: photo['id'], network: 'facebook')
            end
          else
            playlist.albums.create(name: added_album['name'], social_network_id: added_album['id'], network: 'facebook')
          end
        end
        # updated
        exist_albums = facebook_ids - (facebook_ids - user_ids)
        exist_albums.each do |album_id|
          facebook_photos = facebook_albums.select {|album| album["id"] == album_id }[0]["photos"]
          if facebook_photos
            facebook_photos = facebook_photos["data"]
          else
            facebook_photos = []
          end
          facebook_photo_ids = facebook_photos.map {|photo| photo["id"] }
          user_album = playlist.albums.where(social_network_id: album_id, network: 'facebook').first
          user_photos_ids = user_album.photos.map {|photo| photo.social_network_id }
          #puts "----------album_id:#{album_id}"
          #puts "----------faceb_photo_ids:#{facebook_photo_ids.to_s}"
          #puts "----------user_photos_ids:#{user_photos_ids.to_s}"
          # added photo
          (facebook_photo_ids - user_photos_ids).each do |photo_id|
            added_photo = facebook_photos.select {|photo| photo["id"] == photo_id }[0]
            user_album.photos.create(caption: added_photo['name'], image_url: added_photo['source'], social_network_id: photo_id, network: 'facebook')
          end
          # deleted photo
          (user_photos_ids - facebook_photo_ids).each do |photo_id|
            photo = user_album.photos.where(social_network_id: photo_id, network: 'facebook').first
            photo.destroy
          end
        end
        # deleted
        (user_ids - facebook_ids).each do |social_network_id|
          album = playlist.albums.where(social_network_id: social_network_id, network: 'facebook').first
          album.item.delete
          album.delete_self
        end
      end
    end

    def instagram user
      playlist = user.image_playlists.where(social_network: 'Instagram').first
      if playlist && playlist.set_feed && (access_token = user.instagram.try(:access_token)) && !user.instagram.expired?
        client = Instagram.client(access_token: access_token)
        p social_photos = client.user_recent_media
        user_photos = playlist.photos

        social_ids = social_photos.map {|photo| photo["id"] }
        user_ids = user_photos.map {|photo| photo.social_network_id }
        # added
        (social_ids - user_ids).each do |social_network_id|
          added_photo = social_photos.select {|photo| photo["id"] == social_network_id } [0]
          caption = added_photo['caption']
          caption = caption['text'] unless caption.nil?
          playlist.photos.create(caption: caption, image_url: added_photo['images']['standard_resolution']['url'], social_network_id: added_photo['id'], network: 'instagram')
        end
        # deleted
        (user_ids - social_ids).each do |social_network_id|
          photo = playlist.photos.where(social_network_id: social_network_id, network: 'instagram').first
          photo.destroy
        end
      end
    end

    def flickr user
      playlist = user.image_playlists.where(social_network: 'Flickr').first
      if playlist && playlist.set_feed && (service = user.flickr) && !service.expired?
        cred = service.data[:credentials]
        client = FlickRaw::Flickr.new
        client.access_token = cred[:token]
        client.access_secret = cred[:secret]
        social_photos = client.photos.search(user_id: service.uid, :extras => "url_sq, url_t, url_s, url_q, url_m, url_n, url_z, url_c, url_l, url_o")
        user_photos = playlist.photos
        social_ids = social_photos.map {|photo| photo["id"] }
        user_ids = user_photos.map {|photo| photo.social_network_id }
        # added
        (social_ids - user_ids).each do |social_network_id|
          added_photo = social_photos.select {|photo| photo["id"] == social_network_id } [0]
          keys = Hash[added_photo].keys.grep /^url_./
          key = keys.last
          playlist.photos.create(caption: added_photo['title'], image_url: added_photo[key], social_network_id: added_photo['id'], network: 'flickr')
        end
        # deleted
        (user_ids - social_ids).each do |social_network_id|
          photo = playlist.photos.where(social_network_id: social_network_id, network: 'flickr').first
          photo.destroy
        end
      end
    end

    def picasa user
      playlist = user.image_playlists.where(social_network: 'Picasa').first
      if playlist && playlist.set_feed && (service = user.picasa) && !service.disconnected
        # refresh token if service expired
        service.refresh_google_token if service.expired?

        email = service.data[:info][:email]
        access_token = service.access_token
        client = Picasa::Client.new(user_id: email, authorization_header: "Bearer #{access_token}")
        social_albums = client.album.list.albums
        user_albums = playlist.albums
        social_ids = social_albums.map {|album| album.id }
        user_ids = user_albums.map {|album| album.social_network_id }

        # added
        (social_ids - user_ids).each do |social_network_id|
          added_album = social_albums.select {|album| album.id== social_network_id }[0]
          path_object = added_album.media.thumbnails.first
          if path_object
            album = playlist.albums.create(name: added_album.title, social_network_id: added_album.id, network: 'picasa', image_url: path_object.url)
          else
            album = playlist.albums.create(name: added_album.title, social_network_id: added_album.id, network: 'picasa')
          end
          # then photos
          photos = client.album.show(added_album.id).photos
          photos.each do |photo|
            album.photos.create(image_url: photo.content.src, social_network_id: photo.id, network: 'picasa', caption: photo.title)
          end
        end
        # updated
        exist_albums = social_ids - (social_ids - user_ids)
        exist_albums.each do |album_id|
          social_photos = client.album.show(album_id).photos
          social_photo_ids = social_photos.map {|photo| photo.id }
          user_album = playlist.albums.where(social_network_id: album_id, network: 'picasa').first
          user_photos_ids = user_album.photos.map {|photo| photo.social_network_id }
          #puts "----------album_id:#{album_id}"
          #puts "----------social_photo_ids:#{social_photo_ids.to_s}"
          #puts "----------user_photos_ids:#{user_photos_ids.to_s}"
          # added photo
          (social_photo_ids - user_photos_ids).each do |photo_id|
            added_photo = social_photos.select {|photo| photo.id == photo_id }[0]
            user_album.photos.create(image_url: added_photo.content.src, social_network_id: photo_id, network: 'picasa')
          end
          # deleted photo
          (user_photos_ids - social_photo_ids).each do |photo_id|
            photo = user_album.photos.where(social_network_id: photo_id, network: 'picasa').first
            photo.destroy
          end
        end
        # deleted
        (user_ids - social_ids).each do |social_network_id|
          album = playlist.albums.where(social_network_id: social_network_id, network: 'picasa').first
          album.item.delete
          album.delete_self # when delete album, how to delete photo automatically
        end
      end
    end

    # http://rdoc.info/gems/twitter/Twitter/API/Timelines#user_timeline-instance_method
    # https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline
    def twitter user
      playlist = user.image_playlists.where(social_network: 'Twitter').first
      if playlist && playlist.set_feed && (service = user.twitter) && !service.expired?
        cred = service.data[:credentials]
        client = Twitter::Client.new(oauth_token: cred[:token], oauth_token_secret: cred[:secret])
        tweets = client.user_timeline(:trim_user => true, :count => 200)
        social_photos = tweets.map do |tweet|
          if media = tweet.attrs[:entities][:media] and media.any? { |media| media[:type] === 'photo' }
            tweet.attrs[:entities][:media][0]
          end
        end.compact
        user_photos = playlist.photos
        social_ids = social_photos.map {|photo| photo[:id_str] }
        user_ids = user_photos.map {|photo| photo.social_network_id }
        # added
        (social_ids - user_ids).each do |social_network_id|
          added_photo = social_photos.select {|photo| photo[:id_str] == social_network_id } [0]
          playlist.photos.create(image_url: added_photo[:media_url], social_network_id: added_photo[:id], network: 'twitter')
        end
        ## deleted
        #(user_ids - social_ids).each do |social_network_id|
        #  photo = playlist.photos.where(social_network_id: social_network_id, network: 'twitter').first
        #  photo.destroy
        #end
      end
    end

    # get soundcloud tracks by url
    def soundcloud_helper client, url, per_page = 200
      result = []
      (0..8000).each do |index|
        break if per_page * index > 8000 # 8000 is the max limit of offset by soundcloud
        paginate_result = client.get(url, :limit => per_page, offset: per_page * index)
        if paginate_result.length > 0
          result += paginate_result
          break if paginate_result.length < per_page
        else
          break
        end
      end
      result
    end


    def soundcloud user
      playlist = user.music_playlists.where(social_network: 'Soundcloud').first
      if playlist and playlist.set_feed? and service = user.soundcloud
        client = Soundcloud.new(access_token: service.access_token, client_id: CONFIG[:soundcloud][:client_id])
        uploads = soundcloud_helper(client, '/me/tracks') # fetch tracks
        likes = soundcloud_helper client, '/me/favorites' # fetch likes
        soundcloud_playlists = client.get('/me/playlists')
        # save_and_cleanup_tracks_to_database [uploads, likes, social_albums], playlist
        # create_playlist uploads,    'SoundcloudUploads',    user
        # create_playlist likes,      'SoundcloudFavorites',  user
        # create_playlists playlists, user
        create_collection uploads, 'Uploads', playlist
        create_collection likes, 'Likes', playlist
        create_collections soundcloud_playlists, playlist
      end
    end


    def create_collection media, album_name, playlist
      # Finds or create Collection with given name in playlist
      collection = playlist.collections.where(:title => album_name).first_or_initialize
      if collection.new_record?
        collection.save!
        playlist.collections << collection
      else
        track = media.detect { |track| track.artwork_url.present? }
        image_url = track.try(:artwork_url) || track.try(:waveform_url) || "https://a1.sndcdn.com/images/default_avatar_large.png?3eddc42"
        collection.update_attribute(:image_url, image_url)
      end


      # Find new Items Ids which to add to the collection
      social_ids = media.map(&:id).map(&:to_s)
      local_ids = collection.tracks.map(&:social_network_id)
      ids = social_ids - local_ids

      # Add tracks to the collection which don't exists
      media.select { |track| ids.include? track.id.to_s }.each do |track|
        parameters = { title: track.title, track_object: HashWithIndifferentAccess.new(track),
                       social_network_id: track.id, network: 'soundcloud'}
        collection.tracks.create(parameters)
      end

      # Remove tracks from the collection
      ids = local_ids - social_ids
      collection.tracks.where(:social_network_id => ids).destroy_all
    end


    def create_collections media, playlist
      media.each do |soundcloud_playlist|
        create_collection soundcloud_playlist.tracks, soundcloud_playlist.title,  playlist
      end
    end


    def create_playlist media, playlist_name, user
      playlist = user.music_playlists.where(social_network: playlist_name).first_or_create(name: playlist_name.titlecase)

      social_ids = media.map(&:id).map(&:to_s)
      local_ids = playlist.tracks.map(&:social_network_id)
      ids = social_ids - local_ids

      media.select { |track| ids.include? track.id.to_s }.each do |track|
        parameters = { title: track.title, track_object: HashWithIndifferentAccess.new(track),
                       social_network_id: track.id, network: 'soundcloud'}
        playlist.tracks.create(parameters)
      end

      # Remove Deleted/Missing Tracks
      social_ids = media.map(&:id).map(&:to_s)
      local_ids = playlist.tracks.map(&:social_network_id)
      ids = local_ids - social_ids
      playlist.tracks.where(:social_network_id => ids).destroy_all
    end

    def create_playlists playlists, user
      playlists.each do |playlist|
        create_playlist playlist.tracks, playlist.title, user
      end
    end



    def save_and_cleanup_tracks_to_database tracks, playlist
      social_ids = tracks.flatten!.map(&:id).map(&:to_s)
      local_ids = playlist.tracks.map(&:social_network_id)
      ids = social_ids - local_ids

      # Save Tracks 
      tracks.select { |track| ids.include? track.id.to_s }.each do |track|
        params = {title: track.title, network: 'soundcloud', social_network_id: track.id, track_object: HashWithIndifferentAccess.new(track)}
        playlist.tracks.create(params)
      end

      # Destroy Tracks
      ids = local_ids - social_ids
      playlist.tracks.where(:social_network_id => ids).destroy_all
    end


    def old_soundcloud user
      playlist = user.music_playlists.where(social_network: 'Soundcloud').first
      if playlist && playlist.set_feed && (service = user.soundcloud) && !service.expired?
        client = Soundcloud.new(access_token: service.access_token, client_id: CONFIG[:soundcloud][:client_id])

        uploads = soundcloud_helper(client, '/me/tracks') # fetch tracks
        likes = soundcloud_helper client, '/me/favorites' # fetch likes


        # prepare data
        social_albums = client.get('/me/playlists')
        social_albums << OpenStruct.new(id: 'Uploads', title: 'Uploads', artwork_url: nil, tracks: uploads) #uploads
        social_albums << OpenStruct.new(id: 'Likes', title: 'Likes', artwork_url: nil, tracks: likes) #likes
        user_albums = playlist.track_albums
        social_ids = social_albums.map { |album| album.id.to_s }
        user_ids = user_albums.map { |album| album.social_network_id }
        # added
        (social_ids - user_ids).each do |social_network_id|
           added_album = social_albums.select {|album| album.id.to_s == social_network_id } [0]
          track_album = playlist.track_albums.create(name: added_album.title, social_network_id: added_album.id.to_s, network: 'soundcloud', image_url: added_album.artwork_url)
          # add tracks
          tracks = added_album.tracks
          tracks.each do |track|
            data = HashWithIndifferentAccess.new(track)
            track_album.tracks.create(title: track.title, social_network_id: track.id.to_s, network: 'soundcloud', track_object: data);
          end
        end
        # updated
        exist_albums = social_ids - (social_ids - user_ids)
        exist_albums.each do |album_id|
          social_album = social_albums.select {|album| album.id.to_s == album_id } [0]
          user_album = playlist.track_albums.where(social_network_id: album_id, network: 'soundcloud').first
          # check if album changed
          if user_album.name != social_album.title || user_album.image_url != social_album.artwork_url
            user_album.update_attributes({name: social_album.title, image_url: social_album.artwork_url})
          end
          # sync tracks
          # prepare data
          social_tracks = social_album.tracks
          social_track_ids = social_tracks.map { |track| track.id.to_s }
          user_track_ids = user_album.tracks.map {|track| track.social_network_id }
          # added track
          (social_track_ids - user_track_ids).each do |track_id|
            added_track = social_tracks.select {|track| track.id.to_s == track_id }[0]
            data = HashWithIndifferentAccess.new(added_track)
            user_album.tracks.create(title: added_track.title, social_network_id: added_track.id.to_s, network: 'soundcloud', track_object: data)
          end
          # updated track
          (social_track_ids - (social_track_ids - user_track_ids)).each do |track_id|
            social_track = social_tracks.select {|track| track.id.to_s == track_id }[0]
            user_track = user_album.tracks.where(social_network_id: track_id, network: 'soundcloud').first
            if social_track.title != user_track.title
              p data = HashWithIndifferentAccess.new(social_track)
              user_track.update_attributes(title: social_track.title, track_object: data)
            end
          end
          # deleted track
          (user_track_ids - social_track_ids).each do |track_id|
            track = user_album.tracks.where(social_network_id: track_id, network: 'soundcloud').first
            track.destroy
          end
        end
        # deleted
        (user_ids - social_ids).each do |social_network_id|
          album = playlist.track_albums.where(social_network_id: social_network_id, network: 'soundcloud').first
          album.destroy
        end
      end
    end

    def youtube user
      playlist = user.video_playlists.where(social_network: 'Youtube').first
      if playlist && playlist.set_feed && (service = user.youtube) && !service.disconnected
        # refresh token if service expired
        service.refresh_google_token if service.expired?
        access_token = service.access_token
        client = Youtube.new(access_token: access_token)
        #
        social_albums = client.all_playlists
        social_ids = social_albums.map {|album| album['id'] }
        user_ids = playlist.video_albums.map {|video| video.social_network_id }
        #
        # added
        (social_ids - user_ids).each do |social_network_id|
          added_album = social_albums.select {|album| album['id'] == social_network_id } [0]
          video_album = playlist.video_albums.create(name: added_album['snippet']['title'], social_network_id: added_album['id'],
                                                     network: 'youtube', image_url: added_album['snippet']['thumbnails']['medium']['url'])
          # add videos
          videos = client.all_videos_of_one_playlist social_network_id
          videos.each do |video|
            video_album.videos.create(title: video['snippet']['title'], social_network_id: video['id'], video_id: video['snippet']['resourceId']['videoId'],
                                      network: 'youtube', image_url: video['snippet']['thumbnails']['medium']['url']);
          end
        end
        # updated
        exist_albums = social_ids - (social_ids - user_ids)
        exist_albums.each do |album_id|
          social_album = social_albums.select {|album| album['id'] == album_id } [0]
          user_album = playlist.video_albums.where(social_network_id: album_id, network: 'youtube').first
          # check if album changed
          if user_album.name != social_album['snippet']['title'] || user_album.image_url != social_album['snippet']['thumbnails']['medium']['url']
            user_album.update_attributes({name: social_album['snippet']['title'], image_url: social_album['snippet']['thumbnails']['medium']['url']})
          end
          # sync videos
          # prepare data
          social_videos = client.all_videos_of_one_playlist album_id
          social_video_ids = social_videos.map { |video| video['id'] }
          user_video_ids = user_album.videos.map {|video| video.social_network_id }
          # added video
          (social_video_ids - user_video_ids).each do |video_id|
            added_video = social_videos.select {|video| video['id'] == video_id }[0]
            user_album.videos.create(title: added_video['snippet']['title'], social_network_id: added_video['id'],
                                     video_id: added_video['snippet']['resourceId']['videoId'], network: 'youtube', image_url: added_video['snippet']['thumbnails']['medium']['url']);
          end
          # updated video
          (social_video_ids - (social_video_ids - user_video_ids)).each do |video_id|
            social_video = social_videos.select {|video| video['id'] == video_id }[0]
            user_video = user_album.videos.where(social_network_id: video_id, network: 'youtube').first
            if social_video['snippet']['title'] != user_video.title || social_video['snippet']['thumbnails']['medium']['url'] != user_video.image_url
              user_video.update_attributes({:title => social_video['snippet']['title'],
                                            :image_url => social_video['snippet']['thumbnails']['medium']['url']})
            end
          end
          # deleted video
          (user_video_ids - social_video_ids).each do |video_id|
            video = user_album.videos.where(social_network_id: video_id, network: 'youtube').first
            video.destroy
          end
        end
        # deleted
        (user_ids - social_ids).each do |social_network_id|
          album = playlist.video_albums.where(social_network_id: social_network_id, network: 'youtube').first
          album.destroy
        end
      end
    end

    # for cron
    def social_cron
      i = 0
      loop do
        users = User.page(i=i+1).per(10)
        break if users.count == 0
        users.each do |user|
          puts "user:,#{user.id}"
          begin
            # facebook
            Service.facebook user
            # instagram
            Service.instagram user
            # flickr
            Service.flickr user
            # picasa
            Service.picasa user
            # twitter
            Service.twitter user
            # soundcloud
            Service.soundcloud user
            # youtube
            Service.youtube user
          rescue => e
            puts "user:,#{user.id},error......."
            puts e
          end
        end
      end
    end

  end
end
