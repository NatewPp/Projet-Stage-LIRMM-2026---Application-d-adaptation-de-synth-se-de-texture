#define RENDER_VERTEX
#define RENDER_COMPOSITE
#define RENDER_COMPOSITE_BLOOM_BLUR
//#define RENDER_COMPOSITE_BLOOM_BLUR_H

#include "/lib/constants.glsl"
#include "/lib/common.glsl"

out vec2 texcoord;
flat out int tileCount;

uniform sampler2D BUFFER_HDR;

#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif

#include "/lib/camera/bloom.glsl"


void main() {
    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

    tileCount = GetBloomTileCount();
}
