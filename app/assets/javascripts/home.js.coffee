# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  $('.select').on 'click', '.awe-plus-sign', (event) ->
    if $('.select input[type=text]').length < 1
      li = $('<li></li>')
      html = li.html($('#playlist-form').html())
      $('.playlists').append(html)



  $('.select').on 'keypress', '#playlist_name', (event) ->
    if(event.which == 13)
      if $(this).val().trim().length < 1
        alert("Playlist name can't be blank.")
        $(this).focus()
        return false

      data = $(this).closest('form').serialize()
      $.post('/image_playlists', data, null, 'script')
      # $(this).closest('li').remove()
      return false
