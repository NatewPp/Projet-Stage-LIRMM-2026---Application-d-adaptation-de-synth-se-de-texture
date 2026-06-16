//#modified
// © Copyright 2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


const vec4 colortex3ClearColor = vec4( 1.0 , 1.0 ,1.0 , 0.0  );
const vec4 colortex7ClearColor = vec4( 1.0 , 1.0 ,1.0 , 0.0  );



#include "/settings.glsl"

#if HAND_HELD_TORCH > 0 

	uniform int heldItemId;
	uniform int heldItemId2;
#endif



uniform int renderStage;

#if FLOODFILL_LIGHTING >= 1
	//uniform int frameCounter;

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
	
#endif

#if defined IS_IRIS && defined DISTANT_HORIZONS && DH_SHADOWS == 1 && DUAL_DISTORT == 1 || FLOODFILL_LIGHTING >= 1
	//#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
#endif


const float sunPathRotation = 5.0;//[5.0 10.0 15.0 20.0 26.0 30.0 35.0 40.0 50.0 60.0 70.0 80.0]
#include "/noise.glsl"
uniform float wet_not_dry;

	uniform float frameTimeCounter;
#if BEACH_TIMING == 1 || CLOUDS >= 6
	//uniform float frameTimeCounter;
#endif
#if VANILLA_SUNSETS == 0
	uniform float Foggy=0.;
	uniform vec3 sunPosition;

#endif

uniform ivec2 eyeBrightnessSmooth;
uniform float thunderStrength;
uniform float frameCounter;

/*
vec3 projectanddivide(mat4 pm, vec3 p)
{
	vec4 hp = pm*vec4(p,1.);
	return hp.xyz/hp.w;
}
*/

#if IS_WATER_SHADER == 1
//WATER_COL_ABSORB >= 2 && 
	//uniform sampler2D colortex5;
	#if defined IS_IRIS
		#if defined DISTANT_HORIZONS
			uniform sampler2D dhDepthTex1;
		#endif
	#endif
#endif

#if WATER_SCATTERS_LIGHT == 1
	/*
	const bool colortex0MipmapEnabled = true;
	*/
#endif

#if IS_WATER_SHADER == 1
	uniform sampler2D depthtex1;
	#if defined IS_IRIS
	#if defined DISTANT_HORIZONS
	//	uniform sampler2D dhDepthTex1;
	#endif
	#endif
	float linearize_water_d( in float d, in float n, in float f)
	{
	   return 2.0 * n  * f / (f + n - (2.0 * d - 1.0) * (f - n));
	}
#endif


	#define FRAG_SHADER 1
	
#if THIS_IS_DISTANT_HORIZONS != 1  && USE_PHYSICS_MOD_OCEAM == 1
//&& PMOD_SHADER == 1
	#define PMODWATERSHDR 1

#endif



uniform int worldTime;

#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
	#if defined IS_IRIS && defined DISTANT_HORIZONS && DH_SHADOWS == 1 && DUAL_DISTORT == 1
			//per fragment shadow pos
//#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
uniform mat4 shadowModelView;
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

#if IS_WATER_SHADER == 1
	#if defined IS_IRIS
		#if defined DISTANT_HORIZONS
			#if THIS_IS_DISTANT_HORIZONS > 0 
				#define NOT_WATER 1
			#endif
		#endif
	#endif
	#if NOT_WATER!=1
		uniform sampler2D depthtex0;
				float linearize_depth_1(in float d)
				{
					// from gl_FragCoord.z to world measurements
					//float far4 = dhFarPlane*4.;
					return 2.0 * near  * far / (far + near - (2.0 * d - 1.0) * (far - near));

				}	
	#endif
#endif

#if defined IS_IRIS && defined DISTANT_HORIZONS
#else
	float far1 = far;
#endif

const vec4 colortex1ClearColor = vec4(10000.,0.,0.,0.);


uniform sampler2D lightmap;


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


varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
#if SHOW_MOB_DAMAGE == 1 && IS_AN_ENTITY == 1
	uniform vec4 entityColor;
#endif

varying vec4 viewPos;

#if IS_THE_NETHER == 1 || SHADOWS == 7 || (defined IS_IRIS && ((THIS_IS_DISTANT_HORIZONS == 1 && IS_WATER_SHADER == 1 )|| DH_TEXTURE > 0)) || (IS_WATER_SHADER == 1 && FANCY_WATER > 0) || PMODWATERSHDR == 1 || IS_WATER_SHADER == 1 || PUDDLES > 0
	varying vec3 world_pos;
#endif
#if IS_THE_NETHER == 1
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

	
	#if POM == 1
		#include "/stuff/timetravelbeards_Better_3D_Textures_v25-8.glsl"
	#else
		#include "/timetravelbeards_Better_3D_Textures.glsl"
	#endif

#if PBR > 0 || HAND_HELD_TORCH > 0 
	varying vec3 normals_face;
#endif
#if PBR > 0
	varying vec4 tangent;
	uniform vec3 shadowLightPosition;
	uniform vec3 upPosition;
	#if PBR >=2
		uniform float wetness;
		#if SSS >= 1  && PBR >= 2
           const float	iShadowDepth = 1./256.;
		#endif
  	#endif
#endif
#if PBR >=2 || SKY_COLOR_ALTERNATE == 1
		//uniform vec3 skyColor;
#endif
		uniform vec3 skyColor;
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
		
		
#if PMODWATERSHDR == 1

	#include "/stuff/fluids/physics_mod/physics_mod_h.glsl"


	in vec3 physics_localPosition;
	in vec3 physics_foamColor;
	in float physics_localWaviness;
	#if PMOD_SHALLOW_CHK >= 1	
		in float physics_area_depth;
	#endif
	#if TIDAL_WAVES >=  1
		//#include "/stuff/fluids/juivy.glsl"
	#endif
#endif	

#if IS_WATER_SHADER == 1 || PUDDLES > 0
	#include "/stuff/fluids/juivy.glsl"	
#endif	
		
		#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
#if SKY_ONLY_REFL == 1
	#if CLOUDS >= 1 ||  GODRAYS == 1 
		//uniform float rainStrength;
	#endif

	uniform mat4 gbufferModelView;
	float fogify(float x, float w) {
	return w / (x * x + w);
	}
	#if CLOUDS >= 1 
		//uniform int worldTime;
		uniform int worldDay;
		//#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
		//#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
			//uniform vec3 shadowLightPosition;
		#if CLOUDS >= 3
			uniform sampler2D colortex0;
			uniform sampler2D colortex6;
		#endif
		#include "/clouds.glsl"
	#endif



#if VANILLA_SUNSETS == 0
	//#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
	//uniform float sunAngle;
	//#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
	//#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif
#endif
	#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
	#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif

#include "/stuff/fluids/sky_color_h.glsl"

#endif
		
		
		
	
	
	
#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1	&& IS_WATER_SHADER == 11
	//	uniform sampler2D dhDepthTex1;

	//uniform sampler2D depthtex1;

	float linearize_depth_cpf22(in float d)
	{

		// from gl_FragCoord.z to world measurements
		return 2.0 * near  * far / (far + near - (2.0 * d - 1.0) * (far - near));

	}

	float linearize_depth_cpf_dh(in float d)
	{

		// from gl_FragCoord.z to world measurements
		return 2.0 * dhNearPlane  * dhFarPlane / (dhFarPlane + dhNearPlane - (2.0 * d - 1.0) * (dhFarPlane - dhNearPlane));

	}

	float linearize_depth_cpf2(in float d)
	{

		// from gl_FragCoord.z to world measurements
		return 2.0 * near  * far*4. / (far*4. + near - (2.0 * d - 1.0) * (far*4. - near));

	}

	float get_depth_at(vec2 uv)
	{
	#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
		return //texture2D(colortex1,uv).x;
		min(
					linearize_depth_cpf2(texture2D(depthtex1,uv).r),
					linearize_depth_cpf_dh(texture2D(dhDepthTex1,uv).r) ) ;
	#else
		return linearize_depth_cpf(texture2D(depthtex0,uv).r);
	#endif

	}

	float get_underwater_depth_at(vec2 uv)
		{
			#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
				float d1 = linearize_depth_cpf2(texture2D(depthtex1,uv).r);
				float d2 = linearize_depth_cpf_dh(texture2D(dhDepthTex1,uv).r) ;
				d1 = d1 > 0.1?d1 : 1000.;
				d2 = d2 > 0.1?d2 : 1000.;
				float d =  
					min(d1,d2) ;
					return d;
			#else
				return linearize_depth_cpf(texture2D(depthtex1,uv).r);
			#endif
			
			
		}

#endif	
	
	
	
	
	
#define FSHSDT
#include "/lib/sdt/SDTmain.glsl"
void main() {

	//#define DEBUGGING_PMOD 1
	#if DEBUGGING_PMOD == 1 
		//&& PMODWATERSHDR == 1 
		vec4 color=vec4(1.,0.,0.,1.);
	#else
	
	#if IS_WATER_SHADER == 1
		#if PMODWATERSHDR == 1
			bool is_water =true;	
			float is_water_fog =1.;	
		#else
			bool is_water = ((abs(ipbr_id - 10020.)<.5));
			float is_water_fog = is_water? 1. : 
				abs(ipbr_id-10021.) <.5?  clamp((world_pos.y+1.-cameraPosition.y),0.,1.) :
					 0. ;
			
		#endif
	#else
		bool is_water =false;	
	#endif
	#if PMODWATERSHDR == 1 && IS_WATER_SHADER == 1
		vec3 physics_normal;
		float og_water_intensity=0.;
		float foam;
		vec3 water_color ;
	#else
		float foam=0.;
	#endif
	
	#if DEBUG_MODE > 0
		vec3 debugdata3;;
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

	shadowPos=shadowPosv;
	
	#if defined IS_IRIS && defined DISTANT_HORIZONS && DH_SHADOWS == 1 && DUAL_DISTORT == 1
			//per fragment shadow pos
			vec4 playerPos = gbufferModelViewInverse * viewPos;
			shadowPos = shadowProjection * (shadowModelView * playerPos); //convert to shadow ndc space.
			float bias = computeBias(shadowPos.xyz);
			shadowPos.xyz = distort(shadowPos.xyz); //apply shadow distortion
			shadowPos.xyz = shadowPos.xyz * 0.5 + 0.5; //convert from -1 ~ +1 to 0 ~ 1
			shadowPos.w=shadowPosv.w;
	#endif



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
					//if(abs(relative_position_w_pom.z) < abs(texture2D(colortex9, screencoord).z))
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
			
			//
			#if IS_WATER_SHADER == 1
				float od = texelFetch(depthtex0,ivec2(gl_FragCoord.xy),0).r;
				float old_d = linearize_depth_1(od);
			#endif
			//
		#endif
		
	#else
		#if IS_WATER_SHADER == 1
			float od = texelFetch(depthtex0,ivec2(gl_FragCoord.xy),0).r;
			float old_d = linearize_depth_1(od);
		#endif
	#endif



	float face_shading = clamp(shadowPos.w,0.,1.);
	
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
				float noise = 0.;
				
				Ctmpomfix_alt_pom_as_insert_for_texture_data( dist, vlocal_uv, view_vector, pom_target_coord, noise, color, normals_pixel, 		specular_pixel);
				color*=glcolor;
			#else

			
				vec4 color= atlas_uv_to_bilinear_data( texcoord,dist )*glcolor;
				#if PBR > 0
					vec4 normals_pixel = atlas_uv_to_bilinear_data_normal( texcoord,dist );
				#endif
				#if PBR >= 2
					vec4 specular_pixel = atlas_uv_to_bilinear_data_specular( texcoord,dist );
				#endif
			#endif
			
			
		#else
			vec4 color = texture2D(texture, texcoord) * glcolor;
			#if PBR > 0
				vec4 normals_pixel = texture2D(normals, texcoord);
			#endif	
			#if PBR >= 2
				vec4 specular_pixel = texture2D(specular, texcoord);
			#endif
		#endif
		
		#if defined IS_IRIS && defined DISTANT_HORIZONS
			#if THIS_IS_DISTANT_HORIZONS != 1
				#if SMOOTH_DH_FADE_IN >= 1
					#if TEXTURE_SIZE_AVAILABLE == 1
						color.rgb=mix(color.rgb,
					textureLod(texture, texcoord.xy,log2(float(textureSize(texture, 0).x))).rgb* glcolor.rgb
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
	
	#if WHITE == 1
		color.rgb = vec3(1.);
	#endif
	
	#if REFLECTION_DETAIL >= 5
		float f0 = specular_pixel.g;
	#endif
	
	//if (color.a<1./255.) discard; //shouldnn't be needed
	float sss = 0.;
	#if PBR >= 2
		//sss
		 sss = specular_pixel.b;
		sss=sss<64.5/255.?0.:sss;
		//emmission
		#if FLOODFILL_LIGHTING >= 1
			specular_pixel.a=max( (specular_pixel.a >=254.5/255.?0.:specular_pixel.a),
			 (specular_pixel==vec4(0.) ? block_centered_relative_pos.w : 0.  ) );
		#else
			specular_pixel.a=specular_pixel.a >=254.5/255.?0.:specular_pixel.a;
		#endif
	#endif
	#if SSS >= 1 && SHADOWS > 0
		//ipbr sss
	
		#if PBR < 2
			#if SSS >= 2
					sss= max(.25,(abs(ipbr_id-10001.)<=.5? 1. :sss));
			#else
					sss= (abs(ipbr_id-10001.)<=.5? 1. :sss);
			#endif
	
		#else
			#if SSS >= 2
					sss= max(sss,max(.25,(abs(ipbr_id-10001.)<=.5? 1. :sss)));
			#else
					sss= max(sss,(abs(ipbr_id-10001.)<=.5? 1. :sss));
			#endif
	
		#endif

	#endif
	#if SHADOWS > 0 && DH_SHADOWS == 0
		float actual_shadow_distance = min(far,shadowDistance);
		float shadow_edge_fade = clamp((dist-actual_shadow_distance*(1.-SHADOW_FADE))/(actual_shadow_distance*SHADOW_FADE),0.,1.);
		sss *= 1.-.3*shadow_edge_fade;
	#endif

	//sss= max(.25,(abs(ipbr_id-10001.)<=.5? 1. :sss));
	//if (sss > 0.01) color.rgb = vec3(1.,0.,0.);
	
	
	
	float main_lighting = sunAngle <.5 ? SUN_BRIGHTNESS : MOON_BRIGHTNESS ;
	
	
	
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
	#else
		#if EXTRA_DARK_NIGHT > 0
			mix(
			texture2D(lightmap, vec2(1./32.,lm.y)).rgb,
			vec3(0.),
			clamp((1.-abs(sunAngle-.75)*4.)*10.,0.,1.)*float(EXTRA_DARK_NIGHT)*.1
			)
		#else
			texture2D(lightmap, vec2(1./32.,lm.y)).rgb
		#endif	
	#endif
	
	
	;
						
						
						
	#if SUNSET == 0
		vec3 sun_color =
		
		#if CUSTOM_SUN_COLOR == 0
			texture2D(lightmap, vec2(1./32.,lmy_og)).rgb //sky_color at lmy_og
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
			texture2D(lightmap, vec2(1./32.,lmy_og)).rgb //sky_color at lmy_og
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
				vec3 sun_color = texture2D(lightmap, vec2(1./32.,lmy_og)).rgb //sky_color at lmy_og
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
						
					
						
						
	#if SHADOWS == 0
		sun_color*=lm.y;
	#endif						
								
						
						
						
	vec4 shadowLightColor=vec4(1.0);
	
	
	//AO handling
	#if PBR > 0					
		#if defined IS_IRIS && defined DISTANT_HORIZONS
			float ao_allowed_light =  
				mix(1.,normals_pixel.z,AMBIENT_OCCLUSSION_TEXTURES)
				*(.5+.5*mix(pow(glcolor.a,VANILLA_AO_EXPONENT),1.,dist/far) );	//fade out vanulla ao for custom to blend with dh
		#else
			float ao_allowed_light =  
				mix(1.,normals_pixel.z,AMBIENT_OCCLUSSION_TEXTURES)
				*(.5+.5*pow(glcolor.a,VANILLA_AO_EXPONENT));	
		#endif
	#else
		float ao_allowed_light = 1.;//pow(glcolor.a,VANILLA_AO_EXPONENT); - it's applied to color
	#endif
		
		
						
	#if PBR > 0
		
				
		//float ao_allowed_light = mix(1.,normals_pixel.z,AMBIENT_OCCLUSSION_TEXTURES);
		normals_pixel.xy=normals_pixel.xy*2.-1.;
		normals_pixel.z = sqrt(1.0-dot(normals_pixel.xy, normals_pixel.xy)); //Reconstruct Z
		
		normals_pixel.xyz =normalize(normals_pixel.xyz );//fsster no norm?
	
	

		vec3 sky_shine = vec3(pow(lmy_og,10.));
		vec3 n_sky_dir = normalize(upPosition);
		
		#if PBR >= 2
		
			
		
		
		
			float metalness = specular_pixel.g>=229.5/255.?1.:0.;
			
			
			
			float sky_dot_face = dot(n_sky_dir,normals_face.xyz);
				//porosity
				float actual_wetness=clamp(sky_shine.r,0.,1.)
				*max(0.,sky_dot_face)
				*wetness * wet_not_dry;
				//wet porosity darkening
				float porosity = specular_pixel.b;
				porosity=porosity>=64.5/255.?0:porosity/64.;

				//puddles 
				#if PUDDLES > 0
					float puddle_n = min(2.*fnoise3d_j(vec3(world_pos.xz,0.) ),1.);
					actual_wetness*= min(1.,puddle_n);
				#endif

				actual_wetness*=1.-.25*porosity;
				specular_pixel.g=mix(specular_pixel.g,1.,
				min(1.,actual_wetness*1.));
				specular_pixel.r =mix(specular_pixel.r,1., min(1.,actual_wetness*2.));
				
				float puddles = sky_dot_face*PUDDLE_DEPTH;
				#if PUDDLES > 0
					puddles*= puddle_n;
				#endif
					normals_pixel.xy=mix(normals_pixel.xy,vec2(0.),min(1.,actual_wetness*1.5*puddles));
				normals_pixel.z = mix(normals_pixel.z,1.,min(1.,actual_wetness*1.5*puddles));
				normals_pixel.xyz= normalize(normals_pixel.xyz);
		#endif
		
        

		#if PMODWATERSHDR != 1 && IS_WATER_SHADER == 1 && WAVE_SHAPE > 0
			if(is_water)
			{
			//	#if THIS_IS_DISTANT_HORIZONS == 1
			//		float time1 = worldTime*.00153*(.7+.3*rainStrength);
			//	#else
					float time1 = worldTime*.003;
			//	#endif
				
				
				#if WAVE_SHAPE == 1
				vec3 ogp = vec3(world_pos.xz
			//	#if THIS_IS_DISTANT_HORIZONS == 1
			//		*.05
			//	#endif
				,time1*10.);
			
			
				float n = fnoise3d_j(ogp-time1*5.  )-.5+
					fnoise3d_j(1.5*ogp+time1*5.);
				float np = .2;
				float n2 = fnoise3d_j(ogp-time1*5.+vec3(np,0.,0.) )-.5+
					fnoise3d_j(1.5*ogp+time1*5.+vec3(np,0.,0.));
				float n3 = fnoise3d_j(ogp-time1*5. +vec3(0.,np,0.) )-.5+
					fnoise3d_j(1.5*ogp+time1*5.+vec3(0.,np,0.));
				#endif	
				
				#if WAVE_SHAPE == 2
					vec2 wp = vec2( fnoise3d_j(vec3(world_pos.xz+time1*1.1,0.)),fnoise3d_j(vec3(world_pos.xz-time1*1.1,0.)) );
				vec3 ogp =  vec3((world_pos.xz+wp)*1.,time1*2.9)
			//	#if THIS_IS_DISTANT_HORIZONS == 1
			//		*.05
			//	#endif
				;
				//vec3 ogp2 = vec3(world_pos.xz*2.+time1*1.1,time1*2.)
				;
				vec3 ogp3 = vec3((world_pos.xz+wp-time1*2.1)*1.,-time1*2.1)
			//	#if THIS_IS_DISTANT_HORIZONS == 1
			//		*.05
			//	#endif
				;
				
				
	
	
				float n = fnoise3d_j(ogp -time1*5. )-.5+
					+fnoise3d_j(1.5*ogp+time1*5.)
					+fnoise3d_j(ogp3  )
					;
					
				float np = .2;
				float n2 = fnoise3d_j(ogp-time1*5. +vec3(np,0.,0.) )-.5+
					+fnoise3d_j(1.5*ogp+time1*5.+vec3(np,0.,0.))
					+fnoise3d_j(ogp3 +vec3(np,0.,0.) )
					;
					
				float n3 = fnoise3d_j(ogp -time1*5.+vec3(0.,np,0.) )-.5+
					+fnoise3d_j(1.5*ogp+time1*5.+vec3(0.,np,0.))
					+fnoise3d_j(ogp3 +vec3(np,0.,0.) )
					;
				#endif

				#if CALM_AND_WIND == 1
					float base_waves = max(1.-abs(.5-sunAngle)*2.,rainStrength*.7);
					float wind = base_waves + (1.-base_waves)*(.5+.5*sin(sunAngle*100.))*clamp((fnoise3d_j(world_pos*.1+time1*5.)-.5)*5,0.,1.);
					n2=mix(n,n2,wind);
					n3=mix(n,n3,wind);
				#endif

				
				if(dist> 0.)
				{
					float big_waves= clamp((dist-0.)/50.,0.,1.);
					vec3 nb;
					vec3 dhwpos = .1 *ogp;
					nb.x = fnoise3d_j(dhwpos-time1*5.  )-.5+
						fnoise3d_j(1.5*dhwpos+time1*5.);
					float npb = .2;
					nb.y = fnoise3d_j(dhwpos-time1*5.+vec3(np,0.,0.) )-.5+
						fnoise3d_j(1.5*dhwpos+time1*5.+vec3(np,0.,0.));
					nb.z = fnoise3d_j(dhwpos-time1*5. +vec3(0.,np,0.) )-.5+
						fnoise3d_j(1.5*dhwpos+time1*5.+vec3(0.,np,0.));
						
					nb*=2.
					#if CALM_AND_WIND == 1
						* base_waves
					#endif
					;
					//nb = mix(vec3(n,n2,n3),nb,big_waves);
					nb+=vec3(n,n2,n3);
					n = nb.x;
					n2 = nb.y;
					n3 = nb.z;
					
				}
				
				
				normals_pixel.xyz = normalize(vec3(n-n2,n-n3,
			//	#if THIS_IS_DISTANT_HORIZONS == 1
			//		1.5
			//	#else
					2.
			//	#endif
				
				
				
				))
				
				
				
				;
				//color.rgb = normals_pixel.xyz;
			}
		#endif
		
	
	
		#if PMODWATERSHDR == 1 && IS_WATER_SHADER == 1

			// color.rgb = vec3(1.,1.,0.);//debug
			WavePixelData physics_waveData;
			//if(is_water)
			//{
				float p_ripple;
				 physics_waveData = physics_wavePixel(physics_localPosition.xz, physics_localWaviness, physics_iterationsNormal, physics_gameTime, p_ripple);
				
				if (!gl_FrontFacing) {
					//physics_waveData.normal = -physics_waveData.normal;
				}
				
				 physics_normal = normalize(
				gl_NormalMatrix * 
				physics_waveData.normal);
				
				
				
				
				
				color = mix(color, vec4(1.), clamp(physics_waveData.foam
				,0.,1.));
				
				//vec2 ocean_uv = (gbufferModelViewInverse * physics_localPosition).xz; //- physics_textureOffset
		
				//color =vec3(texelFetch(physics_waviness, ivec2(ocean_uv.xy) , 0).r);
			
				#if PMODWATERSHDR == 1 && IS_WATER_SHADER == 1
					//	color = vec4(1.,1.,0.,1.);//debug
					
					water_color =  mix(glcolor.rgb,color.rgb,VANILLA_WATER_COLOR) ;
			
					#if SKY_ONLY_REFL == 1
						color.rgb*=VANILLA_WATER_COLOR;
					#endif
			
					vec2 ocean_uv = ( vec4(physics_localPosition,1.)).xz; //- physics_textureOffset
				
						
					#if TIDAL_WAVES >= 1 && PMODWATERSHDR == 1
						//color.rgb =mix(vec3(1.,0.,0.),vec3(0.,0.,1.),pow(physics_localWaviness,.5));
						#if WAVE_RESOLUTION > 0
							vec3 position2 = floor(world_pos)+floor(fract(world_pos)*WAVE_RESOLUTION)/WAVE_RESOLUTION;
						#else
							vec3 position2 = world_pos;
						#endif
						vec4 water_norm = beaching_(position2.xz,physics_localWaviness
						,physics_waveData.foam);
						normals_pixel.xyz=water_norm.xyz;
						 foam = water_norm.a
						#if PMOD_SHALLOW_CHK == 1	
							*physics_area_depth
						#endif
						;
						#if defined DISTANT_HORIZONS
							foam*=1.-clamp((dist-far*.9*(1.-DH_FADE))/(far*.9*DH_FADE),0.,1.);
						#endif
						color.rgb=mix(color.rgb,vec3(1.),
						.7*
						foam
						*pow(1.-(physics_localWaviness-.1)/.9,3.)
						);
													
						color.a = mix(color.a, 1.0, foam);
	
						// frametimecounter workaround
						#if BEACH_TIMING == 1 || CLOUDS == 6
							color.a+= .001*( fract(frameTimeCounter) ); //this line here DOES NOT makes frametimecounter work in "/stuff/fluids/juivy.glsl"
						#endif
				
					#endif
					
			
			
					#if PMODWATERSHDR == 1
						//	color = vec4(1.,1.,0.,1.);//debug
							
					#else		
						//	color = vec4(1.,0.,0.,1.);//debug
					#endif
						
					
				#endif
								
				#if TRANSLUCENT_MODE == 2
					cull_trans(color.a);
				#endif
				
				
				
			//}
		#endif
		
		
		// frametimecounter workaround
		#if BEACH_TIMING == 1 || CLOUDS == 6
			//comment this out and frameTimeCounter returns 0 in function on line 859
			color.a+= .001*( fract(frameTimeCounter) ); //this line makes frametimecounter work in "/stuff/fluids/juivy.glsl"
		#endif
						
		
		#if POM == 0	
			vec3 tangent2 = normalize(cross(tangent.rgb,normals_face.xyz)*tangent.w);
			mat3 tbn_matrix = mat3(tangent.xyz, tangent2.xyz, normals_face.xyz);
		#endif
		normals_pixel.xyz = normalize(tbn_matrix * normals_pixel.xyz); //Rotate by TBN matrix //faster no norm?
		//normals_pixel.z=clamp(normals_pixel.z,0.,1.);
		//normals_pixel.xyz =normalize(normals_pixel.xyz );
			
		float sun_lighting = max(sss,clamp (dot(normalize(shadowLightPosition), normals_pixel.xyz) ,0.,1.)) ;
		
		float sky_lighting = clamp((dot(n_sky_dir,normals_pixel.xyz)+1.)*.5, NON_DIRECTIONAL_AMBIENT_SKY_LIGHT ,1.);//fix?
		
		#if BORDERS >= 2 
			float sun_lighting_back = max(sss,clamp (dot(normalize(shadowLightPosition), 
			normalize( mix(-normals_pixel.xyz,vec3(0.,0.,-1.),0.5) )
			) ,0.,1.)) ;
			float sky_lighting_back = clamp((dot(n_sky_dir,
			normalize( mix(-normals_pixel.xyz,vec3(0.,0.,-1.),0.5) )
			)+1.)*.5, NON_DIRECTIONAL_AMBIENT_SKY_LIGHT ,1.);//fix?
		#endif	
			
			
		#if PMODWATERSHDR == 1 &&  IS_WATER_SHADER == 1
			//if(is_water )
			{
			
				#if TIDAL_WAVES >= 2 && PMODWATERSHDR == 1
					//color.rgb =mix(vec3(1.,0.,0.),vec3(0.,0.,1.),pow(physics_localWaviness,.5));
					//	float tn2=vec3(beaching_(position.xz,physics_localWaviness,physics_waveData.foam).g);
									
				#endif
				
				og_water_intensity= 

				pow(og_water_intensity*.33,.5)//blend my wind ripples in how physics ripples are blended in

				/(og_water_intensity+physics_waveData.height);
						
				normals_pixel.xyz = normalize(mix(
				physics_normal ,//1.-clamp(physics_waveData.height*100.,0.,.99)
				normals_pixel.xyz,
				
				#if defined IS_IRIS && defined DISTANT_HORIZONS
					#if THIS_IS_DISTANT_HORIZONS != 1
						#if SMOOTH_DH_FADE_IN >= 1
							max((clamp((dist-far*(1.-DH_FADE))/(far*DH_FADE),0.,1.)) ,
						#endif	
					#endif
				#endif
				
				
				OG_WAVES
				#if PMOD_SHALLOW_CHK >= 1	
					*(1.-physics_area_depth)
				#endif
				*(1.-p_ripple)*
				max(
				og_water_intensity,
				1.-pow(clamp(physics_waveData.height*10.,0.,1.),2.)
				)
				#if defined IS_IRIS && defined DISTANT_HORIZONS
					#if THIS_IS_DISTANT_HORIZONS != 1
						#if SMOOTH_DH_FADE_IN >= 1
							)
						#endif	
					#endif
				#endif
				));

				/*
					color.rgb = mix(vec3(1.,0.,0.),vec3(0.,0.,1.),OG_WAVES*max(
					og_water_intensity,
					1.-clamp(physics_waveData.height*1000.,0.,1.)
					));//debug
				*/
			}
				
				
		#endif
		
		
		
	#else
		#if SSS >= 1  && SHADOWS > 0
			float sun_lighting=  max(sss,face_shading); //sunlighting wo normals
		#else
			float sun_lighting=  face_shading; //sunlighting wo normals
		#endif
		
	#endif
	
	
	#if IS_WEATHER == 1
		sun_lighting = 1.;
		//color.rgb= texture2D(texture, texcoord).rgb *2. ;//debug
		color.a = color.a>0.7? 1.: color.a>0.1? .3:0.;
		//normals_pixel.rgb = vec3(1.,0.,0.);//
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
		float torch_hand_light = heldBlockLightValue > 0 || heldBlockLightValue2 > 0 ? clamp( 1.-distance( vec3(0.),viewPos.xyz )/ HAND_HELD_TORCH_RANGE ,0.,1.)
		 
		#if TORCH_LIGHT_3D == 1
			*
			(
			(heldBlockLightValue>0?1.:0.) * clamp(dot(normals_pixel.xyz,normalize(vec3(0.5,-.5,1.))),0.0,1.) 
			+
			(heldBlockLightValue2>0?1.:0.) * clamp(dot(normals_pixel.xyz,normalize(vec3(-0.5,-.5,1.))),0.0,1.)
			)
		#endif
		#if TORCH_LIGHT_3D == 2
			*
			(
			(heldBlockLightValue>0?1.:0.) * clamp(dot(normals_pixel.xyz,normalize(-viewPos.xyz-vec3(-TORCH_HORIZONTAL_OFFSET,-TORCH_V_OFFSET,TORCH_Z_OFFSET))),0.0,1.) 
			+
			(heldBlockLightValue2>0?1.:0.) * clamp(dot(normals_pixel.xyz,normalize(-viewPos.xyz-vec3(TORCH_HORIZONTAL_OFFSET,-TORCH_V_OFFSET,TORCH_Z_OFFSET))),0.0,1.)
			)
		#endif
		: 0.0;
		//float torch_hand_light = 0.;
		lm.x=min(1.,lm.x+pow(torch_hand_light,TORCH_FALLOFF));
	#endif
		
	#if CUSTOM_TORCH_COLOR == 0
		vec3 torch_color = 
			vec3(1.,0.9,0.8)*TORCH_BRIGHTNESS;
			//texture2D(lightmap, vec2(lm.x,0.1)).rgb;//
	#endif
	#if CUSTOM_TORCH_COLOR == 1
		vec3 torch_color = 
			vec3(TORCH_HI_R,TORCH_HI_G,TORCH_HI_B)*TORCH_BRIGHTNESS;
			
	#endif
	#if CUSTOM_TORCH_COLOR == 2
		vec3 torch_color = 
			mix(vec3(TORCH_LOW_R,TORCH_LOW_G,TORCH_LOW_B),
			vec3(TORCH_HI_R,TORCH_HI_G,TORCH_HI_B),
			lm.x)*TORCH_BRIGHTNESS
			;
			
	#endif
	
	
	
	#if FLOODFILL_LIGHTING >= 1 || HAND_HELD_TORCH > 0 
			#if CUSTOM_TORCH_COLOR == 0
					//texture2D(lightmap, vec2(lm.x,0.1)).rgb;//
					
				vec3 flashlight = vec3(0.);
				
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
					
				flashlight = flashlight == vec3(0.) ? vec3(1.) : flashlight;
			#endif
			#if CUSTOM_TORCH_COLOR == 1
				
				vec3 flashlight = vec3(0.);
				
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
					
				flashlight = flashlight == vec3(0.) ? vec3(1.) : flashlight;		
					
			#endif
			#if CUSTOM_TORCH_COLOR == 2

				vec3 flashlight = vec3(0.);
				
				flashlight += heldItemId == 10000 || heldItemId2 == 10000 ? 
					mix(vec3(TORCH_LOW_R,TORCH_LOW_G,TORCH_LOW_B),
					vec3(TORCH_HI_R,TORCH_HI_G,TORCH_HI_B),
					pow(torch_hand_light,TORCH_FALLOFF)*BLOCK_LIGHT_BRIGHTNESS)
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
					
				flashlight = flashlight == vec3(0.) ? vec3(1.) : flashlight;				
			#endif
			
			flashlight = pow(torch_hand_light,TORCH_FALLOFF)*flashlight *TORCH_BRIGHTNESS;
			
			/*
			item.10000 = torch jack_o_lantern magma_block lantern blaze_rod lava_bucket camp_fire fire_charge
			item.10001 = soul_torch
			item.10002 = redstone_torch
			item.10008 = glowstone
			*/

		#endif
	
	

	#if IS_THE_NETHER == 1
			torch_color *=2.-1.5* clamp(vec3(1.,2.5,3.)*(1.-world_pos.y*(2.-1.*sin(frameTimeCounter))/100.),0.,1.);
	#endif
	
	
	#if PBR >= 3
		
	#endif
	
	
	#if FLOODFILL_LIGHTING >= 1
		
		if( dist < VOXEL_RADIUS)
		{
			//uniform int frameCounter;
			ivec3 double_buffer_offset = mod(frameCounter,2)==0? ivec3(0,VOXEL_AREA,0):ivec3(0);
			
			#if FLOODFILL_LIGHTING == 1
			vec4 light_color = texture3D(cSampler3_colored_light, 
				vec3(foot_pos2+fract(cameraPosition) +VOXEL_RADIUS+double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)	
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
					vec3 normals_world= normalize(gbufferModelViewInverse * vec4(normals_pixel.xyz,1.)).xyz;
					vec4 light_color = texture3D(cSampler3_colored_light, 
						vec3(foot_pos2+VX_FIRECTIONALITY*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
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
						light_color = mix( mix(rough_dir,dramaric,specular_pixel.r) ,light_color2, sss);
					#endif
					#if DIFFFUSE_VX_BEHAVIOR == 2
						light_color = mix( mix(dramaric,dramaric2,specular_pixel.r) ,light_color2, sss);
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
							if(sss>0.5/255.)
							{
								float eta = 1.-.3*specular_pixel.g;

								normals_world= normalize((gbufferModelViewInverse * vec4(normalize(refract(view_dir.xyz, normals_pixel.xyz,eta)),1.)).xyz-gbufferModelViewInverse[3].xyz);
								vec4 sss_vx = texture3D(cSampler3_colored_light, 
								vec3(foot_pos2+.9*normals_world+fract(cameraPosition) +VOXEL_RADIUS +double_buffer_offset)/vec3(VOXEL_AREA,VOXEL_AREA_X_2,VOXEL_AREA)
								);	
								sss_vx=mix(light_color2, clamp(sss_vx-light_color2*.8,0.,1.)*2. , specular_pixel.g );
								light_color_spec.rgb +=sss_vx.rgb* sss*mix(vec3(1.),color.rgb,max(0.,color.a-sss));
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
			
			float torch_fade = clamp(((dist/VOXEL_RADIUS)-.8)*5.,0.,1.);
			
			torch_color= mix(
				#if VOXEL_PHOTON_SIMULATION_QUALITY < 2 
					lm.x*
				#endif
				light_color.rgb*BLOCK_LIGHT_BRIGHTNESS,
				lm.x*torch_color,
				torch_fade) ;
		}else{
			torch_color=lm.x*torch_color;
		}
	#else
		
		torch_color=lm.x*torch_color;
	#endif
	
	
	//pre-reflections
	#if TINT_METALS == 1
		vec3 albedo = color.rgb;
		vec3 pre_reflection = light_color_spec.rgb * mix(1.,BLOCK_LIGHT_BRIGHTNESS_IN_DAYLIGHT,lm.y* pow(max(0.,1.-abs(sunAngle-.25)*4.),.2) )
				*BLOCK_LIGHT_BRIGHTNESS;
	#endif
	
	#if PBR == 0 || DIRECTIONAL_LIGHTING == 0
		color.rgb*= glcolor.a; //4-2025
	#endif
				
	#if PMODWATERSHDR == 1 && SKY_LIGHT_FALLOFF == 1
		#if PBR > 0
			sky_shine=vec3(0.);
		#endif
	#endif
			
			
			
			
	#if SHADOWS >= 1
		vec4 ambient_lighting = 
		vec4(
		#if PBR > 0
				ao_allowed_light*
				(lm.y*sky_color*sky_lighting 
				+//lm.x*
				torch_color)
			#else
				lm.y*sky_color
				+//lm.x*
				torch_color
			#endif
			,sss)
		;
	#else
		vec4 ambient_lighting = 
		vec4(
		lm.y*sky_color
			+//lm.x*
			torch_color
			,sss);
	#endif
	
	
	#if CLOUD_SHADOWS == 1
		float cloud_shadows_light =1.- min( 1., cloud_shadow(world_pos) );
				sky_color*=cloud_shadows_light ;
			#endif
	
	#if SHADOWS >= 1
		
		#if SSS == 0
		if (face_shading > 0.0) //surface is facing towards shadowLightPosition
		#endif
		{
			#include "/shadows.glsl"
			#if CLOUD_SHADOWS == 1
			shadowLightColor*=cloud_shadows_light ;
				
			#endif
			
		}
		
		#if BRIGHTER_UNDERWATER == 1
			sky_color*=isEyeInWater > 0 ? main_lighting  : 1.0;
		#endif
				
		#if FIX_COLOR_SPACE == 1
			color.rgb=pow(color.rgb,vec3(2.2));
		#endif
		#include "/pbr2.glsl"
		
		#if PBR >= 2
		
			color.a = 	min(
		color.a+sparkle_opacity,1.);
			
		#endif 
		
		color.rgb = 	
		#if PBR >= 2
			//emmissi9n
			color.rgb*specular_pixel.a*PBR_EMMISSIVE_STRENGTH+
			sun_shine+sky_shine+
			#if COLORED_LIGHT_SPEC == 1 && PBR >= 2
				light_color_spec.rgb * mix(1.,BLOCK_LIGHT_BRIGHTNESS_IN_DAYLIGHT,lm.y* pow(max(0.,1.-abs(sunAngle-.25)*4.),.2) )
				*BLOCK_LIGHT_BRIGHTNESS +
			#endif 
		#endif 
		color.rgb* max(
		#if IS_THE_NETHER == 1
			clamp(max(vec3(MINIMUM_LIGHT_LEVEL),vec3(1.,0.9,0.7)-vec3(1.,2.5,3.)*world_pos.y*(2.+1.*sin(frameTimeCounter))/100.),0.,1.)
		#else
			vec3(MINIMUM_LIGHT_LEVEL)
		#endif
		
		
		,

		sun_lighting*		

		sun_color*
		 shadowLightColor.rgb*main_lighting
		+
		ambient_lighting.rgb
		#if REFLECTION_DETAIL == 5
			*0.
		#endif
		)
		;
	#else
		#if FIX_COLOR_SPACE == 1
			color.rgb=pow(color.rgb,vec3(2.2));
		#endif
		#include "/pbr2.glsl"
		
		#if PBR >= 2
		
			color.a = 	min(
		color.a+sparkle_opacity,1.);
			
		#endif 
		color.rgb = 	
		#if PBR >= 2
			//emmissi9n
		color.rgb*specular_pixel.a*PBR_EMMISSIVE_STRENGTH+
			sun_shine+sky_shine+
			#if COLORED_LIGHT_SPEC == 1 && PBR >= 2
				light_color_spec.rgb * mix(1.,BLOCK_LIGHT_BRIGHTNESS_IN_DAYLIGHT,lm.y* pow(max(0.,1.-abs(sunAngle-.25)*4.),.2) )
				*BLOCK_LIGHT_BRIGHTNESS +
			#endif 
			
		#endif 
		color.rgb* max(
		#if IS_THE_NETHER == 1
				clamp(max(vec3(MINIMUM_LIGHT_LEVEL),vec3(1.,0.9,0.7)-vec3(1.,2.5,3.)*world_pos.y*(2.+1.*sin(frameTimeCounter))/100.),0.,1.)
		#else
			vec3(MINIMUM_LIGHT_LEVEL)
		#endif
		,

		
		
		#if DIRECTIONAL_LIGHTING == 1 
	
				sun_lighting*
	
			
			main_lighting
		#else 
			
			main_lighting
		#endif
		*sun_color
		+
	
			ambient_lighting.rgb
			#if REFLECTION_DETAIL == 5
				*0.
			#endif

		
		);
		;
		
			
		

	
//	color.rgb=vec3(1.,0.,0.);//normals_pixel.xyz*.5+.5;//debug
	
	#endif

	
	
	#if IS_WATER_SHADER == 1
		
		 #if PMODWATERSHDR != 1
			 vec3 water_color;
			 if(is_water)
			{
				water_color =   mix(glcolor.rgb,color.rgb,VANILLA_WATER_COLOR) ;
				color.rgb =  mix(glcolor.rgb,color.rgb,VANILLA_WATER_COLOR) ;
			}else{
				water_color = 
				color.rgb;
			}
			
		 #endif
		#if CLOUDS >= 0 && IS_THE_NETHER != 1
			#if REFLECTION_DETAIL > 0
				float cloud_depth = 0.;
				
				vec4 world_dir = vec4(reflect(normalize(viewPos.xyz
					//-gbufferModelViewInverse[3].xyz//(gbufferModelView*vec4(gbufferModelViewInverse[3].xyz,1.)).xyz
					),
					normals_pixel.xyz
				//(gbufferModelViewInverse*vec4(normals_pixel.xyz,1.)).xyz
				),1.);
				world_dir.xyz =   
							//gbufferModelViewInverse*vec4(world_dir.xyz,1.);
				 normalize((gbufferModelViewInverse*vec4((world_dir.xyz), 1.)).xyz-gbufferModelViewInverse[3].xyz);
				
				//	vec3 wp = (gbufferModelViewInverse*vec4(viewPos.xyz-gbufferModelViewInverse[3].xyz,1.)).xyz;
				//vec3 wn = (gbufferModelViewInverse*vec4(normals_pixel.xyz,1.)).xyz;
				
		
				
				//	world_dir = vec4(reflect(normalize(wp.xyz),wn),1.);
				//vec3 raywdir = normalize((gbufferModelViewInverse*vec4((ray_goal.xyz), 1.)).xyz-gbufferModelViewInverse[3].xyz);
		
				
				
				
				//world_dir = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
				//world_dir = gbufferProjectionInverse * world_dir;
				
				#if SKY_ONLY_REFL == 1
					#if REFLECTION_DETAIL >= 22
						vec4 cloudsq =  clouds_refl(
						
						world_dir
						,cloud_depth) ;
					#else
						vec4 cloudsq = vec4(0.);
					#endif
				
					float foam_refl_null = pow(
					#if THIS_IS_DISTANT_HORIZONS != 1 
						foam
					#else
						0.
					#endif
					,7.);
				

					//sky_color_pixel 
				
					
					cloudsq.rgb= mix(
					//vec3(1.,0.,0.)
			
						 calcSkyColor_w(world_dir.xyz).rgb
			
					
					//*(1.+clamp(1.-abs(sunAngle-(sunAngle<.25? .0 : 1.))*22.,0.,1.))
					,cloudsq.rgb,cloudsq.a)
					*(1.-.1*foam_refl_null)
					*(lmy_og-1./32.)/(30./32.)
					;

					float wfres =  min(229./255.,WATER_F0+(1.-WATER_F0)*pow(clamp((1.-dot(normalize(-viewPos.xyz),normals_pixel.xyz))*1.,0.0,1.),WATER_FRESNEL_CURVE) )
					*(1.-.7*
					foam_refl_null)
					;
					
					
				
					color.rgb= mix(color.rgb,
					cloudsq.rgb
					,wfres*(1.-.9*foam)
					);
					
					//1.//cloudsq.a
					
					if(is_water)
					{	
						color.a = max(
						#if THIS_IS_DISTANT_HORIZONS != 1 
							foam
						#else
							0.
						#endif
						,
						min(wfres+foam,1.)
						);
					}	
			
				#endif
			
			#endif
			
			
			
			
	

		#endif

	#endif
	


		
		
			
	//color.rgb = vec3(1.,0.,0.);//debug
	#if PMODWATERSHDR == 1
		//color.rgb = vec3(1.,1.,0.);//debug
		
	#endif

	
	#if REFRACTIONS < 1 
		color.rgb*=isEyeInWater== 1 ? clamp( vec3(1.)-vec3(4.,1.,0.)*dist/WATER_COLOR_ABSORB_DIST,0.,1. ) : vec3(1.0);
	#endif
	
	#if SHOW_MOB_DAMAGE == 1 && IS_AN_ENTITY == 1
		color.rgb= mix(color.rgb,entityColor.rgb,entityColor.a);
	#endif
	
	#if IS_WEATHER == 11
		color.rgb= texture2D(texture, texcoord).rgb *2. ;//debug
		color.a = color.a>0.7? 1.: color.a>0.1? .5:0.;
		//normals_pixel.rgb = vec3(1.,0.,0.);//
	#endif
		#if DONT_BLOW_OUT_WHITES == 1
		color.r = color.r <.95?color.r : .95+(color.r-.95)*.1;
		color.g = color.g <.95?color.g : .95+(color.g-.95)*.1;
		color.b = color.b <.95?color.b : .95+(color.b-.95)*.1;
	#endif
	
	#if FOG == 1 
		float water_fog = isEyeInWater == 1 ? WATER_VISIBILITY : isEyeInWater == 2? 20. : isEyeInWater == 1? 10. : 0.;
		water_fog = (water_fog > 1. ) ? clamp((dist)/water_fog,0.,1.) : 0.;
		//fogColor FOG_START FOG_END
		#if defined IS_IRIS
			#if defined DISTANT_HORIZONS
				float border_fog_amount = pow(1.-1./dist,DH_FOG_EXPONENT);
			#else
				float border_fog_amount = clamp((dist-(BORDER_FOG_START*far1))/(((1.-BORDER_FOG_START)*far1)),0.,1.);
			#endif
		#else
			float border_fog_amount = clamp((dist-(BORDER_FOG_START*far1))/(((1.-BORDER_FOG_START)*far1)),0.,1.);
		#endif
			
			bool looking_out = isEyeInWater > 0  && !is_water;
			
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
				
				#if VANILLA_SUNSETS == 0
					vec4 world_dir2 = vec4(normalize(viewPos.xyz),1.);
					world_dir2 =   gbufferModelViewInverse*world_dir2-gbufferModelViewInverse[3];
					
					color.rgb = mix(color.rgb,
			
					( isEyeInWater > 0 && !looking_out ? fogColor.rgb : 
						calcSkyColor_w(vec3(world_dir2.x,0.,world_dir2.z))
					)
					
					*float(eyeBrightnessSmooth.y)/240., (looking_out? 0. : fog_amount) );
				
				#else
					color.rgb = mix(color.rgb, fogColor.rgb
					*(isEyeInWater == 1?float(eyeBrightnessSmooth.y)/240.,fog_amount) : 1.);
				#endif
			
			
			
			
	#endif
	
	
	

	
	//color.rgb = vec3( lm.x ) ;//debug
	
	
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
				ao_allowed_light*
				(clamp((lm.y*skyColor*sky_lighting_back -lm.y*skyColor,0.)*5.,0.,1.)*0.
					+//lm.x*
					torch_color)
			#else
				clamp((lm.y*skyColor *sky_lighting_back -lm.y*skyColor)*5.,0.,1.)*0.
				+//lm.x*
				torch_color
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

	#if DEBUG_MODE == 3
		debugdata3=normals_pixel.xyz*.5+.5;
	#endif
	
	#if DEBUG_MODE > 0
		color.rgb=debugdata3;
	#endif




#endif //debug


	
		#if IS_THE_NETHER == 1
			//color.rgb=vec3(fract(world_pos.y));
		#endif

#if IS_WATER_SHADER == 11 
	//waterfog
	#if THIS_IS_DISTANT_HORIZONS == 1
//		float lin_c_wd = linearize_water_d(gl_FragCoord.z, dhNearPlane, dhFarPlane);
		float lin_c_wd = linearize_depth_cpf_dh(gl_FragCoord.z);
	#else
//		float lin_c_wd = linearize_water_d(gl_FragCoord.z, near, far*4.);
		float lin_c_wd = linearize_depth_cpf2(gl_FragCoord.z);
	#endif
	
	float opaque_depth =
	#if defined IS_IRIS && defined DISTANT_HORIZONS
		min(
		linearize_depth_cpf_dh(texelFetch(dhDepthTex1,ivec2(gl_FragCoord.xy),0).r)
		,
	#else
		(
	#endif
	linearize_depth_cpf2(texelFetch(depthtex1,ivec2(gl_FragCoord.xy),0).r)
	);
	
	opaque_depth = get_underwater_depth_at(gl_FragCoord.xy/vec2(viewWidth,viewHeight) );
	
	//opaque_depth = opaque_depth < 0.01? 9999. : opaque_depth;
	
	float water_fog2 = 
	is_water ? 
	clamp((opaque_depth-lin_c_wd)/WATER_VISIBILITY,0.,1.) 
	:
	#if IS_BEACON_BEAM == 1
		clamp(.015*(opaque_depth-lin_c_wd),0.,.7) 
	#else
		clamp(.015*(opaque_depth-lin_c_wd),0.,.1) 
	#endif
	
	;
	
	
	water_fog2=0.;//debug 4-2025
	
	
	//water_fog2=clamp(water_fog2/WATER_VISIBILITY,0.,1.);
	
	color.rgb = mix(color.rgb,water_color.rgb
	//	*.5
	//	*.0+vec3(1.,0.,0.)
	//*(1,-water_fog2)
	*sun_color
	//*mix(1.,lmy_og*(1.-pow(water_fog2,2.)),.5)
	, (1.-color.a)*water_fog2)
	;
	color.a+=(1.-color.a)*water_fog2;
	
//	color = vec4(vec3(fract(opaque_depth*.1)),1.);//debug
	#if THIS_IS_DISTANT_HORIZONS == 1		
//		color.b = 0.;
	#endif

#endif



//color.rgb =  abs(ipbr_id-10020.5)<=1.? vec3(1.,0.,0.) : color.rgb ;//debug
//color =vec4(fract(world_pos.xyz*.01),1.);



//if(metalness > .9) color.rgb  = vec3(1.);//debug


#if IS_PARTICLE == 1
//color.a=vec3(1.,0.,0.);//debug
#endif



	#if REFLECTION_DETAIL >= 5
	//pbr reflections
	
		//gl_FragData[2] = vec4(smoothness,reflective_strength,(abs(material_id-10006.) < .5?1.:0.) ,f0); 
		float smoothness = specular_pixel.r;
		//calculate fresnel, for how strong reflection will be
		//float fresnel = pow(1.-max(0., dot(normals_pixel.xyz,normalize(viewPos.xyz)) ) ,FRESNEL_EXPONENT);
		
		float reflective_strength = f0+(1.-f0)*fresnel;
	
		/*
		float wfres =  min(229./255.,WATER_F0+(1.-WATER_F0)*pow(clamp((1.-dot(normalize(-viewPos.xyz),normals_pixel.xyz))*1.,0.0,1.),WATER_FRESNEL_CURVE) )
					*(1.-.7*
					foam_refl_null)
					;
					*/
	
	
		

					//gl_FragData[3] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 




		#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
			#if REMOVE_REFLECTION_JITTER== 1
				/*
					const int colortex2Format = RGBA16F;
				*/
			#endif
			#if IS_WATER_SHADER == 1 &&  REFRACTIONS == 1
				
				
				
				//pre-reflections
				#if TINT_METALS == 1 
					gl_FragData[4] = vec4(albedo,1.); 
					gl_FragData[5] = vec4(pre_reflection,fog_amount); 
							
					#if IS_HAND == 1 || IS_WEATHER == 1
						/* RENDERTARGETS: 3,1,2,8,4,10 */
					#else
						/* RENDERTARGETS: 7,1,2,8,4,10 */
					#endif		
					gl_FragData[3] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 
					
				#else
				
					#if IS_HAND == 1 || IS_WEATHER == 1
						/* RENDERTARGETS: 3,1,2,8 */
					#else
						/* RENDERTARGETS: 7,1,2,8 */
					#endif		
					gl_FragData[3] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 
				
				#endif
				
			#else
					
				//pre-reflections
				#if TINT_METALS == 1 
					
					#if REFLECTION_DETAIL >= 3
						#if (IS_HAND == 1 || IS_WEATHER == 1)  &&  REFRACTIONS == 1
							/* RENDERTARGETS: 3,1,2,8,4,10,11 */
						#else
							/* RENDERTARGETS: 5,1,2,8,4,10,11  */
						#endif	
						gl_FragData[3] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 
						gl_FragData[2] = vec4(normals_pixel.xyz*.5+.5,(abs(ipbr_id-10020.5)<=1.? 1. : 0.1));;
						
						gl_FragData[4] = vec4(albedo,1.); 
						gl_FragData[5] = vec4(pre_reflection,fog_amount); 
						gl_FragData[6] = vec4(ambient_lighting); 
				
					#else
						#if (IS_HAND == 1 || IS_WEATHER == 1)  &&  REFRACTIONS == 1
							/* RENDERTARGETS: 3,1,8  */
						#else
							/* RENDERTARGETS: 5,1,8  */
						#endif	
						gl_FragData[2] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 

					#endif
				
				#else
					
					#if REFLECTION_DETAIL >= 3
						#if (IS_HAND == 1 || IS_WEATHER == 1)  &&  REFRACTIONS == 1
							/* RENDERTARGETS: 3,1,2,8 */
						#else
							/* RENDERTARGETS: 5,1,2,8 */
						#endif	
						gl_FragData[3] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 
						gl_FragData[2] = vec4(normals_pixel.xyz*.5+.5,(abs(ipbr_id-10020.5)<=1.? 1. : 0.1));;
					#else
						#if (IS_HAND == 1 || IS_WEATHER == 1)  &&  REFRACTIONS == 1
							/* RENDERTARGETS: 3,1,8 */
						#else
							/* RENDERTARGETS: 5,1,8 */
						#endif	
						gl_FragData[2] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 
					#endif
				
				#endif
					
			
			#endif
			
			gl_FragData[0] = color;
			gl_FragData[2] = vec4(normals_pixel.xyz*.5+.5,(abs(ipbr_id-10020.5)<=1.? 1. : 0.1));;
			/*
				const int colortex1Format = R16F;
			*/
			gl_FragData[1].x = 
			#if POM == 1
				pom_depth_forward +
			#endif
			//abs(ipbr_id-10020.5)<=1.? 0.:
			#if IS_HAND == 1 
				-viewPos.z 
			#else
				
				//distance(vec3(0.),viewPos.xyz)
				-viewPos.z //doesn't fight linnear flat plane based depth in refractions
			#endif
			; 
		#else

			#if IS_WATER_SHADER == 1 &&  REFRACTIONS == 1
			
				//pre-reflections
				#if TINT_METALS == 1 
					gl_FragData[3] = vec4(albedo,1.); 
					gl_FragData[4] = vec4(pre_reflection,fog_amount); 
					gl_FragData[5] = vec4(ambient_lighting); 
					
					#if IS_HAND == 1 || IS_WEATHER == 1
						/* RENDERTARGETS: 3,2,8,4,10,11 */
					#else
						/* RENDERTARGETS: 7,2,8,4,10,11  */
						gl_FragData[2] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 
					#endif	
					gl_FragData[1] = vec4(normals_pixel.xyz*.5+.5,(abs(ipbr_id-10020.5)<=1.? 1. : 0.1));;
				#else
				
					#if IS_HAND == 1 || IS_WEATHER == 1
						/* RENDERTARGETS: 3,2,8 */
					#else
						/* RENDERTARGETS: 7,2,8 */
						gl_FragData[2] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 
					#endif	
					gl_FragData[1] = vec4(normals_pixel.xyz*.5+.5,(abs(ipbr_id-10020.5)<=1.? 1. : 0.1));;
				#endif				
					
				
				
			#else
			
				//pre-reflections
				#if TINT_METALS == 1 
					
				
					#if (IS_HAND == 1 || IS_WEATHER == 1)  &&  REFRACTIONS == 1
						/* RENDERTARGETS: 3,8,4,10,11 */
						gl_FragData[1] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 
						gl_FragData[2] = vec4(albedo,1.); 
						gl_FragData[3] = vec4(pre_reflection,fog_amount); 
						gl_FragData[4] = vec4(ambient_lighting); 
					#else
						#if REFLECTION_DETAIL >= 3
							/* RENDERTARGETS: 5,2,8,4,10,11  */
							gl_FragData[1] = vec4(normals_pixel.xyz*.5+.5,(abs(ipbr_id-10020.5)<=1.? 1. : 0.));;
							gl_FragData[2] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 
							
							gl_FragData[3] = vec4(albedo,1.); 
							gl_FragData[4] = vec4(pre_reflection,fog_amount);
							gl_FragData[5] = vec4(ambient_lighting);							
						#else
							/* RENDERTARGETS: 5,8  */
							gl_FragData[1] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 
	
						#endif
						
					#endif	

				#else
					#if (IS_HAND == 1 || IS_WEATHER == 1)  &&  REFRACTIONS == 1
						/* RENDERTARGETS: 3,8 */
						gl_FragData[1] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 
						
					#else
						#if REFLECTION_DETAIL >= 3
							/* RENDERTARGETS: 5,2,8 */
							gl_FragData[1] = vec4(normals_pixel.xyz*.5+.5,(abs(ipbr_id-10020.5)<=1.? 1. : 0.));;
							gl_FragData[2] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 
						#else
							/* RENDERTARGETS: 5,8 */
							gl_FragData[1] = vec4(smoothness,reflective_strength,(abs(ipbr_id-10020.) < .5?1.:0.1) ,f0); 
						#endif
						
					#endif	
				
				#endif				
					
				
				
			#endif

			
			gl_FragData[0] = color; 
		#endif
		
	
		
		
		
		
	#else
	//no pbr reflections
		#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
			#if REMOVE_REFLECTION_JITTER== 1
				/*
					const int colortex2Format = RGBA16F;
				*/
			#endif
			#if IS_WATER_SHADER == 1 &&  REFRACTIONS == 1
				#if IS_HAND == 1 || IS_WEATHER == 1
					/* RENDERTARGETS: 3,1,2 */
				#else
					/* RENDERTARGETS: 7,1,2 */
				#endif		
			#else
				#if REFLECTION_DETAIL >= 3
					#if (IS_HAND == 1 || IS_WEATHER == 1)  &&  REFRACTIONS == 1
						/* RENDERTARGETS: 3,1,2 */
					#else
						/* RENDERTARGETS: 5,1,2 */
					#endif	
					gl_FragData[2] = vec4(normals_pixel.xyz*.5+.5,(abs(ipbr_id-10020.5)<=1.? 1. : 0.1));;
				#else
					#if (IS_HAND == 1 || IS_WEATHER == 1)  &&  REFRACTIONS == 1
						/* RENDERTARGETS: 3,1 */
					#else
						/* RENDERTARGETS: 5,1 */
					#endif	
				#endif
			
			#endif
			
			gl_FragData[0] = color;
			gl_FragData[2] = vec4(normals_pixel.xyz*.5+.5,(abs(ipbr_id-10020.5)<=1.? 1. : 0.1));;
			/*
				const int colortex1Format = R16F;
			*/
			gl_FragData[1].x = 
			#if POM == 1
				pom_depth_forward +
			#endif
			//abs(ipbr_id-10020.5)<=1.? 0.:
			#if IS_HAND == 1 
				0.
			#else
				
				//distance(vec3(0.),viewPos.xyz)
				-viewPos.z //doesn't fight linnear flat plane based depth in refractions
			#endif
			; 
		#else

			#if IS_WATER_SHADER == 1 &&  REFRACTIONS == 1
				#if IS_HAND == 1 || IS_WEATHER == 1
					/* RENDERTARGETS: 3,2 */
				#else
					/* RENDERTARGETS: 7,2 */
				#endif	
				gl_FragData[1] = vec4(normals_pixel.xyz*.5+.5,(abs(ipbr_id-10020.5)<=1.? 1. : 0.1));;
			#else
				#if (IS_HAND == 1 || IS_WEATHER == 1)  &&  REFRACTIONS == 1
					/* RENDERTARGETS: 3 */
					
				#else
					#if REFLECTION_DETAIL >= 3
						/* RENDERTARGETS: 5,2 */
						gl_FragData[1] = vec4(normals_pixel.xyz*.5+.5,(abs(ipbr_id-10020.5)<=1.? 1. : 0.1));;
					#else
						/* RENDERTARGETS: 5 */
					#endif
					
				#endif	
				
			#endif

			
			gl_FragData[0] = color; 
		#endif
		
	
	#endif
		//gl_FragData[1] = edge_colors; 

}