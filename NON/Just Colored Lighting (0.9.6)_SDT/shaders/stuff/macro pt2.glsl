
//APPLY MATERIAL TEXTURE
#if USE_MACRO_TEXTURES >= 1
//apply macro-roughness to normals
        #if PRESERVE_NORMALSVS_MACRO == 1
            normals_pixel.xy = clamp(normals_pixel.xy +(macro_texture.xy)*MACRO_NORMALS_STRENGTH,0.,1.);
        #else
            normals_pixel.xy = mix(normals_pixel.xy, macro_texture.xy,MACRO_NORMALS_STRENGTH);
       
        #endif
		
		//apply macro smoothness variation
		specular_pixel.r =clamp(specular_pixel.r + (macro_texture.b-.5)*MACRO_SMOOTHNESS_STRENGTH,0.,1.);

		//debug
		//color.rgb = vec3( macro_texture.z );
#endif
