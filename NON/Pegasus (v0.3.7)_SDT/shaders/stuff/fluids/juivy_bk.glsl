// © Copyright 2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


#define SMOOTH_2D_DECCED 1
	#include "/stuff/fluids/j_noise.glsl"

// define CRASH_WV_STR SHIRE_FOAM_STR
		

void spin_point(inout vec2 v, float rotation, in vec2 c)
{								// rotate point around center
	highp float theta = rotation * (3.14159 / 180.);
	float r_y = c.y + ((v.x - c.y) * sin(theta) + (v.y - c.y) * cos(theta));
	float r_x = c.x + ((v.x - c.x) * cos(theta) - (v.y - c.x) * sin(theta));
	v.x = r_x;
	v.y = r_y;
}




vec4 beaching_(in vec2 uv, in float h, in float extra_foam) {

#if BEACH_TIMING == 1
	float time1 = (frameTimeCounter);
#else
	float time1 = worldTime*.003;
#endif	
	h=pow(h,0.7);
h=pow(1.-h,1.);

//	float cloudy = .2+.3*sin(time1*.01 );
 // vec2 uv = gl_FragCoord.xy / resolution.xy;
//uv.y*=2.;


vec2 og_uv = uv;

uv*=.01;
//uv.x+=.25;
//uv*=.1+.2*sin(time1*.1);
//uv+=vec2(sin(time1*.01),cos(time1*.02));

vec3 fp = 300.*vec3(uv,time1*.00001);;

vec2 uvt=uv;

spin_point(uv,time1*3.*TIDE_STR2,vec2(.5));


uv*=1.+50.*(.5+.5*sin(time1*.1))*TWARB2;


//uv.x= uv.x/(uv.y*1000.);

vec3 p = vec3(uv+time1,time1);
vec3 p3 = vec3(og_uv*.01+time1*.013,time1*.03)* (25+10.*(.5+.5*sin(time1*.1)));
vec3 p2 = vec3(uv*.42,time1*1.7);
p.x+=1.*snoise_j(p2.xy);
p.y+=1.*snoise_j(p2.yx+10.);
//p.z+=sin(p.x+time1*.1);
//p2.z-=snoise_j(p2.xy)*p.z*.1*cos(sin(.1*p.x-sin(time1*.1))+cos(.1*p.y-sin(time1*.3)));

vec4 tp = vec4(p

+20.*vec3(snoise_j(p.xy*.02),snoise_j(p.yx*.02),1.)
+(5.)*vec3(snoise_j(p.xy*.2),snoise_j(p.yx*.2),1.)
,1.);//,snoise_j(p.zy),0.);



tp.z=h;//texture2D(hmap,uvt).r;
tp.w=tp.y;

float time1t=time1* .1;

tp.y=-300.*pow(tp.z,.4) +10.*snoise_j(55.*uvt.xy)*TWARB;


//tp.x*=3.+time1t*.1;  //olD

float anti_tides = pow(min(1.,float(worldTime)/14000.),2.)*(1.-TIDE_STR);
tp.x=
tp.x*3.*TWARB3+
time1*.5*(100.+100*TIDE_STR4)*WAVES_SPEED*anti_tides+ (0.9+.1*(1.-anti_tides))*(tp.x*3.+time1t*(1000.*(1.-TIDE_STR3)  +.1) *WAVES_SPEED);//+time1t*.1);
//tp.x*=mix(tp.x,time1*200.,TIDE_STR2);
;
//tp.z=time1*11.;
float td = 0.;//time1*.1;

float tides = .5+.5*sin(tp.x*.3 +tp.y*.3+time1t);;
float tides2 = .5+.5*sin(tp.x*.3+tp.y*.3+.1+time1t);;
float tides_h = pow(clamp(tides>tides2?tides:tides-20.*(tides2-tides),0.,1.),0.3)
;
;
//float tides_laege = .5+.5*sin(p.x*.1*sin(time1*.01)+p.y*.1*cos(time1*.01)+time1);;

//tides_h*=snoise_j(p2.xy*.1+time1*.1);

vec3 ogp = vec3(uvt*100.,time1*10.);
vec3 ogp2 = vec3(uvt*100.+time1*1.1,time1*11.);

/*
  float n = fnoise3d_j(ogp)-.5+
  	fnoise3d_j(ogp2)+ tides_h;


//normals / height
  	float np = .2;
	
	
  	float n2 = fnoise3d_j(ogp +vec3(np,0.,0.) )-.5+
  	fnoise3d_j(ogp2+vec3(np,0.,0.))+ tides_h;
  	float n3 = fnoise3d_j(ogp +vec3(0.,np,0.) )-.5+
  	fnoise3d_j(ogp2+vec3(0.,np,0.))+tides_h;
	*/
	float n = fnoise3d_j(ogp  )-.5+
					fnoise3d_j(1.5*ogp+time1*5.);
				float np = .2;
				float n2 = fnoise3d_j(ogp +vec3(np,0.,0.) )-.5+
					fnoise3d_j(1.5*ogp+time1*5.+vec3(np,0.,0.));
				float n3 = fnoise3d_j(ogp +vec3(0.,np,0.) )-.5+
					fnoise3d_j(1.5*ogp+time1*5.+vec3(0.,np,0.));


//n=snoise_j(p2.xy)*p.z*.1;//debug

//h
 // vec3 ctot = mix(vec3(0.,0.,1. ),vec3(1.),n);
//n
vec3 ctot = normalize(vec3(n-n2,n-n3,2.));
/*
//sparkle
float sprkl = clamp(
	(dot(ctot,normalize(vec3(0.,-.5,.5)))
	-.8)*15.
	,0.,1. );
//vis n
ctot=ctot*.5+.5;
ctot.b*=0.;//debug view
ctot.b=ctot.r;
ctot.g=1.-ctot.g;
ctot.r=0.;
vec2 v = (uv*2.-1.)*5.5;
ctot*=1.-clamp(
	(dot(ctot,normalize(vec3(v.x,v.y,.5)))
	-.0)*1.
	,0.,1.)
	;

	ctot.b+=ctot.g;
ctot += .3*vec3(pow(sprkl,1.));
*/

//vec3 //;




tides_h*=pow(tp.z,1.);

//ctot.rgb=vec3(0);


	//ctot.rgb=fract(tp.xyw);
//ctot.rg=fract(fp.xy);

//ctot = vec3(fract(h*20.));

//ctot.rgb=pow(ctot.rgb,vec3(.5));
  // Output the final color
  //foam
  float pockets = fnoise3d_j(fp*.1);
  float tidal1 =   pow( clamp((fnoise3d_j(vec3(5.*p3.xyz)*.1)-.5)*2.+.5,0.,1.) ,2.);
  
  tidal1= min(1.,tidal1+extra_foam);
  //tides_h= min(1.,tides_h+extra_foam);
  float w1 = 

  mix(
			0.,
				//tp,
			1.,
			clamp(
				1.
				*pow(tides_h,1.)
				*clamp(
					pow(fnoise3d_j(fp*.6),2.)*2.
					*(.3*tp.z+(.7+.3*(1.-tp.z))*min(1.,tidal1*1.7))
					*(1.+3.*pow(tides_h,2.5)*.7)
					,pow(tides_h,8.1)*.9
					,1.)
			,0.,1.)
		);
  return 
  vec4(ctot,
  	//mix(
	//	vec3(1.),
		min(vec3(1.),
		//extra_foam+
		tidal1*(0+.5*rainStrength)*(1.-tp.z)+
	CRASH_WV_STR*
			vec3(w1)
		+
		//max(0.,1.-w1*5.)*
		//foam
		 SHIRE_FOAM_STR*
		clamp(
			(tp.z-.75)*5.
			*fnoise3d_j(5.*vec3(.5*og_uv.xy+time1*.1+.5*vec2(snoise_j(.5*og_uv+time1),snoise_j(.3*og_uv.yx-time1)),time1)) 
			//*(.5+.5*pockets)
			
			,0.,
			1.) 
		//)
		)
  	
	/*
	, 
	#if DEBUG_TIDES == 1
		fract(tp.x)
	#else
		1.
	#endif
	*/
	);
	
}

// © Copyright 2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 