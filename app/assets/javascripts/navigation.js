$(document).ready(function () {

    // Menu hiding
    // $('.navbar').affix({
    //	offset: 50
    // });

    $('.form-image').fancybox({
        'transitionIn': 'elastic',
        'transitionOut': 'elastic',
        'speedIn': 300,
        'speedOut': 200,
        'overlayShow': true
    });


    (function() { 

      var url = null;
      $('.awe-cog').click(function(evt) {
        var item = $(this).closest('li');
        var videoId = item.data('id');
        var network = item.data('network');
        url = '/videos/' + videoId + '/preview?network=' + network;

      });

      $('.form-video').click(function(evt) {
        evt.preventDefault();
        $.fancybox({
          'transitionIn': 'elastic',
          'transitionOut': 'elastic',
          'scrolling': 'no',
          'auto': true,
          'speedIn': 300,
          'speedOut': 200,
          'overlayShow': true,
          'href': url,
          'type': 'iframe'
        });
      });

    })();
    

    // Popovers
    $('.demoPopover').popover({
        trigger: 'hover',
        placement: 'left'
    });

    /*------------------------------- Drag items ----------------------------------------*/

    var id, i, checked;

    drag_images($("#thumbnails > li, #thumbnails2 > li"));

    function drag_images(elems) {
        id = [];
        elems.draggable({
            revert: 'invalid',
            appendTo: "body",
            helper: "clone",
            distance: 30,
            start: function () {
                id = [];
                $(".playlists li").removeClass('droped');
                if ($(this).hasClass('checked')) {
                    $('.drag-cont').appendTo($('body > li.ui-draggable'));

                    i = 0;
                    $('.drag-cont > li').each(function () {
                        id.push($(this).attr('id'));
                        i++;
                        return i;
                    });
                    $('.drag-cont .count').remove();
                    $('body > li.ui-draggable .drag-cont li:last').append('<span class="count">' + i + '</span>');
                    var top = 0, left = 0;
                    $('.drag-cont').css('opacity', '1').children('li').each(function () {
                        $(this).css({
                            position: 'absolute',
                            top: top,
                            left: left,
                            margin: 0
                        });

                        if (top <= -20) {
                        } else {
                            top -= 5;
                            left -= 5;
                        }
                    });
                    checked = true;
                } else {

                    id.push($(this).attr('id'));

                }
                return id;
            },
            drag: function () {

            },
            stop: function () {
//                console.log($(this).data('type'));
                $('.drag-cont').appendTo($('body')).css('opacity', '0');
            }
        });


    } // drag_images


    $(".playlists li:not(.no-droppable)").droppable({
        accept: '.ui-draggable',
        tolerance: 'pointer',
        over: function () {
            $(this).removeClass('out').addClass('over');
        },
        out: function () {
            $(this).removeClass('over');
        },
        drop: function (event, ui) {
            $(this).removeClass('over').addClass('droped');
            var playlist_id = $(this).data('id');
            var $ele = $(ui.draggable);
//            console.log(ui.draggable);
            saveAlbumOrImageToPlaylist(playlist_id, $ele.data('type'), $ele.data('id'), $ele.data('network'));

            $.each(id, function (index, val) {
                //$('#'+val).remove();
            });

            if (checked) {
                // $('.drag-cont').html('');
            }

        }
    });

    function saveAlbumOrImageToPlaylist(playlist_id, type, id, network) {
//        console.log(playlist_id, type, id, network);
//        if (network === 'soundcloud') {
//            var path = "/music_playlists/" + playlist_id + "/add_item"
//        } else if (network === 'youtube') {
//            var path = "/video_playlists/" + playlist_id + "/add_item"
//        } else {
//            var path = "/image_playlists/" + playlist_id + "/add_item"
//        }
        if (["track", "music", "track_album"].indexOf(type) != -1) {
            var path = "/music_playlists/" + playlist_id + "/add_item"
        } else if (["video", "video_album"].indexOf(type) != -1) {
            var path = "/video_playlists/" + playlist_id + "/add_item"
        } else if (["playlist_album", "photo", "album"].indexOf(type) != -1) {
            var path = "/image_playlists/" + playlist_id + "/add_item"
        } else {
            var path = null
        }
        if(path) {
            $.post(path, {type: type, object_id: id, network: network}, null, 'script')
        }
    }

    $("#thumbnails li > .thumbnail").live('click', function () {
        if ($(this).prev().attr('checked') == 'checked') {
            $(this).prev().removeAttr('checked');
            $(this).parents('li').removeClass('checked');
            $('.drag-cont #' + $(this).parents('li').attr('id')).remove();

        } else {
            $(this).prev().attr('checked', 'checked');
            $(this).parents('li').addClass('checked');
            $(this).parents('li').clone().appendTo('.drag-cont');

        }
        return false;
    });


    /*------------------------------- Drag items ----------------------------------------*/

    window.form_slide = function(action) {
        if (action == 'show') {
            if ($('.span10.special').css('position') == 'relative') {
                $('.special .content').animate({width: '70%'}, 600, 'easeOutQuint', function () {
                    $(this).removeAttr('style');
                });
                $('div.form').css({width: '31%', top: '-8px'}).animate({right: '0%'}, 600, 'easeOutQuint', function () {
                    $('body').addClass('open-form');
                    $(this).removeAttr('style');
                });
            } else {
                $('.container-fluid[role=main]').animate({right: '22%'}, 600, 'easeOutQuint', function () {
                    $('body').addClass('open-form');
                });
                $('div.form').css({right: 0, position: 'fixed'})
            }
        } else {
          console.log(this);
            if ($('.span10.special').css('position') == 'relative') {
                $('.special .content').animate({width: '100%'}, 600, 'easeOutQuint', function () {
                    $(this).removeAttr('style')
                });
                $('div.form').animate({right: '-32%'}, 600, 'easeOutQuint', function () {
                    $(this).removeAttr('style');
                    $('body').removeClass('open-form');
                });
            } else {
                $('.container-fluid[role=main]').animate({right: '0'}, 600, 'easeOutQuint', function () {
                    $(this).removeAttr('style');
                    $('body').removeClass('open-form');
                });
                $('div.form').css({right: '-23%'})
            }
        }
        return false;
    }

    $('#thumbnails .awe-cog').live('click', function () {
        form_slide('show');
        $("article.span2.special").fadeOut();
    });

    $('div.form .close-form').live('click', function () {
        form_slide('hide');
        $("article.span2.special").fadeIn();
    });

    $('.buttonFinish:not(".buttonDisabled")').live('click', function () {
        $('#wizardModal').removeClass('in').addClass('out').hide();
        $('.modal-backdrop').removeClass('in').addClass('out').hide();
//        console.log($('.buttonFinish'))
    });

    /*------------------------------------ Infinite scroll home-page ------------------------------------------*/

    /*
     $(window).scroll(function(){
     if ($(this).scrollTop() > $('body').height()-$(window).height()-50) {
     $.ajax({
     type: "POST",
     url: "ajax-images.php",
     data: ({}),
     success: function(html){
     $('.loaded-images').append(html);
     drag_images($('.loaded-images > li'));
     $('.loaded-images > li').appendTo('#thumbnails');
     }
     });
     }
     });
     */

    /*------------------------------------ Infinite scroll home-page ------------------------------------------*/

});
