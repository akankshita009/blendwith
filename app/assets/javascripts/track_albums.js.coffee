
$ ->
  $("a.awe-trash").click ->
    $("a.awe-trash").removeClass("selected-media")
    $(this).addClass("selected-media")

  $("#demoModal a[type='submit']").click ->
    id = $("a.awe-trash.selected-media").parents('li').attr('data-id')
    $.ajax({
           type: "DELETE",
           data: {track_id: id}
           url: "/track_albums/delete_track"
           })
      .done ->
        $("#demoModal").modal("hide")
        window.location = window.location.href