#include "/settings.glsl"

#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif
#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif

uniform sampler2D texture;

varying vec2 texcoord;
varying vec4 glcolor;

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;


		vec4 pos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
		pos = gbufferProjectionInverse * pos;
		pos = gbufferModelViewInverse*vec4((pos));
		color.a = normalize(pos.xyz).y > 0.? 1.:0.;
		
		
		vec3 raydir =  normalize(pos.xyz);

		/* RENDERTARGETS: 0 */

	gl_FragData[0] = color; //gcolor
}