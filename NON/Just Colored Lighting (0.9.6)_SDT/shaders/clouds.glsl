
//uniform vec2 resolution;

 float time = float(mod(worldDay,4))*.01/24000.+float(worldTime)*.01;
 float loop_fade_in = time < 100.? min(1.,time*.1) : clamp(1.-(time-(960.-.1))*.1,0.,1.);


//########################
// 2d  noise stuff for this cloud use

float noise_o(vec2 p) {
  return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

//sin like smooth
float smootho(float f) {
  return f * f * (3.0 - 2.0 * f);
}
vec2 smooth2d(vec2 f) {
  return f * f * (3.0 - 2.0 * f);
}


float smooth_noise_o_clouds(vec2 p) {
  vec2 base = floor(p);
  vec2 f = fract(p);
  f = smooth2d(f);//kill?
  
  float a = noise_o(base);
  float b = noise_o(base + vec2(1.0, 0.0));
  float c = noise_o(base + vec2(0.0, 1.0));
  float d = noise_o(base + vec2(1.0, 1.0));
  
  return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}


#define FRACTAL_ROUGHNESS_O_CLOUDS 0.5
#define CLOUDS_O_FRACTAL_DEPTH 4
float fractal_noise_o_clouds(vec2 p) {
  float tot = 0.0;
  float amp = 0.5;
  float scale = 1.0;
  for (int i = 0; i < CLOUDS_O_FRACTAL_DEPTH; i++)
   {
    tot += amp * smooth_noise_o_clouds(p * scale);
    amp *= FRACTAL_ROUGHNESS_O_CLOUDS;
    scale *= 2.0;
  }
  return tot;
}




//########################
// 3d  noise stuff for this cloud use

//3d variants
float noise_o_clouds_3d(vec3 p) {
  return fract(sin(dot(p, vec3(12.9898, 78.233, 31.4578910))) * 43758.5453);
}

vec3 smooth3d(vec3 f) {
  return f * f * (3.0 - 2.0 * f);
}


float smooth_noise_o_clouds3d(vec3 p) {
  vec3 base = floor(p);
  vec3 f = fract(p);
  f = smooth3d(f);//kill?
  
  float a = noise_o_clouds_3d(base);
  float b = noise_o_clouds_3d(base + vec3(1.0, 0.0,0.));
  float c = noise_o_clouds_3d(base + vec3(0.0, 1.0,0.));
  float d = noise_o_clouds_3d(base + vec3(1.0, 1.0,0.));
  float bot = mix(mix(a, b, f.x), mix(c, d, f.x), f.y);

   a = noise_o_clouds_3d(base + vec3(0.0, 0.0,1.));
   b = noise_o_clouds_3d(base + vec3(1.0, 0.0,1.));
   c = noise_o_clouds_3d(base + vec3(0.0, 1.0,1.));
   d = noise_o_clouds_3d(base + vec3(1.0, 1.0,1.));

  return mix(bot , mix(mix(a, b, f.x), mix(c, d, f.x), f.y),f.z);
}


float fractal_noise_o_clouds3d(vec3 p) {

  float tot = 0.0;
  float amp = 0.5;
  float scale = 1.0;
  for (int i = 0; i < CLOUDS_O_FRACTAL_DEPTH; i++)
   {
    tot += amp* smooth_noise_o_clouds3d(
	p 
	* scale);
    amp *= FRACTAL_ROUGHNESS_O_CLOUDS;
    scale *= 2.0;
  }
  return tot;
}



#if CLOUDS == 1 
	#include "/shaders/clouds1.glsl"
#endif
#if CLOUDS == 2
	#include "/shaders/clouds2.glsl"
#endif
