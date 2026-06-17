#define RENDER_VERTEX
#define RENDER_GBUFFER
#define RENDER_LINE

#define LINE_WIDTH 3.0
#define VIEW_SCALE 1.0

#include "/lib/constants.glsl"
#include "/lib/common.glsl"

#if MC_VERSION >= 11700
    attribute vec3 vaPosition;
    attribute vec3 vaNormal;
#endif

out vec2 lmcoord;
out vec3 localPos;

#ifndef MODELVIEWMATRIX
uniform mat4 modelViewMatrix;
#define MODELVIEWMATRIX
#endif
uniform mat4 projectionMatrix;
#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif
#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif


void main() {
    #if BLOCK_OUTLINE == BLOCK_OUTLINE_NONE
        gl_Position = vec4(10.0);
    #else
        lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

        vec4 linePosStart = projectionMatrix * (VIEW_SCALE * (modelViewMatrix * vec4(vaPosition, 1.0)));
        vec3 ndc1 = unproject(linePosStart);

        vec4 linePosEnd = projectionMatrix * (VIEW_SCALE * (modelViewMatrix * vec4(vaPosition + vaNormal, 1.0)));
        vec3 ndc2 = unproject(linePosEnd);

        vec2 viewSize = vec2(viewWidth, viewHeight);
        vec2 lineScreenDirection = normalize((ndc2.xy - ndc1.xy) * viewSize);
        vec2 lineOffset = vec2(-lineScreenDirection.y, lineScreenDirection.x) * LINE_WIDTH / viewSize;

        if (lineOffset.x < 0.0) lineOffset = -lineOffset;
        if (gl_VertexID % 2 != 0) lineOffset = -lineOffset;
        gl_Position = vec4((ndc1 + vec3(lineOffset, 0.0)) * linePosStart.w, linePosStart.w);

        #if BLOCK_OUTLINE == BLOCK_OUTLINE_FANCY
            localPos = (gbufferModelViewInverse * (gbufferProjectionInverse * gl_Position)).xyz + cameraPosition;
        #endif
    #endif
}
