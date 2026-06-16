int mod1(int i, int ii) //6-24
{
	return ii-(ii/i)*i;
}

const float Pi = 3.141592;

#include "/stuff/onion/roll_and_unroll.glsl"


	vec3 screen_coords_to_raydir(in ivec2 uvi,in ivec4 rect) {
		vec2 uv=vec2(uvi-rect.xy)/vec2(rect.zw-rect.xy);
		float phi = (uv.x - 0.5) * 2.0 * Pi;
		float theta = (uv.y - 0.5) * Pi;
		float x = cos(theta) * cos(phi);
		float y = sin(theta);
		float z = cos(theta) * sin(phi);
		return vec3(x, y, z)+gbufferModelViewInverse[3].xyz;
		
		
	}
	
	vec2 unroll_mc_raydirf(in vec3 raydir,in ivec4 rect) {
		 float u = atan(raydir.z, raydir.x) / (2.0 * Pi) + 0.5;
		float v = asin(raydir.y) / Pi + 0.5;
		vec2 ld = vec2(u, v);
		
		
		vec2 iuv=(rect.xy+(ld*vec2(rect.z-rect.x,rect.w-rect.y)))
		// /vec2(DATA_BUFFER_SIZE_TOTAL_W,DATA_BUFFER_SIZE_TOTAL_H)
		;

		//p=mix(p,vec3(0.,p.y,0.),abs(p.y));
		//return normalize(p);
		
		return iuv;
	}
	
	
	
	
	vec3 screen_float_coords_to_raydir(in vec2 uv) {
		//vec2 uv=vec2(uvi-rect.xy)/vec2(rect.zw-rect.xy);
		float phi = (uv.x - 0.5) * 2.0 * Pi;
		float theta = (uv.y - 0.5) * Pi;
		float x = cos(theta) * cos(phi);
		float y = sin(theta);
		float z = cos(theta) * sin(phi);
		return vec3(x, y, z);//+gbufferModelViewInverse[3].xyz;
		
		
	}
	
	
	vec2 unroll_mc_raydirf_float(in vec3 raydir) {
		 float u = atan(raydir.z, raydir.x) / (2.0 * Pi) + 0.5;
		float v = asin(raydir.y) / Pi + 0.5;
		vec2 ld = vec2(u, v);
		
		return ld;

	}

	
	
	