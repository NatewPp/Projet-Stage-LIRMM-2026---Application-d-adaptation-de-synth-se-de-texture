#if SSS >= 1
//	main_lighting=shadowPos.w <0.0? max(sss,main_lighting): main_lighting;
#endif

#if PBR >= 2
	specular_pixel = abs(ipbr_id-10020.)<=.5  || abs(ipbr_id-10021.)<=.5 ? vec4(1.,0.02,1.,0.): specular_pixel;
	
	
//	vec3 view_dir = normalize(viewPos.xyz);
	
	


color.rgb = mix(color.rgb,vec3(0.0),actual_wetness*.25+wetness*porosity*.5 );



	
	specular_pixel.r = metalness > .5? mix(specular_pixel.r,1.,METAL_SMOOTHER) : specular_pixel.r ;
//	reflected_angle = reflect(view_dir,normals_pixel.xyz);
	float fresnel = pow(max(0.,dot(reflected_angle,view_dir)),mix(10.,5.,specular_pixel.r));
	specular_pixel.g= mix(max(metalness, specular_pixel.g),1.,fresnel);
	//specular_pixel.g*=specular_pixel.r;
	

specular_pixel.r=max(MINIMUM_SMOOTHNESS,specular_pixel.r);
specular_pixel.g=max(MINIMIM_F0,specular_pixel.g);
float smoothness_affected_light = (1.+5.28*specular_pixel.r) /6.28;
//smoothness_affected_light = specular_pixel.r;

	vec3 sun_shine = 
#if ADJUSTED_SPECULAR == 1
    ADJUSTED_SPECULAR *

#endif

sun_color//*	vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)
*sign(shadowPos.w)
*main_lighting*(sun_lighting>0.001?1.:0.)
	*smoothness_affected_light
	* mix(vec3(1.) ,color.rgb,metalness) 
	*specular_pixel.g 
	* pow( 
        clamp(
				(
				dot( normalize(shadowLightPosition), reflected_angle )
		//		-(1.-SUN_WIDTH)*(specular_pixel.r)
		//		/max(0.001,SUN_WIDTH*(1.-specular_pixel.r))
                )
		,0.,1.)  
		,1.+200.*specular_pixel.r);
		
		// v *(specular_pixel.r))/max(0.001,SUN_WIDTH*(1.-specular_pixel.r))
		float sky_reflection = dot(n_sky_dir, reflected_angle);
		
	sky_shine = skyColor*sky_shine
	*smoothness_affected_light
	* mix(vec3(1.) ,color.rgb,metalness) 
	*specular_pixel.g 
	* clamp( mix((sky_reflection+1.)*.5,sky_reflection,specular_pixel.r),0.,1.) 
; 

	
	//color= metalness > 0.5? vec4(specular_pixel.g) : color;
#endif
