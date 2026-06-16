#if USE_HARD_CODED_GLASS_COLORS > 0

/*
#hardcoded glass colors
block.10040 =  orange_stained_glass orange_stained_glass_pane
block.10041 =  magenta_stained_glass magenta_stained_glass_pane
block.10042 =  light_blue_stained_glass light_blue_stained_glass_pane
block.10043 =  yellow_stained_glass yellow_stained_glass_pane
block.10044 =  lime_stained_glass lime_stained_glass_pane
 block.10045 = pink_stained_glass pink_stained_glass_pane
 block.10046 = gray_stained_glass gray_stained_glass_pane
 block.10047 = light_gray_stained_glass light_gray_stained_glass_pane
 block.10048 = cyan_stained_glass cyan_stained_glass_pane
 block.10049 = purple_stained_glass purple_stained_glass_pane
 block.10050 = blue_stained_glass blue_stained_glass_pane
 block.10051 = brown_stained_glass brown_stained_glass_pane
 block.10052 = green_stained_glass green_stained_glass_pane
 block.10053 = red_stained_glass red_stained_glass_pane
 block.10054 = black_stained_glass black_stained_glass_pane
 block.10055 = tinted_glass tinted_glass_pane
 */
 
 float c_id = currentRenderedItemId > 0 ? currentRenderedItemId : mc_Entity.x;
 
 light_color.rgb = 
	//glass
		(c_id == 10040.0) ?  vec3(1.0,0.8,0.)
		:(c_id == 10041.0) ?  vec3(1.0,0.0,1.0)
		 :(c_id == 10042.0) ?  vec3(0.5,0.5,1.0)
		  :(c_id == 10043.0) ?   vec3(1.0,1.0,0.0)
		   :(c_id == 10044.0) ?   vec3(0.3,1.0,0.1)
			:(c_id == 10045.0) ?   vec3(1.0,0.7,0.7)
			 :(c_id == 10046.0) ?   vec3(0.5,0.5,0.5)
			  :(c_id == 10047.0) ?   vec3(0.7,0.7,0.7)
			   :(c_id == 10048.0) ?   vec3(0.0,1.0,1.0)
				:(c_id == 10049.0) ?   vec3(0.5,0.0,1.0)
				 :(c_id == 10050.0) ?   vec3(0.0,0.0,1.0)
				 :(c_id == 10051.0) ?   vec3(0.7,.6,0.0)
				  :(c_id == 10052.0) ?   vec3(0.0,1.0,0.0)
				   :(c_id == 10053.0) ?   vec3(1.0,0.0,0.0)
					:(c_id == 10054.0) ?   vec3(0.0,0.0,0.0)
					 :(c_id == 10055.0) ?   vec3(0.0,0.0,0.0)
	//glowing color
		 :(c_id == 10070.0) ?   vec3(GLOW_BERRIES_R,GLOW_BERRIES_G,GLOW_BERRIES_B) 
		  :(c_id == 10071.0) ?   vec3(FROG_OCHE_R,FROG_OCHE_G,FROG_OCHE_B) 
		   :(c_id == 10072.0) ?   vec3(FROG_PEARL_R,FROG_PEARL_G,FROG_PEARL_B) 
		    :(c_id == 10073.0) ?   vec3(FROG_VER_R,FROG_VER_G,FROG_VER_B) 
				 
	//glowing item frames
		: (entityId == 20011) ? vec3(GLOW_FRAME_R,GLOW_FRAME_G,GLOW_FRAME_B) 
				 
				 
					: light_color.rgb;
					
	
					
#endif