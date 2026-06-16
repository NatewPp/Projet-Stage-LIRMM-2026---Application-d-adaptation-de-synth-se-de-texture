#version 120
#include "/settings.glsl"


varying vec2 texcoord;
varying vec4 glcolor;
#if CLOUD_FOG == 1 || (defined IS_IRIS && (defined DISTANT_HORIZONS || defined VOXY)  )
	varying vec4 viewPos;
#endif
void main() {
	#if CLOUD_FOG == 1 || (defined IS_IRIS && (defined DISTANT_HORIZONS || defined VOXY)  )
		viewPos = gl_ModelViewMatrix * gl_Vertex;
	#endif
	
	gl_Position = ftransform();
	#if CLOUDS >= 1
		gl_Position.xyz=vec3(10.);
	#endif
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	glcolor = gl_Color;
}