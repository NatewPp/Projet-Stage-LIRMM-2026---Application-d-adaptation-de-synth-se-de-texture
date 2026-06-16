#version 120
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
#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif
#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
uniform float nightVision;
uniform float blindness;
uniform float darknessFactor;

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


uniform vec3 fogColor;
#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
uniform mat4 gbufferModelView;

float fogify(float x, float w) {
	return clamp((1.-x-.3)/.6,0.,1.);
	return w / (x * x + w);
}

vec3 addcalcSkyColor(vec3 color,float upDot) {
	
	return mix(color, fogColor, fogify(max(upDot, 0.0), 0.1));
}



void main() {

	vec4 color = texture(texture, texcoord) * glcolor;
	
	
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

	vec4 pos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
		pos = gbufferProjectionInverse * pos;
	float upDot = dot(pos.xyz, gbufferModelView[1].xyz); //not much, what's up with you?
	//color.rgb = addcalcSkyColor(color.rgb,upDot);
	
	#if CLOUD_FOG == 1
	float dist = distance(viewPos.xyz,vec3(0.));
		
		//fogColor FOG_START FOG_END
			float far1 = far*2.7;
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
			color.rgb = mix(color.rgb,fogColor,.25);
			
			
			color.a = mix(color.a,0.,max( pow(fog_amount,.7),  0.*clamp((1.-upDot-.3)/.4,0.,1.) ) );
			
	#endif
	
	
	
	
	#if NIGHT_VISION_MODE == 1
		//Gamma based when no composite
			//uniform float nightVision;
		#if BORDERS == 0 && GODRAYS == 0 && CLOUDS == 0
			color.rgb = pow(color.rgb,vec3(1.-.5*nightVision));
		#endif
	#endif
	
	#if NIGHT_VISION_MODE == 2
		//Thermal Vision
		if(nightVision>0.)
		{
			float nv_effect = 1.-pow(min(1.,distance(gl_FragCoord.xy,vec2(viewWidth,viewHeight)*.5)/(.5*viewWidth)),3.);
			
			color.rgb  = mix(color.rgb,vec3(0.,0.,.5), max(nightVision,nv_effect));
		}
	#endif
	
float darkness = min(1.,blindness + darknessFactor);
color.rgb *=1.-darkness ;

	
/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}