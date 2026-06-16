// © Copyright 2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


//water fogColor
			

			//water fog
			#if REFRACTIONS == 1 && WATER_COL_ABSORB >= 2 
				vec2 screen_coord = texcoord;//gl_FragCoord.xy /vec2(viewWidth,viewHeight);
				vec2 refractuv = normals_pixel.xy*REFRACTION_DISTANCE//(.05+.1
				* (1.-
				pow(
				clamp(
				vec2( 
				 ((abs(screen_coord.x-.5)*2.)-(1.- REFRACTION_DISTANCE*3.) )/(REFRACTION_DISTANCE*3.)
				, ((abs(screen_coord.y-.5)*2.)-(1.- REFRACTION_DISTANCE*3.) )/(REFRACTION_DISTANCE*3.)
				
				)
				*1.
				,0.,1.)
				,vec2(1.))
				)
				;

				;

					//			min(
					//linearize_water_d(texelFetch(dhDepthTex1,ivec2(gl_FragCoord.xy),0).r, dhNearPlane, dhFarPlane)
					//,linearize_water_d(texelFetch(depthtex1,ivec2(gl_FragCoord.xy),0).r,near, far*4.)
					//)
	
				float opaque_d = 
				#if defined IS_IRIS && defined DISTANT_HORIZONS
					min(
					linearize_water_d(texelFetch(dhDepthTex1,ivec2(gl_FragCoord.xy -ivec2(vec2(viewWidth,viewHeight)*refractuv)),0).r, dhNearPlane, dhFarPlane),
					linearize_water_d(texelFetch(depthtex1,ivec2(gl_FragCoord.xy -ivec2(vec2(viewWidth,viewHeight)*refractuv)),0).r,near, far*4.)
					
				)
				;
				#else
				
					linearize_water_d(texelFetch(depthtex1,ivec2(gl_FragCoord.xy -ivec2(vec2(viewWidth,viewHeight)*refractuv)),0).r,near, far*4.)
				
				;
				#endif
				
				
				float obscured_refract = 3.;
				float lin_c_wd = linearize_water_d(gl_FragCoord.z, near, far*4.);
				for(float i = 1. //3 to step
				; opaque_d < lin_c_wd && i >=0.;i-- )
				{
					refractuv= normals_pixel.xy*REFRACTION_DISTANCE*i/3.;
					opaque_d = 
						//texelFetch(depthtex1,ivec2(gl_FragCoord.xy -ivec2(vec2(viewWidth,viewHeight)*refractuv)),0).r;
						#if defined IS_IRIS && defined DISTANT_HORIZONS
							min(
						linearize_water_d(texelFetch(dhDepthTex1,ivec2(gl_FragCoord.xy -ivec2(vec2(viewWidth,viewHeight)*refractuv)),0).r, dhNearPlane, dhFarPlane),
						linearize_water_d(texelFetch(depthtex1,ivec2(gl_FragCoord.xy -ivec2(vec2(viewWidth,viewHeight)*refractuv)),0).r,near, far*4.)
						
					);
						#else
	
						linearize_water_d(texelFetch(depthtex1,ivec2(gl_FragCoord.xy -ivec2(vec2(viewWidth,viewHeight)*refractuv)),0).r,near, far*4.)
						
					;
						#endif
						
					obscured_refract--;
				}
			
			#else
				float opaque_d = 
				//texelFetch(depthtex1,ivec2(gl_FragCoord.xy),0).r;
				//linearize_water_d(texelFetch(depthtex1,ivec2(gl_FragCoord.xy ),0).r,near, far*4.);
				#if defined IS_IRIS && defined DISTANT_HORIZONS
						min(
					linearize_water_d(texelFetch(dhDepthTex1,ivec2(gl_FragCoord.xy) ,0).r, dhNearPlane, dhFarPlane)
					,linearize_water_d(texelFetch(depthtex1,ivec2(gl_FragCoord.xy) ,0).r,near, far*4.)
					);
						#else

					linearize_water_d(texelFetch(depthtex1,ivec2(gl_FragCoord.xy) ,0).r,near, far*4.)
					;
						#endif
				
				float lin_c_wd = linearize_water_d(gl_FragCoord.z, near, far*4.);
			#endif	
			
			/*
			works
			vec2 refractuv = normals_pixel.xy*REFRACTION_DISTANCE
			*clamp()
			;//(.05+.1* 
			opaque_d = 			min(
					linearize_water_d(texelFetch(dhDepthTex1,ivec2(gl_FragCoord.xy) -ivec2(vec2(viewWidth,viewHeight)*refractuv),0).r, dhNearPlane, dhFarPlane)
					,linearize_water_d(texelFetch(depthtex1,ivec2(gl_FragCoord.xy) -ivec2(vec2(viewWidth,viewHeight)*refractuv),0).r,near, far*4.)
					);
			*/
			
			float wf1;// =  ((opaque_d)-lin_c_wd);//linearize_water_d(gl_FragCoord.z, near, far*4.)
			float wf;// = clamp( wf1 /WATER_VISIBILITY,0.,1.)

			is_water_fog=1.;//debug 
			
					
				 wf1 =  isEyeInWater == 1 ? 0. : ((opaque_d)-lin_c_wd);  //linearize_water_d(gl_FragCoord.z, near, far*4.)
				 wf = clamp( wf1 /mix(1.,WATER_VISIBILITY,is_water_fog) ,0.,mix(1.,.3,is_water_fog));
				//wf = pow(wf,2);
				
				 ;

			water_color = abs(ipbr_id-10021.)<0.5?mix(vec3(0.,.7,1.),water_color,color.a): water_color;
		//	water_color= vec3(1.,0.,0.);
				
				#if WATER_COL_ABSORB < 2 
					color.rgb = mix(color.rgb,water_color*sun_color
					,wf*(1.-color.a));
					color.a+=(1.-color.a)*wf;
				#endif
				#if WATER_COL_ABSORB >= 2 
				//&&  THIS_IS_DISTANT_HORIZONS != 1 
				
				
					#if WATER_SCATTERS_LIGHT == 1
						#if REFRACTIONS == 1
							vec3 old_col = 
								//textureLod(colortex5,gl_FragCoord.xy/vec2(viewWidth,viewHeight) -refractuv,5.*(wf)).rgb 
								texelFetch(colortex5,ivec2(gl_FragCoord.xy) -ivec2(vec2(viewWidth,viewHeight)*refractuv),5.*(wf)).rgb
							//* obscured_refract/3.
							;
						#else
							vec3 old_col = textureLod(colortex5,gl_FragCoord.xy/vec2(viewWidth,viewHeight),5.*(wf)).rgb;
						#endif
					#else
						#if REFRACTIONS == 1
							vec3 old_col =
								//texture2D(colortex5,gl_FragCoord.xy/vec2(viewWidth,viewHeight) -refractuv).rgb
								texelFetch(colortex5,ivec2(gl_FragCoord.xy) -ivec2(vec2(viewWidth,viewHeight)*refractuv),0).rgb
							//* obscured_refract/3.
							;
						#else
							vec3 old_col = texture2D(colortex5,gl_FragCoord.xy/vec2(viewWidth,viewHeight)).rgb;
						#endif	
					#endif

					old_col= mix(old_col.rgb,water_color
					*sun_color* mix(1.,(1.-wf*wf),is_water_fog)
					
					,wf);
					float WATER_COLOR_ABSORB_DISTa=is_water?WATER_COLOR_ABSORB_DIST:1.;
					
					
					if(is_water)
					{
					color.rgb = mix(
					 old_col * clamp( vec3(1.)-vec3(4.,1.,0.)*wf1/WATER_COLOR_ABSORB_DISTa,0.,1. ) ,color.rgb,color.a);
					color.a=1.;
					}else{
						color.rgb = mix(
					 old_col   ,
					  old_col * mix(vec3(1.),water_color.rgb, clamp(wf1,0.,1. )),color.a);
					color.a=1.;
					}
					
					#if IS_WATER_SHADER == 1

						//color.rgb = normals_pixel.xyz+.5;//debug
					//	color.r = ((clamp((dist-far*(1.-DH_FADE*2.))/(far*DH_FADE),0.,1.)) );//
					#endif
		
		
				#endif
			