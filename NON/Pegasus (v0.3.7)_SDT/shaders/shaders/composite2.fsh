// © Copyright 2024-2025 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 




#include "/settings.glsl"
#include "/noise.glsl"

const bool colortex9Clear = false;

#define REFLECTIONS_ARE_IN_RAYDIR 2

uniform float frameTimeCounter;
uniform float frameCounter;

#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif

varying vec2 texcoord;
uniform float rainStrength;
uniform float thunderStrength;


//#if CLOUDS >= 1 ||  GODRAYS == 1 
	uniform float sunAngle;
//#endif

//#if CLOUDS >= 1 
	uniform int worldTime;
	uniform int worldDay;
	#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
	#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
		uniform vec3 shadowLightPosition;
		uniform vec3 sunPosition;
	//include "/clouds.glsl"
	uniform sampler2D colortex6;
	uniform sampler2D colortex9;
//#endif

#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
	uniform sampler2D colortex1;
#endif

#if DEBUG_SHADOWS == 1
	uniform sampler2D shadowcolor0;
#endif




#if WATER_COL_ABSORB >= 2 
	uniform sampler2D colortex5;
	#if WATER_COL_ABSORB >= 2 && REFRACTIONS == 1
		uniform sampler2D colortex6;
	#endif
#else
	uniform sampler2D colortex0;
#endif
		

uniform sampler2D depthtex0;
#if BORDERS >= 2
	uniform sampler2D colortex1;
#endif

uniform float near;
uniform float far;
#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
		uniform float dhFarPlane;
		float far1 = dhFarPlane*DH_FOG_END;
		#else
		float far1 = far;
		#endif
uniform int isEyeInWater;

uniform vec3 focolortex5;
#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif



//#if CLOUDS >= 1 
	uniform mat4 gbufferModelView;
	uniform vec3 fogColor;
	uniform vec3 skyColor;
	#if VANILLA_SUNSETS == 0

		uniform float Foggy=0.;

	#endif

	float fogify(float x, float w) {
		return w / (x * x + w);
	}
	

//#endif

#include "/stuff/fluids/sky_color_h.glsl"

//#if CLOUDS >= 1 
	
	#include "/clouds.glsl"

//#endif

#include "/stuff/onion/mini_onion_h.glsl"

float linearize_depth_cpf(in float d)
{

    // from gl_FragCoord.z to world measurements
    return 2.0 * near  * far / (far + near - (2.0 * d - 1.0) * (far - near));

}


float get_depth_at(vec2 uv)
{
#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
	return texture2D(colortex1,uv).x;
#else
	return linearize_depth_cpf(texture2D(depthtex0,uv).r);
#endif

}

float get_depth_at2(vec2 uv)
{
#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
	float d = texture2D(colortex1,uv).x;
	return
//	abs(d-0.) < 0.01 ? 1. :
	pow(clamp(d/far1,0.,1.),1.);
#else
	float d = texture2D(depthtex0,uv).r;//
	return d >.999 ? 1. : clamp(linearize_depth_cpf(d)/far1,0.,1.);
#endif

}










void main() {



		

		vec3 raydir = vec3(
			texcoord.x*2.-1.,
			1.-distance(texcoord.xy,vec2(.5))*2. ,
			texcoord.y*2.-1. );
		raydir=normalize(raydir);
		
		raydir= screen_float_coords_to_raydir(texcoord);
		
		
		//get sky
		vec3 color = calcSkyColor_w(raydir);//texture2D(colortex0, texcoord).rgb;
		
	
	 
	#if CLOUDS >= 1 && IS_THE_NETHER != 1
		float depth = 1.;//get_depth_at( texcoord);
		float cloud_depth = raydir.z;
		#if CLOUDS >= 3
			vec4 cloudsq = clouds(raydir.xy,cloud_depth,color);
		#else
			vec4 cloudsq =  depth >= .999*far1? clouds(raydir.xy,cloud_depth) : vec4(0.);
		#endif
		
		
		color= mix(color,cloudsq.rgb,cloudsq.a);
	
	#endif
	
	#if CLOUDS >= 1 
		color= mix(color,texture2D(colortex9, texcoord).rgb,.9);
		//color=vec3(0.,0.,1.);//debug
	#endif
	
	//color=fract(vec3( texcoord*10.,0.));//debug sphere grid coordinates
	

/* RENDERTARGETS: 9 */
	gl_FragData[0] = vec4(color, 1.0); 
}