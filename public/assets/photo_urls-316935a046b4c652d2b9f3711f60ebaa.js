(function(){$(function(){return $("a.awe-trash").click(function(){return $("a.awe-trash").removeClass("selected-media"),$(this).addClass("selected-media")}),$("#demoModal a[type='submit']").click(function(){var t;return t=$("a.awe-trash.selected-media").parent().attr("data-id"),$.ajax({type:"DELETE",url:"/photo_urls/"+t}).done(function(){return $("#demoModal").modal("hide"),window.location=window.location.href})})})}).call(this);