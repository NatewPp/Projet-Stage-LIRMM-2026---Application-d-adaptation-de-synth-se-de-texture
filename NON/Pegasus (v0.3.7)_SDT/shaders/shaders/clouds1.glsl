// © Copyright 2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 

vec3 projectanddivide(mat4 pm, vec3 p)
{
	vec4 hp = pm*vec4(p,1.);
	return hp.xyz/hp.w;
}

vec4 clouds(in vec2 suv,  out float depth) {
	float cloudy = min(1.,.2+.3*sin(time*.1 )+rainStrength);
	
	#if REFLECTIONS_ARE_IN_RAYDIR == 1
			vec4 pos= vec4(texcoord, depth, 1.);
				vec3 view_pos = pos.xyz;
			pos = gbufferModelViewInverse * vec4(pos.xyz,1.);
			pos.xyz-=gbufferModelViewInverse[3].xyz;;//feet position
		#else
			depth = 1.;
			vec4 pos= vec4(texcoord, depth, 1.)*2.-1.;//ndc
			pos.xyz = projectanddivide(gbufferProjectionInverse,pos.xyz);//view pos
				vec3 view_pos = pos.xyz;
			pos = gbufferModelViewInverse * vec4(pos.xyz,1.);
			
		#endif
	
	vec3 raydir = normalize(pos.xyz);
	
	if (raydir.y<0.) return vec4(0.);
	
  vec2 uvog = raydir.xz*(1./raydir.y);//*1.0/n.y
//uvog.y=1.-uvog.y;
float d = 1./(abs(raydir.y));//1.+1./(1.-uvog.y);

 //uvog.y*=d;
//uvog.x=(uvog.x-.5)*d+.5;


 // uvog.y*=2.;
 



  vec2 uv = uvog* 1.0;

raydir*=1.;
float samples = 11.;

  
  uv += vec2(time * 1., time * 0.5);
  

vec4 ctot = vec4(0.);



vec2 uv2 = uvog *1.1-time*.15;

vec2 uv3 = uvog *.5-time*.015;



float haze= 0.;
 depth = distance(uvog,vec2(0.));
for(float s=0.;s<samples;s++)
{

vec3 p = vec3(uv,0.)+raydir*s;
vec3 p2 = vec3(uv2,0.)+raydir*s*1.1;


  float n = fractal_noise_o_clouds3d(p);
  
  float h =
  	fractal_noise_o_clouds(uv3)*
  	n
*clamp(
	(fractal_noise_o_clouds3d( p2) -.5)
		*2.+cloudy
		,0.,1.)


;// 0.5 + 0.5 * n;

//h*=n+1.1;
h*=2.;

//float clouds = mix(1.,0.,h);
vec3 color =

	// h<.1? mix(vec3(0.,0.,1.),vec3(1.) ,clamp(h*10.,0.,1.)):
	
	//selt shadimg
	1.* vec3(1.-.5*(1.+1.-s/samples)*max(0.,h-.1));
	 //color=(color-.1)*3.+.1;
	 //selfvshading and height based color
	 color = mix(pow(color,vec3(.25))*2.

	 	,vec3(1.0,0.7,1.0),vec3(s/samples))
	 	;

float trud = min(1., s/samples +pow(1.-1./d,5.));
haze+=ctot.a <1.? .01: 0.;
depth+=ctot.a <1.? 1.: 0.;
ctot.rgb+=
	//mix(
	(1.-ctot.a)* max(.01,h)*
	//mix(
		mix(
		color,
		#if MIX_SKY == 1
// vec3(0.,0.,1.)
 mix(vec3(0.,0.,0.),vec3(.7,.7,1.),(1.-1./d))
 #else
 color
 #endif
 ,
		 trud)
	//,	 vec3(1.,0.,0.),trud*.2)

	//,ctot.rgb,ctot.a/(ctot.a+h))
	//
	;
	ctot.a=min(1.,ctot.a+h);

	;
}


depth=haze< .01*(samples-1.) ? 1000.:depth;;



#include "/suncolor.glsl"

  	ctot.rgb = sun_color*mix(
			#if MIX_SKY == 1
mix(vec3(0.,0.,1.),vec3(.7,.7,1.),(1.-1./d))
  		
 #else
 1.1*ctot.rgb
 #endif
  		
		,
		1.2*ctot.rgb  /(ctot.rgb+.3)
	//	ctot.rgb
		,
		ctot.a
  		);
//ctot.rgb=pow(ctot.rgb,vec3(.5));
ctot.a=max(0.,ctot.a-haze-pow(1.-1./d,3.));
  return ctot* loop_fade_in;
}






vec4 clouds_refl(in vec4 pos,  out float depth) {
	float cloudy = min(1.,.2+.3*sin(time*.1 )+rainStrength);
	
	//pos =   gbufferModelViewInverse*pos-gbufferModelViewInverse[3];
	
	vec3 raydir = normalize(pos.xyz);
	
	if (raydir.y<0.) return vec4(0.);
	
  vec2 uvog = raydir.xz*(1./raydir.y);//*1.0/n.y
//uvog.y=1.-uvog.y;
float d = 1./(abs(raydir.y));//1.+1./(1.-uvog.y);

 //uvog.y*=d;
//uvog.x=(uvog.x-.5)*d+.5;


 // uvog.y*=2.;
 



  vec2 uv = uvog* 1.0;

raydir*=1.;
float samples = 11.;

  
  uv += vec2(time * 1., time * 0.5);
  

vec4 ctot = vec4(0.);



vec2 uv2 = uvog *1.1-time*.15;

vec2 uv3 = uvog *.5-time*.015;



float haze= 0.;
 depth = distance(uvog,vec2(0.));
for(float s=0.;s<samples;s++)
{

vec3 p = vec3(uv,0.)+raydir*s;
vec3 p2 = vec3(uv2,0.)+raydir*s*1.1;


  float n = fractal_noise_o_clouds3d(p);
  
  float h =
  	fractal_noise_o_clouds(uv3)*
  	n
*clamp(
	(fractal_noise_o_clouds3d( p2) -.5)
		*2.+cloudy
		,0.,1.)


;// 0.5 + 0.5 * n;

//h*=n+1.1;
h*=2.;

//float clouds = mix(1.,0.,h);
vec3 color =

	// h<.1? mix(vec3(0.,0.,1.),vec3(1.) ,clamp(h*10.,0.,1.)):
	
	//selt shadimg
	1.* vec3(1.-.5*(1.+1.-s/samples)*max(0.,h-.1));
	 //color=(color-.1)*3.+.1;
	 //selfvshading and height based color
	 color = mix(pow(color,vec3(.25))*2.

	 	,vec3(1.0,0.7,1.0),vec3(s/samples))
	 	;

float trud = min(1., s/samples +pow(1.-1./d,5.));
haze+=ctot.a <1.? .01: 0.;
depth+=ctot.a <1.? 1.: 0.;
ctot.rgb+=
	//mix(
	(1.-ctot.a)* max(.01,h)*
	//mix(
		mix(
		color,
		#if MIX_SKY == 1
// vec3(0.,0.,1.)
 mix(vec3(0.,0.,0.),vec3(.7,.7,1.),(1.-1./d))
 #else
 color
 #endif
 ,
		 trud)
	//,	 vec3(1.,0.,0.),trud*.2)

	//,ctot.rgb,ctot.a/(ctot.a+h))
	//
	;
	ctot.a=min(1.,ctot.a+h);

	;
}


depth=haze< .01*(samples-1.) ? 1000.:depth;;



#include "/suncolor.glsl"

  	ctot.rgb = sun_color*mix(
			#if MIX_SKY == 1
mix(vec3(0.,0.,1.),vec3(.7,.7,1.),(1.-1./d))
  		
 #else
 1.1*ctot.rgb
 #endif
  		
		,
		1.2*ctot.rgb  /(ctot.rgb+.3)
	//	ctot.rgb
		,
		ctot.a
  		);
//ctot.rgb=pow(ctot.rgb,vec3(.5));
ctot.a=max(0.,ctot.a-haze-pow(1.-1./d,3.));
  return ctot* loop_fade_in;
}

