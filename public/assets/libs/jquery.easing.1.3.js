/*
 * jQuery Easing v1.3 - http://gsgd.co.uk/sandbox/jquery/easing/
 *
 * Uses the built in easing capabilities added In jQuery 1.1
 * to offer multiple easing options
 *
 * TERMS OF USE - jQuery Easing
 * 
 * Open source under the BSD License. 
 * 
 * Copyright © 2008 George McGinley Smith
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, 
 * are permitted provided that the following conditions are met:
 * 
 * Redistributions of source code must retain the above copyright notice, this list of 
 * conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list 
 * of conditions and the following disclaimer in the documentation and/or other materials 
 * provided with the distribution.
 * 
 * Neither the name of the author nor the names of contributors may be used to endorse 
 * or promote products derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 *  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED 
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
 * OF THE POSSIBILITY OF SUCH DAMAGE. 
 *
*/
jQuery.easing.jswing=jQuery.easing.swing,jQuery.extend(jQuery.easing,{def:"easeOutQuad",swing:function(t,e,i,n,s){return jQuery.easing[jQuery.easing.def](t,e,i,n,s)},easeInQuad:function(t,e,i,n,s){return n*(e/=s)*e+i},easeOutQuad:function(t,e,i,n,s){return-n*(e/=s)*(e-2)+i},easeInOutQuad:function(t,e,i,n,s){return(e/=s/2)<1?n/2*e*e+i:-n/2*(--e*(e-2)-1)+i},easeInCubic:function(t,e,i,n,s){return n*(e/=s)*e*e+i},easeOutCubic:function(t,e,i,n,s){return n*((e=e/s-1)*e*e+1)+i},easeInOutCubic:function(t,e,i,n,s){return(e/=s/2)<1?n/2*e*e*e+i:n/2*((e-=2)*e*e+2)+i},easeInQuart:function(t,e,i,n,s){return n*(e/=s)*e*e*e+i},easeOutQuart:function(t,e,i,n,s){return-n*((e=e/s-1)*e*e*e-1)+i},easeInOutQuart:function(t,e,i,n,s){return(e/=s/2)<1?n/2*e*e*e*e+i:-n/2*((e-=2)*e*e*e-2)+i},easeInQuint:function(t,e,i,n,s){return n*(e/=s)*e*e*e*e+i},easeOutQuint:function(t,e,i,n,s){return n*((e=e/s-1)*e*e*e*e+1)+i},easeInOutQuint:function(t,e,i,n,s){return(e/=s/2)<1?n/2*e*e*e*e*e+i:n/2*((e-=2)*e*e*e*e+2)+i},easeInSine:function(t,e,i,n,s){return-n*Math.cos(e/s*(Math.PI/2))+n+i},easeOutSine:function(t,e,i,n,s){return n*Math.sin(e/s*(Math.PI/2))+i},easeInOutSine:function(t,e,i,n,s){return-n/2*(Math.cos(Math.PI*e/s)-1)+i},easeInExpo:function(t,e,i,n,s){return 0==e?i:n*Math.pow(2,10*(e/s-1))+i},easeOutExpo:function(t,e,i,n,s){return e==s?i+n:n*(-Math.pow(2,-10*e/s)+1)+i},easeInOutExpo:function(t,e,i,n,s){return 0==e?i:e==s?i+n:(e/=s/2)<1?n/2*Math.pow(2,10*(e-1))+i:n/2*(-Math.pow(2,-10*--e)+2)+i},easeInCirc:function(t,e,i,n,s){return-n*(Math.sqrt(1-(e/=s)*e)-1)+i},easeOutCirc:function(t,e,i,n,s){return n*Math.sqrt(1-(e=e/s-1)*e)+i},easeInOutCirc:function(t,e,i,n,s){return(e/=s/2)<1?-n/2*(Math.sqrt(1-e*e)-1)+i:n/2*(Math.sqrt(1-(e-=2)*e)+1)+i},easeInElastic:function(t,e,i,n,s){var o=1.70158,a=0,r=n;if(0==e)return i;if(1==(e/=s))return i+n;if(a||(a=.3*s),r<Math.abs(n)){r=n;var o=a/4}else var o=a/(2*Math.PI)*Math.asin(n/r);return-(r*Math.pow(2,10*(e-=1))*Math.sin((e*s-o)*2*Math.PI/a))+i},easeOutElastic:function(t,e,i,n,s){var o=1.70158,a=0,r=n;if(0==e)return i;if(1==(e/=s))return i+n;if(a||(a=.3*s),r<Math.abs(n)){r=n;var o=a/4}else var o=a/(2*Math.PI)*Math.asin(n/r);return r*Math.pow(2,-10*e)*Math.sin((e*s-o)*2*Math.PI/a)+n+i},easeInOutElastic:function(t,e,i,n,s){var o=1.70158,a=0,r=n;if(0==e)return i;if(2==(e/=s/2))return i+n;if(a||(a=s*.3*1.5),r<Math.abs(n)){r=n;var o=a/4}else var o=a/(2*Math.PI)*Math.asin(n/r);return 1>e?-.5*r*Math.pow(2,10*(e-=1))*Math.sin((e*s-o)*2*Math.PI/a)+i:.5*r*Math.pow(2,-10*(e-=1))*Math.sin((e*s-o)*2*Math.PI/a)+n+i},easeInBack:function(t,e,i,n,s,o){return void 0==o&&(o=1.70158),n*(e/=s)*e*((o+1)*e-o)+i},easeOutBack:function(t,e,i,n,s,o){return void 0==o&&(o=1.70158),n*((e=e/s-1)*e*((o+1)*e+o)+1)+i},easeInOutBack:function(t,e,i,n,s,o){return void 0==o&&(o=1.70158),(e/=s/2)<1?n/2*e*e*(((o*=1.525)+1)*e-o)+i:n/2*((e-=2)*e*(((o*=1.525)+1)*e+o)+2)+i},easeInBounce:function(t,e,i,n,s){return n-jQuery.easing.easeOutBounce(t,s-e,0,n,s)+i},easeOutBounce:function(t,e,i,n,s){return(e/=s)<1/2.75?n*7.5625*e*e+i:2/2.75>e?n*(7.5625*(e-=1.5/2.75)*e+.75)+i:2.5/2.75>e?n*(7.5625*(e-=2.25/2.75)*e+.9375)+i:n*(7.5625*(e-=2.625/2.75)*e+.984375)+i},easeInOutBounce:function(t,e,i,n,s){return s/2>e?.5*jQuery.easing.easeInBounce(t,2*e,0,n,s)+i:.5*jQuery.easing.easeOutBounce(t,2*e-s,0,n,s)+.5*n+i}});