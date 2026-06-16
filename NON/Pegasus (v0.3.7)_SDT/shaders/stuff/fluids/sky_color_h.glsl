// © Copyright 2024-2025 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


#if defined SKY_COLOR_DEFINED
#else
#define SKY_COLOR_DEFINED

vec3 calcSkyColor(vec3 pos) {

		

	
	float upDot = dot(pos, gbufferModelView[1].xyz);
	#if VANILLA_SUNSETS == 0
		float hor = (sunAngle<.25? .0 : sunAngle<.75? .5 : 1.);
		float sunset = clamp(1.-abs(sunAngle-hor)*4.,0.,1.);
		sunset*= sunAngle>= .5 ? 1. : sunset;
		bool srise = (sunAngle<.25? true : sunAngle<.75? false : true);
		sunset=  max(0., sunset*(normalize((gbufferModelViewInverse*vec4((pos.xyz), 1.)).xyz-gbufferModelViewInverse[3].xyz)).x * (srise ? 1. : -1.)
			 
		)
		;
		
		vec3 fogColor1 = mix(mix(skyColor,
		mix(fogColor,
		vec3(skyColor.b)
		,1.-upDot)
		,
		.25+.5*Foggy),vec3(1.,.5,0.),sunset);
		vec3 sky_color = mix(skyColor, fogColor1, fogify(max(upDot, 0.0), 0.25));
		
		
		
		//sunsest effect on sky	, in ss
		#include "/stuff/suncolor.glsl"
		vec3 sundir = normalize(vec4(gbufferModelViewInverse * vec4(shadowLightPosition.xyz,1.)).xyz);
		float sunset_factor = pow(1.-sundir.y,SUNSET_EXPONENT);
		float pre_dot = dot(normalize(sunPosition),pos);
		float sun_dot = pow((pre_dot+1.)*.5,3.);
		sky_color=mix(sky_color,sky_color*sky_color*.3, upDot-pow(sun_dot,2.) );
		
				
		sky_color+=Foggy * 3.*pow(sunset_factor,3.)*sun_color*pre_dot*(1.-pow(1.-abs(sundir.y),1.));
		
		//sunset dark
		sky_color=mix(sky_color,sky_color*sun_color*upDot, sunset_factor*min(1.-sun_dot,1.-upDot));
		
		
		return sky_color;
	#else
		return mix(skyColor, fogColor, fogify(max(upDot, 0.0), 0.25));
	#endif

		
		
	
}



vec3 calcSkyColor_w(vec3 pos) {
	float upDot = dot(pos, vec3(0.,1.,0.) );//gbufferModelView[1].xyz);
	#if VANILLA_SUNSETS == 0
		float hor = (sunAngle<.25? .0 : sunAngle<.75? .5 : 1.);
		float sunset = clamp(1.-abs(sunAngle-hor)*4.,0.,1.);
		sunset*= sunAngle>= .5 ? 1. : sunset;
		bool srise = (sunAngle<.25? true : sunAngle<.75? false : true);
		sunset=  max(0., sunset*
			//(gbufferModelViewInverse* vec4(pos,1.)).x
			pos.x
		* (srise ? 1. : -1.)
		)
		;
		
		/*
		//sunsest effect on sky
		vec3 sundir = normalize(vec4(gbufferModelViewInverse * vec4(shadowLightPosition.xyz,1.)).xyz);
		float sunset_factor = pow(1.-sundir.y,SUNSET_EXPONENT);
		#include "/stuff/suncolor.glsl"
		float pre_dot = dot(sundir,pos);
		float sun_dot = pow((pre_dot+1.)*.5,3.);
		vec3 sky_color=mix(skyColor,skyColor*sun_color, sunset_factor*(1.-sun_dot));
		sky_color+=3.*pow(sunset_factor,3.)*sun_color*sun_dot;
		
		
		vec3 fogColor1 = mix(fogColor,fogColor*sun_color, sunset_factor*(1.-sun_dot));
		fogColor1+=3.*pow(sunset_factor,3.)*sun_color*sun_dot;
		*/
		
		
		vec3 fogColor1 = mix(mix(skyColor,
		mix(fogColor,
		vec3(skyColor.b)
		,1.-upDot),
		.25+.5*Foggy),vec3(1.,.5,0.),sunset);		
		
		vec3 sky_color = mix(skyColor, fogColor1, fogify(max(upDot, 0.0), 0.25));
		
		
		#include "/stuff/suncolor.glsl"
		vec3 sundir = normalize(vec4(gbufferModelViewInverse * vec4(sunPosition.xyz,1.)).xyz);
		float sunset_factor = pow(1.-abs(sundir.y),SUNSET_EXPONENT);
		float pre_dot = dot(sundir,pos);
		float sun_dot = pow((pre_dot+1.)*.5,3.);
		sky_color=mix(sky_color,sky_color*sky_color*.3, upDot-pow(sun_dot,2.) );
		
		
		sky_color+=Foggy * 3.*pow(sunset_factor,3.)*sun_color*pre_dot*(1.- pow(1.-abs(sundir.y),1.));
		
		//sunset dark
		sky_color=mix(sky_color,sky_color*sun_color*upDot, sunset_factor*min(1.-sun_dot,1.-upDot));
		
		return sky_color;
		
	#else
		return mix(skyColor, fogColor, fogify(max(upDot, 0.0), 0.25));
	#endif

	
	
}


#endif