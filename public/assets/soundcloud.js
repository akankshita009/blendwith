(function(){jQuery(function(){var t;return t={},$(document).on("click",".play",function(e){var i,n,s;return e.preventDefault(),i=$(this),s=$(this).data("trackId"),n="/tracks/"+s+"/stream",t[s]?"Play"===i.text()?(soundManager.play(t[s]),i.text("Stop")):(soundManager.stop(t[s]),i.text("Play")):SC.stream(n,function(e){var n;return e.play(),n=e.sID,t[s]=n,i.text("Stop")})})})}).call(this);