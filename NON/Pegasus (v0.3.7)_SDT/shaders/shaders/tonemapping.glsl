
// © Copyright 2023 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


#include "/settings.glsl"
/*
const bool colortex0MipmapEnabled = true;
*/


#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif

uniform sampler2D colortex0;






varying vec2 texcoord;


void main() {

	

	vec2 texelSize = 1.0/ vec2(viewWidth,viewHeight);

	
	vec3 color = textureLod(colortex0, texcoord,0).rgb;
	
	
	
	color*=5.;
	color = color/(color+1.);
	
	//color=smoothstep(0.,1.,color);
	
	
	color = pow(color,vec3(1.) );
	
//	color.r=smoothstep(0.,1.,color.r);
	
	color = (color-.5)*1.1+.5;
	
	vec3 hue = color-vec3(0.5);
	float lum = (color.r+color.b+color.g)*.33;
	hue*=1.1+lum*1.4;
	color = vec3(0.5)+hue;
	
	color*=.8;
	
	color.rg*= .7+.3*lum;
	color.rgb = mix(color.rgb,pow(color.rgb,vec3(.8,.9,1.)),lum);
	//color = pow(color,vec3( 1.2 ) );
	
//	color=mix(color, smoothstep(0.,1.,color), lum);


/* RENDERTARGETS: 0 */
	gl_FragData[0] = vec4(color, 1.0); 
	
}

// © Copyright 2023 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 
