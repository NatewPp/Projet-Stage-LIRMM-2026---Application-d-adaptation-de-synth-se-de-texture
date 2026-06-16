// © Copyright 2023-2025 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


#if FIRST_FLOOD_PASS == 1  	&& SOLAR_GI >= 1
	bool bounce_light = false;
	float lmy_og = max(0.,float(eyeBrightnessSmooth.y/240.)-1./32.);
	if(lmy_og>0.01)
	{

		
	#if SOLAR_GI >= 3
		vec4 gi[6];//0north 1east 2south 3west 4up 5down
	#endif
	if(og_int_data==0u) //air
	{
		#if SOLAR_GI >= 2  && SOLAR_GI_DOT == 1
			vec3 sun_dir = normalize((gbufferModelViewInverse*vec4(shadowLightPosition,1.)).xyz);
		#endif
		//get neighbors
								
		//from down
		neighbor = ivec3(0.,-1.,0.);

		vec4 neighbor_data =  unpackUnorm4x8( imageLoad(cimage1, orig_voxel_pos + neighbor ).r ) ;
		vec3 normals_face = -neighbor;
		#if SOLAR_GI >= 2 && SOLAR_GI_DOT == 1
			float sun_weight;
			//vec3 sun_dir = normalize((gbufferModelViewInverse*vec4(shadowLightPosition,1.)).xyz);
			float neighbor_weights =max(0., dot(sun_dir,normals_face) )
			#if REDUCE_GI_LEAKS == 1
				*(neighbor_data.a> 0.001 ? 1.:0.)
			#endif
			;
			#if ADJUST_GI_INTENSITY == 1
				neighbor_data.rgb*=mix(1.,neighbor_weights,DIRECTIONAL_SOLAR_GI);
			#else
				neighbor_data.rgb*=neighbor_weights;
			#endif
			
			
		#endif
		
		#if SOLAR_GI >= 3
			//gi existing
			gi[4] = imageLoad(cimage4_gi, voxel_pos +neighbor);
		#endif
		
		
		#if SOLAR_GI >= 2  && SOLAR_GI_DOT == 1
			
			float total_a = neighbor_data.a;
			
			neighbor = ivec3(0.,0.,1.);
			bytes =unpackUnorm4x8(  imageLoad(cimage1, orig_voxel_pos + neighbor).r);
			#if SOLAR_GI >= 2  && SOLAR_GI_DOT == 1
				sun_weight = max(0.,dot(sun_dir, -neighbor))
				#if REDUCE_GI_LEAKS == 1
					*(bytes.a>0.001?1.:0.)
				#endif
				;
				#if ADJUST_GI_INTENSITY == 1
					bytes.rgb*=mix(1.,sun_weight,DIRECTIONAL_SOLAR_GI);
				#else
					bytes.rgb*=sun_weight;
				#endif
				normals_face = sum_rgb(bytes)>sum_rgb(neighbor_data)? -neighbor : normals_face;
				neighbor_weights+=sun_weight;
			#endif
		//	neighbor_data = max(neighbor_data , bytes );
			neighbor_data.rgb += bytes.rgb ;
			total_a +=bytes.a;
			
			
			neighbor = ivec3(0.,0,-1.);
			bytes = unpackUnorm4x8( imageLoad(cimage1, orig_voxel_pos + neighbor).r);
			#if SOLAR_GI >= 2  && SOLAR_GI_DOT == 1
				normals_face = sum_rgb(bytes)>sum_rgb(neighbor_data)? -neighbor : normals_face;
				sun_weight = max(0.,dot(sun_dir, -neighbor))
				#if REDUCE_GI_LEAKS == 1
					*(bytes.a>0.001?1.:0.)
				#endif
				;
				#if ADJUST_GI_INTENSITY == 1
					bytes.rgb*=mix(1.,sun_weight,DIRECTIONAL_SOLAR_GI);
				#else
					bytes.rgb*=sun_weight;
				#endif
				normals_face = sum_rgb(bytes)>sum_rgb(neighbor_data)? -neighbor : normals_face;
				neighbor_weights+=sun_weight;
			#endif
		//	neighbor_data = max(neighbor_data , bytes );
			neighbor_data.rgb += bytes.rgb ;
			total_a +=bytes.a;
			
			neighbor = ivec3(1.,0,0.);
			bytes = unpackUnorm4x8( imageLoad(cimage1, orig_voxel_pos + neighbor).r);
			#if SOLAR_GI >= 2  && SOLAR_GI_DOT == 1
				normals_face = sum_rgb(bytes)>sum_rgb(neighbor_data)? -neighbor : normals_face;
				sun_weight = max(0.,dot(sun_dir, -neighbor))
				#if REDUCE_GI_LEAKS == 1
					*(bytes.a>0.001?1.:0.)
				#endif
				;
				#if ADJUST_GI_INTENSITY == 1
					bytes.rgb*=mix(1.,sun_weight,DIRECTIONAL_SOLAR_GI);
				#else
					bytes.rgb*=sun_weight;
				#endif
				normals_face = sum_rgb(bytes)>sum_rgb(neighbor_data)? -neighbor : normals_face;
				neighbor_weights+=sun_weight;
			#endif
		//	neighbor_data = max(neighbor_data , bytes );
			neighbor_data.rgb += bytes.rgb ;
			total_a +=bytes.a;
			
			neighbor = ivec3(-1.,0.,0.);
			bytes = unpackUnorm4x8( imageLoad(cimage1, orig_voxel_pos +neighbor).r);
			#if SOLAR_GI >= 2  && SOLAR_GI_DOT == 1
				normals_face = sum_rgb(bytes)>sum_rgb(neighbor_data)? -neighbor : normals_face;
				sun_weight = max(0.,dot(sun_dir, -neighbor))
				#if REDUCE_GI_LEAKS == 1
					*(bytes.a>0.001?1.:0.)
				#endif
				;
				#if ADJUST_GI_INTENSITY == 1
					bytes.rgb*=mix(1.,sun_weight,DIRECTIONAL_SOLAR_GI);
				#else
					bytes.rgb*=sun_weight;
				#endif
				normals_face = sum_rgb(bytes)>sum_rgb(neighbor_data)? -neighbor : normals_face;
				neighbor_weights+=sun_weight;
			#endif
		//	neighbor_data = max(neighbor_data , bytes );
			neighbor_data.rgb += bytes.rgb ;
			total_a +=bytes.a;
			
			neighbor_data.rgb /= neighbor_weights ;
			neighbor_data.a = total_a;
		#endif
		
		if(neighbor_data.a > 0.01)//neighbor solid
		{

			vec4 playerPos = vec4(orig_voxel_pos - fract(cameraPosition) - VOXEL_RADIUS
			+.1*normals_face
			,1.);
			vec4 shadowPos = shadowProjection * (shadowModelView * playerPos); //convert to shadow ndc space.
			//float bias = computeBias(shadowPos.xyz);
			#if SOLAR_GI_SHADOWMAP_SAMPLES > 1
				//offset
				vec3 c1 = cross(normals_face, vec3(0.0, 0.0, 1.0)); // cross product  z
				vec3 c2 = cross(normals_face, vec3(0.0, 1.0, 0.0)); // cross product  y
				vec4 tangent =vec4(normalize( ((length(c1)>length(c2) )? c1 : c2 ) ),1.);
				//tangent.xy = abs(tangent.xy);
				vec4 shadow_pos_offset = (shadowProjection * (shadowModelView * (playerPos+vec4(tangent.xyz,0.))));
				shadow_pos_offset.xyz = distort(shadow_pos_offset.xyz); //apply shadow distortion
				shadow_pos_offset.xyz = shadow_pos_offset.xyz * 0.5 + 0.5; //convert from -1 ~ +1 to 0 ~ 1
				//shadow_pos_offset.x = distance(shadow_pos_offset.xyz,shadowPos.xyz)*.7;
			#endif
			shadowPos.xyz = distort(shadowPos.xyz); //apply shadow distortion
			shadowPos.xyz = shadowPos.xyz * 0.5 + 0.5; //convert from -1 ~ +1 to 0 ~ 1
			#if SOLAR_GI_SHADOWMAP_SAMPLES > 1 && SOLAR_GI_SHADOWMAP_SAMPLES < 16
				//offset
				shadow_pos_offset.x = distance(shadow_pos_offset.xyz,shadowPos.xyz)*.7;
			#endif
			vec3 sun_light = vec3(1.);
			if( abs(shadowPos.x-0.5)<0.5 && abs(shadowPos.y-0.5)<0.5 && abs(shadowPos.z-0.5)<0.5 ) 
			{
				#if SOLAR_GI < 2  && SOLAR_GI_DOT == 1
					vec3 sun_dir = normalize((gbufferModelViewInverse*vec4(shadowLightPosition,1.)).xyz);
				#endif
				//add solar gi source
				float sdistm = 1./256.;
				float SHADOW_BIAS_N = -0.00001;//* (1.-sun_lighting) ;
				
				float sdist=(texture(shadowtex1, shadowPos.xy ).r - shadowPos.z)*sdistm ;
				float sun_light1 = (sdist < SHADOW_BIAS_N ) ? 0. : 1.;
				
				#if SOLAR_GI_SHADOWMAP_SAMPLES > 1
					float weight = 1.;
					#if SOLAR_GI_SHADOWMAP_SAMPLES == 2
					
						float shadow_offset =shadow_pos_offset.x;
						sdist=(texture(shadowtex1, shadowPos.xy+shadow_offset ).r - shadowPos.z)*sdistm ;
						sun_light1 += (sdist < SHADOW_BIAS_N ) ? 0. : 1.;
						weight++;
					#endif
					#if SOLAR_GI_SHADOWMAP_SAMPLES == 3
					for(float s = .2;s<1.;s+=.3)
					{
						float shadow_offset = s*shadow_pos_offset.x;
						sdist=(texture(shadowtex1, shadowPos.xy+shadow_offset ).r - shadowPos.z)*sdistm ;
						sun_light1 += (sdist < SHADOW_BIAS_N ) ? 0. : 1.;
						weight++;
					}
					#endif
					#if SOLAR_GI_SHADOWMAP_SAMPLES >= 4 && SOLAR_GI_SHADOWMAP_SAMPLES < 16
						weight+=3.;
						vec2 shadow_offset = vec2(shadow_pos_offset.x);
						sdist=(texture(shadowtex1, shadowPos.xy+shadow_offset ).r - shadowPos.z)*sdistm ;
						sun_light1 += (sdist < SHADOW_BIAS_N ) ? 0. : 1.;
						
						shadow_offset = vec2(0.,shadow_pos_offset.x);
						sdist=(texture(shadowtex1, shadowPos.xy+shadow_offset ).r - shadowPos.z)*sdistm ;
						sun_light1 += (sdist < SHADOW_BIAS_N ) ? 0. : 1.;
						
						shadow_offset = vec2(shadow_pos_offset.x,0.);
						sdist=(texture(shadowtex1, shadowPos.xy+shadow_offset ).r - shadowPos.z)*sdistm ;
						sun_light1 += (sdist < SHADOW_BIAS_N ) ? 0. : 1.;
						#if SOLAR_GI_SHADOWMAP_SAMPLES >= 8
					
							shadow_offset = vec2(shadow_pos_offset.x)*.5;
							sdist=(texture(shadowtex1, shadowPos.xy+shadow_offset ).r - shadowPos.z)*sdistm ;
							sun_light1 += (sdist < SHADOW_BIAS_N ) ? 0. : 1.;
							
							shadow_offset = vec2(0.,shadow_pos_offset.x);
							sdist=(texture(shadowtex1, shadowPos.xy+shadow_offset ).r - shadowPos.z)*sdistm ;
							sun_light1 += (sdist < SHADOW_BIAS_N ) ? 0. : 1.;
							
							shadow_offset = vec2(shadow_pos_offset.x,0.);
							sdist=(texture(shadowtex1, shadowPos.xy+shadow_offset ).r - shadowPos.z)*sdistm ;
							sun_light1 += (sdist < SHADOW_BIAS_N ) ? 0. : 1.;
							weight+=3.;
						#endif
					#endif
					
					#if SOLAR_GI_SHADOWMAP_SAMPLES == 16
						shadow_pos_offset.xyz = shadow_pos_offset.xyz-shadowPos.xyz;
						sun_light1=0.;
						weight=0.;
						for(int y = 0;y<5;y++)
						{
							for(int x = 0;x<5;x++)
							{
								vec3 shadow_offset = vec3( vec2(x,y)*.25*shadow_pos_offset.xy,
								max(x,y)*.25*shadow_pos_offset.z
								 );
								sdist=(texture(shadowtex1, shadowPos.xy+shadow_offset.xy ).r - (shadowPos.z+shadow_offset.z))*sdistm ;
								sun_light1 += (sdist < SHADOW_BIAS_N ) ? 0. : 1.;
								weight++;
							}
						}
						
						
					#endif
					
					sun_light1/=weight;
				#endif
				
				if(sun_light1 > 0.001)
				{				
						
				
						
					
					#if SUNSET == 0
						vec3 sun_color =
						
						#if CUSTOM_SUN_COLOR == 0
							texture(lightmap, vec2(1./32.,lmy_og)).rgb //sky_color at lmy_og
						#endif
						#if CUSTOM_SUN_COLOR == 1
							(sunAngle <.5 ?
							vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)*SUN_BRIGHTNESS
							:vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B)*MOON_BRIGHTNESS*MOON_BRIGHTNESS
							)
							
						#endif
						;
					#endif
	
					#if SUNSET == 2
						vec3 sun_color =
						clamp(
						
						#if CUSTOM_SUN_COLOR == 0
							texture(lightmap, vec2(1./32.,lmy_og)).rgb //sky_color at lmy_og
						#endif
						#if CUSTOM_SUN_COLOR == 1
							(sunAngle <.5 ?
							 vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)*SUN_BRIGHTNESS
							 :vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B)*MOON_BRIGHTNESS*MOON_BRIGHTNESS
							 )
						#endif

						  -
						  vec3(SUNSET_FADE_R,SUNSET_FADE_G,SUNSET_FADE_B )
						  *(1.-clamp((1.-abs(sunAngle-
						  (sunAngle<.5? .25 : .75)
						  
						  )*4.)*10.,0.,1.))
						  ,0.,1.)
						  ;
					#endif
		 
		 
					#if SUNSET == 1
							#if CUSTOM_SUN_COLOR == 0
								vec3 sun_color = texture(lightmap, vec2(1./32.,lmy_og)).rgb //sky_color at lmy_og
							#endif
							#if CUSTOM_SUN_COLOR == 1
								vec3 sun_color =
								sunAngle <.5 ?
								 vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)*SUN_BRIGHTNESS
								 :vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B)*MOON_BRIGHTNESS*MOON_BRIGHTNESS
							 #endif
						*clamp((1.-abs(sunAngle-
						  (sunAngle<.5? .25 : .75)
						  
						  )*4.)*10.,0.,1.);
				
	 
					#endif
					
					
					
					
					#if SOLAR_GI < 2 && SOLAR_GI_DOT == 1
						sun_color*=mix( 1.,clamp( dot(sun_dir,normals_face),0.,1.),DIRECTIONAL_SOLAR_GI);
					#endif
					
					#if COLORED_SHADOWS == 1 
			if ( sun_light1 >=0.001 )

			{
				//surface is in sunlight
				
					float sdistc=(texture(shadowtex0, shadowPos.xy ).r-shadowPos.z)*sdistm ;
					#if DEBUG_MODE == 1
						 debugdata3=vec3((1.-sdistc*Shadow_map_depth/-20.));
					#endif
					if (sdistc < -0.000001
					)
					{
						//surface has translucent object between it and the sun. modify its color.
						//make colors more intense when the shadow light color is more opaque.
						 vec4 shadowLightColor =  texture(shadowcolor0, shadowPos.xy);
						 
						 //make colors more intense when the shadow light color is more opaque.
						 shadowLightColor.rgb = mix(vec3(1.0),shadowLightColor.rgb,min(1.,shadowLightColor.a*2.))
						 #if BRIGHTER_UNDERWATER == 1
							*(isEyeInWater > 0 ?  max(0.,1.-sdistc*Shadow_map_depth/-20.) : 1.0)
							#endif
			//			*(shadowLightColor.a<.999 || texture_sss > 0.001 ?1.:0.)
						 ;			 
						 sun_color*= shadowLightColor.rgb;
						
					
						
					}
					
				}
				#endif
					
					
					
					
					sun_color*=lmy_og
					* sun_light1
					#if ADJUST_GI_INTENSITY == 1
						*GI_INTENSITY
					#endif
					;
					
					
					
					
					
				//	gi[4].rgb = max( gi[4].rgb, vec3(1.,0.,0.).rgb *sun_color);
					
		//			if(voxel_data.a < .05 )
					{
						#if TRACELESS_PT == 0
							bounce_light = true;
							voxel_data.rgb = neighbor_data.rgb * sun_color;
						#endif
						#if TRACELESS_PT == 1
							//directional lpv
							vec4 light_color = texture3D(cSampler3_colored_light, 
							vec3(orig_voxel_pos+.9*normals_face+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset_read)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
							);	
							vec4 light_color2 = texture3D(cSampler3_colored_light, 
							vec3(orig_voxel_pos+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset_read)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
							);	
							
							vec4 dramaric = clamp(light_color-light_color2*.8,0.,1.)*2.;
							vec4 dramaric2 = clamp(light_color-light_color2,0.,1.)*3.;
							vec4 directional2 =  						
									min(light_color2,pow(clamp((light_color-light_color2) *DBLX_MULT,0.,1.)*1., vec4(1.0)));								
									float vx_lum= (directional2.r+directional2.g+directional2.b)/3.;
									vec3 vx_hue = directional2.rgb - vx_lum;
									directional2.rgb = max(vec3(0.), vx_lum + vx_hue );
							vec4 rough_dir = light_color;
							
							//opacity_type = 4;
							bounce_light = true;
							voxel_data.rgb = neighbor_data.rgb *
							(sun_color+ directional2.rgb);
						#endif
					}
				}
				
			}
		}
			//write data
			
		//	imageStore(cimage4_gi, voxel_pos_new, gi[4] );
		}//if air
	
	}
#endif
