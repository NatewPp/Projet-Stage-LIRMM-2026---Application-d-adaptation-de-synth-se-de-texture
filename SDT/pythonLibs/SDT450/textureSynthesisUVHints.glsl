// uv offsets
#define NUM_NORMAL_BLOCKS 248
#define NUM_4BRICKS_BLOCKS 11
#define NUM_2BRICKS_BLOCKS 17
#define BLR_BLOCKS 44
#define BORDER_LESS_BLOCKS 24
#define ROTATE_BLOCKS 108

// Define UV offsets for each block category
const vec2 normalBlockOffsets[NUM_NORMAL_BLOCKS] = vec2[NUM_NORMAL_BLOCKS](
    vec2(464.0, 160.0), //acacia_log
    vec2(16.0, 272.0), //acacia_planks
    vec2(304.0, 272.0), //amethyst_block
    vec2(400.0, 272.0), //ancient_debris_side
    vec2(16.0, 320.0), //andesite
    vec2(256.0, 320.0), //azalea_leaves
    vec2(400.0, 320.0), //azalea_top
    vec2(352.0, 416.0), //barrel_side
    vec2(16.0, 464.0), //basalt_side
    vec2(64.0, 464.0), //basalt_top
    vec2(160.0, 464.0), //bedrock
    vec2(576.0, 304.0), //birch_leaves
    vec2(576.0, 352.0), //birch_log
    vec2(576.0, 448.0), //birch_planks
    vec2(624.0, 208.0), //black_concrete
    vec2(624.0, 256.0), //black_concrete_powder
    vec2(672.0, 16.0), //black_terracotta
    vec2(672.0, 64.0), //black_wool
    vec2(672.0, 112.0), //blackstone
    vec2(672.0, 160.0), //blackstone_top
    vec2(720.0, 16.0), //blue_concrete
    vec2(720.0, 64.0), //blue_concrete_powder
    vec2(720.0, 160.0), //blue_ice
    vec2(720.0, 400.0), //blue_terracotta
    vec2(720.0, 448.0), //blue_wool
    vec2(768.0, 16.0), //bone_block_side
    vec2(768.0, 208.0), //brain_coral_block
    vec2(816.0, 64.0), //brown_concrete
    vec2(816.0, 112.0), //brown_concrete_powder
    vec2(816.0, 256.0), //brown_mushroom_block
    vec2(816.0, 448.0), //brown_terracotta
    vec2(864.0, 16.0), //brown_wool
    vec2(864.0, 112.0), //bubble_coral_block
    vec2(912.0, 208.0), //calcite
    vec2(784.0, 528.0), //cherry_leaves
    vec2(832.0, 528.0), //cherry_log
    vec2(928.0, 528.0), //cherry_planks
    vec2(64.0, 624.0), //chorus_plant
    vec2(112.0, 624.0), //clay
    vec2(208.0, 624.0), //coal_block
    vec2(304.0, 624.0), //coarse_dirt
    vec2(352.0, 624.0), //cobbled_deepslate
    vec2(400.0, 624.0), //cobblestone
    vec2(976.0, 720.0), //creaking_heart
    vec2(16.0, 768.0), //creaking_heart_awake
    vec2(64.0, 768.0), //creaking_heart_dormant
    vec2(400.0, 768.0), //crimson_nylium
    vec2(448.0, 768.0), //crimson_nylium_side
    vec2(496.0, 768.0), //crimson_planks
    vec2(640.0, 768.0), //crimson_stem  // <verif: bestmatch(d=2311)>
    vec2(784.0, 768.0), //crying_obsidian
    vec2(64.0, 816.0), //cyan_concrete
    vec2(112.0, 816.0), //cyan_concrete_powder
    vec2(352.0, 816.0), //cyan_terracotta
    vec2(400.0, 816.0), //cyan_wool
    vec2(640.0, 816.0), //dark_oak_leaves
    vec2(688.0, 816.0), //dark_oak_log
    vec2(784.0, 816.0), //dark_oak_planks
    vec2(160.0, 864.0), //dead_brain_coral_block
    vec2(304.0, 864.0), //dead_bubble_coral_block
    vec2(496.0, 864.0), //dead_fire_coral_block
    vec2(640.0, 864.0), //dead_horn_coral_block
    vec2(784.0, 864.0), //dead_tube_coral_block
    vec2(976.0, 864.0), //deepslate
    vec2(448.0, 912.0), //deepslate_tiles
    vec2(496.0, 912.0), //deepslate_top
    vec2(208.0, 960.0), //diorite
    vec2(256.0, 960.0), //dirt
    vec2(352.0, 960.0), //dirt_path_top
    vec2(496.0, 960.0), //dragon_egg
    vec2(1040.0, 832.0), //dripstone_block
    vec2(1088.0, 64.0), //enchanting_table_bottom
    vec2(1088.0, 400.0), //end_stone
    vec2(1136.0, 208.0), //farmland
    vec2(1136.0, 256.0), //farmland_moist
    vec2(1136.0, 496.0), //fire_coral_block
    vec2(1136.0, 880.0), //flowering_azalea_leaves
    vec2(1136.0, 976.0), //flowering_azalea_top
    vec2(1184.0, 448.0), //gilded_blackstone
    vec2(1184.0, 640.0), //glow_lichen
    vec2(1184.0, 688.0), //glowstone
    vec2(1184.0, 880.0), //granite
    vec2(1184.0, 928.0), //grass_block_side
    vec2(1184.0, 976.0), //grass_block_side_overlay
    vec2(1232.0, 16.0), //grass_block_snow
    vec2(1232.0, 64.0), //grass_block_top
    vec2(1232.0, 112.0), //gravel
    vec2(1232.0, 256.0), //gray_concrete
    vec2(1232.0, 304.0), //gray_concrete_powder
    vec2(1232.0, 544.0), //gray_terracotta
    vec2(1232.0, 592.0), //gray_wool
    vec2(1232.0, 736.0), //green_concrete
    vec2(1232.0, 784.0), //green_concrete_powder
    vec2(1280.0, 16.0), //green_terracotta
    vec2(1280.0, 64.0), //green_wool
    vec2(1280.0, 304.0), //hay_block_side
    vec2(1280.0, 352.0), //hay_block_top
    vec2(1280.0, 448.0), //honey_block_bottom
    vec2(1280.0, 496.0), //honey_block_side
    vec2(1280.0, 544.0), //honey_block_top
    vec2(1280.0, 592.0), //honeycomb_block
    vec2(1280.0, 688.0), //hopper_outside
    vec2(1280.0, 832.0), //horn_coral_block
    vec2(1280.0, 928.0), //ice
    vec2(1328.0, 784.0), //jungle_leaves
    vec2(1328.0, 832.0), //jungle_log
    vec2(1328.0, 928.0), //jungle_planks
    vec2(1376.0, 512.0), //lava_still  // <verif: bestmatch(d=13059)>
    vec2(1376.0, 544.0), //leaf_litter
    vec2(1376.0, 928.0), //light_blue_concrete
    vec2(1376.0, 976.0), //light_blue_concrete_powder
    vec2(1424.0, 208.0), //light_blue_terracotta
    vec2(1424.0, 256.0), //light_blue_wool
    vec2(1424.0, 400.0), //light_gray_concrete
    vec2(1424.0, 448.0), //light_gray_concrete_powder
    vec2(1424.0, 688.0), //light_gray_terracotta
    vec2(1424.0, 736.0), //light_gray_wool
    vec2(1472.0, 160.0), //lime_concrete
    vec2(1472.0, 208.0), //lime_concrete_powder
    vec2(1472.0, 448.0), //lime_terracotta
    vec2(1472.0, 496.0), //lime_wool
    vec2(1472.0, 928.0), //magenta_concrete
    vec2(1472.0, 976.0), //magenta_concrete_powder
    vec2(1520.0, 208.0), //magenta_terracotta
    vec2(1520.0, 256.0), //magenta_wool
    vec2(1520.0, 304.0), //magma  // <verif: bestmatch(d=4767)>
    vec2(1520.0, 448.0), //mangrove_leaves
    vec2(1520.0, 496.0), //mangrove_log
    vec2(1520.0, 592.0), //mangrove_planks
    vec2(1568.0, 304.0), //mangrove_roots_side
    vec2(1568.0, 352.0), //mangrove_roots_top
    vec2(1520.0, 928.0), //melon_side
    vec2(1568.0, 64.0), //moss_block
    vec2(1568.0, 112.0), //mossy_cobblestone
    vec2(1568.0, 208.0), //mud
    vec2(1568.0, 304.0), //muddy_mangrove_roots_side
    vec2(1568.0, 352.0), //muddy_mangrove_roots_top
    vec2(1568.0, 400.0), //mushroom_block_inside
    vec2(1568.0, 448.0), //mushroom_stem
    vec2(1568.0, 496.0), //mycelium_side
    vec2(1568.0, 544.0), //mycelium_top
    vec2(1568.0, 832.0), //nether_wart_block
    vec2(1616.0, 64.0), //netherrack
    vec2(1616.0, 256.0), //oak_leaves
    vec2(1616.0, 304.0), //oak_log
    vec2(1616.0, 400.0), //oak_planks
    vec2(1088.0, 64.0), //obsidian
    vec2(1664.0, 112.0), //orange_concrete
    vec2(1664.0, 160.0), //orange_concrete_powder
    vec2(1664.0, 400.0), //orange_terracotta
    vec2(1664.0, 496.0), //orange_wool
    vec2(1712.0, 304.0), //packed_ice
    vec2(1712.0, 352.0), //packed_mud
    vec2(1712.0, 496.0), //pale_moss_block
    vec2(1712.0, 496.0), //pale_moss_carpet
    vec2(1712.0, 784.0), //pale_oak_leaves
    vec2(1712.0, 832.0), //pale_oak_log
    vec2(1712.0, 928.0), //pale_oak_planks
    vec2(1760.0, 352.0), //pink_concrete
    vec2(1760.0, 400.0), //pink_concrete_powder
    vec2(1760.0, 736.0), //pink_terracotta
    vec2(1760.0, 832.0), //pink_wool
    vec2(1808.0, 544.0), //podzol_side
    vec2(1808.0, 592.0), //podzol_top
    vec2(1904.0, 64.0), //powder_snow
    vec2(1904.0, 208.0), //prismarine  // <verif: bestmatch(d=1376)>
    vec2(1904.0, 304.0), //pumpkin_side
    vec2(1904.0, 544.0), //purple_concrete
    vec2(1904.0, 592.0), //purple_concrete_powder
    vec2(1904.0, 832.0), //purple_terracotta
    vec2(1904.0, 880.0), //purple_wool
    vec2(1952.0, 64.0), //quartz_block_bottom
    vec2(1952.0, 256.0), //quartz_pillar
    vec2(1952.0, 448.0), //raw_copper_block
    vec2(1952.0, 496.0), //raw_gold_block
    vec2(1952.0, 544.0), //raw_iron_block
    vec2(1952.0, 688.0), //red_concrete
    vec2(1952.0, 736.0), //red_concrete_powder
    vec2(1952.0, 880.0), //red_mushroom_block
    vec2(1952.0, 976.0), //red_sand
    vec2(2000.0, 16.0), //red_sandstone
    vec2(2000.0, 64.0), //red_sandstone_bottom
    vec2(2000.0, 112.0), //red_sandstone_top
    vec2(2000.0, 304.0), //red_terracotta
    vec2(2000.0, 400.0), //red_wool
    vec2(352.0, 1040.0), //resin_block
    vec2(448.0, 1040.0), //resin_clump
    vec2(784.0, 768.0), //respawn_anchor_bottom
    vec2(880.0, 1040.0), //rooted_dirt
    vec2(1024.0, 1040.0), //sand
    vec2(1072.0, 1040.0), //sandstone
    vec2(1120.0, 1040.0), //sandstone_bottom
    vec2(1168.0, 1040.0), //sandstone_top
    vec2(1648.0, 1040.0), //sculk
    vec2(1552.0, 1040.0), //sculk_catalyst_top
    vec2(1552.0, 1040.0), //sculk_catalyst_top_bloom  // <verif: bestmatch(d=946)>
    vec2(1648.0, 1040.0), //sculk_sensor_bottom
    vec2(1840.0, 1040.0), //sculk_sensor_top
    vec2(1648.0, 1040.0), //sculk_shrieker_bottom
    vec2(112.0, 1088.0), //sculk_vein  // <verif: bestmatch(d=11294)>
    vec2(496.0, 1088.0), //slime_block
    vec2(1216.0, 1088.0), //smooth_basalt
    vec2(496.0, 1136.0), //soul_sand
    vec2(688.0, 1136.0), //sponge
    vec2(928.0, 1136.0), //spruce_leaves
    vec2(976.0, 1136.0), //spruce_log
    vec2(1072.0, 1136.0), //spruce_planks
    vec2(1216.0, 1136.0), //stone
    vec2(1504.0, 1136.0), //stripped_acacia_log
    vec2(1696.0, 1136.0), //stripped_birch_log
    vec2(1792.0, 1136.0), //stripped_cherry_log
    vec2(1888.0, 1136.0), //stripped_crimson_stem
    vec2(1984.0, 1136.0), //stripped_dark_oak_log
    vec2(64.0, 1184.0), //stripped_jungle_log
    vec2(160.0, 1184.0), //stripped_mangrove_log
    vec2(256.0, 1184.0), //stripped_oak_log
    vec2(352.0, 1184.0), //stripped_pale_oak_log
    vec2(448.0, 1184.0), //stripped_spruce_log
    vec2(544.0, 1184.0), //stripped_warped_stem
    vec2(1120.0, 1184.0), //suspicious_gravel_0
    vec2(1168.0, 1184.0), //suspicious_gravel_1
    vec2(1216.0, 1184.0), //suspicious_gravel_2
    vec2(1264.0, 1184.0), //suspicious_gravel_3
    vec2(1312.0, 1184.0), //suspicious_sand_0
    vec2(1360.0, 1184.0), //suspicious_sand_1
    vec2(1408.0, 1184.0), //suspicious_sand_2
    vec2(1456.0, 1184.0), //suspicious_sand_3
    vec2(16.0, 1232.0), //terracotta
    vec2(1360.0, 1232.0), //tube_coral_block
    vec2(1456.0, 1232.0), //tuff
    vec2(832.0, 1280.0), //warped_nylium
    vec2(880.0, 1280.0), //warped_nylium_side
    vec2(928.0, 1280.0), //warped_planks
    vec2(1072.0, 1280.0), //warped_stem  // <verif: bestmatch(d=1498)>
    vec2(1216.0, 1280.0), //warped_wart_block
    vec2(160.0, 1328.0), //wet_sponge
    vec2(688.0, 1328.0), //white_concrete
    vec2(736.0, 1328.0), //white_concrete_powder
    vec2(976.0, 1328.0), //white_terracotta
    vec2(1072.0, 1328.0), //white_wool
    vec2(1360.0, 1328.0), //yellow_concrete
    vec2(1408.0, 1328.0), //yellow_concrete_powder
    vec2(1648.0, 1328.0), //yellow_terracotta
    vec2(1696.0, 1328.0), //yellow_wool
    vec2(976.0, 0.0), //sandstonecut_red_sandstone1 // !! NON REPLACE - texture custom shaderpack (synthetic)
    vec2(976.0, 64.0), //sandstonecut_sandstone1 // !! NON REPLACE - texture custom shaderpack (synthetic)
    vec2(976.0, 112.0), //sandstonered_sandstone // !! NON REPLACE - texture custom shaderpack (synthetic)
    vec2(976.0, 128.0) //sandstonesandstone // !! NON REPLACE - texture custom shaderpack (synthetic)
);

const vec2 bricks4BlockOffsets[NUM_4BRICKS_BLOCKS] = vec2[NUM_4BRICKS_BLOCKS](
    vec2(16.0, 368.0), //bamboo_block
    vec2(16.0, 416.0), //bamboo_planks
    vec2(352.0, 464.0), //bee_nest_side
    vec2(768.0, 400.0), //bricks
    vec2(16.0, 720.0), //cracked_nether_bricks
    vec2(928.0, 816.0), //dark_prismarine
    vec2(1568.0, 592.0), //nether_bricks
    vec2(1952.0, 928.0), //red_nether_bricks
    vec2(400.0, 1040.0), //resin_bricks
    vec2(1600.0, 1136.0), //stripped_bamboo_block
    vec2(880.0, 1184.0)  //sugar_cane
);

const vec2 bricks2BlockOffsets[NUM_2BRICKS_BLOCKS] = vec2[NUM_2BRICKS_BLOCKS](
    vec2(768.0, 112.0), //bookshelf
    vec2(112.0, 576.0), //chiseled_bookshelf_empty
    vec2(160.0, 576.0), //chiseled_bookshelf_occupied
    vec2(928.0, 672.0), //cracked_deepslate_bricks
    vec2(976.0, 672.0), //cracked_deepslate_tiles
    vec2(64.0, 720.0), //cracked_polished_blackstone_bricks
    vec2(112.0, 720.0), //cracked_stone_bricks
    vec2(16.0, 912.0), //deepslate_bricks
    vec2(1088.0, 448.0), //end_stone_bricks
    vec2(1568.0, 160.0), //mossy_stone_bricks
    vec2(1856.0, 304.0), //polished_blackstone_bricks
    vec2(1264.0, 1136.0), //stone_bricks
    vec2(1504.0, 1232.0), //tuff_bricks
    vec2(544.0, 80.0), //bookshelf0 // !! NON REPLACE - texture custom shaderpack (synthetic)
    vec2(544.0, 96.0), //bookshelf1 // !! NON REPLACE - texture custom shaderpack (synthetic)
    vec2(544.0, 112.0), //bookshelf2 // !! NON REPLACE - texture custom shaderpack (synthetic)
    vec2(544.0, 128.0) //bookshelf3 // !! NON REPLACE - texture custom shaderpack (synthetic)
);

const vec2 borderLessRotateBlockOffsets[BLR_BLOCKS] = vec2[BLR_BLOCKS](
    vec2(304.0, 576.0), //chiseled_copper
    vec2(256.0, 672.0), //copper_block
    vec2(304.0, 672.0), //copper_bulb
    vec2(352.0, 672.0), //copper_bulb_lit
    vec2(400.0, 672.0), //copper_bulb_lit_powered
    vec2(448.0, 672.0), //copper_bulb_powered
    vec2(640.0, 672.0), //copper_grate
    vec2(832.0, 672.0), //copper_trapdoor
    vec2(112.0, 960.0), //diamond_block
    vec2(1088.0, 496.0), //exposed_chiseled_copper
    vec2(1088.0, 544.0), //exposed_copper
    vec2(1088.0, 640.0), //exposed_copper_bulb
    vec2(1088.0, 688.0), //exposed_copper_bulb_lit
    vec2(1088.0, 736.0), //exposed_copper_bulb_lit_powered
    vec2(1088.0, 784.0), //exposed_copper_bulb_powered
    vec2(1088.0, 976.0), //exposed_copper_grate
    vec2(1136.0, 64.0), //exposed_copper_trapdoor
    vec2(1184.0, 736.0), //gold_block
    vec2(1376.0, 256.0), //lapis_block
    vec2(1664.0, 592.0), //oxidized_chiseled_copper
    vec2(1664.0, 640.0), //oxidized_copper
    vec2(1664.0, 736.0), //oxidized_copper_bulb
    vec2(1664.0, 784.0), //oxidized_copper_bulb_lit
    vec2(1664.0, 832.0), //oxidized_copper_bulb_lit_powered
    vec2(1664.0, 880.0), //oxidized_copper_bulb_powered
    vec2(1712.0, 64.0), //oxidized_copper_grate
    vec2(1712.0, 160.0), //oxidized_copper_trapdoor
    vec2(1856.0, 112.0), //polished_andesite
    vec2(1856.0, 256.0), //polished_blackstone
    vec2(1856.0, 352.0), //polished_deepslate
    vec2(1856.0, 400.0), //polished_diorite
    vec2(1856.0, 448.0), //polished_granite
    vec2(1856.0, 496.0), //polished_tuff
    vec2(1952.0, 112.0), //quartz_block_side
    vec2(1952.0, 112.0), //quartz_block_top
    vec2(400.0, 1088.0), //shroomlight
    vec2(1360.0, 1280.0), //weathered_chiseled_copper
    vec2(1408.0, 1280.0), //weathered_copper
    vec2(1504.0, 1280.0), //weathered_copper_bulb
    vec2(1552.0, 1280.0), //weathered_copper_bulb_lit
    vec2(1600.0, 1280.0), //weathered_copper_bulb_lit_powered
    vec2(1648.0, 1280.0), //weathered_copper_bulb_powered
    vec2(1840.0, 1280.0), //weathered_copper_grate
    vec2(1936.0, 1280.0)  //weathered_copper_trapdoor
);

const vec2 borderLessBlockOffsets[BORDER_LESS_BLOCKS] = vec2[BORDER_LESS_BLOCKS](
    vec2(256.0, 624.0), //coal_ore
    vec2(736.0, 672.0), //copper_ore
    vec2(64.0, 912.0), //deepslate_coal_ore
    vec2(112.0, 912.0), //deepslate_copper_ore
    vec2(160.0, 912.0), //deepslate_diamond_ore
    vec2(208.0, 912.0), //deepslate_emerald_ore
    vec2(256.0, 912.0), //deepslate_gold_ore
    vec2(304.0, 912.0), //deepslate_iron_ore
    vec2(352.0, 912.0), //deepslate_lapis_ore
    vec2(400.0, 912.0), //deepslate_redstone_ore
    vec2(160.0, 960.0), //diamond_ore
    vec2(1088.0, 16.0), //emerald_ore
    vec2(1184.0, 784.0), //gold_ore
    vec2(1328.0, 208.0), //iron_ore
    vec2(1376.0, 304.0), //lapis_ore
    vec2(1568.0, 640.0), //nether_gold_ore
    vec2(1568.0, 736.0), //nether_quartz_ore
    vec2(1616.0, 832.0), //ochre_froglight_side
    vec2(1616.0, 880.0), //ochre_froglight_top
    vec2(1760.0, 64.0), //pearlescent_froglight_side
    vec2(1760.0, 112.0), //pearlescent_froglight_top
    vec2(2000.0, 784.0), //redstone_ore
    vec2(544.0, 1280.0), //verdant_froglight_side
    vec2(592.0, 1280.0)  //verdant_froglight_top
);

const vec2 rotateBlockOffsets[ROTATE_BLOCKS] = vec2[ROTATE_BLOCKS](
    vec2(464.0, 208.0), //acacia_log_top
    vec2(448.0, 272.0), //ancient_debris_top
    vec2(64.0, 368.0), //bamboo_block_top
    vec2(448.0, 368.0), //bamboo_mosaic
    vec2(256.0, 416.0), //bamboo_trapdoor
    vec2(400.0, 416.0), //barrel_top
    vec2(448.0, 416.0), //barrel_top_open
    vec2(208.0, 464.0), //bee_nest_bottom
    vec2(400.0, 464.0), //bee_nest_top
    vec2(576.0, 400.0), //birch_log_top
    vec2(672.0, 352.0), //blast_furnace_top
    vec2(768.0, 64.0), //bone_block_top
    vec2(864.0, 304.0), //cactus_bottom
    vec2(864.0, 448.0), //cactus_top
    vec2(912.0, 16.0), //cake_bottom
    vec2(912.0, 160.0), //cake_top
    vec2(112.0, 528.0), //cauldron_bottom
    vec2(160.0, 528.0), //cauldron_inner
    vec2(256.0, 528.0), //cauldron_top
    vec2(880.0, 528.0), //cherry_log_top
    vec2(256.0, 576.0), //chiseled_bookshelf_top
    vec2(976.0, 576.0), //chorus_flower
    vec2(16.0, 624.0), //chorus_flower_dead
    vec2(976.0, 624.0), //composter_compost
    vec2(16.0, 672.0), //composter_ready
    vec2(112.0, 672.0), //composter_top
    vec2(160.0, 720.0), //crafter_bottom
    vec2(928.0, 720.0), //crafting_table_top
    vec2(112.0, 768.0), //creaking_heart_top
    vec2(160.0, 768.0), //creaking_heart_top_awake
    vec2(208.0, 768.0), //creaking_heart_top_dormant
    vec2(688.0, 768.0), //crimson_stem_top
    vec2(736.0, 816.0), //dark_oak_log_top
    vec2(976.0, 816.0), //daylight_detector_inverted_top
    vec2(16.0, 864.0), //daylight_detector_side
    vec2(64.0, 864.0), //daylight_detector_top
    vec2(448.0, 960.0), //dispenser_front_vertical
    vec2(1040.0, 928.0), //dropper_front_vertical
    vec2(1040.0, 976.0), //emerald_block
    vec2(1184.0, 400.0), //furnace_top
    vec2(160.0, 528.0), //hopper_inside
    vec2(1280.0, 736.0), //hopper_top
    vec2(1328.0, 256.0), //iron_trapdoor
    vec2(1616.0, 112.0), //jukebox_side
    vec2(1328.0, 880.0), //jungle_log_top
    vec2(1472.0, 544.0), //lodestone_side
    vec2(1472.0, 592.0), //lodestone_top
    vec2(1520.0, 544.0), //mangrove_log_top
    vec2(1520.0, 832.0), //mangrove_trapdoor
    vec2(1568.0, 16.0), //melon_top
    vec2(1616.0, 16.0), //netherite_block
    vec2(1616.0, 112.0), //note_block
    vec2(1616.0, 352.0), //oak_log_top
    vec2(1616.0, 496.0), //oak_trapdoor
    vec2(1712.0, 880.0), //pale_oak_log_top
    vec2(1760.0, 880.0), //piston_bottom
    vec2(1760.0, 928.0), //piston_inner
    vec2(1856.0, 208.0), //polished_basalt_top
    vec2(1904.0, 400.0), //pumpkin_top
    vec2(1952.0, 16.0), //purpur_pillar_top
    vec2(1952.0, 304.0), //quartz_pillar_top
    vec2(2000.0, 448.0), //redstone_block
    vec2(2000.0, 688.0), //redstone_lamp
    vec2(2000.0, 736.0), //redstone_lamp_on
    vec2(2000.0, 928.0), //reinforced_deepslate_bottom
    vec2(16.0, 1040.0), //reinforced_deepslate_top
    vec2(1216.0, 1040.0), //scaffolding_bottom
    vec2(1312.0, 1040.0), //scaffolding_top
    vec2(1408.0, 1040.0), //sculk_catalyst_bottom
    vec2(160.0, 1088.0), //sea_lantern  // <verif: bestmatch(d=1440)>
    vec2(784.0, 1088.0), //smithing_table_bottom
    vec2(928.0, 1088.0), //smithing_table_top
    vec2(976.0, 1088.0), //smoker_bottom
    vec2(1168.0, 1088.0), //smoker_top
    vec2(1264.0, 1088.0), //smooth_stone
    vec2(544.0, 1136.0), //soul_soil
    vec2(1024.0, 1136.0), //spruce_log_top
    vec2(1312.0, 1136.0), //stonecutter_bottom
    vec2(1552.0, 1136.0), //stripped_acacia_log_top
    vec2(1648.0, 1136.0), //stripped_bamboo_block_top
    vec2(1744.0, 1136.0), //stripped_birch_log_top
    vec2(1840.0, 1136.0), //stripped_cherry_log_top
    vec2(1936.0, 1136.0), //stripped_crimson_stem_top
    vec2(16.0, 1184.0), //stripped_dark_oak_log_top
    vec2(112.0, 1184.0), //stripped_jungle_log_top
    vec2(208.0, 1184.0), //stripped_mangrove_log_top
    vec2(304.0, 1184.0), //stripped_oak_log_top
    vec2(400.0, 1184.0), //stripped_pale_oak_log_top
    vec2(496.0, 1184.0), //stripped_spruce_log_top
    vec2(592.0, 1184.0), //stripped_warped_stem_top
    vec2(1936.0, 1184.0), //target_side
    vec2(1984.0, 1184.0), //target_top
    vec2(352.0, 1232.0), //tnt_bottom
    vec2(448.0, 1232.0), //tnt_top
    vec2(688.0, 1232.0), //trial_spawner_bottom
    vec2(928.0, 1232.0), //trial_spawner_top_active
    vec2(976.0, 1232.0), //trial_spawner_top_active_ominous
    vec2(1024.0, 1232.0), //trial_spawner_top_ejecting_reward
    vec2(1072.0, 1232.0), //trial_spawner_top_ejecting_reward_ominous
    vec2(1120.0, 1232.0), //trial_spawner_top_inactive
    vec2(1168.0, 1232.0), //trial_spawner_top_inactive_ominous
    vec2(1792.0, 1232.0), //vault_bottom
    vec2(1792.0, 1232.0), //vault_bottom_ominous
    vec2(352.0, 1280.0), //vault_top
    vec2(400.0, 1280.0), //vault_top_ejecting
    vec2(448.0, 1280.0), //vault_top_ejecting_ominous
    vec2(496.0, 1280.0), //vault_top_ominous
    vec2(1120.0, 1280.0)  //warped_stem_top
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
