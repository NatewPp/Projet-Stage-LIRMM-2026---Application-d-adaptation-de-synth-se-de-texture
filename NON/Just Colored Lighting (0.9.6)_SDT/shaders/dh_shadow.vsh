#version 120

attribute vec4 mc_Entity;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;

#include "/settings.glsl"
#include "/distort.glsl"

varying vec3 position;


#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif
uniform mat4 shadowModelViewInverse;

void main() {
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;

	gl_Position = ftransform();
	
	gl_Position.xyz = distort(gl_Position.xyz);
	//glcolor = gl_Position;
	
	
	#if GRASS_SHADOWS == 0
		gl_Position = (mc_Entity.x == 10000.0) ? vec4(10.0) : gl_Position;
	#endif
	
	position = (gl_ModelViewMatrix * gl_Vertex).xyz;//shadow view 
	position = (shadowModelViewInverse * vec4(position.xyz,1.)).xyz+cameraPosition;

	
}