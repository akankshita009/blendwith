(function(){$(function(){return $(".video-thumb").live("click",function(){var t,e,i,n;return t=$(this).parents("li").attr("data-network"),"youtube_url"===t||"youtube"===t?("youtube_url"===t&&(i=$(this).parent().attr("data-id")),"youtube"===t&&(i=$(this).parent().attr("data-video-id")),$(this).hide(),n="a_"+Math.floor(1e8*Math.random()+1),$(this).before("<div style='width: 100%;height: 175px;margin-bottom: 10px;'><video id='"+n+"' src='' class='video-js vjs-default-skin' controls preload='auto' width='260' height='175' ></video></div>"),e="http://www.youtube.com/v/"+i+"?enablejsapi=1&playerapiid=ytplayer&autoplay=1",videojs(""+n,{techOrder:["youtube"],src:e},function(){return this.play()})):"uploaded_video"===t?($(this).hide(),e=$(this).parents("li").attr("data-video-url"),n="a_"+Math.floor(1e8*Math.random()+1),$(this).before("<div style='width: 100%;height: 175px;margin-bottom: 10px;'><video id='"+n+"' src='"+e+"' class='video-js vjs-default-skin' controls preload='auto' width='260' height='175' ></video></div>"),videojs(""+n,{},function(){return this.play()})):void 0}),$("a.awe-trash").click(function(){return $("a.awe-trash").removeClass("selected-media"),$(this).addClass("selected-media")}),$("#demoModal a[type='submit']").click(function(){var t;return t=$("a.awe-trash.selected-media").parents("li").attr("data-item-id"),$.ajax({type:"DELETE",data:{item_id:t},url:"/video_playlists/delete_item"}).done(function(){return $("#demoModal").modal("hide"),window.location=window.location.href})})})}).call(this);