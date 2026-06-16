#include "/settings.glsl"

//the 3d texture we are writing voxel data to
layout (r32ui) uniform uimage3D cimage1a;

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

	

//data we send to fragment shader

#if UNDERWATER_CAUSTICS > 0
		out vec3 world_pos;

	#endif

//if POTATO_SHADOWS != 1
	uniform sampler2D lightmap;
	//uniform sampler2D texture;
	#if PBR_LPV_EMISSION == 1
		uniform sampler2D specular;
	#endif

	out vec2 lmcoord;
	out vec2 texcoord;
	out vec4 glcolor;
	
	out float material;
//endif

attribute vec4 mc_midTexCoord;


#include "/distort.glsl"


void main() {
//if POTATO_SHADOWS != 1
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;
//endif
	
	#if UNDERWATER_CAUSTICS > 0
		//vec4 viewPos = vec4((gl_ModelViewMatrix * gl_Vertex).xyz,1.);
		//vec4 playerPos = gbufferModelViewInverse * viewPos;
		world_pos=((shadowModelViewInverse * (vec4((gl_ModelViewMatrix * gl_Vertex).xyz,1.)))).xyz+cameraPosition;
	#endif
	
	material=mc_Entity.x;//10020
	
	//for voxelizing
	#if WHERE_TO_VOXELIZE == 2
		
		if(
		((renderStage == MC_RENDER_STAGE_TERRAIN_SOLID || renderStage == MC_RENDER_STAGE_TERRAIN_TRANSLUCENT))
		 #if VOXELIZE_ENTITIES == 1
		 || (renderStage == MC_RENDER_STAGE_ENTITIES) //MC_RENDER_STAGE_PARTICLES
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
	
}