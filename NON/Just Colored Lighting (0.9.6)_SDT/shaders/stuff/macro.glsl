//in earlier area to know to include the custom texture sampler
/*
	#define USE_MACRO_TEXTURES 0 //[0 1 2]
	#define USE_MACRO_RESOURCE_PACK 0 //[0 1]
*/

//in shader.properties 
/*
	sliders:
		MACRO_SMOOTHNESS_STRENGTH MACRO_TILING_SCALE MACRO_RENDER_DISTANCE MACRO_NORMALS_STRENGTH MACRO_FADE_PERCENT
		
	screen.Macro_Detail = USE_MACRO_TEXTURES USE_MACRO_RESOURCE_PACK MACRO_SMOOTHNESS_STRENGTH MACRO_TILING_SCALE MACRO_RENDER_DISTANCE MACRO_NORMALS_STRENGTH PRESERVE_NORMALSVS_MACRO MACRO_FADE_PERCENT
*/



//Settings


//LOAD MATERIALTEXTURE
#if USE_MACRO_TEXTURES >= 1

	 vec4 macro_texture;
	//strength of effect
	float macro_roughness = clamp(dist/MACRO_RENDER_DISTANCE/MACRO_FADE_PERCENT,0.,1.);
	if(macro_roughness<1.)
	{


	//tiling / position
	vec2 macro_pos = 
					abs(dot(East.xyz, normals_face.xyz)) > .5? 
						vec2(world_pos.x,-world_pos.y) : 
						abs(dot(North.xyz, normals_face.xyz)) > .5? vec2(world_pos.z ,-world_pos.y) :
						vec2(world_pos.x ,world_pos.z)
						;

    #if IS_ENTITY == 1
        #if MOB_WORLD_SCALING == 1
            // vec2 macro_uv =fract(vlocal_uv.xy*tangent.w*-1.* material_type.z/64.*MACRO_TILING_SCALE_MOBS);
            vec2 macro_uv =fract(vlocal_uv.xy*vec2(material_type.z,1.)*-1.*MACRO_TILING_SCALE_MOBS);
        #else
             vec2 macro_uv =fract(vlocal_uv.xy*tangent.w*-1.*MACRO_TILING_SCALE_MOBS);
        #endif
       
       
    #else
        vec2 macro_uv =
            //moving plants
             (ipbr_id > 10005.-.5 && ipbr_id < 10010.+.5) || abs(ipbr_id - 10050.)<.5 ?
                fract(vlocal_uv.xy*tangent.w*-1.*MACRO_TILING_SCALE_MOBS)
            :
            //terrain
             fract(macro_pos*MACRO_TILING_SCALE
        //extra per material scalling
      //  *( abs(material_type_x - 10016.)<.5|| abs(material_type_x - 10013.)<.5 ? 5.:1.) //dirt)
    );
    #endif
	
   
		macro_roughness=max(0., 1.-macro_roughness);
		
		//apply to pbr rough areas
		macro_roughness *= 1.-specular_pixel.r;
        
        //pick texture from atlas
            /*
            metal, stone. concrete, dirt
            generic, porous stone, wood, leaf
            fur, fabric, skin/organic, hair?
            glass, crystals, painting?, sand?
            */

    #if USE_MACRO_TEXTURES == 2
        float material_type_x = ipbr_id;
/*
The materials are arranged in a 4x4 atlas.
	metal / stone / concrete / dirt
	blank / porous-stone / wood-grain / plant-leaf
	fur / fabric / skin-leather / hair-short
	glass / cystal / wax/slime / grass-organic-dirt
*/
        vec2 macro_atlas_tile =  abs(material_type_x - 20100.)<.5 || abs(material_type_x - 20106.)<.5 ? vec2(0.,0.) //metal
                                : abs(material_type_x - 20101.)<.5? vec2(1.,0.) //stone
                                : abs(material_type_x - 20102.)<.5? vec2(2.,0.) //concrete
                                : abs(material_type_x - 20103.)<.5? vec2(3.,0.) //dirt
 : abs(material_type_x - 20104.)<.5? vec2(0.,1.) //blank
 : abs(material_type_x - 20105.)<.5? vec2(1.,1.) //porous-stone
 : abs(material_type_x - 20106.)<.5? vec2(2.,1.) //wood  
 : abs(material_type_x - 20107.)<.5? vec2(3.,1.) //plant-leaf
                                : abs(material_type_x - 20108.)<.5? vec2(0.,2.) //fur   
                                : abs(material_type_x - 20109.)<.5 ? vec2(1.,2.) //fabric  
                                : abs(material_type_x - 20110.)<.5  ? vec2(2.,2.) //skin   
                                : abs(material_type_x - 20111.) <.5 ? vec2(3.,2.) //hair - short 
                        :  abs(material_type_x - 20112.)<.5 ? vec2(0.,3.)//   glass
                        :  abs(material_type_x - 20113.)<.5 ? vec2(1.,3.)//cystal
                        : abs(material_type_x - 20114.)<.5? vec2(2.,3.) //wax/slime drippy   
                        :  abs(material_type_x - 20115.)<.5 ? vec2(3.,3.)//   grass-organic-dirt
                                : vec2(2.,0.); //generic - currently concrete

        macro_uv = .25*(macro_atlas_tile+macro_uv);
         #endif

		//load texture
		macro_texture = texture(Macro_texture,macro_uv);


     //color.rg=fract(vlocal_uv.xy* material_type.z*100.);// macro_uv =fract(vlocal_uv.xy*tangent.w*-1.* material_type.z/64.*MACRO_TILING_SCALE_MOBS);
	}//distance cutoff
    else{
        macro_texture=vec4(.5);
    }



#endif


//APPLY MATERIAL TEXTURE
#if USE_MACRO_TEXTURES >= 1
//apply macro-roughness to normals
        #if PRESERVE_NORMALSVS_MACRO == 1
            normals_pixel.xy = clamp(normals_pixel.xy +(macro_texture.xy*2.-1.)*macro_roughness*MACRO_NORMALS_STRENGTH,0.,1.);
        #else
            normals_pixel.xy = mix(normals_pixel.xy, macro_texture.xy,macro_roughness*MACRO_NORMALS_STRENGTH);
       
        #endif
		
		//apply macro smoothness variation
		specular_pixel.r =clamp(specular_pixel.r + (macro_texture.b-.5)*MACRO_SMOOTHNESS_STRENGTH*macro_roughness,0.,1.);

		//debug
		//color.rgb = vec3( macro_texture.z );
#endif
