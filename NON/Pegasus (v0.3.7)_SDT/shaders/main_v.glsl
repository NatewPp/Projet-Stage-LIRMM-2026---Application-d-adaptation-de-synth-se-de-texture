//#modified
#include "/settings.glsl"

#if THIS_IS_DISTANT_HORIZONS != 1 && USE_PHYSICS_MOD_OCEAM == 1 
	#define PMODWATERSHDR 1
#endif


	
#if PMODWATERSHDR == 1 
	//uniform int isEyeInWater;
	#include "/stuff/fluids/physics_mod/physics_mod_h.glsl"


	out vec3 physics_localPosition;
	out vec3 physics_foamColor;
	out float physics_localWaviness;
	#if PMOD_SHALLOW_CHK >= 1	
		out float physics_area_depth;
	#endif
	
	#if defined IS_IRIS && defined DISTANT_HORIZONS 
		uniform float far;
	#endif
#endif


#if IS_PARTICLE == 1 && PARTICLES_LPV == 1 && FLOODFILL_LIGHTING > 0
	#if PBR_LPV_EMISSION == 1
		uniform sampler2D specular;
	#endif
	//for hexcasting particle lights
	uniform int renderStage;
	uniform int entityId;
	uniform int currentRenderedItemId;
	uniform mat4 ModelViewInverse;
	layout (r32ui) uniform uimage3D cimage1a;
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

#define INFO_CLICK 0 //[0 1]

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
	//#if TEXTURE_FILTERING_CPF > 0 
		uniform int entityId;
	//#endif
	
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

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec4 viewPos;
#if PBR > 0 || HAND_HELD_TORCH > 0 
	varying vec3 normals_face;
	
#endif
#if PBR > 0
	attribute vec4 at_tangent;
	varying vec4 tangent;
	#if PBR >=2
		
	#endif
#endif
varying float ipbr_id;

#if IS_THE_NETHER == 1 || SHADOWS == 7 || (defined IS_IRIS && ((THIS_IS_DISTANT_HORIZONS == 1 && IS_WATER_SHADER == 1 )|| DH_TEXTURE > 0)) || (IS_WATER_SHADER == 1 && FANCY_WATER > 0)  || PMODWATERSHDR == 1 || IS_WATER_SHADER == 1  || PUDDLES > 0
	varying vec3 world_pos;
	#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif
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
	}
#if POM == 1 || GEN_NORMAL_MAP > 0
#endif





#define VSHSDT
#include "/lib/sdt/SDTmain.glsl"
void main() {
PrepareTextureSynthesisVSH();

	ipbr_id=0.;
	
	//if TEXTURE_FILTERING_CPF > 0
		deconstruct_and_localize_uvs();//CTMPO
	//endif

	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;
	
	
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
	#if IS_THE_NETHER == 1 || SHADOWS == 7 || (defined IS_IRIS && ((THIS_IS_DISTANT_HORIZONS == 1 && IS_WATER_SHADER == 1 )|| DH_TEXTURE > 0)) || (IS_WATER_SHADER == 1 && FANCY_WATER > 0) || PMODWATERSHDR == 1 || IS_WATER_SHADER == 1  || PUDDLES > 0
		 vec4 playerPos = gbufferModelViewInverse * vec4(viewPos.xyz,1.);
		 world_pos=(playerPos//+gbufferModelViewInverse[3]
		 ).xyz+cameraPosition;
	#endif
	
	#if PBR > 0 || HAND_HELD_TORCH > 0 
		normals_face = normalize(gl_NormalMatrix * gl_Normal);
		// (gl_TextureMatrix[1] * gl_MultiTexCoord1-1./32.).x*16./15.);
	#endif
	
	#if PBR > 0
		#if THIS_IS_DISTANT_HORIZONS == 1
			tangent = vec4(normalize(gl_NormalMatrix *at_tangent.rgb),at_tangent.w);
			vec3 c1 = cross(normals_face, vec3(0.0, 0.0, 1.0)); // cross product  z
			vec3 c2 = cross(normals_face, vec3(0.0, 1.0, 0.0)); // cross product  y
			tangent =vec4(normalize( ((length(c1)>length(c2) )? c1 : c2 ) ),1.);
		#else
			tangent = vec4(normalize(gl_NormalMatrix *at_tangent.rgb),at_tangent.w);
		#endif
		
	#endif

	
	#if IS_AN_ENTITY == 1
		
		#if TEXTURE_FILTERING_CPF > 0 
			ipbr_id= float(entityId);
		#endif
	#else
		#if THIS_IS_DISTANT_HORIZONS == 1
			ipbr_id = 30000.;
			ipbr_id= dhMaterialId == DH_BLOCK_LEAVES ? 10001 : ipbr_id;
			#if IS_WATER_SHADER == 1
				ipbr_id= dhMaterialId == DH_BLOCK_WATER ? 10020 : ipbr_id;
			#endif
		#else
			ipbr_id= mc_Entity.x ; 
		#endif

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
			#if !(IS_THE_NETHER == 1 || SHADOWS == 7 || (defined IS_IRIS && ((THIS_IS_DISTANT_HORIZONS == 1 && IS_WATER_SHADER == 1 )|| DH_TEXTURE > 0)) || (IS_WATER_SHADER == 1 && FANCY_WATER > 0)|| PMODWATERSHDR == 1 || IS_WATER_SHADER == 1  || PUDDLES > 0)
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
		viewPos= ipbr_id==10020 ? gbufferModelView* vec4(world_pos.xyz-cameraPosition-vec3(0.,.25,0.),1.) : viewPos;
	#endif
	
	#if PMODWATERSHDR == 1
		if((abs(mc_Entity.x   - 10020)<.5))
		{
			 physics_foamColor = textureLod(physics_lightmap, (mat4(vec4(0.00390625, 0.0, 0.0, 0.0), vec4(0.0, 0.00390625, 0.0, 0.0), vec4(0.0, 0.0, 0.00390625, 0.0), vec4(0.03125, 0.03125, 0.03125, 1.0)) * gl_MultiTexCoord1).xy, 0).rgb;
			physics_localWaviness = texelFetch(physics_waviness, ivec2(gl_Vertex.xz) - physics_textureOffset, 0).r;
			vec4 physics_finalPosition = vec4(gl_Vertex.x, gl_Vertex.y + physics_waveHeight(gl_Vertex.xz, PHYSICS_ITERATIONS_OFFSET, physics_localWaviness, physics_gameTime), gl_Vertex.z, gl_Vertex.w);
			
			
			#if defined IS_IRIS && defined DISTANT_HORIZONS 
				float dist = distance(viewPos.xyz,vec3(0.));
				physics_finalPosition = mix(physics_finalPosition,gl_Vertex,clamp((dist/far-.8)*10.,0.,1.) );

			#else
				physics_finalPosition = physics_finalPosition;
			#endif
			
			physics_localPosition = physics_finalPosition.xyz;
				

			#if PMOD_SHALLOW_CHK >= 1	
				#define PD CRASH_DISTANCE
			 physics_area_depth = max(physics_localWaviness, texelFetch(physics_waviness, ivec2(gl_Vertex.xz) - physics_textureOffset +ivec2(0,PD) , 0).r);
			 physics_area_depth = max(physics_area_depth, texelFetch(physics_waviness, ivec2(gl_Vertex.xz) - physics_textureOffset +ivec2(PD,0) , 0).r);
			 physics_area_depth = max(physics_area_depth, texelFetch(physics_waviness, ivec2(gl_Vertex.xz) - physics_textureOffset +ivec2(-PD,0) , 0).r);
			 physics_area_depth = max(physics_area_depth, texelFetch(physics_waviness, ivec2(gl_Vertex.xz) - physics_textureOffset +ivec2(0,-PD) , 0).r);
			 
			 physics_area_depth = max(physics_area_depth, texelFetch(physics_waviness, ivec2(gl_Vertex.xz) - physics_textureOffset +2*ivec2(0,PD) , 0).r);
			 physics_area_depth = max(physics_area_depth, texelFetch(physics_waviness, ivec2(gl_Vertex.xz) - physics_textureOffset +2*ivec2(PD,0) , 0).r);
			 physics_area_depth = max(physics_area_depth, texelFetch(physics_waviness, ivec2(gl_Vertex.xz) - physics_textureOffset +2*ivec2(-PD,0) , 0).r);
			 physics_area_depth = max(physics_area_depth, texelFetch(physics_waviness, ivec2(gl_Vertex.xz) - physics_textureOffset +2*ivec2(0,-PD) , 0).r);
			 
			 physics_area_depth =  clamp((physics_area_depth*4.),0.,1.);
			#endif

			viewPos = //gbufferModelViewInverse *
			gl_ModelViewMatrix * physics_finalPosition;

		}
	#endif
	
	
	#if IS_PARTICLE == 1  && PARTICLES_LPV == 1 && FLOODFILL_LIGHTING > 0
		if( renderStage == MC_RENDER_STAGE_PARTICLES )
		{
			#include "/voxelizing.glsl"
		}
	#endif
	
	
	gl_Position = gl_ProjectionMatrix * viewPos;
	
	block_centered_relative_pos.w = at_midBlock.w/15.;
	
}