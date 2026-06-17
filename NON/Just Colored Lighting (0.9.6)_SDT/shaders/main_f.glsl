//#modified
// © Copyright 2023-2025 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 




#include "/settings.glsl"
#include "/noise.glsl"
#include "/stuff/noise/noise_texture.glsl"

#if USE_MACRO_TEXTURES >= 1
	 vec4 macro_texture;
	#if USE_MACRO_TEXTURES >= 1 &&   MOB_WORLD_SCALING == 1
		in float face_uv_ratio;
	#endif
#endif

#if AUTO_HAND_HELD_COLOR_DETECTION >= 1 
	layout (r32ui) uniform uimage2D cimage_held_light;

#endif
uniform bool firstPersonCamera;

uniform float nightVision;
#if NIGHT_VISION_MODE == 2
	uniform float temperature_smooth1;
	#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
	#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif
#endif
uniform float blindness;
uniform float darknessFactor;
//uniform float darknessLightFactor;

uniform int renderStage;

#if FLOODFILL_LIGHTING >= 1
	uniform int frameCounter;

	//buffer 3, where  write for later 
	uniform sampler3D cSampler3_colored_light;
	layout (rgba8) uniform image3D cimage3_colored_light;
	
	in vec4 block_centered_relative_pos;

	in vec3 foot_pos2;
	//in vec3 normals_face_world;
	//#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
	#if SOLAR_GI == 1
		uniform sampler3D cSampler4_gi;
	#endif
#endif

#if defined IS_IRIS && (defined DISTANT_HORIZONS || defined VOXY )  && DH_SHADOWS == 1 && DUAL_DISTORT == 1 || FLOODFILL_LIGHTING >= 1 || PIXEL_LOCKED_SHADOW_RES > 0 || USE_MACRO_TEXTURES > 0
	#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif

#endif
#if  USE_MACRO_TEXTURES > 0
    uniform mat4 gbufferModelView;
    uniform sampler2D Macro_texture;
#endif

#if (defined IS_IRIS && (defined DISTANT_HORIZONS || defined VOXY )  && DH_SHADOWS == 1 && DUAL_DISTORT == 1) || PIXEL_LOCKED_SHADOW_RES > 0 
		//per fragment shadow pos
	//#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
	uniform mat4 shadowModelView;
	uniform mat4 shadowProjection;
#endif

#if DH_FLYING_FIX_CIRCLE == 1
	uniform float frametime;
	uniform vec3 previousCameraPosition;
	uniform bool is_on_ground;
	uniform float speed_smooth1;
	
#endif


#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif

#if HAND_HELD_TORCH > 0 
	uniform int heldBlockLightValue;
	uniform int heldBlockLightValue2;
	uniform int heldItemId;
	uniform int heldItemId2;
	uniform vec3 eyePosition;
#endif

#define UPSCALE_TERRAIN 1 //[0 1]
#define UPSCALE_ENTITIES 1 //[0 1]
#define UPSCALE_HAND_HELD 0 //[0 1]
#define UPSCALE_PARTICLES 0 //[0 1]

#if DH_SHADOWS == 1
#endif

uniform float far;
uniform float near;

#if defined IS_IRIS
	#if defined DISTANT_HORIZONS
		uniform float dhNearPlane;
		uniform float dhFarPlane;
		float far1 = dhFarPlane*DH_FOG_END;
		#if THIS_IS_DISTANT_HORIZONS > 0 
			
			uniform sampler2D depthtex0;
			float linearize_depth_1(in float d)
			{
				// from gl_FragCoord.z to world measurements
				//float far4 = dhFarPlane*4.;
				return 2.0 * near  * far / (far + near - (2.0 * d - 1.0) * (far - near));

			}
			
		#endif
	#endif
    
		uniform vec3 playerBodyVector;
		uniform vec3 relativeEyePosition;
#endif

#if defined IS_IRIS && defined DISTANT_HORIZONS
#else
	#if defined VOXY
		float far1 =  16.*3000.*DH_FOG_END;
		float dhFarPlane = far1;
	#else
		float far1 = far;
	#endif
#endif

const vec4 colortex1ClearColor = vec4(48000.,0.,0.,0.);


uniform sampler2D lightmap;

	#define COLORED_SHADOWS 1 //[0 1] //0: Stained glass will cast ordinary shadows. 1: Stained glass will cast colored shadows.
	#define SHADOW_BRIGHTNESS 0.75 //Light levels are multiplied by this number when the surface is in shadows [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

	uniform sampler2D shadowcolor0;
	uniform sampler2D shadowtex0;
	uniform sampler2D shadowtex1;
	varying vec4 shadowPosv;
	vec4 shadowPos;
#if SHADOWS == 1
#endif
uniform sampler2D texture;
uniform sampler2D normals;
uniform sampler2D specular;


uniform int isEyeInWater;
uniform float fogStart;
uniform float fogEnd;
uniform vec3 fogColor;
uniform float rainStrength;
uniform float sunAngle;


varying vec2 texcoord;
#if IS_COLOR_WHEEL == 1
   // varying vec4 v_glcolor;
   // varying vec2 v_lmcoord;
#else
    varying vec4 glcolor;
    varying vec2 lmcoord;
#endif

#if SHOW_MOB_DAMAGE == 1 && IS_AN_ENTITY == 1
	uniform vec4 entityColor;
#endif

varying vec4 viewPos;

#if IS_THE_NETHER == 1 || SHADOWS == 7 || (defined IS_IRIS && ((THIS_IS_DISTANT_HORIZONS == 1 && IS_WATER_SHADER == 1 )|| DH_TEXTURE > 0)) || (IS_WATER_SHADER == 1 && FANCY_WATER > 0) || EXTEND_LAVA_PATTERN == 1 || defined VOXY
	varying vec3 world_pos;
#endif

	uniform float frameTimeCounter;
#if IS_THE_NETHER == 1 || EXTEND_LAVA_PATTERN == 1 || defined VOXY
	//uniform float frameTimeCounter;
#endif

//fix artifacts when colored shadows are enabled
const bool shadowcolor0Nearest = true;
const bool shadowtex0Nearest = true;
const bool shadowtex1Nearest = true;

//only using this include for shadowMapResolution,
//since that has to be declared in the fragment stage in order to do anything.
#include "/distort.glsl"

varying float ipbr_id;



    vec2 dfdx = dFdx(texcoord.st);
	vec2 dfdy = dFdy(texcoord.st);
	varying  vec4 vlocal_uv_components;//CTMPOMFIX
	varying  vec4 vlocal_uv;//CTMPOMFIX
	
	//#include "/timetravelbeards_Better_3D_Textures.glsl"
	#if POM == 1
	    #if CTMPOMFIX_VERSION == 4
			#include "/stuff/timetravelbeards_Better_3D_Textures_v26-2.glsl"
	    #else
			#include "/stuff/timetravelbeards_Better_3D_Textures_v25-8.glsl"
		#endif
	#else
		#include "/timetravelbeards_Better_3D_Textures.glsl"
	#endif

#if PBR > 0 || HAND_HELD_TORCH > 0  || FLOODFILL_LIGHTING >= 1
	varying vec3 normals_face;
#endif
#if PBR > 0 || (PIXEL_LOCKED_SHADOW_RES > 0 && SHADOWS > 0)
	uniform vec3 shadowLightPosition;
#endif
#if POM > 0 ||  PBR > 0
	varying vec4 tangent;
#endif
#if PBR > 0

	uniform vec3 upPosition;
	#if PBR >=2
		uniform float wetness;
		#if SSS >= 1  && PBR >= 2
           const float	iShadowDepth = 1./256.;
		#endif
  	#endif
#endif
#if PBR >=2 || SKY_COLOR_ALTERNATE >= 1
		uniform vec3 skyColor;
#endif

#if defined IS_IRIS && defined DISTANT_HORIZONS && DH_SHADOWS == 0
	
#endif
#if defined IS_IRIS && defined DISTANT_HORIZONS && DH_SHADOWS > 0 && LONG_SUNSET_SHADOWS == 1
	uniform mat4 shadowProjection;
	float Shadow_map_depth = -2.0 / shadowProjection[2][2];
	//float Shadow_map_depth =256.0;
#else
	float Shadow_map_depth =256.0;
#endif

#include "/check_shadow_depth.glsl"


	
	
#if defined IS_IRIS && defined DISTANT_HORIZONS
float linearize_depth_dh(in float d)
{
    // from gl_FragCoord.z to world measurements
    return 2.0 * dhNearPlane  * dhFarPlane / (dhFarPlane + dhNearPlane - (2.0 * d - 1.0) * (dhFarPlane - dhNearPlane));

}
	float linearize_depth(in float d)
		{
			// from gl_FragCoord.z to world measurements

			return 2.0 * near  * far / (far + near - (2.0 * d - 1.0) * (far - near));

		}
#endif
		
#if (CAVE_LIGHT_LEAK_FIX == 1 || CAVE_LIGHT_LEAK_FIX_SKY == 1) && IS_THE_NETHER != 1 && IS_THE_END != 1
	
	uniform ivec2 eyeBrightnessSmooth;
	uniform ivec2 eyeBrightness;
	//float cave_light_leak_fix = float(max(eyeBrightnessSmooth.y,eyeBrightness.y))/240.;
	//color*=cave_light_leak_fix;
	
#endif

#ifdef IRIS_FEATURE_FADE_VARIABLE  
    #if IS_TERRAIN == 1 && CHUNK_FADE == 1
       // in float mc_chunkFade;
        in float chunk_fade;
    #endif
#endif


#if USE_MACRO_TEXTURES >= 1
	vec3 East = normalize( mat3(gbufferModelView) *(vec3(0.,0.,1.)-gbufferModelViewInverse[3].xyz) ).xyz ;//-gbufferModelViewInverse[3].xyz ;
	//normalize( gbufferModelView*vec4(0.,0.,1.,1.) ).xyz ;
	
	vec3 North =  
	normalize( gbufferModelView*vec4(1.,0.,0.,1.) ).xyz ;// normalize( 
	//normalize(mat3(gbufferModelView) *(vec3(1.,0.,0)-gbufferModelViewInverse[3].xyz) ).xyz;
#endif

	
#define FSHSDT
#include "/lib/sdt/SDTmain.glsl"
void main() {

    //Color Wheel (1 of 2)

    #if IS_COLOR_WHEEL == 1
        vec4 glcolor = vec4(1.);//bypass the logic everywhere
    #endif



	#if DEBUG_MODE > 0
		vec3 debugdata3;;
	#endif
	
	#if SOLAR_GI == 1
		vec4 gi[6];// = imageLoad(cimage4_gi, voxel_pos +neighbor);
	#endif	
	
	#if DH_FLYING_FIX_CIRCLE == 1 
		float player_speed =  
		#if defined IS_IRIS
			#if DH_FLYING_FIX_CIRCLE_ONLY_IN_AIR == 1
				is_on_ground? 0.: 
			#endif
		#endif
		
		  speed_smooth1;
				
		float dh_discard_circle = .9*clamp(1.-(player_speed-3.)/DH_FLYING_FIX_CIRCLE_SPEED,0.,1.);
		float dh_discard_circle_small = max(0.,dh_discard_circle-.1);
	#else
		float dh_discard_circle = .9;
		float dh_discard_circle_small = .8;
	#endif
	

//moved for colorwheel - 2026-5
/*
	#if CAVE_LIGHT_LEAK_FIX == 1  && IS_THE_END != 1  && IS_THE_NETHER != 1 
		//uniform ivec2 eyeBrightnessSmooth;
		//uniform ivec2 eyeBrightness;
		float cave_light_leak_fix = mix(float(max(eyeBrightnessSmooth.y,eyeBrightness.y))/240.,1.,clamp(CAVE_DARKNESS_DEPTH +cameraPosition.y-SEA_LEVEL,0.,10.)*.1);
	#endif
	#if CAVE_LIGHT_LEAK_FIX == 2  && IS_THE_END != 1  && IS_THE_NETHER != 1 
		//uniform ivec2 eyeBrightnessSmooth;
		//uniform ivec2 eyeBrightness;
		float cave_light_leak_fix = pow(lmcoord.y+1./32 ,CAVE_LIGHT_LEAK_2_EXP);
	#endif
	#if CAVE_LIGHT_LEAK_FIX_SKY == 1 && IS_THE_NETHER != 1 && IS_THE_END != 1
		 float cave_light_leak_fix_sky = mix(float(max(eyeBrightnessSmooth.y,eyeBrightness.y))/240.,1.,clamp(CAVE_DARKNESS_DEPTH +cameraPosition.y-SEA_LEVEL,0.,10.)*.1);
	#endif
*/




	float dist = distance(vec3(0.),viewPos.xyz);
	
	#if defined IS_IRIS && defined DISTANT_HORIZONS
		#if THIS_IS_DISTANT_HORIZONS > 0 
			#if IS_WATER_SHADER == 1
				//vec2 screencoord = ((gl_FragCoord.xy))*texelSize;
				float od = texelFetch(depthtex0,ivec2(gl_FragCoord.xy),0).r;
				float old_d = linearize_depth_1(od);

				float new_d = dist;//linearize_depth_dh((gl_FragCoord.z));
				#if SMOOTH_DH_FADE_IN >= 2
					//color.a *= 1.-clamp((dist-far*(1.-DH_FADE))/(far*DH_FADE),0.,1.);
					if( dist<=far*dh_discard_circle)
					{
						discard;
					};
				#endif
					//if (old_d < new_d )//|| new_d < far*.9)
					//if(abs(relative_position_w_pom.z) < abs(texture(colortex15, screencoord).z))
					{
						if (od < 1. )
						{
							discard;
							return;
						}
					}
				
			#else
				if(dist < far*dh_discard_circle_small)
				{
					discard;
					return;
				}
			#endif
			
		#else
			#if SMOOTH_DH_FADE_IN >= 2
				if( dist>far*.9)
				{
					discard;
				};
			#endif
		#endif
	#endif

	
	
	
	#if POM == 1
		vec3 tangent2 = normalize(cross(tangent.rgb,normals_face.xyz)*tangent.w);
		mat3 tbn_matrix = mat3(tangent.xyz, tangent2.xyz, normals_face.xyz);
	#endif
	
	
	
	#if defined IS_IRIS && defined DISTANT_HORIZONS && THIS_IS_DISTANT_HORIZONS == 1
		vec4 color= glcolor;

		#if DH_TEXTURE > 0
			color.rgb+=-.5*DH_TEXTURE_STR+DH_TEXTURE_STR
			#if DH_FANCY_NOISE > 0 
				*fractal_noise_3d(world_pos.xyz,DH_NOISE_FRACTAL_STEPS);
			#else
				*hashfrom3(floor((world_pos.xyz)*4.)/4.);
			#endif
		#endif
		
			#if PBR > 0
				vec4 normals_pixel = vec4(0.5,0.5,1.0,1.0);
			#endif
			#if PBR >= 2
				vec4 specular_pixel = vec4(0.0,0.0,0.0,0.0);
			#endif
			
					
	#else
		
		#if USE_MACRO_TEXTURES >= 1
			#include "/stuff/macro pt1.glsl"
		#endif
						
		#if TEXTURE_FILTERING_CPF > 0 && FILTER_HERE == 1 || POM == 1
		
		
			#if POM == 1
				vec4 color;//= atlas_uv_to_bilinear_data( texcoord,dist )*glcolor;
				#if PBR > 0
					vec4 normals_pixel;// = atlas_uv_to_bilinear_data_normal( texcoord,dist );
				#endif
				//#if PBR >= 2
					vec4 specular_pixel;// = atlas_uv_to_bilinear_data_specular( texcoord,dist );
				//#endif
				vec3 view_vector = normalize(viewPos.xyz.xyz*tbn_matrix);
				vec2 pom_target_coord=texcoord;
				float noise = 0.;//blue_noise();//0.;
				
				Ctmpomfix_alt_pom_as_insert_for_texture_data( dist, vlocal_uv, view_vector, pom_target_coord, noise, color, normals_pixel, 		specular_pixel);
				
                
				//color.rgb = blue_noise4().rgb;//debug
				
				
				#if IS_AN_ENTITY == 1 || IS_PARTICLE == 1
                    
					color*=glcolor;// they fade with alpha, unlike terrain since seperateAo is On

				#else
					color.rgb*=glcolor.rgb; // ao is in alpha for terrain

				#endif
			#else

			
				//vec4 color= atlas_uv_to_bilinear_data( texcoord,dist )*glcolor;
				#if IS_AN_ENTITY == 1 || IS_PARTICLE == 1
					//color *= glcolor ; // they fade with alpha, unlike terrain since seperateAo is On
					vec4 color= atlas_uv_to_bilinear_data( texcoord,dist ) * glcolor;
				#else
					//color.rgb*=glcolor.rgb; //*glcolor.a; // ao is in alpha for terrain
					vec4 color= atlas_uv_to_bilinear_data( texcoord,dist ) * vec4(glcolor.rgb,1.);
				#endif
				
				#if PBR > 0
					vec4 normals_pixel = atlas_uv_to_bilinear_data_normal( texcoord,dist );
				#endif
				#if PBR >= 2
					vec4 specular_pixel = atlas_uv_to_bilinear_data_specular( texcoord,dist );
				#endif
			#endif
			
			
		#else
			
			#if IS_AN_ENTITY == 1 || IS_PARTICLE == 1
				//color *= glcolor ; // they fade with alpha, unlike terrain since seperateAo is On
				vec4 color = texture(texture, texcoord);
    ApplyTextureSynthesis(color);
    color = color * glcolor;
			#else
				//color.rgb*=glcolor.rgb; //*glcolor.a; // ao is in alpha for terrain
				vec4 color = texture(texture, texcoord);
    ApplyTextureSynthesis(color);
    color = color * vec4(glcolor.rgb,1.);
			#endif
			#if PBR > 0
				vec4 normals_pixel = texture(normals, texcoord);
			#endif	
			#if PBR >= 2
				vec4 specular_pixel = texture(specular, texcoord);
			#endif
		#endif
		
	
        #if USE_MACRO_TEXTURES >= 1
		   // #include "/stuff/macro.glsl"

		#endif
		
		#include "/stuff/generated_normals.glsl"
				
		#if USE_MACRO_TEXTURES >= 1
			#include "/stuff/macro pt2.glsl"
		#endif
			
		#if defined IS_IRIS && defined DISTANT_HORIZONS
			#if THIS_IS_DISTANT_HORIZONS != 1
				#if SMOOTH_DH_FADE_IN >= 1
					#if TEXTURE_SIZE_AVAILABLE == 1
						color.rgb=mix(color.rgb,
					textureLod(texture, texcoord.xy,log2(float(textureSize(texture, 0).x))).rgb* glcolor.rgb// *glcolor.a
					#endif
						#if DH_TEXTURE > 0
						+-.5*DH_TEXTURE_STR+DH_TEXTURE_STR
						#if DH_FANCY_NOISE > 0 
							*fractal_noise_3d(world_pos.xyz,DH_NOISE_FRACTAL_STEPS)
						#else
							*hashfrom3(floor((world_pos.xyz)*4.)/4.)
						#endif
					#endif
					,
					clamp((dist-far*(1.-DH_FADE))/(far*DH_FADE),0.,1.));
					
				#endif	
			#endif
		#endif
		//color.rgb*=1.-clamp((dist-far*.8)/(far*.1),0.,1.);
	#endif
	
	




 //Color Wheel (2 of 2)

    #if IS_COLOR_WHEEL == 1
       // vec4 glcolor = vec4(1.);//bypass the logic everywhere
        vec2 lmcoord;
        float ao_cw;
        vec4 overlayColor_cw;
        vec4 color_cw;
         
       
		//color.rgb=vec3(1.);//debug
		 //   color - texture(texture,texcoord);
		 #if PBR == 0
			clrwl_computeFragment(color, color, lmcoord, ao_cw, overlayColor_cw);
		 #else
			clrwl_computeFragment(color, color_cw, lmcoord, ao_cw, overlayColor_cw);//color_cw is unused here, but it needs an output
		 #endif

         color.rgb = mix(color.rgb, overlayColor_cw.rgb, overlayColor_cw.a);   
		glcolor.a=ao_cw;//output ao
        
       
		//  vec4 cw_color = color;
        
        
    #endif



//moved for colorwheel - 2026-5

	#if CAVE_LIGHT_LEAK_FIX == 1  && IS_THE_END != 1  && IS_THE_NETHER != 1 
		//uniform ivec2 eyeBrightnessSmooth;
		//uniform ivec2 eyeBrightness;
		float cave_light_leak_fix = mix(float(max(eyeBrightnessSmooth.y,eyeBrightness.y))/240.,1.,clamp(CAVE_DARKNESS_DEPTH +cameraPosition.y-SEA_LEVEL,0.,10.)*.1);
	#endif
	#if CAVE_LIGHT_LEAK_FIX == 2  && IS_THE_END != 1  && IS_THE_NETHER != 1 
		//uniform ivec2 eyeBrightnessSmooth;
		//uniform ivec2 eyeBrightness;
		float cave_light_leak_fix = pow(lmcoord.y+1./32 ,CAVE_LIGHT_LEAK_2_EXP);
	#endif
	#if CAVE_LIGHT_LEAK_FIX_SKY == 1 && IS_THE_NETHER != 1 && IS_THE_END != 1
		 float cave_light_leak_fix_sky = mix(float(max(eyeBrightnessSmooth.y,eyeBrightness.y))/240.,1.,clamp(CAVE_DARKNESS_DEPTH +cameraPosition.y-SEA_LEVEL,0.,10.)*.1);
	#endif

	




	//lava
	vec3 lava_noise;
	#if EXTEND_LAVA_PATTERN == 1 || defined VOXY
		#if FLICKERING_TORCHES >= 2 || FLICKERING_TORCHES == 3
			if(abs(ipbr_id - 10032.0)<.5)
			{
						float flow_gredient =.5;
						float flicker = 
						 
							//lava flicker
							#if LAVA_NOISE_ORGANIC == 1
								(1.-fractal_noise_3d_lava(frameTimeCounter*vec3(.0,.5,.0)+world_pos*.2)-.5)*2.
							#else
								#if FLICKERING_TORCHES >= 2
										//TORCH FLICKER
										(.7+.2*sin((frameTimeCounter*1.+world_pos.x)*flow_gredient) +.2*sin((frameTimeCounter*2.+world_pos.z)*flow_gredient)+.1*sin((frameTimeCounter*5.+world_pos.y)*flow_gredient))					
								#else
										1.
								#endif
							#endif
						
						
						 ;
						 
						lava_noise =
							clamp(
							mix(vec3(1.,0.,0.),
							vec3(1.,1.,0.),
							
							.3+.5* flicker
							
							) *.25 +.5*flicker
							+vec3(1.,0.,-1.)*.75
							,0.,2.)
							;
							#if defined VOXY
								color.rgb=mix(color.rgb,lava_noise,clamp((dist/far),0.,.5));
							#else
								color.rgb=mix(color.rgb,
								lava_noise,
								clamp((dist-VOXEL_RADIUS*.8)/(VOXEL_RADIUS*.2),0.,1.) 
								);
							#endif
							
			}else{
				lava_noise=vec3(0.);
			}
		#endif
	#endif
	//>lava
	

	
	
	#if IS_AN_ENTITY == 1 && UN_SHADED_NAMETAGS == 1
		vec3 albedo = color.rgb;
	#endif	
	
	
	
	//if (color.a<1./255.) discard; //shouldnn't be needed
	float sss = 0.;

    #if IS_A_GLOWING_VANILLA_GBUFFER == 1
         float vanilla_emmisive = 1.;

    #else
         float vanilla_emmisive = abs(ipbr_id-20010.)<=.5? 1.: lmcoord.x>VANILLA_EMMISIVE_THRSHHOLD &&
	lmcoord.y>VANILLA_EMMISIVE_THRSHHOLD?1.:0.;
    #endif


   

	#if PBR >= 2
		//sss
		 sss = specular_pixel.b;
		sss=sss<64.5/255.?0.:(sss-64.)/(255.-64.);
		//emmission
		
		#if FLOODFILL_LIGHTING >= 1
			specular_pixel.a=max(vanilla_emmisive, 
                max( (specular_pixel.a >=254.5/255.?0.:specular_pixel.a),
			     (specular_pixel==vec4(0.) ? block_centered_relative_pos.w : 0.  ) ) );
			#if PER_BLOCK_EMMISSIVE == 1
				specular_pixel.a=max(specular_pixel.a,  block_centered_relative_pos.w);
				
			#endif
		#else
			specular_pixel.a=specular_pixel.a >=254.5/255.?0.:specular_pixel.a;
		#endif
      
    #else
        vec4 specular_pixel;
        specular_pixel.a = vanilla_emmisive;
		#if IS_TERRAIN == 1 
			specular_pixel.a=max(specular_pixel.a,  block_centered_relative_pos.w);
		#endif
       
	#endif


	#if SSS >= 1 && SHADOWS > 0
		//ipbr sss
	
		#if PBR < 2
			#if SSS >= 2
					sss= max(.25,(abs(ipbr_id-10001.)<=.5? 1. :sss));
			#else
					sss= (abs(ipbr_id-10001.)<=.5 || abs(ipbr_id-10080.)<=.5 ? 1. :sss);
			#endif
	
		#else
			#if SSS >= 2
					sss= max(sss,max(.25,(abs(ipbr_id-10001.)<=.5? 1. :0.)));
			#else
					sss= max(sss,(abs(ipbr_id-10001.)<=.5 || abs(ipbr_id-10080.)<=.5  ? 1. :0.));
			#endif
	
		#endif

	#endif
	float texture_sss = sss;
	#if SHADOWS > 0 && DH_SHADOWS == 0
		float actual_shadow_distance = min(far,shadowDistance);
		float shadow_edge_fade = clamp((dist-actual_shadow_distance*(1.-SHADOW_FADE))/(actual_shadow_distance*SHADOW_FADE),0.,1.);
		sss *= 1.-shadow_edge_fade;
	#endif
	#if BACK_LIT_GRASS > 0
			//when EXCLUDE_FOLIAGE is enabled, act as if foliage is always facing towards the sun.
			//in other words, don't darken the back side of it unless something else is casting a shadow on it.
			if (abs(ipbr_id - 10000.0)<.5) sss = max(sss,float(BACK_LIT_GRASS)*.1);
	#endif
	#if SHADOWS > 0 
		float sss_lighting = sss;
	#else
		float sss_lighting = 0.;
	#endif



	#if PIXEL_LOCKED_SHADOW_RES > -10 && SHADOWS > 0
		vec4 shadow_pos =vec4( vec4(gbufferModelViewInverse*vec4(viewPos.xyz,1.)).xyz ,1.);
		//shadow_pos.xyz-=gbufferModelViewInverse[3].xyz;
		vec3 shadow_n=vec4(gbufferModelViewInverse*vec4(normals_face.xyz,1.)).xyz -gbufferModelViewInverse[3].xyz ;
		float dot_face_sun = dot(normals_face.xyz,normalize(shadowLightPosition));

		float sm_bias = (1.-sss)*(1./PIXEL_LOCKED_SHADOW_RES +SHADOW_BIAS_PL*(1.-(abs(dot_face_sun))));
		
		shadow_pos.xyz+=shadow_n*sm_bias;
		
		shadow_pos.xyz= floor((shadow_pos.xyz+fract(cameraPosition))*PIXEL_LOCKED_SHADOW_RES)/PIXEL_LOCKED_SHADOW_RES-fract(cameraPosition);
		
		

		
		shadow_pos.xyz=(shadowModelView*vec4(shadow_pos.xyz,1.0)).xyz;
		shadow_pos=(shadowProjection*vec4(shadow_pos.xyz,1.0));
		
		float bias_factor = computeBias(shadow_pos.xyz);
		
		shadow_pos.xyz=distort(shadow_pos.xyz);
		shadow_pos.xyz/=shadow_pos.w;
		shadow_pos.xyz=.5+.5*shadow_pos.xyz;
		
		shadow_pos.z-=bias_factor;
		
		shadowPos=shadow_pos;
		shadowPos.w = shadowPosv.w;
	#else
		shadowPos=shadowPosv;
	#endif

	
	#if defined IS_IRIS && defined DISTANT_HORIZONS && DH_SHADOWS == 1 && DUAL_DISTORT == 1
			//per fragment shadow pos
			vec4 playerPos = gbufferModelViewInverse * viewPos;
			shadowPos = shadowProjection * (shadowModelView * playerPos); //convert to shadow ndc space.
			float bias = computeBias(shadowPos.xyz);
			shadowPos.xyz = distort(shadowPos.xyz); //apply shadow distortion
			shadowPos.xyz = shadowPos.xyz * 0.5 + 0.5; //convert from -1 ~ +1 to 0 ~ 1
			shadowPos.w=shadowPosv.w;
	#endif
	
	float face_shading = clamp(shadowPos.w,0.,1.);
	
	
	
	float torch_fade = clamp(((dist/min(VOXEL_RADIUS,far))-.8)*5.,0.,1.);
	
	float main_lighting = (sunAngle <.5 ? SUN_BRIGHTNESS : MOON_BRIGHTNESS)
	#if REBALANCE_LIGHTING_FOR_GI >= 1
		#if SOLAR_GI >= 1
			*(1.+torch_fade*.5)
			#if REBALANCE_LIGHTING_FOR_GI >= 2
				*.66
			#endif
		#endif
	#endif
	;
	
	
	
	vec2 lm = lmcoord;
	
			//Lighting Primary
						lm.x=pow(lm.x,TORCH_FALLOFF);
						
		

						
						
						
						
						
						float lmy_og=lm.y;
					
					
						
						lm.y=
						#if BRIGHTER_UNDERWATER == 1
							isEyeInWater == 0?
						#endif
						pow(lm.y,SKY_LIGHT_FALLOFF)*SKY_LIGHT_BRIGHTNESS
						#if BRIGHTER_UNDERWATER == 1
							:.8
						#endif
						;
						
						
						
						vec3 sky_color = 
							#if SKY_COLOR_ALTERNATE == 0
								#if EXTRA_DARK_NIGHT > 0
									mix(
									texture(lightmap, vec2(1./32.,lm.y)).rgb,
									vec3(0.),
									clamp((1.-abs(sunAngle-.75)*4.)*10.,0.,1.)*float(EXTRA_DARK_NIGHT)*.1
									)
								#else
									texture(lightmap, vec2(1./32.,lm.y)).rgb
								#endif	
							#endif
							#if SKY_COLOR_ALTERNATE == 1
								#if EXTRA_DARK_NIGHT > 0
									mix(
									skyColor,
									vec3(0.),
									clamp((1.-abs(sunAngle-.75)*4.)*10.,0.,1.)*float(EXTRA_DARK_NIGHT)*.1
									)
								#else
									skyColor
								#endif
							#endif
							#if SKY_COLOR_ALTERNATE == 2
								#if EXTRA_DARK_NIGHT > 0
									mix(
									mix(skyColor, fogColor,
										FOG_IN_SKYLIGHT_STR * (1.-clamp((foot_pos2.y-63.+cameraPosition.y)/200.,.3,1.) )
									),
									vec3(0.),
									clamp((1.-abs(sunAngle-.75)*4.)*10.,0.,1.)*float(EXTRA_DARK_NIGHT)*.1
									)
								#else
									mix(fogColor,skyColor,clamp((world_pos.y-SEA_LEVEL)/SKY_HEIGHT,.3,.9) )
								#endif
							#endif
						
						
						;
						
						
						
					#if SUNSET == 0
						vec3 sun_color =
						
						#if CUSTOM_SUN_COLOR == 0
							texture(lightmap, vec2(1./32.,lmy_og)).rgb //sky_color at lmy_og
						#endif
						#if CUSTOM_SUN_COLOR == 1
							(sunAngle <.5 ?
							vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)
							:vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B)
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
							 vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)
							 :vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B)
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
								 vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)
								 :vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B)
							 #endif
						*clamp((1.-abs(sunAngle-
						  (sunAngle<.5? .25 : .75)
						  
						  )*4.)*10.,0.,1.);
				
	 
					#endif
				
					
					#if FIX_COLOR_SPACE == 1
						sky_color.rgb=pow(sky_color.rgb,vec3(2.2));
						sun_color.rgb=pow(sun_color.rgb,vec3(2.2));
					#endif
						
					#if FOG_AFFECTS_LIGHT == 1
						if(isEyeInWater==0) sun_color.rgb*=mix(vec3(1.), fogColor,
						FOG_AFFECTS_LIGHT_STR*(1.-clamp( (cameraPosition.y-SEA_LEVEL)/SKY_HEIGHT,0.,1.) ));
					#endif
						
						
							
	#if SHADOWS == 0
		sun_color*=lm.y;
	#endif	
	#if CAVE_LIGHT_LEAK_FIX >= 1  && IS_THE_END != 1  && IS_THE_NETHER != 1
		sun_color*=	cave_light_leak_fix;
	#endif
						
						
						
	vec4 shadowLightColor=vec4(1.0);
	
	
	#if PBR > 0					
		float ao_allowed_sky_light =  pow( mix(1.,glcolor.a,VANILLA_AO_SKY) ,VANILLA_AO_EXPONENT);
		float ao_allowed_light = pow( mix(1.,glcolor.a,VANILLA_AO_TORCH) ,VANILLA_AO_EXPONENT);
		
		ao_allowed_sky_light*=mix(1.,normals_pixel.z,AMBIENT_OCCLUSSION_TEXTURES);
		ao_allowed_light*=mix(1.,normals_pixel.z, AMBIENT_OCCLUSSION_TEXTURES *
		(1.-dot(normals_pixel.xyz,normals_face.xyz) )
		);
		
	#else
        #if IS_COLOR_WHEEL == 1
			 #if PBR == 0
				float ao_allowed_sky_light = 1.;// pow( mix(1.,ao_cw,VANILLA_AO_SKY) ,VANILLA_AO_EXPONENT);
				float ao_allowed_light =  1.;//pow( mix(1.,ao_cw,VANILLA_AO_SKY) ,VANILLA_AO_EXPONENT);
			 #else
				float ao_allowed_sky_light =  pow( mix(1.,ao_cw,VANILLA_AO_SKY) ,VANILLA_AO_EXPONENT);
				float ao_allowed_light =  pow( mix(1.,ao_cw,VANILLA_AO_SKY) ,VANILLA_AO_EXPONENT);
			 #endif
		    
        #else
		    float ao_allowed_sky_light =  pow( mix(1.,glcolor.a,VANILLA_AO_SKY) ,VANILLA_AO_EXPONENT);
		    float ao_allowed_light = pow( mix(1.,glcolor.a,VANILLA_AO_TORCH) ,VANILLA_AO_EXPONENT);
        #endif


	#endif
	#if defined IS_IRIS && (defined DISTANT_HORIZONS || defined VOXY )
		//fade out ao into dh
		{
			#if defined VOXY && DIRECTIONAL_LIGHTING == 0
				float ao_fade = 0;//clamp( ( (dist/far)-.8)*5.,0.,.5);
			#else
				float ao_fade = clamp( ( (dist/far)-.8)*5.,0.,1.);
			#endif
			//#if PBR == 0 && DIRECTIONAL_LIGHTING == 0
				//don't fade ao
			//#else
				ao_allowed_light = mix(ao_allowed_light,1.,ao_fade);
			//#endif
			
			ao_allowed_sky_light = mix(ao_allowed_sky_light,1.,ao_fade);
			
		}
	#endif
	
	#if PBR > 0
		
	
				
		//float ao_allowed_light = mix(1.,normals_pixel.z,AMBIENT_OCCLUSSION_TEXTURES)*pow(glcolor.a,VANILLA_AO_EXPONENT);
		normals_pixel.xy=normals_pixel.xy*2.-1.;
		normals_pixel.z = sqrt(1.0-dot(normals_pixel.xy, normals_pixel.xy)); //Reconstruct Z
		
		normals_pixel.xyz =normalize(normals_pixel.xyz );//fsster no norm?
	
	

		vec3 sky_shine = vec3(pow(lmy_og,10.));
		vec3 n_sky_dir = normalize(upPosition);
		
		#if PBR >= 2 
		
			#if (IS_WATER_SHADER == 1 && FANCY_WATER > 0) 
				if(abs(ipbr_id-10020.)<=.5)
				{
					float w = fractal_noise_3d(world_pos.xyz,4);
					float w2 = fractal_noise_3d(world_pos.xyz+vec3(.1,0.,0.),4);
					float w3 = fractal_noise_3d(world_pos.xyz+vec3(0.,0.1,0.),4);
					
					float g=w-w3;
					float r =w-w2;
					float b = 1. -(abs(r)+abs(g));
					 
					normals_pixel = vec4(r,g,1.,1.);
					//normals_pixel.xy = normals_pixel.xy;
					//normals_pixel.z = sqrt(1.0-dot(normals_pixel.xy, normals_pixel.xy)); //Reconstruct Z
					
					//color.rgb = vec3(normals_pixel.xyz);//debug
					
					specular_pixel = vec4(.8,0.9,1.,0.);
				}
			#endif
		
		
		
			float metalness = specular_pixel.g>=229.5/255.?1.:0.;
			
			
			
			float sky_dot_face = dot(n_sky_dir,normals_face.xyz);
				//porosity
				float actual_wetness=clamp(sky_shine.r,0.,1.)
				*max(0.,sky_dot_face)
				*wetness;
				//wet porosity darkening
				float porosity = specular_pixel.b;
				porosity=porosity>=64.5/255.?0:porosity/64.;



				actual_wetness*=1.-.25*porosity;
				specular_pixel.g=mix(specular_pixel.g,1.,
				min(1.,actual_wetness*1.));
				specular_pixel.r =mix(specular_pixel.r,1., min(1.,actual_wetness*2.));
				float puddles = sky_dot_face*PUDDLE_DEPTH;
					normals_pixel.xy=mix(normals_pixel.xy,vec2(0.),min(1.,actual_wetness*1.5*puddles));
				normals_pixel.z = mix(normals_pixel.z,1.,min(1.,actual_wetness*1.5*puddles));
				normals_pixel.xyz= normalize(normals_pixel.xyz);
			#endif
		
        



		#if POM == 0	
			vec3 tangent2 = normalize(cross(tangent.rgb,normals_face.xyz)*tangent.w);
			mat3 tbn_matrix = mat3(tangent.xyz, tangent2.xyz, normals_face.xyz);
		#endif

		normals_pixel.xyz = normalize(tbn_matrix * normals_pixel.xyz); //Rotate by TBN matrix //faster no norm?
			
		float sun_lighting = max(sss_lighting,clamp (dot(normalize(shadowLightPosition), normals_pixel.xyz) ,0.,1.)) ;
		
		float applied_NON_DIRECTIONAL_AMBIENT_SKY_LIGHT = NON_DIRECTIONAL_AMBIENT_SKY_LIGHT+(1.-NON_DIRECTIONAL_AMBIENT_SKY_LIGHT)*sss;
		
		float sky_lighting = clamp((dot(n_sky_dir,normals_pixel.xyz)+1.)*.5, applied_NON_DIRECTIONAL_AMBIENT_SKY_LIGHT ,1.);//fix?
		
		#if BORDERS >= 2 
			float sun_lighting_back = max(sss_lighting,clamp (dot(normalize(shadowLightPosition), 
			normalize( mix(-normals_pixel.xyz,vec3(0.,0.,-1.),0.5) )
			) ,0.,1.)) ;
			float sky_lighting_back = clamp((dot(n_sky_dir,
			normalize( mix(-normals_pixel.xyz,vec3(0.,0.,-1.),0.5) )
			)+1.)*.5, applied_NON_DIRECTIONAL_AMBIENT_SKY_LIGHT ,1.);//fix?
		#endif
		
	#else
	
		#if SSS >= 1  && SHADOWS > 0
			float sun_lighting=  max(sss_lighting,face_shading); //sunlighting wo normals
		#else
            #if IS_COLOR_WHEEL == 1
               
				#if PBR == 0
					 float sun_lighting= 1.;// face_shading; //sunlighting wo normals
				 #else
					 float sun_lighting=  face_shading; //sunlighting wo normals
				 #endif
            #else
	            float sun_lighting=  face_shading; //sunlighting wo normals
            #endif
		
		#endif
		
	#endif
	
	
	
	#if PBR >= 2
		vec3 view_dir = normalize(viewPos.xyz);
		vec3 reflected_angle = reflect(view_dir,normals_pixel.xyz);
		#if COLORED_LIGHT_SPEC == 1 
			vec4 light_color_spec;
		#endif
	#endif
	
	
	
	#if HAND_HELD_TORCH > 0 
		#if PBR == 0 
			vec3 normals_pixel = normals_face.xyz;	
		#endif
		
		#if AUTO_HAND_HELD_COLOR_DETECTION > 0
			int heldlightvalue_applied = heldBlockLightValue>0 || heldBlockLightValue2+heldBlockLightValue==0?15:0;
			int heldlightvalue_applied2 = heldBlockLightValue2>0? 15:0;
		#else
			int heldlightvalue_applied = heldBlockLightValue;
			int heldlightvalue_applied2 = heldBlockLightValue2;
			
		#endif
		
		float torch_hand_light = 
				heldlightvalue_applied > 0 || heldlightvalue_applied2 > 0 ?
		clamp( 1.-distance( eyePosition,foot_pos2.xyz+cameraPosition )/ HAND_HELD_TORCH_RANGE ,0.,1.)
		 
		#if TORCH_LIGHT_3D == 1
			*
			(
			(heldlightvalue_applied>0?1.:0.) * clamp(dot(normals_pixel.xyz,normalize(vec3(0.5,-.5,1.))),0.0,1.) 
			+
			(heldlightvalue_applied2>0?1.:0.) * clamp(dot(normals_pixel.xyz,normalize(vec3(-0.5,-.5,1.))),0.0,1.)
			)
		#endif
		#if TORCH_LIGHT_3D == 2
			*
			min(
			(heldlightvalue_applied>0?1.:0.) * clamp((dot(normals_pixel.xyz,normalize(-viewPos.xyz-vec3(-TORCH_HORIZONTAL_OFFSET,-TORCH_V_OFFSET,TORCH_Z_OFFSET)))
			+texture_sss)/(1.+texture_sss),0.0,1.) 
			+
			(heldlightvalue_applied2>0?1.:0.) * clamp((dot(normals_pixel.xyz,normalize(-viewPos.xyz-vec3(TORCH_HORIZONTAL_OFFSET,-TORCH_V_OFFSET,TORCH_Z_OFFSET)))
			+ texture_sss)/(1.+texture_sss),.0,1.)
			
			+ texture_sss*.3
			,1.)
		#endif
	
			: 0.0
	
		;
		
		#if HELD_LIGHT_PBR == 1 && PBR >= 2
			//float glare = pow( clamp(dot(reflected_angle,-view_dir.xyz),0.,1.), 1.+1.*specular_pixel.r);
			float hands_offset = firstPersonCamera ? 1.: 0.;
			float glare2 = pow( clamp(dot(reflected_angle,-normalize(viewPos.xyz)+vec3(hands_offset,0.,0.)),0.,1.), 1.+1.*specular_pixel.r);
			float glare3 = pow( clamp(dot(reflected_angle,-normalize(viewPos.xyz)-vec3(hands_offset,0.,0.)),0.,1.), 1.+1.*specular_pixel.r);
			torch_hand_light*=(1.-specular_pixel.g);
			vec3  flashlight_specular = vec3(
				//glare*
				HELD_TORCH_BRIGHTNESS* specular_pixel.g*specular_pixel.r*
			(
				(heldlightvalue_applied>0?glare2:0.) 
				+
				(heldlightvalue_applied2>0?glare3:0.) 
			)
				);
				
			color.a+=color.a<.5/255?0.:(1.-color.a)*(flashlight_specular.r+flashlight_specular.g+flashlight_specular.b)*.33;
				
		#endif
		
		
		
		//float torch_hand_light = 0.;
		#if FLOODFILL_LIGHTING == 0
			//lm.x=min(1.,lm.x+pow(torch_hand_light,TORCH_FALLOFF));
		#endif
	#endif
	
		
		#if CUSTOM_TORCH_COLOR == 0
			vec3 torch_color = 
				vec3(1.,0.9,0.8)*TORCH_BRIGHTNESS;
				//texture(lightmap, vec2(lm.x,0.1)).rgb;//
		#endif
		#if CUSTOM_TORCH_COLOR == 1
			vec3 torch_color = 
				vec3(TORCH_HI_R,TORCH_HI_G,TORCH_HI_B)*TORCH_BRIGHTNESS;
				
		#endif
		
		#if CUSTOM_TORCH_COLOR == 2

			vec3 torch_color = 
				mix(vec3(TORCH_LOW_R,TORCH_LOW_G,TORCH_LOW_B),
				vec3(TORCH_HI_R,TORCH_HI_G,TORCH_HI_B),
				
				lm.x
				
				)*TORCH_BRIGHTNESS
				;
				
		#endif
	
		#if HAND_HELD_TORCH > 0 
		
			#if AUTO_HAND_HELD_COLOR_DETECTION >= 1 
				
				#if AUTO_HAND_HELD_COLOR_DETECTION == 1 
					vec3 flashlight = unpackUnorm4x8( imageLoad( cimage_held_light,ivec2(0) ).r ).rgb;
				#endif
				#if AUTO_HAND_HELD_COLOR_DETECTION == 2
					vec3 flashlight = vec3(
						unpackUnorm4x8(imageLoad( cimage_held_light,ivec2(0) ).r).r ,
						unpackUnorm4x8(imageLoad( cimage_held_light,ivec2(1) ).r ).r,
						unpackUnorm4x8(imageLoad( cimage_held_light,ivec2(2) ).r ).r
						)
					;
				#endif
				#if AUTO_HAND_HELD_COLOR_DETECTION == 3
					vec3 flashlight = 
						unpackUnorm4x8( imageLoad( cimage_held_light,ivec2(0) ).r ).rgb
						+ unpackUnorm4x8( imageLoad( cimage_held_light,ivec2(1) ).r ).rgb
						+ unpackUnorm4x8( imageLoad( cimage_held_light,ivec2(2) ).r ).rgb
						;
				//	flashlight=vec3(1.,0.,0.);//debug
						
				#endif
				#if AUTO_HAND_HELD_COLOR_DETECTION == 4
					vec3 flashlight = 
						unpackUnorm4x8( imageLoad( cimage_held_light,ivec2(1,0) ).r ).rgb
						+ unpackUnorm4x8( imageLoad( cimage_held_light,ivec2(1,1) ).r ).rgb
						+ unpackUnorm4x8( imageLoad( cimage_held_light,ivec2(1,2) ).r ).rgb
						;
				#endif
				#if AUTO_HAND_HELD_COLOR_DETECTION == 5
					vec3 flashlight = 
						unpackUnorm4x8( imageLoad( cimage_held_light,ivec2(0) ).r ).rgb
						+ unpackUnorm4x8( imageLoad( cimage_held_light,ivec2(1) ).r ).rgb
						;
				#endif
                #if AUTO_HAND_HELD_COLOR_DETECTION == 6
               
                    #define IS_HAND_CHECK_FROM_LIST 1
                    float flow_gredient=1.;
                   
                    #include "/hard_coded_blocks_hand.glsl"
				
					vec3 flashlight = hand_color.rgb+hand_color2.rgb;
				#endif

				//torch_color = flashlight;
				
				vec3 flashlight_auto = flashlight;
				flashlight = vec3(0.);
			#else
				vec3 flashlight = vec3(0.);
				vec3 flashlight_auto = vec3(0.);
			#endif	
			//>auto detect hand color
			
				// FLOODFILL_LIGHTING >= 1 || //2025-6
				#if CUSTOM_TORCH_COLOR == 0
						//texture(lightmap, vec2(lm.x,0.1)).rgb;//
						
						
					
						flashlight += heldItemId == 10000 || heldItemId2 == 10000 ? 
							vec3(1.,0.9,0.8):vec3(0.);
							
						flashlight += heldItemId == 10001 || heldItemId2 == 10001 ? 
							vec3(0.5,0.7,1.)
							:vec3(0.)
							;
						
						flashlight += heldItemId == 10002 || heldItemId2 == 10002 ? 
							vec3(1.,0.1,.04)
							:vec3(0.)
							;			
						
						flashlight += heldItemId == 10075 || heldItemId2 == 10075 ? 
							vec3(COPPER_TORCH_R,COPPER_TORCH_G,COPPER_TORCH_B)
							:vec3(0.)
							;			
						
							
						flashlight = flashlight == vec3(0.) ? vec3(1.) : flashlight;
						
						
				



				#endif
				#if CUSTOM_TORCH_COLOR == 1
					
					//vec3 flashlight = vec3(0.);
					
					flashlight += heldItemId == 10000 || heldItemId2 == 10000 ? 
						vec3(TORCH_HI_R,TORCH_HI_G,TORCH_HI_B) : vec3(0.);
						
					flashlight += heldItemId == 10001 || heldItemId2 == 10001 ? 
						vec3(0.5,0.7,1.)
						:vec3(0.)
						;
					
					flashlight += heldItemId == 10002 || heldItemId2 == 10002 ? 
						vec3(1.,0.1,.04)
						:vec3(0.)
						;			
						
					
					flashlight += heldItemId == 10075 || heldItemId2 == 10075 ? 
							vec3(COPPER_TORCH_R,COPPER_TORCH_G,COPPER_TORCH_B)
							:vec3(0.)
							;	
						
					flashlight = flashlight == vec3(0.) ? vec3(1.) : flashlight;		
						
				#endif
				#if CUSTOM_TORCH_COLOR == 2

					//vec3 flashlight = vec3(0.);
					
					float flicker = 
						//.5+.25*sin(frameTimeCounter)+.2*sin(frameTimeCounter*2.14);
						 (.7+.2*sin(frameTimeCounter*1.)+.2*sin(frameTimeCounter*2.)+.1*sin(frameTimeCounter*5. ))
						 ;
					
					flashlight += heldItemId == 10000 || heldItemId2 == 10000 ? 
						mix(vec3(TORCH_LOW_R,TORCH_LOW_G,TORCH_LOW_B),
						vec3(TORCH_HI_R,TORCH_HI_G,TORCH_HI_B),
						flicker
					//.5*(flicker+pow(torch_hand_light,TORCH_FALLOFF))
						)
					//	pow(torch_hand_light,TORCH_FALLOFF)) //*BLOCK_LIGHT_BRIGHTNESS
						:vec3(0.)
						;
						
					flashlight += heldItemId == 10001 || heldItemId2 == 10001 ? 
						vec3(0.5,0.7,1.)
						:vec3(0.)
						;
					
					flashlight += heldItemId == 10002 || heldItemId2 == 10002 ? 
						vec3(1.,0.1,.04)
						:vec3(0.)
						;	

					flashlight += heldItemId == 10075 || heldItemId2 == 10075 ? 
						mix(vec3(COPPER_TORCH_R,COPPER_TORCH_G,COPPER_TORCH_B) ,
						vec3(COPPER_TORCH_LOW_R,COPPER_TORCH_LOW_G,COPPER_TORCH_LOW_B),
						flicker 
					//	.5*(flicker+pow(torch_hand_light,TORCH_FALLOFF))
						)*BLOCK_LIGHT_BRIGHTNESS
						:vec3(0.)
						;
						
					#if AUTO_HAND_HELD_COLOR_DETECTION == 0
						flashlight = flashlight == vec3(0.) ? vec3(1.) : flashlight;	
					#endif
								
				#endif
			
			flashlight =  heldBlockLightValue + heldBlockLightValue2 > 0 ? flashlight : vec3(0.);//needed on jcl
			flashlight=max(flashlight,flashlight_auto);
			//flashlight/=max(max(flashlight.r,flashlight.g),flashlight.b);
				//adjust oob and non-floodfill torch color		
				flashlight*= mix(1.,BLOCK_LIGHT_BRIGHTNESS_IN_DAYLIGHT,lm.y* pow(max(0.,1.-abs(sunAngle-.25)*4.),.2) );
			
			
			#if HELD_LIGHT_PBR == 1 && PBR >= 2 && HAND_HELD_TORCH > 0 
				flashlight_specular*=flashlight;
			#endif
			
			#if AUTO_HAND_HELD_COLOR_DETECTION >= 1
				flashlight = pow(torch_hand_light,HELD_TORCH_FALLOFF)*flashlight *HELD_TORCH_BRIGHTNESS;
			#else
				flashlight = pow(torch_hand_light,HELD_TORCH_FALLOFF)*flashlight *HELD_TORCH_BRIGHTNESS;
			#endif
			
			/*
			item.10000 = torch jack_o_lantern magma_block lantern blaze_rod lava_bucket camp_fire fire_charge
			item.10001 = soul_torch
			item.10002 = redstone_torch
			item.10008 = glowstone
			*/

            //#include "/hard_coded_blocks.glsl"

		#endif
	
		#if IS_THE_NETHER == 1
			//	torch_color *=2.-1.5* clamp(vec3(1.,2.5,3.)*(1.-world_pos.y*(2.-1.*sin(frameTimeCounter))/100.),0.,1.);
		#endif
	
	
	#if PBR >= 3
		
	#endif
			
	//adjust oob and non-floodfill torch color		
	torch_color*= mix(1.,BLOCK_LIGHT_BRIGHTNESS_IN_DAYLIGHT,lm.y* pow(max(0.,1.-abs(sunAngle-.25)*4.),.2) );
	
	#if FLOODFILL_LIGHTING >= 1
		
		#if PBR == 0 && HAND_HELD_TORCH == 0 
			vec3 normals_pixel = normals_face.xyz;
		#endif
					
		if( dist < VOXEL_RADIUS)
		{
			//uniform int frameCounter;
			ivec3 double_buffer_offset = mod(frameCounter,2)==0? ivec3(0,VOXEL_AREA,0):ivec3(0);
			
			#if FLOODFILL_LIGHTING == 1
			vec4 light_color = texture3D(cSampler3_colored_light, 
				vec3(foot_pos2+fract(cameraPosition) +VOXEL_RADIUS+double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)	
				);	
			#endif
			
			#if FLOODFILL_LIGHTING == 5
			//blocky
			vec4 light_color = texture3D(cSampler3_colored_light, 
				vec3(floor(foot_pos2+fract(cameraPosition))+.5 +VOXEL_RADIUS+double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)	
				);	
			#endif
			
			#if FLOODFILL_LIGHTING == 2
				#if IS_PARTICLE == 1
					
					vec4 light_color = texture3D(cSampler3_colored_light, 
					vec3(foot_pos2+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)	
					);	
					//light_color = imageLoad(cimage3_colored_light, ivec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset));	
				#else
					vec3 normals_world= normalize((gbufferModelViewInverse * vec4(normals_pixel.xyz,1.)).xyz);
					vec4 light_color = texture3D(cSampler3_colored_light, 
					vec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)	
					);	
					//light_color = imageLoad(cimage3_colored_light, ivec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset));	
					
					#if COLORED_LIGHT_SPEC == 1 && PBR >= 2 
						light_color*=(1.-specular_pixel.g);
						
						normals_world= normalize((gbufferModelViewInverse * vec4(reflected_angle.xyz,1.)).xyz-gbufferModelViewInverse[3].xyz);
						light_color_spec = texture3D(cSampler3_colored_light, 
						vec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)	
						);	
						light_color_spec.rgb*=specular_pixel.g *mix(vec3(1.) ,color.rgb,metalness) ;
					#endif
				#endif
				
				
			#endif
			#if FLOODFILL_LIGHTING == 3
				#if IS_PARTICLE == 1
					
					vec4 light_color = texture3D(cSampler3_colored_light, 
					vec3(foot_pos2+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)	
					);	
					//light_color = imageLoad(cimage3_colored_light, ivec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset));	
				#else
					vec3 normals_world= normalize(gbufferModelViewInverse * vec4(normals_pixel.xyz,1.)).xyz;
					vec4 light_color = texture3D(cSampler3_colored_light, 
						vec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
						);	
					vec4 light_color2 = texture3D(cSampler3_colored_light, 
						vec3(foot_pos2+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
						);	
					light_color=clamp(light_color-light_color2*.8,0.,1.)*2.;
					
					#if COLORED_LIGHT_SPEC == 1 && PBR >= 2 
						light_color*=(1.-specular_pixel.g);
						
						normals_world= normalize((gbufferModelViewInverse * vec4(reflected_angle.xyz,1.)).xyz-gbufferModelViewInverse[3].xyz);
						light_color_spec = texture3D(cSampler3_colored_light, 
						vec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
						);	
						light_color_spec=clamp(light_color_spec-light_color2*.8,0.,1.)*2.;
						light_color_spec.rgb*=specular_pixel.g *mix(vec3(1.) ,color.rgb,metalness) ;
					#endif
				#endif
			#endif
			#if FLOODFILL_LIGHTING == 4
				#if IS_PARTICLE == 1
					
					vec4 light_color = texture3D(cSampler3_colored_light, 
					vec3(foot_pos2+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)	
					);	
					//light_color = imageLoad(cimage3_colored_light, ivec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset));	
				#else
					vec3 normals_world= normalize(gbufferModelViewInverse * vec4(normals_pixel.xyz,1.)).xyz;
					vec4 light_color = texture3D(cSampler3_colored_light, 
						vec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
						);	
					vec4 light_color2 = texture3D(cSampler3_colored_light, 
						vec3(foot_pos2+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
						);	
						
					//light_color=clamp(light_color-light_color2*.8,0.,1.)*2.;
								light_color = min(light_color2,pow(clamp((light_color-light_color2)*DBLX_MULT,0.,1.)*1., vec4(1.0)));								
								float vx_lum= (light_color.r+light_color.g+light_color.b)/3.;
								vec3 vx_hue = light_color.rgb - vx_lum;
								light_color.rgb = max(vec3(0.), vx_lum + vx_hue );
						
							
					#if COLORED_LIGHT_SPEC == 1 && PBR >= 2 
						light_color*=(1.-specular_pixel.g);
						
						normals_world= normalize((gbufferModelViewInverse * vec4(reflected_angle.xyz,1.)).xyz-gbufferModelViewInverse[3].xyz);
						light_color_spec = texture3D(cSampler3_colored_light, 
						vec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
						);	
						
						//light_color_spec=clamp(light_color_spec-light_color2*.8,0.,1.)*2.;
							light_color_spec = min(light_color2,pow(clamp((light_color_spec-light_color2)*DBLX_MULT,0.,1.)*1., vec4(1.0)));								
								vx_lum= (light_color_spec.r+light_color_spec.g+light_color_spec.b)/3.;
								vx_hue = light_color_spec.rgb - vx_lum;
								light_color_spec.rgb = max(vec3(0.), vx_lum + vx_hue );
						
						light_color_spec.rgb*= 2.* specular_pixel.g *mix(vec3(1.) ,color.rgb,metalness) ;
					#endif
				#endif
			#endif
							
			
			#if FLOODFILL_LIGHTING >= 7
				#if IS_PARTICLE == 1
					
					vec4 light_color = texture3D(cSampler3_colored_light, 
					vec3(foot_pos2+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)	
					);	
					//light_color = imageLoad(cimage3_colored_light, ivec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset));	
				#else
					vec3 normals_world= normalize(gbufferModelViewInverse * vec4(normals_pixel.xyz
					,1.)).xyz 
					- gbufferModelViewInverse[3].xyz //2025-11-20
					;
					vec4 light_color = texture3D(cSampler3_colored_light, 
						vec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
						);	
					vec4 light_color2 = texture3D(cSampler3_colored_light, 
						vec3(foot_pos2+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
						);	
						
					vec4 dramaric = clamp(light_color-light_color2*.8,0.,1.)*2.;
					vec4 dramaric2 = clamp(light_color-light_color2,0.,1.)*3.;
					vec4 directional2 =  						
								min(light_color2,pow(clamp((light_color-light_color2) *DBLX_MULT,0.,1.)*1., vec4(1.0)));								
								float vx_lum= (directional2.r+directional2.g+directional2.b)/3.;
								vec3 vx_hue = directional2.rgb - vx_lum;
								directional2.rgb = max(vec3(0.), vx_lum + vx_hue );
					vec4 rough_dir = light_color;
					
					#if DIFFFUSE_VX_BEHAVIOR == 1
						light_color = mix( mix(rough_dir,dramaric,specular_pixel.r) ,light_color2, texture_sss);
					#endif
					#if DIFFFUSE_VX_BEHAVIOR == 2
						light_color = mix( mix(dramaric,dramaric2,specular_pixel.r) ,light_color2, texture_sss);
					#endif
					
					#if SOLAR_GI == 1
						gi[4] = texture3D(cSampler4_gi, vec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA*6) );
						gi[4]*=max(0.,-normals_world.y);
						light_color+=gi[4];
					#endif	
					
							
					#if COLORED_LIGHT_SPEC == 1 && PBR >= 2 
						light_color*=(1.-specular_pixel.g);
						
						normals_world= normalize((gbufferModelViewInverse * vec4(reflected_angle.xyz,1.)).xyz-gbufferModelViewInverse[3].xyz);
						light_color_spec = texture3D(cSampler3_colored_light, 
						vec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
						);	
						
						dramaric=clamp(light_color_spec-light_color2*.8,0.,1.)*2.;
						
						directional2 = 
								min(light_color2,pow(clamp((light_color_spec-light_color2) 				*DBLX_MULT,0.,1.)*1., vec4(1.0)));								
								vx_lum= (directional2.r+directional2.g+directional2.b)/3.;
								vx_hue = directional2.rgb - vx_lum;
								directional2.rgb = max(vec3(0.), vx_lum + vx_hue );
						
						
						#if SPECULAR_VX_BEHAVIOR == 1
							light_color_spec = mix(dramaric,directional2,specular_pixel.r);
						#endif
						#if SPECULAR_VX_BEHAVIOR == 2
							light_color_spec = mix(rough_dir,dramaric,specular_pixel.r);
						#endif
						#if SPECULAR_VX_BEHAVIOR == 3
							dramaric2=clamp(light_color_spec-light_color2,0.,1.)*3.;
						
							light_color_spec = mix(dramaric,dramaric2,specular_pixel.r);
						#endif
						
						#if METAL_AMBIENT_LIT == 1
							light_color_spec = max(light_color_spec,rough_dir*METAL_AMBIENT);
						#endif
						
						
						
						#if CRYSTAL_SSS == 1
							if(texture_sss>0.5/255.)
							{
								float eta = 1.-.3*specular_pixel.g;

								normals_world= normalize((gbufferModelViewInverse * vec4(normalize(refract(view_dir.xyz,
								#if PBR > 0
									normals_pixel.xyz
								#else
									normals_face.xyz
								#endif
								
								,eta)),1.)).xyz-gbufferModelViewInverse[3].xyz);
								vec4 sss_vx = texture3D(cSampler3_colored_light, 
								vec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
								);	
								sss_vx=mix(light_color2, clamp(sss_vx-light_color2*.8,0.,1.)*2. , specular_pixel.g );
								light_color_spec.rgb +=sss_vx.rgb* texture_sss*mix(vec3(1.),color.rgb,max(0.,color.a-texture_sss));
							}
						#endif
						
						light_color_spec.rgb*= 2.* specular_pixel.g *mix(vec3(1.) ,color.rgb,metalness) ;
					#endif
				#endif
			#endif
			
			
			#if EXTRA_VIBRANT_BL == 1 && LIGHT_FALLOFF == 1
				float lbd = max(light_color.r,max(light_color.g,light_color.b));
				light_color.rgb=lbd>0.01?light_color.rgb/lbd : light_color.rgb;
			#endif
			
			light_color*= mix(1.,BLOCK_LIGHT_BRIGHTNESS_IN_DAYLIGHT,lm.y* pow(max(0.,1.-abs(sunAngle-.25)*4.),.2) );
			
					
			torch_color= mix(
				#if VOXEL_PHOTON_SIMULATION_QUALITY < 2 
					lm.x*
				#endif
				light_color.rgb*BLOCK_LIGHT_BRIGHTNESS,
				lm.x*torch_color+lava_noise*.5,
				torch_fade) ;
		}else{
			torch_color=lm.x*torch_color+lava_noise*.5;
		}
		
		#if VOXELIZE_ENTITIES == 0 
			torch_color = (abs(ipbr_id -20010.)<.5) ? vec3(1.) : torch_color; //fire bright when no voxelizing entities
		#endif 
		
	#else
		
		torch_color=lm.x*torch_color;
	#endif
	
	//2026-1, use to be: OR :   #if PBR == 0 || DIRECTIONAL_LIGHTING == 0
	#if PBR == 0 && DIRECTIONAL_LIGHTING == 0
		//color.rgb*= glcolor.a; //4-2025
		color.rgb*= ao_allowed_light; //10-2025
	#endif
	
	#if NIGHT_VISION_MODE == 0
		torch_color = max(torch_color, vec3(nightVision) );
	#endif
	#if NIGHT_VISION_MODE == 2
		torch_color.r = max(torch_color.r, nightVision);
	#endif
	
	
	#if BLOCK_LIGHTS_CATCH_HELD_LIGHT == 0
		{
			float inverse_emission = 1.-specular_pixel.a;
			flashlight*=inverse_emission;
			#if PBR >= 2
				flashlight_specular*=inverse_emission;
			#endif
		}
	#endif
	




	
	#if SHADOWS >= 1
		
		#if SSS == 0
		if (face_shading > 0.0) //surface is facing towards shadowLightPosition
		#endif
		{
			#if IS_THE_NETHER ==1
				main_lighting*=0.;
			#else
				#include "/shadows.glsl"
			#endif
			
		}
		#if BRIGHTER_UNDERWATER == 1
			sky_color*=isEyeInWater > 0 ? main_lighting  : 1.0;
		#endif
				
		#if FIX_COLOR_SPACE == 1
			color.rgb=pow(color.rgb,vec3(2.2));
		#endif

        #if ADJUST_SPECULAR == 1
            #include "/pbr3.glsl"
        #else
	        #include "/pbr2.glsl"
        #endif      
	
		
		#if HAND_HELD_TORCH > 0 
			torch_color += flashlight;
		#endif
		
	
		
		color.rgb = 	
        //emmissi9n
		color.rgb*specular_pixel.a*PBR_EMMISSIVE_STRENGTH+
		#if PBR >= 2
			
			sun_shine+sky_shine+
			#if COLORED_LIGHT_SPEC == 1 && PBR >= 2
				light_color_spec.rgb * mix(1.,BLOCK_LIGHT_BRIGHTNESS_IN_DAYLIGHT,lm.y* pow(max(0.,1.-abs(sunAngle-.25)*4.),.2) )
				*BLOCK_LIGHT_BRIGHTNESS +
			#endif 
			#if HELD_LIGHT_PBR == 1 && PBR >= 2  && HAND_HELD_TORCH > 0 
				flashlight_specular+
			#endif 
		#endif 
		color.rgb* max(
		#if IS_THE_NETHER == 1 
			#if NETHER_RED_AMBIENT_LIGHT == 1
				clamp(max(vec3(MINIMUM_LIGHT_LEVEL_NETHER),
				vec3(1.,0.9,0.7)-vec3(1.,2.5,3.)*world_pos.y/100.
				#if PULSING_AMBIENT_LIGHT == 1
					*(2.+1.*sin(frameTimeCounter))
				#endif
			
				),0.,1.)
			#else
				vec3(MINIMUM_LIGHT_LEVEL_NETHER)
		
			#endif
			

		#else
			
			#if IS_THE_END == 1 
				vec3(MINIMUM_LIGHT_LEVEL_END)
			#else
				vec3(MINIMUM_LIGHT_LEVEL)
			#endif
		#endif
		
		
		,

			sun_lighting*		

			sun_color*
			 shadowLightColor.rgb*main_lighting
			+
			#if PBR > 0
				(ao_allowed_sky_light*
				(lm.y*sky_color*sky_lighting )
				#if AO_EFFECTS_BLOCKLIGHT == 1
					+torch_color*ao_allowed_light
				#else
					+torch_color
				#endif
				)
			#else
                
				ao_allowed_sky_light* //2025-5
				lm.y*sky_color
				+torch_color
				
			#endif
		
		)
		;
	#else
		#if FIX_COLOR_SPACE == 1
			color.rgb=pow(color.rgb,vec3(2.2));
		#endif
		#include "/pbr2.glsl"
		
		#if HAND_HELD_TORCH > 0 
			torch_color += flashlight;
		#endif
		

 #if IS_COLOR_WHEEL == 1 && PBR == 011
	color.rgb+= color.rgb*specular_pixel.a*PBR_EMMISSIVE_STRENGTH;
 #else

		color.rgb = 	
        //emmissi9n
		color.rgb*specular_pixel.a*PBR_EMMISSIVE_STRENGTH+
		#if PBR >= 2
			
			sun_shine+sky_shine+
			#if COLORED_LIGHT_SPEC == 1 && PBR >= 2
				light_color_spec.rgb * mix(1.,BLOCK_LIGHT_BRIGHTNESS_IN_DAYLIGHT,lm.y* pow(max(0.,1.-abs(sunAngle-.25)*4.),.2) )
				*BLOCK_LIGHT_BRIGHTNESS +
			#endif 
			#if HELD_LIGHT_PBR == 1 && PBR >= 2  && HAND_HELD_TORCH > 0 
				flashlight_specular +
			#endif 
		#endif 


		color.rgb* max(
		#if IS_THE_NETHER == 1 
			
			#if NETHER_RED_AMBIENT_LIGHT == 1
				clamp(max(vec3(MINIMUM_LIGHT_LEVEL_NETHER),
				vec3(1.,0.9,0.7)-vec3(1.,2.5,3.)*world_pos.y/100.
				#if PULSING_AMBIENT_LIGHT == 1
					*(2.+1.*sin(frameTimeCounter))
				#endif
			
				),0.,1.)
			#else
				vec3(MINIMUM_LIGHT_LEVEL_NETHER)
		
			#endif
			
		#else
			#if IS_THE_END == 1 
				vec3(MINIMUM_LIGHT_LEVEL_END)
			#else
				vec3(MINIMUM_LIGHT_LEVEL)
			#endif
		#endif
		,

		
	   
		#if DIRECTIONAL_LIGHTING == 1
	
				sun_lighting*
	
			
			main_lighting *sun_color+
				lm.y*sky_color
				+torch_color
		#else
			#if IS_AN_ENTITY == 1
				lm.y*sky_color*((1.-ENTITY_LIGHTING_DIRECTIONALITY)
					+ENTITY_LIGHTING_DIRECTIONALITY*clamp(dot(normalize(vec3( ENTITY_LIGHTING_ANGLE_X , ENTITY_LIGHTING_ANGLE_Y , ENTITY_LIGHTING_ANGLE_Z )), normals_pixel.xyz) ,0.,1.) 
					)
				+torch_color
				// ENTITY_LIGHTING_ANGLE_X ENTITY_LIGHTING_ANGLE_Y ENTITY_LIGHTING_ANGLE_Z
			#else
				lm.y*sky_color
				+torch_color

			#endif
		#endif
		
 
		
	
			

		
		);
		;
		
		#endif
        //> not color wheel

		
		

	
		//	color.rgb=vec3(1.,0.,0.);//normals_pixel.xyz*.5+.5;//debug
	
	#endif
	
	
	#if IS_AN_ENTITY == 1 && (UN_SHADED_NAMETAGS == 1 || SEE_NAMETAGS_BETTER_THROUGH_WALLS == 1)
		if ( abs(ipbr_id - 20013.) < .5 &&  color.a>0.001 &&  color.r>0.001) 
		{
			#if UN_SHADED_NAMETAGS == 1
				color.rgb = albedo;
			#endif
			#if SEE_NAMETAGS_BETTER_THROUGH_WALLS == 1
				color.a = NAMETAGS_OPACITY_THROUGH_WALLS ;	
			#endif
			
		}
	#endif	
	
	

	
	
	#if SHOW_MOB_DAMAGE == 1 && IS_AN_ENTITY == 1
		color.rgb= mix(color.rgb,entityColor.rgb,entityColor.a);
	#endif
	
	//moved before fog (8-2025)
	#if DONT_BLOW_OUT_WHITES == 1
		color.r = color.r < TONEMAPPING_BRIGHTNESS?color.r : TONEMAPPING_BRIGHTNESS+(color.r-TONEMAPPING_BRIGHTNESS)*TONEMAPPING_RANGE;
		color.g = color.g <TONEMAPPING_BRIGHTNESS?color.g : TONEMAPPING_BRIGHTNESS+(color.g-TONEMAPPING_BRIGHTNESS)*TONEMAPPING_RANGE;
		color.b = color.b <TONEMAPPING_BRIGHTNESS?color.b : TONEMAPPING_BRIGHTNESS+(color.b-TONEMAPPING_BRIGHTNESS)*TONEMAPPING_RANGE;
	#endif
	#if DONT_BLOW_OUT_WHITES == 2
		float gray = (color.r +color.g+color.b)/3.;
		float lum = gray/(gray+TONEMAPPING2_STRENGTH);
		color.rgb*=lum;
	#endif
	
	
	#if FOG == 1
		float water_fog = isEyeInWater == 1? WATER_FOG_DISTANCE : isEyeInWater == 2? 20. : isEyeInWater == 3? SNOW_VISIBILITY : 0.;
		water_fog= mix(water_fog,15.,darknessFactor);
		water_fog= mix(water_fog,5.,blindness);
		
		water_fog = (water_fog > 1. ) ? clamp((dist)/water_fog,0.,1.) : 0.;
		
		//fogColor FOG_START FOG_END
		
		
            #if defined VOXY
                float border_fog_amount = 0.;
            #else
                float border_fog_amount = clamp((dist-(BORDER_FOG_START*far1))/(((1.-BORDER_FOG_START)*far1)),0.,1.);
            #endif
			
			
			float fog_amount = 
				clamp(
                
				max(
				water_fog,
				max( 
					clamp((dist-FOG_START)/(FOG_END-FOG_START),0.,FOG_MAX),
					border_fog_amount)
					*(1.+rainStrength)
					)
				,0.,1.)
				;
				
				#if EXPONENTIAL_FOG == 1
					fog_amount=pow(fog_amount,2.);
				#endif

                #ifdef IRIS_FEATURE_FADE_VARIABLE 
                    #if IS_TERRAIN == 1 && CHUNK_FADE == 1 && IS_BREAKING_BLOCK != 1
                        // in float mc_chunkFade;
                        fog_amount=max(fog_amount, chunk_fade);
                     #endif
				  #endif
				
			
				
			color.rgb = mix(color.rgb,fogColor
				#if CAVE_LIGHT_LEAK_FIX_SKY == 1 && IS_THE_NETHER != 1 && IS_THE_END != 1
					*cave_light_leak_fix_sky
				#endif
				,fog_amount);



			
	#endif
	

				
	//color.rgb = vec3( lm.x ) ;//debug
	
	
	#if IS_PARTICLE == 1 && PARTICLES_LPV == 1
		//if( renderStage == MC_RENDER_STAGE_PARTICLES ) color.rgb=vec3(1.,0.,0.);//debug
	#endif
	
	#if BORDERS >= 2
		vec4 edge_colors = 
		
		vec4(
			mix(color.rgb*3.,+vec3(1.),.25)*
			
			(sun_lighting_back)*		
			sun_color*
			shadowLightColor.rgb*main_lighting
			
			+
			color.rgb*3.*
			//(color.rgb+vec3(1.))*.5*
			#if PBR > 0
				(ao_allowed_sky_light*
				(clamp((lm.y*skyColor*sky_lighting_back -lm.y*skyColor,0.)*5.,0.,1.)*0.
				#if AO_EFFECTS_BLOCKLIGHT == 1
					+torch_color*ao_allowed_light
				#else
					+torch_color
				#endif
					)
			#else
				clamp((lm.y*skyColor *sky_lighting_back -lm.y*skyColor)*5.,0.,1.)*0.
				+torch_color
				
			#endif
			,1.);
		
	#endif
	
	#if DEBUG_FIX_CIRCLE == 1
	  color.rgb = dist > dh_discard_circle*far? vec3(1.,0.,0.)*player_speed/DH_FLYING_FIX_CIRCLE_SPEED: color.rgb;//debug
	#endif
	
	//color.rgb = vec3(fract(shadowPos.z*Shadow_map_depth));// <= 0.? vec3(0.,0.,1.):shadowPos.z >= 1.? vec3(1.,0.,0.):color.rgb;
	//color.rgb= abs(ipbr_id-20001.)<=.5?  vec3(1.,0.,0.) : color.rgb;//debug
	//color.rgb=vec3(fract(.1*viewPos.z));//debug

	#if FIX_COLOR_SPACE == 1
		color.rgb=pow(color.rgb,vec3(1./2.2));
	#endif
	
	#if BORDERS == 0 && GODRAYS == 0 && CLOUDS == 0 && ADJUST_GAMMA == 1	
		color.rgb=pow(color.rgb,vec3(1./GAMMA_DISPLAY));
	#endif
	

	
	#if DEBUG_MODE > 0
		color.rgb=debugdata3;
	#endif
	
	
		#if IS_THE_NETHER == 1
			
			#if defined IS_IRIS && (defined DISTANT_HORIZONS ||  defined VOXY)
				color.rgb=mix(color.rgb,fogColor,pow(clamp(dist/ (dhFarPlane
				#if PULSING_FOG == 1
					*(.5+.45*sin(frameTimeCounter*.1))
				#endif
				) ,0.,1.),.5));
			#else
				color.rgb=mix(color.rgb,fogColor,pow(clamp(dist/ (far
				#if PULSING_FOG == 1
					*(.5+.45*sin(frameTimeCounter*.1))
				#endif
				) ,0.,1.),.5));
			#endif

			
		#endif
		
	#if IS_AN_ENTITY == 1
		color.a = ( abs(ipbr_id - 20013.) < .5 && color.a > .1 && (color.r+color.g+color.b<.1) ) ? NAMETAG_OPACITY : color.a;	
	#endif	
	
	#if IS_WEATHER == 1
		color.a = color.a<1.? min(color.a, RAIN_OPACITY ) :color.a;;
	#endif	
	
	








	
	
	#if DEBUG_MODE == 3
		ivec3 double_buffer_offset = mod(frameCounter,2)==0? ivec3(0,VOXEL_AREA,0):ivec3(0);
			
		color.rgb = texture3D(cSampler3_colored_light, 
					vec3(foot_pos2+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)	
					);
    ApplyTextureSynthesis(color);
    color = color .rgb;	
	#endif					
	
	
	
	
	
#if IS_LINE == 1
//	discard;
//	return;
#endif

	#if NIGHT_VISION_MODE == 1
		//Gamma based when no composite
		#if BORDERS == 0 && GODRAYS == 0 && CLOUDS == 0
			color.rgb = pow(color.rgb,vec3(1.-.5*nightVision));
		#endif
	#endif
	#if NIGHT_VISION_MODE == 2
		if(nightVision > 0.001)
		{
			float detail = color.r;
			//Thermal
			#if PBR >= 2
				float heat = min(1., specular_pixel.a+torch_color.r*.2+torch_color.g*.3+torch_color.b*.5  )*(1.+1.*specular_pixel.g*(torch_color.r-.5))
				
				//-puddles
				;
			#else
				float heat = min(1., torch_color.r*.2+torch_color.g*.3+torch_color.b*.5 );
			#endif
			#if IS_AN_ENTITY == 1
				heat+=.5
				#if PBR >= 2
					-.5*specular_pixel.g
				#endif
				;
			#endif	
			heat += (abs(ipbr_id - 10032.)<.5?.5 :0.);
			heat+= (sunAngle >.5)? 0. :
				clamp((1.-abs(sunAngle-.25)*4.)*10.,0.,1.)
				
				*(
				#if SHADOWS > 0
					 shadowLightColor.r* main_lighting *
				#endif
				sun_lighting *.5*lm.y 
				+lm.y *.3 *temperature_smooth1);
				
			heat=max(heat-detail*.3,0.);
			vec3 heat_vis =
				 heat < .25 ? mix(vec3(0.,0.,0.),vec3(0.,0.,1.), heat*4.)
				:heat < .5 ? mix(vec3(0.,0.,1.),vec3(0.,1.,0.), (heat-.25)*4.)
			:heat < .75 ? mix(vec3(0.,1.,0.),vec3(1.,1.,0.), (heat-.5)*4.)
			:heat < 1. ? mix(vec3(1.,1.,0.),vec3(1.,0.,0.), (heat-.75)*4.)
			: mix(vec3(1.,0.,0.),vec3(1.), (heat-1.)*4.)
;
			
			float nv_effect = 1.-pow(min(1.,distance(gl_FragCoord.xy,vec2(viewWidth,viewHeight)*.5)/(.5*viewWidth)),3.);
			
			color.rgb  = mix(color.rgb,heat_vis,max(nightVision,nv_effect));
			
			color.rgb*= 1.-max(blindness, darknessFactor)*fog_amount;
		
		}
	#endif
	
	
	
	#if BORDERS == 0 && GODRAYS == 0 && CLOUDS == 0
		//program.composite.enabled=false	
		#define NOT_RUNNING_COMPOSITE 1
	#endif
	
	
	
	#if USE_MANUAL_FINAL_ADJUSTMENTS == 1 && NOT_RUNNING_COMPOSITE == 1	
		float brightness = (color.r+color.g+color.b)*.333;
		vec3 hue = color.rgb-brightness;
		color.rgb=(((brightness-BTIGHTNESS_CONTRAST_CENTER)*BTIGHTNESS_CONTRAST+BTIGHTNESS_CONTRAST_CENTER)+hue*SATURATION-.5)*CONTRAST+.5+BRIGHTNESS-1.;
		//BRIGHTNESS SATURATION CONTRAST
	#endif
	
	
	
	  #if IS_COLOR_WHEEL == 1
 
    //    color = cw_color;
        
        
    #endif
	
	
	
	
	
	
	//if(ipbr_id > 10039.5 && ipbr_id < 10055.5) color.a=max(color.a,.75);//glass more opaque
	
	

	#if defined IS_IRIS && (defined DISTANT_HORIZONS || defined VOXY ) && BORDERS_IN_DH == 1
		/* RENDERTARGETS: 0,1 */
		gl_FragData[0] = color;
		/*
			const int colortex1Format = R16F;
		*/
		gl_FragData[1].x = 
		//abs(ipbr_id-10020.)<=.5? 0.:
		distance(vec3(0.),viewPos.xyz)
		#if POM == 1
			+pom_depth_forward
		#endif
		; 
	#else
		/* DRAWBUFFERS:0 */
		gl_FragData[0] = color; 
	#endif
	
	





		//gl_FragData[1] = edge_colors; 

}
