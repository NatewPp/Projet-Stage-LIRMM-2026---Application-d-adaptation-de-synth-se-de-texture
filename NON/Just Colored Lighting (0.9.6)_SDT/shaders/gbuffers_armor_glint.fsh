#version 120

uniform sampler2D lightmap;
uniform sampler2D texture;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;

void main() {
	vec4 color = texture(texture, texcoord) * glcolor;
	color *= texture(lightmap, lmcoord);

/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}