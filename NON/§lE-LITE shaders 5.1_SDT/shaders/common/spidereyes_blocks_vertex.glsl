#include "/lib/config.glsl"

/* Uniforms */

#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
uniform float frameTime;

#if defined SHADOW_CASTING && !defined NETHER
    #ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
#endif

/* Ins / Outs */

varying vec2 texcoord;

/* Utility functions */

#if AA_TYPE > 1
    #include "/src/taa_offset.glsl"
#endif

//#include "/lib/downscale.glsl"
 
// MAIN FUNCTION ------------------

void main() {
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

    #include "/src/position_vertex.glsl"
    //resize_vertex(gl_Position);
}