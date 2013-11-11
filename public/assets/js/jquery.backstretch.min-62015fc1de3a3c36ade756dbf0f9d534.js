/*
 * jQuery Backstretch
 * Version 1.2.8
 * http://srobbin.com/jquery-plugins/jquery-backstretch/
 *
 * Add a dynamically-resized background image to the page
 *
 * Copyright (c) 2012 Scott Robbin (srobbin.com)
 * Licensed under the MIT license
 * https://raw.github.com/srobbin/jquery-backstretch/master/LICENSE.txt
 *
*/
!function(t){t.backstretch=function(e,i,n){function s(){if(e){var i;0==r.length?r=t("<div />").attr("id","backstretch").css({left:0,top:0,position:c?"fixed":"absolute",overflow:"hidden",zIndex:-999999,margin:0,padding:0,height:"100%",width:"100%"}):r.find("img").addClass("deleteable"),i=t("<img />").css({position:"absolute",display:"none",margin:0,padding:0,border:"none",zIndex:-999999,maxWidth:"none"}).bind("load",function(e){var i,s=t(this);s.css({width:"auto",height:"auto"}),i=this.width||t(e.target).width(),e=this.height||t(e.target).height(),d=i/e,o(),s.fadeIn(l.speed,function(){r.find(".deleteable").remove(),"function"==typeof n&&n()})}).appendTo(r),0==t("body #backstretch").length&&(0===t(window).scrollTop()&&window.scrollTo(0,0),t("body").append(r)),r.data("settings",l),i.attr("src",e),t(window).unbind("resize.backstretch").bind("resize.backstretch",function(){"onorientationchange"in window&&0===window.pageYOffset&&window.scrollTo(0,1),o()})}}function o(){try{g={left:0,top:0},rootWidth=p=h.width(),rootHeight=u?window.innerHeight:h.height(),f=p/d,f>=rootHeight?(m=(f-rootHeight)/2,l.centeredY&&(g.top="-"+m+"px")):(f=rootHeight,p=f*d,m=(p-rootWidth)/2,l.centeredX&&(g.left="-"+m+"px")),r.css({width:rootWidth,height:rootHeight}).find("img:not(.deleteable)").css({width:p,height:f}).css(g)}catch(t){}}var a={centeredX:!0,centeredY:!0,speed:0},r=t("#backstretch"),l=r.data("settings")||a;r.data("settings");var h,c,u,d,p,f,m,g;return i&&"object"==typeof i&&t.extend(l,i),i&&"function"==typeof i&&(n=i),t(document).ready(function(){var e=window,i=navigator.userAgent,n=navigator.platform,o=i.match(/AppleWebKit\/([0-9]+)/),o=!!o&&o[1],a=i.match(/Fennec\/([0-9]+)/),a=!!a&&a[1],r=i.match(/Opera Mobi\/([0-9]+)/),l=!!r&&r[1],d=i.match(/MSIE ([0-9]+)/),d=!!d&&d[1];h=(c=!((-1<n.indexOf("iPhone")||-1<n.indexOf("iPad")||-1<n.indexOf("iPod"))&&o&&534>o||e.operamini&&"[object OperaMini]"==={}.toString.call(e.operamini)||r&&7458>l||-1<i.indexOf("Android")&&o&&533>o||a&&6>a||"palmGetResource"in window&&o&&534>o||-1<i.indexOf("MeeGo")&&-1<i.indexOf("NokiaBrowser/8.5.0")||d&&6>=d))?t(window):t(document),u=c&&window.innerHeight,s()}),this}}(jQuery);