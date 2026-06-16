#version 120
#include "/settings.glsl"

#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif
#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
uniform mat4 gbufferModelView;
#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform float nightVision;
uniform float blindness;
uniform float darknessFactor;
#if FOG_BY_HEIGHT == 1 || CAVE_LIGHT_LEAK_FIX_SKY == 1
	#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif
#endif
		
#if CLOUDS == 22
	uniform int worldTime;
	//#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
	#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
	#include "/clouds.glsl"
#endif

varying vec4 starData; //rgb = star color, a = flag for weather or not this pixel is a star.

const float sunPathRotation = 0.0; //[-90.0 -80.0 -70.0 -60.0 -50.0 -40.0 -30.0 -20.0 -10.0 0.0 10.0 20.0 30.0 40.0 50.0 60.0 70.0 80.0 90.0]

float fogify(float x, float w) {
	return clamp((1.-x-.3)/.55,0.,1.);
	return w / (x * x + w);
}

vec3 calcSkyColor(vec3 pos) {
	float upDot = max(0., dot(pos, gbufferModelView[1].xyz)); 
	
	return mix(skyColor, fogColor, fogify(
		#if FOG_BY_HEIGHT == 1
			pow(upDot,1.-clamp( (cameraPosition.y-SEA_LEVEL)/SKY_HEIGHT,0.,.9) )
		#else
			upDot
		#endif
		
	, 0.25));
}

#if CAVE_LIGHT_LEAK_FIX_SKY == 1
	uniform ivec2 eyeBrightnessSmooth;
	uniform ivec2 eyeBrightness;
	
#endif

void main() {
	vec3 color;
	if (starData.a > 0.5) {
		color = starData.rgb;
	}
	else {
		vec4 pos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
		pos = gbufferProjectionInverse * pos;
		#if CLOUDS == 22
			color=clouds(vec2(gl_FragCoord.xy / vec2(viewWidth, viewHeight))).rgb;
		#else
			color = calcSkyColor(normalize(pos.xyz));
		#endif
		
	}

#if FIX_COLOR_SPACE == 1
	//color.rgb=pow(color.rgb,vec3(GAMMA_DISPLAY));
#endif

#if CAVE_LIGHT_LEAK_FIX_SKY == 1
	//uniform ivec2 eyeBrightnessSmooth;
	//uniform ivec2 eyeBrightness;
	float cave_light_leak = mix(float(max(eyeBrightnessSmooth.y,eyeBrightness.y))/240.,1.,clamp(CAVE_DARKNESS_DEPTH +cameraPosition.y-SEA_LEVEL,0.,10.)*.1);
//	float cave_light_leak = mix(float(eyeBrightnessSmooth.y)/240.,1.,clamp(CAVE_DARKNESS_DEPTH +cameraPosition.y-SEA_LEVEL,0.,10.)*.1);
	
	color*=cave_light_leak;
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
			
			color.rgb  *= 1.-max(nightVision,nv_effect);
			}
#endif

float darkness = min(1.,blindness + darknessFactor);
color.rgb *=1.-darkness ;

					
/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(color, 1.0); //gcolor
}