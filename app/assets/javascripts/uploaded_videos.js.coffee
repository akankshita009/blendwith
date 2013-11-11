# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("a.awe-trash").click ->
    $("a.awe-trash").removeClass("selected-media")
    $(this).addClass("selected-media")

  $("#demoModal a[type='submit']").click ->
    id = $("a.awe-trash.selected-media").parent().find("input").val()
    $.ajax({
      type: "DELETE",
      url: "/uploaded_videos/#{id}"
           })
    .done ->
        $("#demoModal").modal("hide")
        window.location = window.location.href

  $('#thumbnails .awe-cog').live 'click', ->
    $("div.form input[name='uploaded_video[title]']").val($(this).parent().find("label").text().trim())
    $("a.form-image").html($(this).parent().find("video.scale-video").clone())
    $("#original-size-video-div").html($(this).parent().find("div.original-size-video video").clone())
    id = $(this).parent().find("input").val()
    $("div.form form").attr("action", "/uploaded_videos/#{id}")

  $(".video-thumb").live 'click', ->
    $(this).hide()
    url = $(this).parents('li').attr('data-video-url')
    video_tag_id = "a_#{Math.floor(Math.random()*100000000+1)}"
    $(this).before("<div style='width: 100%;height: 175px;margin-bottom: 10px;'><video id='#{video_tag_id}' src='#{url}' class='video-js vjs-default-skin' controls preload='auto' width='260' height='175' ></video></div>")
    videojs "#{video_tag_id}", {}, ->
      this.play()