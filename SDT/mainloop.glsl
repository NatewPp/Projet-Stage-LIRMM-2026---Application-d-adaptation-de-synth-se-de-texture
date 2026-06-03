// Texture Synthesis Main Loop
// Extracted from gbuffers_terrain.glsl

// Required variables
ivec3 blockPosFrag;
vec3 worldGeoNormal;
vec2 texCoord;
vec4 color;
bool applyTilingAndBlending = false;

#if ANISOTROPIC_FILTER == 0

    #include "../lib/sdt/textureSynthesis.glsl"
    #include "../lib/sdt/textureSynthesisUVHints.glsl"

    // Loop through normal blocks
    for (int i = 0; i < NUM_NORMAL_BLOCKS; i++) {
        vec2 minUVValue = minUVNormal(i);
        vec2 maxUVValue = maxUVNormal(i);
        if (texCoord.x >= minUVValue.x && texCoord.x <= maxUVValue.x && texCoord.y >= minUVValue.y && texCoord.y <= maxUVValue.y) {
            applyTilingAndBlending = true;
            color.rgba = TilingAndBlendingMethod(tex, texCoord, blockPosFrag, worldGeoNormal, 1).rgba;
            break;
        }
    }

    if(!applyTilingAndBlending && texCoord.x >= minUVdirtpath().x && texCoord.x <= maxUVdirtpath().x && texCoord.y >= minUVdirtpath().y && texCoord.y <= maxUVdirtpath().y) {
        applyTilingAndBlending = true;
        color.rgba = TilingAndBlendingMethod(tex, texCoord, blockPosFrag, worldGeoNormal, 1).rgba;
    }

    // Loop through 4 bricks blocks
    if (!applyTilingAndBlending) {
        for (int i = 0; i < NUM_4BRICKS_BLOCKS; i++) {
            vec2 minUVValue = minUV4Bricks(i);
            vec2 maxUVValue = maxUV4Bricks(i);

            if (texCoord.x >= minUVValue.x && texCoord.x <= maxUVValue.x && texCoord.y >= minUVValue.y && texCoord.y <= maxUVValue.y) {
                applyTilingAndBlending = true;
                color.rgba = TilingAndBlendingMethod(tex, texCoord, blockPosFrag, worldGeoNormal, 3).rgba;
                break;
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
                break;
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
                break;
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
                break;
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
                break;
            }
        }
    }

    if (!applyTilingAndBlending) {
        color.rgba = texture2D(tex, texCoord);
    }

#else

    // Loop through normal blocks
    for (int i = 0; i < NUM_NORMAL_BLOCKS; i++) {
        vec2 minUVValue = minUVNormal(i);
        vec2 maxUVValue = maxUVNormal(i);
        if (texCoord.x >= minUVValue.x && texCoord.x <= maxUVValue.x && texCoord.y >= minUVValue.y && texCoord.y <= maxUVValue.y) {
            applyTilingAndBlending = true;
            color.rgba = TilingAndBlendingAF(tex, texCoord, blockPosFrag, 16.0, 1.0).rgba;
            break;
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
                break;
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
                break;
            }
        }
    }

    if (!applyTilingAndBlending) {
        color.rgba = textureAF(tex, texCoord);
    }

#endif
