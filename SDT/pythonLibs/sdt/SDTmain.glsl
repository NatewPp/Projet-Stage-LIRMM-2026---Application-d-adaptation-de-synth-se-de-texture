// Required includes for texture synthesis


#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif

#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif 


#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif  


#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif

#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif

#ifndef TEX
uniform sampler2D tex;
#define TEX
#endif
#ifdef VSHSDT
//========== VERTEX SHADER COMPONENT ==========

// Inter-stage variables vers le FSH : 'out' dans le Vertex Shader.
// (GLSL >= 130 : on n'utilise pas 'varying', déprécié et refusé par les
//  packs écrits en style core comme Photon.)
out vec2 sdtTexCoord;
out vec3 sdtNormal;
out vec4 sdtWavingOffset;
out vec3 sdtPlayerPos;



void PrepareTextureSynthesisVSH() {
    // Pass texture coordinates
    sdtTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

    // Pass normal
    sdtNormal = normalize(gl_NormalMatrix * gl_Normal);
    
    // WavingOffset is shader specific.
    sdtWavingOffset = vec4(0.0);

    // Pass player position (relative to camera)
    sdtPlayerPos = (gbufferModelViewInverse * (gl_ModelViewMatrix * gl_Vertex)).xyz;
}

#endif // VSHSDT

#ifdef FSHSDT
//========== FRAGMENT SHADER COMPONENT ==========


// Inter-stage variables depuis le VSH : 'in' dans le Fragment Shader.
in vec2 sdtTexCoord;
in vec3 sdtNormal;
in vec4 sdtWavingOffset;
in vec3 sdtPlayerPos;
#include "/lib/sdt/textureSynthesis.glsl"
#ifndef ATLASSIZE
uniform ivec2 atlasSize;
#define ATLASSIZE
#endif

#include "/lib/sdt/textureSynthesisUVHints.glsl"


vec3 SDTViewToPlayer(vec3 pos) {
    return mat3(gbufferModelViewInverse) * pos + gbufferModelViewInverse[3].xyz;
}

vec3 SDTSDTScreenToView(vec3 pos) {
    vec4 iProjDiag = vec4(gbufferProjectionInverse[0].x,
                          gbufferProjectionInverse[1].y,
                          gbufferProjectionInverse[2].zw);
    vec3 p3 = pos * 2.0 - 1.0;
    vec4 viewPos = iProjDiag * p3.xyzz + gbufferProjectionInverse[3];
    return viewPos.xyz / viewPos.w;
}

void ApplyTextureSynthesis(inout vec4 color) {
    // Initialize variables
    vec2 texCoord = sdtTexCoord;
    vec3 normal = sdtNormal;
    vec4 wavingOffset = sdtWavingOffset;
    
    // Calculate player position from fragment position and camera position
    vec3 playerPos = sdtPlayerPos;
    
    // Calculate required variables
    vec3 playerPosWithoutWaves = playerPos + wavingOffset.xyz;
    ivec3 blockPosFrag = ivec3(floor(playerPosWithoutWaves + cameraPosition + 0.001));
    vec3 worldGeoNormal = normalize(SDTViewToPlayer(normal * 10000.0));
    bool applyTilingAndBlending = false;

    #ifndef ANISOTROPIC_FILTER
        #define ANISOTROPIC_FILTER 0
    #endif

    #if ANISOTROPIC_FILTER == 0
        // Loop through normal blocks
        for (int i = 0; i < NUM_NORMAL_BLOCKS; i++) {
            vec2 minUVValue = minUVNormal(i);
            vec2 maxUVValue = maxUVNormal(i);
            if (texCoord.x >= minUVValue.x && texCoord.x <= maxUVValue.x && texCoord.y >= minUVValue.y && texCoord.y <= maxUVValue.y) {
                applyTilingAndBlending = true;
                color.rgba = TilingAndBlendingMethod(tex, texCoord, blockPosFrag, worldGeoNormal, 1).rgba;
                return;
            }
        }

        // Dirtpath check
        if(!applyTilingAndBlending && texCoord.x >= minUVdirtpath().x && texCoord.x <= maxUVdirtpath().x && texCoord.y >= minUVdirtpath().y && texCoord.y <= maxUVdirtpath().y) {
            applyTilingAndBlending = true;
            color.rgba = TilingAndBlendingMethod(tex, texCoord, blockPosFrag, worldGeoNormal, 1).rgba;
            return;
        }

        // Loop through 4 bricks blocks
        if (!applyTilingAndBlending) {
            for (int i = 0; i < NUM_4BRICKS_BLOCKS; i++) {
                vec2 minUVValue = minUV4Bricks(i);
                vec2 maxUVValue = maxUV4Bricks(i);

                if (texCoord.x >= minUVValue.x && texCoord.x <= maxUVValue.x && texCoord.y >= minUVValue.y && texCoord.y <= maxUVValue.y) {
                    applyTilingAndBlending = true;
                    color.rgba = TilingAndBlendingMethod(tex, texCoord, blockPosFrag, worldGeoNormal, 3).rgba;
                    return;
                }
            }
        }

        // Loop through 2 bricks blocks
        if (!applyTilingAndBlending) {
            for (int i = 0; i < NUM_2BRICKS_BLOCKS; i++) {
                vec2 minUVValue = minUV2Bricks(i);
                vec2 maxUVValue = maxUV2Bricks(i);

                if (texCoord.x >= minUVValue.x && texCoord.x <= maxUVValue.x && texCoord.y >= minUVValue.y && texCoord.y <= maxUVValue.y) {
                    applyTilingAndBlending = true;
                    color.rgba = TilingAndBlendingMethod(tex, texCoord, blockPosFrag, worldGeoNormal, 2).rgba;
                    return;
                }
            }
        }

        // Loop through border less blocks
        if (!applyTilingAndBlending) {
            for (int i = 0; i < BORDER_LESS_BLOCKS; i++) {
                vec2 minUVValue = minUVBorderLess(i);
                vec2 maxUVValue = maxUVBorderLess(i);

                if (texCoord.x > minUVValue.x && texCoord.x < maxUVValue.x && texCoord.y > minUVValue.y && texCoord.y < maxUVValue.y) {
                    applyTilingAndBlending = true;
                    color.rgba = TilingAndBlendingMethod(tex, texCoord, blockPosFrag, worldGeoNormal, 6).rgba;
                    return;
                }
            }
        }

        // Loop through border less rotate blocks
        if (!applyTilingAndBlending) {
            for (int i = 0; i < BLR_BLOCKS; i++) {
                vec2 minUVValue = minUVBLR(i);
                vec2 maxUVValue = maxUVBLR(i);

                if (texCoord.x >= minUVValue.x && texCoord.x <= maxUVValue.x && texCoord.y >= minUVValue.y && texCoord.y <= maxUVValue.y) {
                    applyTilingAndBlending = true;
                    color.rgba = TilingAndBlendingMethod(tex, texCoord, blockPosFrag, worldGeoNormal, 9).rgba;
                    return;
                }
            }
        }

        // Loop through rotate blocks
        if (!applyTilingAndBlending) {
            for (int i = 0; i < ROTATE_BLOCKS; i++) {
                vec2 minUVValue = minUVRotate(i);
                vec2 maxUVValue = maxUVRotate(i);

                if (texCoord.x >= minUVValue.x && texCoord.x <= maxUVValue.x && texCoord.y >= minUVValue.y && texCoord.y <= maxUVValue.y) {
                    applyTilingAndBlending = true;
                    color.rgba = TilingAndBlendingMethod(tex, texCoord, blockPosFrag, worldGeoNormal, 8).rgba;
                    return;
                }
            }
        }

    #else
        // Anisotropic Filter Version
        
        // Loop through normal blocks
        for (int i = 0; i < NUM_NORMAL_BLOCKS; i++) {
            vec2 minUVValue = minUsdtNormal(i);
            vec2 maxUVValue = maxUsdtNormal(i);
            if (texCoord.x >= minUVValue.x && texCoord.x <= maxUVValue.x && texCoord.y >= minUVValue.y && texCoord.y <= maxUVValue.y) {
                applyTilingAndBlending = true;
                color.rgba = TilingAndBlendingAF(tex, texCoord, blockPosFrag, 16.0, 1.0).rgba;
                return;
            }
        }

        // Loop through 4 bricks blocks
        if (!applyTilingAndBlending) {
            for (int i = 0; i < NUM_4BRICKS_BLOCKS; i++) {
                vec2 minUVValue = minUV4Bricks(i);
                vec2 maxUVValue = maxUV4Bricks(i);

                if (texCoord.x >= minUVValue.x && texCoord.x <= maxUVValue.x && texCoord.y >= minUVValue.y && texCoord.y <= maxUVValue.y) {
                    applyTilingAndBlending = true;
                    color.rgba = TilingAndBlendingAF(tex, texCoord, blockPosFrag, 16.0, 0.25).rgba;
                    return;
                }
            }
        }

        // Loop through 2 bricks blocks
        if (!applyTilingAndBlending) {
            for (int i = 0; i < NUM_2BRICKS_BLOCKS; i++) {
                vec2 minUVValue = minUV2Bricks(i);
                vec2 maxUVValue = maxUV2Bricks(i);

                if (texCoord.x >= minUVValue.x && texCoord.x <= maxUVValue.x && texCoord.y >= minUVValue.y && texCoord.y <= maxUVValue.y) {
                    applyTilingAndBlending = true;
                    color.rgba = TilingAndBlendingAF(tex, texCoord, blockPosFrag, 2.0, 1.0).rgba;
                    return;
                }
            }
        }
    #endif

    // Fallback texture if no synthesis applied
    if (!applyTilingAndBlending) {
        #if ANISOTROPIC_FILTER == 0
            color.rgba = texture2D(tex, texCoord);
        #else
            color.rgba = textureAF(tex, texCoord);
        #endif
    }
}

#endif // FSHSDT