// uv offsets
#define NUM_NORMAL_BLOCKS 248
#define NUM_4BRICKS_BLOCKS 11
#define NUM_2BRICKS_BLOCKS 17
#define BLR_BLOCKS 44
#define BORDER_LESS_BLOCKS 24
#define ROTATE_BLOCKS 108

// Define UV offsets for each block category
const vec2 normalBlockOffsets[NUM_NORMAL_BLOCKS] = vec2[NUM_NORMAL_BLOCKS](
    vec2(48.0, 80.0), //acacia_log
    vec2(80.0, 80.0), //acacia_planks
    vec2(48.0, 96.0), //amethyst_block
    vec2(80.0, 96.0), //ancient_debris_side
    vec2(112.0, 96.0), //andesite
    vec2(64.0, 112.0), //azalea_leaves
    vec2(112.0, 112.0), //azalea_top
    vec2(160.0, 32.0), //barrel_side
    vec2(160.0, 80.0), //basalt_side
    vec2(160.0, 96.0), //basalt_top
    vec2(176.0, 0.0), //bedrock
    vec2(208.0, 112.0), //birch_leaves
    vec2(224.0, 0.0), //birch_log
    vec2(224.0, 32.0), //birch_planks
    vec2(224.0, 112.0), //black_concrete
    vec2(240.0, 0.0), //black_concrete_powder
    vec2(240.0, 80.0), //black_terracotta
    vec2(240.0, 96.0), //black_wool
    vec2(240.0, 112.0), //blackstone
    vec2(0.0, 128.0), //blackstone_top
    vec2(112.0, 128.0), //blue_concrete
    vec2(128.0, 128.0), //blue_concrete_powder
    vec2(160.0, 128.0), //blue_ice
    vec2(240.0, 128.0), //blue_terracotta
    vec2(0.0, 144.0), //blue_wool
    vec2(16.0, 144.0), //bone_block_side
    vec2(80.0, 144.0), //brain_coral_block
    vec2(192.0, 144.0), //brown_concrete
    vec2(208.0, 144.0), //brown_concrete_powder
    vec2(0.0, 160.0), //brown_mushroom_block
    vec2(64.0, 160.0), //brown_terracotta
    vec2(80.0, 160.0), //brown_wool
    vec2(112.0, 160.0), //bubble_coral_block
    vec2(16.0, 176.0), //calcite
    vec2(240.0, 192.0), //cherry_leaves
    vec2(0.0, 208.0), //cherry_log
    vec2(32.0, 208.0), //cherry_planks
    vec2(64.0, 224.0), //chorus_plant
    vec2(80.0, 224.0), //clay
    vec2(96.0, 224.0), //coal_block
    vec2(128.0, 224.0), //coarse_dirt
    vec2(144.0, 224.0), //cobbled_deepslate
    vec2(160.0, 224.0), //cobblestone
    vec2(160.0, 384.0), //creaking_heart  // <verif: bestmatch(d=17861)>
    vec2(208.0, 144.0), //creaking_heart_awake  // <verif: bestmatch(d=23837)>
    vec2(192.0, 144.0), //creaking_heart_dormant  // <verif: bestmatch(d=18494)>
    vec2(256.0, 144.0), //crimson_nylium
    vec2(256.0, 160.0), //crimson_nylium_side
    vec2(256.0, 176.0), //crimson_planks
    vec2(256.0, 224.0), //crimson_stem
    vec2(272.0, 16.0), //crying_obsidian
    vec2(272.0, 112.0), //cyan_concrete
    vec2(272.0, 128.0), //cyan_concrete_powder
    vec2(272.0, 208.0), //cyan_terracotta
    vec2(272.0, 224.0), //cyan_wool
    vec2(288.0, 48.0), //dark_oak_leaves
    vec2(288.0, 64.0), //dark_oak_log
    vec2(288.0, 96.0), //dark_oak_planks
    vec2(288.0, 224.0), //dead_brain_coral_block
    vec2(304.0, 16.0), //dead_bubble_coral_block
    vec2(304.0, 80.0), //dead_fire_coral_block
    vec2(304.0, 128.0), //dead_horn_coral_block
    vec2(304.0, 176.0), //dead_tube_coral_block
    vec2(304.0, 240.0), //deepslate
    vec2(320.0, 144.0), //deepslate_tiles
    vec2(320.0, 160.0), //deepslate_top
    vec2(336.0, 144.0), //diorite
    vec2(336.0, 160.0), //dirt
    vec2(336.0, 192.0), //dirt_path_top
    vec2(336.0, 240.0), //dragon_egg
    vec2(352.0, 48.0), //dripstone_block
    vec2(352.0, 128.0), //enchanting_table_bottom
    vec2(352.0, 240.0), //end_stone
    vec2(368.0, 48.0), //farmland
    vec2(368.0, 64.0), //farmland_moist
    vec2(368.0, 144.0), //fire_coral_block
    vec2(368.0, 240.0), //flowering_azalea_leaves
    vec2(384.0, 16.0), //flowering_azalea_top
    vec2(384.0, 176.0), //gilded_blackstone
    vec2(384.0, 240.0), //glow_lichen
    vec2(400.0, 0.0), //glowstone
    vec2(400.0, 48.0), //granite
    vec2(400.0, 80.0), //grass_block_side
    vec2(400.0, 96.0), //grass_block_side_overlay
    vec2(400.0, 112.0), //grass_block_snow
    vec2(400.0, 128.0), //grass_block_top
    vec2(400.0, 144.0), //gravel
    vec2(400.0, 192.0), //gray_concrete
    vec2(400.0, 208.0), //gray_concrete_powder
    vec2(416.0, 32.0), //gray_terracotta
    vec2(416.0, 48.0), //gray_wool
    vec2(416.0, 96.0), //green_concrete
    vec2(416.0, 112.0), //green_concrete_powder
    vec2(416.0, 192.0), //green_terracotta
    vec2(416.0, 208.0), //green_wool
    vec2(432.0, 32.0), //hay_block_side
    vec2(432.0, 48.0), //hay_block_top
    vec2(432.0, 64.0), //honey_block_bottom
    vec2(432.0, 80.0), //honey_block_side
    vec2(432.0, 96.0), //honey_block_top
    vec2(432.0, 112.0), //honeycomb_block
    vec2(432.0, 144.0), //hopper_outside
    vec2(432.0, 192.0), //horn_coral_block
    vec2(432.0, 224.0), //ice
    vec2(448.0, 240.0), //jungle_leaves
    vec2(464.0, 0.0), //jungle_log
    vec2(464.0, 32.0), //jungle_planks
    vec2(464.0, 224.0), //lava_still  // <verif: bestmatch(d=9168)>
    vec2(752.0, 256.0), //leaf_litter  // <verif: bestmatch(d=89367)>
    vec2(480.0, 96.0), //light_blue_concrete
    vec2(480.0, 112.0), //light_blue_concrete_powder
    vec2(480.0, 192.0), //light_blue_terracotta
    vec2(480.0, 208.0), //light_blue_wool
    vec2(496.0, 0.0), //light_gray_concrete
    vec2(496.0, 16.0), //light_gray_concrete_powder
    vec2(496.0, 96.0), //light_gray_terracotta
    vec2(496.0, 112.0), //light_gray_wool
    vec2(0.0, 256.0), //lime_concrete
    vec2(16.0, 256.0), //lime_concrete_powder
    vec2(96.0, 256.0), //lime_terracotta
    vec2(112.0, 256.0), //lime_wool
    vec2(256.0, 256.0), //magenta_concrete
    vec2(272.0, 256.0), //magenta_concrete_powder
    vec2(352.0, 256.0), //magenta_terracotta
    vec2(368.0, 256.0), //magenta_wool
    vec2(384.0, 256.0), //magma  // <verif: bestmatch(d=2342)>
    vec2(432.0, 256.0), //mangrove_leaves
    vec2(448.0, 256.0), //mangrove_log
    vec2(480.0, 256.0), //mangrove_planks
    vec2(16.0, 272.0), //mangrove_roots_side
    vec2(32.0, 272.0), //mangrove_roots_top
    vec2(80.0, 272.0), //melon_side
    vec2(128.0, 272.0), //moss_block
    vec2(144.0, 272.0), //mossy_cobblestone
    vec2(176.0, 272.0), //mud
    vec2(208.0, 272.0), //muddy_mangrove_roots_side
    vec2(224.0, 272.0), //muddy_mangrove_roots_top
    vec2(240.0, 272.0), //mushroom_block_inside
    vec2(256.0, 272.0), //mushroom_stem
    vec2(272.0, 272.0), //mycelium_side
    vec2(288.0, 272.0), //mycelium_top
    vec2(384.0, 272.0), //nether_wart_block
    vec2(464.0, 272.0), //netherrack
    vec2(16.0, 288.0), //oak_leaves
    vec2(32.0, 288.0), //oak_log
    vec2(64.0, 288.0), //oak_planks
    vec2(352.0, 128.0), //obsidian
    vec2(272.0, 288.0), //orange_concrete
    vec2(288.0, 288.0), //orange_concrete_powder
    vec2(368.0, 288.0), //orange_terracotta
    vec2(400.0, 288.0), //orange_wool
    vec2(464.0, 288.0), //packed_ice
    vec2(480.0, 288.0), //packed_mud
    vec2(288.0, 272.0), //pale_moss_block  // <verif: bestmatch(d=13200)>
    vec2(288.0, 272.0), //pale_moss_carpet  // <verif: bestmatch(d=13200)>
    vec2(288.0, 272.0), //pale_oak_leaves  // <verif: bestmatch(d=44548)>
    vec2(400.0, 208.0), //pale_oak_log  // <verif: bestmatch(d=12425)>
    vec2(192.0, 336.0), //pale_oak_planks  // <verif: bestmatch(d=14522)>
    vec2(80.0, 304.0), //pink_concrete
    vec2(96.0, 304.0), //pink_concrete_powder
    vec2(208.0, 304.0), //pink_terracotta
    vec2(240.0, 304.0), //pink_wool
    vec2(336.0, 304.0), //podzol_side
    vec2(352.0, 304.0), //podzol_top
    vec2(320.0, 320.0), //powder_snow
    vec2(368.0, 320.0), //prismarine
    vec2(400.0, 320.0), //pumpkin_side
    vec2(480.0, 320.0), //purple_concrete
    vec2(496.0, 320.0), //purple_concrete_powder
    vec2(64.0, 336.0), //purple_terracotta
    vec2(80.0, 336.0), //purple_wool
    vec2(144.0, 336.0), //quartz_block_bottom
    vec2(208.0, 336.0), //quartz_pillar
    vec2(272.0, 336.0), //raw_copper_block
    vec2(288.0, 336.0), //raw_gold_block
    vec2(304.0, 336.0), //raw_iron_block
    vec2(352.0, 336.0), //red_concrete
    vec2(368.0, 336.0), //red_concrete_powder
    vec2(416.0, 336.0), //red_mushroom_block
    vec2(448.0, 336.0), //red_sand
    vec2(464.0, 336.0), //red_sandstone
    vec2(480.0, 336.0), //red_sandstone_bottom
    vec2(496.0, 336.0), //red_sandstone_top
    vec2(48.0, 352.0), //red_terracotta
    vec2(80.0, 352.0), //red_wool
    vec2(272.0, 288.0), //resin_block  // <verif: bestmatch(d=16912)>
    vec2(784.0, 0.0), //resin_clump  // <verif: bestmatch(d=17290)>
    vec2(272.0, 16.0), //respawn_anchor_bottom
    vec2(16.0, 368.0), //rooted_dirt
    vec2(64.0, 368.0), //sand
    vec2(80.0, 368.0), //sandstone
    vec2(96.0, 368.0), //sandstone_bottom
    vec2(112.0, 368.0), //sandstone_top
    vec2(176.0, 368.0), //sculk
    vec2(240.0, 368.0), //sculk_catalyst_top
    vec2(256.0, 368.0), //sculk_catalyst_top_bloom
    vec2(176.0, 368.0), //sculk_sensor_bottom
    vec2(336.0, 368.0), //sculk_sensor_top
    vec2(176.0, 368.0), //sculk_shrieker_bottom
    vec2(432.0, 368.0), //sculk_vein
    vec2(16.0, 384.0), //slime_block
    vec2(256.0, 384.0), //smooth_basalt
    vec2(400.0, 384.0), //soul_sand
    vec2(464.0, 384.0), //sponge
    vec2(32.0, 400.0), //spruce_leaves
    vec2(48.0, 400.0), //spruce_log
    vec2(80.0, 400.0), //spruce_planks
    vec2(128.0, 400.0), //stone
    vec2(224.0, 400.0), //stripped_acacia_log
    vec2(288.0, 400.0), //stripped_birch_log
    vec2(320.0, 400.0), //stripped_cherry_log
    vec2(352.0, 400.0), //stripped_crimson_stem
    vec2(384.0, 400.0), //stripped_dark_oak_log
    vec2(416.0, 400.0), //stripped_jungle_log
    vec2(448.0, 400.0), //stripped_mangrove_log
    vec2(480.0, 400.0), //stripped_oak_log
    vec2(144.0, 336.0), //stripped_pale_oak_log  // <verif: bestmatch(d=8947)>
    vec2(0.0, 416.0), //stripped_spruce_log
    vec2(32.0, 416.0), //stripped_warped_stem
    vec2(400.0, 144.0), //suspicious_gravel_0  // <verif: bestmatch(d=4868)>
    vec2(400.0, 144.0), //suspicious_gravel_1  // <verif: bestmatch(d=7089)>
    vec2(400.0, 144.0), //suspicious_gravel_2  // <verif: bestmatch(d=9735)>
    vec2(400.0, 144.0), //suspicious_gravel_3  // <verif: bestmatch(d=13613)>
    vec2(224.0, 416.0), //suspicious_sand_0
    vec2(240.0, 416.0), //suspicious_sand_1
    vec2(256.0, 416.0), //suspicious_sand_2
    vec2(272.0, 416.0), //suspicious_sand_3
    vec2(448.0, 416.0), //terracotta
    vec2(144.0, 432.0), //tube_coral_block
    vec2(176.0, 432.0), //tuff
    vec2(368.0, 432.0), //warped_nylium
    vec2(384.0, 432.0), //warped_nylium_side
    vec2(400.0, 432.0), //warped_planks
    vec2(448.0, 432.0), //warped_stem
    vec2(496.0, 432.0), //warped_wart_block
    vec2(96.0, 448.0), //wet_sponge
    vec2(272.0, 448.0), //white_concrete
    vec2(288.0, 448.0), //white_concrete_powder
    vec2(368.0, 448.0), //white_terracotta
    vec2(400.0, 448.0), //white_wool
    vec2(464.0, 448.0), //yellow_concrete
    vec2(480.0, 448.0), //yellow_concrete_powder
    vec2(48.0, 464.0), //yellow_terracotta
    vec2(64.0, 464.0), //yellow_wool
    vec2(976.0, 0.0), //sandstonecut_red_sandstone1 // !! NON REPLACE - texture custom shaderpack (synthetic)
    vec2(976.0, 64.0), //sandstonecut_sandstone1 // !! NON REPLACE - texture custom shaderpack (synthetic)
    vec2(976.0, 112.0), //sandstonered_sandstone // !! NON REPLACE - texture custom shaderpack (synthetic)
    vec2(976.0, 128.0)  //sandstonesandstone // !! NON REPLACE - texture custom shaderpack (synthetic)
);

const vec2 bricks4BlockOffsets[NUM_4BRICKS_BLOCKS] = vec2[NUM_4BRICKS_BLOCKS](
    vec2(128.0, 16.0), //bamboo_block
    vec2(144.0, 48.0), //bamboo_planks
    vec2(176.0, 64.0), //bee_nest_side
    vec2(144.0, 144.0), //bricks
    vec2(240.0, 80.0), //cracked_nether_bricks  // <verif: bestmatch(d=6950)>
    vec2(288.0, 144.0), //dark_prismarine
    vec2(240.0, 80.0), //nether_bricks  // <verif: bestmatch(d=7318)>
    vec2(432.0, 336.0), //red_nether_bricks  // <verif: bestmatch(d=12724)>
    vec2(464.0, 224.0), //resin_bricks  // <verif: bestmatch(d=17703)>
    vec2(256.0, 400.0), //stripped_bamboo_block
    vec2(144.0, 416.0)   //sugar_cane
);

const vec2 bricks2BlockOffsets[NUM_2BRICKS_BLOCKS] = vec2[NUM_2BRICKS_BLOCKS](
    vec2(48.0, 144.0), //bookshelf
    vec2(96.0, 208.0), //chiseled_bookshelf_empty
    vec2(112.0, 208.0), //chiseled_bookshelf_occupied
    vec2(224.0, 240.0), //cracked_deepslate_bricks
    vec2(240.0, 240.0), //cracked_deepslate_tiles
    vec2(256.0, 16.0), //cracked_polished_blackstone_bricks
    vec2(256.0, 32.0), //cracked_stone_bricks
    vec2(320.0, 0.0), //deepslate_bricks
    vec2(368.0, 0.0), //end_stone_bricks
    vec2(160.0, 272.0), //mossy_stone_bricks
    vec2(80.0, 320.0), //polished_blackstone_bricks
    vec2(144.0, 400.0), //stone_bricks
    vec2(272.0, 208.0), //tuff_bricks  // <verif: bestmatch(d=15945)>
    vec2(544.0, 80.0), //bookshelf0 // !! NON REPLACE - texture custom shaderpack (synthetic)
    vec2(544.0, 96.0), //bookshelf1 // !! NON REPLACE - texture custom shaderpack (synthetic)
    vec2(544.0, 112.0), //bookshelf2 // !! NON REPLACE - texture custom shaderpack (synthetic)
    vec2(544.0, 128.0)  //bookshelf3 // !! NON REPLACE - texture custom shaderpack (synthetic)
);

const vec2 borderLessRotateBlockOffsets[BLR_BLOCKS] = vec2[BLR_BLOCKS](
    vec2(176.0, 240.0), //chiseled_copper  // <verif: bestmatch(d=10648)>
    vec2(176.0, 240.0), //copper_block
    vec2(176.0, 240.0), //copper_bulb  // <verif: bestmatch(d=21527)>
    vec2(176.0, 240.0), //copper_bulb_lit  // <verif: bestmatch(d=25991)>
    vec2(176.0, 240.0), //copper_bulb_lit_powered  // <verif: bestmatch(d=26220)>
    vec2(176.0, 240.0), //copper_bulb_powered  // <verif: bestmatch(d=21742)>
    vec2(176.0, 240.0), //copper_grate  // <verif: bestmatch(d=50859)>
    vec2(176.0, 240.0), //copper_trapdoor  // <verif: bestmatch(d=36865)>
    vec2(336.0, 112.0), //diamond_block
    vec2(368.0, 16.0), //exposed_chiseled_copper  // <verif: bestmatch(d=7985)>
    vec2(368.0, 16.0), //exposed_copper
    vec2(368.0, 16.0), //exposed_copper_bulb  // <verif: bestmatch(d=15585)>
    vec2(368.0, 16.0), //exposed_copper_bulb_lit  // <verif: bestmatch(d=20425)>
    vec2(368.0, 16.0), //exposed_copper_bulb_lit_powered  // <verif: bestmatch(d=20860)>
    vec2(368.0, 16.0), //exposed_copper_bulb_powered  // <verif: bestmatch(d=16020)>
    vec2(368.0, 16.0), //exposed_copper_grate  // <verif: bestmatch(d=49849)>
    vec2(368.0, 16.0), //exposed_copper_trapdoor  // <verif: bestmatch(d=36513)>
    vec2(400.0, 16.0), //gold_block
    vec2(464.0, 144.0), //lapis_block
    vec2(432.0, 288.0), //oxidized_chiseled_copper  // <verif: bestmatch(d=11197)>
    vec2(432.0, 288.0), //oxidized_copper
    vec2(432.0, 288.0), //oxidized_copper_bulb  // <verif: bestmatch(d=17525)>
    vec2(432.0, 288.0), //oxidized_copper_bulb_lit  // <verif: bestmatch(d=24753)>
    vec2(432.0, 288.0), //oxidized_copper_bulb_lit_powered  // <verif: bestmatch(d=25709)>
    vec2(432.0, 288.0), //oxidized_copper_bulb_powered  // <verif: bestmatch(d=18478)>
    vec2(432.0, 288.0), //oxidized_copper_grate  // <verif: bestmatch(d=49900)>
    vec2(432.0, 288.0), //oxidized_copper_trapdoor  // <verif: bestmatch(d=36029)>
    vec2(16.0, 320.0), //polished_andesite
    vec2(64.0, 320.0), //polished_blackstone
    vec2(96.0, 320.0), //polished_deepslate
    vec2(112.0, 320.0), //polished_diorite
    vec2(128.0, 320.0), //polished_granite
    vec2(288.0, 272.0), //polished_tuff  // <verif: bestmatch(d=10768)>
    vec2(160.0, 336.0), //quartz_block_side
    vec2(160.0, 336.0), //quartz_block_top
    vec2(496.0, 368.0), //shroomlight
    vec2(32.0, 448.0), //weathered_chiseled_copper  // <verif: bestmatch(d=11681)>
    vec2(32.0, 448.0), //weathered_copper
    vec2(32.0, 448.0), //weathered_copper_bulb  // <verif: bestmatch(d=14676)>
    vec2(32.0, 448.0), //weathered_copper_bulb_lit  // <verif: bestmatch(d=21185)>
    vec2(32.0, 448.0), //weathered_copper_bulb_lit_powered  // <verif: bestmatch(d=21912)>
    vec2(32.0, 448.0), //weathered_copper_bulb_powered  // <verif: bestmatch(d=15403)>
    vec2(32.0, 448.0), //weathered_copper_grate  // <verif: bestmatch(d=48996)>
    vec2(32.0, 448.0)   //weathered_copper_trapdoor  // <verif: bestmatch(d=35727)>
);

const vec2 borderLessBlockOffsets[BORDER_LESS_BLOCKS] = vec2[BORDER_LESS_BLOCKS](
    vec2(112.0, 224.0), //coal_ore
    vec2(192.0, 240.0), //copper_ore
    vec2(320.0, 16.0), //deepslate_coal_ore
    vec2(320.0, 32.0), //deepslate_copper_ore
    vec2(320.0, 48.0), //deepslate_diamond_ore
    vec2(320.0, 64.0), //deepslate_emerald_ore
    vec2(320.0, 80.0), //deepslate_gold_ore
    vec2(320.0, 96.0), //deepslate_iron_ore
    vec2(320.0, 112.0), //deepslate_lapis_ore
    vec2(320.0, 128.0), //deepslate_redstone_ore
    vec2(336.0, 128.0), //diamond_ore
    vec2(352.0, 112.0), //emerald_ore
    vec2(400.0, 32.0), //gold_ore
    vec2(448.0, 48.0), //iron_ore
    vec2(464.0, 160.0), //lapis_ore
    vec2(320.0, 272.0), //nether_gold_ore
    vec2(352.0, 272.0), //nether_quartz_ore
    vec2(208.0, 288.0), //ochre_froglight_side
    vec2(224.0, 288.0), //ochre_froglight_top
    vec2(496.0, 288.0), //pearlescent_froglight_side
    vec2(0.0, 304.0), //pearlescent_froglight_top
    vec2(208.0, 352.0), //redstone_ore
    vec2(272.0, 432.0), //verdant_froglight_side
    vec2(288.0, 432.0)   //verdant_froglight_top
);

const vec2 rotateBlockOffsets[ROTATE_BLOCKS] = vec2[ROTATE_BLOCKS](
    vec2(64.0, 80.0), //acacia_log_top
    vec2(96.0, 96.0), //ancient_debris_top
    vec2(128.0, 32.0), //bamboo_block_top
    vec2(144.0, 32.0), //bamboo_mosaic
    vec2(160.0, 0.0), //bamboo_trapdoor
    vec2(160.0, 48.0), //barrel_top
    vec2(160.0, 64.0), //barrel_top_open
    vec2(176.0, 16.0), //bee_nest_bottom
    vec2(176.0, 80.0), //bee_nest_top
    vec2(224.0, 16.0), //birch_log_top
    vec2(64.0, 128.0), //blast_furnace_top
    vec2(32.0, 144.0), //bone_block_top
    vec2(160.0, 160.0), //cactus_bottom
    vec2(192.0, 160.0), //cactus_top
    vec2(208.0, 160.0), //cake_bottom
    vec2(0.0, 176.0), //cake_top
    vec2(0.0, 192.0), //cauldron_bottom
    vec2(432.0, 128.0), //cauldron_inner
    vec2(48.0, 192.0), //cauldron_top
    vec2(16.0, 208.0), //cherry_log_top
    vec2(144.0, 208.0), //chiseled_bookshelf_top
    vec2(32.0, 224.0), //chorus_flower
    vec2(48.0, 224.0), //chorus_flower_dead
    vec2(96.0, 240.0), //composter_compost
    vec2(112.0, 240.0), //composter_ready
    vec2(144.0, 240.0), //composter_top
    vec2(64.0, 128.0), //crafter_bottom  // <verif: bestmatch(d=8743)>
    vec2(256.0, 80.0), //crafting_table_top
    vec2(64.0, 160.0), //creaking_heart_top  // <verif: bestmatch(d=13586)>
    vec2(64.0, 80.0), //creaking_heart_top_awake  // <verif: bestmatch(d=18743)>
    vec2(192.0, 144.0), //creaking_heart_top_dormant  // <verif: bestmatch(d=14406)>
    vec2(256.0, 240.0), //crimson_stem_top
    vec2(288.0, 80.0), //dark_oak_log_top
    vec2(288.0, 160.0), //daylight_detector_inverted_top
    vec2(288.0, 176.0), //daylight_detector_side
    vec2(288.0, 192.0), //daylight_detector_top
    vec2(336.0, 224.0), //dispenser_front_vertical
    vec2(352.0, 80.0), //dropper_front_vertical
    vec2(352.0, 96.0), //emerald_block
    vec2(384.0, 160.0), //furnace_top
    vec2(432.0, 128.0), //hopper_inside
    vec2(432.0, 160.0), //hopper_top
    vec2(448.0, 64.0), //iron_trapdoor
    vec2(448.0, 176.0), //jukebox_side
    vec2(464.0, 16.0), //jungle_log_top
    vec2(128.0, 256.0), //lodestone_side
    vec2(144.0, 256.0), //lodestone_top
    vec2(464.0, 256.0), //mangrove_log_top
    vec2(48.0, 272.0), //mangrove_trapdoor
    vec2(112.0, 272.0), //melon_top
    vec2(448.0, 272.0), //netherite_block
    vec2(448.0, 176.0), //note_block
    vec2(48.0, 288.0), //oak_log_top
    vec2(96.0, 288.0), //oak_trapdoor
    vec2(448.0, 368.0), //pale_oak_log_top  // <verif: bestmatch(d=22062)>
    vec2(256.0, 304.0), //piston_bottom
    vec2(272.0, 304.0), //piston_inner
    vec2(48.0, 320.0), //polished_basalt_top
    vec2(432.0, 320.0), //pumpkin_top
    vec2(128.0, 336.0), //purpur_pillar_top
    vec2(224.0, 336.0), //quartz_pillar_top
    vec2(96.0, 352.0), //redstone_block
    vec2(176.0, 352.0), //redstone_lamp
    vec2(192.0, 352.0), //redstone_lamp_on
    vec2(256.0, 352.0), //reinforced_deepslate_bottom
    vec2(288.0, 352.0), //reinforced_deepslate_top
    vec2(128.0, 368.0), //scaffolding_bottom
    vec2(160.0, 368.0), //scaffolding_top
    vec2(192.0, 368.0), //sculk_catalyst_bottom
    vec2(448.0, 368.0), //sea_lantern
    vec2(112.0, 384.0), //smithing_table_bottom
    vec2(160.0, 384.0), //smithing_table_top
    vec2(176.0, 384.0), //smoker_bottom
    vec2(240.0, 384.0), //smoker_top
    vec2(272.0, 384.0), //smooth_stone
    vec2(416.0, 384.0), //soul_soil
    vec2(64.0, 400.0), //spruce_log_top
    vec2(160.0, 400.0), //stonecutter_bottom
    vec2(240.0, 400.0), //stripped_acacia_log_top
    vec2(272.0, 400.0), //stripped_bamboo_block_top
    vec2(304.0, 400.0), //stripped_birch_log_top
    vec2(336.0, 400.0), //stripped_cherry_log_top
    vec2(368.0, 400.0), //stripped_crimson_stem_top
    vec2(400.0, 400.0), //stripped_dark_oak_log_top
    vec2(432.0, 400.0), //stripped_jungle_log_top
    vec2(464.0, 400.0), //stripped_mangrove_log_top
    vec2(496.0, 400.0), //stripped_oak_log_top
    vec2(144.0, 336.0), //stripped_pale_oak_log_top  // <verif: bestmatch(d=11323)>
    vec2(64.0, 400.0), //stripped_spruce_log_top  // <verif: bestmatch(d=3737)>
    vec2(48.0, 416.0), //stripped_warped_stem_top
    vec2(416.0, 416.0), //target_side
    vec2(432.0, 416.0), //target_top
    vec2(480.0, 416.0), //tnt_bottom
    vec2(0.0, 432.0), //tnt_top
    vec2(432.0, 128.0), //trial_spawner_bottom  // <verif: bestmatch(d=36493)>
    vec2(400.0, 208.0), //trial_spawner_top_active  // <verif: bestmatch(d=22314)>
    vec2(416.0, 48.0), //trial_spawner_top_active_ominous  // <verif: bestmatch(d=21756)>
    vec2(0.0, 368.0), //trial_spawner_top_ejecting_reward  // <verif: bestmatch(d=24545)>
    vec2(0.0, 368.0), //trial_spawner_top_ejecting_reward_ominous  // <verif: bestmatch(d=23853)>
    vec2(400.0, 208.0), //trial_spawner_top_inactive  // <verif: bestmatch(d=21586)>
    vec2(400.0, 240.0), //trial_spawner_top_inactive_ominous  // <verif: bestmatch(d=18480)>
    vec2(400.0, 192.0), //vault_bottom  // <verif: bestmatch(d=8905)>
    vec2(400.0, 192.0), //vault_bottom_ominous  // <verif: bestmatch(d=8905)>
    vec2(160.0, 384.0), //vault_top  // <verif: bestmatch(d=18509)>
    vec2(0.0, 368.0), //vault_top_ejecting  // <verif: bestmatch(d=18759)>
    vec2(0.0, 368.0), //vault_top_ejecting_ominous  // <verif: bestmatch(d=17799)>
    vec2(64.0, 128.0), //vault_top_ominous  // <verif: bestmatch(d=14292)>
    vec2(464.0, 432.0)   //warped_stem_top
);

vec2 minUVNormal(int blockIndex) {
    return normalBlockOffsets[blockIndex] / atlasSize;
}

vec2 maxUVNormal(int blockIndex) {
    return (normalBlockOffsets[blockIndex] + vec2(16.0, 16.0)) / atlasSize;
}

vec2 minUV4Bricks(int blockIndex) {
    return bricks4BlockOffsets[blockIndex] / atlasSize;
}

vec2 maxUV4Bricks(int blockIndex) {
    return (bricks4BlockOffsets[blockIndex] + vec2(16.0, 16.0)) / atlasSize;
}

vec2 minUV2Bricks(int blockIndex) {
    return bricks2BlockOffsets[blockIndex] / atlasSize;
}

vec2 maxUV2Bricks(int blockIndex) {
    return (bricks2BlockOffsets[blockIndex] + vec2(16.0, 16.0)) / atlasSize;
}

vec2 minUVBLR(int blockIndex) {
    return (borderLessRotateBlockOffsets[blockIndex]+ vec2(1.0, 1.0)) / atlasSize;
}

vec2 maxUVBLR(int blockIndex) {
    return (borderLessRotateBlockOffsets[blockIndex] + vec2(15.0, 15.0)) /atlasSize;
}

vec2 minUVBorderLess(int blockIndex) {
    return (borderLessBlockOffsets[blockIndex]+ vec2(1.0, 1.0)) / atlasSize;
}

vec2 maxUVBorderLess(int blockIndex) {
    return (borderLessBlockOffsets[blockIndex] + vec2(15.0, 15.0)) / atlasSize;
}

vec2 minUVRotate(int blockIndex){
    return (rotateBlockOffsets[blockIndex]) / atlasSize;
}

vec2 maxUVRotate(int blockIndex){
    return (rotateBlockOffsets[blockIndex] + vec2(16.0, 16.0)) / atlasSize; 
}

vec2 minUVdirtpath() {
    return vec2(352.0, 960.0) / atlasSize;
}

vec2 maxUVdirtpath() {
    return (vec2(352.0, 960.0) + vec2(16.0, 16.0)) / atlasSize;
}
