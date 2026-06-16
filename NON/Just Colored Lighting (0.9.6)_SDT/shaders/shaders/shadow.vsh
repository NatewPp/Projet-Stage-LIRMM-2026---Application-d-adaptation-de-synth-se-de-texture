
#include "/settings.glsl"

//the 3d texture we are writing voxel data to
layout (r32ui) uniform uimage3D cimage1;

//data from minecraft / iris
uniform sampler2D texture;
in vec4 at_midBlock;
#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif
#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
attribute vec4 mc_Entity;
uniform float frameTimeCounter;
uniform mat4 shadowModelViewInverse;
uniform int renderStage;
uniform int entityId;
uniform int currentRenderedItemId;
#if VOXELIZE_PLAYER == 0 || OTHER_PLAYER_LIGHTS == 0 || AUTO_HAND_HELD_COLOR_DETECTION >= 1  
	uniform int heldItemId;
	uniform int heldItemId2;
	uniform vec3 eyePosition;
#endif

#if AUTO_HAND_HELD_COLOR_DETECTION >= 1 
	layout (r32ui) uniform uimage2D cimage_held_light;
	#if AUTO_HAND_HELD_COLOR_DETECTION == 5 
		uniform vec3 playerBodyVector;
		uniform vec3 previousCameraPosition;
	#endif
#endif


//data we send to fragment shader



//if POTATO_SHADOWS != 1
	uniform sampler2D lightmap;
	//uniform sampler2D texture;
	#if PBR_LPV_EMISSION == 1
		uniform sampler2D specular;
	#endif

	out vec2 lmcoord;
	out vec2 texcoord;
	out vec4 glcolor;
//endif

attribute vec4 mc_midTexCoord;


#include "/distort.glsl"

 #if FLICKERING_TORCHES >= 2 && LAVA_NOISE_ORGANIC == 1
	#include "/noise.glsl"
 #endif


void main() {
//if POTATO_SHADOWS != 1
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;
//endif
	
	//for voxelizing
	#if WHERE_TO_VOXELIZE == 2
		
		if(
        
		((renderStage == MC_RENDER_STAGE_TERRAIN_SOLID || renderStage == MC_RENDER_STAGE_TERRAIN_TRANSLUCENT))
		 #if VOXELIZE_ENTITIES == 1
		 || (renderStage == MC_RENDER_STAGE_ENTITIES) //MC_RENDER_STAGE_PARTICLES
		 #endif
         #if IS_COLOR_WHEEL == 1
            || true
         #endif
		)
		{

			#include "/voxelizing.glsl"
		}
	#endif

	gl_Position = ftransform();
	gl_Position.xyz = distort(gl_Position.xyz);
	
	

	#if GRASS_SHADOWS == 0
		gl_Position = (mc_Entity.x == 10000.0) ? vec4(10.0) : gl_Position;
	#endif
	
	#if IS_THE_NETHER ==1
		gl_Position = vec4(10.0) ;
	#endif
	
}
