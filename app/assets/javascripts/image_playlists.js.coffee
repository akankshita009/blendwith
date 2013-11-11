# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("a.awe-trash").click ->
    $("a.awe-trash").removeClass("selected-media")
    $(this).addClass("selected-media")

  $("#demoModal a[type='submit']").click ->
    item_id = $("a.awe-trash.selected-media").parents('li').attr('data-item-id')
    $.ajax({
           type: "DELETE",
           url: "/image_playlists/delete_media"
           data: {item_id: item_id}
           })
      .done ->
        $("#demoModal").modal("hide")
        window.location = window.location.href