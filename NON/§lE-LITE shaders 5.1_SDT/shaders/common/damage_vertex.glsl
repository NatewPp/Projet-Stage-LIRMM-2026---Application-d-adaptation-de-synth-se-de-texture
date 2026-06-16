#include "/lib/config.glsl"

/* Uniforms */

#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif

/* Ins / Outs */

varying vec2 texcoord;
#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif 
#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif 
uniform int frameCounter;
uniform float frameTime;
/* Utility functions */

#if AA_TYPE > 1
    #include "/src/taa_offset.glsl"
#endif
//#include "/lib/downscale.glsl"

// MAIN FUNCTION ------------------

void main() {
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    //resize_vertex(gl_Position);
    
    vec4 homopos = gbufferProjectionInverse * vec4(gl_Position.xyz / gl_Position.w, 1.0);
    vec3 viewPos = homopos.xyz / homopos.w;
    gl_FogFragCoord = length(viewPos.xyz);
}