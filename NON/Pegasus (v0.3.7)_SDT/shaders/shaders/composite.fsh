// © Copyright 2023-2025 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


#include "/settings.glsl"
#include "/noise.glsl"

const float entityShadowDistanceMul = 1.0; //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]


//set the voxelizing distance that isn't culled off-screen
#if VOXEL_AREA == 32
	const float voxelDistance = 32.0;
#endif
#if VOXEL_AREA == 64
	const float voxelDistance = 64.0;
#endif
#if VOXEL_AREA == 128
	const float voxelDistance = 128.0;
#endif
#if VOXEL_AREA == 256
	const float voxelDistance = 256.0;
#endif
#if VOXEL_AREA == 512
	const float voxelDistance = 512.0;
#endif


uniform float rainStrength;
#if CLOUDS >= 1 ||  GODRAYS == 1 
	uniform float sunAngle;
#endif

#if CLOUDS >= 1 
	uniform int worldTime;
	uniform int worldDay;
	#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif
	#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
		uniform vec3 shadowLightPosition;
	#include "/clouds.glsl"
#endif

#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
	uniform sampler2D colortex1;
#endif

#if DEBUG_SHADOWS == 1
	uniform sampler2D shadowcolor0;
#endif


#if GODRAYS == 1 
	uniform mat4 gbufferProjection;
	uniform vec3 sunPosition;
	uniform sampler2D lightmap;
	
	uniform float rainfall=0.;
	float Foggy = min(1.,rainfall*.1+rainStrength);
#endif

uniform sampler2D gcolor;
uniform sampler2D depthtex0;
#if BORDERS >= 2
	uniform sampler2D colortex1;
#endif

uniform float near;
uniform float far;
#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
		uniform float dhFarPlane;
		float far1 = dhFarPlane*DH_FOG_END;
		#else
		float far1 = far;
		#endif
uniform int isEyeInWater;

uniform vec3 fogColor;
#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif

varying vec2 texcoord;


float linearize_depth_cpf(in float d)
{

    // from gl_FragCoord.z to world measurements
    return 2.0 * near  * far / (far + near - (2.0 * d - 1.0) * (far - near));

}


float get_depth_at(vec2 uv)
{
#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
	return texture2D(colortex1,uv).x;
#else
	return linearize_depth_cpf(texture2D(depthtex0,uv).r);
#endif

}

float get_depth_at2(vec2 uv)
{
#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
	float d = texture2D(colortex1,uv).x;
	return
//	abs(d-0.) < 0.01 ? 1. :
	pow(clamp(d/far1,0.,1.),1.);
#else
	float d = texture2D(depthtex0,uv).r;//
	return d >.999 ? 1. : clamp(linearize_depth_cpf(d)/far1,0.,1.);
#endif

}

void main() {


vec3 color = texture2D(gcolor, texcoord).rgb;
	
	
	 
	#if CLOUDS >= 1 && IS_THE_NETHER != 1
		float cloud_depth = 0.;
		vec4 cloudsq =  get_depth_at( texcoord) >= .999*far1? clouds(texcoord,cloud_depth) : vec4(0.);
		color= mix(color,cloudsq.rgb,cloudsq.a);
		
	#endif
	 
	
	#if BORDERS >= 1
		
		vec2 texelSize = float( BACKGROUND_RESOLUTIION_DIVIDER )/ vec2(viewWidth,viewHeight);
		 //vec2 floored = floor(texcoord / texelSize) * texelSize;
	
		float material = get_depth_at( texcoord) ;
		float dist = material;//texture2D(colortex1,texcoord).y;
		
		float adjusted_dist = material*BORDERS_SENSITIVITY;//.05
		
		float material1 = get_depth_at( texcoord+texelSize*vec2(1.,0.)) ;
		float material2 = get_depth_at( texcoord+texelSize*vec2(-1.,0.)) ;
		float material3 = get_depth_at( texcoord+texelSize*vec2(0.,1.)) ;
		float material4 =get_depth_at( texcoord+texelSize*vec2(0.,-1.)) ;
		
		#if BORDER_SAMPLES >= 8
			float material11 = get_depth_at( texcoord+texelSize*vec2(2.,0.)) ;
			float material21 = get_depth_at( texcoord+texelSize*vec2(-2.,0.)) ;
			float material31 = get_depth_at( texcoord+texelSize*vec2(0.,2.)) ;
			float material41 =get_depth_at( texcoord+texelSize*vec2(0.,-2.)) ;
			#if BORDER_SAMPLES >= 12
				float material112 = get_depth_at( texcoord+texelSize*vec2(1.,1.)) ;
				float material212 = get_depth_at( texcoord+texelSize*vec2(-1.,-1.)) ;
				float material312 = get_depth_at( texcoord+texelSize*vec2(-1.,1.)) ;
				float material412 =get_depth_at( texcoord+texelSize*vec2(-1.,1.)) ;
				#if BORDER_SAMPLES >= 12
					float material1123 = get_depth_at( texcoord+texelSize*vec2(3.,0.)) ;
					float material2123 = get_depth_at( texcoord+texelSize*vec2(-3.,0.)) ;
					float material3123 = get_depth_at( texcoord+texelSize*vec2(0.,3.)) ;
					float material4123 =get_depth_at( texcoord+texelSize*vec2(0.,-3.)) ;
				#endif
			#endif

		#endif
		
		if(
		abs(material-material1)<adjusted_dist//*-.1
		&&abs(material-material2)<adjusted_dist//*-.1
		&&abs(material-material3)<adjusted_dist//*-.1
		&&abs(material-material4)<adjusted_dist//*-.1
		#if BORDER_SAMPLES >= 8
			&&abs(material-material11)<adjusted_dist//*-.1
			&&abs(material-material21)<adjusted_dist//*-.1
			&&abs(material-material31)<adjusted_dist//*-.1
			&&abs(material-material41)<adjusted_dist//*-.1
			#if BORDER_SAMPLES >= 12
				&&abs(material-material112)<adjusted_dist//*-.1
				&&abs(material-material212)<adjusted_dist//*-.1
				&&abs(material-material312)<adjusted_dist//*-.1
				&&abs(material-material412)<adjusted_dist//*-.1
				#if BORDER_SAMPLES >= 16
					&&abs(material-material1123)<adjusted_dist//*-.1
					&&abs(material-material2123)<adjusted_dist//*-.1
					&&abs(material-material3123)<adjusted_dist//*-.1
					&&abs(material-material4123)<adjusted_dist//*-.1
				#endif
			#endif
		#endif
		)
		{}else{
			
			#if FOG == 1
				float water_fog = isEyeInWater == 1? 30. : isEyeInWater == 2? 20. : isEyeInWater == 1? 10. : 0.;
				water_fog = (water_fog > 1. ) ? clamp((dist)/water_fog,0.,1.) : 0.;
				//fogColor FOG_START FOG_END
					float border_fog_amount = clamp((dist-(BORDER_FOG_START*far1))/(((1.-BORDER_FOG_START)*far1)),0.,1.);
					float fog_amount = 
						clamp(
						max(
						water_fog,
						max( 
							clamp((dist-FOG_START)/(FOG_END-FOG_START),0.,FOG_MAX),
							border_fog_amount)
							*(1.+rainStrength)
							)
						,0.,1.)
						;
					#if EXPONENTIAL_FOG == 1
						fog_amount=pow(fog_amount,2.);
					#endif
			#endif
			
			
			#if BORDERS >= 2
				vec3 border_color = texture2D(colortex1, texcoord).rgb;
				color.rgb = 
				mix(
				color.rgb,
				border_color,
	
				clamp(
				1./(dist*.1)
				
				*clamp(1.-(dist-far1*.5)/(far1*.1),0.,1.)
				
				
				,0.,1.)
				
				)
				//,fogColor, fog_amount)
				;
				
				
			#else
				color.rgb *= 
				//mix(
				
				mix(1.,0.,
				#if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
					((material)>0.1? BORDER_OPACITY :0.)*
					(1.-
					clamp(dist*DH_BORDERS_FADE/dhFarPlane
					#if FOG == 1
						+fog_amount*FOG_HIDES_DH_BORDERS
					#endif
					,0.,1.)));
				#else
					BORDER_OPACITY * clamp(
					//1.-
					1./(dist*.1)
					*clamp(1.-(dist-far1*.5)/(far1*.1)
					#if FOG == 1
						+fog_amount*FOG_HIDES_DH_BORDERS
					#endif
					,0.,1.)
					
					,0.,1.)
					)
					//,fogColor, fog_amount)
					;
				#endif
				
			#endif
		}
		
	#endif


	#if GODRAYS == 1 && IS_THE_NETHER != 1
	bool amore = !(sunPosition.z<0.001);
	bool sunrise = !amore && sunAngle>.5;
	
					
					#if SUNSET == 2
						vec3 sun_color =
						max(vec3(0.),
						
					
					
							(sunAngle <.5?
							(//day
							!amore?
							(
							vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)*SUN_BRIGHTNESS
							//sunrise
							*(1.+2.*(clamp(
							(1.-abs(sunAngle-(sunAngle>.25? .5:0.))
							*40.),0.,1.)))
							)
							:
							(//moon in daytime
							vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B) *MOON_BRIGHTNESS
							//moonset
							*(1.-clamp(
							abs(sunAngle-(sunAngle<.25? 0. : .5))
							*30.,0.,1.))
							)
							
							)//day
							:
							
							(//pizza pie
							amore?
							vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B)*MOON_BRIGHTNESS
							//no moonset
							
							:
							vec3(SUN_COLOR_R,SUN_COLOR_G,SUN_COLOR_B)*SUN_BRIGHTNESS
							//sunrise
							*3.*((clamp(
							(1.-abs(sunAngle-(sunAngle<.75? .5 : 1.))
							
							*40.),0.,1.)))
							
							)//not love
							)
						

						  -
						  (
						  amore?vec3(0.)
						  
						  :
						  vec3(SUNSET_FADE_R,SUNSET_FADE_G,SUNSET_FADE_B )
						  *(1.-clamp((1.-abs(sunAngle-
						  (sunAngle<.5? .25 : .75)
						  )*4.)*10.,0.,1.))
						  
						  )
						  )
						  
						
						  ;
						  /*
						  float gray = (sun_color.r+sun_color.b+sun_color.g)/3.;
						  vec3 hue = sun_color-vec3(gray);
						  sun_color = (vec3(1.)+hue)
						  *(1.-clamp((1.-abs(sunAngle-
						  (sunAngle<.5? .25 : .75)
						  )*4.)*10.,0.,1.));
						  */
					#endif
						 
		


float l =0.0;
		
		
		//if(!amore )
		{
		vec3 celestial = amore? sunPosition*-1.:sunPosition;
		vec4 sunp = gbufferProjection*vec4(celestial,1.);
		sunp.xyz/=sunp.w;
		vec2 c=.5+.5*sunp.xy;
		//vec2 c=.3+vec2(sin(time*.3),.2*cos(time*1.7));
		
		for(float s=0.;s<GODRAY_SAMPLES;s++)
		{
			float z = s/GODRAY_SAMPLES;
		  l+=
		  GR_STR*
		 // pow(
		#if CLOUDS == 3
			min( pow(clamp(cloud_depth/far1,0.,1.),1.0),
		#endif
			get_depth_at2((texcoord-c)
		  	 //texture2D(depth2,(texcoord-c)
		  	*(z-GODRAY_DITHER/GODRAY_SAMPLES*random(random(32.*dot(texcoord,vec2(.718,.1287)))))
        +c)
       // ,5.)
	   #if CLOUDS == 3
			)
		#endif
        ;
		  //1.-texture2D(depth,clamp((texcoord-c)*z+c,0.,1.)).r;
		  float os = pow(clamp((1.-distance(c,vec2(0.5))/2.9),0.,1.),GR_VIEW_SMOOTH*(sunrise ? 10.:5.));
		  os= amore? (os > .7?.7+.3*pow((os-.7)/.3,11.):os)
		  :
		 
		   (os > .5?.5+.5*pow((os-.5)/.5,11.):os)
		  ;
		  os= amore? min(os,.75):min(os,.6);
		  l*=1.-(1.-os)
		  *	(.5-.5*z)
		  *	clamp((distance(texcoord,c)-GR_SUN_WIDTH )/ SUN_GR_HAZE ,0.0,1.);

		 l*=pow(os,0.05);
		 // l*=pow( clamp((1.-2.*max(abs(c.x-0.5),abs(c.y-.5)))*7.,0.,1.),.5);
			}

			l/=GODRAY_SAMPLES;
			
			color+=l*sun_color*(sunAngle>.5?1.:max(Foggy,mix(1.,NOON_GODRAYS,1.-clamp(abs(sunAngle-.25)*4.,0.,1.))));
			}
	#endif


#if FTUDD == 1
//debug
vec3 celestial = amore? sunPosition*-1.:sunPosition;
vec4 sunp = gbufferProjection*vec4(celestial,1.);
		sunp.xyz/=sunp.w;
		vec2 c=.5+.5*sunp.xy;
//color.rgb=vec3( get_depth_at2(texcoord));
float z = .5;//s/GODRAY_SAMPLES;
color.rgb = vec3((	
#if CLOUDS == 1
			min( pow(clamp(cloud_depth/far1,0.,1.),.1),
		#endif
			get_depth_at2((texcoord-c)
		  	 //texture2D(depth2,(texcoord-c)
		  	*(z-GODRAY_DITHER/GODRAY_SAMPLES*random(random(32.*dot(texcoord,vec2(.718,.1287)))))
        +c)
       // ,5.)
	   #if CLOUDS == 1
			)));
		#endif
		
	//	
			#endif
		
		

	#if DEBUG_SHADOWS == 1
		color=texture2D(shadowcolor0, texcoord).rgb ;
	#endif
	;//(material>0.01?1.:0.)*vec3(1-clamp(material/dhFarPlane,0.,1.));

	#if FIX_COLOR_SPACE == 1
		//color.rgb=pow(color.rgb,vec3(1./2.2));
	#endif
	

/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(color, 1.0); //gcolor
}