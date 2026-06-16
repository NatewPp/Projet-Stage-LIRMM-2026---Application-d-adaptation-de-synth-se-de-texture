#version 120

#include "/settings.glsl"

uniform sampler2D texture;

varying vec2 texcoord;
varying vec4 glcolor;

//#if CAVE_LIGHT_LEAK_FIX_SKY == 1
	uniform ivec2 eyeBrightnessSmooth;
	uniform ivec2 eyeBrightness;
	#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif
//#endif

uniform float nightVision;
uniform float blindness;
uniform float darknessFactor;
#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif
#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif

#if IS_THE_END ==  1
	uniform vec3 skyColor;
	uniform vec3 fogColor;
	uniform mat4 gbufferModelView;
	#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
	
	
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
#endif

void main() {
	#if IS_THE_END ==  1 && END_SKY_TEXTURED == 0
		vec4 color = vec4(0.);
		#if END_SKY_GRADIENT == 1
			vec4 pos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
			pos = gbufferProjectionInverse * pos;
			color.rgb = calcSkyColor(normalize(pos.xyz));
		#endif
	#else
		vec4 color = texture(texture, texcoord) * glcolor;
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
			float heat=color.b+color.r*.5+color.g*.2;
			vec3 heat_vis =
				 heat < .25 ? mix(vec3(0.,0.,0.),vec3(0.,0.,1.), heat*4.)
				:heat < .5 ? mix(vec3(0.,0.,1.),vec3(0.,1.,0.), (heat-.25)*4.)
			:heat < .75 ? mix(vec3(0.,1.,0.),vec3(1.,1.,0.), (heat-.5)*4.)
			:heat < 1. ? mix(vec3(1.,1.,0.),vec3(1.,0.,0.), (heat-.75)*4.)
			: mix(vec3(1.,0.,0.),vec3(1.), (heat-1.)*4.)
;
			color.rgb  = mix(color.rgb,heat_vis, max(nightVision,nv_effect));
		}
	#endif

	#if CAVE_LIGHT_LEAK_FIX_SKY == 1
		//uniform ivec2 eyeBrightnessSmooth;
		//uniform ivec2 eyeBrightness;
		float cave_light_leak = mix(float(max(eyeBrightnessSmooth.y,eyeBrightness.y))/240.,1.,clamp(CAVE_DARKNESS_DEPTH +cameraPosition.y-SEA_LEVEL,0.,10.)*.1);
		
		color*=cave_light_leak;
	#endif
	
	
	
/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}