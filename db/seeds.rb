#email = "punkrocker04@gmail.com"
#def_user = User.where(:email => email).first
#if def_user.count.eql?(0)
#create_user = lambda do |first_name, last_name, email, no_need_confirm = true|
#    User.create!(:first_name => "#{first_name}", :last_name => "#{last_name}", :email => "#{email}",
#                 :password => "12345678", :password_confirmation => "12345678", :no_need_confirm => no_need_confirm)
#end
#
#create_user.call("Albert", "Contreras", email)
#end
  
#create_user = lambda do |first_name, last_name, email, no_need_confirm = true|
#  1.upto(30).each do |i|
#    User.create!(:first_name => "#{first_name}#{i}", :last_name => "#{last_name}#{i}", :email => "#{email}#{i}@gmail.com",
#                 :password => "12345678", :password_confirmation => "12345678", :no_need_confirm => no_need_confirm)
#  end
#end
#
#create_user.call("Abcd", "Efg", "james")
#create_user.call("Hijk", "Lmn", "kevin")
#create_user.call("Opq", "Rst", "bryant", false)
#create_user.call("Uvw", "Xyz", "jordan", false)
#
#friend_test = User.create!(first_name: 'friend', last_name: 'test', email: "friends@gmail.com",
#            password: '12345678', password_confirmation: '12345678', no_need_confirm: false)
#
## requests
#User.limit(20).offset(0).each do |user|
#  user.add_friend friend_test.id
#end
#
## pending
#User.where('first_name like ?', '%Opq%').limit(20).each do |friend|
#  friend_test.add_friend friend.id
#end

#FriendFeed.delete_all
#
#images = %w(
#https://fbcdn-sphotos-c-a.akamaihd.net/hphotos-ak-ash4/s720x720/417950_10151641159867628_1511996154_n.jpg
#https://fbcdn-sphotos-c-a.akamaihd.net/hphotos-ak-ash4/s720x720/417950_10151641159867628_1511996154_n.jpg
#https://fbcdn-sphotos-g-a.akamaihd.net/hphotos-ak-frc1/227525_10150201828647628_570359_n.jpg
#https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-ash4/5105_93573577627_2193038_n.jpg
#https://fbcdn-sphotos-c-a.akamaihd.net/hphotos-ak-frc3/971725_10151647932082628_1368617773_n.jpg
#)
#
#user = User.find_by_email "friends@gmail.com"
#User.where('first_name like ?', '%Opq%').limit(20).each do |friend|
#  0.upto(4).each do |i|
#    FriendFeed.create_friend_feed friend, 'This is caption', 'facebook', 'photo', OpenStruct.new(id: nil), images[i]
#  end
#end

#User.all.each do |user|
#  %w(Facebook Twitter Instagram Flickr Picasa).each do |social|
#    playlist = user.image_playlists.where(name: social, social_network: social).first
#    unless playlist
#      user.image_playlists.create(name: social, social_network: social)
#    end
#  end
#  unless user.video_playlists.where(name: 'Youtube', social_network: 'Youtube').first
#    user.video_playlists.create(name: 'Youtube', social_network: 'Youtube')
#  end
#  unless user.music_playlists.where(name: 'Soundcloud', social_network: 'Soundcloud').first
#    user.music_playlists.create(name: 'Soundcloud', social_network: 'Soundcloud')
#  end
#end

#ImagePlaylist.where(name: 'Picasa').each do |playlist|
#  playlist.update_attribute :name, 'Google Plus'
#end

#User.all.each do |user|
#  %w(URL MyPhotos AllPhotos RecentPhotos).each do |social|
#    playlist = user.image_playlists.where(name: social, social_network: social).first
#    unless playlist
#      user.image_playlists.create(name: social, social_network: social)
#    end
#  end
#end
#
#ImagePlaylist.where(name: 'AllPhotos').each do |playlist|
#  playlist.update_attribute :name, 'All Photos'
#end
#
#ImagePlaylist.where(name: 'RecentPhotos').each do |playlist|
#  playlist.update_attribute :name, 'Recent Photos'
#end

#User.all.each do |user|
#  user.init_player_token if user.player_token.nil?
#end

#FriendFeed.all.each do |feed|
#  if feed.media_type == 'video'
#    #puts ".........#{feed.network}....#{feed.image_url.include?('keating111000.s3.amazonaws.com')}....#{feed.image_url}"
#    if feed.image_url.include?('keating111000.s3.amazonaws.com')
#      feed.update_attribute :network, 'uploaded_video'
#    end
#  end
#end
#
#FriendFeed.all.each do |feed|
#  unless feed.item_id
#    feed.destroy
#  end
#end

#Track.all.each do |track|
#  if track.network == 'soundcloud' && !track.social_network_id
#    track.destroy
#  end
#end

#playlists = MusicPlaylist.where(social_network: 'Soundcloud')
#playlists.each do |playlist|
#  playlist.tracks.destroy_all
#end

#playlists = VideoPlaylist.where(social_network: 'Youtube')
#playlists.each do |playlist|
#  playlist.videos.destroy_all
#end

#audios = []
#UploadedAudio.all.each do |uploaded_audio|
#  begin
#    Panda::Video.find(uploaded_audio.panda_audio_id)
#  rescue
#    audios << uploaded_audio
#  end
#end
#audios.each do |e|
#  e.delete
#end
#
#videos = []
#UploadedVideo.all.each do |uploaded_video|
#  begin
#    Panda::Video.find(uploaded_video.panda_video_id)
#  rescue
#    videos << uploaded_video
#  end
#end
#videos.each do |e|
#  e.delete
#end
#
## resolve refresh token
#Service.where(provider: 'google_oauth2').each do |service|
#  refresh_token = service.data['credentials']['refresh_token']
#  if refresh_token
#    service.update_attribute :refresh_token, refresh_token
#  else
#    service.destroy
#  end
#end

# delete items that refer deleted uploaded video
#Video.where(network: 'uploaded_video').each do |video|
#  if UploadedVideo.where(id: video.video_id).count == 0
#    video.destroy
#  end
#end

# delete dirty data
Comment.all.each do |comment|
  comment.destroy if comment.owner_id.blank?
end