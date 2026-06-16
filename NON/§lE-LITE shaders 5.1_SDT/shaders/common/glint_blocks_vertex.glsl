#include "/lib/config.glsl"

/* Uniforms */

uniform sampler2D gaux3;
#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
uniform float frameTime;

/* Ins / Outs */

varying vec2 texcoord;
varying vec4 tint_color;
varying float exposure;

#if AA_TYPE > 1
    #include "/src/taa_offset.glsl"
#endif

// MAIN FUNCTION ------------------

void main() {
    #include "/src/basiccoords_vertex.glsl"
    #include "/src/position_vertex.glsl"

        exposure = texture2D(gaux3, vec2(0.5)).r;

    tint_color = gl_Color;
}
