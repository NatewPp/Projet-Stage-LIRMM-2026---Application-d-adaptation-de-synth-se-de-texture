#version 430 compatibility




#define IS_AN_ENTITY 1


#define HARD_ALPHA 1

#include "/version_check.glsl"

#if TEXTURE_SIZE_AVAILABLE == 1

	#define FILTER_HERE UPSCALE_ENTITIES 
#else
	#define FILTER_HERE 0 
#endif

#include "/main_f.glsl"