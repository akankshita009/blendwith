# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("a.awe-trash").click ->
    $("a.awe-trash").removeClass("selected-media")
    $(this).addClass("selected-media")

  $("#demoModal a[type='submit']").click ->
    id = $("a.awe-trash.selected-media").parent().attr("data-audio-id")
    $.ajax({
           type: "DELETE",
           url: "/uploaded_audios/#{id}"
           })
      .done ->
        $("#demoModal").modal("hide")
        window.location = window.location.href

  $('#thumbnails .awe-cog').live 'click', ->
    $("div.form input[name='uploaded_audio[title]']").val($(this).parent().find("label").text().trim())
    $("div.form input[name='uploaded_audio[artist]']").val($(this).parents('li').attr('data-artist'))
    $("div.form input[name='uploaded_audio[album]']").val($(this).parents('li').attr('data-album'))
    $("div.form input[name='uploaded_audio[genre]']").val($(this).parents('li').attr('data-genre'))
    $("div.form input[name='uploaded_audio[genre]']").val($(this).parents('li').attr('data-genre'))
    photo = $(this).parents('li').attr('data-photo')
    if photo == '/music_photos/original/missing.png'
      $("div.form .music_photo").hide()
    else
      $("div.form .music_photo").attr('src', photo)
      $("div.form .music_photo").show()

    $item = $(this).closet('li')
    id = $item.data("id")
    $('#caption').val($item.data('title'))
    $('#tags').val($item.data('tags'))
    
    $("div.form form").attr("action", "/uploaded_audios/#{id}")
    music = $(this).parent().find("input").val()
    $("#cp_jplayer_1").jPlayer("setMedia", { m4a: music })

    $("div.form").height($(window).height() - 60)
