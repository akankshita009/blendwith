(function(){var t=[].slice;!function(e){var i,n,s,o,a,r,l,h,c,u,d;return o=e.tourbus=function(){var i,n;return i=arguments.length>=1?t.call(arguments,0):[],n=i[0],s.hasOwnProperty(n)?i=i.slice(1):n instanceof e?n="build":"string"==typeof n?(n="build",i[0]=e(i[0])):e.error("Unknown method of $.tourbus --",i),s[n].apply(this,i)},e.fn.tourbus=function(){var i;return i=arguments.length>=1?t.call(arguments,0):[],this.each(function(){return i.unshift(e(this)),o.apply(null,["build"].concat(t.call(i))),this})},s={build:function(t,i){var n;return null==i&&(i={}),i=e.extend(!0,{},o.defaults,i),n=[],t instanceof e||(t=e(t)),t.each(function(){return n.push(l(this,i))}),0===n.length&&e.error(""+t.selector+" was not found!"),1===n.length?n[0]:n},destroyAll:function(){var t,e,i;i=[];for(e in h)t=h[e],i.push(t.destroy());return i},expose:function(t){return t.tourbus={Bus:i,Leg:n}}},o.defaults={debug:!1,autoDepart:!1,target:"body",startAt:0,onDepart:function(){return null},onStop:function(){return null},onLegStart:function(){return null},onLegEnd:function(){return null},leg:{scrollTo:null,scrollSpeed:150,scrollContext:100,orientation:"bottom",align:"left",width:"auto",margin:10,top:null,left:null,arrow:"50%"}},i=function(){function i(t,i){this.id=a(),this.$target=e(i.target),this.$el=e(t),this.$el.data({tourbus:this}),this.options=i,this.currentLegIndex=null,this.legs=null,this.legEls=this.$el.children("li"),this.totalLegs=this.legEls.length,this._setupEvents(),this.options.autoDepart&&this.$el.trigger("depart.tourbus"),this._log("built tourbus with el",""+t,"and options",this.options)}return i.prototype.depart=function(){return this.running=!0,this.options.onDepart(this),this._log("departing",this),this.legs=this._buildLegs(),this.currentLegIndex=this.options.startAt,this.showLeg()},i.prototype.stop=function(){return this.running?(this.legs&&e.each(this.legs,e.proxy(this.hideLeg,this)),this.currentLegIndex=this.options.startAt,this.options.onStop(this),this.running=!1):void 0},i.prototype.on=function(t,e,i){return this.$target.on(t,e,i)},i.prototype.currentLeg=function(){return null===this.currentLegIndex?null:this.legs[this.currentLegIndex]},i.prototype.showLeg=function(t){var e,i;return null==t&&(t=this.currentLegIndex),e=this.legs[t],this._log("showLeg:",e),i=this.options.onLegStart(e,this),i!==!1?e.show():void 0},i.prototype.hideLeg=function(t){var e,i;return null==t&&(t=this.currentLegIndex),e=this.legs[t],this._log("hideLeg:",e),i=this.options.onLegEnd(e,this),i!==!1?e.hide():void 0},i.prototype.repositionLegs=function(){return this.legs?e.each(this.legs,function(){return this.reposition()}):void 0},i.prototype.next=function(){return this.hideLeg(),this.currentLegIndex++,this.currentLegIndex>this.totalLegs-1?this.stop():this.showLeg()},i.prototype.prev=function(){return this.hideLeg(),this.currentLegIndex--,0>this.currentLegIndex?this.stop():this.showLeg()},i.prototype.destroy=function(){return this.legs&&e.each(this.legs,function(){return this.destroy()}),this.legs=null,delete h[this.id],this._teardownEvents()},i.prototype._buildLegs=function(){var t=this;return this.legs&&e.each(this.legs,function(t,e){return e.destroy()}),e.map(this.legEls,function(i,s){var o,a,r;return o=e(i),a=o.data(),r=new n({content:o.html(),target:a.el||"body",bus:t,index:s,rawData:a}),r.render(),t.$target.append(r.$el),r._position(),r.hide(),r})},i.prototype._log=function(){return this.options.debug?console.log.apply(console,["TOURBUS "+this.id+":"].concat(t.call(arguments))):void 0},i.prototype._setupEvents=function(){return this.$el.on("depart.tourbus",e.proxy(this.depart,this)),this.$el.on("stop.tourbus",e.proxy(this.stop,this)),this.$el.on("next.tourbus",e.proxy(this.next,this)),this.$el.on("prev.tourbus",e.proxy(this.prev,this))},i.prototype._teardownEvents=function(){return this.$el.off(".tourbus")},i}(),n=function(){function t(t){if(this.bus=t.bus,this.rawData=t.rawData,this.content=t.content,this.index=t.index,this.options=t,this.$target=e(t.target),0===this.$target.length)throw""+this.$target.selector+" is not an element!";this._setupOptions(),this._configureElement(),this._configureTarget(),this._configureScroll(),this._setupEvents(),this.bus._log("leg "+this.index+" made with options",this.options)}return t.prototype.render=function(){var t,e;return t="centered"===this.options.orientation?"":"tourbus-arrow",this.$el.addClass(" "+t+" tourbus-arrow-"+this.options.orientation+" "),e="<div class='tourbus-leg-inner'>\n  "+this.content+"\n</div>",this.$el.css({width:this.options.width}).html(e),this},t.prototype.destroy=function(){return this.$el.remove(),this._teardownEvents()},t.prototype.reposition=function(){return this._configureTarget(),this._position()},t.prototype._position=function(){var t,e,i,n;return"centered"!==this.options.orientation&&(i={},e={top:"left",bottom:"left",left:"top",right:"top"},"number"==typeof this.options.arrow&&(this.options.arrow+="px"),i[e[this.options.orientation]]=this.options.arrow,n="#"+this.id+".tourbus-arrow",this.bus._log("adding rule for "+this.id,i),r(""+n+":before, "+n+":after",i)),t=this._offsets(),this.bus._log("setting offsets on leg",t),this.$el.css(t)},t.prototype.show=function(){return this.$el.css({visibility:"visible",opacity:1,zIndex:9999}),this.scrollIntoView()},t.prototype.hide=function(){return this.bus.options.debug?this.$el.css({visibility:"visible",opacity:.4,zIndex:0}):this.$el.css({visibility:"hidden"})},t.prototype.scrollIntoView=function(){var t;return this.willScroll?(t=c(this.options.scrollTo,this.$el),this.bus._log("scrolling to",t,this.scrollSettings),e.scrollTo(t,this.scrollSettings)):void 0},t.prototype._setupOptions=function(){var t;return t=this.bus.options.leg,this.options.top=c(this.rawData.top,t.top),this.options.left=c(this.rawData.left,t.left),this.options.scrollTo=c(this.rawData.scrollTo,t.scrollTo),this.options.scrollSpeed=c(this.rawData.scrollSpeed,t.scrollSpeed),this.options.scrollContext=c(this.rawData.scrollContext,t.scrollContext),this.options.margin=c(this.rawData.margin,t.margin),this.options.arrow=this.rawData.arrow||t.arrow,this.options.align=this.rawData.align||t.align,this.options.width=this.rawData.width||t.width,this.options.orientation=this.rawData.orientation||t.orientation},t.prototype._configureElement=function(){return this.id="tourbus-leg-id-"+this.bus.id+"-"+this.options.index,this.$el=e("<div class='tourbus-leg'></div>"),this.el=this.$el[0],this.$el.attr({id:this.id}),this.$el.css({zIndex:9999})},t.prototype._setupEvents=function(){return this.$el.on("click",".tourbus-next",e.proxy(this.bus.next,this.bus)),this.$el.on("click",".tourbus-prev",e.proxy(this.bus.prev,this.bus)),this.$el.on("click",".tourbus-stop",e.proxy(this.bus.stop,this.bus))},t.prototype._teardownEvents=function(){return this.$el.off("click")},t.prototype._configureTarget=function(){return this.targetOffset=this.$target.offset(),c(this.options.top,!1)&&(this.targetOffset.top=this.options.top),c(this.options.left,!1)&&(this.targetOffset.left=this.options.left),this.targetWidth=this.$target.outerWidth(),this.targetHeight=this.$target.outerHeight()},t.prototype._configureScroll=function(){return this.willScroll=e.fn.scrollTo&&this.options.scrollTo!==!1,this.scrollSettings={offset:-this.options.scrollContext,easing:"linear",axis:"y",duration:this.options.scrollSpeed}},t.prototype._offsets=function(){var t,i,n,s,o,a,r,l;switch(n=this.$el.height(),s=this.$el.width(),o={},this.options.orientation){case"centered":r=e(window).height(),o.top=this.options.top,c(o.top,!1)||(o.top=r/2-n/2),o.left=this.targetWidth/2-s/2;break;case"left":o.top=this.targetOffset.top,o.left=this.targetOffset.left-s-this.options.margin;break;case"right":o.top=this.targetOffset.top,o.left=this.targetOffset.left+this.targetWidth+this.options.margin;break;case"top":o.top=this.targetOffset.top-n-this.options.margin,o.left=this.targetOffset.left;break;case"bottom":o.top=this.targetOffset.top+this.targetHeight+this.options.margin,o.left=this.targetOffset.left}if(l={top:["left","right"],bottom:["left","right"],left:["top","bottom"],right:["top","bottom"]},u(this.options.orientation,l[this.options.align]))switch(this.options.align){case"right":o.left+=this.targetWidth-s;break;case"bottom":o.top+=this.targetHeight-n}else"center"===this.options.align&&(u(this.options.orientation,l.left)?(a=this.targetWidth/2,i=s/2,t="left"):(a=this.targetHeight/2,i=n/2,t="top"),a>i?o[t]+=a-i:o[t]-=i-a);return o},t}(),d=0,a=function(){return d++},h={},l=function(){var t;return t=function(t,e,i){i.prototype=t.prototype;var n=new i,s=t.apply(n,e);return Object(s)===s?s:n}(i,arguments,function(){}),h[t.id]=t,t},c=function(t,e){return null===t||void 0===t?e:t},u=function(t,i){return-1!==e.inArray(t,i||[])},r=function(t){var i;return t.type="text/css",document.getElementsByTagName("head")[0].appendChild(t),i=document.styleSheets[document.styleSheets.length-1],function(t,n){var s,o;o=e.map(function(){var t;t=[];for(s in n)t.push(s);return t}(),function(t){return""+t+":"+n[t]}).join(";");try{i.insertRule?i.insertRule(""+t+" { "+o+" }",(i.cssRules||i.rules).length):i.addRule(t,o)}catch(a){}}}(document.createElement("style"))}(jQuery)}).call(this);