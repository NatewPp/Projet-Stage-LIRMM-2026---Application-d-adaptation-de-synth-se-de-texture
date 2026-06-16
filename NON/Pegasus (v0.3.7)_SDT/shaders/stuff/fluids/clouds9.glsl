// © Copyright 2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


//#define CLOUD_SAMPLES 20.0 //[10.0 20.0 30.0 100.0]
//#define CLOUD_SHADING_SAMPLES 11.0 //[3.0 5.0 11.0]

//uniform float frameTimeCounter;
//uniform sampler2D colortex0;
//uniform sampler2D colortex6;
//uniform sampler2D depthtex0;
//uniform mat4 gbufferProjectionInverse;
//uniform mat4 gbufferModelViewInverse;
//varying vec2 texcoord;
//uniform float rainStrength;
//uniform vec3 shadowLightPosition;

//uniform vec3 cameraPosition;

//uniform int worldTime;
float cloud_time = float(worldTime+(worldDay-(worldDay/4)*4)*24000)*.1 * CLOUD_SPEED;

/*
const bool colortex0MipmapEnabled = true;
*/


//uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferPreviousProjection;

//const bool colortex6Clear = false;

float random3d(in vec3 p)
{
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
	float amplitude = 1.;
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

vec3 projectanddivide(mat4 pm, vec3 p)
{
	vec4 hp = pm*vec4(p,1.);
	return hp.xyz/hp.w;
}


float sky_density = .00;

float get_cloud(in vec3 p, in int layer)
{
	//p = floor(p*5.)/5.;

	float wisps = (layer == 2)? 5.* smooth_noise3d(p*.01) : 1.;
	p.z*= wisps;
	float c =  clamp(fractal_noise3d(
		(layer == 0 ? floor(p) : p )
	+layer)*fractal_noise3d(p*.1-layer*5.)
	*(1.+1.*fractal_noise3d(p*5.-.2* cloud_time*CLOUD_PERMUTATION_SPEED)),0.,1.)
	* (layer >= 1? smooth_noise3d(p*.1/layer+layer*121.):1)
	;
	//making holes and density
	c =  clamp(.5* (c -(.3*(1.-rainStrength)))
	*(layer >= 1? 2.+2.*smooth_noise3d(p+11.*.07) : 4.)//feathery
	,sky_density,1. );
	
	return layer != 0 ? c :	p.y<c*CLOUD_LAYER_HEIGHT1?.5:0. ;

}

vec4 clouds(in vec2 texcoord,inout float cloud_depth,in vec3 color) {
	//vec3 color = texture2D(colortex0, texcoord).rgb;
	float depth = cloud_depth;//texture2D(depthtex0, texcoord).r;
	
	//sky mask

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
		
		
		vec3 raydir =  normalize(pos.xyz);
		
		float starting_distance = 1./raydir.y;
		
		vec2 uv = raydir.xz*starting_distance+.05* cloud_time*CLOUD_SPEED;
		vec2 uv2 =raydir.xz*3.*starting_distance -.02* cloud_time*CLOUD_PERMUTATION_SPEED;
		
		vec3 sundir = normalize(vec4(gbufferModelViewInverse * vec4(shadowLightPosition.xyz,1.)).xyz);
		float sunset_factor = pow(1.-sundir.y,5.);
		
		//vec3 sun_color = max(vec3(0.),1.-vec3(1.,1.2,1.3)* sunset_factor);	
		#include "/stuff/suncolor.glsl"
		
		
		vec3 sky_color_blurred =  textureLod(colortex0, texcoord,8).rgb;
		vec3 sky_color_og = sky_color_blurred;
		vec3 sky_color = sky_color_og;
		
		//sunsest effect on sky
		float pre_dot = dot(sundir,raydir);
		float sun_dot = pow((pre_dot+1.)*.5,3.);
		sky_color=mix(sky_color,sky_color*sun_color, sunset_factor*(1.-sun_dot));
		sky_color+=3.*pow(sunset_factor,3.)*sun_color*sun_dot;
		
		
		//add clouds
		vec4 clouds= vec4(vec3(1.),0.); 
		float scale = .1;
		float cloud_shading_amount= .5;
		
		
		
		
		
		if(raydir.y > 0.)
		{
		
		for(int layer = 0;layer<CLOUD_LAYERS; layer++)
		{
		
			float CLOUD_SAMPLES = layer == 0? CLOUD_SAMPLES1 : layer == 1? CLOUD_SAMPLES2 : CLOUD_SAMPLES2;
			float CLOUD_LAYER_HEIGHT = layer == 0? CLOUD_LAYER_HEIGHT1 : layer == 1? CLOUD_LAYER_HEIGHT2 : CLOUD_LAYER_HEIGHT3;
			float CLOUD_SHADING_SAMPLES = layer == 0? CLOUD_SHADING_SAMPLES1 : layer == 1? CLOUD_SHADING_SAMPLES2 : CLOUD_SHADING_SAMPLES3;
			float ray_error = (CLOUD_LAYER_HEIGHT/CLOUD_SAMPLES);
					
					
			vec3 player = vec3(uv.x,0.,uv.y)
			+cameraPosition*scale*.1*vec3(1.,0.,1.)
			;
			if(layer >= 1 )
			{
				uv = raydir.xz*11.*float(layer)*starting_distance+.05* cloud_time*CLOUD_SPEED;
				player = vec3(uv.x,0.,uv.y)
					+cameraPosition*scale*.1*vec3(1.,0.,1.)
			;
			}
			
			
			
			for(float s = 0.;s < CLOUD_SAMPLES && clouds.a < .99;s++)
			{
				vec3 ray_pos = player + raydir*(s-random3d(frameTimeCounter+vec3(texcoord,s)))*scale*ray_error;
				
				//slices
				if(s>CLOUD_SAMPLES*.5)
				{
					ray_pos = player + raydir/raydir.y*(s-random3d(frameTimeCounter+vec3(texcoord,s)))*scale*ray_error;
				}
				
				//get density
				vec4 cloud =  vec4(get_cloud(ray_pos,layer));
				
				
				
				//color by height
				cloud.rgb = vec3(1.);
				
				//if sunset colors
				//sky_color=sky_color_og*mix(sun_color,vec3(1.),ray_pos.y*.1);
				//sky_color+=sun_color*clamp(dot(sundir,raydir),0.,1.);
		
				//shading
				vec3 light = sun_color;
				float highlight_total = 0.0;
				
				
				float CLOUD_SHADING_SAMPLESc = min(CLOUD_SHADING_SAMPLES,(player.y+CLOUD_SHADING_SAMPLES-ray_pos.y)/sundir.y);
				for(float ss = 0.;ss < CLOUD_SHADING_SAMPLESc && light.r>0. ;ss++)
				{
					//move ray
					vec3 ray_s_pos = ray_pos + sundir*.25*(ss-random3d(frameTimeCounter+vec3(texcoord,ss)))*scale;
					
					//get cloud density
					float cloud_shadow =  get_cloud(ray_s_pos,layer);
					//*pow(clamp(cloud_shadow,0.,1.),2.)
					;
					
					//apply shading
					light *=1.- pow(clamp(cloud_shadow,0.,1.),.1+1.-sun_dot)*cloud_shading_amount
						// with color absoption
						*(vec3(1.,1.1,1.33));
					light = clamp(light,0.,1.);
					
					
					//add highlight
					vec3 highlight =
					1.*
					clamp(pow(light-.1,vec3(2.))*pow(max(0.,cloud.a-.1),3.),0.,1.);
					highlight_total+=highlight.b;
					light.rgb =mix(light.rgb, sun_color,highlight.b);
					
					
					//add shine through
					cloud_shadow = pow(cloud_shadow,0.1);
					
					//float sun_dot = clamp(dot(sundir,raydir),0.,1.);
					light += 1.1 *sun_color
						//widen scatter in deep shadow
						*pow(sun_dot,1.+5.*(1.-cloud_shadow))
						
						//debug red
						//*vec3(1.,0.,0.)
	
						
						//color absorption
						*(1.
							-1.*pow(
								//by shadow depth 
								(cloud_shadow) 
								
								//and width of scatter
								//+.0*.5*(1.-pow(sun_dot,1.)))
								
								//less so in the center of scatter
								*(1.-.5*sun_dot)
								
								//color absorption
								*mix(
									vec3(1.),
									//vec3(1.,1.2,1.3)
									vec3(1.,1.1,1.33)
								,1.+1.*(vec3(pow(1.-sun_dot,1.))))
								
								//exponent
								,vec3(.5)
							)
						)
						
						
						
						/*
						*clamp(
						(1.
						-1
						//-vec3(1.,1.2,1.3)
						//*pow(cloud_shadow,1.)
						//*(1.-pow(clamp(dot(sundir,raydir),0.,1.),1.))
						)
						,0.,1.)
						*/
						;
						
						//add shine off
						float sun_dot2 = clamp(dot(-sundir,raydir),0.,1.);
						light +=.15*sun_dot2*sun_color
						*(1.-light)*vec3(1.3,1.2,1.1)
						;
						
												
					
						
				}
				
				//AMBIENT SKY LIGHT
				//vec3 ski_total = 0.;
				
				vec3 ski=vec3(1.);
				for(float ss = 0.;ss < 3. && light.r>0. ;ss++)
				{
					ski*=1.-get_cloud(ray_pos+scale*ss*vec3(0.,1.,0.),layer)*vec3(1.,1.1,1.33);
				}
				light+=sky_color*(.5+.5*(max(vec3(0.),ski)));
				
				light = clamp(light,0.,1.);
				
				
				//add highlight to visibility
				cloud.a=min(1.,cloud.a+highlight_total);
				
								
				//add lighting
				cloud.rgb *=clamp(
				//sky_color*.5*(1.-.7*rainStrength) //ambient
				+light //sun
				
				,0.,1.);
				
				if(layer >= 1 )
				{
					//sky fog
					clouds.rgb = mix(clouds.rgb,sky_color*vec3(1.,.9,.9)+0.*vec3(1.,0.,0.), min(1.,pow(1.-raydir.y,7.)+.0) ); 
				}
				
				
				
				//blend sample in
				clouds.rgb = mix(clouds.rgb,cloud.rgb, (1.-clouds.a) * cloud.a);
				clouds.a = clamp(clouds.a+(1.-clouds.a) * cloud.a,0.,1.);
			}//samples
			
			
			
			}//layers
			 
		}else{
			 clouds = vec4(color,1.);
		}

		
		//tonemap
		/*
		clouds.rgb=clouds.rgb + pow(clouds.rgb,vec3(1.+rainStrength*5.));
		clouds.r = clouds.r <.85 ?clouds.r  : .85+(clouds.r -.85)*.1;
		clouds.g = clouds.g <.85 ?clouds.g  : .85+(clouds.g -.85)*.1;
		clouds.b = clouds.b <.85 ?clouds.b  : .85+(clouds.b -.85)*.1;
		*/
		
		//add distance fog
		 clouds.rgb = mix(clouds.rgb,sky_color,pow(1.-raydir.y,7.)); 
			 
		
		//if sunset colors
		//color=mix(color,color*sun_color, sunset_factor*(1.-sun_dot));
		//color+=3.*pow(sunset_factor,3.)*sun_color*sun_dot;
		
		//blend them in
		color.rgb=mix(color.rgb,clouds.rgb ,min(clouds.a,1.));
			
		
		
	
	
	
	depth = depth ==1.0 ? 1.0 : 0.0;
	
	
	#if REFLECTIONS_ARE_IN_RAYDIR == 1 ||  REFLECTIONS_ARE_IN_RAYDIR == 2
	#else
		#include "/stuff/reprojection.glsl"
	#endif
	
	

	//color = texcoord.x>.05?color : texcoord.y<sunset_factor?vec3(1.):color;//debug sunset factor


	return vec4(color, depth); 
}


vec4 clouds_refl(in vec4 world_dir,inout float cloud_depth) {
	return vec4(0.);
}
