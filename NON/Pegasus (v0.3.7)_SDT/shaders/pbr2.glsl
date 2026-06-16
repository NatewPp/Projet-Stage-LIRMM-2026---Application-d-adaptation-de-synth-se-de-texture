// © Copyright 2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


#if SSS >= 1
	main_lighting=shadowPos.w <0.0? max(sss,main_lighting): main_lighting;
#endif

#if PBR >= 2
	specular_pixel = abs(ipbr_id-10020.)<=.5? vec4(1.,0.02,1.,0.): specular_pixel;
	
	
	//vec3 view_dir = normalize(viewPos.xyz);
	
	


color.rgb = mix(color.rgb,vec3(0.0),actual_wetness*.25+wetness*porosity*.5 );



	
	specular_pixel.r = metalness > .5? mix(specular_pixel.r,1.,METAL_SMOOTHER) : specular_pixel.r ;
	//vec3 reflected_angle = reflect(view_dir,normals_pixel.xyz);
	//float fresnel = pow(max(0.,dot(reflected_angle,view_dir)),mix(10.,5.,specular_pixel.r));
	
	float fresnel =mix(ROUGH_FRESNEL,FRESNEL,specular_pixel.r)*pow(max(0., dot(reflected_angle,view_dir) ),(is_water?WATER_FRESNEL_CURVE: FRESNEL_EXPONENT));
	
	specular_pixel.g= mix(max(metalness, specular_pixel.g),1.,fresnel);
	//specular_pixel.g*=specular_pixel.r;
	
	
	
	vec3 sun_shine = SUN_SPARKLE*
//sun_color*//*	vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)
sign(shadowPos.w)
*main_lighting*(sun_lighting>0.001?1.:0.)
	*specular_pixel.r
	* mix(vec3(1.) ,color.rgb,metalness) 
	*specular_pixel.g 
	* clamp ((dot(normalize(shadowLightPosition), (reflected_angle))
		-(1.-SUN_WIDTH)*(specular_pixel.r))/max(0.001,SUN_WIDTH*(1.-specular_pixel.r))
		,0.,1.)  ;
		
		float sparkle_opacity = color.a*(sun_shine.g + sky_shine.g);
		
		sun_shine*=sun_color;
		
		// v *(specular_pixel.r))/max(0.001,SUN_WIDTH*(1.-specular_pixel.r))
		float sky_reflection = dot(n_sky_dir, reflected_angle);
		

	#define REFLECT_SKY_STUFF 0
	#if REFLECT_SKY_STUFF == 1
	
			vec4 world_dir = vec4(reflect(normalize(viewPos.xyz),
			normals_pixel.xyz),1.);
			world_dir =   gbufferModelViewInverse*world_dir-gbufferModelViewInverse[3];
			
			
			vec4 cloudsq =  clouds_refl(
				//world_dir = gbufferModelViewInverse * //world_dir+gbufferModelViewInverse[3]
			world_dir
			,cloud_depth) ;
			
			float foam_refl_null = pow(
			#if THIS_IS_DISTANT_HORIZONS != 1 
				foam
			#else
				0.
			#endif
			,7.);
			

			cloudsq.rgb= mix(

				 calcSkyColor_w(world_dir.xyz).rgb

			,cloudsq.rgb,cloudsq.a)
			*(1.-.1*foam_refl_null)
			*(lmy_og-1./32.)/(30./32.)
			;
			
			sky_shine = cloudsq.rgb
	#else
		sky_shine = skyColor
	#endif
	
	
	
	*sky_shine
	*specular_pixel.r
	* mix(vec3(1.) ,color.rgb,metalness) 
	*specular_pixel.g 
	* clamp( mix((sky_reflection+1.)*.5,sky_reflection,specular_pixel.r),0.,1.) 
; 

	
	//color= metalness > 0.5? vec4(specular_pixel.g) : color;
#endif