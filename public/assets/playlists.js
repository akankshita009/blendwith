(function(){var t,e,i,n;jQuery(function(){return $(".select").on("click",".awe-plus-sign",function(){return $("#playlist-box-li").show(),$.post("/playlist_box_session",{media_type:t()})}),$(".select").on("keypress",'input[type="text"]',function(t){var e;return 13===t.which?$(this).val().trim().length<1?(alert("Playlist name can't be blank."),$(this).focus(),!1):(e=$(this).closest("form"),$.post(e.attr("action"),e.serialize(),function(t){var e;return e=$(t.result),i(e),$("#recent-li").after(e)},"json"),$(this).val(""),!1):void 0}),$("li.playlist-user-add").live("mouseenter",function(){return $(this).find("a.playlist-setting").show()}),$("li.playlist-user-add").live("mouseleave",function(){return $(this).find("a.playlist-setting").hide()}),$(".playlist-setting").live("click",function(){var t;return t=$(this).prev(),$("#playlist-setting-panel .modal-header input").val(t.attr("data-id")),$("#playlist-setting-panel .modal-body input").val(t.text()),$("#playlist-setting-panel").modal()}),$("#playlist-setting-panel .modal-footer .btn-danger").click(function(){var t,e;return e=confirm("Are you sure you want to delete?"),e?(t=$("#playlist-setting-panel .modal-header input").val(),$.ajax({type:"DELETE",url:"/playlists/"+t}).done(function(){return 0===$("#name-playlist-detail").length?($("#playlist-setting-panel").modal("hide"),$("li[data-id="+t+"]").remove()):window.location=window.location.href.slice(0,+window.location.href.lastIndexOf("/")+1||9e9)})):void 0}),$("#playlist-setting-panel .modal-footer .btn-primary").click(function(){var t,e;return e=$("#playlist-setting-panel .modal-body input").val(),""===e.trim()?(alert("Playlist name can not be empty"),void 0):(t=$("#playlist-setting-panel .modal-header input").val(),$.ajax({type:"PUT",url:"/playlists/"+t,data:{name:e}}).done(function(){return $("#playlist-setting-panel").modal("hide"),$("a[data-id="+t+"]").text(e),$("#name-playlist-detail").html(e)}))})}),e=function(){var t;return t=$("#controller-name-box").val(),-1!==["music_networks"," music_playlists","music_urls","uploaded_audios"].indexOf(t)?"/music_playlists":-1!==["photo_networks","image_playlists","photo_urls albums uploaded_photos"].indexOf(t)?"/image_playlists":"/video_playlists"},t=function(){var t;return t=$("#controller-name-box").val(),-1!==["music_networks","music_playlists","music_urls","uploaded_audios"].indexOf(t)?"music_box":-1!==["photo_networks","image_playlists","photo_urls albums uploaded_photos"].indexOf(t)?"image_box":"video_box"},i=function(t){return t.droppable({accept:".ui-draggable",tolerance:"pointer",over:function(){return $(this).removeClass("out").addClass("over")},out:function(){return $(this).removeClass("over")},drop:function(t,e){var i,s;return $(this).removeClass("over").addClass("droped"),s=$(this).data("id"),i=$(e.draggable),n(s,i.data("type"),i.data("id"),i.data("network"))}})},n=function(t,e,i,n){var s;return s=-1!==["track","music"].indexOf(e)?"/music_playlists/"+t+"/add_item":-1!==["video"].indexOf(e)?"/video_playlists/"+t+"/add_item":-1!==["playlist_album","photo","album"].indexOf(e)?"/image_playlists/"+t+"/add_item":null,s?$.post(s,{type:e,object_id:i,network:n},null,"script"):void 0}}).call(this);