//Weather_FS


#ifndef TEX
uniform sampler2D tex;
#define TEX
#endif


/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 gbufferOutput0;


in vec2 texCoord;


void main(){
	vec4 tex = texture(tex, texCoord);

	if(tex.a < 0.1) discard;

	gbufferOutput0 = vec4(0.0, 0.0, 0.0, tex.a);
}
