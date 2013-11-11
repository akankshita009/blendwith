module ApplicationHelper

  def helper_my
    concat(link_to "me", root_url)
    concat("Ismail")
  end
  def cover_class(playlist, media)
    playlist.cover_image_source? && media.id == playlist.cover_source_id && 
      media.instance_of?(playlist.cover_source_class) ? 'highlight' : ''
  end

  def generate_cover_id_from media
    "#{media.id}-#{media.class}"
  end

  def playlist_thumb(playlists, network)
    playlists.detect { |list| list.social_network == network }.try {|item| item.cover_image.url(:thumb)}  or '/assets/thumb.png'
  end

  def playlist_object
    if controller_name.in?(%w(music_networks music_playlists music_urls uploaded_audios collections))
      MusicPlaylist
    elsif controller_name.in?('photo_networks image_playlists photo_urls albums')
      ImagePlaylist
    else
      VideoPlaylist
    end.new
  end

  # for user.PLAYLIST_NAME (it is an attribute of user)
  def playlist_by_controller
    if controller_name.in?(%w(music_networks music_playlists music_urls uploaded_audios track_albums collections))
      :music_playlists
    elsif controller_name.in?('photo_networks image_playlists photo_urls albums uploaded_photos')
      :image_playlists
    else
      :video_playlists
    end
  end

  # for playlist_path(playlist)
  def playlist_path_by_controller playlist
    if controller_name.in?(%w(music_networks music_playlists music_urls uploaded_audios track_albums collections))
      music_playlist_path playlist
    elsif controller_name.in?('photo_networks image_playlists photo_urls albums uploaded_photos')
      image_playlist_path playlist
    else
      video_playlist_path playlist
    end
  end

  # the playlist key stored in session
  def playlist_box_by_controller
    if controller_name.in?(%w(music_networks music_playlists music_urls uploaded_audios collections))
      "music_box"
    elsif controller_name.in?('photo_networks image_playlists photo_urls albums uploaded_photos')
      "image_box"
    else
      "video_box"
    end
  end

  # all media and recent media label by controller
  def nav_media_menus
    if controller_name.in?(%w(music_networks music_playlists music_urls collections uploaded_audios))
      %(<li class="colored no-droppable"><a href="#{music_playlists_path}">All Music</a></li><li id="recent-li" class='no-droppable'><a href="#">Recent Music</a></li>)
    elsif controller_name.in?('photo_networks image_playlists photo_urls albums uploaded_photos')
      %(<li class="colored no-droppable playlist-user-add" data-id="#{current_user.all_photos_playlist_id}">
          <a href="#{image_playlists_path}">All Photos</a>
          <a href="#" class="slide-show-setting" data-id="#{current_user.all_photos_playlist_id}"></a></li>
        <li id="recent-li" class="playlist-user-add no-droppable" data-id="#{current_user.recent_photos_playlist_id}">
          <a href="#{recent_image_playlists_path}">Recent Photos</a>
          <a href="#" class="slide-show-setting" data-id="#{current_user.recent_photos_playlist_id}"></a></li>)
    else
      %(<li class="colored no-droppable"><a href="#{video_playlists_path}">All Videos</a></li><li id="recent-li" class='no-droppable'><a href="#">Recent Videos</a></li>)
    end.html_safe
  end


  # gravatar
  # profile photo is just for player, using gravatar is okay here
  def image_by_user user, size = 80, profile_photo_style = :medium
    return nil unless user
    profile_photo = user.profile_photo
    if profile_photo.nil?
      "http://www.gravatar.com/avatar/#{ Digest::MD5.hexdigest(user.email) }?s=#{size}"
    else
      profile_photo.profile_photo.url(profile_photo_style)
    end
  end

  #user name
  def user_name user
    user.full_name.blank? ? user.username : user.full_name
  end

end
