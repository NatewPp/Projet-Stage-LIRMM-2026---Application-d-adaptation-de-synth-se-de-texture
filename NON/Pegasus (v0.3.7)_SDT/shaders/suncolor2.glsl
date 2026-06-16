
					
				
						vec3 sun_color =
						clamp(
						
						
							(sunAngle <.5 ?
							 vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)*SUN_BRIGHTNESS
							 :vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B)*MOON_BRIGHTNESS
							 )
						

						  -
						  vec3(SUNSET_FADE_R,SUNSET_FADE_G,SUNSET_FADE_B )
						  *(1.-clamp((1.-abs(sunAngle-
						  (sunAngle<.5? .25 : .75)
						  
						  )*4.)*10.*(1.+.5*elevation*.1),0.,1.))
						  ,0.,1.)
						  ;
				
						 
						 
					