// © Copyright 2023-2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 

//last noted edited: 2024-5



//float NOISE_GRID_SIZE_2D = 1000.0;

float fractn1(in float f)
{
return fract(f);
	return f- floor(f);
}
vec2 fractn2(in vec2 f)
{
return fract(f);
	return f- floor(f);
}
vec3 fractn3(in vec3 f)
{
return fract(f);
	return f- floor(f);
}

float random(float x) {
    return fractn1(sin(x) * NOISE_GRID_SIZE_2D);       
}

float noise(vec2 p) {
p=fractn2(p/vec2(NOISE_TILING))*vec2(NOISE_TILING);
	return random(p.x + NOISE_GRID_SIZE_2D *(p.y * NOISE_GRID_SIZE_2D));
}




float noisefrom3(vec3 p) {
p=fractn3(p/vec3(NOISE_TILING))*vec3(NOISE_TILING);
    return random(p.x*3.142 + p.y*.001237*(NOISE_GRID_SIZE_2D+p.z*.04181*NOISE_GRID_SIZE_2D));     
}

float noisefrom33(vec3 p) {
p=fractn3(p/vec3(NOISE_TILING))*vec3(NOISE_TILING);
    return random(dot(vec3(p.x*3.142 , p.y*.001237*(NOISE_GRID_SIZE_2D),(p.z*.04181*NOISE_GRID_SIZE_2D)),vec3(0.5)));     
}

float hashfrom3(in vec3 p)
{
	return fract(sin( p.x*12.56+p.y*618.7890)*7654.+7685.*sin(p.x+p.z*891.   ));

}

vec3 noise3from3(vec3 p) {
p=fractn3(p/vec3(NOISE_TILING))*vec3(NOISE_TILING);
    return vec3(random(p.y+p.z*100.),random(p.x*200.+p.z),random(p.x+p.y*300.));     
}

vec3 noise3from3_ver2(vec3 p) {
p=fractn3(p/vec3(NOISE_TILING))*vec3(NOISE_TILING);
    return vec3(random(dot(p.y,p.z)*100.),random(dot(p.x,p.z)*200.),random(dot(p.x,p.y)*300.));     
}

vec3 noise3from3_v3(vec3 p) {
p=fractn3(p/vec3(NOISE_TILING))*vec3(NOISE_TILING);
    return vec3(hashfrom3(vec3(p.x,p.y,p.z)),hashfrom3(vec3(p.z,p.x,p.y)),hashfrom3(vec3(p.y,p.z,p.x)));     
}

//corners for 3d interp

vec2 nw(vec2 p) 
{
 return vec2(floor(p.x), ceil(p.y));
 }
vec2 ne(vec2 p)
 {
 return vec2(ceil(p.x), ceil(p.y)); 
 }
vec2 sw(vec2 p)
 { 
return vec2(floor(p.x), floor(p.y)); 
}
vec2 se(vec2 p)
 {
 return vec2(ceil(p.x), floor(p.y)); }

vec2 nw2(vec2 p) {
 return vec2(floor(p.x), ceil(p.y)); }
vec2 ne2(vec2 p) 
{ 
return vec2(ceil(p.x), ceil(p.y)); 
}
vec2 sw2(vec2 p)
 { 
return vec2(floor(p.x), floor(p.y)); }
vec2 se2(vec2 p)
 { 
 return vec2(ceil(p.x), floor(p.y));
 }

float smoothNoise(vec2 p) {
	//p=fractn2(p/vec2(NOISE_TILING))*vec2(NOISE_TILING);
    vec2 xyp = fractn2(p);
	  float n = mix(noise(nw(p)), noise(ne(p)), xyp.x);
    float s = mix(noise(sw(p)), noise(se(p)), xyp.x);
  
    return mix(s, n, xyp.y);
}

float smoothNoise4(vec2 p,vec2 v) {
//p=fractn2(p/vec2(NOISE_TILING))*vec2(NOISE_TILING);
    vec2 xyp = fractn2(p);
	 float n = mix(noise(nw(p)), noise(ne(p)), xyp.x);
    float s = mix(noise(sw(p)), noise(se(p)), xyp.x);
   
    return mix(s, n, xyp.y);    
}





float noise_grid_size = 100.0;
//used in cloud shading
float floor2_f(in float f)
{
return floor(f);
}
vec3 floor2_v3(in vec3 f)
{
return f;//
return floor(f);
}


//used in xypolation of 3d noise 
float floor3_f(in float f)
{
return floor(f);
}
vec3 floor3_v3(in vec3 f)
{
//return f;//
return floor(f);
}

/*
float random(float x) {

    return fract(sin(x) * 10000.);

}
*/


float noise3d(vec3 p) {
p=fractn3(p/vec3(NOISE_TILING))*vec3(NOISE_TILING);
    return random(p.x + noise_grid_size *(p.y +p.z* noise_grid_size));

}







vec3 nw3(vec3 p) {
 return vec3(floor3_f(p.x), ceil(p.y),floor3_f(p.z)); 
 }
vec3 ne3(vec3 p) {
 return vec3(ceil(p.x), ceil(p.y),floor3_f(p.z)); 
 }
vec3 sw3(vec3 p) { 
return vec3(floor3_f(p.x), floor3_f(p.y),floor3_f(p.z)); 
}
vec3 se3(vec3 p) {
 return vec3(ceil(p.x), floor3_f(p.y),floor3_f(p.z)); 
 }
 

vec3 nw3t(vec3 p) {
 return vec3(floor3_f(p.x), ceil(p.y),ceil(p.z));
 }
vec3 ne3t(vec3 p) {
 return vec3(ceil(p.x), ceil(p.y),ceil(p.z)); 
 }
 vec3 sw3t(vec3 p) {
 return vec3(floor3_f(p.x), floor3_f(p.y),ceil(p.z)); 
 }
vec3 se3t(vec3 p) { 
return vec3(ceil(p.x), floor3_f(p.y),ceil(p.z)); 
}

float smooth_noise_3d(vec3 p) {
//p=fractn3(p/vec3(NOISE_TILING))*vec3(NOISE_TILING);
    vec3 xyp = fractn3(p);

    float s = mix(noise3d(sw3(p)), noise3d(se3(p)), xyp.x);
    float n = mix(noise3d(nw3(p)), noise3d(ne3(p)), xyp.x);
    float b= mix(s, n, xyp.y);

     s = mix(noise3d(sw3t(p)), noise3d(se3t(p)), xyp.x);
    n = mix(noise3d(nw3t(p)), noise3d(ne3t(p)), xyp.x);
    float t= mix(s, n, xyp.y);

    return mix(b, t, xyp.z);
}
float smooth_noise_3d2d(vec3 p) {
//p=fractn3(p/vec3(NOISE_TILING))*vec3(NOISE_TILING);
    vec3 xyp = fractn3(p);

    float s = mix(noise3d(sw3(p)), noise3d(se3(p)), xyp.x);
    float n = mix(noise3d(nw3(p)), noise3d(ne3(p)), xyp.x);
    return  mix(s, n, xyp.y);

}

float fractalNoise3(vec3 p) {

    float x = 0.;
    float octave_strength=1.0;
    float total_s=0.0;
    for(int i=1;i<=DEFAULT_FRACTAL_DEPTH;i++)
    {
    	x += smooth_noise_3d(p  *float(i)    ) *octave_strength ;
    	total_s+=octave_strength;
    	octave_strength*=FRACTAL_ROUGHNESS;

    }
    x/=total_s;

    return x;
            
}

float fractalNoise(vec2 p) {

    float x = 0.;
    float octave_strength=1.0;
    float total_s=0.0;
    for(int i=1;i<=DEFAULT_FRACTAL_DEPTH;i++)
    {
    	x += smoothNoise(p  *float(i)    ) *octave_strength ;
    	total_s+=octave_strength;
    	octave_strength*=FRACTAL_ROUGHNESS;

    }
    x/=total_s;

    return x;
            
}

float fractal_noise_3d(vec3 p, int fractal_depth) {

    float x = 0.;
    float octave_strength=1.0;
    float total_s=0.0;
    for(int i=1;i<=fractal_depth;i++)
    {
    	x += smooth_noise_3d(p  *float(i)    ) *octave_strength ;
    	total_s+=octave_strength;
    	octave_strength*=FRACTAL_ROUGHNESS;

    }
    x/=total_s;

    return x;

}
float fractal_noise_3d_default(vec3 p) {
 int fractal_depth = DEFAULT_FRACTAL_DEPTH ;
    float x = 0.;
    float octave_strength=1.0;
    float total_s=0.0;
    for(int i=1;i<=fractal_depth;i++)
    {
    	x += smooth_noise_3d(p  *float(i)    ) *octave_strength ;
    	total_s+=octave_strength;
    	octave_strength*=FRACTAL_ROUGHNESS;

    }
    x/=total_s;

    return x;

}

float fractal_noise_3dvtop(vec3 p) {

	return
	#if PATCHY_BY_LAYER == 2
		clamp((
		smooth_noise_3d2d(p)
		- CLOUD_PATCH_CUTOFF_V
	)*CLOUD_PATCHY_STR_V+CLOUD_PATCH_CUTOFF_V
	,0.,1.)
		*
	#endif
	#if PATCHY_BY_LAYER == 3
	clamp((
		smooth_noise_3d(p     )
		- CLOUD_PATCH_CUTOFF_V
	)*CLOUD_PATCHY_STR_V+CLOUD_PATCH_CUTOFF_V
	,0.,1.)
		*
	#endif
	
	smooth_noise_3d(p  *vec3(1.,1.,4.))
    ;


}
