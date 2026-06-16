#version 430 compatibility
#include "/settings.glsl"

uniform sampler2D texture;
#if defined IS_IRIS && defined DISTANT_HORIZONS 
	uniform sampler2D dhDepthTex0 ;
#endif

varying vec2 texcoord;
varying vec4 glcolor;
#if CLOUD_FOG == 1 || (defined IS_IRIS && defined DISTANT_HORIZONS  )
	varying vec4 viewPos;
#endif

uniform float far;
uniform float near;

uniform float rainStrength;
uniform vec3 skyColor;



#if defined IS_IRIS && defined DISTANT_HORIZONS 
	uniform float dhNearPlane;
	uniform float dhFarPlane;
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


void main() {

	vec4 color = texture2D(texture, texcoord) * glcolor;
	
	
	#if defined IS_IRIS && defined DISTANT_HORIZONS  
				

				//vec2 screencoord = ((gl_FragCoord.xy))*texelSize;
				float od = texelFetch(dhDepthTex0 ,ivec2(gl_FragCoord.xy),0).r;
				float old_d = abs(linearize_depth_dh(od));

				float new_d =-viewPos.z;// linearize_depth((gl_FragCoord.z));
				if (od < 1. && old_d < new_d )//|| new_d < far*.9)
				{
					discard;
					return;
		
				}
				
			//color.rgb = fract(vec3( new_d /far)*1.);	
	#endif

	
	#if CLOUD_FOG == 1
	float dist = distance(viewPos.xyz,vec3(0.));
		
		//fogColor FOG_START FOG_END
			float far1 = far*4.;
			float border_fog_amount = clamp((dist-(BORDER_FOG_START*far1))/(((1.-BORDER_FOG_START)*far1)),0.,1.);
			
			float fog_amount = 
				clamp(

				max( 
					.1*clamp((dist-FOG_START)/(FOG_END-FOG_START),0.,FOG_MAX),
					border_fog_amount)
					*(1.+rainStrength)
					
				,0.,1.)
				;
				/*
				*/
			//color.rgb = mix(color.rgb,skyColor,fog_amount);
			color.a = mix(color.a,0.,fog_amount);
			
	#endif
/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}