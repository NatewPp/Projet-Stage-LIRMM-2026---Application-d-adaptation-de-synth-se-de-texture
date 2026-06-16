
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

#if VANILLA_SUNSETS == 0
	#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
	uniform float sunAngle;
	uniform float Foggy=0.;
	uniform vec3 shadowLightPosition;
	uniform vec3 sunPosition;

#endif
#if CLOUDS == 25
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


float fogify(float x, float w) {
	return w / (x * x + w);
}

#include "/stuff/fluids/sky_color_h.glsl"

void main() {
	vec3 color;
	if (starData.a > 0.5) {
		color = starData.rgb;
	}
	else {
		vec4 pos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
		pos = gbufferProjectionInverse * pos;
		#if CLOUDS == 25
			color=clouds(vec2(gl_FragCoord.xy / vec2(viewWidth, viewHeight))).rgb;
		#else
			color = calcSkyColor(normalize(pos.xyz));
		#endif
		
	}

#if FIX_COLOR_SPACE == 1
	//color.rgb=pow(color.rgb,vec3(2.2));
#endif
					

			/* RENDERTARGETS: 0 */

		
	gl_FragData[0] = vec4(color, 1.0); //gcolor
}