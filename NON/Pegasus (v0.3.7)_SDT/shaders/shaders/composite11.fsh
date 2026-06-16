// © Copyright 2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


#define REFLECTIONS_ARE_IN_RAYDIR 1

#include "/settings.glsl"
#include "/noise.glsl"

#if TINT_METALS == 1 
	uniform sampler2D colortex4;//albedo
	uniform sampler2D colortex10;//early reflectoin
#endif

uniform vec3 sunPosition;
uniform float frameCounter;

#if REFLECTION_DETAIL >= 5	
	uniform sampler2D colortex8;//pbr
#endif

uniform float near;
uniform float far;
#if defined IS_IRIS && defined DISTANT_HORIZONS 
	uniform float dhFarPlane;
	uniform float dhNearPlane;
	float far_adjusted = dhFarPlane;
	
#else
	float far_adjusted = far;
#endif

uniform ivec2 eyeBrightnessSmooth;

#if SSPTGI > 0
	
	
#endif
/*
	const bool colortex0MipmapEnabled = true;
	*/
/*
	const bool colortex9MipmapEnabled = true;
*/

vec3 projectAndDivide(mat4 projectionMatrix, in vec3 position)
{
	vec4 position2= projectionMatrix*vec4(position,1.);
	return position2.xyz/position2.w;
}

float linearize_water_d( in float depth, in float n, in float f)
	{
	   return .7* (n * f) / (depth * (n - f) + f);
	}
	
#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif
uniform float frameTimeCounter;
varying vec2 texcoord;
uniform float rainStrength;
uniform float thunderStrength;

	uniform sampler2D colortex6;//sky
	uniform sampler2D colortex9;//sky cubemap
	
	uniform sampler2D colortex5;//solids
	#if REFRACTIONS == 1
		uniform sampler2D colortex2;//normals
		uniform sampler2D colortex7;//water
		uniform sampler2D colortex3;//hand
		uniform sampler2D depthtex1;
	#endif

#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1	
	uniform sampler2D dhDepthTex1;
#endif
	
//#if CLOUDS >= 1 ||  GODRAYS == 1 
	uniform float sunAngle;
//#endif

#if CLOUDS >= 5 
	uniform sampler2D colortex0;
#endif

	uniform vec3 fogColor;
	uniform vec3 skyColor;
	
uniform float Foggy=0.;
//#if CLOUDS >= 1 || REFLECTION_DETAIL >= 3
	#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
//#endif
//#if CLOUDS >= 1 
	uniform int worldTime;
	uniform int worldDay;
	
	uniform mat4 gbufferModelView;
	#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
		uniform vec3 shadowLightPosition;


	#if VANILLA_SUNSETS == 0

		

	#endif

	float fogify(float x, float w) {
		return w / (x * x + w);
	}
	#include "/clouds.glsl"

//#else
//	float cloudy = 0.;
//#endif


#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
	uniform sampler2D colortex1;
	 float Cloud_mask = 9990.0;
#else
	 float Cloud_mask = far_adjusted-.1;

#endif

#if DEBUG_SHADOWS == 1
	uniform sampler2D shadowcolor0;
#endif


#if GODRAYS == 1 
	uniform mat4 gbufferProjection;
	
	uniform sampler2D lightmap;
	
	uniform float rainfall=0.;
	//float Foggy = min(1.,rainfall*.1+rainStrength);
#endif

#if WATER_COL_ABSORB >= 2 
	uniform sampler2D colortex5;
	#if WATER_COL_ABSORB >= 2 && REFRACTIONS == 1
		uniform sampler2D colortex6;
	#endif
#else
	#if CLOUDS < 5 
		uniform sampler2D colortex0;
	#endif
	
#endif
		

uniform sampler2D depthtex0;
#if BORDERS >= 2
	uniform sampler2D colortex1;
#endif


#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
		float far1 = dhFarPlane*DH_FOG_END;
		#else
		float far1 = far;
		#endif
uniform int isEyeInWater;

uniform vec3 focolortex5;
#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif



#include "/stuff/onion/mini_onion_h.glsl"

float linearize_depth_cpf(in float d)
{

    // from gl_FragCoord.z to world measurements
    return 2.0 * near  * far / (far + near - (2.0 * d - 1.0) * (far - near));

}

#if defined IS_IRIS && defined DISTANT_HORIZONS 
float linearize_depth_cpf_dh(in float d)
{

    // from gl_FragCoord.z to world measurements
    return 2.0 * dhNearPlane  * dhFarPlane / (dhFarPlane + dhNearPlane - (2.0 * d - 1.0) * (dhFarPlane - dhNearPlane));

}
#endif
float linearize_depth_cpf2(in float d)
{

    // from gl_FragCoord.z to world measurements
    return 2.0 * near  * far*4. / (far*4. + near - (2.0 * d - 1.0) * (far*4. - near));

}

float get_depth_at(vec2 uv)
{
#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
	return texture2D(colortex1,uv).x;
#else
	return linearize_depth_cpf(texture2D(depthtex0,uv).r);
#endif

}

float get_underwater_depth_at(vec2 uv)
	{
		#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
			float d =  
				min(
				linearize_depth_cpf2(texture2D(depthtex1,uv).r),
				linearize_depth_cpf_dh(texture2D(dhDepthTex1,uv).r) ) ;
				return abs(d) > 0.1 ? d: 10.;
		#else
			return linearize_depth_cpf(texture2D(depthtex1,uv).r);
		#endif
		
		
	}

float get_depth_at2(vec2 uv)
{
#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
	float d = texture2D(colortex1,uv).x;
	return
//	abs(d-0.) < 0.01 ? 1. :
	pow(clamp(d/far1,0.,1.),1.);
#else
	float d = texture2D(depthtex0,uv).r;//
	return d >.999 ? 1. : clamp(linearize_depth_cpf(d)/far1,0.,1.);
#endif

}



#include "/stuff/fluids/sky_color_h.glsl"





void main() {
	vec3 debug3;
	vec4 normals = texture2D(colortex2, texcoord);
	
	
	#if REFLECTION_DETAIL >= 5	
		//load and unpack data
		vec4 pbr_data = texture2D(colortex8, texcoord);
		float smoothness = pbr_data.r;
		float reflective_strength = pbr_data.g;
		float is_water = pbr_data.b;
		float f0 = pbr_data.a;
	#else
		float is_water = normals.w > .5 ?1. : 0.;
	#endif


		
		
		vec4 color = texture2D(colortex0, texcoord);
		
		normals.rgb=normals.rgb*2.-1.;
		float material = get_depth_at( texcoord) ;
	


	#if REFLECTION_DETAIL >= 3
	
		if(	
			#if REFLECTION_DETAIL >= 5
				//check flags for reflections, like is this water or shiny, to save performance
				(smoothness*reflective_strength >= REFLECTION_THRESHHOLD && normals.w > .01)
				|| is_water>.5
			#else
				//color.a+water.a > 0.001
				 material < far_adjusted
				// normals.w > .5
				#if SSPTGI == 0
					&& normals.w > .5
				#endif
			#endif
			
		
			
		
		)
		{
		
			#if TINT_METALS == 1 && REFLECTION_DETAIL >= 5
				vec3 albedo;
				vec3 pre_reflection;
				if(f0> 230./255.)
				{
					albedo = texture2D(colortex4, texcoord).rgb;
					pre_reflection  = texture2D(colortex10, texcoord).rgb;
				}
			#endif
			
		//#include "/reflections.glsl"
		//color = texture2D(colortex5, refracted_coord);
		//normals
		//float material = get_depth_at( texcoord) ;
		//normals.z=abs(normals.z);
		vec3 pos = vec3(texcoord,1.)*2.-1.;
		
		vec3 last_ray_pos = pos*.5+.5;
		
		pos=  projectAndDivide(gbufferProjectionInverse,pos) ;
		pos=normalize(pos);
		pos/=(pos.z);
		
		pos*=-material;
		
		//pos*=-1;
		
		//	vec3 ray_spd =  normals.w > .5 ? normalize( reflect(
		//	normalize(pos)
		//	,normals.xyz)) : normals.xyz ;
		vec3 ray_spd =  normalize( reflect(normalize(pos),normals.xyz)) ;
		
		vec3 goal = pos+ray_spd*1.;
		
		#if REFLECTION_DETAIL >= 5	
			float f = f0 + mix(ROUGH_FRESNEL,FRESNEL,smoothness)*(1.-f0)*pow(1.-max(0., dot(normals.xyz,ray_spd) ),(is_water>.5?WATER_FRESNEL_CURVE: FRESNEL_EXPONENT));
		#else
			float f = pow(1.-max(0., dot(normals.xyz,ray_spd) ),WATER_FRESNEL_CURVE);
		#endif

		
		
		//debug3= vec3(fract(material));
		vec3 raypos = pos;
		
		bool hit = false;
		bool oob = false;
		
		
		 float RAY_DIST2 =
					ray_spd.z > 0.? 
						max(-pos.z,10.) : 	
						mix(max(10.,0.),min(far_adjusted,far_adjusted)+pos.z,
						1.//pow(goal.z,2.)
						); 
		//vec3 db = pos; //debug
		for(float i = 0.;i< SSR_STEPS && !hit && !oob; i++)
		{
			//raypos = pos+ray_spd*i;
			raypos = (pos+ ray_spd.xyz*RAY_DIST2*pow(i/SSR_STEPS,4.));
			
			vec4 raypos2=gbufferProjection*vec4(raypos.xyz,1.);
					raypos2.xy/=raypos2.w;
    				raypos2.xy=raypos2.xy*.5+.5;
					raypos=raypos2.xyz;
			oob = raypos.x<0 || raypos.x>1 || raypos.y<0 || raypos.y> 1 || raypos.z<0;
			
			//a bias is necesary so that rays don't immediately hit where they are coming from
	    	float bias =
				//this is very janky, do better. I didn't have problems in shaders that aren't reconstricting the position from the pixel position on screen, so i think it's a precision issue there that causes problems here
				//a small bias is fine for up close, if you use just this it's perfect up close but no eflections far away
					0.1  
				//we use more bias to account for error in depths at distance, but this gives us a distorted janky result
			//		+ (abs(pos.z)-0.)
				//we reduce the additional bias as we get away from starting surface to limit this distortion
			//		*pow(1.-1.*i/SSR_STEPS,2.)
					;
					
			
			float d = get_depth_at( raypos.xy) ;
			
			//hit = d < raypos.z && !oob ;
			hit = d + bias < raypos.z //occluded ray
				&& !oob //on screen
				//allow rays to continue if far enough behind something
				&& d + bias + raypos.z *.1 + abs(last_ray_pos.z-raypos.z) > raypos.z
				;
			
		    last_ray_pos = !hit ? raypos : last_ray_pos;
			
		}
		
		//vec3 db = pos;//debug view
		
		if(hit )
		{
			//refine pos
			float d;
			pos = raypos;
				float reverse = -1.0;
				float refined = 1.0;
				float rrayspeed = 1.0;
				for(int rr = 0;rr<SSR_REFINEMENT_STEPS;rr++)
				{ 
				    rrayspeed*=.5;
					refined+=rrayspeed*reverse;
					raypos = mix(last_ray_pos, pos,refined);

					d = get_depth_at( raypos.xy) ;
					hit = d < raypos.z;
					
					reverse = hit? -1.0 : 1.0;
				}
	
	
			//fade reflections on screen edges
			
			f*= (
				(is_water >.5) ?
					(clamp( min( (1.-abs(raypos.x-.5 )*2.)*20. , (1.-abs(raypos.y-.5 )*2.)*5.) ,0.,1.) )
					:
					(clamp( min( (1.-abs(raypos.x-.5 )*2.) , (1.-abs(raypos.y-.5 )*2.)) ,0.,1.) )
				)	
				;
			
			#if SSPTGI == 0
				//determine lod, for rough reflectios
				#if REFLECTION_DETAIL >=5 
					float ray_lod = 8.*(1.-smoothness);
					vec3 reflection =  textureLod(colortex0, raypos.xy,ray_lod).rgb;
				#else
					vec3 reflection =  textureLod(colortex0, raypos.xy,0.).rgb;
				#endif
					
					
					
					
				color.rgb = mix(color.rgb,reflection,f);
				//color.rgb =raypos;//debug
			#endif
			#if SSPTGI == 1
				float ray_lod = (normals.w > .5)? 0.: 6. ;
				
				vec3 reflection = textureLod(colortex0, raypos.xy,ray_lod).rgb;	
				f *= (normals.w > .5)? 1.: 0. ;
				float ssptgi =1.-f;
				color.rgb = mix(color.rgb,reflection,f) + color.rgb*reflection*ssptgi;
			#endif
			
					
				
		}else{
		 if(!oob){
		 
			#if REFLECTION_DETAIL < 4
			//	f*= f*( clamp( min( (1.-abs(raypos.x-.5 )*2.)*20. , (1.-abs(raypos.y-.5 )*2.)*20.) ,0.,1.) );
			#endif
		 
		 
			#if SSPTGI == 0
				vec3 reflection = texture2D(colortex0, raypos.xy).rgb ;	
				
				#if REFLECTION_DETAIL >= 4
					float edge_fade = 1.-clamp( min( (1.-abs(raypos.x-.5 )*2.)*5. , (1.-abs(raypos.y-.5 )*2.)*5.) ,0.,1.) ;
					if(edge_fade>0.001)
					{
						float cloud_depth = ray_spd.z;
						vec4 world_dir = gbufferModelViewInverse * vec4(ray_spd.xyz,1.);
						world_dir.xyz-=gbufferModelViewInverse[3].xyz;;//feet position
						vec3 cloudsq = 
							(
							isEyeInWater == 1 ? fogColor.rgb
								//*skyColor: //sky fog under water
								*skyColor*float(eyeBrightnessSmooth.y)/240. :
							texture2D(colortex9, unroll_mc_raydirf_float(world_dir.xyz) ).rgb
							)
							*float(eyeBrightnessSmooth.y)/240.;
			
						reflection.rgb = mix(reflection.rgb,cloudsq.rgb ,edge_fade);
						
			
					}
				#endif
				
				//apply metal tint
				#if TINT_METALS == 1
					if(f0> 230./255.) reflection*= pow(albedo.rgb,vec3(2.));
					reflection = max(reflection, pre_reflection);
				#endif
				color.rgb = mix(color.rgb,reflection,f);
			#endif
			
			#if SSPTGI == 11
				float ray_lod = (normals.w > .5)? 0.: 11. ;
				float ssptgi =f*(1.-ray_lod/5.);
				vec3 reflection = textureLod(colortex0, raypos.xy,ray_lod).rgb;	
				f *= (normals.w > .5)? 1.: 0. ;
				
				//apply metal tint
				#if TINT_METALS == 1
					if(f0> 230./255.) reflection*= pow(albedo.rgb,vec3(2.));
					reflection = max(reflection, pre_reflection);
				#endif
				color.rgb = mix(color.rgb,reflection,f) + color.rgb*reflection*ssptgi;
			#endif
			#if SSPTGI == 1
				float ray_lod = (normals.w > .5)? 0.: 8. ;
				
				vec3 reflection = textureLod(colortex0, raypos.xy,ray_lod).rgb;	
				
				//reflection = vec3(0.,1.,0.);//debug
				
				f *= (normals.w > .5)? 1.: 0. ;
				float ssptgi =1.-f;
				
				//apply metal tint
				#if TINT_METALS == 1
					if(f0> 230./255.) reflection*= pow(albedo.rgb,vec3(2.));
					reflection = max(reflection, pre_reflection);
				#endif
				
				color.rgb = mix(color.rgb,reflection,f) + color.rgb*reflection*ssptgi;
			#endif
			
		
			
		
				
				}
				#if REFLECTION_DETAIL >= 4
				else{
				
					#if SSPTGI == 0
						//if(is_water>.5)
						{
							float cloud_depth = ray_spd.z;
							vec4 world_dir = gbufferModelViewInverse * vec4(ray_spd.xyz,1.);
							world_dir.xyz-=gbufferModelViewInverse[3].xyz;;//feet position
							#if OFFFSCREEN_REFLECTIONS_ATYLE == 0
								float rm =1.;// clamp((world_dir.y+.4) *5.,.5,1.);
								//if(world_dir.y >0.)
								{
									bool sees_sky = world_dir.y >0.;
									world_dir.y=abs(world_dir.y);
											vec3 cloudsq = 
												(
												isEyeInWater == 1 ? fogColor.rgb
													//*skyColor: //sky fog under water
													*skyColor*float(eyeBrightnessSmooth.y)/240.:
												textureLod(colortex9, unroll_mc_raydirf_float(world_dir.xyz) ,sees_sky?0.:1. ).rgb
												)
												*float(eyeBrightnessSmooth.y)/240.
												*(sees_sky?1.:.5)
												;
									//apply metal tint
									#if TINT_METALS == 1
										if(f0> 230./255.) cloudsq.rgb*= pow(albedo.rgb,vec3(2.));
										cloudsq.rgb = max(cloudsq.rgb, pre_reflection);
									#endif
									
									color.rgb = mix(color.rgb,cloudsq.rgb*rm,f);
								}
							#else
								float rm = clamp((world_dir.y+.4) *5.,.5,1.);
								if(world_dir.y >0.)
								{
									world_dir.y=abs(world_dir.y);
								}
									vec3 cloudsq = 
										(
										isEyeInWater == 1 ? fogColor.rgb
											//*skyColor: //sky fog under water
											*skyColor*float(eyeBrightnessSmooth.y)/240.
										: texture2D(colortex9, unroll_mc_raydirf_float(world_dir.xyz) ).rgb
										)
										*float(eyeBrightnessSmooth.y)/240.;
									//apply metal tint
									#if TINT_METALS == 1
										if(f0> 230./255.) cloudsq.rgb*= pow(albedo.rgb,vec3(2.));
										cloudsq.rgb = max(cloudsq.rgb, pre_reflection);
									#endif
									color.rgb = mix(color.rgb,cloudsq.rgb*rm,f);
							#endif
						
						}
						
					#endif
					#if SSPTGI == 11
						float ray_lod = (normals.w > .5)? 0.: 11. ;
						float ssptgi =f*(1.-ray_lod/5.);
						float cloud_depth = ray_spd.z;
						#if CLOUDS >= 3
							vec3 cloudsq =  ray_lod < 1.? clouds(ray_spd.xy,cloud_depth,color.rgb).rgb : skyColor;	
						#else
							vec3 cloudsq =  ray_lod < 1.? clouds(ray_spd.xy,cloud_depth).rgb : skyColor;
						
						#endif
						f *= (normals.w > .5)? 1.: 0. ;
						if(f0> 230./255.) cloudsq.rgb*= pow(color.rgb,vec3(2.));
						color.rgb = mix(color.rgb,cloudsq,f) + color.rgb*cloudsq*ssptgi;
					#endif
					#if SSPTGI == 1
						float ray_lod = (normals.w > .5)? 0.: 2. ;
						float cloud_depth = ray_spd.z;
						#if CLOUDS >= 3
							vec3 reflection =  ray_lod < 1.? clouds(ray_spd.xy,cloud_depth,color.rgb).rgb : skyColor;	
						#else
							vec3 reflection =  ray_lod < 1.? clouds(ray_spd.xy,cloud_depth).rgb : skyColor;
						
						#endif
						//reflection = vec3(0.,0.,0.);//debug
						f *= (normals.w > .5)? 1.: 0. ;
						float ssptgi =1.-f;
						//apply metal tint
						#if TINT_METALS == 1
							if(f0> 230./255.) reflection*= pow(albedo.rgb,vec3(2.));
							reflection = max(reflection, pre_reflection);
						#endif
						color.rgb = mix(color.rgb,reflection,f) + color.rgb*reflection*ssptgi;
					#endif
					
					
					
					
				;
						
				}
				#endif
		}
		//color.rgb = fract(pos.xyz*.1);//debug
		//color.rgb = fract(db.xyz*.1);//debug
		//color.rgb = ray_spd;//debug
		//color.rgb =  texture2D(colortex0, texcoord.xy).rgb;//debug
		//color.rgb = vec3(f);//debug
		
		}
	#endif
	 
	 	//color.rgb = fract(vec3(texcoord.xy,0.));//debug
	// color.rgb = normals.w > .5 ? vec3(1.,0.,0.): color.rgb ;
	 //color.rgb = vec3(fract(material*.1) );//debug
	
	
	


	//sky fog under water
	if( isEyeInWater == 11 && material > WATER_VISIBILITY )
	{
		color.rgb=
			fogColor.rgb
			*skyColor*float(eyeBrightnessSmooth.y)/240.
			
				
			;
	}
		
		

	#if DEBUG_SHADOWS == 1
		color.rgb=texture2D(shadowcolor0, texcoord).rgb ;
	#endif
	;//(material>0.01?1.:0.)*vec3(1-clamp(material/dhFarPlane,0.,1.));

	#if FIX_COLOR_SPACE == 1
		//color.rgb=pow(color.rgb,vec3(1./2.2));
	#endif
	
	/*
	color.r=color.r<.9?color.r:.9+(color.r-.9)*.1;
	color.g=color.g<.9?color.g:.9+(color.g-.9)*.1;
	color.b=color.b<.9?color.b:.9+(color.b-.9)*.1;
	//color=(color-.5)*1.1+.5;
	*/
	//color.rgb = vec3(debug3);
	
	//color.rgb = fract(60.0 * vec3(1-clamp(get_underwater_depth_at(texcoord)/dhFarPlane,0.,1.)) );//debug

	//color = texture2D(colortex0, texcoord);//debug
	

/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(color.rgb, 1.0); 
}