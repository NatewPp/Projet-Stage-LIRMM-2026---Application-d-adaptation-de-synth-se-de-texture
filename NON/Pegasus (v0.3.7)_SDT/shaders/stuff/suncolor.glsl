	#if SUNSET == 0
		vec3 sun_color =
		

			(sunAngle <.5 ?
			vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)
			:vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B)
			)
			

		;
	#endif
	
	#if SUNSET == 2
		vec3 sun_color =
		clamp(
		

			(sunAngle <.5 ?
			 vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)
			 :vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B)
			 )
	

		  -
		  vec3(SUNSET_FADE_R,SUNSET_FADE_G,SUNSET_FADE_B )
		  *(1.-clamp((1.-abs(sunAngle-
		  (sunAngle<.5? .25 : .75)
		  
				)*4.)*SUNSET_EXPONENT*1.5
			,0.,5.))
		  ,0.,1.)
		  ;
		  
		  vec3 sun_color_hi =
		clamp(
		

			(sunAngle <.5 ?
			 vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)
			 :vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B)
			 )
	

		  -
		  vec3(SUNSET_FADE_R,SUNSET_FADE_G,SUNSET_FADE_B )
		  *(1.-clamp((1.-abs(sunAngle-
		  (sunAngle<.5? .25 : .75)
		  
				)*4.)*SUNSET_EXPONENT*3.0
			,0.,5.))
		  ,0.,1.)
		  ;
		 
	#endif
						 
						 
	#if SUNSET == 1

				vec3 sun_color =
				sunAngle <.5 ?
				 vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)
				 :vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B)

		*clamp((1.-abs(sunAngle-
		  (sunAngle<.5? .25 : .75)
		  
		  )*4.)*10.,0.,1.);


	#endif