float sdistm = 1.;
float sdist=0.1;
float shadow_data = 1.0;
if( abs(shadowPos.x-0.5)<0.5 && abs(shadowPos.y-0.5)<0.5 && abs(shadowPos.z-0.5)<0.5 ) 
{

#if COLORED_SHADOWS == 1
	 sdist=(texture2D(shadowtex1, shadowPos.xy ).r - shadowPos.z)*sdistm ;
#endif

#if SHADOWS >= 2
	
	#define SHADOW_BIAS_N 0.0 //[-0.1 -0.0001 -0.0002 -0.0005 -0.0007 -0.001 -.01 0.0 0.01 0.1]
		
	vec2 pixel_size = vec2(1.0)/(shadowMapResolution);
	vec2 subpixel = shadowPos.xy/pixel_size;
	vec2 base_pixel = floor(subpixel);
	subpixel=subpixel-base_pixel;
	base_pixel*=pixel_size;

	#if COLORED_SHADOWS == 0
		 sdist=(texture2D(shadowtex1, shadowPos.xy ).r - shadowPos.z)*sdistm ;
	#endif
	float sun_light1 = (sdist < SHADOW_BIAS_N ) ? 0. : 1.;


	float sdist2 = (texture2D(shadowtex1, base_pixel + vec2(pixel_size.x,0.0)).r - shadowPos.z)*sdistm ;
	float sdist3 = (texture2D(shadowtex1, base_pixel + vec2(0.0,pixel_size.y)).r - shadowPos.z)*sdistm;
	float sdist4 = (texture2D(shadowtex1, base_pixel + pixel_size).r - shadowPos.z)*sdistm;

	float sun_light2 = (sdist2 < SHADOW_BIAS_N ) ?  0. : 1.;
	float sun_light3 = (sdist3 < SHADOW_BIAS_N ) ?  0. : 1.;
	float sun_light4 = (sdist4 < SHADOW_BIAS_N ) ?  0. : 1.;

	float shadow_data =mix(mix(sun_light1,sun_light2,subpixel.x),mix(sun_light3,sun_light4,subpixel.x),subpixel.y);
	
		//crisp
	#if SHADOWS == 3
		shadow_data = shadow_data>=.5?1.: 0.;
	#endif
	
	
	
	#if SHADOWS == 4
	
		float sdist5 = (texture2D(shadowtex1, shadowPos.xy - vec2(pixel_size.x,0.0)).r - shadowPos.z)*sdistm ;
		float sdist6 = (texture2D(shadowtex1, shadowPos.xy -vec2(0.0,pixel_size.y)).r - shadowPos.z)*sdistm;
		float sdist7 = (texture2D(shadowtex1, shadowPos.xy + vec2(pixel_size.x,0.0)).r - shadowPos.z)*sdistm ;
		float sdist8= (texture2D(shadowtex1, shadowPos.xy +vec2(0.0,pixel_size.y)).r - shadowPos.z)*sdistm;


		float sun_light5 = (sdist5 < SHADOW_BIAS_N ) ?  0. : 1.;
		float sun_light6 = (sdist6 < SHADOW_BIAS_N ) ?  0. : 1.;
		float sun_light7 = (sdist7 < SHADOW_BIAS_N ) ?  0. : 1.;
		float sun_light8 = (sdist8 < SHADOW_BIAS_N ) ?  0. : 1.;
	
		shadow_data =
			mix(
			shadow_data,
			(sun_light5+sun_light6+sun_light7+sun_light8)*.25
			,.5)
			;
	
	#endif
	
	#if PRENUMBRA_INFO == 1
	#endif
	
	
	
	#if SHADOWS == 5
		//shadow_data = (sdist < SHADOW_BIAS_N ) ?  0. : 1.;
		//shadow_data = shadow_data>=.5?1.: 0.;
		
		for(float i = 1.;i<= SHADOW_SAMPLES8 ;i++)
		{
			float samplling_width = (i/SHADOW_SAMPLES8)*pow(abs(sdist),1.0)*256.* PRENUMBRA_WIDTH * float(shadowMapResolution)/1024.;
			
			float sdist5 = (texture2D(shadowtex1, shadowPos.xy - samplling_width* vec2(pixel_size.x,0.0)).r - shadowPos.z)*sdistm;
			float sdist6 = (texture2D(shadowtex1, shadowPos.xy - samplling_width* vec2(0.0,pixel_size.y)).r - shadowPos.z)*sdistm;
			float sdist7 = (texture2D(shadowtex1, shadowPos.xy + samplling_width* vec2(pixel_size.x,0.0)).r - shadowPos.z)*sdistm;
			float sdist8 = (texture2D(shadowtex1, shadowPos.xy + samplling_width* vec2(0.0,pixel_size.y)).r - shadowPos.z)*sdistm;
			
			float sdist11 = (texture2D(shadowtex1, shadowPos.xy - samplling_width* vec2(-pixel_size.x,-pixel_size.y)).r - shadowPos.z)*sdistm;
			float sdist12 = (texture2D(shadowtex1, shadowPos.xy - samplling_width* vec2(-pixel_size.x,pixel_size.y)).r - shadowPos.z)*sdistm;
			float sdist13 = (texture2D(shadowtex1, shadowPos.xy + samplling_width* vec2(pixel_size.x,-pixel_size.y)).r - shadowPos.z)*sdistm;
			float sdist14 = (texture2D(shadowtex1, shadowPos.xy + samplling_width* vec2(pixel_size.x,pixel_size.y)).r - shadowPos.z)*sdistm;

			float sun_light5 = (sdist5 < SHADOW_BIAS_N ) ?  0. : 1.;
			float sun_light6 = (sdist6 < SHADOW_BIAS_N ) ?  0. : 1.;
			float sun_light7 = (sdist7 < SHADOW_BIAS_N ) ?  0. : 1.;
			float sun_light8 = (sdist8 < SHADOW_BIAS_N ) ?  0. : 1.;
			
			float sun_light11 = (sdist11 < SHADOW_BIAS_N ) ?  0. : 1.;
			float sun_light12 = (sdist12 < SHADOW_BIAS_N ) ?  0. : 1.;
			float sun_light13 = (sdist13 < SHADOW_BIAS_N ) ?  0. : 1.;
			float sun_light14 = (sdist14 < SHADOW_BIAS_N ) ?  0. : 1.;
		
			shadow_data +=
			
				sun_light5+sun_light6+sun_light7+sun_light8
				+sun_light11+sun_light12+sun_light13+sun_light14
				
				
				;
		}
		shadow_data=clamp(shadow_data/(1.+SHADOW_SAMPLES8*8.),0.,1.);
	#endif
	
	
	
	#if SHADOWS >= 6
		shadow_data = shadow_data>=.5?1.: 0.;
		//shadow_data = (sdist < SHADOW_BIAS_N ) ?  0. : 1.;
		//shadow_data = shadow_data>=.5?1.: 0.;
		
		#if SHADOWS == 7
			#if IS_HAND != 1
				vec3 seed1 = floor(world_pos*SHADOW_SUB_PIXEL_SEED_RES)/SHADOW_SUB_PIXEL_SEED_RES;//vec3(gl_FragCoord.xy,10.);//viewPos.xyz;
				vec3 seed2 =  floor(world_pos.yzx*SHADOW_SUB_PIXEL_SEED_RES)/SHADOW_SUB_PIXEL_SEED_RES;//vec3(gl_FragCoord.yx,20.);//viewPos.xyz;
			#else
				vec3 seed1 = floor(viewPos.xyz*SHADOW_SUB_PIXEL_SEED_RES)/SHADOW_SUB_PIXEL_SEED_RES;//vec3(gl_FragCoord.xy,10.);//viewPos.xyz;
				vec3 seed2 =  floor(viewPos.yzx*SHADOW_SUB_PIXEL_SEED_RES)/SHADOW_SUB_PIXEL_SEED_RES;//vec3(gl_FragCoord.yx,20.);//viewPos.xyz;
			#endif
			
		#else
			vec3 seed1 = vec3(gl_FragCoord.xy,10.);//viewPos.xyz;
			vec3 seed2 = vec3(gl_FragCoord.yx,20.);//viewPos.xyz;
		#endif
		float total_weight = 1.;
		for(float i = 1.;i<= SHADOW_SAMPLES ;i++)
		{
			float samplling_width = (i/SHADOW_SAMPLES)*pow(abs(sdist),1.0)*256.* PRENUMBRA_WIDTH * float(shadowMapResolution)/1024.;
			
			float r = i*.5;
			
			vec2 spiral=vec2(sin(r),cos(r)) * max(samplling_width,SHADOW_EXTRA_SOFTNESS);
			vec3 noise_blur = noise3from3_v3(
				vec3(spiral,i)+
				gl_FragCoord.xyz
			);
			//spiral=spiral* (1.+ SHADOW_NOISE_STR*noise_blur.xy*mix(3.,noise_blur.z,SHADOW_NOISE_VARIATION ));
			spiral=spiral*(1.+SHADOW_NOISE_STR*noise_blur.xy) 
			* (mix(1.,noise_blur.z*3.0,SHADOW_NOISE_VARIATION ));
			
			#if FLIP_SHADOW_SPIRAL_RANDOMLY == 1
				spiral *= vec2(sign(random(i)-.5) , sign(random(i+5.)-.5)  );
			#endif
			#if FLIP_SHADOW_SPIRAL_RANDOMLY == 2
				spiral *= vec2(sign(hashfrom3(seed1)-.5) , sign(hashfrom3(seed2)-.5)  );
			#endif
			//spiral *= sign(hashfrom3(noise_blur)-.5);

			
			float sdist5 = (texture2D(shadowtex1, shadowPos.xy - spiral* pixel_size.x).r - shadowPos.z)*sdistm;

			float sun_light5 = (sdist5 < SHADOW_BIAS_N ) ?  0. : 1.;

		
			shadow_data += sun_light5;
			float weight = mix(1.,1.-i/(SHADOW_SAMPLES+1.),SHADOW_SOFTNESS_WEIGHT);
			total_weight+=weight;
				
				;
		}
		
		shadow_data=pow(clamp(shadow_data/(total_weight),0.,1.),SHADOW_WEIGHT_EXPONENT);
	#endif
	
	
	

	
		

	
	
	#if SSS >= 1 

		sss= pow(1.-clamp(((shadowPos.z - texture2D(shadowtex1, shadowPos.xy).r)*Shadow_map_depth*SSS_DECAY_RATE)/sss,0.,1.), SSS_DECAY_CURVE);
	#endif
		
		
			//crisp
	#if FORCE_CRISP_SHADOWS == 1
		shadow_data = shadow_data>=.5?1.: 0.;
	#endif
	
		main_lighting *= shadow_data;
	

#else




	#if SSS >= 1 
		sss = pow(1.-clamp(((shadowPos.z - texture2D(shadowtex1, shadowPos.xy).r)*Shadow_map_depth*SSS_DECAY_RATE)/sss,0.,1.), SSS_DECAY_CURVE);
		 shadow_data=  sss<0.999?0.:1.;
	#else
		 shadow_data =  texture2D(shadowtex1, shadowPos.xy).r < shadowPos.z? 0.:1.;
	#endif
	
			//crisp
	#if FORCE_CRISP_SHADOWS == 1
		shadow_data = shadow_data>=.5?1.: 0.;
	#endif
	
	main_lighting *= shadow_data;
#endif

#if FADE_SHADOWS == 1 && DH_SHADOWS == 0
	//float actual_shadow_distance = min(far,shadowDistance);
	float shadow_edge_fade = clamp((dist-actual_shadow_distance*(1.-SHADOW_FADE))/(actual_shadow_distance*SHADOW_FADE),0.,1.);
	main_lighting=mix(main_lighting,
			1.,
			shadow_edge_fade);
	//sss *= 1.-shadow_edge_fade;
#else
	#if defined IS_IRIS && defined DISTANT_HORIZONS && DH_SHADOWS == 0
		
		//if THIS_IS_DISTANT_HORIZONS == 1
			main_lighting=mix(main_lighting,
			1.,
			//clamp((dist-far*.9)/(far*.1),0.,1.));
			clamp((dist-far*(1.-DH_FADE*.5))/(far*DH_FADE*.5),0.,1.));
		//endif
	#endif	
#endif			

if ( 
				shadow_data <=0.001
				#if SSS >= 1 
					&&sss < 0.001
				#endif
			) 
			{
			
				//in full shadow

			}else{
				//surface is in sunlight
				#if COLORED_SHADOWS == 1
					float sdistc=(texture2D(shadowtex0, shadowPos.xy ).r-shadowPos.z)*sdistm ;
					#if DEBUG_MODE == 1
						 debugdata3=vec3((1.-sdistc*Shadow_map_depth/-20.));
					#endif
					if (
					abs(sdist-sdistc)>.0001 && 
					sdistc < -0.001)
					{
						//surface has translucent object between it and the sun. modify its color.
						//make colors more intense when the shadow light color is more opaque.
						 vec4 shadowLightColor1 =  texture2D(shadowcolor0, shadowPos.xy);
						 //make colors more intense when the shadow light color is more opaque.
						/*
						shadowLightColor1.rgb = mix(vec3(1.0),shadowLightColor1.rgb,
							min(1.,((shadowLightColor1.a)*2.)))
						 #if BRIGHTER_UNDERWATER == 1
						//	*(isEyeInWater > 0 ?  max(0.,1.-sdistc*Shadow_map_depth/-20.) : 1.0)
						#endif
						
						 ;		
						 */
						 shadowLightColor1 = (shadowLightColor1-.5)*2.;
						 shadowLightColor1.r=shadowLightColor1.r<0.? shadowLightColor1.r*1.: shadowLightColor1.r;
						 shadowLightColor1.g=shadowLightColor1.g<0.? shadowLightColor1.g*1.: shadowLightColor1.g;
						 shadowLightColor1.b=shadowLightColor1.b<0.? shadowLightColor1.b*1.: shadowLightColor1.b;
						 
						 
						 shadowLightColor= max(shadowLightColor*(1.-shadowLightColor1),0.);
						
						 
						 #if defined IS_IRIS && defined DISTANT_HORIZONS && DH_SHADOWS == 0
							#if THIS_IS_DISTANT_HORIZONS == 1
								shadowLightColor.rgb=mix(shadowLightColor.rgb,
								vec3(1.),
								clamp((dist-far*dh_discard_circle)/(far*.1),0.,1.));
							#endif
						#endif	
						
						
					}
					
							
				#endif
				
				
			}
	#if DEBUG_MODE == 2
		 debugdata3=vec3(fract(sdist*Shadow_map_depth));
	#endif
}


