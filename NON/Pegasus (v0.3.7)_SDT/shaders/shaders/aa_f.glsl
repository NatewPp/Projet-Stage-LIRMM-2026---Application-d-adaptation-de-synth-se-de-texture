
// © Copyright 2023 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 



#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif

uniform sampler2D colortex0;


#include "/settings.glsl"

varying vec2 texcoord;


void main() {


			 vec2 texelSize = 1.0/ vec2(viewWidth,viewHeight);

	vec3 color = texture2D(colortex0, texcoord).rgb;
	
	vec3 color1 = texture2D(colortex0, texcoord+texelSize*vec2(1.,0.)).rgb;
vec3 color2 = texture2D(colortex0, texcoord+texelSize*vec2(0.,1.)).rgb;
	vec3 color3 = texture2D(colortex0, texcoord+texelSize*vec2(0.,-1.)).rgb;
	vec3 color4 = texture2D(colortex0, texcoord+texelSize*vec2(-1.,0.)).rgb;
	
		vec3 bloom =max( max(color2,color1),max(color3,color4));
		
	
	

	
	color=max(color,bloom* AA_STRENGTH)  ;
	
	//color=mix(color, vec3(1.,0.,0.), abs(color-bloom)*10.);

/* RENDERTARGETS: 0 */
	gl_FragData[0] = vec4(color, 1.0); 
	
}

// © Copyright 2023 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 
