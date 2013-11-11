
$ ->
  $("#search_btn").click ->
    text = $(this).prev().val()
    $.get("/friend_maps", {name: text}, null, 'script'
    )

  $(".add-friend").live 'click', ->
    self = this
    $.post "/friend_maps/add_friend", {friend_id: $(this).attr("data-id")}, (data) ->
      $(self).hide()
      if data.result == 'friend'
        $(self).parent().find(".friend").fadeIn()
        $("#friend_btn span").html(parseInt($("#friend_btn span").html(), 10) + 1)
        show_notice('Add successfully')
        $.get("/friend_maps/friends", {}, null, 'script');
      if data.result == 'already'
        $(self).parent().find(".friend").fadeIn()
        show_warn('Already your friend')
      if data.result == "pending"
        $(self).parent().find(".pending").fadeIn()
        $("#pending_btn span").html(parseInt($("#pending_btn span").html(), 10) + 1)
        show_error('Wait be confirmed')
        $.get("/friend_maps/pending_friends", {}, null, 'script');
    , 'json'
    false

  $(".agree-request").live 'click', ->
    self = this
    $.post "/friend_maps/agree_request", {user_id: $(this).attr("data-id")}, (data) ->
      $(self).hide()
      $(self).next().fadeIn() if data.result == "friend"
    , 'json'
    false

  tabFunc = (comp) ->
    $("div.friend-panel").hide()
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

  $("#friend_btn").click ->
    tabFunc(this)
    $("#all_friends").show()

  $("div.feed").live 'click', ->
    playlist_type = $(this).attr('media-type')
    playlist_type = 'photo' if playlist_type == 'album'
    playlist_type = 'audio' if playlist_type == 'track_album'
    playlist_type = 'video' if playlist_type == 'video_album'
    window.location = "/users/#{$(this).attr('data-id')}?feed=#{$(this).attr('feed-id')}&playlist_type=#{playlist_type}"
