
#include "/settings.glsl"


#if POTATO_SHADOWS != 1
	//uniform sampler2D lightmap;
	uniform sampler2D texture;

	varying vec2 lmcoord;
	varying vec2 texcoord;
	varying vec4 glcolor;
	
	#if UNDERWATER_CAUSTICS > 0
		varying vec3 world_pos;
		uniform float frameTimeCounter;
		uniform sampler2D normals;
	#endif
	varying float material;//=mc_Entity.x;//10020
	
	#if UNDERWATER_CAUSTICS > 0
	float random3d(in vec3 p)
{
	p = p-floor(p*.01)*100.;
	return fract(sin(p.x*456.+p.y*56.+p.z*741.)*100.);
}

vec3 smoothv2(in vec3 v)
{
	return v*v*(3.-2.*v);
}

float smooth_noise3d(in vec3 p)
{
	vec3 f = smoothv2(fract(p));
	
	float a = random3d(floor(p));
	float b = random3d(vec3(ceil(p.x),floor(p.y),floor(p.z)));
	float c = random3d(vec3(floor(p.x),ceil(p.y),floor(p.z)));	
	float d = random3d(vec3(ceil(p.xy),floor(p.z)));
	
	float bottom =  mix(	mix(a,b,f.x),	mix(c,d,f.x),	f.y);
	
	 a = random3d(vec3(floor(p.x),floor(p.y),ceil(p.z)));
	 b = random3d(vec3(ceil(p.x),floor(p.y),ceil(p.z)));
	 c = random3d(vec3(floor(p.x),ceil(p.y),ceil(p.z)));	
	 d = random3d(vec3(ceil(p.xy),ceil(p.z)));
	
	float top =  mix(	mix(a,b,f.x),	mix(c,d,f.x),	f.y);
	
	return mix(bottom, top, f.z);
	
	
	
}

float fractal_noise3d(in vec3 p)
{
	float total = 0.5;
	float amplitude = .5;
	float frequency = 1.;
	float iterations = 4.;
	for(float i= 0; i < iterations;i++)
	{
		total +=(smooth_noise3d(p*frequency)-.5)*amplitude;
		amplitude*=.5;
		frequency*=2.;
	}
	return total;
}

#endif

#endif
//potato shadows, not



void main() {
#if POTATO_SHADOWS != 1
vec4 color;

if(abs(material-10020.)<.5)
{
	//water
	#if UNDERWATER_CAUSTICS > 0
		color = 
		vec4(vec3(.5-.5*(1.-clamp(pow(
		#if UNDERWATER_CAUSTICS >=2 
		min(
			abs(
			 fractal_noise3d(world_pos+vec3(frameTimeCounter*.5,frameTimeCounter,0.))-.5)
			,
		#else
			(
		#endif
			abs(
			  fractal_noise3d(2.+world_pos*2.2+vec3(frameTimeCounter*-.7,-1.*frameTimeCounter,frameTimeCounter*.1))-.5)
		)
		,.75)*5.,0.,1.))),1.)
		;
		
	#else
		
		color = vec4(0.5);
	#endif
	
	
}else{ 
	//not water
	vec4 glass = texture2D(texture, texcoord);
	#if UNDERWATER_CAUSTICS > 0
		vec4 glass_n = texture2D(normals, texcoord);
		float ri = abs(glass_n.x+glass_n.y-1.);
		color.rgb =
		//ri<.02?
		.5+ .5*(1.-glass.rgb* glcolor.rgb)
		//:.5-.5*(glass.rgb* glcolor.rgb)
		;
	#else
		color.rgb = .5+ .5*(1.-glass.rgb* glcolor.rgb);
	#endif
	
	
	color.a = glass.a;
	//color.a= color.a*.5+.5;
	
}
	
	//color.rgb = vec3(1.,0.,0.);//debug
    gl_FragData[0] = vec4(color);
	
	
#else
	 gl_FragData[0] = vec4(0.,0.,0.,1.);;
#endif


	
}



