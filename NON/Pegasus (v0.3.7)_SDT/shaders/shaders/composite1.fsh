// © Copyright 2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 




#include "/settings.glsl"
#include "/noise.glsl"


//const float entityShadowDistanceMul = 1.0; //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]


//set the voxelizing distance that isn't culled off-screen
#if VOXEL_AREA == 32
	const float voxelDistance = 32.0;
#endif
#if VOXEL_AREA == 64
	const float voxelDistance = 64.0;
#endif
#if VOXEL_AREA == 128
	const float voxelDistance = 128.0;
#endif
#if VOXEL_AREA == 256
	const float voxelDistance = 256.0;
#endif
#if VOXEL_AREA == 512
	const float voxelDistance = 512.0;
#endif


uniform float frameTimeCounter;
uniform float frameCounter;

#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif

varying vec2 texcoord;
uniform float rainStrength;
uniform float thunderStrength;

#if CLOUDS >= 1 ||  GODRAYS == 1 
	uniform float sunAngle;
#endif

#if CLOUDS >= 1 
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
#endif

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

#if CLOUDS >= 1 
	uniform mat4 gbufferModelView;
	uniform vec3 fogColor;
	uniform vec3 skyColor;
	#if VANILLA_SUNSETS == 0

		uniform float Foggy=0.;

	#endif

	float fogify(float x, float w) {
		return w / (x * x + w);
	}
	#include "/clouds.glsl"

#endif


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



		//get sky
		vec3 color = texture2D(colortex0, texcoord).rgb;

		
	
	 
	#if CLOUDS >= 1 && IS_THE_NETHER != 1
		float depth = get_depth_at( texcoord);
		float cloud_depth = 0.;
		#if CLOUDS >= 3
			vec4 cloudsq = clouds(texcoord,cloud_depth,color);
		#else
			vec4 cloudsq =  depth >= .999*far1? clouds(texcoord,cloud_depth) : vec4(0.);
		#endif
		
		
		color= mix(color,cloudsq.rgb,cloudsq.a);
		//vec3 old_color = texture2D(colortex6, texcoord).rgb;
		//color = depth >= .999*far1? mix(color,old_color,.9) : color;
		
	#endif
	 
	
	


		
	


/* DRAWBUFFERS:6 */
	gl_FragData[0] = vec4(color, 1.0); 
}