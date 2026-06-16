/*
====================================================================================================

    Copyright (C) 2023 RRe36

    All Rights Reserved unless otherwise explicitly stated.


    By downloading this you have agreed to the license and terms of use.
    These can be found inside the included license-file
    or here: https://rre36.com/copyright-license

    Violating these terms may be penalized with actions according to the Digital Millennium
    Copyright Act (DMCA), the Information Society Directive and/or similar laws
    depending on your country.

====================================================================================================
*/

#include "/lib/head.glsl"
#include "/lib/shadowconst.glsl"

flat out int matID;

out vec2 uv;

out vec3 tint;

#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif

#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelView, gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
uniform mat4 shadowModelView, shadowModelViewInverse;

attribute vec2 mc_Entity;
attribute vec4 mc_midTexCoord;

#include "/lib/light/warp.glsl"

#ifdef windEffectsEnabled
#include "/lib/vertex/wind.glsl"
#endif

#define WIND_NEW_TOPVERT

attribute vec3 at_midBlock;

bool getFoliageTopVertex(float worldY) {
    #ifdef WIND_NEW_TOPVERT
    float bottomY = (worldY + (at_midBlock.y / 64.0)) - 0.45;

    return worldY > bottomY;
    #else
    return (gl_MultiTexCoord0.t < mc_midTexCoord.t);
    #endif
}

void main() {
    uv  = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

    tint    = gl_Color.rgb;

    gl_Position = gl_ModelViewMatrix * gl_Vertex;

    gl_Position.xyz     = transMAD(shadowModelViewInverse, gl_Position.xyz);

    vec3 worldPos       = gl_Position.xyz + cameraPosition;

    float skyOcclusion  = linStep((gl_TextureMatrix[1] * gl_MultiTexCoord1).y, rcp(16.0), 1.0);

    int mcEntity        = int(mc_Entity.x);

    if (mcEntity == 10001) matID = 102;
    else if (mcEntity == 10003) matID = 103;
    else matID = 1;

    #ifdef windEffectsEnabled
    bool windLod        = length(gl_Position.xz) < 64.0;

    if (windLod) {
        bool topVertex  = getFoliageTopVertex(gl_Position.y);

        float windStrength  = sqr(skyOcclusion) * 0.9 + 0.1;

        if ((mc_Entity.x >= 10021 && mc_Entity.x <=10024) || mc_Entity.x == 10027) {
            vec2 windOffset = vertexWindEffect(worldPos, 0.18, 1.0);

            if (mc_Entity.x == 10027) gl_Position.xz += windOffset.xy * (1.0 + length(windOffset));
                windOffset*= windStrength;

            if (mc_Entity.x == 10021) gl_Position.xyz += windOffset.xyy*0.4;

            if (mc_Entity.x == 10022 && topVertex)
                gl_Position.xz += windOffset;

            if ((mc_Entity.x == 10023 && topVertex) || (mc_Entity.x == 10024)) gl_Position.xz += windOffset * 0.5;
            if ((mc_Entity.x == 10024 && topVertex)) gl_Position.xz += windOffset * 0.5;
        }
    }
    #endif

    gl_Position.xyz = transMAD(shadowModelView, gl_Position.xyz);

    gl_Position     = gl_ProjectionMatrix * gl_Position;

    gl_Position.xy  = shadowmapWarp(gl_Position.xy);
    gl_Position.z  *= shadowMapDepthScale;

    #ifdef disableFoliageShadows
        if (mcEntity == 10022 ||
            mcEntity == 10023 ||
            mcEntity == 10024) gl_Position = vec4(-1);
    #endif
}