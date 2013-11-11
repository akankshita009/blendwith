
$ ->
  $("a.awe-trash").click ->
    $("a.awe-trash").removeClass("selected-media")
    $(this).addClass("selected-media")

  $("#demoModal a[type='submit']").click ->
    id = $("a.awe-trash.selected-media").parents('li').attr('data-id')
    $.ajax({
           type: "DELETE",
           data: {video_id: id}
           url: "/video_albums/delete_video"
           })
      .done ->
        $("#demoModal").modal("hide")
        window.location = window.location.href

  $('.thumbnails li i').click ->
    $(this).hide();
    video_id = $(this).parent().attr('data-video-id')
    url = "http://www.youtube.com/watch?v=#{video_id}"
    video_tag_id = "a_#{Math.floor(Math.random()*100000000+1)}";
    $(this).before("<div style='width: 100%;height: 175px;margin-bottom: 10px;'><video id='#{video_tag_id}' src='' class='video-js vjs-default-skin' controls preload='auto' width='260' height='175' ></video></div>");
    videojs "#{video_tag_id}", {"techOrder": ["youtube"], "src": url}, ->
      this.play();