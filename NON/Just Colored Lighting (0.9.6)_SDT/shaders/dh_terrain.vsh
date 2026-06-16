#version 120

#define FILTER_HERE UPSCALE_TERRAIN

#define THIS_IS_DISTANT_HORIZONS 1

#include "/main_v.glsl"
/*
int dhMaterialId ==
DH_BLOCK_UNKNOWN // Any block not in this list that does not emit light
DH_BLOCK_LEAVES // All types of leaves, bamboo, or cactus
DH_BLOCK_STONE // Stone or ore
DH_BLOCK_WOOD // Any wooden item
DH_BLOCK_METAL // Any block that emits a metal or copper sound.
DH_BLOCK_DIRT // Dirt, grass, podzol, and coarse dirt.
DH_BLOCK_LAVA // Lava.
DH_BLOCK_DEEPSLATE // Deepslate, and all it's forms.
DH_BLOCK_SNOW // Snow.
DH_BLOCK_SAND // Sand and red sand.
DH_BLOCK_TERRACOTTA // Terracotta.
DH_BLOCK_NETHER_STONE // Blocks that have the "base_stone_nether" tag.
DH_BLOCK_WATER // Water...
DH_BLOCK_AIR // Air. This should never be accessible/used.
DH_BLOCK_ILLUMINATED // Any block not in this list that emits light
*/