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

out vec4 tint;

flat out vec3 vertexNormal;

out float vertexDistance;

uniform vec2 taaOffset;

uniform mat4 dhProjection;
uniform mat4 dhProjectionInverse;
uniform mat4 dhPreviousProjection;

#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelView, gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif

flat out int matID;

out float viewDist;
out vec3 worldPos;

#if DIM != -1

out vec3 shadowPosition;

uniform vec3 lightDir;

uniform mat4 shadowModelView, shadowProjection;

#include "/lib/shadowconst.glsl"

#include "/lib/light/warp.glsl"

#endif

#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif

void main() {
    uv          = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lightmapUV  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

    lightmapUV.x = linStep(lightmapUV.x, rcp(24.0), 1.0);
    lightmapUV.y = linStep(lightmapUV.y, rcp(16.0), 1.0);

    gl_Position = gl_ModelViewMatrix * gl_Vertex;

    vertexDistance = gl_Position.z;

    vec3 viewNormal     = normalize(gl_NormalMatrix * gl_Normal);

    vertexNormal        = mat3(gbufferModelViewInverse) * viewNormal;

    tint        = gl_Color;

    vec3 scenePosition  = transMAD(gbufferModelViewInverse, gl_Position.xyz);

        worldPos    = scenePosition + cameraPosition;
        viewDist    = length(scenePosition);

#if DIM != -1
        shadowPosition  = scenePosition;
        //shadowPosition += lightDir * shadowmapBias * sqrt(length(shadowPosition) / 128.0);
        //shadowPosition += vertexNormal * shadowmapBias * (2.0 - max0(dot(vertexNormal, lightDir)));
        shadowPosition += vertexNormal * min(0.1 + length(scenePosition) / 200.0, 0.5) * (2.0 - max0(dot(vertexNormal, lightDir))) * log2(max(128.0 - shadowMapResolution * shadowMapDepthScale, sqrt3));
        shadowPosition  = transMAD(shadowModelView, shadowPosition);
        shadowPosition  = projMAD(shadowProjection, shadowPosition);
        shadowPosition.xy = shadowmapWarp(shadowPosition.xy);
        shadowPosition.z *= shadowMapDepthScale;
        shadowPosition  = shadowPosition * 0.5 + 0.5;
#endif

        gl_Position     = dhProjection * gl_Position;

    VertexDownscaling(gl_Position);

    #ifdef taaEnabled
        gl_Position.xy += taaOffset * gl_Position.w;
    #endif

    matID  = 1;

    if (dhMaterialId == DH_BLOCK_LEAVES) matID = 2;
    if (dhMaterialId == DH_BLOCK_WATER) matID = 102;
    if (dhMaterialId == DH_BLOCK_LAVA) matID = 5;
}