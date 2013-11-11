# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".video-thumb").live 'click', ->
    network = $(this).parents('li').attr('data-network')

    if(network == 'youtube_url' || network == 'youtube')
      video_id = $(this).parent().attr('data-id') if network == 'youtube_url'
      video_id = $(this).parent().attr('data-video-id') if network == 'youtube'
      $(this).hide()
      video_tag_id = "a_#{Math.floor(Math.random()*100000000+1)}"
      $(this).before("<div style='width: 100%;height: 175px;margin-bottom: 10px;'><video id='#{video_tag_id}' src='' class='video-js vjs-default-skin' controls preload='auto' width='260' height='175' ></video></div>")
      url = "http://www.youtube.com/v/#{video_id}?enablejsapi=1&playerapiid=ytplayer&autoplay=1"
      videojs "#{video_tag_id}", {"techOrder": ["youtube"], "src": url}, ->
        this.play()
    else if(network == 'uploaded_video')
      $(this).hide()
      url = $(this).parents('li').attr('data-video-url')
      video_tag_id = "a_#{Math.floor(Math.random()*100000000+1)}"
      $(this).before("<div style='width: 100%;height: 175px;margin-bottom: 10px;'><video id='#{video_tag_id}' src='#{url}' class='video-js vjs-default-skin' controls preload='auto' width='260' height='175' ></video></div>")
      videojs "#{video_tag_id}", {}, ->
        this.play()


  $("a.awe-trash").click ->
    $("a.awe-trash").removeClass("selected-media")
    $(this).addClass("selected-media")

  $("#demoModal a[type='submit']").click ->
    id = $("a.awe-trash.selected-media").parents('li').attr('data-item-id')
    $.ajax({
           type: "DELETE",
           data: {item_id: id}
           url: "/video_playlists/delete_item"
           })
      .done ->
        $("#demoModal").modal("hide")
        window.location = window.location.href