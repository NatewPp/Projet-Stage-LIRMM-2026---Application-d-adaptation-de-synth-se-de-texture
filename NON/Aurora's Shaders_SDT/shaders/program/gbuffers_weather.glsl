////////////////////////////////////////
// Complementary Reimagined by EminGT //
////////////////////////////////////////

//Common//
#include "/lib/common.glsl"

//////////Fragment Shader//////////Fragment Shader//////////Fragment Shader//////////
#ifdef FRAGMENT_SHADER

flat in vec2 lmCoord;
in vec2 texCoord;

flat in vec3 upVec, sunVec;

flat in vec4 glColor;

//Uniforms//
uniform int isEyeInWater;

uniform vec3 skyColor;

#ifndef TEX
uniform sampler2D tex;
#define TEX
#endif

//Pipeline Constants//

//Common Variables//
float SdotU = dot(sunVec, upVec);
float sunFactor = SdotU < 0.0 ? clamp(SdotU + 0.375, 0.0, 0.75) / 0.75 : clamp(SdotU + 0.03125, 0.0, 0.0625) / 0.0625;
float sunVisibility = clamp(SdotU + 0.0625, 0.0, 0.125) / 0.125;
float sunVisibility2 = sunVisibility * sunVisibility;

//Common Functions//

//Includes//
#include "/lib/colors/lightAndAmbientColors.glsl"

#ifdef COLOR_CODED_PROGRAMS
	#include "/lib/misc/colorCodedPrograms.glsl"
#endif

//Program//
void main() {
	vec4 color = texture2D(tex, texCoord);
	color *= glColor;

	if (color.a < 0.1 || isEyeInWater == 3) discard;

	if (color.r + color.g < 1.5) color.a *= rainTexOpacity;
	else color.a *= snowTexOpacity;

	color.rgb = sqrt3(color.rgb) * (blocklightCol * 2.0 * lmCoord.x + (ambientColor + 0.2 * lightColor) * lmCoord.y * (0.6 + 0.3 * sunFactor));

	#ifdef COLOR_CODED_PROGRAMS
		ColorCodeProgram(color);
	#endif

	/* DRAWBUFFERS:0 */
	gl_FragData[0] = color;
}

#endif

//////////Vertex Shader//////////Vertex Shader//////////Vertex Shader//////////
#ifdef VERTEX_SHADER

flat out vec2 lmCoord;
out vec2 texCoord;

flat out vec3 upVec, sunVec;

flat out vec4 glColor;

//Uniforms//
uniform float frameTimeCounter;

#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif

//Attributes//

//Common Variables//

//Common Functions//

//Includes//

//Program//
void main() {
	vec4 position = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
	glColor = gl_Color;

	gl_Position = gl_ProjectionMatrix * gbufferModelView * position;

	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmCoord  = GetLightMapCoordinates();
	
	upVec = normalize(gbufferModelView[1].xyz);
	sunVec = GetSunVector();
}

#endif
