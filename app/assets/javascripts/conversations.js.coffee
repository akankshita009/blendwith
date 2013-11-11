
$ ->
  tabFunc = (comp) ->
    $("div.message-panel").hide()
    $("#friend_ul li").removeClass("active")
    $(comp).parent().addClass("active")

  $("#pending_btn").click ->
    tabFunc(this)
    $("#pending_friends").show()

  $("#request_btn").click ->
    tabFunc(this)
    $("#request_friends").show()

  $("#all_btn").click ->
    tabFunc(this)
    $("#search_result").show()

  $(".show-message").live 'click', ->
    self = this
    $.get $(this).attr('href'), {}, (result) ->
      $(self).parents('.message-panel').children('.message-content').html(result.html)
      $(self).removeClass('unread-message')
      $(self).next().removeClass('unread-message')
    , 'json'
    false

