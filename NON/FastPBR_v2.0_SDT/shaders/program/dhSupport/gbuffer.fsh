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

#ifndef gTRANSLUCENT
    /* RENDERTARGETS: 0,1,6 */
    layout(location = 0) out vec4 sceneColor;
    layout(location = 1) out vec4 GData;
    layout(location = 2) out vec4 lightingData;
#else
    /* RENDERTARGETS: 5,1,6,7 */
    layout(location = 0) out vec4 sceneColor;
    layout(location = 1) out vec4 GData;
    layout(location = 2) out vec4 lightingData;
    layout(location = 3) out vec4 sceneTint;
#endif

#define RSSBO_ENABLE_COLOR
#include "/lib/head.glsl"
#include "/lib/util/colorspace.glsl"
#include "/lib/util/encoders.glsl"

uniform vec2 viewSize;
#include "/lib/downscaleTransform.glsl"

in vec2 uv;
in vec2 lightmapUV;

in vec4 tint;

flat in vec3 vertexNormal;

uniform sampler2D gcolor;
uniform sampler2D specular;
uniform sampler2D depthtex0;

flat in int matID;
in vec3 worldPos;

uniform float far;

uniform vec2 taaOffset;

uniform mat4 dhProjection;
uniform mat4 dhProjectionInverse;
uniform mat4 dhPreviousProjection;
#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
uniform mat4 gbufferModelView;

vec3 screenToViewSpace(vec3 screenpos, mat4 projInv, const bool taaAware) {
    screenpos   = screenpos*2.0-1.0;

    #ifdef taaEnabled
        if (taaAware) screenpos.xy -= taaOffset;
    #endif

    vec3 viewpos    = vec3(vec2(projInv[0].x, projInv[1].y)*screenpos.xy + projInv[3].xy, projInv[3].z);
        viewpos    /= projInv[2].w*screenpos.z + projInv[3].w;
    
    return viewpos;
}
vec3 screenToViewSpace(vec3 screenpos, mat4 projInv) {    
    return screenToViewSpace(screenpos, projInv, true);
}

vec3 screenToViewSpace(vec3 screenpos) {
    return screenToViewSpace(screenpos, dhProjectionInverse);
}

in float vertexDistance;

#if DIM != -1

const bool shadowHardwareFiltering = true;

uniform sampler2DShadow shadowtex0;
uniform sampler2DShadow shadowtex1;
uniform sampler2D shadowcolor0;

uniform vec3 lightDir;

in vec3 shadowPosition;

#endif

#ifndef DIM
#include "/lib/light/sphericalHarmonics.glsl"
#endif

float diffuseLambert(vec3 vertexNormal, vec3 direction) {
    return saturate(dot(vertexNormal, direction)) * rpi;
}


#define FUTIL_LIGHTMAP
#include "/lib/fUtil.glsl"


/*
    This offset thing is from spectrum, and zombye has it from here:
    http://extremelearning.com.au/unreasonable-effectiveness-of-quasirandom-sequences/
*/
vec2 R2(float n) {
	const float s0 = 0.5;
	const vec2 alpha = 1.0 / vec2(rho, rho * rho);
	return fract(n * alpha + s0);
}

uniform sampler2D noisetex;

uniform int frameCounter;

#include "/lib/frag/bluenoise.glsl"

#if DIM != -1
#include "/lib/shadowconst.glsl"

vec3 ReadShadowColor(ivec2 Pixel) {
    vec4 Sample = texelFetch(shadowcolor0, Pixel, 0);

    return mix(vec3(1.0), Sample.rgb, Sample.a);
}
vec3 GetSampleColor(vec3 Color, float SolidOcclusion, float TranslucentOcclusion) {
    if (TranslucentOcclusion >= SolidOcclusion) Color = vec3(1.0);

    return SolidOcclusion * Color;
}

vec3 GetShadowBilinear(vec3 uv) {
    ivec2 ShadowRes = ivec2(shadowMapResolution);

    ivec2 SamplePixel = ivec2(uv.xy * ShadowRes - 0.5);

    vec4 OcclusionSamples = textureGather(shadowtex1, uv.xy, uv.z).wzxy;
    vec4 OcclusionSamples_T = textureGather(shadowtex0, uv.xy, uv.z).wzxy;

    vec3[4] ColorSamples = vec3[4](
        ReadShadowColor(SamplePixel + ivec2(0,0)),
        ReadShadowColor(SamplePixel + ivec2(1,0)),
        ReadShadowColor(SamplePixel + ivec2(0,1)),
        ReadShadowColor(SamplePixel + ivec2(1,1))
    );

    vec2 PixelFract = fract(uv.xy * ShadowRes - 0.5);

    vec3 Color0 = mix(GetSampleColor(ColorSamples[0], OcclusionSamples[0], OcclusionSamples_T[0]), GetSampleColor(ColorSamples[1], OcclusionSamples[1], OcclusionSamples_T[1]), PixelFract.x);
    vec3 Color1 = mix(GetSampleColor(ColorSamples[2], OcclusionSamples[2], OcclusionSamples_T[2]), GetSampleColor(ColorSamples[3], OcclusionSamples[3], OcclusionSamples_T[3]), PixelFract.x);

    return mix(Color0, Color1, PixelFract.y);
}

vec3 shadowFiltered(vec3 position) {

    float dither   = ditherBluenoise();

    const float sigma = shadowmapPixel.x * sqrt2 * shadowFilterSize;

    vec3 total  = vec3(0);

    for (uint i = 0; i < shadowFilterIterations; ++i) {
        vec2 offset     = R2((i + dither) * 64.0);
            offset      = vec2(cos(offset.x * tau), sin(offset.x * tau)) * sqrt(offset.y);

        vec3 uv         = position + vec3(offset * sigma, 0.0);

        //float shadow    = texture(shadowtex1, uv);
        //vec4 color      = vec4(1,1,1,0);

        //if (texture(shadowtex0, uv) < shadow) color = texture(shadowcolor0, uv.xy);

        //total          += shadow * mix(vec3(1), color.rgb, color.a);
        total += GetShadowBilinear(uv);
    }
    total  /= float(shadowFilterIterations);

    return total;
}
#endif

vec4 packReflectionAux(vec3 directLight, vec3 albedo) {
    vec4 lightRGBE  = encodeRGBE8(directLight);
    vec4 albedoRGBE = encodeRGBE8(albedo);

    return vec4(pack2x8(lightRGBE.xy),
                pack2x8(lightRGBE.zw),
                pack2x8(albedoRGBE.xy),
                pack2x8(albedoRGBE.zw));
}

#ifdef gTRANSLUCENT

in float viewDist;
uniform float frameTimeCounter;

#include "/lib/util/bicubic.glsl"

#include "/lib/atmos/waterWaves.glsl"

vec3 waterNormal() {
    vec3 pos    = worldPos;

    float dstep   = 0.02 + (1.0 - exp(-viewDist * rcp(32.0))) * 0.06;

    vec2 delta;
        delta.x     = waterWaves(pos + vec3( dstep, 0.0, -dstep));
        delta.y     = waterWaves(pos + vec3(-dstep, 0.0,  dstep));
        delta      -= waterWaves(pos + vec3(-dstep, 0.0, -dstep));

    return normalize(vec3(-delta.x, 2.0 * dstep, -delta.y));
}

#endif

void main() {
    //if (OutsideDownscaleViewport()) discard;
    vec3 sceneNormal      = vertexNormal;
    vec4 specularData   = vec4(0.0);
    float parallaxShadow = 1.0;
    vec2 ambientOcclusion = vec2(1.0);
    float wetnessVal    = 0.0;

    vec3 foregroundPos = screenToViewSpace(vec3((gl_FragCoord.xy) / vec2(viewSize), texture(depthtex0, (gl_FragCoord.xy) / vec2(viewSize)).x), gbufferProjectionInverse);

    if (texture(depthtex0, (gl_FragCoord.xy) / vec2(viewSize)).x < 1.0 || length(worldPos) < far / 3) discard;

    sceneColor  = vec4(tint.rgb, 1.0);

    vec4 normalTex      = vec4(0.5, 0.5, 1.0, 1.0);

    specularData = vec4(0,0,0,1);
    
    ambientOcclusion.x  = tint.a;

    #if wetnessMode != 2
    //if (wetness > 1e-2) getWetness(wetnessVal, normalOut, specularData.xy, normalTex.w);
    #endif

    convertToPipelineAlbedo(sceneColor.rgb);

    #ifdef gTRANSLUCENT
        if (matID == 102) {
            #ifdef customWaterNormals
            sceneNormal     = waterNormal();
            #endif

            #ifdef customWaterColor
            sceneColor      = vec4(vec3(waterRed, waterGreen, waterBlue) * rpi, max(waterAlpha, 0.101));
            #endif
        }
    #endif


    #ifdef gTRANSLUCENT
    sceneTint           = sceneColor;
    sceneTint.rgb       = normalize(max(sceneColor.rgb, 1e-3));
    sceneTint.a         = sqrt(sceneTint.a);
    #endif

    float occlusion     = sqr(tint.a) * 0.9 + 0.1;

    #if DIM == -1

    vec3 directLight = vec3(0);

    #else
    float diffuse       = diffuseLambert(sceneNormal, lightDir);
    vec3 shadow         = vec3(diffuse);
    //if (diffuse > 1e-8) shadow *= GetShadowBilinear(shadowPosition);

    vec3 directLight    = RColorTable.DirectLight * shadow;
        //directLight    *= sqrt(occlusion) * 0.9 + 0.1;

    #if DIM != 1
        directLight    *= sstep(lightmapUV.y, 0.1, 0.5);
    #endif

    #endif

    #if DIM == 1

    vec3 indirectLight  = RColorTable.Skylight / sqrt2;

    #elif DIM == -1

    vec3 indirectLight = RColorTable.Skylight;

    #else

    vec3 indirectLight  = ProjectIrradiance(RColorTable.SkylightSH, clampDIR(vertexNormal)) * cube(lightmapUV.y) * pi;
    indirectLight  += vec3(0.85, 0.9, 1.0) * 0.002 * sqrt((clampDIR(vertexNormal.y) + 2.0) / 3.0);
        

    #endif

    vec3 blockLight     = getBlocklightMap(RColorTable.Blocklight, lightmapUV.x);
        blockLight     *= occlusion;
    if (lightmapUV.x > (15.0/16.0) || matID == 5) {
        float albedoLum = getLuma(sceneColor.rgb);
            albedoLum   = mix(cube(albedoLum), albedoLum, albedoLum);
        blockLight += RColorTable.Blocklight * pi * albedoLum;
    } else if (matID == 6) {
        float albedoLum = getLuma(sceneColor.rgb);
            albedoLum   = mix(cube(albedoLum), albedoLum, albedoLum);
        blockLight += RColorTable.Blocklight * albedoLum;
    }

    lightingData    = packReflectionAux(directLight, sceneColor.rgb);

    sceneColor.rgb *= directLight + indirectLight + blockLight;

    sceneColor      = drawbufferClamp(sceneColor);

    GData.xy        = encodeNormal(sceneNormal);
    GData.z         = pack2x8(vec2(lightmapUV.y, float(matID) / 255.0));
    GData.w         = pack2x8(specularData.xy);
}