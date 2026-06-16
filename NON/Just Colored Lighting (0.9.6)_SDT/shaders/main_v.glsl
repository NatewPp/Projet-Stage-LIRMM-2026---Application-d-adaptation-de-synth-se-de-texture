// © Copyright 2023-2025 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


#include "/settings.glsl"



#if AUTO_HAND_HELD_COLOR_DETECTION >= 0  && HAND_LIGHT_CAPTURE_BACKUP == 1 && IS_HAND == 1
	uniform bool isRightHanded;
	uniform int heldBlockLightValue;
	uniform int heldBlockLightValue2;
	uniform int heldItemId;
	uniform int heldItemId2;
	uniform vec3 eyePosition;

	layout (r32ui) uniform uimage2D cimage_held_light;
	#if AUTO_HAND_HELD_COLOR_DETECTION == 5 
		uniform vec3 playerBodyVector;
		uniform vec3 previousCameraPosition;
	#endif
	#include "/noise.glsl"
#endif

#if ((IS_PARTICLE == 1 && PARTICLES_LPV == 1) || (HAND_LIGHT_CAPTURE_BACKUP == 1 && IS_HAND == 1)) && FLOODFILL_LIGHTING > 0
	#if PBR_LPV_EMISSION == 1
		uniform sampler2D specular;
	#endif
	//for hexcasting particle lights
	uniform int renderStage;
	uniform int entityId;
	uniform int currentRenderedItemId;
	uniform mat4 ModelViewInverse;
	layout (r32ui) uniform uimage3D cimage1;
	uniform float frameTimeCounter;
	uniform int frameCounter;
	uniform sampler2D texture;
	
	layout (rgba8) uniform image3D cimage3_colored_light;
#endif

/*
int dhMaterialId ==
DH_BLOCK_UNKNOWN // Any block not in this list that does not emit light
DH_BLOCK_LEAVES // All types of leaves, bamboo, or cactus
DH_BLOCK_STONE // Stone or ore
DH_BLOCK_WOOD // Any wooden item
DH_BLOCK_METAL // Any block that emits a metal or copper sound.
DH_BLOCK_DIRT // Dirt, grass, podzol, and coarse dirt.
DH_BLOCK_LAVA // Lava.
DH_BLOCK_DEEPSLATE // Deepslate, and all it's forms.
DH_BLOCK_SNOW // Snow.
DH_BLOCK_SAND // Sand and red sand.
DH_BLOCK_TERRACOTTA // Terracotta.
DH_BLOCK_NETHER_STONE // Blocks that have the "base_stone_nether" tag.
DH_BLOCK_WATER // Water...
DH_BLOCK_AIR // Air. This should never be accessible/used.
DH_BLOCK_ILLUMINATED // Any block not in this list that emits light

 THIS_IS_DISTANT_HORIZONS 1

*/


attribute vec4 mc_Entity;
attribute vec4 mc_midTexCoord;

//#define INFO_CLICK 0 //[0 1]

uniform mat4 gbufferModelView;
#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif



	uniform mat4 shadowModelView;
	uniform mat4 shadowProjection;
	uniform vec3 shadowLightPosition;
	varying vec4 shadowPosv;

	#include "/distort.glsl"
#if SHADOWS == 1
#endif


#if IS_AN_ENTITY == 1
	
		uniform int entityId;
	
	
#endif



varying vec2 texcoord;
#if IS_COLOR_WHEEL == 1
    //varying vec4 v_glcolor;
    //varying vec2 v_lmcoord;
#else
    varying vec4 glcolor;
    varying vec2 lmcoord;
#endif
varying vec4 viewPos;
#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif
#if FLOODFILL_LIGHTING >= 1
	//#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif
	in vec4 at_midBlock;

	varying vec4 block_centered_relative_pos;
	varying vec3 foot_pos2;
	//varying vec3 normals_face_world;
	
#endif

#if PBR > 0 || HAND_HELD_TORCH > 0 || FLOODFILL_LIGHTING >= 1
	varying vec3 normals_face;
	
#endif
#if POM > 0 ||  PBR > 0
	attribute vec4 at_tangent;
	varying vec4 tangent;
#endif
#if PBR > 0

	#if PBR >=2
		
	#endif
#endif
varying float ipbr_id;

#if IS_THE_NETHER == 1 || SHADOWS == 7 || (defined IS_IRIS && ((THIS_IS_DISTANT_HORIZONS == 1 && IS_WATER_SHADER == 1 )|| DH_TEXTURE > 0)) || (IS_WATER_SHADER == 1 && FANCY_WATER > 0) || EXTEND_LAVA_PATTERN == 1 || defined VOXY
	varying vec3 world_pos;
	//#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif
#endif

#if USE_MACRO_TEXTURES >= 1 &&   MOB_WORLD_SCALING == 1
	out float face_uv_ratio;
#endif

	varying  vec4 vlocal_uv_components;//CTMPOMFIX
	varying  vec4 vlocal_uv;//CTMPOMFIX
	
	
	//attribute vec4 mc_midTexCoord;//CTMPOMFIX
void deconstruct_and_localize_uvs()//CTMPOMFIX
	{

	
		//use vertex corners of quad to get local coords and components fir reconstruction
	vec2 atlas_uvs = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	//standard get center of quad
	vec2 quad_center= (gl_TextureMatrix[0] *  mc_midTexCoord).st;
	//get center_relative_uvs
	vec2 center_relative_uvs = atlas_uvs.xy-quad_center.xy;
	
	//per vertex local coords 0.0-1.0
	vlocal_uv.st = 0.5 + 0.5 * sign(center_relative_uvs); 
	
	
	//location of uv 0,0 in texture
	vlocal_uv_components.st  = min(atlas_uvs.xy,quad_center-center_relative_uvs);
	
	//size of quad in atlas
	vlocal_uv_components.pq  =  abs(center_relative_uvs)*2.0;

	//cpf temporary flicker fix -(2025-9)
	#define CPF_MARGIN_FLICKER_AMOUNT 0.0001 //[0.0001 0.0005 0.0009 0.001 0.0016 0.002 0.0025 0.003 0.00390625 0.004 0.005 0.006 0.007 0.0078125 0.008 0.009 0.01 0.02]
	vlocal_uv_components.st+=vlocal_uv_components.pq *CPF_MARGIN_FLICKER_AMOUNT;
	vlocal_uv_components.pq  *=1.-2.*CPF_MARGIN_FLICKER_AMOUNT;;
	
	//and in frag shader
	//atlas_uv_for_tex_lookup = fract(local_uv.st)*local_uv_components.pq+local_uv_components.st;
	
		#if USE_MACRO_TEXTURES >= 1 &&   MOB_WORLD_SCALING == 1
		    vec2 a_center_relative_uvs= abs(center_relative_uvs);
			face_uv_ratio = a_center_relative_uvs.x/a_center_relative_uvs.y;//*sign(center_relative_uvs.x);
		#endif
	
	}
#if POM == 1 || GEN_NORMAL_MAP > 0
#endif

#ifdef IRIS_FEATURE_FADE_VARIABLE  
    #if IS_TERRAIN == 1 && CHUNK_FADE == 1
         // in float mc_chunkFade;
         out float chunk_fade;
    #endif
#endif




#define VSHSDT
#include "/lib/sdt/SDTmain.glsl"
void main() {
    #ifdef IRIS_FEATURE_FADE_VARIABLE  
         #if IS_TERRAIN == 1 && CHUNK_FADE == 1
            // in float mc_chunkFade;
            chunk_fade =  1.-mc_chunkFade;
        #endif
    #endif
	
	//if TEXTURE_FILTERING_CPF > 0
		deconstruct_and_localize_uvs();//CTMPO
	//endif

	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;


	
    #if IS_COLOR_WHEEL == 1
       //v_glcolor = gl_Color;
       //v_lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    #else
        glcolor = gl_Color;
        lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    #endif
	
	#if FLOODFILL_LIGHTING >= 1
		
		//positions
		vec3 view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
		vec3 foot_pos = (gbufferModelViewInverse * vec4( view_pos ,1.) ).xyz;
		//vec3 world_pos = foot_pos + cameraPosition;
		
		//for reconstructing in fragment shader
		foot_pos2 = foot_pos;
		normals_face = normalize(gl_NormalMatrix * gl_Normal);
		//normals_face_world = (gbufferModelViewInverse * vec4( normals_face ,1.) ).xyz;
		
		//voxel map position
		#define VOXEL_RADIUS (VOXEL_AREA/2)
		block_centered_relative_pos.xyz = foot_pos + at_midBlock.xyz/64.0 +fract(cameraPosition);
		ivec3 voxel_pos = ivec3(block_centered_relative_pos.xyz + VOXEL_RADIUS);
	#endif
		
	

	 viewPos = vec4((gl_ModelViewMatrix * gl_Vertex).xyz,1.);
	#if IS_THE_NETHER == 1 || SHADOWS == 7 || (defined IS_IRIS && ((THIS_IS_DISTANT_HORIZONS == 1 && IS_WATER_SHADER == 1 )|| DH_TEXTURE > 0)) || (IS_WATER_SHADER == 1 && FANCY_WATER > 0)  || EXTEND_LAVA_PATTERN == 1 || defined VOXY
		 vec4 playerPos = gbufferModelViewInverse * viewPos;
		 world_pos=(playerPos//+gbufferModelViewInverse[3]
		 ).xyz+cameraPosition;
	#endif
	
	#if POM > 0 ||  PBR > 0
		tangent = vec4(normalize(gl_NormalMatrix *at_tangent.rgb),at_tangent.w);
	#endif

	
	#if IS_AN_ENTITY == 1
		
		ipbr_id= float(entityId);
	#else
		#if THIS_IS_DISTANT_HORIZONS == 1
			ipbr_id = 30000.;
			ipbr_id= dhMaterialId == DH_BLOCK_LAVA ? 10032 :  dhMaterialId == DH_BLOCK_LEAVES ? 10001 : ipbr_id;
			
			#if IS_WATER_SHADER == 1
				ipbr_id= dhMaterialId == DH_BLOCK_WATER ? 10020 : ipbr_id;
			#endif
		#else
			ipbr_id= mc_Entity.x ; 
		#endif

	#endif
	



	
	
	#if PBR > 0 || HAND_HELD_TORCH > 0 
		normals_face = normalize(gl_NormalMatrix * gl_Normal);
		// (gl_TextureMatrix[1] * gl_MultiTexCoord1-1./32.).x*16./15.);
	#endif
	#if PBR > 0	
		float lightDot = dot(normalize(shadowLightPosition), normals_face.xyz);
	#else
		float lightDot = dot(normalize(shadowLightPosition), normalize(gl_NormalMatrix * gl_Normal));
	#endif
	 
		
		#if BACK_LIT_GRASS > 0
			//when EXCLUDE_FOLIAGE is enabled, act as if foliage is always facing towards the sun.
			//in other words, don't darken the back side of it unless something else is casting a shadow on it.
			if (mc_Entity.x == 10000.0) lightDot = max(lightDot,float(BACK_LIT_GRASS)*.1);
		#endif
		
	#if SHADOWS >= 1
		
	

		
		//if (lightDot > 0.0)
		{ //vertex is facing towards the sun
			#if !(IS_THE_NETHER == 1 || SHADOWS == 7 || (defined IS_IRIS && ((THIS_IS_DISTANT_HORIZONS == 1 && IS_WATER_SHADER == 1 )|| DH_TEXTURE > 0)) || (IS_WATER_SHADER == 1 && FANCY_WATER > 0))
				 vec4 playerPos = gbufferModelViewInverse * viewPos;
			#endif
			shadowPosv = shadowProjection * (shadowModelView * playerPos); //convert to shadow ndc space.
			float bias = computeBias(shadowPosv.xyz);
			shadowPosv.xyz = distort(shadowPosv.xyz); //apply shadow distortion
			shadowPosv.xyz = shadowPosv.xyz * 0.5 + 0.5; //convert from -1 ~ +1 to 0 ~ 1
			//apply shadow bias.
			#ifdef NORMAL_BIAS
				//we are allowed to project the normal because shadowProjection is purely a scalar matrix.
				//a faster way to apply the same operation would be to multiply by shadowProjection[0][0].
				vec4 normal = shadowProjection * vec4(mat3(shadowModelView) * (mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal)), 1.0);
				shadowPosv.xyz += normal.xyz / normal.w * bias;
			#else
				shadowPosv.z -= bias / abs(lightDot);
			#endif
		}
	
	
	#endif
		shadowPosv.w = lightDot;
		

	#if THIS_IS_DISTANT_HORIZONS == 1 && IS_WATER_SHADER == 1
		
		viewPos= ipbr_id==10020 || ipbr_id==10021 ? gbufferModelView* vec4(world_pos.xyz-cameraPosition-vec3(0.,.15,0.),1.) : viewPos;
	#endif
	
	vec4 g_pos = gl_ProjectionMatrix * viewPos;;



	#if ((IS_PARTICLE == 1 && PARTICLES_LPV == 1 && IS_WEATHER!= 1) || (HAND_LIGHT_CAPTURE_BACKUP == 1 && IS_HAND == 1)) && FLOODFILL_LIGHTING > 0
	
		#if !(HAND_LIGHT_CAPTURE_BACKUP == 1 && IS_HAND == 1) 
			if( renderStage == MC_RENDER_STAGE_PARTICLES )
		#endif
		#if (IS_HAND == 1 && VOXELIZE_PLAYER == 0)
		#else
		{
			#include "/voxelizing.glsl"
		}
		#endif
	#endif
	
	gl_Position = g_pos;
	
	//glcolor = g_pos.x<-.5? vec4(1.,0.,0.,1.) :  g_pos.x>.5? vec4(0.,1.,0.,1.): glcolor;//debug
	

	
	block_centered_relative_pos.w = at_midBlock.w/15.;
	

}
