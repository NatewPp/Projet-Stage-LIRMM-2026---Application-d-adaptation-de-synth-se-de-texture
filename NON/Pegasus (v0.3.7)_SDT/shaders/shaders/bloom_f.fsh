
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




#if ONION == 1
	uniform sampler2D colortex9;
#endif


varying vec2 texcoord;


void main() {

	

			 vec2 texelSize = 1.0/ vec2(viewWidth,viewHeight);

	
	vec3 color = textureLod(colortex0, texcoord,0).rgb;
	
	#if ANTI_ALIASING >= 2 && BLOOOM_PASS == 1
		{
		vec3 color1 = texture2D(colortex0, texcoord+texelSize*vec2(1.,0.)).rgb;
		vec3 color2 = texture2D(colortex0, texcoord+texelSize*vec2(0.,1.)).rgb;
		vec3 color3 = texture2D(colortex0, texcoord+texelSize*vec2(0.,-1.)).rgb;
		vec3 color4 = texture2D(colortex0, texcoord+texelSize*vec2(-1.,0.)).rgb;
		
		vec3 bloom =max( max(color2,color1),max(color3,color4));

		color=max(color,bloom* AA_STRENGTH)  ;
		}
	#endif
	vec2 b_offset = bloom_texel_size*texelSize*.5*vec2(1.,0.);
	vec3 color1 = textureLod(colortex0, texcoord+texelSize*vec2(1.,1.)*bloom_texel_size + b_offset ,bloom_mip).rgb;
	vec3 color2 = textureLod(colortex0, texcoord+texelSize*vec2(-1.,1.)*bloom_texel_size+ b_offset,bloom_mip).rgb;
	vec3 color3 = textureLod(colortex0, texcoord+texelSize*vec2(1.,-1.)*bloom_texel_size+ b_offset,bloom_mip).rgb;
	vec3 color4 = textureLod(colortex0, texcoord+texelSize*vec2(-1.,-1.)*bloom_texel_size+ b_offset,bloom_mip).rgb;
	
	
		vec3 bloom =

		max( max(color2,color1) , max(color3,color4) )
	

		;
		
	bloom = pow(clamp((bloom-BLOOM_THRESHHOLD)*(1./BLOOM_THRESHHOLD),0.,1.),vec3(.5));
	
	#if BLOOOM_PASS == 3
		 bloom*= 1.5/bloom_mip;
	#else
		bloom*= 2./bloom_mip;
	#endif
   
	
	color=max(color,bloom * BLOOM_STRENGTH1)  ;
	
	//color=mix(vec3(0.), vec3(1.,1.,1.), min(vec3(1.),abs(color-bloom)*11.));

#if ONION == 1
	color = texcoord.x<.2&&texcoord.y<.2? texture2D(colortex9, texcoord*5.).rgb : color;
#endif


/* RENDERTARGETS: 0 */
	gl_FragData[0] = vec4(color, 1.0); 
	
}

// © Copyright 2023 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 
