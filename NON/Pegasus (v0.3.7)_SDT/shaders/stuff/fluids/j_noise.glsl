//I have written this type of function set like 100 times between my phone and pc. This version of hash/noise might be by me or chatgpt to just plug into my phone quick. but then i edited this file

// A simple 2D noise function
float noise_j(vec2 p) {
#if TILE_J_NOISE == 1
	p=fractn2(p/vec2(NOISE_TILING))*vec2(NOISE_TILING);
#endif
  return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// A smooth interpolation function
float smooth_j(float t) {
  return t * t * (3.0 - 2.0 * t);
}
vec2 smooth2d(vec2 t) {
  return t * t * (3.0 - 2.0 * t);
}

// A smoothed noise function
float snoise_j(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  f = smooth2d(f);
  float a = noise_j(i);
  float b = noise_j(i + vec2(1.0, 0.0));
  float c = noise_j(i + vec2(0.0, 1.0));
  float d = noise_j(i + vec2(1.0, 1.0));
  return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// A fractal noise function with multiple octaves
float fnoise_j(vec2 p) {
  float f = 0.0;
  float a = 0.5;
  float s = 1.0;
  for (int i = 0; i < 4; i++) {
    f += a * snoise_j(p * s);
    a *= 0.5;
    s *= 2.0;
  }
  return f;
}


float noise3d_j(vec3 p) {
  return fract(sin(dot(p, vec3(12.9898, 78.233, 31.4578910))) * 43758.5453);
}

vec3 smooth3d_j(vec3 t) {
  return t * t * (3.0 - 2.0 * t);
}

// A smoothed noise function
float snoise3d_j(vec3 p) {
  vec3 i = floor(p);
  vec3 f = fract(p);
  f = smooth3d_j(f);
  float a = noise3d_j(i);
  float b = noise3d_j(i + vec3(1.0, 0.0,0.));
  float c = noise3d_j(i + vec3(0.0, 1.0,0.));
  float d = noise3d_j(i + vec3(1.0, 1.0,0.));
  float bot = mix(mix(a, b, f.x), mix(c, d, f.x), f.y);

   a = noise3d_j(i + vec3(0.0, 0.0,1.));
   b = noise3d_j(i + vec3(1.0, 0.0,1.));
   c = noise3d_j(i + vec3(0.0, 1.0,1.));
   d = noise3d_j(i + vec3(1.0, 1.0,1.));

  return mix(bot , mix(mix(a, b, f.x), mix(c, d, f.x), f.y),f.z);


}

// A fractal noise function with multiple octaves
float fnoise3d_j(vec3 p) {
  float f = 0.0;
  float a = 0.5;
  float s = 1.0;
  for (int i = 0; i < 7; i++) {
    f += a * snoise3d_j(p * s);
    a *= 0.5;
    s *= 2.0;
  }
  return f;
}