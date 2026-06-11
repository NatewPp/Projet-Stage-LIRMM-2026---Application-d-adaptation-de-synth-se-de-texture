#modified
#version 330 compatibility

out vec2 lmcoord;
out vec2 texcoord;
out vec4 glcolor;

#define VSHSDT

#include "/lib/sdt/SDTmain.glsl"
void main() {
   PrepareTextureSynthesisVSH();

	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;
}