//#modified
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

uniform vec2 viewSize;
#define VERTEX_STAGE
#include "/lib/downscaleTransform.glsl"

out vec2 uv;
out vec2 lightmapUV;

flat out vec3 vertexNormal;

out vec4 tint;

uniform vec2 taaOffset;

#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelView, gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif

attribute vec4 mc_midTexCoord;

#ifdef gTERRAIN
    flat out int matID;

    #ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif

    attribute vec2 mc_Entity;

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

#endif

#ifdef gTEXTURED
    #ifdef normalmapEnabled
        flat out mat3 tbn;

        attribute vec4 at_tangent;
    #endif
#endif

#ifdef G_WATER
out vec3 tangentViewDir;

#ifndef normalmapEnabled
attribute vec4 at_tangent;
#endif
#endif

#if DIM == 1
#include "/lib/atmos/colorsEnd.glsl"
#else
#include "/lib/atmos/colorsDefault.glsl"
#endif

out vec3 shadowPosition;
flat out vec3 directColor;

uniform float sunAngle, lightFlip;

uniform vec3 lightDir;

uniform mat4 shadowModelView, shadowProjection;

#include "/lib/shadowconst.glsl"

#include "/lib/light/warp.glsl"

#if (defined gTRANSLUCENT && defined gTERRAIN)

out float viewDist;
out vec3 worldPos;

#endif

#define VSHSDT
#include "/lib/sdt/SDTmain.glsl"
void main() {
PrepareTextureSynthesisVSH();

    uv          = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lightmapUV  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

    lightmapUV.x = linStep(lightmapUV.x, rcp(24.0), 1.0);
    lightmapUV.y = linStep(lightmapUV.y, rcp(16.0), 1.0);

    tint        = gl_Color;

    gl_Position = gl_ModelViewMatrix * gl_Vertex;

    vec3 viewNormal     = normalize(gl_NormalMatrix * gl_Normal);

    vertexNormal        = mat3(gbufferModelViewInverse) * viewNormal;

    vec3 scenePosition  = transMAD(gbufferModelViewInverse, gl_Position.xyz);

    #if (defined gTRANSLUCENT && defined gTERRAIN)
        worldPos    = scenePosition + cameraPosition;
        viewDist    = length(scenePosition);
    #endif

    shadowPosition  = scenePosition;
    //shadowPosition += lightDir * shadowmapBias * sqrt(length(shadowPosition) / 128.0);
    //shadowPosition += vertexNormal * shadowmapBias * (2.0 - max0(dot(vertexNormal, lightDir)));
    shadowPosition += vertexNormal * min(0.1 + length(scenePosition) / 200.0, 0.5) * (2.0 - max0(dot(vertexNormal, lightDir))) * log2(max(128.0 - shadowMapResolution * shadowMapDepthScale, sqrt3));
    shadowPosition  = transMAD(shadowModelView, shadowPosition);
    shadowPosition  = projMAD(shadowProjection, shadowPosition);
    shadowPosition.xy = shadowmapWarp(shadowPosition.xy);
    shadowPosition.z *= shadowMapDepthScale;
    shadowPosition  = shadowPosition * 0.5 + 0.5;

    #ifdef gTEXTURED
        #if (defined normalmapEnabled || defined G_WATER)
            vec3 tangent    = normalize(gl_NormalMatrix * at_tangent.xyz);
            vec3 binormal   = normalize(gl_NormalMatrix * cross(at_tangent.xyz, gl_Normal.xyz) * at_tangent.w);

            tangent     = mat3(gbufferModelViewInverse) * tangent;
            binormal    = mat3(gbufferModelViewInverse) * binormal;

            tbn         = mat3(tangent, binormal, vertexNormal);

            #ifdef G_WATER
                tangentViewDir = mat3(gbufferModelViewInverse) * gl_Position.xyz * tbn;
            #endif
        #endif
    #endif

    #ifdef gTERRAIN
        int mcEntity    = int(mc_Entity.x);

        #ifndef gTRANSLUCENT
            matID  = 1;

            if (
            mcEntity == 10022 ||
            mcEntity == 10023 ||
            mcEntity == 10024 ||
            mcEntity == 10025 ||
            mcEntity == 10027 ||
            mcEntity == 10202) matID = 2;

            if (
            mcEntity == 10021) matID = 4;

            if (mcEntity == 10301 ||
            mcEntity == 10002) matID = 5;

            if (mcEntity == 10302) matID = 6;
        #else
            matID   = 101;

            if (mcEntity == 10001) matID = 102;
            else if (mcEntity == 10003) matID = 103;
        #endif

        #ifdef windEffectsEnabled
        gl_Position.xyz = transMAD(gbufferModelViewInverse, gl_Position.xyz);

        bool windLod    = length(gl_Position.xz) < 64.0;

        if (windLod) {
            bool topVertex      = getFoliageTopVertex(gl_Position.y);

            float windStrength  = sqr(lightmapUV.y) * 0.9 + 0.1;

            vec3 worldPos       = gl_Position.xyz + cameraPosition;

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

        gl_Position.xyz = transMAD(gbufferModelView, gl_Position.xyz);
        #endif
        
    #endif

    gl_Position         = gl_ProjectionMatrix * gl_Position;

    VertexDownscaling(gl_Position);

    #ifdef taaEnabled
        gl_Position.xy += taaOffset * gl_Position.w;
    #endif
}