# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('.select').on 'click', '.awe-plus-sign', (event) ->
    $("#playlist-box-li").show();
    $.post "/playlist_box_session", {media_type: mediaBoxByController()}

  $('.select').on 'keypress', 'input[type="text"]', (event) ->
    if(event.which == 13)
      if $(this).val().trim().length < 1
        alert("Playlist name can't be blank.")
        $(this).focus()
        return false

      form = $(this).closest('form')
      $.post(form.attr("action"), form.serialize(), (data) ->
        newAddedPlaylist = $(data.result)
        newAddedPlaylistDroppable(newAddedPlaylist)
        $("#recent-li").after(newAddedPlaylist)
      , 'json') #script
      $(this).val("")
      return false

  $("li.playlist-user-add").live "mouseenter", ->
      $(this).find("a.playlist-setting").show()
  $("li.playlist-user-add").live "mouseleave", ->
      $(this).find("a.playlist-setting").hide()

  $(".playlist-setting").live 'click', ->
    link = $(this).prev()
    $("#playlist-setting-panel .modal-header input").val(link.attr("data-id"))
    $("#playlist-setting-panel .modal-body input").val(link.text())
    $("#playlist-setting-panel").modal()

  $("#playlist-setting-panel .modal-footer .btn-danger").click ->
    r = confirm("Are you sure you want to delete?")
    if r
      playlistId = $("#playlist-setting-panel .modal-header input").val()
      $.ajax({
             type: "DELETE",
             url: "/playlists/#{playlistId}"
             })
        .done ->
          if $("#name-playlist-detail").length == 0
            $("#playlist-setting-panel").modal("hide")
            $("li[data-id=#{playlistId}]").remove()
          else
            window.location = window.location.href[0..window.location.href.lastIndexOf("/")]

  $("#playlist-setting-panel .modal-footer .btn-primary").click ->
    name = $("#playlist-setting-panel .modal-body input").val()
    if name.trim() == ""
      alert("Playlist name can not be empty")
      return
    id = $("#playlist-setting-panel .modal-header input").val()
    $.ajax({
          type: "PUT",
          url: "/playlists/#{id}",
          data: {name: name}
           })
      .done ->
        $("#playlist-setting-panel").modal("hide")
        $("a[data-id=#{id}]").text(name)
        $("#name-playlist-detail").html(name)

mediaByController = ->
  ctrl = $("#controller-name-box").val()
  if ["music_networks", " music_playlists", "music_urls", "uploaded_audios"].indexOf(ctrl) != -1
    return "/music_playlists"
  if ["photo_networks", "image_playlists", "photo_urls albums uploaded_photos"].indexOf(ctrl) != -1
    return "/image_playlists"
  return "/video_playlists"

mediaBoxByController = ->
  ctrl = $("#controller-name-box").val()
  if ["music_networks", "music_playlists", "music_urls", "uploaded_audios"].indexOf(ctrl) != -1
    return "music_box"
  if ["photo_networks", "image_playlists", "photo_urls albums uploaded_photos"].indexOf(ctrl) != -1
    return "image_box"
  return "video_box"

newAddedPlaylistDroppable = (comp) ->
  comp.droppable
    accept: ".ui-draggable"
    tolerance: "pointer"
    over: ->
      $(this).removeClass("out").addClass "over"

    out: ->
      $(this).removeClass "over"

    drop: (event, ui) ->
      $(this).removeClass("over").addClass "droped"
      playlist_id = $(this).data("id")
      $ele = $(ui.draggable)

      saveAlbumOrImageToPlaylist playlist_id, $ele.data("type"), $ele.data("id"), $ele.data("network")

saveAlbumOrImageToPlaylist = (playlist_id, type, id, network) ->
  unless ["track", "music"].indexOf(type) is -1
    path = "/music_playlists/" + playlist_id + "/add_item"
  else unless ["video"].indexOf(type) is -1
    path = "/video_playlists/" + playlist_id + "/add_item"
  else unless ["playlist_album", "photo", "album"].indexOf(type) is -1
    path = "/image_playlists/" + playlist_id + "/add_item"
  else
    path = null
  if path
    $.post path,
           type: type
           object_id: id
           network: network
    , null, "script"

#saveAlbumOrImageToPlaylist = (playlist_id, type, id) ->
##  console.log playlist_id, type, id
#  path = "/image_playlists/" + playlist_id + "/add_item"
#  $.post path,
#         type: type
#         object_id: id
#  , null, "script"
#
#newAddedLiDropable = ->
#  $(".playlists li").droppable
#    accept: ".ui-draggable"
#    tolerance: "pointer"
#    over: ->
#      $(this).removeClass("out").addClass "over"
#
#    out: ->
#      $(this).removeClass "over"
#
#    drop: (event, ui) ->
#      $(this).removeClass("over").addClass "droped"
#      playlist_id = $(this).data("id")
#      $ele = $(ui.draggable)
#      saveAlbumOrImageToPlaylist playlist_id, $ele.data("type"), $ele.data("id")

