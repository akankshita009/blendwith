window.Modernizr=function(t,e,i){function n(t){b.cssText=t}function s(t,e){return n(_.join(t+";")+(e||""))}function o(t,e){return typeof t===e}function a(t,e){return!!~(""+t).indexOf(e)}function r(t,e){for(var n in t){var s=t[n];if(!a(s,"-")&&b[s]!==i)return"pfx"==e?s:!0}return!1}function l(t,e,n){for(var s in t){var a=e[t[s]];if(a!==i)return n===!1?t[s]:o(a,"function")?a.bind(n||e):a}return!1}function h(t,e,i){var n=t.charAt(0).toUpperCase()+t.slice(1),s=(t+" "+x.join(n+" ")+n).split(" ");return o(e,"string")||o(e,"undefined")?r(s,e):(s=(t+" "+k.join(n+" ")+n).split(" "),l(s,e,i))}var c,u,d,p="2.6.2",f={},m=!0,g=e.documentElement,v="modernizr",y=e.createElement(v),b=y.style,_=({}.toString," -webkit- -moz- -o- -ms- ".split(" ")),w="Webkit Moz O ms",x=w.split(" "),k=w.toLowerCase().split(" "),C={},D=[],T=D.slice,S={}.hasOwnProperty;d=o(S,"undefined")||o(S.call,"undefined")?function(t,e){return e in t&&o(t.constructor.prototype[e],"undefined")}:function(t,e){return S.call(t,e)},Function.prototype.bind||(Function.prototype.bind=function(t){var e=this;if("function"!=typeof e)throw new TypeError;var i=T.call(arguments,1),n=function(){if(this instanceof n){var s=function(){};s.prototype=e.prototype;var o=new s,a=e.apply(o,i.concat(T.call(arguments)));return Object(a)===a?a:o}return e.apply(t,i.concat(T.call(arguments)))};return n}),C.rgba=function(){return n("background-color:rgba(150,255,150,.5)"),a(b.backgroundColor,"rgba")},C.borderradius=function(){return h("borderRadius")},C.boxshadow=function(){return h("boxShadow")},C.textshadow=function(){return""===e.createElement("div").style.textShadow},C.opacity=function(){return s("opacity:.55"),/^0.55$/.test(b.opacity)},C.cssgradients=function(){var t="background-image:",e="gradient(linear,left top,right bottom,from(#9f9),to(white));",i="linear-gradient(left top,#9f9, white);";return n((t+"-webkit- ".split(" ").join(e+t)+_.join(i+t)).slice(0,-t.length)),a(b.backgroundImage,"gradient")};for(var P in C)d(C,P)&&(u=P.toLowerCase(),f[u]=C[P](),D.push((f[u]?"":"no-")+u));return f.addTest=function(t,e){if("object"==typeof t)for(var n in t)d(t,n)&&f.addTest(n,t[n]);else{if(t=t.toLowerCase(),f[t]!==i)return f;e="function"==typeof e?e():e,"undefined"!=typeof m&&m&&(g.className+=" "+(e?"":"no-")+t),f[t]=e}return f},n(""),y=c=null,function(t,e){function i(t,e){var i=t.createElement("p"),n=t.getElementsByTagName("head")[0]||t.documentElement;return i.innerHTML="x<style>"+e+"</style>",n.insertBefore(i.lastChild,n.firstChild)}function n(){var t=v.elements;return"string"==typeof t?t.split(" "):t}function s(t){var e=g[t[f]];return e||(e={},m++,t[f]=m,g[m]=e),e}function o(t,i,n){if(i||(i=e),c)return i.createElement(t);n||(n=s(i));var o;return o=n.cache[t]?n.cache[t].cloneNode():p.test(t)?(n.cache[t]=n.createElem(t)).cloneNode():n.createElem(t),o.canHaveChildren&&!d.test(t)?n.frag.appendChild(o):o}function a(t,i){if(t||(t=e),c)return t.createDocumentFragment();i=i||s(t);for(var o=i.frag.cloneNode(),a=0,r=n(),l=r.length;l>a;a++)o.createElement(r[a]);return o}function r(t,e){e.cache||(e.cache={},e.createElem=t.createElement,e.createFrag=t.createDocumentFragment,e.frag=e.createFrag()),t.createElement=function(i){return v.shivMethods?o(i,t,e):e.createElem(i)},t.createDocumentFragment=Function("h,f","return function(){var n=f.cloneNode(),c=n.createElement;h.shivMethods&&("+n().join().replace(/\w+/g,function(t){return e.createElem(t),e.frag.createElement(t),'c("'+t+'")'})+");return n}")(v,e.frag)}function l(t){t||(t=e);var n=s(t);return v.shivCSS&&!h&&!n.hasCSS&&(n.hasCSS=!!i(t,"article,aside,figcaption,figure,footer,header,hgroup,nav,section{display:block}mark{background:#FF0;color:#000}")),c||r(t,n),t}var h,c,u=t.html5||{},d=/^<|^(?:button|map|select|textarea|object|iframe|option|optgroup)$/i,p=/^(?:a|b|code|div|fieldset|h1|h2|h3|h4|h5|h6|i|label|li|ol|p|q|span|strong|style|table|tbody|td|th|tr|ul)$/i,f="_html5shiv",m=0,g={};!function(){try{var t=e.createElement("a");t.innerHTML="<xyz></xyz>",h="hidden"in t,c=1==t.childNodes.length||function(){e.createElement("a");var t=e.createDocumentFragment();return"undefined"==typeof t.cloneNode||"undefined"==typeof t.createDocumentFragment||"undefined"==typeof t.createElement}()}catch(i){h=!0,c=!0}}();var v={elements:u.elements||"abbr article aside audio bdi canvas data datalist details figcaption figure footer header hgroup mark meter nav output progress section summary time video",shivCSS:u.shivCSS!==!1,supportsUnknownElements:c,shivMethods:u.shivMethods!==!1,type:"default",shivDocument:l,createElement:o,createDocumentFragment:a};t.html5=v,l(e)}(this,e),f._version=p,f._prefixes=_,f._domPrefixes=k,f._cssomPrefixes=x,f.testProp=function(t){return r([t])},f.testAllProps=h,g.className=g.className.replace(/(^|\s)no-js(\s|$)/,"$1$2")+(m?" js "+D.join(" "):""),f}(this,this.document),function(t,e,i){function n(t){return"[object Function]"==g.call(t)}function s(t){return"string"==typeof t}function o(){}function a(t){return!t||"loaded"==t||"complete"==t||"uninitialized"==t}function r(){var t=v.shift();y=1,t?t.t?f(function(){("c"==t.t?d.injectCss:d.injectJs)(t.s,0,t.a,t.x,t.e,1)},0):(t(),r()):y=0}function l(t,i,n,s,o,l,h){function c(e){if(!p&&a(u.readyState)&&(b.r=p=1,!y&&r(),u.onload=u.onreadystatechange=null,e)){"img"!=t&&f(function(){w.removeChild(u)},50);for(var n in T[i])T[i].hasOwnProperty(n)&&T[i][n].onload()}}var h=h||d.errorTimeout,u=e.createElement(t),p=0,g=0,b={t:n,s:i,e:o,a:l,x:h};1===T[i]&&(g=1,T[i]=[]),"object"==t?u.data=i:(u.src=i,u.type=t),u.width=u.height="0",u.onerror=u.onload=u.onreadystatechange=function(){c.call(this,g)},v.splice(s,0,b),"img"!=t&&(g||2===T[i]?(w.insertBefore(u,_?null:m),f(c,h)):T[i].push(u))}function h(t,e,i,n,o){return y=0,e=e||"j",s(t)?l("c"==e?k:x,t,e,this.i++,i,n,o):(v.splice(this.i++,0,t),1==v.length&&r()),this}function c(){var t=d;return t.loader={load:h,i:0},t}var u,d,p=e.documentElement,f=t.setTimeout,m=e.getElementsByTagName("script")[0],g={}.toString,v=[],y=0,b="MozAppearance"in p.style,_=b&&!!e.createRange().compareNode,w=_?p:m.parentNode,p=t.opera&&"[object Opera]"==g.call(t.opera),p=!!e.attachEvent&&!p,x=b?"object":p?"script":"img",k=p?"script":x,C=Array.isArray||function(t){return"[object Array]"==g.call(t)},D=[],T={},S={timeout:function(t,e){return e.length&&(t.timeout=e[0]),t}};d=function(t){function e(t){var e,i,n,t=t.split("!"),s=D.length,o=t.pop(),a=t.length,o={url:o,origUrl:o,prefixes:t};for(i=0;a>i;i++)n=t[i].split("="),(e=S[n.shift()])&&(o=e(o,n));for(i=0;s>i;i++)o=D[i](o);return o}function a(t,s,o,a,r){var l=e(t),h=l.autoCallback;l.url.split(".").pop().split("?").shift(),l.bypass||(s&&(s=n(s)?s:s[t]||s[a]||s[t.split("/").pop().split("?")[0]]),l.instead?l.instead(t,s,o,a,r):(T[l.url]?l.noexec=!0:T[l.url]=1,o.load(l.url,l.forceCSS||!l.forceJS&&"css"==l.url.split(".").pop().split("?").shift()?"c":i,l.noexec,l.attrs,l.timeout),(n(s)||n(h))&&o.load(function(){c(),s&&s(l.origUrl,r,a),h&&h(l.origUrl,r,a),T[l.url]=2})))}function r(t,e){function i(t,i){if(t){if(s(t))i||(u=function(){var t=[].slice.call(arguments);d.apply(this,t),p()}),a(t,u,e,0,h);else if(Object(t)===t)for(l in r=function(){var e,i=0;for(e in t)t.hasOwnProperty(e)&&i++;return i}(),t)t.hasOwnProperty(l)&&(!i&&!--r&&(n(u)?u=function(){var t=[].slice.call(arguments);d.apply(this,t),p()}:u[l]=function(t){return function(){var e=[].slice.call(arguments);t&&t.apply(this,e),p()}}(d[l])),a(t[l],u,e,l,h))}else!i&&p()}var r,l,h=!!t.test,c=t.load||t.both,u=t.callback||o,d=u,p=t.complete||o;i(h?t.yep:t.nope,!!c),c&&i(c)}var l,h,u=this.yepnope.loader;if(s(t))a(t,0,u,0);else if(C(t))for(l=0;l<t.length;l++)h=t[l],s(h)?a(h,0,u,0):C(h)?d(h):Object(h)===h&&r(h,u);else Object(t)===t&&r(t,u)},d.addPrefix=function(t,e){S[t]=e},d.addFilter=function(t){D.push(t)},d.errorTimeout=1e4,null==e.readyState&&e.addEventListener&&(e.readyState="loading",e.addEventListener("DOMContentLoaded",u=function(){e.removeEventListener("DOMContentLoaded",u,0),e.readyState="complete"},0)),t.yepnope=c(),t.yepnope.executeStack=r,t.yepnope.injectJs=function(t,i,n,s,l,h){var c,u,p=e.createElement("script"),s=s||d.errorTimeout;p.src=t;for(u in n)p.setAttribute(u,n[u]);i=h?r:i||o,p.onreadystatechange=p.onload=function(){!c&&a(p.readyState)&&(c=1,i(),p.onload=p.onreadystatechange=null)},f(function(){c||(c=1,i(1))},s),l?p.onload():m.parentNode.insertBefore(p,m)},t.yepnope.injectCss=function(t,i,n,s,a,l){var h,s=e.createElement("link"),i=l?r:i||o;s.href=t,s.rel="stylesheet",s.type="text/css";for(h in n)s.setAttribute(h,n[h]);a||(m.parentNode.insertBefore(s,m),f(i,0))}}(this,document),Modernizr.load=function(){yepnope.apply(window,[].slice.call(arguments,0))};