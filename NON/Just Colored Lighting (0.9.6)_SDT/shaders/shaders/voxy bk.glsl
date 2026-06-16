/*
struct VoxyFragmentParameters {
    vec4 sampledColour;
    vec2 tile;
    vec2 uv;
    uint face;
    uint modelId;
    vec2 lightMap;
    vec4 tinting;
    uint customId;//Same as iris's modelId
};


The uniforms that are added to iris are as follows:
vxRenderDistance (int) in chunks
vxViewProj 
vxViewProjInv
vxViewProjPrev
vxModelView
vxModelViewInv
vxModelViewPrev
vxProj
vxProjInv
vxProjPrev


one such way of getting the face normal from voxy is by
vec3 normal = vec3(uint((face>>1)==2), uint((face>>1)==0), uint((face>>1)==1)) * (float(int(face)&1)*2-1);


nearplane is 16, farplane is 16*3000

#if defined VOXY 
*/


#define gbufferProjection vxProj
#define gbufferProjectionInverse vxProjInv
#define gbufferPreviousProjection vxProjPrev
#define gbufferModelView vxModelView
#define gbufferModelViewInverse vxModelViewInv
#define vxModelView vxModelViewPrev


layout(location = 0) out vec4 gl_FragData_0;
layout(location = 1) out vec4 gl_FragData_1;





#include "/noise.glsl"
#include "/stuff/noise/noise_texture.glsl"
#include "/distort.glsl"
#include "/check_shadow_depth.glsl"
#include "/licensed/spaceConversions.glsl"

float far1 = 16.*3000.*DH_FOG_END;



void voxy_emitFragment(VoxyFragmentParameters params) {
 

//if (texture(depthtex0, gl_FragCoord.xy / resolution).r < 1.0) discard;


/*        varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec4 viewPos;
//EXTEND_LAVA_PATTERN == 1	varying vec3 world_pos;
varying float ipbr_id;



	varying  vec4 vlocal_uv_components;//CTMPOMFIX
	varying  vec4 vlocal_uv;//CTMPOMFIX

varying vec3 normals_face;
	varying vec4 tangent;
*/

//varyings replaced
vec3 normals_face = vec3(uint((face>>1)==2), uint((face>>1)==0), uint((face>>1)==1)) * (float(int(face)&1)*2-1);
  vec3 viewPos = screenSpaceToViewSpace(
      gl_FragCoord.xyz / vec3(viewWidth, viewHeight, 1.0)
    );
 vec2 lmcoord = params.lightMap;
vec4 glcolor=parameters.tinting;

//main shader code

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


float dist = distance(vec3(0.),viewPos.xyz);



         vec4 color = parameters.sampledColour;
         color.rgb *= parameters.tinting.rgb;



#if FOG == 1 
		float water_fog = isEyeInWater == 1? WATER_FOG_DISTANCE : isEyeInWater == 2? 20. : isEyeInWater == 1? 10. : 0.;
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
				
			color.rgb = mix(color.rgb,fogColor
				#if CAVE_LIGHT_LEAK_FIX_SKY == 1 && IS_THE_NETHER != 1 && IS_THE_END != 1
					*cave_light_leak_fix_sky
				#endif
				,fog_amount);
			
	#endif
	


		/* RENDERTARGETS: 0,1 */
		gl_FragData_0 = color;
		/*
			const int colortex1Format = R16F;
		*/
      	#if BORDERS_IN_DH == 1
		    gl_FragData_1.x = 
		    //abs(ipbr_id-10020.)<=.5? 0.:
		    dist
		    #if POM == 1
			    +pom_depth_forward
		    #endif
		    ; 
        #endif

}
