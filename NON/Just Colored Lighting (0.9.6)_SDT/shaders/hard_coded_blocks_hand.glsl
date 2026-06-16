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


    //## SATURATED COLORS (very colorful)

    #define RED  vec3(1.,.0,.0) 
    #define RED_ORANGE  vec3(1.,.25,.0) 
    #define ORANGE  vec3(1.,.5,.0) 
    #define YELLOW  vec3(1.,1.,.0) 
    #define YELLOW_GREEN  vec3(.5,1.,.0) 
    #define GREEN  vec3(.0,1.,.0) 
    #define GREEN_CYAN  vec3(.0,1.,.5) 
    #define CYAN  vec3(.0,1.,1.) 
    #define BLUE_CYAN  vec3(.0,.5,1.) 
    #define BLUE  vec3(.0,.0,1.) 
    #define PURPLE  vec3(.5,.0,1.) 
    #define MAGENTA  vec3(1.,.0,1.) 
    #define RED_MAGENTA  vec3(1.,.0,.5) 

    //## UN-SATURATED COLORS (half white)

    #define LIGHT_RED  vec3(1.,.5,.5) 
    #define LIGHT_RED_ORANGE  vec3(1.,.62,.5) 
    #define LIGHT_ORANGE  vec3(1.,.75,.5) 
    #define LIGHT_YELLOW  vec3(1.,1.,.5) 
    #define LIGHT_YELLOW_GREEN  vec3(.75,1.,.5) 
    #define LIGHT_GREEN  vec3(.5,1.,.5) 
    #define LIGHT_GREEN_CYAN  vec3(.5,1.,.75) 
    #define LIGHT_CYAN  vec3(.5,1.,1.) 
    #define LIGHT_BLUE_CYAN  vec3(.5,.75,1.) 
    #define LIGHT_BLUE  vec3(.5,.5,1.) 
    #define LIGHT_PURPLE  vec3(.75,.5,1.) 
    #define LIGHT_MAGENTA  vec3(1.,.5,1.) 
    #define LIGHT_RED_MAGENTA  vec3(1.,.5,.75) 

    //## DIM COLORS (not very bright)

    #define DIM_RED  vec3(.5,.0,.0) 
    #define DIM_RED_ORANGE  vec3(.5,.12,.0) 
    #define DIM_ORANGE  vec3(.5,.25,.0) 
    #define DIM_YELLOW  vec3(.5,.5,.0) 
    #define DIM_YELLOW_GREEN  vec3(.25,.5,.0) 
    #define DIM_GREEN  vec3(.0,.5,.0) 
    #define DIM_GREEN_CYAN  vec3(.0,.5,.25) 
    #define DIM_CYAN  vec3(.0,.5,.5) 
    #define DIM_BLUE_CYAN  vec3(.0,.25,.5) 
    #define DIM_BLUE  vec3(.0,.0,.5) 
    #define DIM_PURPLE  vec3(.25,.0,.5) 
    #define DIM_MAGENTA  vec3(.5,.0,.5) 
    #define DIM_RED_MAGENTA  vec3(.5,.0,.25) 

    //## WHITES 

    #define WHITE  vec3(1.) 
    #define DIM_WHITE vec3(.5) 


 #if IS_HAND_CHECK_FROM_LIST == 1
     vec4 hand_color;
     vec4 hand_color2;
float emmissiveness=0.;
    for(int h = 0;h<=1; h++)
    {//hands vs vertex wrapper
        int c_id = (h == 0 )? heldItemId : heldItemId2;
        vec4 light_color=vec4(0.);
      // c_id = 10113;//debug
	  // c_id = heldItemId;//debug
 #else

         float 
        c_id = currentRenderedItemId > 0 ? currentRenderedItemId : 
	    renderStage == MC_RENDER_STAGE_ENTITIES ? float(entityId) : mc_Entity.x;
 #endif



 //c_id = currentRenderedItemId; //
 #if IS_HAND == 111
    //run for hand vertexes only
	c_id = isRightHanded? (g_pos.x<.0 ? heldItemId : heldItemId2) :  (g_pos.x>.0 ? heldItemId : heldItemId2);
 #endif
 
 {
  float flicker = (.7+.2*sin((frameTimeCounter*1.+world_pos.x)*flow_gredient) +.2*sin((frameTimeCounter*2.+world_pos.z)*flow_gredient)+.1*sin((frameTimeCounter*5.+world_pos.y)*flow_gredient));

 light_color.rgb = 
	//glass
		(c_id == 10040) ?  vec3(1.0,0.8,0.)
		:(c_id == 10041) ?  vec3(1.0,0.0,1.0)
		 :(c_id == 10042) ?  vec3(0.5,0.5,1.0)
		  :(c_id == 10043) ?   vec3(1.0,1.0,0.0)
		   :(c_id == 10044) ?   vec3(0.3,1.0,0.1)
			:(c_id == 10045) ?   vec3(1.0,0.7,0.7)
			 :(c_id == 10046) ?   vec3(0.5,0.5,0.5)
			  :(c_id == 10047) ?   vec3(0.7,0.7,0.7)
			   :(c_id == 10048) ?   vec3(0.0,1.0,1.0)
				:(c_id == 10049) ?   vec3(0.5,0.0,1.0)
				 :(c_id == 10050) ?   vec3(0.0,0.0,1.0)
				 :(c_id == 10051) ?   vec3(0.7,.6,0.0)
				  :(c_id == 10052) ?   vec3(0.0,1.0,0.0)
				   :(c_id == 10053) ?   vec3(1.0,0.0,0.0)
					:(c_id == 10054) ?   vec3(0.0,0.0,0.0)
					 :(c_id == 10055) ?   vec3(0.0,0.0,0.0)
	//glowing color
		 :(c_id == 10070) ?   vec3(GLOW_BERRIES_R,GLOW_BERRIES_G,GLOW_BERRIES_B) 
		  :(c_id == 10071) ?   vec3(FROG_OCHE_R,FROG_OCHE_G,FROG_OCHE_B) 
		   :(c_id == 10072) ?   vec3(FROG_PEARL_R,FROG_PEARL_G,FROG_PEARL_B) 
		    :(c_id == 10073) ?   vec3(FROG_VER_R,FROG_VER_G,FROG_VER_B) 
				 
	//glowing item frames
		: (c_id == 20011) ? vec3(GLOW_FRAME_R,GLOW_FRAME_G,GLOW_FRAME_B) 
				 
		 :(c_id == 10074) ?   vec3(LIGHT_BLOCK_R, LIGHT_BLOCK_G, LIGHT_BLOCK_B) //utility creative light block  SOUL_TORCH_R SOUL_TORCH_G SOUL_TORCH_B SOUL_TORCH_R_HIGH SOUL_TORCH_G_HIGH SOUL_TORCH_B_HIGH
				
			 :(c_id == 10075) ? //copper torches
				#if FLICKERING_TORCHES == 2
					mix( vec3(COPPER_TORCH_R,COPPER_TORCH_G,COPPER_TORCH_B) ,
						vec3(COPPER_TORCH_LOW_R,COPPER_TORCH_LOW_G,COPPER_TORCH_LOW_B), flicker) 
				#else
					vec3(COPPER_TORCH_R,COPPER_TORCH_G,COPPER_TORCH_B) 
				#endif
			//	: light_color.rgb;

    #if USE_EXTENDED_OVERRIDE_LIST == 1
       // light_color.rgb = 
        :(c_id == 10113  ) ?  RED
        :(c_id == 10101  ) ?  RED_ORANGE
        :(c_id == 10102  ) ?  ORANGE
        :(c_id == 10103  ) ?  YELLOW
        :(c_id == 10104  ) ?  YELLOW_GREEN
        :(c_id == 10105  ) ?  GREEN
        :(c_id == 10106    ) ?  GREEN_CYAN
        :(c_id == 10107  ) ?  CYAN
        :(c_id == 10108  ) ?  BLUE_CYAN
        :(c_id == 10109  ) ?  BLUE
        :(c_id == 10110     ) ?  PURPLE
        :(c_id == 10111   ) ?  MAGENTA
        :(c_id == 10112   ) ?  RED_MAGENTA

        //## UN-SATURATED COLORS (half white)

        :(c_id == 10120   ) ? LIGHT_RED  
        :(c_id == 10121   ) ?  LIGHT_RED_ORANGE
        :(c_id == 10122  ) ?  LIGHT_ORANGE
        :(c_id == 10123  ) ?  LIGHT_YELLOW
        :(c_id == 10124  ) ?  LIGHT_YELLOW_GREEN
        :(c_id == 10125  ) ?  LIGHT_GREEN
        :(c_id == 10126  ) ?  LIGHT_GREEN_CYAN
        :(c_id == 10127  ) ?  LIGHT_CYAN
        :(c_id == 10128  ) ?  LIGHT_BLUE_CYAN
        :(c_id == 10129  ) ?  LIGHT_BLUE
        :(c_id == 10130  ) ?  LIGHT_PURPLE
        :(c_id == 10131  ) ?  LIGHT_MAGENTA
        :(c_id == 10132  ) ?  LIGHT_RED_MAGENTA

        //## DIM COLORS (not very bright)

        :(c_id == 10140  ) ?  DIM_RED
        :(c_id == 10141  ) ?  DIM_RED_ORANGE
        :(c_id == 10142  ) ?  DIM_ORANGE
        :(c_id == 10143  ) ?  DIM_YELLOW
        :(c_id == 10144  ) ?  DIM_YELLOW_GREEN
        :(c_id == 10145  ) ?  DIM_GREEN
        :(c_id == 10146  ) ?  DIM_GREEN_CYAN
        :(c_id == 10147  ) ?  DIM_CYAN
        :(c_id == 10148  ) ?  DIM_BLUE_CYAN
        :(c_id == 10149  ) ?  DIM_BLUE
        :(c_id == 10150  ) ?  DIM_PURPLE
        :(c_id == 10151  ) ?  DIM_MAGENTA
        :(c_id == 10152  ) ?  DIM_RED_MAGENTA


        :(c_id == 10160  ) ?  WHITE

        :(c_id == 10161  ) ?  DIM_WHITE

       
    #endif
     : light_color.rgb;

}
					
if(c_id>=10113 && c_id<=  10152) emmissiveness = 15.;//flag as light
					

//ipbr sss
 light_color.a = (c_id == 10080) ? .5 : light_color.a;
 
#if IS_HAND_CHECK_FROM_LIST == 1

//DEBUG, WOOL IS SET RED AND YELLOW IN BLOCK.PROPERTIES
//c_id = 10113;
   //light_color= c_id >= 0? vec4(1.,0.,0.,1.):vec4(0.);//debug

   if(h == 0){ hand_color = light_color; }else{ hand_color2 = light_color;  }



}//wrapper for hands vs vertex
 // hand_color*= emmissiveness/15.;
 // hand_color2*= emmissiveness/15.;
#endif

					
#endif
