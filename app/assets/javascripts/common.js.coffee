$ ->
  $("#set_feed_div button").click ->
    if $(this).attr('class').indexOf('active') == -1
      $(this).text('On')
    else
      $(this).text('Off')

  $("a.comment-reply").live 'click', ->
    if $(this).next().css("display") == 'none'
      $(this).next().show()
    else
      $(this).next().hide()
    false

  # image playlist setting
  $(".slide-show-setting").click ->
    $.get("/image_playlists/#{$(this).attr('data-id')}/image_playlist_by_id", {}, (data) ->
      $("div.slideshow-setting-div").html(data.html)
      $("div.form").removeClass('form')
      $("div.slideshow-setting-div").addClass('form')
      $("div.individual").hide()
      $("div.slideshow-setting-div").show()
      form_slide('show')
      $("article.span2.special").fadeOut()
    , 'json')

  # choose music btn event on image playlist setting page
  $("#choose_music").live 'click', ->
    if($("#music_not_load").length == 1)
      $("#image-playlist-setting-panel").modal()
      $.get("/image_playlists/background_music_list", {}, (data) ->
        $("#image-playlist-setting-panel").html(data.html)
      , 'json')
    else
      $("#image-playlist-setting-panel").modal()

  # set feed button
  $(".feed-btn").click ->
    $.post "/playlists/#{$(this).attr('data-id')}/toggle_feed"

