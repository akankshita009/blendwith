# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("a.awe-trash").click ->
    $("a.awe-trash").removeClass("selected-media")
    $(this).addClass("selected-media")

  $("#demoModal a[type='submit']").click ->
    id = $("a.awe-trash.selected-media").parent().find("input").val()
    photo_album_id = $("a.awe-trash.selected-media").parents('li').attr('data-photo-album-id')
    $.ajax({
           type: "DELETE",
           data: {photo_album_id: photo_album_id}
           url: "/albums/delete_photo"
           })
      .done ->
        $("#demoModal").modal("hide")
        window.location = window.location.href

