// © Copyright 2023-2025 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


vec4 clouds(in vec2 suv,  out float depth) {
	float cloudy = min(1.,.2+.3*sin(time*.1 )+rainStrength);
	
	vec4 pos = vec4(suv  * 2.0 - 1.0, 1.0, 1.0);
	pos = gbufferProjectionInverse * pos;
	pos.xyz/=pos.w;
	pos = gbufferModelViewInverse * pos+gbufferModelViewInverse[3];
	
	vec3 raydir = normalize(pos.xyz);
	
	if (raydir.y<0.) return vec4(0.);
	
  vec2 uvog =raydir.xz*(1./raydir.y);//*1.0/n.y
//uvog.y=1.-uvog.y;
float d = 1./(abs(raydir.y));//1.+1./(1.-uvog.y);

 //uvog.y*=d;
//uvog.x=(uvog.x-.5)*d+.5;


 // uvog.y*=2.;
 

 vec2 position_offset = cameraPosition.xz*.01;

  vec2 uv = uvog* 1.0+position_offset;

float samples = 10.;

  
  uv += .75*vec2(time * 1., time * 0.5);
  

vec4 ctot = vec4(skyColor,0.);



vec2 uv2 =(position_offset+  uvog) *.1-time*.07515;

vec2 uv3 =(position_offset+ uvog) *.5-time*.0515;



float haze= 0.;
 depth = distance(uvog,vec2(0.));
 float cloud_shadow = 0.;
for(float s=0.;s<samples;s++)
{

vec3 p = vec3(uv,0.)+raydir/raydir.y*s;
vec3 p2 = vec3(uv2,0.)+raydir/raydir.y*s*1.1;


  float n = fractal_noise_o_clouds3d(p);
  
  float h =
  	fractal_noise_o_clouds(uv3)*
  	n
*clamp(
	(fractal_noise_o_clouds3d( p2) -.4)
		*2.+cloudy
		,0.,1.)


;// 0.5 + 0.5 * n;



//h*=n+1.1;
h=clamp((h-.051)*20.,0.,1.);
cloud_shadow+=h*.35;

//float clouds = mix(1.,0.,h);
vec3 color = mix(vec3(1.),skyColor,.5*s/samples);
	ctot.rgb = mix(ctot.rgb,color,(1.-ctot.a)*h);
	ctot.a+=(1.-ctot.a) * h;
 
	;
}

cloud_shadow/=samples;


depth=haze< .01*(samples-1.) ? 1000.:depth;;



#include "/suncolor.glsl"




	sun_color =(sun_color*(1.-cloud_shadow)+skyColor*max(0.,1.-.5* cloud_shadow))*.65;//debug
	//sun_color=mix(sun_color,skyColor,.5);//debug

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

/*

float cloud_fog =1.+1./raydir.y ;
		vec3 p = vec3(uv,0.)+raydir;
vec3 p2 = vec3(uv2,0.)+raydir*1.1;
		 ctot.a = clamp((fractal_noise_o_clouds(p.xy)*fractal_noise_o_clouds(p2.xy)-.2)*10.,0.,1.);
		//making holes and density
		ctot.a=clamp( (ctot.a-(.3*(1.-rainStrength)))*4.,0.,2. );
		//setting white
		ctot.rgb = vec3(1.);
		//shading
		ctot.rgb*=1.-clamp( (ctot.a-.5)*.3, 0., 0.5 );
		//blend them in
	//	ctot.rgb=mix(color.rgb,ctot.rgb ,min(ctot.a,1.)/max(1.,cloud_fog*CLOUD_FOG) );
			

*/
  return ctot* loop_fade_in;
}
