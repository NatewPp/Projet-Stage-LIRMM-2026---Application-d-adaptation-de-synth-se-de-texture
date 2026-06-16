#include "/lib/config.glsl"

/* Uniforms */

#ifndef TEX
uniform sampler2D tex;
#define TEX
#endif

/* Ins / Outs */

varying vec2 texcoord;

// MAIN FUNCTION ------------------

void main() {
    vec4 block_color = texture2D(tex, texcoord);

    #include "/src/writebuffers.glsl"
}
