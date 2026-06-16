// < Noise

uniform sampler2D noisetex;
float blue_noise()
{
	return texelFetch(noisetex, ivec2(gl_FragCoord.xy/100)%64,0).r;
}
vec4 blue_noise4()
{
	return texelFetch(noisetex, ivec2(gl_FragCoord.xy)%64,0);
}
// > Noise >