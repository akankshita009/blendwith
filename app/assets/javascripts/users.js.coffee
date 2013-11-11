# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.add-comment-btn').live 'click', ->
    form = $(this).parent()
    $.post(form.attr('action'), form.serialize(), null, 'script')
    false

  $('.disconnect').live 'click', ->
    self = this
    $.post '/users/disconnect_social_network', {social_network: $(this).attr('href')}, ->
      $(self).prev().prev().hide()
      $(self).hide()
      $(self).prev().show()
      $(self).next().show()
    false
