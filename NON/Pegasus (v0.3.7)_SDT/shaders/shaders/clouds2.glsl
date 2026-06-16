// © Copyright 2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


vec4 clouds(in vec2 suv,  out float depth) {
	float cloudy = min(1.,.2+.3*sin(time*.1 )+rainStrength);
	float CLOUD_FLOOR = 1.;
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
	
	vec3 sa = (gbufferModelViewInverse*vec4(shadowLightPosition.xyz,1.)
	-gbufferModelViewInverse[3]
	).xyz;
	
	vec3 raydir = normalize(pos.xyz);
	
	if (raydir.y<0.) return vec4(0.);
	 
  vec2 uvog = raydir.xz*(CLOUD_FLOOR/raydir.y);//*1.0/n.y
  
  
  
//uvog.y=1.-uvog.y;
float d = 1./(abs(raydir.y));//1.+1./(1.-uvog.y);

 //uvog.y*=d;
//uvog.x=(uvog.x-.5)*d+.5;


 // uvog.y*=2.;
  



  vec2 uv = uvog* 1.0;

raydir*=.01;
float samples = 11.;

 
  uv += vec2(time * .01, time * 0.005);
 

vec4 ctot = vec4(0.);



vec2 uv2 = uvog *1.1-time*.15;

vec2 uv3 = uvog *.5-time*.015;

//vec3 sa = vec3(0.,1.,0.)*.001;;

float haze= 0.;
 depth = distance(uvog,vec2(0.));
for(float s=0.;s<samples;s++)
{
if (abs(s - samples*.7)<1.2) raydir*=3.5;

//if (s > samples-1.01) raydir*= 10./ raydir.y;//top slice far

vec3 raydir2 = raydir;//*vec3(1.,.25,1.);

if (s > samples-1.01) raydir2.xyz += raydir2/  raydir.y;//get slices

vec3 skew =  (s > samples-1.01)? vec3(.1,.1,.1):vec3(1.);

vec3 p = skew * vec3(uv,time*.02)+raydir2*s;
vec3 p2 = skew * vec3(uv2,time*.1)+raydir2*s*1.1;
vec3 p3 = skew * vec3(uv3,time*.1)+raydir2*s*1.1;



  float n = fractal_noise_o_clouds3d(p);

  float h =
  	fractal_noise_o_clouds3d(vec3(p3))
	*n
    *clamp(
	(fractal_noise_o_clouds3d( p2) -.5)
		*2.+cloudy
		,0.,1.)


;// 0.5 + 0.5 * n;

//h*=n+1.1;
h*=2.;
h=pow(h,.5);

//
float sh = 0.;
float C_SHADING_STEPS = 5.;
for(float ss = 1;ss <= C_SHADING_STEPS;ss++)
{
  sh+= 2.*clamp(pow(
  
  fnoise_o3d(p+sa*ss)
  *fnoise_o3d(p3+sa*ss)
  	
   *clamp((fnoise_o3d( p2+sa*ss) -.5)*2.+cloudy,0.,1.)
   
   ,.5),0.,1.)
		;
		}
//

//float clouds = mix(1.,0.,h);
vec3 color = (s > samples-1.01)? vec3(.2,.2,1.):

	// h<.1? mix(vec3(0.,0.,1.),vec3(1.) ,clamp(h*10.,0.,1.)):
	1.* vec3(1.-.5*(1.+1.-s/samples)*max(0.,h-.1));
	 //color=(color-.1)*3.+.1;

	 color = mix(pow(color,vec3(.25))*2.

	 	,vec3(11.2,10.1,11.0)*.3,vec3(s/samples))
	 	;
		
color*=1.-min(.9,sh/C_SHADING_STEPS);

float trud = min(1., s/samples +pow(1.-1./d,5.));
haze+=ctot.a <1.? .01+.01*s/samples: 0.;
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
  return ctot;
}
