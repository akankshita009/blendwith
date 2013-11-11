$(document).ready(function() {

  var video_btn = $('.video-btn'),
  home_btn = $('.home-btn'),
  audio_btn = $('.chart-btn'),
  photo_btn = $('.photo-btn'),
  now_play = $('.now-play'),
  fullscreen_play = $('.fullscreen'),
  intro = $('.nav-intro, #block .bio'),
  wrapper, thumbs, playlist, items, playlist_thumb,
  player_nav = $('#player-navigation'),
  player_master = $('.player-master'),
  controls = $('.vjs-controls'),
  play_btn = $('.vjs-play-control'),
  play_slideshow = $('.vjs-slideshow-button'),
  scroller = $('.scroller'),
  scrollbar = $('.scrollbar'),
  share = $('#share'),
  share_button = $('.vjs-plus-button div, .audiojs .share, .embed-player-btn'),
  speed, thumb;

  // set photo size
  window.photo_size_setting = function(){
    var container = $('#block');
    var width = container.width();
    var height = container.height() - 26;
    // photo width
    $('#gallery .photo').width(width);
    // gallery and photo height
    $('#gallery').height(height);
    $('#gallery .photo').height(height);
  };

  play_btn.after('    <div class="vjs-slideshow-button vjs-menu-button vjs-control ">'+
                 '<div><span class="vjs-control-text"></span></div>'+
                 '</div>'+

                 '<div class="vjs-next-button vjs-menu-button vjs-control ">'+
                 '<div><span class="vjs-control-text"></span></div>'+
                 '</div>'
                );
  play_btn.before(    '<div class="vjs-prev-button vjs-menu-button vjs-control ">'+
                  '<div><span class="vjs-control-text"></span></div>'+
                  '</div>'
                 );
  controls.append(    '<div class="vjs-plus-button vjs-menu-button vjs-control ">'+
                 '<div><span class="vjs-control-text"></span></div>'+
                 '</div>'
                 );

  window.curr_item = null;

  /*----------- Navigation ------------------*/



  function load_playlist() {
    $('.thumbnail-wrapper').hide();
    intro.fadeOut(500);
    player_nav.fadeIn(500);
    $('.vjs-big-play-button').fadeOut(500);
    wrapper.show();
    playlist_slide('show',playlist);
    wrapper.find('h4').remove();
    wrapper.children('h2').show();

    console.log(myPlayer);

    var isPlaying = !myPlayer.paused();
    if (isPlaying) {
      myPlayer.currentTime(0);
      // myPlayer.pause();
      setTimeout(function(){$('.vjs-loading-spinner').hide()}, 500);
    }
    //        audio.pause();
  }

  function vars(pl)	{
    //
    clearInterval(slideshowTimer);
    $(".vjs-loading-spinner").hide();
    if(window.playlistSetting && window.playlistSetting.music_type == 'Soundcloud') {
      if(typeof soundManager != 'undefined'){
        soundManager.stopAll();
      }
    } else {
      $("#jquery_jplayer_1").jPlayer('stop');
    }
    // stop photo slideshow
    stop_play_image_sideshow($('.vjs-slideshow-button'));// stop play photos sideshow
    //
    share.fadeOut();
    wrapper = $('.thumbnail-wrapper.'+pl);
    wrapper.show();
    thumbs = wrapper.find('.thumbs');
    thumb = thumbs.find('.thumb');
    playlist = wrapper.find('.playlist');
    playlist_thumb = playlist.find('.thumb');

    // item = thumbs.children('div');

    data=0;
    if (data==0) {
      item = playlist;
    } else {
      item = wrapper.find('div[playlist-id='+data+']');
    }
    // console.log('height vars......', item);
    // console.log(scrollbar.height(), item.children('div').height(), item.height());
    scroller.height(scrollbar.height()/(item.children('div').height()/item.height()));
    scroller.css('top', item.scrollTop()/((item.children('div').height()-item.height())/(scrollbar.height()-scroller.height())));
    return wrapper, thumbs, thumb, playlist_thumb, playlist;
  }


  window.myPlayer  = _V_("example_video_1");
  myPlayer.addEvent("play", function(){
    $('.player-master').fadeOut(500);
  });
  myPlayer.addEvent("pause", function(){
    $('.player-master').fadeIn(500);
  });
  //    console.log('-----------------');
  //    console.log(myPlayer);

  window.soundcloud_played = {};

  player_control = {
    play: myPlayer.play,
    pause: myPlayer.pause,
    paused: myPlayer.paused,
    currentTime: myPlayer.currentTime,
    duration: myPlayer.duration,
    muted: myPlayer.muted,
    volume: myPlayer.volume,
    last_video_type: 'general',
    youtube_muted: false
  }

  var a = audiojs.createAll();
  var audio = a[0];
  window.shared_audio = audio;

  soundcloud_control = {
    play: audio.play,
    pause: audio.pause,
    playPause: audio.playPause,
    skipTo: audio.skipTo,
    setVolume: audio.setVolume,
    loadProgress: audio.loadProgress,
    last_audio_type: 'general',
    soundcloudTrackId: null
  }

  //    console.log('-----------------');
  //    console.log(audio);

  $( ".volume" ).slider({
    value: 60,
    orientation: "horizontal",
    range: "min",
    animate: false,
    slide: function( event, ui ) {
      audio.setVolume(parseInt($('.audiojs .volume a').css('left'))*0.02);
      if(parseInt($('.audiojs .volume a').css('left'))*0.02 <0.1) {
        audio.setVolume(0);
      }
    }
  });
  vars('video');

  var data;

  // Audio controls

  $('.play-pause .next').click(function(){
    var next = $('.thumb.awe-play.playing').next();
    $('.thumb.awe-play').removeClass('playing');
    if (!next.length) next = $('.thumbnail-wrapper.audio .thumb.awe-play').first();
    next.click();
    // audio.play();
    return false;
  });
  $('.play-pause .prev').click(function(){
    console.log("--------------------------------");
    var prev = $('.thumb.awe-play.playing').prev();
    $('.thumb.awe-play').removeClass('playing');
    if (!prev.length) prev = $('.thumbnail-wrapper.audio .thumb.awe-play').last();
    prev.click();
    // audio.play();
    return false;
  });

  // Audio controls

  // Share
  share_button.live('click',function(){
    share.fadeToggle();
  });
  $('#share .close').click(function(){
    share.fadeOut();
  });

  $('#share input, #share textarea').click(function(){
    $(this).select();
  })

  // Share
  var loadAndPlay = function() {
    //        console.log('load and play.......');
    myPlayer.play();
  }

  window.soundcloud_settting = {
    onplay: function () {
      console.log('on play...');
      if ($(".audiojs").attr("class").indexOf("playing") == -1) {
        $(".audiojs").addClass('playing');
      }
      $(".audiojs").removeClass('loading');
      //                                                 soundcloud_played[trackId] = this;
      if (!window.soundcloud_play) {
        window.soundcloud_play = function (sound) {
          if (sound.playState == 1 && !sound.paused) {
            var position = parseInt(sound.position / 1000, 10);
            $(".scrubber .progress").width(position * 1000 / sound.durationEstimate * 100 + "%");
            var m = Math.floor(position / 60), s = Math.floor(position % 60);
            $(".time .played").html((m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s);
            setTimeout(function () {
              window.soundcloud_play(sound)
            }, 200);
          }
        }
      }
      window.soundcloud_play(this);
    },
    onresume: function() {
      console.log('resume....');
    },
    onfinish: function () {
      console.log('on fished');
      $(".audiojs").removeClass('playing');
      $(".scrubber .progress").width("0px");
      $(".time .played").html("00:00");
      // $('.play-pause .next').trigger('click');
    },
    onpause: function () {
      $(".audiojs").removeClass('playing');
    },
    whileloading: function () {
      $(".scrubber .loaded").width(this.bytesLoaded / this.bytesTotal * 100 + "%");
      //                                                 console.log('duration....'+this.durationEstimate);
      var time = parseInt(this.durationEstimate / 1000, 10);
      var m = Math.floor(time / 60), s = Math.floor(time % 60);
      $(".time .duration").html((m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s);
    }
  }

  function moveToGeneralPlayer() {
    if(player_control.last_video_type == 'youtube') {
      player_control.last_video_type = 'general';
      myPlayer.play = player_control.play;
      myPlayer.pause = player_control.pause;
      myPlayer.paused = player_control.paused;
      myPlayer.currentTime = player_control.currentTime;
      myPlayer.duration = player_control.duration;
      myPlayer.muted = player_control.muted;
      myPlayer.volume = player_control.volume;
    }
  }

  // open a playlist or a single media
  // just for video and audio
  $.each(['.video', '.audio'], function(i, e) {
    var selector = '.thumbnail-wrapper' + e + ' .thumb';
    $(selector).live('click', function () {
      var elem = $(this);
      // if this is playlist
      if ($(this).parents('.thumbs').hasClass('playlist')) {
        load_videos(elem);
        data = $(this).attr('playlist-id');
        //            store_history(wrapper.attr('class').replace("thumbnail-wrapper ", ""),$(this).attr('playlist-id'));
        if (wrapper.attr('class')) {
          console.log('will save history....');
          store_history(wrapper.attr('class').replace("thumbnail-wrapper ", ""), $(this).attr('playlist-id'));
        }
      } else {
        var playlist_id = (elem.attr('playlist-id') || elem.parents('.thumbs').attr('playlist-id'));
        var playlist_type = elem.parents('.thumbs').attr('playlist-type');
        var item_id = elem.attr('item-id');
        var user_id = elem.parents('.thumbs').attr('user-id');
        var track_id_or_url = elem.attr('href');

        store_history(null, null, {playlist_id: playlist_id, playlist_type: playlist_type,
                      item_id: item_id, user_id: user_id, track_id_or_url: track_id_or_url});

                      load_single_media(playlist_id, playlist_type, item_id, user_id, track_id_or_url);
      }
      if (data == 0) {
        item = playlist;
      } else {
        item = wrapper.find('div[playlist-id=' + data + ']');
      }
      return false;
    });
  });

  // open a photo album as side show
  $('.hey').live('click', function () {
    var elem = $(this);

    var playlist_id = 'photo_album';
    var playlist_type = elem.parents('.thumbs').attr('playlist-type');
    var item_id = elem.attr('item-id');
    var user_id = elem.parents('.thumbs').attr('user-id');
    var track_id_or_url = (elem.attr('playlist-id') || elem.parents('.thumbs').attr('playlist-id'));

    store_history(null, null, {playlist_id: playlist_id, playlist_type: playlist_type,
                  item_id: item_id, user_id: user_id, track_id_or_url: track_id_or_url});

                  load_single_media(playlist_id, playlist_type, item_id, user_id, track_id_or_url);

                  return false;
  });


  var photo_idx = null;
  var photo_count = 0;
  function moveToClickedThumbnail() {
    for(var i=0; i < photo_idx; i++) {
      slide_gallery('right', true);
    }
  }

  // open a photo's  slideshow
  $('.thumbnail-wrapper.photo .thumbs .thumb.photo').live('click', function () {
    var elem = $(this);

    var $children = elem.parent().children();
    photo_idx = $children.index(elem);
    photo_count = $children.length

    var playlist_id = 'photo_playlist';
    var playlist_type = elem.parents('.thumbs').attr('playlist-type');
    var item_id = (elem.attr('playlist-id') || elem.parents('.thumbs').attr('playlist-id'));
    var user_id = elem.parents('.thumbs').attr('user-id');
    var track_id_or_url = elem.attr('href');
    if(item_id == 'album') {
      playlist_id = 'photo_album';
      item_id = elem.attr('item-id');
    }

    store_history(null, null, {playlist_id: playlist_id, playlist_type: playlist_type,
                  item_id: item_id, user_id: user_id, track_id_or_url: track_id_or_url});

                  load_single_media(playlist_id, playlist_type, item_id, user_id, track_id_or_url);

                  return false;
  });


  // open a photo
  $('.thumba').live('click', function () {
    var elem = $(this);

    var playlist_id = 'single_photo';
    var playlist_type = elem.parents('.thumbs').attr('playlist-type');
    var item_id = elem.children('i').css('background-image').replace('url(','').replace(')','');// image_url
    var user_id = elem.parents('.thumbs').attr('user-id');
    var track_id_or_url = null;

    store_history(null, null, {playlist_id: playlist_id, playlist_type: playlist_type,
                  item_id: item_id, user_id: user_id, track_id_or_url: track_id_or_url});

                  load_single_media(playlist_id, playlist_type, item_id, user_id, track_id_or_url);

                  return false;
  });


  var slide = false;
  // photo, album text button click event
  // open the medias in 'folders and files'
  $('.thumbnail-wrapper.photo .thumbs.playlist .thumb, .thumbnail-wrapper.photo .thumbs .thumb.album').live('click', function () {
    console.log('-----', slide)
    slide = true;
    var elem = $(this);
    // if this is playlist
    if (elem.parents('.thumbs').hasClass('playlist')) {
      load_videos(elem);
      data = elem.attr('playlist-id');
      if (wrapper.attr('class')) {
        store_history(wrapper.attr('class').replace("thumbnail-wrapper ", ""), elem.attr('playlist-id'));
      }
    } else {
      // if this is album
      load_media_by_album(elem);
      data = 'album';
    }
    // console.log('data.................', data);
    if (data == 0) {
      item = playlist;
    } else {
      item = wrapper.find('div[playlist-id=' + data + ']');
    }
    slide = true
    return false;
  });

  // load single media(single track video or photo)
  function load_single_media(playlist_id, playlist_type, item_id, user_id, track_id_or_url) {
    $('.vjs-loading-spinner').show();

    $.ajax({
      type: "POST",
      url: "/users/player.php",
      data: ({item_id: item_id, user_id : user_id, playlist_type : playlist_type, playlist_id : playlist_id, track_id_or_url : track_id_or_url}),
      success: function(html){
        var result = $('#result');
        result.html(html);
        $('.vjs-loading-spinner').hide();

        // remove youtube player
        $("#ytapiplayer").remove();
        $("#myytplayer").remove();

        // stop now playing music
        // audio.pause();

        // zero playing video progress
        // if you play video, then quickly play a music, you will see the video playing progress on the music playing page
        // for vjs-controls didnt have class 'vjs-fade-out' yet, you too quickly.
        // If you play a music 5 seconds after playing a video, there will not be this problem
        // This problem was not fixed here, just make the progress to zero, this is necessary, especially when playing another video
        $('.vjs-play-progress').width('1%');
        $('.vjs-seek-handle').css('left', '0%');

        if (playlist_type == 'video') {
          if (playlist_id == 'Youtube' || playlist_id == 'URL_Videos') {
            $(".vjs-volume-level").width('90%');
            $(".vjs-volume-handle").css("left", '80%');
            $('.audiojs').fadeOut(300);

            $("#example_video_1").append("<div id='ytapiplayer'></div>");
            var params = { allowScriptAccess: "always" };
            var atts = { id: "myytplayer" };
            swfobject.embedSWF("http://www.youtube.com/v/"+ result.find('#video_url').html() +"?enablejsapi=1&playerapiid=ytplayer&version=3&autoplay=0&controls=0&autohide=1&color=white&theme=light",
                               "ytapiplayer", "425", "356", "8", null, null, params, atts);

                               $('#gallery').remove();
                               player_master.html(result.find('#video_desc').html());
                               curr_item = 'video';
          } else {
            moveToGeneralPlayer();

            $('.audiojs').fadeOut(300);
            myPlayer.src(result.find('#video_url').html());
            myPlayer.addEvent("loadstart", loadAndPlay);
            $('#gallery').remove();
            player_master.html(result.find('#video_desc').html());
            curr_item = 'video';
          }
          // remove fullscreen button
          resolveFullscreenButtonForPhoto();
        } else if (playlist_type == 'photo'){
          moveToGeneralPlayer();

          $('.audiojs').fadeOut(300);
          curr_item = 'photo';
          progress.width('0px');
          $('.player-master').fadeOut(500);

          if($('#block > #gallery').size() < 1) {
            $('#block .video-js').after(result.html());
          } else {
            $('#block > #gallery').remove();
            $('#block .video-js').after(result.html());
          }

          moveToClickedThumbnail();

          // add fullscreen button
          resolveFullscreenButtonForPhoto();

          // at last, if there is more than one photo then play otherwise dont play
          if($('#result .photo').length > 1) {
            // window.play_image_sideshow($('.vjs-slideshow-button'));
            $('.vjs-slideshow-button').show();
            $('.vjs-prev-button').show();
            $('.vjs-next-button').show();
          } else {
            $('.vjs-slideshow-button').hide();
            $('.vjs-prev-button').hide();
            $('.vjs-next-button').hide();
          }
        } else if (playlist_type == 'audio'){
          window.curr_item = 'audio';
          $('#gallery').remove();// remove playing photos
          player_master.html(result.find('#audio_desc').html()).fadeIn();
          //                    elem.addClass('playing').siblings().removeClass('playing');
          $('.audiojs').fadeIn(300).removeClass('error');

          console.log(result);
          console.log('play sound');
          if (playlist_id == 'Soundcloud') {
            $(".audiojs").addClass('playing').addClass('loading');
            window.setup_soundcloud_player(audio, track_id_or_url);
            audio.play();
          } else {
            window.general_audio_settings(audio, track_id_or_url);
            audio.play();
          }
          // remove fullscreen button
          resolveFullscreenButtonForPhoto();
        }
        //                share.find('textarea').text('<iframe width="730" height="439" src="http://acapellaglobal.com/blendwith/Template/embed.php?'+curr_item+'='+item_id+'" frameborder="0"></iframe>')
        player_nav.fadeOut();
      }
    });
  }

  var audioId = null;
  $(document).on('click', '.thumb.awe-play', function(evt) {
    $('.thumb.awe-play').removeClass('playing');
    $(this).addClass('playing');
  });

  // add fullscreen button for photos
  // delete fullscreen button for photo when playing video
  // run after curr_item is set
  function resolveFullscreenButtonForPhoto() {
    // add photo fullscreen button
    if(curr_item == 'photo' || curr_item == 'video') {
      if($('.vjs-controls').children('.photo-audio-fullscreen-control').length == 0) {
        var photoFullScreen = '<div class="photo-audio-fullscreen-control vjs-menu-button vjs-control " tabindex="0" style="float: right;">'+
          '<div style="width: 16px;height: 16px;background: url(/assets/images/video-js.png) -50px 0;margin: 0.5em auto 0;">' +
          '<span class="vjs-control-text">Fullscreen</span>' +
          '</div>' +
          '</div>';

        $('.vjs-fullscreen-control').before(photoFullScreen);

        $(".photo-audio-fullscreen-control").live('click', function(){
          if (screenfull.enabled) {
            //                        screenfull.toggle(document.getElementById('gallery'));
            screenfull.toggle(document.getElementById('block'));
          }
        });
      }
      return;
    }
    // add audio fullscreen button
    if(curr_item == 'audio') {
      if($('.audiojs').children('.fullscreen').length == 0) {
        var fullScreen = '<div class="fullscreen"></div>';

        $('.audiojs').append(fullScreen);

        $(".audiojs .fullscreen").live('click', function(){
          if (screenfull.enabled) {
            screenfull.toggle(document.getElementById('block'));
          }
        });
      }
    }
  }

  // ------------------ fullscreen event begin ----------------

  // the same is worked on in _player.html.erb when load photos
  function setPhotoSize() {
    if(curr_item == 'photo') {
      if(screenfull.isFullscreen) {
        var width = screen.width;
        var height = screen.height - 26;
      } else {
        var container = $('#block');
        var width = container.width();
        var height = container.height() - 26;
      }
      // photo width
      $('#gallery .photo').width(width);
      // gallery and photo height
      $('#gallery').height(height);
      $('#gallery .photo').height(height);
    }
  }

  if (screenfull.enabled) {
    screenfull.onchange = function() {
      if(screenfull.isFullscreen) {
        window.player_fullscreen_setting();
      } else {
        window.cancel_player_fullscreen_setting();
      }
      if(curr_item == 'photo') {
        stop_play_image_sideshow($('.vjs-slideshow-button'));// stop play photos sideshow
        $('#gallery').scrollLeft(0);// set gallery to the left
        setPhotoSize();// resize photo div size
      }
      // do nothing for video and audio
    };
  }

  // player fullscreen or embed function
  window.player_fullscreen_setting = function() {
    if(screenfull.isFullscreen) {
      var container_height = screen.height;
      var container_width = screen.width;
      //            console.log('+++++++++++++a', container_height);
    } else {
      var container_height = $(window).height();
      var container_width = $(window).width();
      //            console.log('+++++++++++++', container_height);
    }

    window.player_fullscreen_common(container_height, container_width);
  }

  window.player_fullscreen_common = function(container_height, container_width) {
    // set height of the video container
    var height = container_height - 26;
    $("#example_video_1").height(height).width('100%');

    $('#fullscreen_style').remove();

    var fullscreen_style = "<style id='fullscreen_style'>" +
      "#block #thumbnails {" +
      "height: " + height + "px;" +
      "}" +

      "#share {" +
      "height: " + height + "px;" +
      "}" +

      ".thumbnail-wrapper {" +
      "height: " + (height - 20) + "px;" +
      "}" +

      "div.scrollbar {" +
      "height: " + (height - 80) + "px;" +
      "}" +

      "div.thumbnail-wrapper {" +
      "width: " + (container_width - 50 - 40) + "px;" + // left 50(margin), right 40(scroll width/margin)
      "}" +

      "article.bio {" +
      "width: 100%" +
      "}" +

      "section#block {" +
      "width: 100%" +
      "}" +

      "div.thumbnail-wrapper {" +
      "height: 100%" +
      "}" +

      "#block div.thumbnail-wrapper div.thumbs {" +
      "width: 100%;" +
      "height: 90%;" +
      "}" +
      "</style>"

    $('body').append(fullscreen_style);
  }

  // player cancel fullscreen
  window.cancel_player_fullscreen_setting = function() {
    if($("#embed_player_flag").length == 0) {
      $('#fullscreen_style').remove();
      $("#example_video_1").width('730px').height('410px');
    } else {
      $('#fullscreen_style').remove();
      window.player_fullscreen_common(window.embed_player_container_size.height,
                                      window.embed_player_container_size.width);
    }
  }

  fullscreen_play.live('click', function(){
    if (screenfull.enabled) {
      screenfull.toggle(document.getElementById('block'));
    }
  });

  // ------------------ fullscreen event end ----------------

  video_btn.click(function(){
    speed = 300;
    vars('video');
    load_playlist();
    store_history(wrapper.attr('class').replace("thumbnail-wrapper ", ""),'false');
    return false;
  });

  photo_btn.click(function(){
    speed = 300;
    vars('photo');
    load_playlist();
    store_history(wrapper.attr('class').replace("thumbnail-wrapper ", ""),'false');
    return false;
  });

  audio_btn.click(function(){
    speed = 300;
    vars('audio');
    load_playlist();
    store_history(wrapper.attr('class').replace("thumbnail-wrapper ", ""),'false');
    return false;
  });

  home_btn.click(function(){
    share.fadeOut();
    $('.vjs-loading-spinner').hide();
    $('.vjs-big-play-button').hide();
    intro.fadeIn(500);
    player_nav.fadeIn(500);
    myPlayer.pause();
    if(window.playlistSetting && window.playlistSetting.music_type == 'Soundcloud') {
      if(typeof soundManager != 'undefined'){
        soundManager.stopAll();
      }
    } else {
      $("#jquery_jplayer_1").jPlayer('stop');
    }
    return false;
  });

  now_play.click(function(){
    if(curr_item == 'audio') {
      player_nav.fadeOut();
    } else {
      $.jGrowl("There is not music playing", {
        header: '',
        sticky: true,
        theme: 'info'
      });
    }
    return false;
  });

  var history,h=101, his_count=0;
  history = new Object();
  var home = false;

  function store_history(playlist,id,media){
    h--; his_count++;
    history[h]=[playlist, id, media];
    console.log(h,playlist, id)
    curr_hist = 101- his_count;
    home = false;
    return history;
  }

  function navigation(playlist, id, media) {
    vars(playlist);
    data = (id == 'false') ? 0 : id;
    item = wrapper.find('div[playlist-id='+data+']');
    console.log('height navigation......');
    scroller.height(scrollbar.height()/(item.children('div').height()/item.height()));
    load_playlist();
    myPlayer.pause();
    if(media == undefined) {
      if (id == 'false') {} else {
        load_videos(wrapper.find('a[playlist-id='+id+']'));
      }
    } else {
      load_single_media(media.playlist_id, media.playlist_type, media.item_id, media.user_id, media.track_id_or_url)
    }
  }


  var curr_hist=101;
  $('#forward').click(function(){
    console.log('forward', curr_hist, his_count);
    if($.isEmptyObject(history)) {
      return false;
    }
    speed = 0; data=0;
    if (curr_hist < 102-his_count){
      data = history[curr_hist][1];
    }
    else {
      if(home) {
        curr_hist--;
        navigation(history[curr_hist][0],history[curr_hist][1],history[curr_hist][2]);
        home = false;
      } else {
        navigation(history[100][0],history[100][1],history[100][2]);
        home = true;
      }
    }
    return false;

  });

  $('#back').click(function(){
    console.log('back', curr_hist, his_count);
    if($.isEmptyObject(history)) {
      return false;
    }
    speed = 0;data=0;
    curr_hist++;
    if (curr_hist > 100){
      curr_hist=100;
    } else {
      if(home) {
        navigation(history[curr_hist][0],history[curr_hist][1],history[curr_hist][2]);
        home = false;
      } else if (slide) {
        console.log(history);
        navigation(history[curr_hist][0],history[curr_hist][1],history[curr_hist][2]);
        console.log("yes here");
        slide = false;
      } else {
        navigation(history[100][0],history[100][1],history[100][2]);
        home = true;
      }

    }
    return false;
  });



  /*----------- /Navigation ------------------*/

  /*----------- Slider ------------------*/
  var item;

  $('.thumbs').live('mousewheel', function(event, delta, deltaX, deltaY) {
    console.log("wheelDelta...:"+event.originalEvent.wheelDelta);
    //        console.log(scroller.scrollTop());
    if (event.originalEvent.wheelDelta >= 0) {
      console.log('Scroll up');
      if (data==0) {
        item = playlist;
      } else {
        item = wrapper.find('div[playlist-id='+data+']');
      }
      item.stop().animate({'scrollTop': parseInt(parseInt(item.scrollTop())  - item.height())}, {
        duration: 300,
        step: function () {
          scroller.css('top', item.scrollTop() / ((item.children('div').height() - item.height()) / (scrollbar.height() - scroller.height())));
        }
      });
    }
    else {
      console.log('Scroll down');
      var dir = (deltaY == 1 ) ? 'up' : 'down';
      slide_thumb(dir);
    }
    //        console.log(dir, deltaY);
    return false;
  });

  scroller.draggable({
    containment: 'parent',
    drag: function(event, ui){
      if ($.browser.chrome || $.browser.safari || ($.browser.msie && $.browser.version == 7)) {
        ui.position.top += $(window).scrollTop();
      }
      if (data==0) {
        item = playlist;
      } else {
        item = wrapper.find('div[playlist-id='+data+']');
      }
      var scrollTop = parseInt(scroller.css('top'))*((item.children('div').height()-item.height())/(scrollbar.height()-scroller.height()));
      item.scrollTop(scrollTop);
    }
  });

  function slide_thumb(direction) {
    if (data==0) {
      item = playlist;
    } else {
      item = wrapper.find('div[playlist-id='+data+']');
      console.log('this is item..........', item);
    }

    scroller.height(scrollbar.height()/(item.children('div').height()/item.height()));
    var div = item.children('.thumb');
    var scroll = (direction == 'down')?  parseInt(parseInt(item.scrollTop() + item.height())) : parseInt(parseInt(item.scrollTop())  - item.height());

    item.stop().animate({'scrollTop': scroll}, {
      duration: 300,
      step: function () {
        //scroller.css('top', item.scrollTop()/(item.children('a').size()/3*item.children('a').height()/(scrollbar.height()-100)))
        scroller.css('top', item.scrollTop() / ((item.children('div').height() - item.height()) / (scrollbar.height() - scroller.height())));
      },
      complete: function () {
        if(data == 'album') {
          // album doesnt need ajax load
          return;
        }
        if (parseInt(scroller.css('top')) + scroller.height() > scrollbar.height() - 5) {
          //                console.log(window.ajax_loading_media);
          if (!data == 0 && !window.ajax_loading_media) {
            window.ajax_loading_media = true;
            console.log('will show loading...');
            var el = wrapper.find('a[playlist-id=' + data + ']');
            $('.vjs-loading-spinner').show();
            //                    var offset_value = el.attr('offset-value') || 12;
            var offset_value = parseInt($("#offset_value").val(), 10);
            if ($("#youtube_pageToken").length == 0) {
              var pageToken = "";
            } else {
              var pageToken = $("#youtube_pageToken").val();
            }
            $.ajax({
              type: "POST",
              url: "/users/ajax-gallery.php",
              data: ({user_id: el.parents('.playlist').attr('user-id'),
                     playlist_type: el.parents('.playlist').attr('playlist-type'),
                     playlist_id: el.attr('playlist-id'),
                     playlist_title: el.find('h3').text(),
                     offset_value: offset_value,
                     pageToken: pageToken
              }),
              success: function (html) {
                item.children('div').append(html);
                $('.vjs-loading-spinner').hide();
                //                            el.attr('offset-value', Number(offset_value) + 12);
                $("#offset_value").val(offset_value + 12);
                //item = wrapper.find('div[playlist-id='+data+']');
                window.ajax_loading_media = false;
              }
            });
            console.log(item, data)
          }
        }
      }
    });
  }



  function playlist_slide(act, playlist) {
    var pos = (act=="hide")? -(playlist.width()) : 0 ;
    playlist.animate({left:pos},speed);
    if(act=="hide") {} else {
      $('.album-image').hide();
    }
    wrapper.find('.thumbs').not('.playlist').animate({left:pos+playlist.width()},speed, function(){
      if(act=="hide") {
        $('.album-image').show();
      }
    });

  }

  /*----------- /Slider ------------------*/


  /*----------- Photo Slider ------------------*/

  var next = $('.vjs-next-button'),
  prev = $('.vjs-prev-button');



  function slide_gallery(dir, noDelay) {
    wrapper = $('#gallery');
    wrapper.children('div:first').width(wrapper.find('.photo').size()*wrapper.width());
    var scroll = (dir == 'right') ? wrapper.scrollLeft()+wrapper.width() : wrapper.scrollLeft()-wrapper.width();
    console.log('Wrapper', wrapper.width() * photo_count , scroll, wrapper.width() );

    if(window.playlistSetting.transition == 'None') {
      wrapper.scrollLeft(scroll);
    }else if(window.playlistSetting.transition == 'Slide') {
      if((wrapper.width() * photo_count) == scroll) {
        wrapper.scrollLeft(0);
      } else {
        if(noDelay != undefined)
          wrapper.scrollLeft(scroll);
        else
          wrapper.animate({scrollLeft:scroll},300);
      }
    }else if(window.playlistSetting.transition == 'Dissolve') {
      console.log('Dissolve', scroll);
      wrapper.fadeOut(300);
      setTimeout(function(){
        wrapper.scrollLeft(scroll);
        wrapper.fadeIn(500);
      },
      300);
    }
  }

  next.live('click', function(){
    slide_gallery('right');
  });

  prev.live('click', function(){
    slide_gallery('left');
  });


  var slideshowTimer, slideshowTimerFullScreen,
  progress = $('.vjs-play-progress');

  window.play_image_sideshow = function($self) {
    console.log('i will play now.........');
    if(window.playlistSetting.slideShow == 'true') {
      var ss_speed = parseInt(window.playlistSetting.delay, 10) * 1000;
      wrapper = $('#gallery');

      var photo_progress = get_music_play_progress();

      if ($self.hasClass('ss-play')) {
        stop_play_image_sideshow($self);
      } else {
        console.log("here");
        slideshowTimer = setInterval(function(){
          slide_gallery('right');
          photo_progress.animate({width:wrapper.width()},ss_speed, function(){photo_progress.width('0px');});
        }, ss_speed );
        photo_progress.animate({width:wrapper.width()},ss_speed, function(){photo_progress.width(0)});
        $self.addClass('ss-play');
        playBackgroundMusic();// play music
      }
    } else {
      $.jGrowl("Please turn on slide show on this playlist's setting page.", {
        header: 'Slide show is turned off',
        sticky: true,
        theme: 'info'
      });
    }
  }

  // get music play progress
  function get_music_play_progress() {
    if($('#gallery .vjs-play-progress').length == 1) {
      var photo_progress = $('#gallery .vjs-play-progress');
      console.log('YES...#gallery .vjs-play-progress');
    } else {
      var photo_progress = progress;
      //console.log('NO...#gallery .vjs-play-progress');
    }
    return photo_progress;
  }

  // stop play image sideshow
  function stop_play_image_sideshow($playBtn) {
    var photo_progress = get_music_play_progress();
    if ($playBtn.hasClass('ss-play')) {
      $playBtn.removeClass('ss-play');
      clearInterval(slideshowTimer);
      photo_progress.stop().animate({width:'0px'},300);
      stopBackgroundMusic();// stop music
    }
  }

  // play background music
  function playBackgroundMusic() {
    if($('.audiojs').hasClass('playing')) {
      audio.pause();
    }
    if(window.playlistSetting.music_type == 'Soundcloud') {
      SC.stream("/tracks/" + window.playlistSetting.music_url + "/stream",
                function (sound) {
                  soundManager.play(sound.sID, {});
                });
    } else {
      // wait some time to play
      setTimeout(function(){
        $("#jquery_jplayer_1").jPlayer("play", 0);
      }, 300);
    }
  }

  // stop background music
  function stopBackgroundMusic() {
    if(window.playlistSetting.music_type == 'Soundcloud') {
      if(typeof soundManager != 'undefined'){
        soundManager.stopAll();
      }
    } else {
      $("#jquery_jplayer_1").jPlayer("stop");
    }
  }

  play_slideshow.live('click',function(){
    play_image_sideshow($(this));
  });

  /*----------- /Photo Slider ------------------*/

  // load medias from playlist, not only videos but also include music and photos
  function load_videos(el) {
    //        console.log('load');
    $('.vjs-loading-spinner').show();
    $.ajax({
      type: "POST",
      url: "/users/user-gallery.php",
      data: ({user_id : el.parents('.playlist').attr('user-id'),playlist_type : el.parents('.playlist').attr('playlist-type'), playlist_id : el.attr('playlist-id'), playlist_title:el.find('h3').text()}),
      success: function(html){
        wrapper.find('.thumbs').not('.playlist').remove();
        wrapper.children('h2').hide();
        wrapper.append(html);
        $('.vjs-loading-spinner').hide();
        playlist_slide('hide', wrapper.find('.playlist'));
        scroller.css('top', 0);
        item = wrapper.find('div[playlist-id='+data+']');
        scroller.height(scrollbar.height()/(item.children('div').height()/item.height()));
        // console.log('scroller.height', scrollbar.height()/(item.children('div').height()/item.height()));
        // set or reset offset_value
        if($("#offset_value").length == 0) {
          $("body").append('<input type="hidden" id="offset_value" value="12" />');
        } else {
          $("#offset_value").val(12);
        }
      }
    });
  }

  // load media by from one album
  function load_media_by_album(el) {
    $('.vjs-loading-spinner').show();
    console.log(el.parents('.playlist').attr('user-id'));
    console.log('.............');
    $.ajax({
      type: "POST",
      url: "/users/user_gallery_album",
      data: ({user_id : el.parents('.thumbs').attr('user-id'), playlist_type : 'photo', playlist_id : 'album', item_id : el.attr('item-id')}),
      success: function(html){
        wrapper.find('.thumbs').not('.playlist').remove();
        wrapper.children('h2').hide();
        wrapper.append(html);
        $('.vjs-loading-spinner').hide();
        playlist_slide('hide', wrapper.find('.playlist'));
        scroller.css('top', 0);
        item = wrapper.find('div[playlist-id='+data+']');
        scroller.height(scrollbar.height()/(item.children('div').height()/item.height()));
        console.log('scroller.height', scrollbar.height()/(item.children('div').height()/item.height()));
        // set or reset offset_value
        if($("#offset_value").length == 0) {
          $("body").append('<input type="hidden" id="offset_value" value="12" />');
        } else {
          $("#offset_value").val(12);
        }
        moveToClickedThumbnail();
      }
    });
  }

  // show video play control when move mouse
  $('.player-master').live('mousemove', function(){
    if(curr_item == 'video') {
      $('.vjs-controls').removeClass('vjs-fade-out').addClass('vjs-fade-in');
      clearTimeout(window.video_control_hide);
      window.video_control_hide = setTimeout(function(){
        $('.vjs-controls').removeClass('vjs-fade-in').addClass('vjs-fade-out');
      }, 5000);
    }
  });

  //    $('.player-master, #share, .vjs-controls').hover(function(){
  //        console.log('hove....................');
  //        if (curr_item == 'video') {
  //            $('.vjs-controls').removeClass('vjs-fade-out').addClass('vjs-fade-in');
  //            clearTimeout(window.video_control_hide);
  //            window.video_control_hide = setTimeout(function(){
  //                $('.vjs-controls').removeClass('vjs-fade-in').addClass('vjs-fade-out');
  //            }, 5000);
  //        }
  //    }, function(){
  //        if(curr_item == 'video') {
  //            $('.vjs-controls').removeClass('vjs-fade-in').addClass('vjs-fade-out');
  //        }
  //    });

  $('.player-master').click(function(){
    if (curr_item == 'audio') {
      if ($('.audiojs').hasClass('playing')){
        audio.pause();
      } else {
        audio.play();
      }
    } else {
      if(player_control.last_video_type == 'general') {
        myPlayer.play();
      }
    }
  });

});

//

function onYouTubePlayerReady(playerId) {
  console.log('youtube video load...............');
  window.ytplayer = document.getElementById("myytplayer");
  window.ytplayer.addEventListener("onStateChange", "onytplayerStateChange");
  //    console.log("duration:"+window.ytplayer.getDuration());
}

function onytplayerStateChange(newState){
  //    console.log("Player's new state: " + newState);
  //    只要播放器的状态发生更改，系统就会触发此事件。可用的值为未开始 (-1)、已结束 (0)、正在播放 (1)、已暂停 (2)、正在缓冲 (3)、
  //    已插入视频 (5)。在初次载入 SWF 时，该事件会传递未开始 (-1) 事件。在视频插入完毕并可供播放时，该事件会传递已插入视频 (5) 事件。

  // play after load
  if(newState == -1) {
    if(player_control.last_video_type == 'general') {
      player_control.last_video_type = 'youtube';
      myPlayer.play = function() {
        $('.player-master').css('opacity', 0);
        //                console.log('play ********');
        window.ytplayer.playVideo();
        myPlayer.onPlay();
        myPlayer.paused = function() { return false; }
        return this;
      }
      myPlayer.pause = function() {
        $('.player-master').css('opacity', 0.5);
        //                console.log('pause ********');
        window.ytplayer.pauseVideo();
        myPlayer.onPause();
        myPlayer.paused = function() { return true; }
        return this;
      }
      myPlayer.currentTime = function(seconds) {
        if(seconds) {
          //                    console.log('currentTime................................................'+seconds);
          ytplayer.seekTo(seconds, true);
          var currentTime = window.ytplayer.getCurrentTime();
          var duration = window.ytplayer.getDuration();
          $(".vjs-current-time-display").html(_V_.formatTime(currentTime));
          $(".vjs-remaining-time-display").html("-" + _V_.formatTime(duration - currentTime));
        }
        return ytplayer.getCurrentTime() || 0;
      }
      myPlayer.duration = function() {
        return ytplayer.getDuration();
      }
      myPlayer.muted = function(muted) {
        if(muted == true) {
          myPlayer.volume(0);
        }else if(muted == false) {
          myPlayer.volume(1);
        }
        return myPlayer.volume() == 0;
      }
      myPlayer.volume = function(percentAsDecimal) {
        if(percentAsDecimal != undefined) {
          var volume = parseInt(percentAsDecimal * 100);
          ytplayer.setVolume(volume);
          myPlayer.controlBar.volumeControl.volumeBar.update();
          myPlayer.controlBar.muteToggle.update();
        }
        return ytplayer.getVolume() / 100;
      }
    }
    window.myPlayer.play();
  }
  // stop
  if(newState == 0) {
    ytplayer.seekTo(0, true);
    // when the player finishes itself, you can not play the player again with myPlayer.pause() here.
    setTimeout(myPlayer.pause, 0);
    $(".vjs-play-progress").width("1%");
    $(".vjs-seek-handle").css("left", "0%");
  }
  // play
  if(newState == 1) {
    last_play_data.setProcessBar();
  }
}

// for youtube
window.last_play_data = {
  process: 0,
  setProcessBar: function() {
    var currentTime = window.ytplayer.getCurrentTime();
    var duration = window.ytplayer.getDuration();
    var process = currentTime / duration * 100;
    //        console.log('r');
    if(ytplayer.getPlayerState() == 0 || ytplayer.getPlayerState() == 2) {
      return;
    }
    if(process != last_play_data.process) {
      //            console.log('state............:'+ytplayer.getPlayerState()+",...,"+process);
      last_play_data.process = process;
      $(".vjs-play-progress").width((process<=99?process:99)+"%");
      $(".vjs-seek-handle").css("left", (process<2?0:((process>98.8?98.8:process)-1))+"%");
      $(".vjs-current-time-display").html(_V_.formatTime(currentTime));
      $(".vjs-remaining-time-display").html("-" + _V_.formatTime(duration - currentTime));
    }
    setTimeout(last_play_data.setProcessBar, 200);
  }
}

// for soundcloud setting
window.setup_soundcloud_player = function(audio, soundcloudTrackId) {
  soundcloud_control.soundcloudTrackId = soundcloudTrackId;
  if(soundcloud_control.last_audio_type == 'general') {
    soundcloud_control.last_audio_type = 'soundcloud';
    audio.loadProgress = function() {
      this.loadedPercent = 1;
    }
    audio.play = function () {
      console.log('play................');
      if(typeof soundManager != 'undefined'){
        soundManager.stopAll();
      }
      if (soundcloud_played[soundcloud_control.soundcloudTrackId]) {
        soundManager.play(soundcloud_played[soundcloud_control.soundcloudTrackId], soundcloud_settting);
      } else {
        SC.stream("/tracks/" + soundcloud_control.soundcloudTrackId + "/stream",
                  function (sound) {
                    soundcloud_played[soundcloud_control.soundcloudTrackId] = sound.sID;
                    soundManager.play(soundcloud_played[soundcloud_control.soundcloudTrackId], soundcloud_settting);
                  });
      }
    }
    audio.pause = function() {
      console.log('pause................');
      soundManager.pause(soundcloud_played[soundcloud_control.soundcloudTrackId]);
    }
    audio.playPause = function () {
      console.log('play pause.......,'+soundManager.getSoundById(soundcloud_played[soundcloud_control.soundcloudTrackId]).playState);
      console.log('play pause.......,'+soundManager.getSoundById(soundcloud_played[soundcloud_control.soundcloudTrackId]).paused);
      var sound = soundManager.getSoundById(soundcloud_played[soundcloud_control.soundcloudTrackId]);
      if(sound.playState == 0) {
        console.log('play pause play');
        sound.play(soundcloud_settting);
      }else {
        console.log('play pause toggle');
        sound.togglePause();
      }
    }
    audio.skipTo = function (percent) {
      console.log('skip to...,' + percent);
      var sound = soundManager.getSoundById(soundcloud_played[soundcloud_control.soundcloudTrackId]);
      sound.setPosition(sound.durationEstimate * percent);
    }
    audio.setVolume = function (v) {
      console.log('volume....,' + v);
      var sound = soundManager.getSoundById(soundcloud_played[soundcloud_control.soundcloudTrackId]);
      sound.setVolume(parseInt(v*100, 10));
    }
  }
}

window.general_audio_settings = function(audio, track_id) {
  if(soundcloud_control.last_audio_type != 'general') {
    soundcloud_control.last_audio_type = 'general';
    audio.loadProgress = soundcloud_control.loadProgress;
    audio.play = soundcloud_control.play;
    audio.pause = soundcloud_control.pause;
    audio.playPause = soundcloud_control.playPause;
    audio.skipTo = soundcloud_control.skipTo;
    audio.setVolume = soundcloud_control.setVolume;
  }
  audio.load(track_id);
}
