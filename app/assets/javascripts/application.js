// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require libs/jquery
//= require jquery_ujs
//= require jquery-ui
//= require libs/jquery.easing.1.3
//= require plugins/jquery.fancybox-1.3.4.pack
//= require libs/modernizr
//= require libs/selectivizr
//= require bootstrap/bootstrap
//= require navigation
//= require ruby.developer
//= require plugins/jquery.jplayer.min
//= require plugins/circle.player
//= require plugins/jquery.grab
//= require plugins/jquery.transform2d
//= require plugins/mod.csstransforms.min
//= require plugins/jGrowl/jquery.jgrowl

$(function(){
    if($('article.span2.special').length == 1) {
        $('article.span2.special div.select ul.playlists').css('max-height', $(window).height() - 55 - 250);
    }
})

function clear_message() {
    // this message is for fading alert message
    clearTimeout(window.timeoutForMessage);
    window.timeoutForMessage = setTimeout("$('#flash').html(' ');", 5000);
}

function show_msg_common(content, type){
    var str = '<div class="'+type+'">';
    str += '<p>'
    str += content;
    str += '</p>'
    str += '</div>'
    $('#flash').html(str);
    clear_message();
}

function show_error(content) {
    show_msg_common(content, "error");
}

function show_warn(content) {
    show_msg_common(content, "warn");
}

function show_notice(content) {
    show_msg_common(content, "notice");
}

$(".tourbus-stop").click(function() {
  $.ajax({
    type: "GET",
    url: "/tour/update",
    contentType: "application/json; charset=utf-8",
    dataType: "json"
  });
});

