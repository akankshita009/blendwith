(function(){$(function(){return $("a.awe-trash").click(function(){return $("a.awe-trash").removeClass("selected-media"),$(this).addClass("selected-media")}),$("#demoModal a[type='submit']").click(function(){var t;return t=$("a.awe-trash.selected-media").parent().attr("data-audio-id"),$.ajax({type:"DELETE",url:"/uploaded_audios/"+t}).done(function(){return $("#demoModal").modal("hide"),window.location=window.location.href})}),$("#thumbnails .awe-cog").live("click",function(){var t,e,i,n;return $("div.form input[name='uploaded_audio[title]']").val($(this).parent().find("label").text().trim()),$("div.form input[name='uploaded_audio[artist]']").val($(this).parents("li").attr("data-artist")),$("div.form input[name='uploaded_audio[album]']").val($(this).parents("li").attr("data-album")),$("div.form input[name='uploaded_audio[genre]']").val($(this).parents("li").attr("data-genre")),$("div.form input[name='uploaded_audio[genre]']").val($(this).parents("li").attr("data-genre")),n=$(this).parents("li").attr("data-photo"),"/music_photos/original/missing.png"===n?$("div.form .music_photo").hide():($("div.form .music_photo").attr("src",n),$("div.form .music_photo").show()),t=$(this).closet("li"),e=t.data("id"),$("#caption").val(t.data("title")),$("#tags").val(t.data("tags")),$("div.form form").attr("action","/uploaded_audios/"+e),i=$(this).parent().find("input").val(),$("#cp_jplayer_1").jPlayer("setMedia",{m4a:i}),$("div.form").height($(window).height()-60)})})}).call(this);