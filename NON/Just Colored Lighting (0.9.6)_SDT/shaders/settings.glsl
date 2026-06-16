// © Copyright 2023-2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 

//last edited: 2026-1, then 2024-6



#define CTMPOMFIX_VERSION 4 //[0 1 4]

#define PATH_TRACING_RESOLUTION 1.0 //[0.1 0.2 0.25 0.33 0.5 0.667 0.75 1.0] //lower quality bounce light for way better performance

#define DIFFUSE_BOUNCE_LIGHT 1 //[0 1 2 3 4 5 6 7 8 9 10 11 12 15 20 30 40 50 60 70 80 90 100 150 200 300] //AMOUNT OF RAYTRACED AMBIENT SKY DIFFUSE LIGHTING

#define SKY_AMBIENT_LIGHT 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.25 1.5 1.75 2.0 3.0 5 5 6 7.0 8 9 10 11 12 15 20.0 30.0 40.0 50.0 60.0 70.0 80.0 90.0 100.0 150.0 200.0 300.0] //AMOUNT OF RAYTRACED AMBIENT SKY DIFFUSE LIGHTING


#define SPECULAR_BOUNCE_LIGHT 1 //[0 1 2 3 4 5 6 7 8 9 10 11 12 15 20 30 40 50 60 70 80 90 100 150 200 300]  //AMOUNT OF RAYTRACED AMBIENT SKY DIFFUSE LIGHTING

#define BOUNCE_LIGHT_M 1.0 //[0.2 0.5 0.75 1.0 2.0 3.0]

#define BOUNCE_MORE 1 //[0 1 2 3 4 5 6] // Amount of light bounces . Very Expensive! 

#define KILL_SWITCH 0 //[0 1 5 10 20 24 30 40 50 60] // Fps for Kill Switch . Light Simulation will stop below this fps! So you can still navugate menus and turn it down . RED BOX in top left, 	It will toggle per frame so you still might get lagged out
//requires
 //uniform float frameTime;
 
 
 #define RAY_ACCELERATION 0.2 //[0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.5 0.6 0.7 1.0] //Speeds up rays to maintain precise close reflections and better ray distance at the same time . too high might hurt ray accuracy
 #define REFINER_STEPS_RAY 5 //[0 1 2 3 4 5 6 7 8 9 10] //fractal refinement of ray collission position

#define RAY_DIST 1.0 //[0.0 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0] //further ray distance . this may break close reflections at low step count

#define SKY_RAY_NUM_W 1 // [0 1 2 3 4 5 6 7 8 9 10] // more looks better but is slower . ray number = 4 * w * h + 1 . w wedges in convergence cone

#define SKY_RAY_NUM_H 2 // [0 1 2 3 4 5 6 7 8 9 10] // more looks better but is slower . ray number = 4 * w * h + 1 .  h layers of petals in convergence cone
 
  #define DIFFUSE_THE_RAYS  6 //[0 1 2 3 4 5 6 7 8 9 10 15 20 25 30 40] //softness and stability of diffuse lighting. helps with low samples . can be inaccurate and cause bloom 
  
    #define DIFFUSE_THE_RAYS_SPEC  6 //[0 1 2 3 4 5 6 7 8 9 10 15 20 25 30 40] //softness and stability of SPECULAR lighting. helps with low samples . can be inaccurate and cause bloom . 
  
  
  #define PBR_RAY_STEPS_SKY 20 // [0 5 10 20 30 40 50 60 70 80 90] //how accurately and expensively to propagate light rays 

 #define METAL_SMOOTHER 0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 
 #define METAL_REFLECTIVE 0.92 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.91 0.92 0.93 0.94 0.95 1.0] //increase metal reflectivity
 
 #define USE_MINECRAFT_TORCH_LIGHTING 0.2 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 3.0 4.0 5.0] //Minecraft ambient light from torches and light blocks . is divided by number of light bounces to not overpower
 
 #if BOUNCE_MORE > 1
	#define TORCH_DIV_BOUNCES USE_MINECRAFT_TORCH_LIGHTING / BOUNCE_MORE
 #else
	#define TORCH_DIV_BOUNCES USE_MINECRAFT_TORCH_LIGHTING 
 #endif
 
 #define RAY_BIAS 0.0001 //[0.0001 0.001 0.01 0.0]
 #define NOISE_AMOUNT_IN_RAYS 0 //[0 1 2 3 4 5 6 7 8 9 10]
 
 #define SCREEN_TANGENT 1 //[0 1] //buggy test, don't use!
 
  #define GEN_NORMAL_MAP 0 //[0 1] //generate a normal map for blank textures to play better with the light simulation . probably won't work in texture filtering range

  #define DEBUG_GEN_NORMAL_MAP 0 //[0 1] //buggy test, don't use!

 #define N_BLANK_R 0.5 //[0.0 0.5 1.0] //VALUE FOR MISSING TEXTURES TO OVERRIDE
  #define N_BLANK_G 0.5 //[0.0 0.5 1.0] //VALUE FOR MISSING TEXTURES TO OVERRIDE
   #define N_BLANK_B 1.0 //[0.0 0.5 1.0] //VALUE FOR MISSING TEXTURES TO OVERRIDE
    #define N_BLANK_A 1.0 //[0.0 0.5 1.0] //VALUE FOR MISSING TEXTURES TO OVERRIDE
   
    #define S_BLANK_R 0.0 //[0.0 1.0] //VALUE FOR MISSING TEXTURES TO OVERRIDE
  #define S_BLANK_G 0.0 //[0.0 1.0] //VALUE FOR MISSING TEXTURES TO OVERRIDE
   #define S_BLANK_B 0.0 //[0.0 1.0] //VALUE FOR MISSING TEXTURES TO OVERRIDE
    #define S_BLANK_A 0.0 //[0.0 1.0] //VALUE FOR MISSING TEXTURES TO OVERRIDE


 #define CURVE_LENS 1 //[0 1 2 3] //buggy test, don't use!
 
 #define REDUCE_DIFFUSE_BY_REFLECTIVITY_ 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //1.0 is realistic . 0 is because i don't think most artists think about it
  #define HANDHELD_REDUCE_DIFFUSE_BY_REFLECTIVITY_ 0.9 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //1.0 is realistic . 0 is because i don't think most artists think about it 
  #define REDUCE_DIFFUSE_BY_REFLECTIVITY_METALS 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //1.0 is realistic . 0 is default because i don't think most artists think about it

#define HALF_RAYS 0 //[0 1]//buggy test, combine diffuse and specular
#define ASSUMED_DEPTH 1.0 //[0.1 0.2 0.5 0.7 1.0 1.5 2.0 3.0 4.0 5.0 10.0 100.0 10000.0] //assumed depth of things in screenspace effects . higher gets rid of halos and collides better, but may create occclussion where it shouldn't be . 
	#define ASSUMED_DEPTH_DYNAMIC 1 //[0 1] // increases assumed depth based on distance from camera . usually looks a lot better
						
#define DEBUG_CPF 0 //[0 1]// debug views , not for gameplay!

#define FIX_SSS_LIGHT_LEAK 1 //[0 1] //turning this off will make things directly on top of honey or leaves not cast shadows into it . off will make forest canopies brighter as branches and trunks will not cast shadows on leaves . off may save performance

 #define RAY_FULLY_CONVERGE 1 //[0 1]//fully converge ray cones . may waste performance . may look better with crisper reflections

#define RAY_NUM_W 1 // [0 1 2 3 4 5 6 7 8 9 10] // more looks better but is slower . ray number = 4 * w * h + 1 . w wedges in convergence cone

#define RAY_NUM_H 3 // [0 1 2 3 4 5 6 7 8 9 10] // more looks better but is slower . ray number = 4 * w * h + 1 .  h layers of petals in convergence cone

 #define ROUGH_FRESNEL 0.7 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //FRESNEL amount for rough materials
 #define ROUGH_FRESNEL_EXPONENTIAL 1 // [0 1] //FRESNEL for rough materials use an extra exponential curvature . 0 no . 1 exponentially less fresnel but still full at parallel angles
 #define ROUGH_FRESNEL_EXPONENT 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //FRESNEL for rough materials use an extra exponential curvature . 0 no . 1 exponentially less fresnel but still full at parallel angles . degree of effect
 
 #define CURVE_ASPECT 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 2.5 3.0 3.5 4.0 5.0]
 
#define DIRTY_WATER 0.05 //[0.0 0.001 0.002 0.003 0.005 0.007 0.01 0.02 0.03 0.05 0.07 0.1 0.12 0.15 0.17 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.92 0.95 0.97 0.99 1.0] //linear rate of DIRT color per meter (block) . 1.0 is 1 block . 0.1 is 10 blocks
 #define DIRTY_WATER_R 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
  #define DIRTY_WATER_G 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
   #define DIRTY_WATER_B 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define WATER_ABSORB_R 0.3 //[0.0 0.001 0.002 0.003 0.005 0.007 0.01 0.02 0.03 0.05 0.07 0.1 0.12 0.15 0.17 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.92 0.95 0.97 0.99 1.0] //linear rate of light color absorption per meter (block) . 1.0 is 1 block . 0.1 is 10 blocks
#define WATER_ABSORB_G 0.05 //[0.0 0.001 0.002 0.003 0.005 0.007 0.01 0.02 0.03 0.05 0.07 0.1 0.12 0.15 0.17 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.92 0.95 0.97 0.99 1.0] //linear rate of light color absorption per meter (block) . 1.0 is 1 block . 0.1 is 10 blocks
#define WATER_ABSORB_B 0.01 //[0.0 0.001 0.002 0.003 0.005 0.007 0.01 0.02 0.03 0.05 0.07 0.1 0.12 0.15 0.17 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.92 0.95 0.97 0.99 1.0] //linear rate of light color absorption per meter (block) . 1.0 is 1 block . 0.1 is 10 blocks
#define WATER_SKIN_R 0.99 //[0.0 0.001 0.002 0.003 0.005 0.007 0.01 0.02 0.03 0.05 0.07 0.1 0.12 0.15 0.17 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.92 0.95 0.97 0.99 1.0] //color allowed through water skin, tints even shallow water 
#define WATER_SKIN_G 1.0 //[0.0 0.001 0.002 0.003 0.005 0.007 0.01 0.02 0.03 0.05 0.07 0.1 0.12 0.15 0.17 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.92 0.95 0.97 0.99 1.0] //color allowed through water skin, tints even shallow water 
#define WATER_SKIN_B 1.0 //[0.0 0.001 0.002 0.003 0.005 0.007 0.01 0.02 0.03 0.05 0.07 0.1 0.12 0.15 0.17 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.92 0.95 0.97 0.99 1.0] //color allowed through water skin, tints even shallow water 



#define AMBIENT_LIGHT_FLAT 0.2 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //multiply the old flat ambient light . Use this to brighten shadows . This will easily hide raytraced lighting!
#define SSS_DECAY_RATE 0.4 //[0.01 0.05 0.1 0.15 0.2 0.25 0.3 0.4 0.5 0.75 1.0 1.5 2.0 2.5 3.0] //Sub Surface Scattering will be absorbed faster by this rate . 1.0 is 3 blocks of depth . 3.0 is about 1 block of depth

#define SSS_SCATTER_WIDTH 30.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 2.0 3.0 4.0 5.0 7.0 10.0 20 30 40 50 100]

#define BORDER_FOG 3 //[0 1 2 3 4 5 6 7 8 9 10] // amount of render distance in tenths to use for border fog . it's a fade out effect . high values will have light leak in fog at sunset
#define BORDER_FOG_CLOUDS 2 //[0 1 2 3 4 5 6 7 8 9 10] // amount of the fog distance in tenths to have clouds in . 0 or too low will create pop-in! 10 will be very smooth fade in with clouds in it . 10 was the old default
#define BORDER_FOG_ALTITUDE 3 //[0 1 2 3 4 5 6 7 8 9 10] // add height based fog this high

#define LIGHT_LEAK_ANGLE_LIMIT 0.9 //[0.0 0.01 0.02 0.03 0.1 0.15 0.16 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0] //adjusting this will reduce shadow seams in seamless 3d textures when using no-cubes . high might disable light leak fix for corners . low will create shadow seams on block edges that are smooth, not sharp




//SHADoWS

#define SHADOW_DISTORT_ENABLED 1 //[0 1]//Toggles shadow map distortion
#define SHADOW_DISTORT_FACTOR 0.10 //Distortion factor for the shadow map. Has no effect when shadow distortion is disabled. [0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SHADOW_BIAS 0.00 //Increase this if you get shadow acne. Decrease this if you get peter panning. [0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.60 0.70 0.80 0.90 1.00 1.50 2.00 2.50 3.00 3.50 4.00 4.50 5.00 6.00 7.00 8.00 9.00 10.00]
//#define NORMAL_BIAS //Offsets the shadow sample position by the surface normal instead of towards the sun
//#define EXCLUDE_FOLIAGE //If true, foliage will not cast shadows.
#define SHADOW_BRIGHTNESS 0.75 //Light levels are multiplied by this number when the surface is in shadows [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

const int shadowMapResolution = 1024; //Resolution of the shadow map. Higher numbers mean more accurate shadows. [128 256 512 1024 2048 4096 8192]


#define SHADOW_LENS_CURVATURE 5 //[1 2 3 4 5 6 7 8 9 10] //Higher quality shadows closer to you at the cost of worse shadows far away

#define SHADOW_DEPTH_MULT 1.0 //[1.0 0.75 0.5 0.4 0.3 0.25 0.2 0.1]//Shadow map has a depth of 255 centered around player, divide that limit by this to multiply the range so that sunset and sunrise have longer shadow range. 0.5 doubles, 0.25 quadruples . May cause light leak issues!



#define WAVY_FOLIAGE 0

#define BLURRY_SHADOWS 1 // [0 1]



//Water 
#define WATER_STYLE 1 //[0 1]//water style. 0 is Vanilla
#define WIND_STRENGTH 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 2.0 3.0 4.0 5.0]
#define WATER_SPEED 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 2.0 3.0 4.0 5.0 6.0 7.0 10.0 50.0 100.0 1000.0]
#define WEATHER_TIME 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 2.0 3.0 4.0 5.0]
#define WATER_SCALE 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 2.0]
#define WIND_SPEED 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WIND_SPOT_SIZE 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 2.0 3.0 4.0 5.0 6.0 7.0 10.0]
#define STORM_STRENGTH 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 2.0 3.0 4.0 5.0 6.0 7.0 10.0]

#define INFINITE_OCEAN 1 //[0 1] 
#define FAKE_SKY_REFLECTION 1 //[0 1] 


#define WATER_SKIN_R2 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_SKIN_G2 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_SKIN_B2 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_FOAM_R 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_FOAM_G 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_FOAM_B 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_SKIN_A2 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 


//CLOUDS
#define CLOUD_SIZE 0.2 //[0.001 0.01 0.02 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]// INVERTED. SMALLER IS BIGGER

#define CLOUD_SIZE_CUTOFF 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]//REMOVE THIS MUCH CLOUD IN PATCHES

#define CLOUDINESS_PATCHY_SIZE 0.01 //[0.001 0.01 0.02 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]// INVERTED. SMALLER IS BIGGER
#define CLOUD_PATCH_CUTOFF 0.4 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]//REMOVE THIS MUCH CLOUD IN PATCHES
#define CLOUD_STYLE 5 //[0 1 5]//CLOUD style. 0 is Vanilla . 1 is dreamy. 5 is immersive

#define  SKY_STEPS 80 ///[10 20 30 40 50 60 70 80 90 100 120 150 200 250 300 400 500 1000]
#define LOW_QUALITY_CLOUDS 1 //[2 1 0]
#define SKY_RAY_ACCELERATION 1.1 //[1.0 1.05 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define SKY_RAY_STEP_SIZE 0.01 //[0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 5.0 10.0]//CHANGING THIS CURRENTLY BREAKS THE SKY
#define SKY_NOISE_H 0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]//starting forward dither offset
#define SKY_NOISE_W 0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]//scattering dither
#define SKY_NOISE_H2 0 //[0 1 2 3 4 5 6 7 8 9 10]//forward dither per step
#define ANIMATE_NOISE_H2 0 //[0 1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100]//forward dither per step, ANIMATED
#define JET_STREAM 5.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 5.0 10.0 20.0 50.0 100.0]// WIND SPEED THAT MOVES WEATHER SYSTEMS

#define AIR_SPECULAR 0.1 //[0.0 0.001 0.002 0.003 0.004 0.005 0.007 0.008 0.01 0.02 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 20.0 100.0 1000.0]

#define AIR_DENSITY 0.003 //[0.0 0.001 0.002 0.003 0.004 0.005 0.007 0.008 0.01 0.02 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]


#define CLOUD_PATCHY_STR 20.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 5.0 10.0 20.0 100.0] // PATCHY STRENGTH FOR CLOUDS . higher is more defined patches with holes in clouds . loweer is full cloud cover
#define CLOUD_SIZE_STR 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 5.0 10.0] // PATCHY STRENGTH FOR CLOUDS . higher is more defined patches with holes in clouds . loweer is full cloud cover


#define CLOUD_SCALE 0.05 //[0.0 0.001 0.002 0.003 0.004 0.005 0.007 0.008 0.01 0.02 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define iCLOUD_SCALE (1./CLOUD_SCALE)

#define CLOUD_FRACTAL_DEPTH_MIN 2 //[1 2 3 4 5 6 7 8 9 10]//lod by distance
#define CLOUD_FRACTAL_DEPTH_MAX 4 //[1 2 3 4 5 6 7 8 9 10]//lod by distance

#define SHADING_STEPS_CLOUDS 3 //[1 2 3 4 5 6 7 8 9 10 15 20 30 50 100]//More dynamic shading at heavy cost
#define SHADING_STEPS_FOG 3 //[1 2 3 4 5 6 7 8 9 10 12 15 17 20 30 40 50 100]////More dynamic shading at heavy cost



#define FOG_3D 1.0 //[0.0 0.001 0.002 0.003 0.004 0.005 0.007 0.008 0.01 0.02 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define TAA_ON 0 //[0 1]
#define TAA_HISTORY 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]  // STRENGTH OF HISTORY . BIGGER IS MORE GHOSTING BLUR BUT MORE EFFECT
#define TAA_WIDTH 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 5.0 10.0 100.0] // 1.0 IS STANDARD, MORE IS BLURRY
#define TAA_BRIGHT_SPD 0.8 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 
#define TAA_DARK_SPD 0.5 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 

#define FORWARD_RENDER 0 //[0 1] // onlly use for compatibility, will be slower and breaks light simulation
#define FORWARD_RENDER_BG 0 //[0 1 2]
#define BACKGROUND_RESOLUTIION_DIVIDER 1 //[1 2 4 5 10]// Lower resolution clouds and background for massive fps boost
#define CLOUD_SPECULAR 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 5.0 10.0 100.0]
#define CLOUD_OPACITY 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 3.0 4.0 5.0 10.0 100.0]

#define CLOUD_SHADING 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 2.0 3.0 4.0 5.0]//
#define OBJECT_SHADOWS_RANGE_CLOUDS 2.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 10. 20. 100.]//RANGE FOR SHADOWS ONTO FOGS AND CLOUDS
#define COLORED_SHADOWS_RANGE_CLOUDS 0.1 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]//RANGE FOR SHADOWS ONTO FOGS AND CLOUDS
#define CLOUD_SHADOW_BIAS 0.0001 //[ 0.0 0.0001 0.0002 0.0003 0.0005  0.001 0.002 0.003 0.005  0.01 0.1]
#define FAR_CLOUDS 11111111.0 //[0.0  1.0 111.0 1111.0 11111111.0] 
#define POST_DITHER_FOG 0 //[0 2 5 7 10 15 20 30 40 50 100]
#define CLOUD_VOXEL_SIZE 0 //[0 1 2 4 5 10 20 50 100 1000]
#define FRACTAL_ROUGHNESS 0.5 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 

#define ADDITIVE_CLOUD_ALPHA 1 //[0 1 2 3]
#define USE_MINECRAFT_SKY_COLORS 0 //[0 1]
#define USE_MINECRAFT_FOG_COLORS 0 //[0 1]
#define USE_MINECRAFT_CLOUD_COLORS 0 //[0 1]

#define DAY_LENGTH 1.0// [1.0 1.1 1.2 1/5 1.75 2.0 2.1 2.25 2.5 2.75 3.0 3.2 3.3 3.5 4.0]//Purely asthetic. 2.0 is 12 hours of 24
#define SUNRISE 0.0 // [0.0 0.1 0.2 0.25 0.3 0.34 .4 .5 .6 .7 .8 .9 1.0]//Purely aesthetic. 0.25 is standard

#define AMBIENT_SKY_LIGHT 0.4 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]// 

#define AMBIENT_SKY_LIGHT_CLOUDS 0.2 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]// 

#define QUICK_CLOUDS 0 //[0 1]//render as verticle slices instead of better immersive raytracing. you can still fly and move through them
#define FOG_LAYERS 5 //[0 1 2 3 4 5 6 7 8 9 10]
#define POOFY_LAYERS 20 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 25 30 40 50 100 1000]
#define CIRRUS_LAYERS 5 //[0 1 2 3 4 5 6 7 8 9 10]

#define CLOUD_CRISPNESS 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.8 2.0 3.0 4.0 5.0 6.0 7.0 8.0 8.0 9.0 10.0 20.0 30.0 40.0 50.0 100.0]//
#define CLOUD_CRISP_BIAS 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]//

#define CLOUD_PATCH_USE 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]//0 meand no patches, full coverage

#define CLOUD_SPEED 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 2.0 3.0 4.0 5.0 6.0 7.0 10.0 50.0 100.0 1000.0]

#define OZONE_LAYERS 10.0 //[0.0 1.0 5.0 10.0 20.0 100.0]


#define DEBUG_VIEWS 0 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41]


#define PATH_TRACING_RESOLUTION_DIVIDER 2 //[1 2 4 5 10]// Lower resolution light simulation for massive fps boost
#define DEFER_SHADING 1 //[0 1]

#define SKY_TINT_DIRECTION 0.1 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]//

 #define TORCH_R 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 
  #define TORCH_G 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 
   #define TORCH_B 0.3 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 
   

   
#define SKY_TAA 0 //[0 1]
	#define TAA_HISTORYS 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]  // STRENGTH OF HISTORY . BIGGER IS MORE GHOSTING BLUR BUT MORE EFFECT
#define TAA_WIDTHS 0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 5.0 10.0 100.0] // 1.0 IS STANDARD, MORE IS BLURRY
#define TAA_BRIGHT_SPDS 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //FAVOR BRIGHTS
#define TAA_DARK_SPDS 0.5 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //favor dark
#define TAA_BRIGHT_SPDSA 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //alpha favor more, speed to change
#define TAA_DARK_SPDSA 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //alpha favor less, speed to change
	
 #define DOWNSCALE_CLOUDS 0 //[0 1 2 3]  // lod factor for downscaling to limit noise
 
  #define DOWNSCALE_PTX 0 //[0 1 2 3]  // lod factor for downscaling to limit noise
#define POST_DITHER_PTX 0 //[0 2 5 7 10 15 20 30 40 50 100]

 #define NOISE_GRID_SIZE_2D 100.0 //[100.0 1000.0 11111.0 2000.0 10000.0 11111.0 314718.0]
   
    #define SUNRISE_COLORATION 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 
	#define SUNRISE_TYPE 1 //[0 1]
	
	#define SUN_ELEVATION_TINT 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]//
#define BRIGHT_TIME .7 //[0.0 0.5 0.7 1.0]//how long bright and not sunrise colors
#define EVENING_TIME_ .9 //[0.0 1.0 2.0 3.0] //extending day into night

#define EVENING_TIME (4.-1.*EVENING_TIME_)
	
	#define BLOOM_STRENGTH 7 //[0 1 2 3 4 5 6 7 8 9 10] // 3 pixel wide blend	
	#define BLOOM_STRENGTH_WIDE 20 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 30 40 50 60 70 80 90 100]// wide bloom strength
	#define BLOOM_DEPTH_WIDE 8 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 100]//mip layers to use for bloom, each doubles the width
	#define BLOOM_FALLOFF 100 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 100 222 333 555 1000 2222 11111] // for wide bloom
	#define BLOOM_ONLY_BRIGHTS 1 //[0 1]//only bloom bright stuff
	#define BLOOM_ONLY_BRIGHTS_POW 1.7 //[1. 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9  2. 3.]//how  bright something has to be to bloom, thisis exponential decrease of brightness in bloom


	#define PTX_BLOOM_DEPTH_WIDE 5 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 100]//mip layers to use
	#define PTX_BLOOM_FALLOFF 100 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 100 222 333 555 1000 2222 11111] // for wide bloom
	#define PTX_BLOOM_STRENGTH_WIDE 12 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 30 40 50 60 70 80 90 100]
	
	
	#define CLOUD_BLOOM_DEPTH_WIDE 5 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 100]//mip layers to use
	#define CLOUD_BLOOM_FALLOFF 100 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 100 222 333 555 1000 2222 11111] // for wide bloom
	#define CLOUD_BLOOM_STRENGTH_WIDE 12 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 30 40 50 60 70 80 90 100]
	
	#define CLOUDS_FINE_BLOOM_STRENGTH 0 //[0 1 2 3 4 5 6 7 8 9 10] // pixel wide blend	
	
	
	#define COLOR_SPACE 1 //[0 1 2 3 4 5 6 7]
	#define DO_BLURS 1 //[0 1] // 0 DISABLES ALL BLURRING EFFECTS, SOMME OF WHICH IMPROVE QUALITY. bloom is i neffects menu
	
	#define COLOR_BITS 16 //[8 16 32]
	#define COLOR_BITS_SKY 16 //[8 16 32]
	
	
	#define DH_MODE 1 //[0 1]
	
	#define STARS 2 //[0 1 2]
	#define WIDTH_MOVING_WATERG 0.3  //[.1 .2 .3 .4 .5 .6 .7 .8 .9 1. 2. 3. 4. 5.]
#define SCALE_MOVING_GALAXY 3.  //[.1 .2 .3 .4 .5 .6 .7 .8 .9 1. 2. 3. 4. 5.]

#define NIGHT_SKY_SCALE 30. //[1. 2. 3. 10. 20. 30. 40. 50. 60. 70. 100.]
	#define STAR_BRIGHTNESS 0.5 //[.1 .2 .3 .4 .5 .6 .7 .8 0.9 1. 2. 3. 4. 5.]
	#define GALAXY_BRIGHTNESS 0.2 //[.1 .2 .3 .4 .5 .6 .7 .8 .9 1. 2. 3. 4. 5.]
	#define STAR_SCALE 3.0 //[0.5 0.7 0.8 0.9 1.0 2.0 3.0 5.0 7.0 10.0 20.0 30.0 40.0 50.0 60.0 70.0 100.0]
	#define GALAXY_SCALE .7 //[0.0001 0.001 0.01 0.02 0.05 .1 .2 .3 .4 .5 .6 .7 .8 .9 1. 2. 3. 4. 5.]
		#define GALAXY_COLOR_SCALE 0.3  //[.1 .2 .3 .4 .5 .6 .7 .8 .9 1.]
			#define GALAXY_PATCHY_SCALE 0.3  //[0.0001 0.001 0.01 0.02 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
				#define GALAXY_TIME_SCALE 0.01 //[0.001 0.01 0.02 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define STAR_CUTOFF 0.97 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95 0.97 0.99 0.999 1.0]
#define STAR_SIZE 3. //[.1 .2 .3 .4 .5 .6 .7 .8 .9 1. 2. 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11. 12. 13. 15. 20. 30. 100.]
#define STAR_CRISPNESS 8.  //[.1 .2 .3 .4 .5 .6 .7 .8 .9 1. 2. 3. 4. 5.]

#define TILEWG 1000.  //[.1 .2 .3 .4 .5 .6 .7 .8 .9 1. 2. 3. 4. 5.]
#define TILEHG 1000.  //[.1 .2 .3 .4 .5 .6 .7 .8 .9 1. 2. 3. 4. 5.]

#define HAZINESS 0.1 //[0.0 0.01 0.1 0.2 0.3 0.4] 

#define DOWNSAMPLING 0 //[0 1 2 3 4]
#define TRANSLUCENT_MODE 4 //[0 1 2 3 4]

#define PEARL_WATER 0 //[0 1]
#define WATER_F0 0.2  //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define NOISE_TILING 1000.0 //[1.0 100.0 1000.0 5000.0 10000.0]
#define DITHER_TRANS 4 //[0 1 2 3 4 5]
#define FILL_BG 0
#define CAUSTICS 4 //[0 1 2 3 4 5]
#define CAUSTIC_STR .7 //[0.0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.]
#define WATER_CAUSTIC_PASSES 2 // [1 2 3]//how many steps to take drawing water caustics
#define WATER_CAUSTIC_EXPONENT 1 //[0 1]
#define WATER_CAUSTIC_BRIGHTNESS 1 // [-8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5]

#define WATER_FOG 0.2  //[0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_FOG_R 0.4  //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_FOG_G 0.7  //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_FOG_B 1.0  //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WISPS 0 //[0 1]
#define WATER_TRANSLUCENCY_DISTANCE 20.0 //[17.0 20.0 30.0 40.0 50.0 100.0 200.0 1000.0] //cheap temp trick
#define VANILLA_WATER_COLOR .5  //[0. .1 .2 .3 .4 .5 .6 .7 .8 .9 1.]


#define FOG_BLUR 5 //[0 1 2 3 4 5]
#define FOG_AMBIENT_LIGHTING_AMOUNT 0.1  //[0. .01 .02 .03 .04 .05 .06 .07 .08 .09 .1 .15 .17 ]
#define FOG_AMBIENT_LIGHTING 0 //[0 1 2 3 4 5 6 7 8 9 10] //steps, 0 is off. can look like bloom

#define SHADER_LAVA 1 //[0 1 2]
#define LAVA_RESOLUTION 0 //[0 16 32 64 128 256 512 1024]//0 is infinite	

#define CAVE_MOUTH_DUST 0.1  //[0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.12 0.15 0.2 0.3 0.4 0.5]
#define FOG_AMBIENT_SPECULAR 0.1  //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_AMBIENT_LIGHTING_DIST 10000.0 //[10.0 15.0 20.0 30.0 50.0 100.0 10000.0]

#define EXPOSURE_HIGH_PASS 0.9  //[0.7 0.8 0.85 0.87 0.9 0.95 0.97 0.99 1.0]
#define EXPOSURE_HIGH_PASS_RANGE 10.0 //[0.0 0.5 0.7 1.0 1.5 1.7 2.0 3.0 5.0 10.0 15.0 20.0 30.0 50.0 100.0 10000.0]
#define MANUAL_EXPOSURE_RANGE 1.0  //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.3 1.4 1.5 2.0 3.0 4.0 5.0] //lower will be brighter, higher will be darker
	
#define POM 0 //[0 1]

#define RAIN_DROPS 2 //[0 1 2]

#define ONLY_DRAW_DH 0 //[0 1]
#define BUGGY_DH_SHADING 1 //[0 1 2]
#define DISABLE_SKY_RAY_TRACE 1 //[0 1]
#define NO_DH_SHADOWS 1 //[0 1]
#define DH_WETNESS 0.3 //wETNESS OF dISTANT bLOCKS [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define VANILLA_CELESTIALS 0 //Vanilla or resource pack sun, moon, and stars will be on if set to 1 //[0 1] 

#define SUN_COLOR_R 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SUN_COLOR_G 0.80 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SUN_COLOR_B 0.60 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define WAVY_PLANTS 1//plants wave in wind [0 1]
#define DH_REG_CUTOFF 0.9

#define SNOW_ON_FAR_CHUNKS 0 //[0 1]
#define SNOW_DROPS 1 //[0 1]
#define SNOW_EVERYWHERE 0 //[0 1]
#define RAIN_DOWN_SIDES 0.7 //rain overflowing down sides of stuff [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define THAW_TRANSITION_TIME 300.0 //time to transition rain to snow [90.0 100.0 120.0 150.0 170.0 200.0 300.0 400.0 500.0]
#define FREEZE_TRANSITION_TIME 30.0 //time to transition rain to snow [30. 90.0 100.0 120.0 150.0 170.0 200.0 300.0 400.0 500.0]
#define TORCH_MELTS_SNOW 1 //[0 1]
#define SNOW_IN_HAND 1 //[0 1]
#define SLUSH_RANGE 0.05 //[0.001 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.12 0.15] 
#define OLD_SNOW 0 //[0 1 2]
 #define PATHTRACE_WEATHER 0 //[0 1]
 #define SNOW_ON_ENTITES 1 //[0 1]
 #define SNOW_SIZE_DIVIDER  5.0 //[4.0 5.0 6.0 7.0 8.0 9.0 10.0 20.0]
 #define SNOW_DISTANCE 0.8 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
  #define SNOW_DISTANCE_FADE 0.3 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
  
#define SNOW_COLOR_B 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SNOW_COLOR_R 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SNOW_COLOR_G 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define SUN_MELTS_SNOW_AMOUNT 0.8 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.72 0.75 0.77 0.8 0.9 1.0]
#define SUN_MELTS_SNOW 0 //[0 1] 

#define RAIN_RIPPLE_OPACITY 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define SNOW_3D 1 //[0 1] 
#define RAIN_3D 1 //[0 1] 
#define SNOW_ON_WALLS 1 //[0 1] 
 
 #define AUTO_EXPOSURE 1 //[0 1 3]
 
 #define DEFAULT_FRACTAL_DEPTH 3 //[1 2 3 4 5 6 7 8 9 10]
#define SUN_THROUGH_CLOUDS .9 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SUN_THROUGH_CLOUDS_WIDTH .3 //[0.0 0.1 0.2 0.25 0.3 0.35 0.4 0.5 0.7 0.9 1.0]
#define CLOUDS_SHADOW_STUFF 1 //[0 1]
#define SUNLIGHT_ELEVATION_TINT_HEIGHT 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define JANK_TRACING 14 //[5 6 7 8 9 11 12 13 14]

#define WATER_SMOOTHNESS 3.0 //[1.0 1.1 1.2 1.5 1.7 2.0 3.0 4.0 5.0]

#define DIFFUSE_RAY_SMOOTHNESS 0.1 //[0.0 0.01 0.02 0.03 0.04 0.05 0.06 .07 0.08 0.09 0.1 0.11 0.12 0.15 0.17 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 
#define WATER_NO_COLOR 1 //[0 1]

#define DH_RAY_M 2.0 //[1.0 1.2 1.5 1.7 2.0 2.5 3.0]ray multiplier for step size dynamic assumed depth

#define TORCH_LITE_STEPS 20 //[0 10 15 20 25 30 40 50 70 100 120 150 200 500]
#define TORCH_RAYS_X 1.0 //[1.0 2.0 3.0 4.0 5.0 10.0]
#define TORCH_RAYS_Y 1.0 //[1.0 2.0 3.0 4.0 5.0 10.0]
#define HAND_HELD_LIGHTING 2 //[0 1 2]
#define TORCH_POSITION_ON_SCREEN_X 0.75 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.75 0.8 0.9 1.0]
#define TORCH_POSITION_ON_SCREEN_Y 0.3 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.75 0.8 0.9 1.0]
#define TORCH_WIDTH_X 0.02 //[0.0 0.01 0.015 0.02 0.025 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.15]
#define TORCH_WIDTH_Y 0.02 //[0.0 0.01 0.015 0.02 0.025 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.15]
#define TORCH_FLICKERING 1 //[0 1]


#define FAST_PTX 0 //[0 1]
#define FULL_RES_SKY_TRACE 0 //[0] //legacy 0 1, 1

#define VANILLA_CLOUDS 0 //[0 1]

#define FLASH_LIGHT 0 //[0 1]
#define FLASHLIGHT_FLICKER_STR 0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define HOLLOW_CENTER 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define FLASHLIGHT_FLICKER_SPEED 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.5 1.7 2.0 3.0 4.0 5.0]
#define FLASHLIGHT_BRIGHTNESS 5.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.5 1.7 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0]
#define FLASHLIGHT_DISTANCE 1.0 //[1.0]
#define TORCH_DISTANCE 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.5 1.7 2.0 3.0 4.0 5.0]
#define FLASHLIGHT_WIDTH 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.75 0.8 0.9 1.0]

#define NARROW_DIFFUSE_CONE_BY_SMOOTHNESS 1 //[0 1]
#define ELEVATION_LIGHTING 1 //[0 1]
#define PATHTRACE_PARTICLES 1 //[0 1]

#define INTEGRATED_SSS 1 //[0 1]
#define INTEGRATED_PBR 1 //[0 1]
#define INTEGRATED_SSS_STR 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //multiply INTEGRATED Sub Surface Scattering   . which makes things without a pbr texture still maybe have the effect

#define LEFT_HANDED 0 //[0 1]//swap torch sides

#define NOISE_I1 10 //[0 1 2 3 4 5 6 7 8 9 10 15 20 30 40 50]
#define  CLOUD_SHADOWS_ON_STUFF_STR 1.0
#define DYNAMIC_BIOME_SKY 1 //[0 1]

#define SUPER_SMOOTH_DH 0 //[0 1]
#define SMOOTH_DH_NORMALS 0 //[0 1]
#define DH_SMOOTHED_VALUE_ 6 //[0 1 2 3 4 5 6 7 8 9 10]
#define DEFER_WATER 1 //[0 1]
#define DEFER_WATER2 1 //[0 1]

#define GLASS_TINIT_STRENGTH 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define DUAL_CELESTIAL_LIGHTING 0//[0 1]

#define WATERFALLS 4 //[0 1 2 3 4]

#define WATER_TRANSLUCENCY_ANGLE 1.2 //[0.1 0.2 0.3 0.4 0.5 0.6 0.75 0.8 0.9 1.0 1.2 1.5 2.0]
#define VIGNETTE_PTX 1 //[0 1]
#define WATER_FOAM_BRIGHTNESS 0.8 //[0.7 0.8 0.9 1.0]
#define RAIN_RUN_OFF 1 //[0 1]
#define WATERFALL_WHITENESS 1.2 //[0.1 0.2 0.3 0.4 0.5 0.6 0.75 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define WATERFALL_SPEED 2.0 //[1.0 1.1 1.2 1.3 1.4 1.5 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 15.0 20.0 30.0] // 10 looks realiistic for big falsls, 2 looks vanillla friendly for most water and smaller falls

#define WATERFALL_SHINY 1.0 //[1.0 1.1 1.2 1.3 1.4 1.5 2.0]
#define UNDEFER_SHADING 0 //[0 1]
#define REFRACTIONS 4 //[0 1 2 3 4]
#define REFRACT_GLASS 0 //[0 1]

#define HELP_INFO 0 //[0 1]
#define WHITE_WATER_SLANTS 0 //[0 1]
#define DEBUG_TEX_EMISSIVE 1 //[0 1]
#define REFRACTION_STEPS 5.0 //[1.0 2.0 3.0 4.0 5.0]
#define SUNHEAP 0.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.75 0.8 0.9 1.0]
#define DYNAMIC_BIOME_SKY_COLOR 1 //[0 1]
#define H_LAYERS 1 //[0 1]
#define RECESS_POM_IN_PTX 3 //[0 1 2 3 4 5 6]
#define NO_SNOW 0 //[0 1]

#define REFRACTION_DISTANCE 0.1 //[0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14]

#define TEXTURE_FILTER_HAND 1 //[1]
#define PBR_FOR_ENTITIES 1 //[1]

#define BRIGHTNESS_MULT 1.0 [1.0]//unused
#define INDEPENDENT_BRANCHES 1 //[0 1]
#define ABSOLUTE_BIOME_RAIN_CONTROL 1 //[0 1]

#define RIPPLES_OUTSIDE_PUDDLES 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define PBR_DRAINAGE 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define DISABLE_DRAINAGE_WITHOUT_POM 1 //[0 1]
#define SANDSTONE_POROSITY 0.3 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SAND_POROSITY 0.8 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define DIRT_POROSITY 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define RAIN_RIPPLE_SPD 0.2 //[0.1 0.2 0.3 0.4 0.5 0.7 0.9 1.0 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.5 3.0 3.5 4.0 5.0 6.0 7.0 10.0]
#define CLEAN_CLOUDS 1 //[0 1]
#define RIPPLE_RESOLUTION 0 //[0 8 16 32 64 1128 256 513 1024]
#define CLORD_CLEANLINESS 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
	
#define VARIABLE_HEIGHT_POOFY 1 //[0 1]
#define MID_ATMOSPHERE_LAYERS 0 //[0 1 5 10 20 50 100]

#define PATCHY_BY_LAYER 2 //3 is very expensive[0 1 2 3]
#define PARTIAL_FOG_BLENDING_METHOD 3 //[0 1 2 3]//old ibackwards, multiplied, straight, percent of depth

#define WATER_COLOR_ABSORPTION_MULT 0.3 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_SUN_DEPTH 30.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 10.0 20.0 30.0 63.0 100.0 200.0 300.0] //inverted

#define CLOUD_PATCH_CUTOFF_V 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]//REMOVE THIS MUCH CLOUD IN PATCHES
#define CLOUD_PATCHY_STR_V 5.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 5.0 10.0 20.0 100.0] // PATCHY STRENGTH FOR CLOUDS . higher is more defined patches with holes in clouds . loweer is full cloud cover



//NEW
#define DARKEN_MISSING_REFRACTION_DATA_INVERTED 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define BORDERS 0 //[0 1]

#define WEATHER_AS_TRANSLUCENT 0 //[0 1]
#define HAND_AS_WATER 0 //[0 1]


#define DAILY_WEATHER 0 //[0 1]
#define COS_SCROLL 0 //[0 1]

#define LIT_ENTIRE_SKY 1 //[0 1]

#define ACCENTUATE_TORCH_SMOOTHNESS 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define BIOME_WATER 1 //[0 1]
#define ALGAE 1 //[0 1]
#define SHADE_ALGAE 1 //[0 1]
#define OCEAN_DEEP_STYLE 5 //[0 1 2 3 4 5]
#define SHADING_STEPS_OCEAN 3 //[1 1 2 3 4 5 6 7 8 9 10 11 20 30 100]

#define DH_FADE .3 //[0.0001 .1 .2 .3 .4 .5]// how far to fade close chunks into far chunks
#define GLOWING_DEEP_ALGAE 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define	OCEAN_DEPTH_LAYER_SIZE 1.9 //[1.0 1.3 1.4 1.5 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.5 2.7 3.0 4.0 5.0]//also affects shading strength of volumetics
#define TEMPERATURE_MOON_GLOWING_ALGAE 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.7 1.8 2.0]
#define RAINFALL_MOON_GLOWING_ALGAE 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TEMPERATURE_DEEP_GLOWING_ALGAE 0.3 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define ONLY_I2_SHADOW 0 //[0 1]
#define REFRACTION_WARBLE_WHERE_NO_INFO 0.0 //[0.0 1.0]
#define GEM_GLASS 0 //[0 1]
#define MAXIMUM_ALBEDO 1.0 ////[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define SUN_DIRECT_WATER_PENETRATION 0.0 ////[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WEATHER_BUFFFER 0 //[0 1]
#define UPPER_ATMOSPHERE_LAYERS 40.0 //[0.0 1.0 5.0 10.0 20.0 30.0 40.0 41.0 50.0 100.0]
#define UPPER_ATMOSPHERE_CLOUD_LAYERS 0 //[0 1 5 10 20 50 100]
#define REINHART 0 //[0 1 2 3 4]

#define LIGHTNING_PROC 2 //[0 1 2]
#define DEBUG_CLOUDS 0 //[0 1]
#define CLOUD_SHADING_ON_SKYLIGHT 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define FALLBACK_CIRRUS_SHADOWS 1 //[0 1] 
#define FADE_PRE_GLASS_FOG 1 //[0 1]

#define BG_LIT_AMBIENT_LIGHT 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define BG_LIT_SKY_LIGHTING 0.1 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define BG_LIT_FREQUENCY 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define LIGHTNING_SROBE_STR_STEADY 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LIGHTNING_SROBE_STR_1 0.2 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LIGHTNING_SROBE_STR_2 0.1 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LIGHTNING_SROBE_SPD_1 30.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 20.0 30.0 40.0 50.0]
#define LIGHTNING_SROBE_SPD_2 31.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 20.0 31.7 40.0 50.0]
#define LIGHTNING_SROBE_SPD_NONE 5.17 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 3.0 4.0 5.0 5.17 6.0 7.0 10.0]

#define LIT_R 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LIT_G 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LIT_B 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LIT_A 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define GLASS_DIST_BIAS 0.05 //fix jumpy water on low res, nut hole in it when on surface [0.001 0.01 0.02 0.05 0.1 0.0]

#define TM_AMPLITUDE 0.0 //[-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TM_WHITE 3.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 2.0 3.0 4.0 5.0 10.0 100.0]
#define TONEMAPPING 0 //[1 2 3 4 5 6 7]

#define EXPOSURE_PRE 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 3.0 4.0 5.0 10.0]
#define AUTO_EXPOSURE_RANGE 1.7  //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 3.0 4.0 5.0] //lower 
#define AUTO_EXPOSURE_LOW 0.3 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 3.0 4.0 5.0 10.0]
#define AUTO_EXPOSURE_HIGH 3.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 3.0 4.0 5.0 10.0]
#define AE_CHECK_CORNERS 1 //[0 1]

#define AE_SPD 0.9 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define PBR_EMMISSIVE_STRENGTH 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12 13 14.0 15.0 20.0 30.0 100.0] //how brightly glowing things glow

#define RESTORE_ARTIST_INTENTIONS 0 //[0 1]
#define AE_CORNERS_STR 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FLASH_BANG_LIMIT 2.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 3.0 4.0 5.0 10.0 100.0 1000.0 10000.0 100000.0 1000000.0]

#define AE_LUMINANCE_R 0.2 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define AE_LUMINANCE_G 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define AE_LUMINANCE_B 0.1 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define AE_SAMPLE_WIDTH 5 //[1 2 3 4 5 6 7  9 10 11 12 13 14 15 16 111]
#define GLASS_FLIP_BIAS 0.001 //[0.0 0.001 0.01 0.02 0.05 0.1 0.0]

#define LIMIT_CLOUD_SHADING_BY_STEPSIZE 0 //[0 1]

#define DYNAMIC_SKY_SS 0 //[0 1]
#define SS_PARTIAL 0 //[0 1]
#define SS_SHADOWS 0 //off, cheap, more ccurate//[0 1]

#define POM_SHADOWS_ACCURATE 1 //[0 1]
#define WRITE_SP 0 //[0 1]

#define SS_SUN_SHADOW_STEPS 20 //[10 20 30 40 50 60 70 100 200]
#define SS_SUN_SHADOWS_RANGE 0.25 //[0.25 0.5 0.75 1.0 2.0 3.0 5.0 10.0 100.0]
#define SS_SUN_SHADOWS_MAX_RANGE 0.25 //[0.25 0.5 0.75 1.0 2.0 3.0 5.0 10.0 100.0]
#define NORMALS_BIT_DEPTH 16 //[8 16]
#define SSS_DECAY_CURVE 5.0 //[0.5 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.7 2.0 3.1 5.0 6.0 7.0 8.0 9.0 10.0]
#define FULL_DARKNESS 1 //[0 1]

#define ROUGH_FRESNEL_CURVE 10.0 //[2.0 2.5 3.0 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 9.0 10.0]
#define FRESNEL_CURVE 6.0 //[2.0 2.5 3.0 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 9.0 10.0 11.00 15.0 20.0]
#define PTX_DIFFUSE_RANGE 10.0 //[1.0 2.0 3.0 5.0 10.0 15.0 20.0 50.0 70.0 100.0]
#define PTX_CHECK_NORMALS 2 //[0 1 2]
#define PTX_TORCH_DIFFUSE_RANGE_WORKAROUND 0 //[0 1]
#define INFINITE_DIFFUSE_PTX_RANGE 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define DIFFUSE_PTX_EXP_STEP 2.0 //[1.0 1.1 1.2 1.3 1.4 1.5 1.7 1.5 2.0 3.0]

//5-24 p2
#define MINIMUM_BIOME_CLOUDS 0.0 //least amount for biome control//[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define MINIMUM_BIOME_CLOUDS_HI 0.2 //least amount for biome control//[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WEATHER_EFFECT 0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SKY_REFLECTION 1 //[0 1]

#define SSS_SHALLOW 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SSS_DEEP 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define THE_ONION 1 //[0 1 2 3 4 5 6 7]

#define POM_SHADOW_DEPTH 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SM_BIAS_N 0.1 //[0.0 0.01 0.05 0.1 0.2]//in block, by normal if facinf perpendicular to sun rays
#define SM_BIAS 0.01 //[0.0 0.01 0.05 0.1 0.2]//in block, by normal if facinf perpendicular to sun rays
#define CRISP_BLOCK_EDGES_SHADOWS 1 //[0 1]

#define OFF_SCREEN_BOUNCES 1 //[0 1 2 3]
#define ONION_HEIGHT 0.314 //[0.0 0.1 0.2 0.3 0.31 0.314 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 
#define SMOOTHNESS_EXPONENTIAL 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 2.5 3.0]

#define PRIORITIZE_SS_SKY 0 //[0 1] // over onion
#define SMOOTH_ONION_BORDER 1 //[0 1] // over onion
#define FADE_SS_SKY_EDGE 0 //[0 1] // over onion
#define ONION_NO_VIGNETTE 0 //[0 1] // over onion
#define PTX_CHECK_ONION_NORMALS 0 //[0 1] // over onion

#define CLOUD_SAMPLES_FOR_STYLE_1 5 //[1 2 3 4 5]
#define PTX_SINGLE_PIXEL 0 //[0 1] // over onion
#define EARLY_SHADOW_CLOUDS 1 //[0 1] // over onion

#define SKY_ONION_UPDATE_D 11111.0 //[90.0 200. 1000.0 11111.0 FAR_CLOUDS]
#define SKY_ONION_UPDATE_SPEED 200 //[1 10 20 30 40 50 70 100 200 1000 10000]
#define SKY_ONION_REFRESH_FADE_SPD 0.01 //[0.01 0.02 0.05 0.1 0.2 0.3 0.5 1.0]
#define ONION_SKY_BEHIND 1 //[0 1]

#define PBR_AO_CPF 0.5 // [0.0 0.25 0.5 0.75 1.0 ] // Ambient Occlusion from Textures, strength of effect. Darkens crevices

		#define SUN_SPECULAR_INDOOR_FALLOFF_CPF 1.0 //[ 0.05 0.1 0.15 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.75 2.0 2.5 3.0] // PBR QUALITY 2+ . Limit sky color reflections and rain indoors by this falloff rate. 
		#define PBR_WETNESS_CPF 1.0 // [0.0 0.25 0.5 0.75 1.0 ] // Wetness effect from rain . Darkens porous materials . Adds reflectivity
		#define PBR_WETNESS_DARKENING 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 ] // Wetness effect from rain to Darken porous materials . This stacks with REDUCE_DIFFUSE_BY_REFLECTIVITY
		#define WET_F0 0.1 // [0.0 0.005 0.02 0.1 0.015 0.2 0.025 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 ] // Reflectivity of wet stuff

#define OFFSCREEN_PTX_STEPS 0 //[0 5 10 20 30 40 50]
#define DARKEN_ONION_SKY_INDOORS 1 //[0 1]
#define ONION_MIPS 3 //[0 1 2 3 4 5 6 7 8 9 10]
#define ONION_SKY_FADE_SPEED 0.05 //[0.01 0.05 0.07 0.1 0.2 0.3 0.5 1.0]
#define LESSEN_REFLECTIONS_BY_BOUNCE_NUMBER 1 //[0 1]// not counting onion stepping
#define EXTRA_DARK_T_STORMS 0 //[0 1]
#define PTX_CHECK_PBR_AT_COLLISION 1 //[0 1]

#define ONION_HD 0 //[0 1]
#define SS_SUN_SHADOWS_ASSUMED_DEPTH 0.04 //[0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.5 0.75 1.0]

#define TORCH_SHADOWS_ASSUMED_DEPTH 0.1 //[0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.5 0.75 1.0]

#define DELICATE_TORCH_DEPTH 0 //[0 1]

#define USE_CACHED_CLOUDS 0 //[0 1]
#define BASIC_REFLECTIONS_ONLY 0 //[0 1 2]

#define REFLECTION_CUTOFF 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SKY_ONION_ORIENTATION 0 //[0 1]
#define PERFECT_ONION 1 //[0 1]
#define CACHE_CLOUD_DOWNSCALING 1 //[0 1 2 3]


#define SKY_ONION_TOP_BORDER 2 //[0 1 2 3 4 5 6 7 8 9 10]
#define SKY_ONION_RIGHT_BORDER 1 //[0 1 2 3 4 5 6 7 8 9 10]
#define EXPONENTIAL_TORCH_FALL_OFF 1.0 //[1.0 1.5 2.0 3.0 5.0 10.0 11.0 12.0 15.0 17.0]
#define EXPONENTIAL_SKY_FALL_OFF 1.0 //[1.0 1.5 2.0 3.0 5.0 10.0 11.0 12.0 15.0 17.0]
#define ONION_SKY_ONLY_IN_BLOCK_SKY 0 //[0 1]

#define BLEND_PIXELS 0 //[0 1]
#define BLEND_PIXELS_SOFTNESS 0.3 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define G_NORM_MAP_STR 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 3.0 4.0 5.0 7.0 10.0]
#define G_NORM_MAP_SUB_PIXEL_STR 0.2 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define G_NORM_SP_RES 16.0 //[1.0 8.0 16.0 32.0 64.0 128.0]


#define SHADOWS 0 //[0 1 2 3 4 5 6]
#if IS_THE_NETHER == 1
	//#define SHADOWS 0
#endif

#define UPSCALE_TERRAIN 1 //[0 1]
#define UPSCALE_ENTITIES 1 //[0 1]
#define UPSCALE_HAND_HELD 0 //[0 1]
#define UPSCALE_PARTICLES 0 //[0 1]

#define FOG 1 //[0 1]
#define FOG_START 10.0//[0.0 10.0 20.0 100.0]
#define FOG_END 1000.0//[20.0 100.0 200.0 300.0 400.0 500.0 700.0 1000.0 2000.0 5000.0 10000.0]
#define FOG_MAX 0.0 //[0.0 0.25 0.5 0.75 1.0]
#define BORDER_FOG_START 0.75 //[0.0 0.25 0.5 0.75 0.8 0.9]

#define TORCH_FALLOFF 1.0 //[1.0 2.0 3.0 4.0 5.0]
#define SKY_LIGHT_FALLOFF 1.0 //[1.0 2.0 3.0 4.0 5.0]
#define SKY_LIGHT_BRIGHTNESS 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TORCH_BRIGHTNESS 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.7 2.0 2.5 3.0]

#define CUSTOM_TORCH_COLOR 0 //[0 1 2]
#define TORCH_HI_R  1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TORCH_LOW_R  1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TORCH_HI_G  0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TORCH_LOW_G  0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TORCH_HI_B  0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TORCH_LOW_B  0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define SUN_BRIGHTNESS 1.0 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0 1.1 1.25 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.7 2.8 3.0 3.1]
#define MOON_BRIGHTNESS 1.0 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define MINIMUM_LIGHT_LEVEL 0.00 //[0.00 0.001 0.002 0.003 0.004 0.005 0.006 0.07 0.008 0.009 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.6 0.7 0.8 0.9 1.0]
#define MINIMUM_LIGHT_LEVEL_NETHER 0.00 //[0.00 0.001 0.002 0.003 0.004 0.005 0.006 0.07 0.008 0.009 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.6 0.7 0.8 0.9 1.0]

#define EXTRA_DARK_NIGHT 5 //[0 1 2 3 4 5 6 7 8 9 10]
#define DIRECTIONAL_LIGHTING 0 //[0 1]
#define DONT_BLOW_OUT_WHITES 1 //[0 1 2]

#define BACK_LIT_GRASS 2 //[0 1 2 3 4 5 6 7 8 9 10]

#define No_PBR_Textures 0
#define Only_Normal_Maps 1
#define LabPBR_Textures 2

#define PBR No_PBR_Textures //[No_PBR_Textures Only_Normal_Maps LabPBR_Textures]

#define NON_DIRECTIONAL_AMBIENT_SKY_LIGHT  0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define AMBIENT_OCCLUSSION_TEXTURES  1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SHOW_MOB_DAMAGE 1 //[0 1]
#define SUN_WIDTH 0.0025 //[0.001 0.002 0.0025 0.003 0.004 0.005 0.006 0.007 0.008 0.009 0.001 0.002]
#define METAL_SMOOTHER 0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SKY_COLOR_ALTERNATE 0 //[0 1 2]
#define CUSTOM_SUN_COLOR 0 //[0 1]

#define MOON_COLOR_R 0.70 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define MOON_COLOR_G 0.90 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define MOON_COLOR_B 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define SUNSET 2 //[0 1 2]

#define SUNSET_FADE_R 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0]
#define SUNSET_FADE_G 1.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0]
#define SUNSET_FADE_B 2.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0]

#define BORDER_SAMPLES 12 //[4 8 12 16]
#define SHADOW_SAMPLES 16.0 //[2.0 3.0 4.0 5.0 8.0 10.0 15.0 16.0 20.0 30.0 40.0 50.0 60.0 100.0]
const float SHADOW_SAMPLES8 = SHADOW_SAMPLES/8.+(fract(SHADOW_SAMPLES)/8.)>=.2? 8.:0. ;

#define PRENUMBRA_WIDTH 0.7 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 20.0 30.0 40.0 50.0 70.0 80.0 90.0 100.0 210.0 100.0 1000.0]

#define SHADOW_SOFTNESS_WEIGHT 1.0 //[0.0 0.001 0.01 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SHADOW_NOISE_VARIATION 0.001 //[0.0 0.001 0.01 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SHADOW_NOISE_STR 0.1 //[0.0 0.001 0.01 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FLIP_SHADOW_SPIRAL_RANDOMLY 0 //[0 1 2]
#define SHADOW_WEIGHT_EXPONENT 1.0//[1.0 2.0 3.0 4.0 5.0 7.0 19.0]

#define SHADOW_SUB_PIXEL_SEED_RES 111.0 //[1.0 8.0 10.0 16.0 32.0 64.0 128.0 256.0 512.0 1024.0]
#define SHADOW_EXTRA_SOFTNESS 1.0//[0.0 0.25 0.5 0.75 1.0 2.0 3.0 4.0 5.0]
#define PRENUMBRA_INFO 0 //[0 1]

#define SSS 1 //[0 1 2]

#define PUDDLE_DEPTH 0.85 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.85 0.9 1.0]


#define HAND_HELD_TORCH 1 //[0 1]
#define HAND_HELD_TORCH_RANGE 20.0 //[5.0 10.0 15.0 20.0 30.0]
#define TORCH_LIGHT_3D 0 //[0 1 2]
#define TORCH_HORIZONTAL_OFFSET 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.3 1.4 1.5 1.7 2.0] 
#define TORCH_V_OFFSET 0.2 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.3 1.4 1.5 1.7 2.0]
#define TORCH_Z_OFFSET 0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.3 1.4 1.5 1.7 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0]

#define GRASS_SHADOWS 0 //[0 1]
#define ENTITY_TEX_FILTER_FIX 1 //[0 1 2]
#define HAND_TEX_FILTER_FIX 2 //[0 1 2]

#define WIDEN_FILTERED_THINGS 1 //[0 1]
#define DH_SHADOWS 0 //[0 1]
#define DH_FOG_END 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define SMOOTH_DH_FADE_IN 2 //[0 1 2]

#define CLOUD_FOG 1 //[0 1]

#define BORDERS_IN_DH 1 //[0 1]
#define DH_BORDERS_FADE 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.85 0.9 1.0 1.5 1.7 2.0 2.5 3.0 3.5 4.0 5.0 10.0]
#define BORDERS_SENSITIVITY 0.05//[0.05 0.07 0.1 0.12 0.15 0.2 0.3 0.4 0.5]
#define FOG_HIDES_DH_BORDERS 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define EXPONENTIAL_FOG_ 1 //[0 1 2]
#if EXPONENTIAL_FOG_ == 1
	#if defined IS_IRIS && defined DISTANT_HORIZONS
		#define EXPONENTIAL_FOG 1
	#else
		#define EXPONENTIAL_FOG 0
	#endif
#else
	#if EXPONENTIAL_FOG_ == 2
		#define EXPONENTIAL_FOG 1
	#else
		#define EXPONENTIAL_FOG 0
	#endif
#endif

#define DH_TEXTURE 0 //[0 1]
#define DH_NOISE_FRACTAL_STEPS 2 //[1 2 3 4 5]
#define DH_FANCY_NOISE 1 //[0 1]
#define DH_TEXTURE_STR 0.1 //[0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.1 0.15 0.17 0.2]
#define LONG_SUNSET_SHADOWS 1 //[0 1]

#if DH_SHADOWS == 0
	const float shadowDistanceRenderMult = 1.0;
#else
	const float shadowDistanceRenderMult = -1.0;
#endif
const float shadowDistance = 75.0; //[20.0 50.0 75.0 100.0 120.0 150.0 175.0 200.0 256.0 512.0 1000.0 2000.0 3000.0 5000.0 10000.0 -1.0]
#if DH_SHADOWS == 1 && LONG_SUNSET_SHADOWS == 1
	
	const float shadowNearPlane= -1. ;//[20.0 50.0 100.0 256.0 512.0 1000.0 2000.0 3000.0 5000.0 10000.0 -1.0]
	const float shadowFarPlane= -1. ; //[20.0 50.0 100.0 156.0 256.0 512.0 1000.0 2000.0 3000.0 5000.0 10000.0 -1.0]
	
#endif

#define DUAL_DISTORT 0 //[0 1]


#define DEBUG_SHADOWS 0 //[0 1]

#define GODRAYS 0 //[0 1]
#define FIX_COLOR_SPACE 0 //[0 1]

#define GODRAY_SAMPLES 30.0 //[5.0 10.0 16.0 20.0 30.0 35.0 40.0 50.0 100.0]
#define SUN_GR_HAZE 0.1 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define GR_SUN_WIDTH 0.0  //[0.0 0.1 0 15 0.2 0.25 0.3 0.35 0.4 0.45]
#define GR_STR 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define GODRAY_DITHER 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NOON_GODRAYS 0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define GR_VIEW_SMOOTH 2.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.5 1.7 2.0 2.5 3.0 4.0 5.0]

#define FANCY_WATER 0 //[0 1]

#define BORDER_OPACITY 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define DH_FLYING_FIX_CIRCLE 1 //[0 1]
#define DH_FLYING_FIX_CIRCLE_ONLY_IN_AIR 1 //[0 1]
#define DH_FLYING_FIX_CIRCLE_SPEED 3.0 //[0.01 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.5 1.7 2.0 2.2 2.5 2.7 3.0 5.0 7.0 10.0 15.0 20.0 30.0];
#define DEBUG_FIX_CIRCLE 0 //[0 1]

#define FORCE_CRISP_SHADOWS 0 //[0 1]
#define BRIGHTER_UNDERWATER 0 //[0 1]
#define FADE_SHADOWS 1 //[0 1]
#define SHADOW_FADE 0.3 //[0.1 0.2 0.3 0.4 0.5]

#define DEBUG_MODE 0 //[0 1 2 3]

#define CLOUDS 0 //[0 1]

#define POTATO_SHADOWS 1 //[0 1]

#define PULSING_FOG 0 //[0 1]
#define PULSING_AMBIENT_LIGHT 1 //[0 1]


//Voxelizing
#define WHERE_TO_VOXELIZE 2 //[1 2]
#define FLOODFILL_LIGHTING 2 //[0 1 2 3 4 7]
//get voxel map position
#define VOXEL_AREA 128 //[32 48 64 96 128 160 192 224 256 512 1024]
#define VOXEL_RADIUS (VOXEL_AREA/2)
#define VOXEL_AREA_X_2 (VOXEL_AREA * 2)

//get which voxel this is in 2 ways
#define VOXEL_POSITION_RECONSTRUCTION_METHOD 1 //[1 2]
#define FLICKERING_TORCHES 2 //[0 1 2 3]
#define LIGHT_FALLOFF 2 //[1 2] 
#define LIGHT_FALLOFF_RATE 0.80 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98]
#define BLOCK_LIGHT_BRIGHTNESS 2.5 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.5 1.7 2.0 2.5 3.0 4.0 5.0]
#define EXTRA_VIBRANT_BL 0 //[0 1]

#define BLOCK_LIGHT_BRIGHTNESS_IN_DAYLIGHT 0.20 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define OVERRIDE_FIRE 0 //[0 1]
#define OVERRIDE_LAVA 1 //[0 1]
#define OVERRIDE_TORCHES 1 //[0 1]
#define OVERRIDE_CAMPFIRE 0 //[0 1]
#define LAVA_LEVEL 32.0 //[0.0 32.0 64.0 100.0 300.0 1000.0] 

#define VOXEL_PHOTON_SIMULATION_QUALITY 2 //[1 2]
#define SAVE_WRITES 0 //[0 1]

#define USE_HARD_CODED_GLASS_COLORS 1 //[0 1]

#define DONT_VOXELIZE_CARPETS 1 //[0 1]
#define MOB_SHADOWS 0 //[0 1]
#define VOXELIZE_ENTITIES 1 //[0 1]

#define LIGHT_UPDATE_SPEED 1 //[1 3 5]
#define FADE_LIGHT_UPDATES 1 //[0 1]
#define FADE_LIGHT_UPDATES_AMOUNT 0.40 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90]

#define PBR_LPV_EMISSION 0 //[0 1]

#define PARTICLES_LPV 0 //[0 1]

#define LPV_PARTICLES_BY_LM 1 //[0 1]

#define LIGHT_VIIBRANCE 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define GLOWING_CONCRETE 0 //[0 1]

#define GLOWING_ROCKETS 1 //[0 1]



#define ADJUST_SATURATION 1 //[0 1]
#define LIGHT_COLOR_SATURATION 1.0 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0 1.25 1.5 1.75 2.0 2.5 3.0 3.5 4.0 4.5 5.0]
 
#define PBR_EMMISIVENESS_IN_VOXELS_TERRAIN 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

 
#define EPBR_EMMISIVENESS_IN_VOXELS_ENTITY 0.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define VOXELIZE_GRASS 1 //[0 1]//10000

#define VANILLA_lIGHTING 1 //[0 1]

#define TONEMAPPING_BRIGHTNESS 0.90 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define TONEMAPPING_RANGE 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define TONEMAPPING2_STRENGTH 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define NAMETAG_OPACITY 0.25 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]


#define RAIN_OPACITY 0.33 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define LPV_BLOCKS_BY_LM 0 //[0 1]


#define PARTIAL_BLOCKS_OCCLUDE 0 //[0 1] 

#define GLOW_BERRIES_R 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define GLOW_BERRIES_G 0.90 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define GLOW_BERRIES_B 0.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define FROG_OCHE_R 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define FROG_OCHE_G 0.90 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define FROG_OCHE_B 0.55 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define FROG_PEARL_R 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define FROG_PEARL_G 0.55 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define FROG_PEARL_B 0.55 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define FROG_VER_R 0.55 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define FROG_VER_G 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define FROG_VER_B 0.55 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define LAVA_BRIGHT_R 0.55 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define LAVA_BRIGHT_G 0.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define LAVA_BRIGHT_B 0.55 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define LAVA_DARK_R 0.55 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define LAVA_DARK_G 0.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define LAVA_DARK_B 0.55 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define FIRE_BRIGHT_R 0.55 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define FIRE_BRIGHT_G 0.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define FIRE_BRIGHT_B 0.55 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define FIRE_DARK_R 0.55 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define FIRE_DARK_G 0.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define FIRE_DARK_B 0.55 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

 #define SOUL_FIRE_BRIGHT_R 0.60 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SOUL_FIRE_BRIGHT_G 0.80 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SOUL_FIRE_BRIGHT_B 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define SOUL_FIRE_DARK_R 0.20 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SOUL_FIRE_DARK_G 0.30 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SOUL_FIRE_DARK_B 0.70 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
 
//RED_STONE_R RED_STONE_G RED_STONE_B vec3(1.,0.1,.04)
#define RED_STONE_R 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define RED_STONE_G 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define RED_STONE_B 0.04 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
 
 #define COLORED_LIGHT_SPEC 1//[0 1]
 
 #define DBLX_MULT 2.0 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.25 1.5 1.75 2.0 3.0 5.0]
 
 #define CRYSTAL_SSS 0 //[0 1]
 
  #define VANILLA_AO_EXPONENT 1.5 //[1.0 1,1 1.2 1.3 1.5 1.7 2.0]
  
  #define CONSTRAIN_TO_VANILLA_LIGHTMAP_DISTANCE 0 //[0 1] 
  
  
   #define METAL_AMBIENT 0.20 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
 
 #define METAL_AMBIENT_LIT 1 //[0 1]

 #define DIFFFUSE_VX_BEHAVIOR 1 //[1 2]
  #define SPECULAR_VX_BEHAVIOR 1 //[1 2 3]
 
  
 #define NETHER_RED_AMBIENT_LIGHT 1 //[0 1]


#define GLOW_FRAME_R 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define GLOW_FRAME_G 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define GLOW_FRAME_B 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define LIGHT_BLOCK_R 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define LIGHT_BLOCK_G 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define LIGHT_BLOCK_B 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define SOUL_LANTERN_R 0.30 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SOUL_LANTERN_G 0.40 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SOUL_LANTERN_B 0.90 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define SOUL_LANTERN_R_HIGH 0.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SOUL_LANTERN_G_HIGH 0.70 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SOUL_LANTERN_B_HIGH 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

//shadow controls for performance -2025-4
	#define ENTITY_SHADOWS 1 //[0 1]
		//shadowEntities=<true|false>

	#define PLAYER_SHADOW 1 //[0 1]	
		// - iris only - _ shadowPlayer=<true|false>
		
	#define BLOCK_ENTITY_SHADOWS 1 //[0 1]	
		//shadowBlockEntities=<true|false>
		
			// - iris only - shadowLightBlockEntities=<true|false>
			// voxelizeLightBlocks=<true|false>
			
	//const float entityShadowDistanceMul = 1.0; //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 
	
//> SHADOW EXTRA OPTIONS



 #define FLICKERING_FIRE 0 //[0 1]




#define PIXEL_LOCKED_SHADOW_RES 5555 //[1 2 4 8 16 32 64 128 256 512 1024 2048 5555]

#define MINIMUM_LIGHT_LEVEL_END 0.20 //[0.00 0.001 0.002 0.003 0.004 0.005 0.006 0.07 0.008 0.009 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.6 0.7 0.8 0.9 1.0]

#define SHADOW_BIAS_PL 0.40 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

 #define LAVA_NOISE_ORGANIC 0 //[0 1]

#define CAVE_LIGHT_LEAK_FIX 1 //[0 1 2]
#define CAVE_LIGHT_LEAK_2_EXP 1.0 //[0.25 0.5 1.0 2.0 3.0 4.0]

const float eyeBrightnessHalflife = 40.0;
#define CAVE_DARKNESS_DEPTH 20.0 //[0,0 10.0 20.0 30.0]
#define SEA_LEVEL 63.0 //[-200.0 -100.0 0.0 63.0 64.0 100.0 200.0 300.0 400.0 500.0 600.0 700.0 800.0 900.0 1000.0 1024.0]



//version 0.3.4
#define VOXELIZE_PLAYER 1 //[0 1]
#define RANGE_FOR_DISABLING_PLAYER_HELD_LIGHTS 2.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.10 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.30 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.40 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.50 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.60 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.70 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.80 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.90 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.00 2.01 2.02 2.03 2.04 2.05 2.06 2.07 2.08 2.09 2.10 2.11 2.12 2.13 2.14 2.15 2.16 2.17 2.18 2.19 2.20 2.21 2.22 2.23 2.24 2.25 2.26 2.27 2.28 2.29 2.30 2.31 2.32 2.33 2.34 2.35 2.36 2.37 2.38 2.39 2.40 2.41 2.42 2.43 2.44 2.45 2.46 2.47 2.48 2.49 2.50 2.51 2.52 2.53 2.54 2.55 2.56 2.57 2.58 2.59 2.60 2.61 2.62 2.63 2.64 2.65 2.66 2.67 2.68 2.69 2.70 2.71 2.72 2.73 2.74 2.75 2.76 2.77 2.78 2.79 2.80 2.81 2.82 2.83 2.84 2.85 2.86 2.87 2.88 2.89 2.90 2.91 2.92 2.93 2.94 2.95 2.96 2.97 2.98 2.99 3.00 3.01 3.02 3.03 3.04 3.05 3.06 3.07 3.08 3.09 3.10 3.11 3.12 3.13 3.14 3.15 3.16 3.17 3.18 3.19 3.20 3.21 3.22 3.23 3.24 3.25 3.26 3.27 3.28 3.29 3.30 3.31 3.32 3.33 3.34 3.35 3.36 3.37 3.38 3.39 3.40 3.41 3.42 3.43 3.44 3.45 3.46 3.47 3.48 3.49 3.50 3.51 3.52 3.53 3.54 3.55 3.56 3.57 3.58 3.59 3.60 3.61 3.62 3.63 3.64 3.65 3.66 3.67 3.68 3.69 3.70 3.71 3.72 3.73 3.74 3.75 3.76 3.77 3.78 3.79 3.80 3.81 3.82 3.83 3.84 3.85 3.86 3.87 3.88 3.89 3.90 3.91 3.92 3.93 3.94 3.95 3.96 3.97 3.98 3.99 4.00 4.01 4.02 4.03 4.04 4.05 4.06 4.07 4.08 4.09 4.10 4.11 4.12 4.13 4.14 4.15 4.16 4.17 4.18 4.19 4.20 4.21 4.22 4.23 4.24 4.25 4.26 4.27 4.28 4.29 4.30 4.31 4.32 4.33 4.34 4.35 4.36 4.37 4.38 4.39 4.40 4.41 4.42 4.43 4.44 4.45 4.46 4.47 4.48 4.49 4.50 4.51 4.52 4.53 4.54 4.55 4.56 4.57 4.58 4.59 4.60 4.61 4.62 4.63 4.64 4.65 4.66 4.67 4.68 4.69 4.70 4.71 4.72 4.73 4.74 4.75 4.76 4.77 4.78 4.79 4.80 4.81 4.82 4.83 4.84 4.85 4.86 4.87 4.88 4.89 4.90 4.91 4.92 4.93 4.94 4.95 4.96 4.97 4.98 4.99 5.0]

#define ENTITY_LIGHTING_ANGLE_X -0.5 //[-1.0 -0.99 -0.98 -0.97 -0.96 -0.95 -0.94 -0.93 -0.92 -0.91 -0.9 -0.89 -0.88 -0.87 -0.86 -0.85 -0.84 -0.83 -0.82 -0.81 -0.8 -0.79 -0.78 -0.77 -0.76 -0.75 -0.74 -0.73 -0.72 -0.71 -0.7 -0.69 -0.68 -0.67 -0.66 -0.65 -0.64 -0.63 -0.62 -0.61 -0.6 -0.59 -0.58 -0.57 -0.56 -0.55 -0.54 -0.53 -0.52 -0.51 -0.5 -0.49 -0.48 -0.47 -0.46 -0.45 -0.44 -0.43 -0.42 -0.41 -0.4 -0.39 -0.38 -0.37 -0.36 -0.35 -0.34 -0.33 -0.32 -0.31 -0.3 -0.29 -0.28 -0.27 -0.26 -0.25 -0.24 -0.23 -0.22 -0.21 -0.2 -0.19 -0.18 -0.17 -0.16 -0.15 -0.14 -0.13 -0.12 -0.11 -0.1 -0.09 -0.08 -0.07 -0.06 -0.05 -0.04 -0.03 -0.02 -0.01 0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]

#define ENTITY_LIGHTING_ANGLE_Y 1.0 //[-1.0 -0.99 -0.98 -0.97 -0.96 -0.95 -0.94 -0.93 -0.92 -0.91 -0.9 -0.89 -0.88 -0.87 -0.86 -0.85 -0.84 -0.83 -0.82 -0.81 -0.8 -0.79 -0.78 -0.77 -0.76 -0.75 -0.74 -0.73 -0.72 -0.71 -0.7 -0.69 -0.68 -0.67 -0.66 -0.65 -0.64 -0.63 -0.62 -0.61 -0.6 -0.59 -0.58 -0.57 -0.56 -0.55 -0.54 -0.53 -0.52 -0.51 -0.5 -0.49 -0.48 -0.47 -0.46 -0.45 -0.44 -0.43 -0.42 -0.41 -0.4 -0.39 -0.38 -0.37 -0.36 -0.35 -0.34 -0.33 -0.32 -0.31 -0.3 -0.29 -0.28 -0.27 -0.26 -0.25 -0.24 -0.23 -0.22 -0.21 -0.2 -0.19 -0.18 -0.17 -0.16 -0.15 -0.14 -0.13 -0.12 -0.11 -0.1 -0.09 -0.08 -0.07 -0.06 -0.05 -0.04 -0.03 -0.02 -0.01 0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]

#define ENTITY_LIGHTING_ANGLE_Z 0.0 //[-1.0 -0.99 -0.98 -0.97 -0.96 -0.95 -0.94 -0.93 -0.92 -0.91 -0.9 -0.89 -0.88 -0.87 -0.86 -0.85 -0.84 -0.83 -0.82 -0.81 -0.8 -0.79 -0.78 -0.77 -0.76 -0.75 -0.74 -0.73 -0.72 -0.71 -0.7 -0.69 -0.68 -0.67 -0.66 -0.65 -0.64 -0.63 -0.62 -0.61 -0.6 -0.59 -0.58 -0.57 -0.56 -0.55 -0.54 -0.53 -0.52 -0.51 -0.5 -0.49 -0.48 -0.47 -0.46 -0.45 -0.44 -0.43 -0.42 -0.41 -0.4 -0.39 -0.38 -0.37 -0.36 -0.35 -0.34 -0.33 -0.32 -0.31 -0.3 -0.29 -0.28 -0.27 -0.26 -0.25 -0.24 -0.23 -0.22 -0.21 -0.2 -0.19 -0.18 -0.17 -0.16 -0.15 -0.14 -0.13 -0.12 -0.11 -0.1 -0.09 -0.08 -0.07 -0.06 -0.05 -0.04 -0.03 -0.02 -0.01 0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]

#define ENTITY_LIGHTING_DIRECTIONALITY 0.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define OTHER_PLAYER_LIGHTS 1 //[0 1]

//v0.3.5
#define TRANSLECENT_LIGHTS 1 //[0 1]

#define SMART_COLOR_SATURATION 1 //[0 1]

#define SMART_COLOR_SATURATION_BOOST 2.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.10 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.30 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.40 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.50 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.60 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.70 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.80 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.90 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.00 2.01 2.02 2.03 2.04 2.05 2.06 2.07 2.08 2.09 2.10 2.11 2.12 2.13 2.14 2.15 2.16 2.17 2.18 2.19 2.20 2.21 2.22 2.23 2.24 2.25 2.26 2.27 2.28 2.29 2.30 2.31 2.32 2.33 2.34 2.35 2.36 2.37 2.38 2.39 2.40 2.41 2.42 2.43 2.44 2.45 2.46 2.47 2.48 2.49 2.50 2.51 2.52 2.53 2.54 2.55 2.56 2.57 2.58 2.59 2.60 2.61 2.62 2.63 2.64 2.65 2.66 2.67 2.68 2.69 2.70 2.71 2.72 2.73 2.74 2.75 2.76 2.77 2.78 2.79 2.80 2.81 2.82 2.83 2.84 2.85 2.86 2.87 2.88 2.89 2.90 2.91 2.92 2.93 2.94 2.95 2.96 2.97 2.98 2.99 3.00 3.01 3.02 3.03 3.04 3.05 3.06 3.07 3.08 3.09 3.10 3.11 3.12 3.13 3.14 3.15 3.16 3.17 3.18 3.19 3.20 3.21 3.22 3.23 3.24 3.25 3.26 3.27 3.28 3.29 3.30 3.31 3.32 3.33 3.34 3.35 3.36 3.37 3.38 3.39 3.40 3.41 3.42 3.43 3.44 3.45 3.46 3.47 3.48 3.49 3.50 3.51 3.52 3.53 3.54 3.55 3.56 3.57 3.58 3.59 3.60 3.61 3.62 3.63 3.64 3.65 3.66 3.67 3.68 3.69 3.70 3.71 3.72 3.73 3.74 3.75 3.76 3.77 3.78 3.79 3.80 3.81 3.82 3.83 3.84 3.85 3.86 3.87 3.88 3.89 3.90 3.91 3.92 3.93 3.94 3.95 3.96 3.97 3.98 3.99 4.00 4.01 4.02 4.03 4.04 4.05 4.06 4.07 4.08 4.09 4.10 4.11 4.12 4.13 4.14 4.15 4.16 4.17 4.18 4.19 4.20 4.21 4.22 4.23 4.24 4.25 4.26 4.27 4.28 4.29 4.30 4.31 4.32 4.33 4.34 4.35 4.36 4.37 4.38 4.39 4.40 4.41 4.42 4.43 4.44 4.45 4.46 4.47 4.48 4.49 4.50 4.51 4.52 4.53 4.54 4.55 4.56 4.57 4.58 4.59 4.60 4.61 4.62 4.63 4.64 4.65 4.66 4.67 4.68 4.69 4.70 4.71 4.72 4.73 4.74 4.75 4.76 4.77 4.78 4.79 4.80 4.81 4.82 4.83 4.84 4.85 4.86 4.87 4.88 4.89 4.90 4.91 4.92 4.93 4.94 4.95 4.96 4.97 4.98 4.99 5.00 6.0 7.0 8.0 9.0 10.0]

#include "/version_check.glsl"



//V0.3.6

#define VX_FIRECTIONALITY 0.90 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.25 1.5 1.75 2.0 3.0]

#define VX_FIRECTIONALITY2 0.90 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.25 1.5 1.75 2.0 3.0]

#if POM > 0 && PBR < 1
	#define PBR 1
#endif

#define AO 0 //[0 1 2 3 4]
#define AOGI 0 //[0 1]
#define AO_DEBUG 0 //[0 1 2 3]


#define AO_DARKNESS 2.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.10 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.30 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.40 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.50 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.60 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.70 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.80 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.90 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.00 2.01 2.02 2.03 2.04 2.05 2.06 2.07 2.08 2.09 2.10 2.11 2.12 2.13 2.14 2.15 2.16 2.17 2.18 2.19 2.20 2.21 2.22 2.23 2.24 2.25 2.26 2.27 2.28 2.29 2.30 2.31 2.32 2.33 2.34 2.35 2.36 2.37 2.38 2.39 2.40 2.41 2.42 2.43 2.44 2.45 2.46 2.47 2.48 2.49 2.50 2.51 2.52 2.53 2.54 2.55 2.56 2.57 2.58 2.59 2.60 2.61 2.62 2.63 2.64 2.65 2.66 2.67 2.68 2.69 2.70 2.71 2.72 2.73 2.74 2.75 2.76 2.77 2.78 2.79 2.80 2.81 2.82 2.83 2.84 2.85 2.86 2.87 2.88 2.89 2.90 2.91 2.92 2.93 2.94 2.95 2.96 2.97 2.98 2.99 3.00 3.01 3.02 3.03 3.04 3.05 3.06 3.07 3.08 3.09 3.10 3.11 3.12 3.13 3.14 3.15 3.16 3.17 3.18 3.19 3.20 3.21 3.22 3.23 3.24 3.25 3.26 3.27 3.28 3.29 3.30 3.31 3.32 3.33 3.34 3.35 3.36 3.37 3.38 3.39 3.40 3.41 3.42 3.43 3.44 3.45 3.46 3.47 3.48 3.49 3.50 3.51 3.52 3.53 3.54 3.55 3.56 3.57 3.58 3.59 3.60 3.61 3.62 3.63 3.64 3.65 3.66 3.67 3.68 3.69 3.70 3.71 3.72 3.73 3.74 3.75 3.76 3.77 3.78 3.79 3.80 3.81 3.82 3.83 3.84 3.85 3.86 3.87 3.88 3.89 3.90 3.91 3.92 3.93 3.94 3.95 3.96 3.97 3.98 3.99 4.00 4.01 4.02 4.03 4.04 4.05 4.06 4.07 4.08 4.09 4.10 4.11 4.12 4.13 4.14 4.15 4.16 4.17 4.18 4.19 4.20 4.21 4.22 4.23 4.24 4.25 4.26 4.27 4.28 4.29 4.30 4.31 4.32 4.33 4.34 4.35 4.36 4.37 4.38 4.39 4.40 4.41 4.42 4.43 4.44 4.45 4.46 4.47 4.48 4.49 4.50 4.51 4.52 4.53 4.54 4.55 4.56 4.57 4.58 4.59 4.60 4.61 4.62 4.63 4.64 4.65 4.66 4.67 4.68 4.69 4.70 4.71 4.72 4.73 4.74 4.75 4.76 4.77 4.78 4.79 4.80 4.81 4.82 4.83 4.84 4.85 4.86 4.87 4.88 4.89 4.90 4.91 4.92 4.93 4.94 4.95 4.96 4.97 4.98 4.99 5.0]

#define CLOSE_AO_DARKNESS 11.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.10 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.30 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.40 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.50 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.60 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.70 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.80 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.90 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.00 2.01 2.02 2.03 2.04 2.05 2.06 2.07 2.08 2.09 2.10 2.11 2.12 2.13 2.14 2.15 2.16 2.17 2.18 2.19 2.20 2.21 2.22 2.23 2.24 2.25 2.26 2.27 2.28 2.29 2.30 2.31 2.32 2.33 2.34 2.35 2.36 2.37 2.38 2.39 2.40 2.41 2.42 2.43 2.44 2.45 2.46 2.47 2.48 2.49 2.50 2.51 2.52 2.53 2.54 2.55 2.56 2.57 2.58 2.59 2.60 2.61 2.62 2.63 2.64 2.65 2.66 2.67 2.68 2.69 2.70 2.71 2.72 2.73 2.74 2.75 2.76 2.77 2.78 2.79 2.80 2.81 2.82 2.83 2.84 2.85 2.86 2.87 2.88 2.89 2.90 2.91 2.92 2.93 2.94 2.95 2.96 2.97 2.98 2.99 3.00 3.01 3.02 3.03 3.04 3.05 3.06 3.07 3.08 3.09 3.10 3.11 3.12 3.13 3.14 3.15 3.16 3.17 3.18 3.19 3.20 3.21 3.22 3.23 3.24 3.25 3.26 3.27 3.28 3.29 3.30 3.31 3.32 3.33 3.34 3.35 3.36 3.37 3.38 3.39 3.40 3.41 3.42 3.43 3.44 3.45 3.46 3.47 3.48 3.49 3.50 3.51 3.52 3.53 3.54 3.55 3.56 3.57 3.58 3.59 3.60 3.61 3.62 3.63 3.64 3.65 3.66 3.67 3.68 3.69 3.70 3.71 3.72 3.73 3.74 3.75 3.76 3.77 3.78 3.79 3.80 3.81 3.82 3.83 3.84 3.85 3.86 3.87 3.88 3.89 3.90 3.91 3.92 3.93 3.94 3.95 3.96 3.97 3.98 3.99 4.00 4.01 4.02 4.03 4.04 4.05 4.06 4.07 4.08 4.09 4.10 4.11 4.12 4.13 4.14 4.15 4.16 4.17 4.18 4.19 4.20 4.21 4.22 4.23 4.24 4.25 4.26 4.27 4.28 4.29 4.30 4.31 4.32 4.33 4.34 4.35 4.36 4.37 4.38 4.39 4.40 4.41 4.42 4.43 4.44 4.45 4.46 4.47 4.48 4.49 4.50 4.51 4.52 4.53 4.54 4.55 4.56 4.57 4.58 4.59 4.60 4.61 4.62 4.63 4.64 4.65 4.66 4.67 4.68 4.69 4.70 4.71 4.72 4.73 4.74 4.75 4.76 4.77 4.78 4.79 4.80 4.81 4.82 4.83 4.84 4.85 4.86 4.87 4.88 4.89 4.90 4.91 4.92 4.93 4.94 4.95 4.96 4.97 4.98 4.99 5.0 6.- 7.0 8.0 9.0 10.0 11.0]

#define WHITE 0 //[0 1]

#define AO_WIDTH .2
#define AO_SAMPLES 22. //[8.0 16.0 22.0]
#define AO_EXTRA_SOFTNESS .01
#define AO_NOISE_STR 1.1 
#define AO_SOFTNESS_WEIGHT 0.5
#define AO_SPIN 1.5 //[1.0 1.5 2.0 3. 4.0]

#define WATER_FOG_DISTANCE 30.0 //[10.0 20.0 30.0 40.0 50.0 60.0 70.0 80.0 90.0 100.0]

#define NIGHT_VISION_MODE 0 //[0 1 2]

#define EXTEND_LAVA_PATTERN 0 //[0 1]







//2025-10

#define ADJUST_GAMMA 0 //[0 1]
#define GAMMA_DISPLAY 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.10 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.30 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.40 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.50 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.60 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.70 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.80 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.90 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.00 2.01 2.02 2.03 2.04 2.05 2.06 2.07 2.08 2.09 2.10 2.11 2.12 2.13 2.14 2.15 2.16 2.17 2.18 2.19 2.20 2.21 2.22 2.23 2.24 2.25 2.26 2.27 2.28 2.29 2.30 2.31 2.32 2.33 2.34 2.35 2.36 2.37 2.38 2.39 2.40 2.41 2.42 2.43 2.44 2.45 2.46 2.47 2.48 2.49 2.50 2.51 2.52 2.53 2.54 2.55 2.56 2.57 2.58 2.59 2.60 2.61 2.62 2.63 2.64 2.65 2.66 2.67 2.68 2.69 2.70 2.71 2.72 2.73 2.74 2.75 2.76 2.77 2.78 2.79 2.80 2.81 2.82 2.83 2.84 2.85 2.86 2.87 2.88 2.89 2.90 2.91 2.92 2.93 2.94 2.95 2.96 2.97 2.98 2.99 3.00 3.01 3.02 3.03 3.04 3.05 3.06 3.07 3.08 3.09 3.10 3.11 3.12 3.13 3.14 3.15 3.16 3.17 3.18 3.19 3.20 3.21 3.22 3.23 3.24 3.25 3.26 3.27 3.28 3.29 3.30 3.31 3.32 3.33 3.34 3.35 3.36 3.37 3.38 3.39 3.40 3.41 3.42 3.43 3.44 3.45 3.46 3.47 3.48 3.49 3.50 3.51 3.52 3.53 3.54 3.55 3.56 3.57 3.58 3.59 3.60 3.61 3.62 3.63 3.64 3.65 3.66 3.67 3.68 3.69 3.70 3.71 3.72 3.73 3.74 3.75 3.76 3.77 3.78 3.79 3.80 3.81 3.82 3.83 3.84 3.85 3.86 3.87 3.88 3.89 3.90 3.91 3.92 3.93 3.94 3.95 3.96 3.97 3.98 3.99 4.00]

#define SHADOW_BIAS_IN_DISTANCE 2.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.10 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.30 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.40 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.50 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.60 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.70 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.80 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.90 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.00 2.01 2.02 2.03 2.04 2.05 2.06 2.07 2.08 2.09 2.10 2.11 2.12 2.13 2.14 2.15 2.16 2.17 2.18 2.19 2.20 2.21 2.22 2.23 2.24 2.25 2.26 2.27 2.28 2.29 2.30 2.31 2.32 2.33 2.34 2.35 2.36 2.37 2.38 2.39 2.40 2.41 2.42 2.43 2.44 2.45 2.46 2.47 2.48 2.49 2.50 2.51 2.52 2.53 2.54 2.55 2.56 2.57 2.58 2.59 2.60 2.61 2.62 2.63 2.64 2.65 2.66 2.67 2.68 2.69 2.70 2.71 2.72 2.73 2.74 2.75 2.76 2.77 2.78 2.79 2.80 2.81 2.82 2.83 2.84 2.85 2.86 2.87 2.88 2.89 2.90 2.91 2.92 2.93 2.94 2.95 2.96 2.97 2.98 2.99 3.00 3.01 3.02 3.03 3.04 3.05 3.06 3.07 3.08 3.09 3.10 3.11 3.12 3.13 3.14 3.15 3.16 3.17 3.18 3.19 3.20 3.21 3.22 3.23 3.24 3.25 3.26 3.27 3.28 3.29 3.30 3.31 3.32 3.33 3.34 3.35 3.36 3.37 3.38 3.39 3.40 3.41 3.42 3.43 3.44 3.45 3.46 3.47 3.48 3.49 3.50 3.51 3.52 3.53 3.54 3.55 3.56 3.57 3.58 3.59 3.60 3.61 3.62 3.63 3.64 3.65 3.66 3.67 3.68 3.69 3.70 3.71 3.72 3.73 3.74 3.75 3.76 3.77 3.78 3.79 3.80 3.81 3.82 3.83 3.84 3.85 3.86 3.87 3.88 3.89 3.90 3.91 3.92 3.93 3.94 3.95 3.96 3.97 3.98 3.99 4.00]

#define AO_EFFECTS_BLOCKLIGHT 1 //[0 1]

#define FOG_BY_HEIGHT 0 //[0 1]

#define FOG_AFFECTS_LIGHT 0 //[0 1]
#define FOG_AFFECTS_LIGHT_STR 0.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]


#define SKY_HEIGHT 300.0 //[100.0 200.0 300.0 400.0 500.0 600.0 700.0 800.0 900.0 1000.0 1024.0 2000.0 3000.0]

#define FOG_IN_SKYLIGHT_STR 0.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]



#define AUTO_HAND_HELD_COLOR_DETECTION 4 //[0 1 2 3 4 5 6]

#define HELD_TORCH_FALLOFF 2.0 //[1.0 1.2 1.3 1.4 1.5 1.6 1.7 2.0 3.0 4.0 5.0]
#define HELD_TORCH_BRIGHTNESS 2.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.2 1.3 1.4 1.5 1.6 1.7 2.0 3.0 4.0 5.0]

#define USE_MANUAL_FINAL_ADJUSTMENTS 0 //[0 1]

#define BTIGHTNESS_CONTRAST_CENTER 0.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define BTIGHTNESS_CONTRAST 1.000 //[0.000 0.001 0.002 0.003 0.004 0.005 0.006 0.007 0.008 0.009 0.010 0.011 0.012 0.013 0.014 0.015 0.016 0.017 0.018 0.019 0.020 0.021 0.022 0.023 0.024 0.025 0.026 0.027 0.028 0.029 0.030 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 0.039 0.040 0.041 0.042 0.043 0.044 0.045 0.046 0.047 0.048 0.049 0.050 0.051 0.052 0.053 0.054 0.055 0.056 0.057 0.058 0.059 0.060 0.061 0.062 0.063 0.064 0.065 0.066 0.067 0.068 0.069 0.070 0.071 0.072 0.073 0.074 0.075 0.076 0.077 0.078 0.079 0.080 0.081 0.082 0.083 0.084 0.085 0.086 0.087 0.088 0.089 0.090 0.091 0.092 0.093 0.094 0.095 0.096 0.097 0.098 0.099 0.100 0.101 0.102 0.103 0.104 0.105 0.106 0.107 0.108 0.109 0.110 0.111 0.112 0.113 0.114 0.115 0.116 0.117 0.118 0.119 0.120 0.121 0.122 0.123 0.124 0.125 0.126 0.127 0.128 0.129 0.130 0.131 0.132 0.133 0.134 0.135 0.136 0.137 0.138 0.139 0.140 0.141 0.142 0.143 0.144 0.145 0.146 0.147 0.148 0.149 0.150 0.151 0.152 0.153 0.154 0.155 0.156 0.157 0.158 0.159 0.160 0.161 0.162 0.163 0.164 0.165 0.166 0.167 0.168 0.169 0.170 0.171 0.172 0.173 0.174 0.175 0.176 0.177 0.178 0.179 0.180 0.181 0.182 0.183 0.184 0.185 0.186 0.187 0.188 0.189 0.190 0.191 0.192 0.193 0.194 0.195 0.196 0.197 0.198 0.199 0.200 0.201 0.202 0.203 0.204 0.205 0.206 0.207 0.208 0.209 0.210 0.211 0.212 0.213 0.214 0.215 0.216 0.217 0.218 0.219 0.220 0.221 0.222 0.223 0.224 0.225 0.226 0.227 0.228 0.229 0.230 0.231 0.232 0.233 0.234 0.235 0.236 0.237 0.238 0.239 0.240 0.241 0.242 0.243 0.244 0.245 0.246 0.247 0.248 0.249 0.250 0.251 0.252 0.253 0.254 0.255 0.256 0.257 0.258 0.259 0.260 0.261 0.262 0.263 0.264 0.265 0.266 0.267 0.268 0.269 0.270 0.271 0.272 0.273 0.274 0.275 0.276 0.277 0.278 0.279 0.280 0.281 0.282 0.283 0.284 0.285 0.286 0.287 0.288 0.289 0.290 0.291 0.292 0.293 0.294 0.295 0.296 0.297 0.298 0.299 0.300 0.301 0.302 0.303 0.304 0.305 0.306 0.307 0.308 0.309 0.310 0.311 0.312 0.313 0.314 0.315 0.316 0.317 0.318 0.319 0.320 0.321 0.322 0.323 0.324 0.325 0.326 0.327 0.328 0.329 0.330 0.331 0.332 0.333 0.334 0.335 0.336 0.337 0.338 0.339 0.340 0.341 0.342 0.343 0.344 0.345 0.346 0.347 0.348 0.349 0.350 0.351 0.352 0.353 0.354 0.355 0.356 0.357 0.358 0.359 0.360 0.361 0.362 0.363 0.364 0.365 0.366 0.367 0.368 0.369 0.370 0.371 0.372 0.373 0.374 0.375 0.376 0.377 0.378 0.379 0.380 0.381 0.382 0.383 0.384 0.385 0.386 0.387 0.388 0.389 0.390 0.391 0.392 0.393 0.394 0.395 0.396 0.397 0.398 0.399 0.400 0.401 0.402 0.403 0.404 0.405 0.406 0.407 0.408 0.409 0.410 0.411 0.412 0.413 0.414 0.415 0.416 0.417 0.418 0.419 0.420 0.421 0.422 0.423 0.424 0.425 0.426 0.427 0.428 0.429 0.430 0.431 0.432 0.433 0.434 0.435 0.436 0.437 0.438 0.439 0.440 0.441 0.442 0.443 0.444 0.445 0.446 0.447 0.448 0.449 0.450 0.451 0.452 0.453 0.454 0.455 0.456 0.457 0.458 0.459 0.460 0.461 0.462 0.463 0.464 0.465 0.466 0.467 0.468 0.469 0.470 0.471 0.472 0.473 0.474 0.475 0.476 0.477 0.478 0.479 0.480 0.481 0.482 0.483 0.484 0.485 0.486 0.487 0.488 0.489 0.490 0.491 0.492 0.493 0.494 0.495 0.496 0.497 0.498 0.499 0.500 0.501 0.502 0.503 0.504 0.505 0.506 0.507 0.508 0.509 0.510 0.511 0.512 0.513 0.514 0.515 0.516 0.517 0.518 0.519 0.520 0.521 0.522 0.523 0.524 0.525 0.526 0.527 0.528 0.529 0.530 0.531 0.532 0.533 0.534 0.535 0.536 0.537 0.538 0.539 0.540 0.541 0.542 0.543 0.544 0.545 0.546 0.547 0.548 0.549 0.550 0.551 0.552 0.553 0.554 0.555 0.556 0.557 0.558 0.559 0.560 0.561 0.562 0.563 0.564 0.565 0.566 0.567 0.568 0.569 0.570 0.571 0.572 0.573 0.574 0.575 0.576 0.577 0.578 0.579 0.580 0.581 0.582 0.583 0.584 0.585 0.586 0.587 0.588 0.589 0.590 0.591 0.592 0.593 0.594 0.595 0.596 0.597 0.598 0.599 0.600 0.601 0.602 0.603 0.604 0.605 0.606 0.607 0.608 0.609 0.610 0.611 0.612 0.613 0.614 0.615 0.616 0.617 0.618 0.619 0.620 0.621 0.622 0.623 0.624 0.625 0.626 0.627 0.628 0.629 0.630 0.631 0.632 0.633 0.634 0.635 0.636 0.637 0.638 0.639 0.640 0.641 0.642 0.643 0.644 0.645 0.646 0.647 0.648 0.649 0.650 0.651 0.652 0.653 0.654 0.655 0.656 0.657 0.658 0.659 0.660 0.661 0.662 0.663 0.664 0.665 0.666 0.667 0.668 0.669 0.670 0.671 0.672 0.673 0.674 0.675 0.676 0.677 0.678 0.679 0.680 0.681 0.682 0.683 0.684 0.685 0.686 0.687 0.688 0.689 0.690 0.691 0.692 0.693 0.694 0.695 0.696 0.697 0.698 0.699 0.700 0.701 0.702 0.703 0.704 0.705 0.706 0.707 0.708 0.709 0.710 0.711 0.712 0.713 0.714 0.715 0.716 0.717 0.718 0.719 0.720 0.721 0.722 0.723 0.724 0.725 0.726 0.727 0.728 0.729 0.730 0.731 0.732 0.733 0.734 0.735 0.736 0.737 0.738 0.739 0.740 0.741 0.742 0.743 0.744 0.745 0.746 0.747 0.748 0.749 0.750 0.751 0.752 0.753 0.754 0.755 0.756 0.757 0.758 0.759 0.760 0.761 0.762 0.763 0.764 0.765 0.766 0.767 0.768 0.769 0.770 0.771 0.772 0.773 0.774 0.775 0.776 0.777 0.778 0.779 0.780 0.781 0.782 0.783 0.784 0.785 0.786 0.787 0.788 0.789 0.790 0.791 0.792 0.793 0.794 0.795 0.796 0.797 0.798 0.799 0.800 0.801 0.802 0.803 0.804 0.805 0.806 0.807 0.808 0.809 0.810 0.811 0.812 0.813 0.814 0.815 0.816 0.817 0.818 0.819 0.820 0.821 0.822 0.823 0.824 0.825 0.826 0.827 0.828 0.829 0.830 0.831 0.832 0.833 0.834 0.835 0.836 0.837 0.838 0.839 0.840 0.841 0.842 0.843 0.844 0.845 0.846 0.847 0.848 0.849 0.850 0.851 0.852 0.853 0.854 0.855 0.856 0.857 0.858 0.859 0.860 0.861 0.862 0.863 0.864 0.865 0.866 0.867 0.868 0.869 0.870 0.871 0.872 0.873 0.874 0.875 0.876 0.877 0.878 0.879 0.880 0.881 0.882 0.883 0.884 0.885 0.886 0.887 0.888 0.889 0.890 0.891 0.892 0.893 0.894 0.895 0.896 0.897 0.898 0.899 0.900 0.901 0.902 0.903 0.904 0.905 0.906 0.907 0.908 0.909 0.910 0.911 0.912 0.913 0.914 0.915 0.916 0.917 0.918 0.919 0.920 0.921 0.922 0.923 0.924 0.925 0.926 0.927 0.928 0.929 0.930 0.931 0.932 0.933 0.934 0.935 0.936 0.937 0.938 0.939 0.940 0.941 0.942 0.943 0.944 0.945 0.946 0.947 0.948 0.949 0.950 0.951 0.952 0.953 0.954 0.955 0.956 0.957 0.958 0.959 0.960 0.961 0.962 0.963 0.964 0.965 0.966 0.967 0.968 0.969 0.970 0.971 0.972 0.973 0.974 0.975 0.976 0.977 0.978 0.979 0.980 0.981 0.982 0.983 0.984 0.985 0.986 0.987 0.988 0.989 0.990 0.991 0.992 0.993 0.994 0.995 0.996 0.997 0.998 0.999 1.000 1.001 1.002 1.003 1.004 1.005 1.006 1.007 1.008 1.009 1.010 1.011 1.012 1.013 1.014 1.015 1.016 1.017 1.018 1.019 1.020 1.021 1.022 1.023 1.024 1.025 1.026 1.027 1.028 1.029 1.030 1.031 1.032 1.033 1.034 1.035 1.036 1.037 1.038 1.039 1.040 1.041 1.042 1.043 1.044 1.045 1.046 1.047 1.048 1.049 1.050 1.051 1.052 1.053 1.054 1.055 1.056 1.057 1.058 1.059 1.060 1.061 1.062 1.063 1.064 1.065 1.066 1.067 1.068 1.069 1.070 1.071 1.072 1.073 1.074 1.075 1.076 1.077 1.078 1.079 1.080 1.081 1.082 1.083 1.084 1.085 1.086 1.087 1.088 1.089 1.090 1.091 1.092 1.093 1.094 1.095 1.096 1.097 1.098 1.099 1.100 1.101 1.102 1.103 1.104 1.105 1.106 1.107 1.108 1.109 1.110 1.111 1.112 1.113 1.114 1.115 1.116 1.117 1.118 1.119 1.120 1.121 1.122 1.123 1.124 1.125 1.126 1.127 1.128 1.129 1.130 1.131 1.132 1.133 1.134 1.135 1.136 1.137 1.138 1.139 1.140 1.141 1.142 1.143 1.144 1.145 1.146 1.147 1.148 1.149 1.150 1.151 1.152 1.153 1.154 1.155 1.156 1.157 1.158 1.159 1.160 1.161 1.162 1.163 1.164 1.165 1.166 1.167 1.168 1.169 1.170 1.171 1.172 1.173 1.174 1.175 1.176 1.177 1.178 1.179 1.180 1.181 1.182 1.183 1.184 1.185 1.186 1.187 1.188 1.189 1.190 1.191 1.192 1.193 1.194 1.195 1.196 1.197 1.198 1.199 1.200 1.201 1.202 1.203 1.204 1.205 1.206 1.207 1.208 1.209 1.210 1.211 1.212 1.213 1.214 1.215 1.216 1.217 1.218 1.219 1.220 1.221 1.222 1.223 1.224 1.225 1.226 1.227 1.228 1.229 1.230 1.231 1.232 1.233 1.234 1.235 1.236 1.237 1.238 1.239 1.240 1.241 1.242 1.243 1.244 1.245 1.246 1.247 1.248 1.249 1.250 1.251 1.252 1.253 1.254 1.255 1.256 1.257 1.258 1.259 1.260 1.261 1.262 1.263 1.264 1.265 1.266 1.267 1.268 1.269 1.270 1.271 1.272 1.273 1.274 1.275 1.276 1.277 1.278 1.279 1.280 1.281 1.282 1.283 1.284 1.285 1.286 1.287 1.288 1.289 1.290 1.291 1.292 1.293 1.294 1.295 1.296 1.297 1.298 1.299 1.300 1.301 1.302 1.303 1.304 1.305 1.306 1.307 1.308 1.309 1.310 1.311 1.312 1.313 1.314 1.315 1.316 1.317 1.318 1.319 1.320 1.321 1.322 1.323 1.324 1.325 1.326 1.327 1.328 1.329 1.330 1.331 1.332 1.333 1.334 1.335 1.336 1.337 1.338 1.339 1.340 1.341 1.342 1.343 1.344 1.345 1.346 1.347 1.348 1.349 1.350 1.351 1.352 1.353 1.354 1.355 1.356 1.357 1.358 1.359 1.360 1.361 1.362 1.363 1.364 1.365 1.366 1.367 1.368 1.369 1.370 1.371 1.372 1.373 1.374 1.375 1.376 1.377 1.378 1.379 1.380 1.381 1.382 1.383 1.384 1.385 1.386 1.387 1.388 1.389 1.390 1.391 1.392 1.393 1.394 1.395 1.396 1.397 1.398 1.399 1.400 1.401 1.402 1.403 1.404 1.405 1.406 1.407 1.408 1.409 1.410 1.411 1.412 1.413 1.414 1.415 1.416 1.417 1.418 1.419 1.420 1.421 1.422 1.423 1.424 1.425 1.426 1.427 1.428 1.429 1.430 1.431 1.432 1.433 1.434 1.435 1.436 1.437 1.438 1.439 1.440 1.441 1.442 1.443 1.444 1.445 1.446 1.447 1.448 1.449 1.450 1.451 1.452 1.453 1.454 1.455 1.456 1.457 1.458 1.459 1.460 1.461 1.462 1.463 1.464 1.465 1.466 1.467 1.468 1.469 1.470 1.471 1.472 1.473 1.474 1.475 1.476 1.477 1.478 1.479 1.480 1.481 1.482 1.483 1.484 1.485 1.486 1.487 1.488 1.489 1.490 1.491 1.492 1.493 1.494 1.495 1.496 1.497 1.498 1.499 1.500 1.501 1.502 1.503 1.504 1.505 1.506 1.507 1.508 1.509 1.510 1.511 1.512 1.513 1.514 1.515 1.516 1.517 1.518 1.519 1.520 1.521 1.522 1.523 1.524 1.525 1.526 1.527 1.528 1.529 1.530 1.531 1.532 1.533 1.534 1.535 1.536 1.537 1.538 1.539 1.540 1.541 1.542 1.543 1.544 1.545 1.546 1.547 1.548 1.549 1.550 1.551 1.552 1.553 1.554 1.555 1.556 1.557 1.558 1.559 1.560 1.561 1.562 1.563 1.564 1.565 1.566 1.567 1.568 1.569 1.570 1.571 1.572 1.573 1.574 1.575 1.576 1.577 1.578 1.579 1.580 1.581 1.582 1.583 1.584 1.585 1.586 1.587 1.588 1.589 1.590 1.591 1.592 1.593 1.594 1.595 1.596 1.597 1.598 1.599 1.600 1.601 1.602 1.603 1.604 1.605 1.606 1.607 1.608 1.609 1.610 1.611 1.612 1.613 1.614 1.615 1.616 1.617 1.618 1.619 1.620 1.621 1.622 1.623 1.624 1.625 1.626 1.627 1.628 1.629 1.630 1.631 1.632 1.633 1.634 1.635 1.636 1.637 1.638 1.639 1.640 1.641 1.642 1.643 1.644 1.645 1.646 1.647 1.648 1.649 1.650 1.651 1.652 1.653 1.654 1.655 1.656 1.657 1.658 1.659 1.660 1.661 1.662 1.663 1.664 1.665 1.666 1.667 1.668 1.669 1.670 1.671 1.672 1.673 1.674 1.675 1.676 1.677 1.678 1.679 1.680 1.681 1.682 1.683 1.684 1.685 1.686 1.687 1.688 1.689 1.690 1.691 1.692 1.693 1.694 1.695 1.696 1.697 1.698 1.699 1.700 1.701 1.702 1.703 1.704 1.705 1.706 1.707 1.708 1.709 1.710 1.711 1.712 1.713 1.714 1.715 1.716 1.717 1.718 1.719 1.720 1.721 1.722 1.723 1.724 1.725 1.726 1.727 1.728 1.729 1.730 1.731 1.732 1.733 1.734 1.735 1.736 1.737 1.738 1.739 1.740 1.741 1.742 1.743 1.744 1.745 1.746 1.747 1.748 1.749 1.750 1.751 1.752 1.753 1.754 1.755 1.756 1.757 1.758 1.759 1.760 1.761 1.762 1.763 1.764 1.765 1.766 1.767 1.768 1.769 1.770 1.771 1.772 1.773 1.774 1.775 1.776 1.777 1.778 1.779 1.780 1.781 1.782 1.783 1.784 1.785 1.786 1.787 1.788 1.789 1.790 1.791 1.792 1.793 1.794 1.795 1.796 1.797 1.798 1.799 1.800 1.801 1.802 1.803 1.804 1.805 1.806 1.807 1.808 1.809 1.810 1.811 1.812 1.813 1.814 1.815 1.816 1.817 1.818 1.819 1.820 1.821 1.822 1.823 1.824 1.825 1.826 1.827 1.828 1.829 1.830 1.831 1.832 1.833 1.834 1.835 1.836 1.837 1.838 1.839 1.840 1.841 1.842 1.843 1.844 1.845 1.846 1.847 1.848 1.849 1.850 1.851 1.852 1.853 1.854 1.855 1.856 1.857 1.858 1.859 1.860 1.861 1.862 1.863 1.864 1.865 1.866 1.867 1.868 1.869 1.870 1.871 1.872 1.873 1.874 1.875 1.876 1.877 1.878 1.879 1.880 1.881 1.882 1.883 1.884 1.885 1.886 1.887 1.888 1.889 1.890 1.891 1.892 1.893 1.894 1.895 1.896 1.897 1.898 1.899 1.900 1.901 1.902 1.903 1.904 1.905 1.906 1.907 1.908 1.909 1.910 1.911 1.912 1.913 1.914 1.915 1.916 1.917 1.918 1.919 1.920 1.921 1.922 1.923 1.924 1.925 1.926 1.927 1.928 1.929 1.930 1.931 1.932 1.933 1.934 1.935 1.936 1.937 1.938 1.939 1.940 1.941 1.942 1.943 1.944 1.945 1.946 1.947 1.948 1.949 1.950 1.951 1.952 1.953 1.954 1.955 1.956 1.957 1.958 1.959 1.960 1.961 1.962 1.963 1.964 1.965 1.966 1.967 1.968 1.969 1.970 1.971 1.972 1.973 1.974 1.975 1.976 1.977 1.978 1.979 1.980 1.981 1.982 1.983 1.984 1.985 1.986 1.987 1.988 1.989 1.990 1.991 1.992 1.993 1.994 1.995 1.996 1.997 1.998 1.999 2.000 2.001 2.002 2.003 2.004 2.005 2.006 2.007 2.008 2.009 2.010 2.011 2.012 2.013 2.014 2.015 2.016 2.017 2.018 2.019 2.020 2.021 2.022 2.023 2.024 2.025 2.026 2.027 2.028 2.029 2.030 2.031 2.032 2.033 2.034 2.035 2.036 2.037 2.038 2.039 2.040 2.041 2.042 2.043 2.044 2.045 2.046 2.047 2.048 2.049 2.050 2.051 2.052 2.053 2.054 2.055 2.056 2.057 2.058 2.059 2.060 2.061 2.062 2.063 2.064 2.065 2.066 2.067 2.068 2.069 2.070 2.071 2.072 2.073 2.074 2.075 2.076 2.077 2.078 2.079 2.080 2.081 2.082 2.083 2.084 2.085 2.086 2.087 2.088 2.089 2.090 2.091 2.092 2.093 2.094 2.095 2.096 2.097 2.098 2.099 2.100 2.101 2.102 2.103 2.104 2.105 2.106 2.107 2.108 2.109 2.110 2.111 2.112 2.113 2.114 2.115 2.116 2.117 2.118 2.119 2.120 2.121 2.122 2.123 2.124 2.125 2.126 2.127 2.128 2.129 2.130 2.131 2.132 2.133 2.134 2.135 2.136 2.137 2.138 2.139 2.140 2.141 2.142 2.143 2.144 2.145 2.146 2.147 2.148 2.149 2.150 2.151 2.152 2.153 2.154 2.155 2.156 2.157 2.158 2.159 2.160 2.161 2.162 2.163 2.164 2.165 2.166 2.167 2.168 2.169 2.170 2.171 2.172 2.173 2.174 2.175 2.176 2.177 2.178 2.179 2.180 2.181 2.182 2.183 2.184 2.185 2.186 2.187 2.188 2.189 2.190 2.191 2.192 2.193 2.194 2.195 2.196 2.197 2.198 2.199 2.200 2.201 2.202 2.203 2.204 2.205 2.206 2.207 2.208 2.209 2.210 2.211 2.212 2.213 2.214 2.215 2.216 2.217 2.218 2.219 2.220 2.221 2.222 2.223 2.224 2.225 2.226 2.227 2.228 2.229 2.230 2.231 2.232 2.233 2.234 2.235 2.236 2.237 2.238 2.239 2.240 2.241 2.242 2.243 2.244 2.245 2.246 2.247 2.248 2.249 2.250 2.251 2.252 2.253 2.254 2.255 2.256 2.257 2.258 2.259 2.260 2.261 2.262 2.263 2.264 2.265 2.266 2.267 2.268 2.269 2.270 2.271 2.272 2.273 2.274 2.275 2.276 2.277 2.278 2.279 2.280 2.281 2.282 2.283 2.284 2.285 2.286 2.287 2.288 2.289 2.290 2.291 2.292 2.293 2.294 2.295 2.296 2.297 2.298 2.299 2.300 2.301 2.302 2.303 2.304 2.305 2.306 2.307 2.308 2.309 2.310 2.311 2.312 2.313 2.314 2.315 2.316 2.317 2.318 2.319 2.320 2.321 2.322 2.323 2.324 2.325 2.326 2.327 2.328 2.329 2.330 2.331 2.332 2.333 2.334 2.335 2.336 2.337 2.338 2.339 2.340 2.341 2.342 2.343 2.344 2.345 2.346 2.347 2.348 2.349 2.350 2.351 2.352 2.353 2.354 2.355 2.356 2.357 2.358 2.359 2.360 2.361 2.362 2.363 2.364 2.365 2.366 2.367 2.368 2.369 2.370 2.371 2.372 2.373 2.374 2.375 2.376 2.377 2.378 2.379 2.380 2.381 2.382 2.383 2.384 2.385 2.386 2.387 2.388 2.389 2.390 2.391 2.392 2.393 2.394 2.395 2.396 2.397 2.398 2.399 2.400 2.401 2.402 2.403 2.404 2.405 2.406 2.407 2.408 2.409 2.410 2.411 2.412 2.413 2.414 2.415 2.416 2.417 2.418 2.419 2.420 2.421 2.422 2.423 2.424 2.425 2.426 2.427 2.428 2.429 2.430 2.431 2.432 2.433 2.434 2.435 2.436 2.437 2.438 2.439 2.440 2.441 2.442 2.443 2.444 2.445 2.446 2.447 2.448 2.449 2.450 2.451 2.452 2.453 2.454 2.455 2.456 2.457 2.458 2.459 2.460 2.461 2.462 2.463 2.464 2.465 2.466 2.467 2.468 2.469 2.470 2.471 2.472 2.473 2.474 2.475 2.476 2.477 2.478 2.479 2.480 2.481 2.482 2.483 2.484 2.485 2.486 2.487 2.488 2.489 2.490 2.491 2.492 2.493 2.494 2.495 2.496 2.497 2.498 2.499 2.500 2.501 2.502 2.503 2.504 2.505 2.506 2.507 2.508 2.509 2.510 2.511 2.512 2.513 2.514 2.515 2.516 2.517 2.518 2.519 2.520 2.521 2.522 2.523 2.524 2.525 2.526 2.527 2.528 2.529 2.530 2.531 2.532 2.533 2.534 2.535 2.536 2.537 2.538 2.539 2.540 2.541 2.542 2.543 2.544 2.545 2.546 2.547 2.548 2.549 2.550 2.551 2.552 2.553 2.554 2.555 2.556 2.557 2.558 2.559 2.560 2.561 2.562 2.563 2.564 2.565 2.566 2.567 2.568 2.569 2.570 2.571 2.572 2.573 2.574 2.575 2.576 2.577 2.578 2.579 2.580 2.581 2.582 2.583 2.584 2.585 2.586 2.587 2.588 2.589 2.590 2.591 2.592 2.593 2.594 2.595 2.596 2.597 2.598 2.599 2.600 2.601 2.602 2.603 2.604 2.605 2.606 2.607 2.608 2.609 2.610 2.611 2.612 2.613 2.614 2.615 2.616 2.617 2.618 2.619 2.620 2.621 2.622 2.623 2.624 2.625 2.626 2.627 2.628 2.629 2.630 2.631 2.632 2.633 2.634 2.635 2.636 2.637 2.638 2.639 2.640 2.641 2.642 2.643 2.644 2.645 2.646 2.647 2.648 2.649 2.650 2.651 2.652 2.653 2.654 2.655 2.656 2.657 2.658 2.659 2.660 2.661 2.662 2.663 2.664 2.665 2.666 2.667 2.668 2.669 2.670 2.671 2.672 2.673 2.674 2.675 2.676 2.677 2.678 2.679 2.680 2.681 2.682 2.683 2.684 2.685 2.686 2.687 2.688 2.689 2.690 2.691 2.692 2.693 2.694 2.695 2.696 2.697 2.698 2.699 2.700 2.701 2.702 2.703 2.704 2.705 2.706 2.707 2.708 2.709 2.710 2.711 2.712 2.713 2.714 2.715 2.716 2.717 2.718 2.719 2.720 2.721 2.722 2.723 2.724 2.725 2.726 2.727 2.728 2.729 2.730 2.731 2.732 2.733 2.734 2.735 2.736 2.737 2.738 2.739 2.740 2.741 2.742 2.743 2.744 2.745 2.746 2.747 2.748 2.749 2.750 2.751 2.752 2.753 2.754 2.755 2.756 2.757 2.758 2.759 2.760 2.761 2.762 2.763 2.764 2.765 2.766 2.767 2.768 2.769 2.770 2.771 2.772 2.773 2.774 2.775 2.776 2.777 2.778 2.779 2.780 2.781 2.782 2.783 2.784 2.785 2.786 2.787 2.788 2.789 2.790 2.791 2.792 2.793 2.794 2.795 2.796 2.797 2.798 2.799 2.800 2.801 2.802 2.803 2.804 2.805 2.806 2.807 2.808 2.809 2.810 2.811 2.812 2.813 2.814 2.815 2.816 2.817 2.818 2.819 2.820 2.821 2.822 2.823 2.824 2.825 2.826 2.827 2.828 2.829 2.830 2.831 2.832 2.833 2.834 2.835 2.836 2.837 2.838 2.839 2.840 2.841 2.842 2.843 2.844 2.845 2.846 2.847 2.848 2.849 2.850 2.851 2.852 2.853 2.854 2.855 2.856 2.857 2.858 2.859 2.860 2.861 2.862 2.863 2.864 2.865 2.866 2.867 2.868 2.869 2.870 2.871 2.872 2.873 2.874 2.875 2.876 2.877 2.878 2.879 2.880 2.881 2.882 2.883 2.884 2.885 2.886 2.887 2.888 2.889 2.890 2.891 2.892 2.893 2.894 2.895 2.896 2.897 2.898 2.899 2.900 2.901 2.902 2.903 2.904 2.905 2.906 2.907 2.908 2.909 2.910 2.911 2.912 2.913 2.914 2.915 2.916 2.917 2.918 2.919 2.920 2.921 2.922 2.923 2.924 2.925 2.926 2.927 2.928 2.929 2.930 2.931 2.932 2.933 2.934 2.935 2.936 2.937 2.938 2.939 2.940 2.941 2.942 2.943 2.944 2.945 2.946 2.947 2.948 2.949 2.950 2.951 2.952 2.953 2.954 2.955 2.956 2.957 2.958 2.959 2.960 2.961 2.962 2.963 2.964 2.965 2.966 2.967 2.968 2.969 2.970 2.971 2.972 2.973 2.974 2.975 2.976 2.977 2.978 2.979 2.980 2.981 2.982 2.983 2.984 2.985 2.986 2.987 2.988 2.989 2.990 2.991 2.992 2.993 2.994 2.995 2.996 2.997 2.998 2.999 3.000]

#define SATURATION 1.000 //[0.000 0.001 0.002 0.003 0.004 0.005 0.006 0.007 0.008 0.009 0.010 0.011 0.012 0.013 0.014 0.015 0.016 0.017 0.018 0.019 0.020 0.021 0.022 0.023 0.024 0.025 0.026 0.027 0.028 0.029 0.030 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 0.039 0.040 0.041 0.042 0.043 0.044 0.045 0.046 0.047 0.048 0.049 0.050 0.051 0.052 0.053 0.054 0.055 0.056 0.057 0.058 0.059 0.060 0.061 0.062 0.063 0.064 0.065 0.066 0.067 0.068 0.069 0.070 0.071 0.072 0.073 0.074 0.075 0.076 0.077 0.078 0.079 0.080 0.081 0.082 0.083 0.084 0.085 0.086 0.087 0.088 0.089 0.090 0.091 0.092 0.093 0.094 0.095 0.096 0.097 0.098 0.099 0.100 0.101 0.102 0.103 0.104 0.105 0.106 0.107 0.108 0.109 0.110 0.111 0.112 0.113 0.114 0.115 0.116 0.117 0.118 0.119 0.120 0.121 0.122 0.123 0.124 0.125 0.126 0.127 0.128 0.129 0.130 0.131 0.132 0.133 0.134 0.135 0.136 0.137 0.138 0.139 0.140 0.141 0.142 0.143 0.144 0.145 0.146 0.147 0.148 0.149 0.150 0.151 0.152 0.153 0.154 0.155 0.156 0.157 0.158 0.159 0.160 0.161 0.162 0.163 0.164 0.165 0.166 0.167 0.168 0.169 0.170 0.171 0.172 0.173 0.174 0.175 0.176 0.177 0.178 0.179 0.180 0.181 0.182 0.183 0.184 0.185 0.186 0.187 0.188 0.189 0.190 0.191 0.192 0.193 0.194 0.195 0.196 0.197 0.198 0.199 0.200 0.201 0.202 0.203 0.204 0.205 0.206 0.207 0.208 0.209 0.210 0.211 0.212 0.213 0.214 0.215 0.216 0.217 0.218 0.219 0.220 0.221 0.222 0.223 0.224 0.225 0.226 0.227 0.228 0.229 0.230 0.231 0.232 0.233 0.234 0.235 0.236 0.237 0.238 0.239 0.240 0.241 0.242 0.243 0.244 0.245 0.246 0.247 0.248 0.249 0.250 0.251 0.252 0.253 0.254 0.255 0.256 0.257 0.258 0.259 0.260 0.261 0.262 0.263 0.264 0.265 0.266 0.267 0.268 0.269 0.270 0.271 0.272 0.273 0.274 0.275 0.276 0.277 0.278 0.279 0.280 0.281 0.282 0.283 0.284 0.285 0.286 0.287 0.288 0.289 0.290 0.291 0.292 0.293 0.294 0.295 0.296 0.297 0.298 0.299 0.300 0.301 0.302 0.303 0.304 0.305 0.306 0.307 0.308 0.309 0.310 0.311 0.312 0.313 0.314 0.315 0.316 0.317 0.318 0.319 0.320 0.321 0.322 0.323 0.324 0.325 0.326 0.327 0.328 0.329 0.330 0.331 0.332 0.333 0.334 0.335 0.336 0.337 0.338 0.339 0.340 0.341 0.342 0.343 0.344 0.345 0.346 0.347 0.348 0.349 0.350 0.351 0.352 0.353 0.354 0.355 0.356 0.357 0.358 0.359 0.360 0.361 0.362 0.363 0.364 0.365 0.366 0.367 0.368 0.369 0.370 0.371 0.372 0.373 0.374 0.375 0.376 0.377 0.378 0.379 0.380 0.381 0.382 0.383 0.384 0.385 0.386 0.387 0.388 0.389 0.390 0.391 0.392 0.393 0.394 0.395 0.396 0.397 0.398 0.399 0.400 0.401 0.402 0.403 0.404 0.405 0.406 0.407 0.408 0.409 0.410 0.411 0.412 0.413 0.414 0.415 0.416 0.417 0.418 0.419 0.420 0.421 0.422 0.423 0.424 0.425 0.426 0.427 0.428 0.429 0.430 0.431 0.432 0.433 0.434 0.435 0.436 0.437 0.438 0.439 0.440 0.441 0.442 0.443 0.444 0.445 0.446 0.447 0.448 0.449 0.450 0.451 0.452 0.453 0.454 0.455 0.456 0.457 0.458 0.459 0.460 0.461 0.462 0.463 0.464 0.465 0.466 0.467 0.468 0.469 0.470 0.471 0.472 0.473 0.474 0.475 0.476 0.477 0.478 0.479 0.480 0.481 0.482 0.483 0.484 0.485 0.486 0.487 0.488 0.489 0.490 0.491 0.492 0.493 0.494 0.495 0.496 0.497 0.498 0.499 0.500 0.501 0.502 0.503 0.504 0.505 0.506 0.507 0.508 0.509 0.510 0.511 0.512 0.513 0.514 0.515 0.516 0.517 0.518 0.519 0.520 0.521 0.522 0.523 0.524 0.525 0.526 0.527 0.528 0.529 0.530 0.531 0.532 0.533 0.534 0.535 0.536 0.537 0.538 0.539 0.540 0.541 0.542 0.543 0.544 0.545 0.546 0.547 0.548 0.549 0.550 0.551 0.552 0.553 0.554 0.555 0.556 0.557 0.558 0.559 0.560 0.561 0.562 0.563 0.564 0.565 0.566 0.567 0.568 0.569 0.570 0.571 0.572 0.573 0.574 0.575 0.576 0.577 0.578 0.579 0.580 0.581 0.582 0.583 0.584 0.585 0.586 0.587 0.588 0.589 0.590 0.591 0.592 0.593 0.594 0.595 0.596 0.597 0.598 0.599 0.600 0.601 0.602 0.603 0.604 0.605 0.606 0.607 0.608 0.609 0.610 0.611 0.612 0.613 0.614 0.615 0.616 0.617 0.618 0.619 0.620 0.621 0.622 0.623 0.624 0.625 0.626 0.627 0.628 0.629 0.630 0.631 0.632 0.633 0.634 0.635 0.636 0.637 0.638 0.639 0.640 0.641 0.642 0.643 0.644 0.645 0.646 0.647 0.648 0.649 0.650 0.651 0.652 0.653 0.654 0.655 0.656 0.657 0.658 0.659 0.660 0.661 0.662 0.663 0.664 0.665 0.666 0.667 0.668 0.669 0.670 0.671 0.672 0.673 0.674 0.675 0.676 0.677 0.678 0.679 0.680 0.681 0.682 0.683 0.684 0.685 0.686 0.687 0.688 0.689 0.690 0.691 0.692 0.693 0.694 0.695 0.696 0.697 0.698 0.699 0.700 0.701 0.702 0.703 0.704 0.705 0.706 0.707 0.708 0.709 0.710 0.711 0.712 0.713 0.714 0.715 0.716 0.717 0.718 0.719 0.720 0.721 0.722 0.723 0.724 0.725 0.726 0.727 0.728 0.729 0.730 0.731 0.732 0.733 0.734 0.735 0.736 0.737 0.738 0.739 0.740 0.741 0.742 0.743 0.744 0.745 0.746 0.747 0.748 0.749 0.750 0.751 0.752 0.753 0.754 0.755 0.756 0.757 0.758 0.759 0.760 0.761 0.762 0.763 0.764 0.765 0.766 0.767 0.768 0.769 0.770 0.771 0.772 0.773 0.774 0.775 0.776 0.777 0.778 0.779 0.780 0.781 0.782 0.783 0.784 0.785 0.786 0.787 0.788 0.789 0.790 0.791 0.792 0.793 0.794 0.795 0.796 0.797 0.798 0.799 0.800 0.801 0.802 0.803 0.804 0.805 0.806 0.807 0.808 0.809 0.810 0.811 0.812 0.813 0.814 0.815 0.816 0.817 0.818 0.819 0.820 0.821 0.822 0.823 0.824 0.825 0.826 0.827 0.828 0.829 0.830 0.831 0.832 0.833 0.834 0.835 0.836 0.837 0.838 0.839 0.840 0.841 0.842 0.843 0.844 0.845 0.846 0.847 0.848 0.849 0.850 0.851 0.852 0.853 0.854 0.855 0.856 0.857 0.858 0.859 0.860 0.861 0.862 0.863 0.864 0.865 0.866 0.867 0.868 0.869 0.870 0.871 0.872 0.873 0.874 0.875 0.876 0.877 0.878 0.879 0.880 0.881 0.882 0.883 0.884 0.885 0.886 0.887 0.888 0.889 0.890 0.891 0.892 0.893 0.894 0.895 0.896 0.897 0.898 0.899 0.900 0.901 0.902 0.903 0.904 0.905 0.906 0.907 0.908 0.909 0.910 0.911 0.912 0.913 0.914 0.915 0.916 0.917 0.918 0.919 0.920 0.921 0.922 0.923 0.924 0.925 0.926 0.927 0.928 0.929 0.930 0.931 0.932 0.933 0.934 0.935 0.936 0.937 0.938 0.939 0.940 0.941 0.942 0.943 0.944 0.945 0.946 0.947 0.948 0.949 0.950 0.951 0.952 0.953 0.954 0.955 0.956 0.957 0.958 0.959 0.960 0.961 0.962 0.963 0.964 0.965 0.966 0.967 0.968 0.969 0.970 0.971 0.972 0.973 0.974 0.975 0.976 0.977 0.978 0.979 0.980 0.981 0.982 0.983 0.984 0.985 0.986 0.987 0.988 0.989 0.990 0.991 0.992 0.993 0.994 0.995 0.996 0.997 0.998 0.999 1.000 1.001 1.002 1.003 1.004 1.005 1.006 1.007 1.008 1.009 1.010 1.011 1.012 1.013 1.014 1.015 1.016 1.017 1.018 1.019 1.020 1.021 1.022 1.023 1.024 1.025 1.026 1.027 1.028 1.029 1.030 1.031 1.032 1.033 1.034 1.035 1.036 1.037 1.038 1.039 1.040 1.041 1.042 1.043 1.044 1.045 1.046 1.047 1.048 1.049 1.050 1.051 1.052 1.053 1.054 1.055 1.056 1.057 1.058 1.059 1.060 1.061 1.062 1.063 1.064 1.065 1.066 1.067 1.068 1.069 1.070 1.071 1.072 1.073 1.074 1.075 1.076 1.077 1.078 1.079 1.080 1.081 1.082 1.083 1.084 1.085 1.086 1.087 1.088 1.089 1.090 1.091 1.092 1.093 1.094 1.095 1.096 1.097 1.098 1.099 1.100 1.101 1.102 1.103 1.104 1.105 1.106 1.107 1.108 1.109 1.110 1.111 1.112 1.113 1.114 1.115 1.116 1.117 1.118 1.119 1.120 1.121 1.122 1.123 1.124 1.125 1.126 1.127 1.128 1.129 1.130 1.131 1.132 1.133 1.134 1.135 1.136 1.137 1.138 1.139 1.140 1.141 1.142 1.143 1.144 1.145 1.146 1.147 1.148 1.149 1.150 1.151 1.152 1.153 1.154 1.155 1.156 1.157 1.158 1.159 1.160 1.161 1.162 1.163 1.164 1.165 1.166 1.167 1.168 1.169 1.170 1.171 1.172 1.173 1.174 1.175 1.176 1.177 1.178 1.179 1.180 1.181 1.182 1.183 1.184 1.185 1.186 1.187 1.188 1.189 1.190 1.191 1.192 1.193 1.194 1.195 1.196 1.197 1.198 1.199 1.200 1.201 1.202 1.203 1.204 1.205 1.206 1.207 1.208 1.209 1.210 1.211 1.212 1.213 1.214 1.215 1.216 1.217 1.218 1.219 1.220 1.221 1.222 1.223 1.224 1.225 1.226 1.227 1.228 1.229 1.230 1.231 1.232 1.233 1.234 1.235 1.236 1.237 1.238 1.239 1.240 1.241 1.242 1.243 1.244 1.245 1.246 1.247 1.248 1.249 1.250 1.251 1.252 1.253 1.254 1.255 1.256 1.257 1.258 1.259 1.260 1.261 1.262 1.263 1.264 1.265 1.266 1.267 1.268 1.269 1.270 1.271 1.272 1.273 1.274 1.275 1.276 1.277 1.278 1.279 1.280 1.281 1.282 1.283 1.284 1.285 1.286 1.287 1.288 1.289 1.290 1.291 1.292 1.293 1.294 1.295 1.296 1.297 1.298 1.299 1.300 1.301 1.302 1.303 1.304 1.305 1.306 1.307 1.308 1.309 1.310 1.311 1.312 1.313 1.314 1.315 1.316 1.317 1.318 1.319 1.320 1.321 1.322 1.323 1.324 1.325 1.326 1.327 1.328 1.329 1.330 1.331 1.332 1.333 1.334 1.335 1.336 1.337 1.338 1.339 1.340 1.341 1.342 1.343 1.344 1.345 1.346 1.347 1.348 1.349 1.350 1.351 1.352 1.353 1.354 1.355 1.356 1.357 1.358 1.359 1.360 1.361 1.362 1.363 1.364 1.365 1.366 1.367 1.368 1.369 1.370 1.371 1.372 1.373 1.374 1.375 1.376 1.377 1.378 1.379 1.380 1.381 1.382 1.383 1.384 1.385 1.386 1.387 1.388 1.389 1.390 1.391 1.392 1.393 1.394 1.395 1.396 1.397 1.398 1.399 1.400 1.401 1.402 1.403 1.404 1.405 1.406 1.407 1.408 1.409 1.410 1.411 1.412 1.413 1.414 1.415 1.416 1.417 1.418 1.419 1.420 1.421 1.422 1.423 1.424 1.425 1.426 1.427 1.428 1.429 1.430 1.431 1.432 1.433 1.434 1.435 1.436 1.437 1.438 1.439 1.440 1.441 1.442 1.443 1.444 1.445 1.446 1.447 1.448 1.449 1.450 1.451 1.452 1.453 1.454 1.455 1.456 1.457 1.458 1.459 1.460 1.461 1.462 1.463 1.464 1.465 1.466 1.467 1.468 1.469 1.470 1.471 1.472 1.473 1.474 1.475 1.476 1.477 1.478 1.479 1.480 1.481 1.482 1.483 1.484 1.485 1.486 1.487 1.488 1.489 1.490 1.491 1.492 1.493 1.494 1.495 1.496 1.497 1.498 1.499 1.500 1.501 1.502 1.503 1.504 1.505 1.506 1.507 1.508 1.509 1.510 1.511 1.512 1.513 1.514 1.515 1.516 1.517 1.518 1.519 1.520 1.521 1.522 1.523 1.524 1.525 1.526 1.527 1.528 1.529 1.530 1.531 1.532 1.533 1.534 1.535 1.536 1.537 1.538 1.539 1.540 1.541 1.542 1.543 1.544 1.545 1.546 1.547 1.548 1.549 1.550 1.551 1.552 1.553 1.554 1.555 1.556 1.557 1.558 1.559 1.560 1.561 1.562 1.563 1.564 1.565 1.566 1.567 1.568 1.569 1.570 1.571 1.572 1.573 1.574 1.575 1.576 1.577 1.578 1.579 1.580 1.581 1.582 1.583 1.584 1.585 1.586 1.587 1.588 1.589 1.590 1.591 1.592 1.593 1.594 1.595 1.596 1.597 1.598 1.599 1.600 1.601 1.602 1.603 1.604 1.605 1.606 1.607 1.608 1.609 1.610 1.611 1.612 1.613 1.614 1.615 1.616 1.617 1.618 1.619 1.620 1.621 1.622 1.623 1.624 1.625 1.626 1.627 1.628 1.629 1.630 1.631 1.632 1.633 1.634 1.635 1.636 1.637 1.638 1.639 1.640 1.641 1.642 1.643 1.644 1.645 1.646 1.647 1.648 1.649 1.650 1.651 1.652 1.653 1.654 1.655 1.656 1.657 1.658 1.659 1.660 1.661 1.662 1.663 1.664 1.665 1.666 1.667 1.668 1.669 1.670 1.671 1.672 1.673 1.674 1.675 1.676 1.677 1.678 1.679 1.680 1.681 1.682 1.683 1.684 1.685 1.686 1.687 1.688 1.689 1.690 1.691 1.692 1.693 1.694 1.695 1.696 1.697 1.698 1.699 1.700 1.701 1.702 1.703 1.704 1.705 1.706 1.707 1.708 1.709 1.710 1.711 1.712 1.713 1.714 1.715 1.716 1.717 1.718 1.719 1.720 1.721 1.722 1.723 1.724 1.725 1.726 1.727 1.728 1.729 1.730 1.731 1.732 1.733 1.734 1.735 1.736 1.737 1.738 1.739 1.740 1.741 1.742 1.743 1.744 1.745 1.746 1.747 1.748 1.749 1.750 1.751 1.752 1.753 1.754 1.755 1.756 1.757 1.758 1.759 1.760 1.761 1.762 1.763 1.764 1.765 1.766 1.767 1.768 1.769 1.770 1.771 1.772 1.773 1.774 1.775 1.776 1.777 1.778 1.779 1.780 1.781 1.782 1.783 1.784 1.785 1.786 1.787 1.788 1.789 1.790 1.791 1.792 1.793 1.794 1.795 1.796 1.797 1.798 1.799 1.800 1.801 1.802 1.803 1.804 1.805 1.806 1.807 1.808 1.809 1.810 1.811 1.812 1.813 1.814 1.815 1.816 1.817 1.818 1.819 1.820 1.821 1.822 1.823 1.824 1.825 1.826 1.827 1.828 1.829 1.830 1.831 1.832 1.833 1.834 1.835 1.836 1.837 1.838 1.839 1.840 1.841 1.842 1.843 1.844 1.845 1.846 1.847 1.848 1.849 1.850 1.851 1.852 1.853 1.854 1.855 1.856 1.857 1.858 1.859 1.860 1.861 1.862 1.863 1.864 1.865 1.866 1.867 1.868 1.869 1.870 1.871 1.872 1.873 1.874 1.875 1.876 1.877 1.878 1.879 1.880 1.881 1.882 1.883 1.884 1.885 1.886 1.887 1.888 1.889 1.890 1.891 1.892 1.893 1.894 1.895 1.896 1.897 1.898 1.899 1.900 1.901 1.902 1.903 1.904 1.905 1.906 1.907 1.908 1.909 1.910 1.911 1.912 1.913 1.914 1.915 1.916 1.917 1.918 1.919 1.920 1.921 1.922 1.923 1.924 1.925 1.926 1.927 1.928 1.929 1.930 1.931 1.932 1.933 1.934 1.935 1.936 1.937 1.938 1.939 1.940 1.941 1.942 1.943 1.944 1.945 1.946 1.947 1.948 1.949 1.950 1.951 1.952 1.953 1.954 1.955 1.956 1.957 1.958 1.959 1.960 1.961 1.962 1.963 1.964 1.965 1.966 1.967 1.968 1.969 1.970 1.971 1.972 1.973 1.974 1.975 1.976 1.977 1.978 1.979 1.980 1.981 1.982 1.983 1.984 1.985 1.986 1.987 1.988 1.989 1.990 1.991 1.992 1.993 1.994 1.995 1.996 1.997 1.998 1.999 2.000 2.001 2.002 2.003 2.004 2.005 2.006 2.007 2.008 2.009 2.010 2.011 2.012 2.013 2.014 2.015 2.016 2.017 2.018 2.019 2.020 2.021 2.022 2.023 2.024 2.025 2.026 2.027 2.028 2.029 2.030 2.031 2.032 2.033 2.034 2.035 2.036 2.037 2.038 2.039 2.040 2.041 2.042 2.043 2.044 2.045 2.046 2.047 2.048 2.049 2.050 2.051 2.052 2.053 2.054 2.055 2.056 2.057 2.058 2.059 2.060 2.061 2.062 2.063 2.064 2.065 2.066 2.067 2.068 2.069 2.070 2.071 2.072 2.073 2.074 2.075 2.076 2.077 2.078 2.079 2.080 2.081 2.082 2.083 2.084 2.085 2.086 2.087 2.088 2.089 2.090 2.091 2.092 2.093 2.094 2.095 2.096 2.097 2.098 2.099 2.100 2.101 2.102 2.103 2.104 2.105 2.106 2.107 2.108 2.109 2.110 2.111 2.112 2.113 2.114 2.115 2.116 2.117 2.118 2.119 2.120 2.121 2.122 2.123 2.124 2.125 2.126 2.127 2.128 2.129 2.130 2.131 2.132 2.133 2.134 2.135 2.136 2.137 2.138 2.139 2.140 2.141 2.142 2.143 2.144 2.145 2.146 2.147 2.148 2.149 2.150 2.151 2.152 2.153 2.154 2.155 2.156 2.157 2.158 2.159 2.160 2.161 2.162 2.163 2.164 2.165 2.166 2.167 2.168 2.169 2.170 2.171 2.172 2.173 2.174 2.175 2.176 2.177 2.178 2.179 2.180 2.181 2.182 2.183 2.184 2.185 2.186 2.187 2.188 2.189 2.190 2.191 2.192 2.193 2.194 2.195 2.196 2.197 2.198 2.199 2.200 2.201 2.202 2.203 2.204 2.205 2.206 2.207 2.208 2.209 2.210 2.211 2.212 2.213 2.214 2.215 2.216 2.217 2.218 2.219 2.220 2.221 2.222 2.223 2.224 2.225 2.226 2.227 2.228 2.229 2.230 2.231 2.232 2.233 2.234 2.235 2.236 2.237 2.238 2.239 2.240 2.241 2.242 2.243 2.244 2.245 2.246 2.247 2.248 2.249 2.250 2.251 2.252 2.253 2.254 2.255 2.256 2.257 2.258 2.259 2.260 2.261 2.262 2.263 2.264 2.265 2.266 2.267 2.268 2.269 2.270 2.271 2.272 2.273 2.274 2.275 2.276 2.277 2.278 2.279 2.280 2.281 2.282 2.283 2.284 2.285 2.286 2.287 2.288 2.289 2.290 2.291 2.292 2.293 2.294 2.295 2.296 2.297 2.298 2.299 2.300 2.301 2.302 2.303 2.304 2.305 2.306 2.307 2.308 2.309 2.310 2.311 2.312 2.313 2.314 2.315 2.316 2.317 2.318 2.319 2.320 2.321 2.322 2.323 2.324 2.325 2.326 2.327 2.328 2.329 2.330 2.331 2.332 2.333 2.334 2.335 2.336 2.337 2.338 2.339 2.340 2.341 2.342 2.343 2.344 2.345 2.346 2.347 2.348 2.349 2.350 2.351 2.352 2.353 2.354 2.355 2.356 2.357 2.358 2.359 2.360 2.361 2.362 2.363 2.364 2.365 2.366 2.367 2.368 2.369 2.370 2.371 2.372 2.373 2.374 2.375 2.376 2.377 2.378 2.379 2.380 2.381 2.382 2.383 2.384 2.385 2.386 2.387 2.388 2.389 2.390 2.391 2.392 2.393 2.394 2.395 2.396 2.397 2.398 2.399 2.400 2.401 2.402 2.403 2.404 2.405 2.406 2.407 2.408 2.409 2.410 2.411 2.412 2.413 2.414 2.415 2.416 2.417 2.418 2.419 2.420 2.421 2.422 2.423 2.424 2.425 2.426 2.427 2.428 2.429 2.430 2.431 2.432 2.433 2.434 2.435 2.436 2.437 2.438 2.439 2.440 2.441 2.442 2.443 2.444 2.445 2.446 2.447 2.448 2.449 2.450 2.451 2.452 2.453 2.454 2.455 2.456 2.457 2.458 2.459 2.460 2.461 2.462 2.463 2.464 2.465 2.466 2.467 2.468 2.469 2.470 2.471 2.472 2.473 2.474 2.475 2.476 2.477 2.478 2.479 2.480 2.481 2.482 2.483 2.484 2.485 2.486 2.487 2.488 2.489 2.490 2.491 2.492 2.493 2.494 2.495 2.496 2.497 2.498 2.499 2.500 2.501 2.502 2.503 2.504 2.505 2.506 2.507 2.508 2.509 2.510 2.511 2.512 2.513 2.514 2.515 2.516 2.517 2.518 2.519 2.520 2.521 2.522 2.523 2.524 2.525 2.526 2.527 2.528 2.529 2.530 2.531 2.532 2.533 2.534 2.535 2.536 2.537 2.538 2.539 2.540 2.541 2.542 2.543 2.544 2.545 2.546 2.547 2.548 2.549 2.550 2.551 2.552 2.553 2.554 2.555 2.556 2.557 2.558 2.559 2.560 2.561 2.562 2.563 2.564 2.565 2.566 2.567 2.568 2.569 2.570 2.571 2.572 2.573 2.574 2.575 2.576 2.577 2.578 2.579 2.580 2.581 2.582 2.583 2.584 2.585 2.586 2.587 2.588 2.589 2.590 2.591 2.592 2.593 2.594 2.595 2.596 2.597 2.598 2.599 2.600 2.601 2.602 2.603 2.604 2.605 2.606 2.607 2.608 2.609 2.610 2.611 2.612 2.613 2.614 2.615 2.616 2.617 2.618 2.619 2.620 2.621 2.622 2.623 2.624 2.625 2.626 2.627 2.628 2.629 2.630 2.631 2.632 2.633 2.634 2.635 2.636 2.637 2.638 2.639 2.640 2.641 2.642 2.643 2.644 2.645 2.646 2.647 2.648 2.649 2.650 2.651 2.652 2.653 2.654 2.655 2.656 2.657 2.658 2.659 2.660 2.661 2.662 2.663 2.664 2.665 2.666 2.667 2.668 2.669 2.670 2.671 2.672 2.673 2.674 2.675 2.676 2.677 2.678 2.679 2.680 2.681 2.682 2.683 2.684 2.685 2.686 2.687 2.688 2.689 2.690 2.691 2.692 2.693 2.694 2.695 2.696 2.697 2.698 2.699 2.700 2.701 2.702 2.703 2.704 2.705 2.706 2.707 2.708 2.709 2.710 2.711 2.712 2.713 2.714 2.715 2.716 2.717 2.718 2.719 2.720 2.721 2.722 2.723 2.724 2.725 2.726 2.727 2.728 2.729 2.730 2.731 2.732 2.733 2.734 2.735 2.736 2.737 2.738 2.739 2.740 2.741 2.742 2.743 2.744 2.745 2.746 2.747 2.748 2.749 2.750 2.751 2.752 2.753 2.754 2.755 2.756 2.757 2.758 2.759 2.760 2.761 2.762 2.763 2.764 2.765 2.766 2.767 2.768 2.769 2.770 2.771 2.772 2.773 2.774 2.775 2.776 2.777 2.778 2.779 2.780 2.781 2.782 2.783 2.784 2.785 2.786 2.787 2.788 2.789 2.790 2.791 2.792 2.793 2.794 2.795 2.796 2.797 2.798 2.799 2.800 2.801 2.802 2.803 2.804 2.805 2.806 2.807 2.808 2.809 2.810 2.811 2.812 2.813 2.814 2.815 2.816 2.817 2.818 2.819 2.820 2.821 2.822 2.823 2.824 2.825 2.826 2.827 2.828 2.829 2.830 2.831 2.832 2.833 2.834 2.835 2.836 2.837 2.838 2.839 2.840 2.841 2.842 2.843 2.844 2.845 2.846 2.847 2.848 2.849 2.850 2.851 2.852 2.853 2.854 2.855 2.856 2.857 2.858 2.859 2.860 2.861 2.862 2.863 2.864 2.865 2.866 2.867 2.868 2.869 2.870 2.871 2.872 2.873 2.874 2.875 2.876 2.877 2.878 2.879 2.880 2.881 2.882 2.883 2.884 2.885 2.886 2.887 2.888 2.889 2.890 2.891 2.892 2.893 2.894 2.895 2.896 2.897 2.898 2.899 2.900 2.901 2.902 2.903 2.904 2.905 2.906 2.907 2.908 2.909 2.910 2.911 2.912 2.913 2.914 2.915 2.916 2.917 2.918 2.919 2.920 2.921 2.922 2.923 2.924 2.925 2.926 2.927 2.928 2.929 2.930 2.931 2.932 2.933 2.934 2.935 2.936 2.937 2.938 2.939 2.940 2.941 2.942 2.943 2.944 2.945 2.946 2.947 2.948 2.949 2.950 2.951 2.952 2.953 2.954 2.955 2.956 2.957 2.958 2.959 2.960 2.961 2.962 2.963 2.964 2.965 2.966 2.967 2.968 2.969 2.970 2.971 2.972 2.973 2.974 2.975 2.976 2.977 2.978 2.979 2.980 2.981 2.982 2.983 2.984 2.985 2.986 2.987 2.988 2.989 2.990 2.991 2.992 2.993 2.994 2.995 2.996 2.997 2.998 2.999 3.000]

#define CONTRAST 1.000 //[0.000 0.001 0.002 0.003 0.004 0.005 0.006 0.007 0.008 0.009 0.010 0.011 0.012 0.013 0.014 0.015 0.016 0.017 0.018 0.019 0.020 0.021 0.022 0.023 0.024 0.025 0.026 0.027 0.028 0.029 0.030 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 0.039 0.040 0.041 0.042 0.043 0.044 0.045 0.046 0.047 0.048 0.049 0.050 0.051 0.052 0.053 0.054 0.055 0.056 0.057 0.058 0.059 0.060 0.061 0.062 0.063 0.064 0.065 0.066 0.067 0.068 0.069 0.070 0.071 0.072 0.073 0.074 0.075 0.076 0.077 0.078 0.079 0.080 0.081 0.082 0.083 0.084 0.085 0.086 0.087 0.088 0.089 0.090 0.091 0.092 0.093 0.094 0.095 0.096 0.097 0.098 0.099 0.100 0.101 0.102 0.103 0.104 0.105 0.106 0.107 0.108 0.109 0.110 0.111 0.112 0.113 0.114 0.115 0.116 0.117 0.118 0.119 0.120 0.121 0.122 0.123 0.124 0.125 0.126 0.127 0.128 0.129 0.130 0.131 0.132 0.133 0.134 0.135 0.136 0.137 0.138 0.139 0.140 0.141 0.142 0.143 0.144 0.145 0.146 0.147 0.148 0.149 0.150 0.151 0.152 0.153 0.154 0.155 0.156 0.157 0.158 0.159 0.160 0.161 0.162 0.163 0.164 0.165 0.166 0.167 0.168 0.169 0.170 0.171 0.172 0.173 0.174 0.175 0.176 0.177 0.178 0.179 0.180 0.181 0.182 0.183 0.184 0.185 0.186 0.187 0.188 0.189 0.190 0.191 0.192 0.193 0.194 0.195 0.196 0.197 0.198 0.199 0.200 0.201 0.202 0.203 0.204 0.205 0.206 0.207 0.208 0.209 0.210 0.211 0.212 0.213 0.214 0.215 0.216 0.217 0.218 0.219 0.220 0.221 0.222 0.223 0.224 0.225 0.226 0.227 0.228 0.229 0.230 0.231 0.232 0.233 0.234 0.235 0.236 0.237 0.238 0.239 0.240 0.241 0.242 0.243 0.244 0.245 0.246 0.247 0.248 0.249 0.250 0.251 0.252 0.253 0.254 0.255 0.256 0.257 0.258 0.259 0.260 0.261 0.262 0.263 0.264 0.265 0.266 0.267 0.268 0.269 0.270 0.271 0.272 0.273 0.274 0.275 0.276 0.277 0.278 0.279 0.280 0.281 0.282 0.283 0.284 0.285 0.286 0.287 0.288 0.289 0.290 0.291 0.292 0.293 0.294 0.295 0.296 0.297 0.298 0.299 0.300 0.301 0.302 0.303 0.304 0.305 0.306 0.307 0.308 0.309 0.310 0.311 0.312 0.313 0.314 0.315 0.316 0.317 0.318 0.319 0.320 0.321 0.322 0.323 0.324 0.325 0.326 0.327 0.328 0.329 0.330 0.331 0.332 0.333 0.334 0.335 0.336 0.337 0.338 0.339 0.340 0.341 0.342 0.343 0.344 0.345 0.346 0.347 0.348 0.349 0.350 0.351 0.352 0.353 0.354 0.355 0.356 0.357 0.358 0.359 0.360 0.361 0.362 0.363 0.364 0.365 0.366 0.367 0.368 0.369 0.370 0.371 0.372 0.373 0.374 0.375 0.376 0.377 0.378 0.379 0.380 0.381 0.382 0.383 0.384 0.385 0.386 0.387 0.388 0.389 0.390 0.391 0.392 0.393 0.394 0.395 0.396 0.397 0.398 0.399 0.400 0.401 0.402 0.403 0.404 0.405 0.406 0.407 0.408 0.409 0.410 0.411 0.412 0.413 0.414 0.415 0.416 0.417 0.418 0.419 0.420 0.421 0.422 0.423 0.424 0.425 0.426 0.427 0.428 0.429 0.430 0.431 0.432 0.433 0.434 0.435 0.436 0.437 0.438 0.439 0.440 0.441 0.442 0.443 0.444 0.445 0.446 0.447 0.448 0.449 0.450 0.451 0.452 0.453 0.454 0.455 0.456 0.457 0.458 0.459 0.460 0.461 0.462 0.463 0.464 0.465 0.466 0.467 0.468 0.469 0.470 0.471 0.472 0.473 0.474 0.475 0.476 0.477 0.478 0.479 0.480 0.481 0.482 0.483 0.484 0.485 0.486 0.487 0.488 0.489 0.490 0.491 0.492 0.493 0.494 0.495 0.496 0.497 0.498 0.499 0.500 0.501 0.502 0.503 0.504 0.505 0.506 0.507 0.508 0.509 0.510 0.511 0.512 0.513 0.514 0.515 0.516 0.517 0.518 0.519 0.520 0.521 0.522 0.523 0.524 0.525 0.526 0.527 0.528 0.529 0.530 0.531 0.532 0.533 0.534 0.535 0.536 0.537 0.538 0.539 0.540 0.541 0.542 0.543 0.544 0.545 0.546 0.547 0.548 0.549 0.550 0.551 0.552 0.553 0.554 0.555 0.556 0.557 0.558 0.559 0.560 0.561 0.562 0.563 0.564 0.565 0.566 0.567 0.568 0.569 0.570 0.571 0.572 0.573 0.574 0.575 0.576 0.577 0.578 0.579 0.580 0.581 0.582 0.583 0.584 0.585 0.586 0.587 0.588 0.589 0.590 0.591 0.592 0.593 0.594 0.595 0.596 0.597 0.598 0.599 0.600 0.601 0.602 0.603 0.604 0.605 0.606 0.607 0.608 0.609 0.610 0.611 0.612 0.613 0.614 0.615 0.616 0.617 0.618 0.619 0.620 0.621 0.622 0.623 0.624 0.625 0.626 0.627 0.628 0.629 0.630 0.631 0.632 0.633 0.634 0.635 0.636 0.637 0.638 0.639 0.640 0.641 0.642 0.643 0.644 0.645 0.646 0.647 0.648 0.649 0.650 0.651 0.652 0.653 0.654 0.655 0.656 0.657 0.658 0.659 0.660 0.661 0.662 0.663 0.664 0.665 0.666 0.667 0.668 0.669 0.670 0.671 0.672 0.673 0.674 0.675 0.676 0.677 0.678 0.679 0.680 0.681 0.682 0.683 0.684 0.685 0.686 0.687 0.688 0.689 0.690 0.691 0.692 0.693 0.694 0.695 0.696 0.697 0.698 0.699 0.700 0.701 0.702 0.703 0.704 0.705 0.706 0.707 0.708 0.709 0.710 0.711 0.712 0.713 0.714 0.715 0.716 0.717 0.718 0.719 0.720 0.721 0.722 0.723 0.724 0.725 0.726 0.727 0.728 0.729 0.730 0.731 0.732 0.733 0.734 0.735 0.736 0.737 0.738 0.739 0.740 0.741 0.742 0.743 0.744 0.745 0.746 0.747 0.748 0.749 0.750 0.751 0.752 0.753 0.754 0.755 0.756 0.757 0.758 0.759 0.760 0.761 0.762 0.763 0.764 0.765 0.766 0.767 0.768 0.769 0.770 0.771 0.772 0.773 0.774 0.775 0.776 0.777 0.778 0.779 0.780 0.781 0.782 0.783 0.784 0.785 0.786 0.787 0.788 0.789 0.790 0.791 0.792 0.793 0.794 0.795 0.796 0.797 0.798 0.799 0.800 0.801 0.802 0.803 0.804 0.805 0.806 0.807 0.808 0.809 0.810 0.811 0.812 0.813 0.814 0.815 0.816 0.817 0.818 0.819 0.820 0.821 0.822 0.823 0.824 0.825 0.826 0.827 0.828 0.829 0.830 0.831 0.832 0.833 0.834 0.835 0.836 0.837 0.838 0.839 0.840 0.841 0.842 0.843 0.844 0.845 0.846 0.847 0.848 0.849 0.850 0.851 0.852 0.853 0.854 0.855 0.856 0.857 0.858 0.859 0.860 0.861 0.862 0.863 0.864 0.865 0.866 0.867 0.868 0.869 0.870 0.871 0.872 0.873 0.874 0.875 0.876 0.877 0.878 0.879 0.880 0.881 0.882 0.883 0.884 0.885 0.886 0.887 0.888 0.889 0.890 0.891 0.892 0.893 0.894 0.895 0.896 0.897 0.898 0.899 0.900 0.901 0.902 0.903 0.904 0.905 0.906 0.907 0.908 0.909 0.910 0.911 0.912 0.913 0.914 0.915 0.916 0.917 0.918 0.919 0.920 0.921 0.922 0.923 0.924 0.925 0.926 0.927 0.928 0.929 0.930 0.931 0.932 0.933 0.934 0.935 0.936 0.937 0.938 0.939 0.940 0.941 0.942 0.943 0.944 0.945 0.946 0.947 0.948 0.949 0.950 0.951 0.952 0.953 0.954 0.955 0.956 0.957 0.958 0.959 0.960 0.961 0.962 0.963 0.964 0.965 0.966 0.967 0.968 0.969 0.970 0.971 0.972 0.973 0.974 0.975 0.976 0.977 0.978 0.979 0.980 0.981 0.982 0.983 0.984 0.985 0.986 0.987 0.988 0.989 0.990 0.991 0.992 0.993 0.994 0.995 0.996 0.997 0.998 0.999 1.000 1.001 1.002 1.003 1.004 1.005 1.006 1.007 1.008 1.009 1.010 1.011 1.012 1.013 1.014 1.015 1.016 1.017 1.018 1.019 1.020 1.021 1.022 1.023 1.024 1.025 1.026 1.027 1.028 1.029 1.030 1.031 1.032 1.033 1.034 1.035 1.036 1.037 1.038 1.039 1.040 1.041 1.042 1.043 1.044 1.045 1.046 1.047 1.048 1.049 1.050 1.051 1.052 1.053 1.054 1.055 1.056 1.057 1.058 1.059 1.060 1.061 1.062 1.063 1.064 1.065 1.066 1.067 1.068 1.069 1.070 1.071 1.072 1.073 1.074 1.075 1.076 1.077 1.078 1.079 1.080 1.081 1.082 1.083 1.084 1.085 1.086 1.087 1.088 1.089 1.090 1.091 1.092 1.093 1.094 1.095 1.096 1.097 1.098 1.099 1.100 1.101 1.102 1.103 1.104 1.105 1.106 1.107 1.108 1.109 1.110 1.111 1.112 1.113 1.114 1.115 1.116 1.117 1.118 1.119 1.120 1.121 1.122 1.123 1.124 1.125 1.126 1.127 1.128 1.129 1.130 1.131 1.132 1.133 1.134 1.135 1.136 1.137 1.138 1.139 1.140 1.141 1.142 1.143 1.144 1.145 1.146 1.147 1.148 1.149 1.150 1.151 1.152 1.153 1.154 1.155 1.156 1.157 1.158 1.159 1.160 1.161 1.162 1.163 1.164 1.165 1.166 1.167 1.168 1.169 1.170 1.171 1.172 1.173 1.174 1.175 1.176 1.177 1.178 1.179 1.180 1.181 1.182 1.183 1.184 1.185 1.186 1.187 1.188 1.189 1.190 1.191 1.192 1.193 1.194 1.195 1.196 1.197 1.198 1.199 1.200 1.201 1.202 1.203 1.204 1.205 1.206 1.207 1.208 1.209 1.210 1.211 1.212 1.213 1.214 1.215 1.216 1.217 1.218 1.219 1.220 1.221 1.222 1.223 1.224 1.225 1.226 1.227 1.228 1.229 1.230 1.231 1.232 1.233 1.234 1.235 1.236 1.237 1.238 1.239 1.240 1.241 1.242 1.243 1.244 1.245 1.246 1.247 1.248 1.249 1.250 1.251 1.252 1.253 1.254 1.255 1.256 1.257 1.258 1.259 1.260 1.261 1.262 1.263 1.264 1.265 1.266 1.267 1.268 1.269 1.270 1.271 1.272 1.273 1.274 1.275 1.276 1.277 1.278 1.279 1.280 1.281 1.282 1.283 1.284 1.285 1.286 1.287 1.288 1.289 1.290 1.291 1.292 1.293 1.294 1.295 1.296 1.297 1.298 1.299 1.300 1.301 1.302 1.303 1.304 1.305 1.306 1.307 1.308 1.309 1.310 1.311 1.312 1.313 1.314 1.315 1.316 1.317 1.318 1.319 1.320 1.321 1.322 1.323 1.324 1.325 1.326 1.327 1.328 1.329 1.330 1.331 1.332 1.333 1.334 1.335 1.336 1.337 1.338 1.339 1.340 1.341 1.342 1.343 1.344 1.345 1.346 1.347 1.348 1.349 1.350 1.351 1.352 1.353 1.354 1.355 1.356 1.357 1.358 1.359 1.360 1.361 1.362 1.363 1.364 1.365 1.366 1.367 1.368 1.369 1.370 1.371 1.372 1.373 1.374 1.375 1.376 1.377 1.378 1.379 1.380 1.381 1.382 1.383 1.384 1.385 1.386 1.387 1.388 1.389 1.390 1.391 1.392 1.393 1.394 1.395 1.396 1.397 1.398 1.399 1.400 1.401 1.402 1.403 1.404 1.405 1.406 1.407 1.408 1.409 1.410 1.411 1.412 1.413 1.414 1.415 1.416 1.417 1.418 1.419 1.420 1.421 1.422 1.423 1.424 1.425 1.426 1.427 1.428 1.429 1.430 1.431 1.432 1.433 1.434 1.435 1.436 1.437 1.438 1.439 1.440 1.441 1.442 1.443 1.444 1.445 1.446 1.447 1.448 1.449 1.450 1.451 1.452 1.453 1.454 1.455 1.456 1.457 1.458 1.459 1.460 1.461 1.462 1.463 1.464 1.465 1.466 1.467 1.468 1.469 1.470 1.471 1.472 1.473 1.474 1.475 1.476 1.477 1.478 1.479 1.480 1.481 1.482 1.483 1.484 1.485 1.486 1.487 1.488 1.489 1.490 1.491 1.492 1.493 1.494 1.495 1.496 1.497 1.498 1.499 1.500 1.501 1.502 1.503 1.504 1.505 1.506 1.507 1.508 1.509 1.510 1.511 1.512 1.513 1.514 1.515 1.516 1.517 1.518 1.519 1.520 1.521 1.522 1.523 1.524 1.525 1.526 1.527 1.528 1.529 1.530 1.531 1.532 1.533 1.534 1.535 1.536 1.537 1.538 1.539 1.540 1.541 1.542 1.543 1.544 1.545 1.546 1.547 1.548 1.549 1.550 1.551 1.552 1.553 1.554 1.555 1.556 1.557 1.558 1.559 1.560 1.561 1.562 1.563 1.564 1.565 1.566 1.567 1.568 1.569 1.570 1.571 1.572 1.573 1.574 1.575 1.576 1.577 1.578 1.579 1.580 1.581 1.582 1.583 1.584 1.585 1.586 1.587 1.588 1.589 1.590 1.591 1.592 1.593 1.594 1.595 1.596 1.597 1.598 1.599 1.600 1.601 1.602 1.603 1.604 1.605 1.606 1.607 1.608 1.609 1.610 1.611 1.612 1.613 1.614 1.615 1.616 1.617 1.618 1.619 1.620 1.621 1.622 1.623 1.624 1.625 1.626 1.627 1.628 1.629 1.630 1.631 1.632 1.633 1.634 1.635 1.636 1.637 1.638 1.639 1.640 1.641 1.642 1.643 1.644 1.645 1.646 1.647 1.648 1.649 1.650 1.651 1.652 1.653 1.654 1.655 1.656 1.657 1.658 1.659 1.660 1.661 1.662 1.663 1.664 1.665 1.666 1.667 1.668 1.669 1.670 1.671 1.672 1.673 1.674 1.675 1.676 1.677 1.678 1.679 1.680 1.681 1.682 1.683 1.684 1.685 1.686 1.687 1.688 1.689 1.690 1.691 1.692 1.693 1.694 1.695 1.696 1.697 1.698 1.699 1.700 1.701 1.702 1.703 1.704 1.705 1.706 1.707 1.708 1.709 1.710 1.711 1.712 1.713 1.714 1.715 1.716 1.717 1.718 1.719 1.720 1.721 1.722 1.723 1.724 1.725 1.726 1.727 1.728 1.729 1.730 1.731 1.732 1.733 1.734 1.735 1.736 1.737 1.738 1.739 1.740 1.741 1.742 1.743 1.744 1.745 1.746 1.747 1.748 1.749 1.750 1.751 1.752 1.753 1.754 1.755 1.756 1.757 1.758 1.759 1.760 1.761 1.762 1.763 1.764 1.765 1.766 1.767 1.768 1.769 1.770 1.771 1.772 1.773 1.774 1.775 1.776 1.777 1.778 1.779 1.780 1.781 1.782 1.783 1.784 1.785 1.786 1.787 1.788 1.789 1.790 1.791 1.792 1.793 1.794 1.795 1.796 1.797 1.798 1.799 1.800 1.801 1.802 1.803 1.804 1.805 1.806 1.807 1.808 1.809 1.810 1.811 1.812 1.813 1.814 1.815 1.816 1.817 1.818 1.819 1.820 1.821 1.822 1.823 1.824 1.825 1.826 1.827 1.828 1.829 1.830 1.831 1.832 1.833 1.834 1.835 1.836 1.837 1.838 1.839 1.840 1.841 1.842 1.843 1.844 1.845 1.846 1.847 1.848 1.849 1.850 1.851 1.852 1.853 1.854 1.855 1.856 1.857 1.858 1.859 1.860 1.861 1.862 1.863 1.864 1.865 1.866 1.867 1.868 1.869 1.870 1.871 1.872 1.873 1.874 1.875 1.876 1.877 1.878 1.879 1.880 1.881 1.882 1.883 1.884 1.885 1.886 1.887 1.888 1.889 1.890 1.891 1.892 1.893 1.894 1.895 1.896 1.897 1.898 1.899 1.900 1.901 1.902 1.903 1.904 1.905 1.906 1.907 1.908 1.909 1.910 1.911 1.912 1.913 1.914 1.915 1.916 1.917 1.918 1.919 1.920 1.921 1.922 1.923 1.924 1.925 1.926 1.927 1.928 1.929 1.930 1.931 1.932 1.933 1.934 1.935 1.936 1.937 1.938 1.939 1.940 1.941 1.942 1.943 1.944 1.945 1.946 1.947 1.948 1.949 1.950 1.951 1.952 1.953 1.954 1.955 1.956 1.957 1.958 1.959 1.960 1.961 1.962 1.963 1.964 1.965 1.966 1.967 1.968 1.969 1.970 1.971 1.972 1.973 1.974 1.975 1.976 1.977 1.978 1.979 1.980 1.981 1.982 1.983 1.984 1.985 1.986 1.987 1.988 1.989 1.990 1.991 1.992 1.993 1.994 1.995 1.996 1.997 1.998 1.999 2.000 2.001 2.002 2.003 2.004 2.005 2.006 2.007 2.008 2.009 2.010 2.011 2.012 2.013 2.014 2.015 2.016 2.017 2.018 2.019 2.020 2.021 2.022 2.023 2.024 2.025 2.026 2.027 2.028 2.029 2.030 2.031 2.032 2.033 2.034 2.035 2.036 2.037 2.038 2.039 2.040 2.041 2.042 2.043 2.044 2.045 2.046 2.047 2.048 2.049 2.050 2.051 2.052 2.053 2.054 2.055 2.056 2.057 2.058 2.059 2.060 2.061 2.062 2.063 2.064 2.065 2.066 2.067 2.068 2.069 2.070 2.071 2.072 2.073 2.074 2.075 2.076 2.077 2.078 2.079 2.080 2.081 2.082 2.083 2.084 2.085 2.086 2.087 2.088 2.089 2.090 2.091 2.092 2.093 2.094 2.095 2.096 2.097 2.098 2.099 2.100 2.101 2.102 2.103 2.104 2.105 2.106 2.107 2.108 2.109 2.110 2.111 2.112 2.113 2.114 2.115 2.116 2.117 2.118 2.119 2.120 2.121 2.122 2.123 2.124 2.125 2.126 2.127 2.128 2.129 2.130 2.131 2.132 2.133 2.134 2.135 2.136 2.137 2.138 2.139 2.140 2.141 2.142 2.143 2.144 2.145 2.146 2.147 2.148 2.149 2.150 2.151 2.152 2.153 2.154 2.155 2.156 2.157 2.158 2.159 2.160 2.161 2.162 2.163 2.164 2.165 2.166 2.167 2.168 2.169 2.170 2.171 2.172 2.173 2.174 2.175 2.176 2.177 2.178 2.179 2.180 2.181 2.182 2.183 2.184 2.185 2.186 2.187 2.188 2.189 2.190 2.191 2.192 2.193 2.194 2.195 2.196 2.197 2.198 2.199 2.200 2.201 2.202 2.203 2.204 2.205 2.206 2.207 2.208 2.209 2.210 2.211 2.212 2.213 2.214 2.215 2.216 2.217 2.218 2.219 2.220 2.221 2.222 2.223 2.224 2.225 2.226 2.227 2.228 2.229 2.230 2.231 2.232 2.233 2.234 2.235 2.236 2.237 2.238 2.239 2.240 2.241 2.242 2.243 2.244 2.245 2.246 2.247 2.248 2.249 2.250 2.251 2.252 2.253 2.254 2.255 2.256 2.257 2.258 2.259 2.260 2.261 2.262 2.263 2.264 2.265 2.266 2.267 2.268 2.269 2.270 2.271 2.272 2.273 2.274 2.275 2.276 2.277 2.278 2.279 2.280 2.281 2.282 2.283 2.284 2.285 2.286 2.287 2.288 2.289 2.290 2.291 2.292 2.293 2.294 2.295 2.296 2.297 2.298 2.299 2.300 2.301 2.302 2.303 2.304 2.305 2.306 2.307 2.308 2.309 2.310 2.311 2.312 2.313 2.314 2.315 2.316 2.317 2.318 2.319 2.320 2.321 2.322 2.323 2.324 2.325 2.326 2.327 2.328 2.329 2.330 2.331 2.332 2.333 2.334 2.335 2.336 2.337 2.338 2.339 2.340 2.341 2.342 2.343 2.344 2.345 2.346 2.347 2.348 2.349 2.350 2.351 2.352 2.353 2.354 2.355 2.356 2.357 2.358 2.359 2.360 2.361 2.362 2.363 2.364 2.365 2.366 2.367 2.368 2.369 2.370 2.371 2.372 2.373 2.374 2.375 2.376 2.377 2.378 2.379 2.380 2.381 2.382 2.383 2.384 2.385 2.386 2.387 2.388 2.389 2.390 2.391 2.392 2.393 2.394 2.395 2.396 2.397 2.398 2.399 2.400 2.401 2.402 2.403 2.404 2.405 2.406 2.407 2.408 2.409 2.410 2.411 2.412 2.413 2.414 2.415 2.416 2.417 2.418 2.419 2.420 2.421 2.422 2.423 2.424 2.425 2.426 2.427 2.428 2.429 2.430 2.431 2.432 2.433 2.434 2.435 2.436 2.437 2.438 2.439 2.440 2.441 2.442 2.443 2.444 2.445 2.446 2.447 2.448 2.449 2.450 2.451 2.452 2.453 2.454 2.455 2.456 2.457 2.458 2.459 2.460 2.461 2.462 2.463 2.464 2.465 2.466 2.467 2.468 2.469 2.470 2.471 2.472 2.473 2.474 2.475 2.476 2.477 2.478 2.479 2.480 2.481 2.482 2.483 2.484 2.485 2.486 2.487 2.488 2.489 2.490 2.491 2.492 2.493 2.494 2.495 2.496 2.497 2.498 2.499 2.500 2.501 2.502 2.503 2.504 2.505 2.506 2.507 2.508 2.509 2.510 2.511 2.512 2.513 2.514 2.515 2.516 2.517 2.518 2.519 2.520 2.521 2.522 2.523 2.524 2.525 2.526 2.527 2.528 2.529 2.530 2.531 2.532 2.533 2.534 2.535 2.536 2.537 2.538 2.539 2.540 2.541 2.542 2.543 2.544 2.545 2.546 2.547 2.548 2.549 2.550 2.551 2.552 2.553 2.554 2.555 2.556 2.557 2.558 2.559 2.560 2.561 2.562 2.563 2.564 2.565 2.566 2.567 2.568 2.569 2.570 2.571 2.572 2.573 2.574 2.575 2.576 2.577 2.578 2.579 2.580 2.581 2.582 2.583 2.584 2.585 2.586 2.587 2.588 2.589 2.590 2.591 2.592 2.593 2.594 2.595 2.596 2.597 2.598 2.599 2.600 2.601 2.602 2.603 2.604 2.605 2.606 2.607 2.608 2.609 2.610 2.611 2.612 2.613 2.614 2.615 2.616 2.617 2.618 2.619 2.620 2.621 2.622 2.623 2.624 2.625 2.626 2.627 2.628 2.629 2.630 2.631 2.632 2.633 2.634 2.635 2.636 2.637 2.638 2.639 2.640 2.641 2.642 2.643 2.644 2.645 2.646 2.647 2.648 2.649 2.650 2.651 2.652 2.653 2.654 2.655 2.656 2.657 2.658 2.659 2.660 2.661 2.662 2.663 2.664 2.665 2.666 2.667 2.668 2.669 2.670 2.671 2.672 2.673 2.674 2.675 2.676 2.677 2.678 2.679 2.680 2.681 2.682 2.683 2.684 2.685 2.686 2.687 2.688 2.689 2.690 2.691 2.692 2.693 2.694 2.695 2.696 2.697 2.698 2.699 2.700 2.701 2.702 2.703 2.704 2.705 2.706 2.707 2.708 2.709 2.710 2.711 2.712 2.713 2.714 2.715 2.716 2.717 2.718 2.719 2.720 2.721 2.722 2.723 2.724 2.725 2.726 2.727 2.728 2.729 2.730 2.731 2.732 2.733 2.734 2.735 2.736 2.737 2.738 2.739 2.740 2.741 2.742 2.743 2.744 2.745 2.746 2.747 2.748 2.749 2.750 2.751 2.752 2.753 2.754 2.755 2.756 2.757 2.758 2.759 2.760 2.761 2.762 2.763 2.764 2.765 2.766 2.767 2.768 2.769 2.770 2.771 2.772 2.773 2.774 2.775 2.776 2.777 2.778 2.779 2.780 2.781 2.782 2.783 2.784 2.785 2.786 2.787 2.788 2.789 2.790 2.791 2.792 2.793 2.794 2.795 2.796 2.797 2.798 2.799 2.800 2.801 2.802 2.803 2.804 2.805 2.806 2.807 2.808 2.809 2.810 2.811 2.812 2.813 2.814 2.815 2.816 2.817 2.818 2.819 2.820 2.821 2.822 2.823 2.824 2.825 2.826 2.827 2.828 2.829 2.830 2.831 2.832 2.833 2.834 2.835 2.836 2.837 2.838 2.839 2.840 2.841 2.842 2.843 2.844 2.845 2.846 2.847 2.848 2.849 2.850 2.851 2.852 2.853 2.854 2.855 2.856 2.857 2.858 2.859 2.860 2.861 2.862 2.863 2.864 2.865 2.866 2.867 2.868 2.869 2.870 2.871 2.872 2.873 2.874 2.875 2.876 2.877 2.878 2.879 2.880 2.881 2.882 2.883 2.884 2.885 2.886 2.887 2.888 2.889 2.890 2.891 2.892 2.893 2.894 2.895 2.896 2.897 2.898 2.899 2.900 2.901 2.902 2.903 2.904 2.905 2.906 2.907 2.908 2.909 2.910 2.911 2.912 2.913 2.914 2.915 2.916 2.917 2.918 2.919 2.920 2.921 2.922 2.923 2.924 2.925 2.926 2.927 2.928 2.929 2.930 2.931 2.932 2.933 2.934 2.935 2.936 2.937 2.938 2.939 2.940 2.941 2.942 2.943 2.944 2.945 2.946 2.947 2.948 2.949 2.950 2.951 2.952 2.953 2.954 2.955 2.956 2.957 2.958 2.959 2.960 2.961 2.962 2.963 2.964 2.965 2.966 2.967 2.968 2.969 2.970 2.971 2.972 2.973 2.974 2.975 2.976 2.977 2.978 2.979 2.980 2.981 2.982 2.983 2.984 2.985 2.986 2.987 2.988 2.989 2.990 2.991 2.992 2.993 2.994 2.995 2.996 2.997 2.998 2.999 3.000]

#define BRIGHTNESS 1.000 //[0.000 0.001 0.002 0.003 0.004 0.005 0.006 0.007 0.008 0.009 0.010 0.011 0.012 0.013 0.014 0.015 0.016 0.017 0.018 0.019 0.020 0.021 0.022 0.023 0.024 0.025 0.026 0.027 0.028 0.029 0.030 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 0.039 0.040 0.041 0.042 0.043 0.044 0.045 0.046 0.047 0.048 0.049 0.050 0.051 0.052 0.053 0.054 0.055 0.056 0.057 0.058 0.059 0.060 0.061 0.062 0.063 0.064 0.065 0.066 0.067 0.068 0.069 0.070 0.071 0.072 0.073 0.074 0.075 0.076 0.077 0.078 0.079 0.080 0.081 0.082 0.083 0.084 0.085 0.086 0.087 0.088 0.089 0.090 0.091 0.092 0.093 0.094 0.095 0.096 0.097 0.098 0.099 0.100 0.101 0.102 0.103 0.104 0.105 0.106 0.107 0.108 0.109 0.110 0.111 0.112 0.113 0.114 0.115 0.116 0.117 0.118 0.119 0.120 0.121 0.122 0.123 0.124 0.125 0.126 0.127 0.128 0.129 0.130 0.131 0.132 0.133 0.134 0.135 0.136 0.137 0.138 0.139 0.140 0.141 0.142 0.143 0.144 0.145 0.146 0.147 0.148 0.149 0.150 0.151 0.152 0.153 0.154 0.155 0.156 0.157 0.158 0.159 0.160 0.161 0.162 0.163 0.164 0.165 0.166 0.167 0.168 0.169 0.170 0.171 0.172 0.173 0.174 0.175 0.176 0.177 0.178 0.179 0.180 0.181 0.182 0.183 0.184 0.185 0.186 0.187 0.188 0.189 0.190 0.191 0.192 0.193 0.194 0.195 0.196 0.197 0.198 0.199 0.200 0.201 0.202 0.203 0.204 0.205 0.206 0.207 0.208 0.209 0.210 0.211 0.212 0.213 0.214 0.215 0.216 0.217 0.218 0.219 0.220 0.221 0.222 0.223 0.224 0.225 0.226 0.227 0.228 0.229 0.230 0.231 0.232 0.233 0.234 0.235 0.236 0.237 0.238 0.239 0.240 0.241 0.242 0.243 0.244 0.245 0.246 0.247 0.248 0.249 0.250 0.251 0.252 0.253 0.254 0.255 0.256 0.257 0.258 0.259 0.260 0.261 0.262 0.263 0.264 0.265 0.266 0.267 0.268 0.269 0.270 0.271 0.272 0.273 0.274 0.275 0.276 0.277 0.278 0.279 0.280 0.281 0.282 0.283 0.284 0.285 0.286 0.287 0.288 0.289 0.290 0.291 0.292 0.293 0.294 0.295 0.296 0.297 0.298 0.299 0.300 0.301 0.302 0.303 0.304 0.305 0.306 0.307 0.308 0.309 0.310 0.311 0.312 0.313 0.314 0.315 0.316 0.317 0.318 0.319 0.320 0.321 0.322 0.323 0.324 0.325 0.326 0.327 0.328 0.329 0.330 0.331 0.332 0.333 0.334 0.335 0.336 0.337 0.338 0.339 0.340 0.341 0.342 0.343 0.344 0.345 0.346 0.347 0.348 0.349 0.350 0.351 0.352 0.353 0.354 0.355 0.356 0.357 0.358 0.359 0.360 0.361 0.362 0.363 0.364 0.365 0.366 0.367 0.368 0.369 0.370 0.371 0.372 0.373 0.374 0.375 0.376 0.377 0.378 0.379 0.380 0.381 0.382 0.383 0.384 0.385 0.386 0.387 0.388 0.389 0.390 0.391 0.392 0.393 0.394 0.395 0.396 0.397 0.398 0.399 0.400 0.401 0.402 0.403 0.404 0.405 0.406 0.407 0.408 0.409 0.410 0.411 0.412 0.413 0.414 0.415 0.416 0.417 0.418 0.419 0.420 0.421 0.422 0.423 0.424 0.425 0.426 0.427 0.428 0.429 0.430 0.431 0.432 0.433 0.434 0.435 0.436 0.437 0.438 0.439 0.440 0.441 0.442 0.443 0.444 0.445 0.446 0.447 0.448 0.449 0.450 0.451 0.452 0.453 0.454 0.455 0.456 0.457 0.458 0.459 0.460 0.461 0.462 0.463 0.464 0.465 0.466 0.467 0.468 0.469 0.470 0.471 0.472 0.473 0.474 0.475 0.476 0.477 0.478 0.479 0.480 0.481 0.482 0.483 0.484 0.485 0.486 0.487 0.488 0.489 0.490 0.491 0.492 0.493 0.494 0.495 0.496 0.497 0.498 0.499 0.500 0.501 0.502 0.503 0.504 0.505 0.506 0.507 0.508 0.509 0.510 0.511 0.512 0.513 0.514 0.515 0.516 0.517 0.518 0.519 0.520 0.521 0.522 0.523 0.524 0.525 0.526 0.527 0.528 0.529 0.530 0.531 0.532 0.533 0.534 0.535 0.536 0.537 0.538 0.539 0.540 0.541 0.542 0.543 0.544 0.545 0.546 0.547 0.548 0.549 0.550 0.551 0.552 0.553 0.554 0.555 0.556 0.557 0.558 0.559 0.560 0.561 0.562 0.563 0.564 0.565 0.566 0.567 0.568 0.569 0.570 0.571 0.572 0.573 0.574 0.575 0.576 0.577 0.578 0.579 0.580 0.581 0.582 0.583 0.584 0.585 0.586 0.587 0.588 0.589 0.590 0.591 0.592 0.593 0.594 0.595 0.596 0.597 0.598 0.599 0.600 0.601 0.602 0.603 0.604 0.605 0.606 0.607 0.608 0.609 0.610 0.611 0.612 0.613 0.614 0.615 0.616 0.617 0.618 0.619 0.620 0.621 0.622 0.623 0.624 0.625 0.626 0.627 0.628 0.629 0.630 0.631 0.632 0.633 0.634 0.635 0.636 0.637 0.638 0.639 0.640 0.641 0.642 0.643 0.644 0.645 0.646 0.647 0.648 0.649 0.650 0.651 0.652 0.653 0.654 0.655 0.656 0.657 0.658 0.659 0.660 0.661 0.662 0.663 0.664 0.665 0.666 0.667 0.668 0.669 0.670 0.671 0.672 0.673 0.674 0.675 0.676 0.677 0.678 0.679 0.680 0.681 0.682 0.683 0.684 0.685 0.686 0.687 0.688 0.689 0.690 0.691 0.692 0.693 0.694 0.695 0.696 0.697 0.698 0.699 0.700 0.701 0.702 0.703 0.704 0.705 0.706 0.707 0.708 0.709 0.710 0.711 0.712 0.713 0.714 0.715 0.716 0.717 0.718 0.719 0.720 0.721 0.722 0.723 0.724 0.725 0.726 0.727 0.728 0.729 0.730 0.731 0.732 0.733 0.734 0.735 0.736 0.737 0.738 0.739 0.740 0.741 0.742 0.743 0.744 0.745 0.746 0.747 0.748 0.749 0.750 0.751 0.752 0.753 0.754 0.755 0.756 0.757 0.758 0.759 0.760 0.761 0.762 0.763 0.764 0.765 0.766 0.767 0.768 0.769 0.770 0.771 0.772 0.773 0.774 0.775 0.776 0.777 0.778 0.779 0.780 0.781 0.782 0.783 0.784 0.785 0.786 0.787 0.788 0.789 0.790 0.791 0.792 0.793 0.794 0.795 0.796 0.797 0.798 0.799 0.800 0.801 0.802 0.803 0.804 0.805 0.806 0.807 0.808 0.809 0.810 0.811 0.812 0.813 0.814 0.815 0.816 0.817 0.818 0.819 0.820 0.821 0.822 0.823 0.824 0.825 0.826 0.827 0.828 0.829 0.830 0.831 0.832 0.833 0.834 0.835 0.836 0.837 0.838 0.839 0.840 0.841 0.842 0.843 0.844 0.845 0.846 0.847 0.848 0.849 0.850 0.851 0.852 0.853 0.854 0.855 0.856 0.857 0.858 0.859 0.860 0.861 0.862 0.863 0.864 0.865 0.866 0.867 0.868 0.869 0.870 0.871 0.872 0.873 0.874 0.875 0.876 0.877 0.878 0.879 0.880 0.881 0.882 0.883 0.884 0.885 0.886 0.887 0.888 0.889 0.890 0.891 0.892 0.893 0.894 0.895 0.896 0.897 0.898 0.899 0.900 0.901 0.902 0.903 0.904 0.905 0.906 0.907 0.908 0.909 0.910 0.911 0.912 0.913 0.914 0.915 0.916 0.917 0.918 0.919 0.920 0.921 0.922 0.923 0.924 0.925 0.926 0.927 0.928 0.929 0.930 0.931 0.932 0.933 0.934 0.935 0.936 0.937 0.938 0.939 0.940 0.941 0.942 0.943 0.944 0.945 0.946 0.947 0.948 0.949 0.950 0.951 0.952 0.953 0.954 0.955 0.956 0.957 0.958 0.959 0.960 0.961 0.962 0.963 0.964 0.965 0.966 0.967 0.968 0.969 0.970 0.971 0.972 0.973 0.974 0.975 0.976 0.977 0.978 0.979 0.980 0.981 0.982 0.983 0.984 0.985 0.986 0.987 0.988 0.989 0.990 0.991 0.992 0.993 0.994 0.995 0.996 0.997 0.998 0.999 1.000 1.001 1.002 1.003 1.004 1.005 1.006 1.007 1.008 1.009 1.010 1.011 1.012 1.013 1.014 1.015 1.016 1.017 1.018 1.019 1.020 1.021 1.022 1.023 1.024 1.025 1.026 1.027 1.028 1.029 1.030 1.031 1.032 1.033 1.034 1.035 1.036 1.037 1.038 1.039 1.040 1.041 1.042 1.043 1.044 1.045 1.046 1.047 1.048 1.049 1.050 1.051 1.052 1.053 1.054 1.055 1.056 1.057 1.058 1.059 1.060 1.061 1.062 1.063 1.064 1.065 1.066 1.067 1.068 1.069 1.070 1.071 1.072 1.073 1.074 1.075 1.076 1.077 1.078 1.079 1.080 1.081 1.082 1.083 1.084 1.085 1.086 1.087 1.088 1.089 1.090 1.091 1.092 1.093 1.094 1.095 1.096 1.097 1.098 1.099 1.100 1.101 1.102 1.103 1.104 1.105 1.106 1.107 1.108 1.109 1.110 1.111 1.112 1.113 1.114 1.115 1.116 1.117 1.118 1.119 1.120 1.121 1.122 1.123 1.124 1.125 1.126 1.127 1.128 1.129 1.130 1.131 1.132 1.133 1.134 1.135 1.136 1.137 1.138 1.139 1.140 1.141 1.142 1.143 1.144 1.145 1.146 1.147 1.148 1.149 1.150 1.151 1.152 1.153 1.154 1.155 1.156 1.157 1.158 1.159 1.160 1.161 1.162 1.163 1.164 1.165 1.166 1.167 1.168 1.169 1.170 1.171 1.172 1.173 1.174 1.175 1.176 1.177 1.178 1.179 1.180 1.181 1.182 1.183 1.184 1.185 1.186 1.187 1.188 1.189 1.190 1.191 1.192 1.193 1.194 1.195 1.196 1.197 1.198 1.199 1.200 1.201 1.202 1.203 1.204 1.205 1.206 1.207 1.208 1.209 1.210 1.211 1.212 1.213 1.214 1.215 1.216 1.217 1.218 1.219 1.220 1.221 1.222 1.223 1.224 1.225 1.226 1.227 1.228 1.229 1.230 1.231 1.232 1.233 1.234 1.235 1.236 1.237 1.238 1.239 1.240 1.241 1.242 1.243 1.244 1.245 1.246 1.247 1.248 1.249 1.250 1.251 1.252 1.253 1.254 1.255 1.256 1.257 1.258 1.259 1.260 1.261 1.262 1.263 1.264 1.265 1.266 1.267 1.268 1.269 1.270 1.271 1.272 1.273 1.274 1.275 1.276 1.277 1.278 1.279 1.280 1.281 1.282 1.283 1.284 1.285 1.286 1.287 1.288 1.289 1.290 1.291 1.292 1.293 1.294 1.295 1.296 1.297 1.298 1.299 1.300 1.301 1.302 1.303 1.304 1.305 1.306 1.307 1.308 1.309 1.310 1.311 1.312 1.313 1.314 1.315 1.316 1.317 1.318 1.319 1.320 1.321 1.322 1.323 1.324 1.325 1.326 1.327 1.328 1.329 1.330 1.331 1.332 1.333 1.334 1.335 1.336 1.337 1.338 1.339 1.340 1.341 1.342 1.343 1.344 1.345 1.346 1.347 1.348 1.349 1.350 1.351 1.352 1.353 1.354 1.355 1.356 1.357 1.358 1.359 1.360 1.361 1.362 1.363 1.364 1.365 1.366 1.367 1.368 1.369 1.370 1.371 1.372 1.373 1.374 1.375 1.376 1.377 1.378 1.379 1.380 1.381 1.382 1.383 1.384 1.385 1.386 1.387 1.388 1.389 1.390 1.391 1.392 1.393 1.394 1.395 1.396 1.397 1.398 1.399 1.400 1.401 1.402 1.403 1.404 1.405 1.406 1.407 1.408 1.409 1.410 1.411 1.412 1.413 1.414 1.415 1.416 1.417 1.418 1.419 1.420 1.421 1.422 1.423 1.424 1.425 1.426 1.427 1.428 1.429 1.430 1.431 1.432 1.433 1.434 1.435 1.436 1.437 1.438 1.439 1.440 1.441 1.442 1.443 1.444 1.445 1.446 1.447 1.448 1.449 1.450 1.451 1.452 1.453 1.454 1.455 1.456 1.457 1.458 1.459 1.460 1.461 1.462 1.463 1.464 1.465 1.466 1.467 1.468 1.469 1.470 1.471 1.472 1.473 1.474 1.475 1.476 1.477 1.478 1.479 1.480 1.481 1.482 1.483 1.484 1.485 1.486 1.487 1.488 1.489 1.490 1.491 1.492 1.493 1.494 1.495 1.496 1.497 1.498 1.499 1.500 1.501 1.502 1.503 1.504 1.505 1.506 1.507 1.508 1.509 1.510 1.511 1.512 1.513 1.514 1.515 1.516 1.517 1.518 1.519 1.520 1.521 1.522 1.523 1.524 1.525 1.526 1.527 1.528 1.529 1.530 1.531 1.532 1.533 1.534 1.535 1.536 1.537 1.538 1.539 1.540 1.541 1.542 1.543 1.544 1.545 1.546 1.547 1.548 1.549 1.550 1.551 1.552 1.553 1.554 1.555 1.556 1.557 1.558 1.559 1.560 1.561 1.562 1.563 1.564 1.565 1.566 1.567 1.568 1.569 1.570 1.571 1.572 1.573 1.574 1.575 1.576 1.577 1.578 1.579 1.580 1.581 1.582 1.583 1.584 1.585 1.586 1.587 1.588 1.589 1.590 1.591 1.592 1.593 1.594 1.595 1.596 1.597 1.598 1.599 1.600 1.601 1.602 1.603 1.604 1.605 1.606 1.607 1.608 1.609 1.610 1.611 1.612 1.613 1.614 1.615 1.616 1.617 1.618 1.619 1.620 1.621 1.622 1.623 1.624 1.625 1.626 1.627 1.628 1.629 1.630 1.631 1.632 1.633 1.634 1.635 1.636 1.637 1.638 1.639 1.640 1.641 1.642 1.643 1.644 1.645 1.646 1.647 1.648 1.649 1.650 1.651 1.652 1.653 1.654 1.655 1.656 1.657 1.658 1.659 1.660 1.661 1.662 1.663 1.664 1.665 1.666 1.667 1.668 1.669 1.670 1.671 1.672 1.673 1.674 1.675 1.676 1.677 1.678 1.679 1.680 1.681 1.682 1.683 1.684 1.685 1.686 1.687 1.688 1.689 1.690 1.691 1.692 1.693 1.694 1.695 1.696 1.697 1.698 1.699 1.700 1.701 1.702 1.703 1.704 1.705 1.706 1.707 1.708 1.709 1.710 1.711 1.712 1.713 1.714 1.715 1.716 1.717 1.718 1.719 1.720 1.721 1.722 1.723 1.724 1.725 1.726 1.727 1.728 1.729 1.730 1.731 1.732 1.733 1.734 1.735 1.736 1.737 1.738 1.739 1.740 1.741 1.742 1.743 1.744 1.745 1.746 1.747 1.748 1.749 1.750 1.751 1.752 1.753 1.754 1.755 1.756 1.757 1.758 1.759 1.760 1.761 1.762 1.763 1.764 1.765 1.766 1.767 1.768 1.769 1.770 1.771 1.772 1.773 1.774 1.775 1.776 1.777 1.778 1.779 1.780 1.781 1.782 1.783 1.784 1.785 1.786 1.787 1.788 1.789 1.790 1.791 1.792 1.793 1.794 1.795 1.796 1.797 1.798 1.799 1.800 1.801 1.802 1.803 1.804 1.805 1.806 1.807 1.808 1.809 1.810 1.811 1.812 1.813 1.814 1.815 1.816 1.817 1.818 1.819 1.820 1.821 1.822 1.823 1.824 1.825 1.826 1.827 1.828 1.829 1.830 1.831 1.832 1.833 1.834 1.835 1.836 1.837 1.838 1.839 1.840 1.841 1.842 1.843 1.844 1.845 1.846 1.847 1.848 1.849 1.850 1.851 1.852 1.853 1.854 1.855 1.856 1.857 1.858 1.859 1.860 1.861 1.862 1.863 1.864 1.865 1.866 1.867 1.868 1.869 1.870 1.871 1.872 1.873 1.874 1.875 1.876 1.877 1.878 1.879 1.880 1.881 1.882 1.883 1.884 1.885 1.886 1.887 1.888 1.889 1.890 1.891 1.892 1.893 1.894 1.895 1.896 1.897 1.898 1.899 1.900 1.901 1.902 1.903 1.904 1.905 1.906 1.907 1.908 1.909 1.910 1.911 1.912 1.913 1.914 1.915 1.916 1.917 1.918 1.919 1.920 1.921 1.922 1.923 1.924 1.925 1.926 1.927 1.928 1.929 1.930 1.931 1.932 1.933 1.934 1.935 1.936 1.937 1.938 1.939 1.940 1.941 1.942 1.943 1.944 1.945 1.946 1.947 1.948 1.949 1.950 1.951 1.952 1.953 1.954 1.955 1.956 1.957 1.958 1.959 1.960 1.961 1.962 1.963 1.964 1.965 1.966 1.967 1.968 1.969 1.970 1.971 1.972 1.973 1.974 1.975 1.976 1.977 1.978 1.979 1.980 1.981 1.982 1.983 1.984 1.985 1.986 1.987 1.988 1.989 1.990 1.991 1.992 1.993 1.994 1.995 1.996 1.997 1.998 1.999 2.000 2.001 2.002 2.003 2.004 2.005 2.006 2.007 2.008 2.009 2.010 2.011 2.012 2.013 2.014 2.015 2.016 2.017 2.018 2.019 2.020 2.021 2.022 2.023 2.024 2.025 2.026 2.027 2.028 2.029 2.030 2.031 2.032 2.033 2.034 2.035 2.036 2.037 2.038 2.039 2.040 2.041 2.042 2.043 2.044 2.045 2.046 2.047 2.048 2.049 2.050 2.051 2.052 2.053 2.054 2.055 2.056 2.057 2.058 2.059 2.060 2.061 2.062 2.063 2.064 2.065 2.066 2.067 2.068 2.069 2.070 2.071 2.072 2.073 2.074 2.075 2.076 2.077 2.078 2.079 2.080 2.081 2.082 2.083 2.084 2.085 2.086 2.087 2.088 2.089 2.090 2.091 2.092 2.093 2.094 2.095 2.096 2.097 2.098 2.099 2.100 2.101 2.102 2.103 2.104 2.105 2.106 2.107 2.108 2.109 2.110 2.111 2.112 2.113 2.114 2.115 2.116 2.117 2.118 2.119 2.120 2.121 2.122 2.123 2.124 2.125 2.126 2.127 2.128 2.129 2.130 2.131 2.132 2.133 2.134 2.135 2.136 2.137 2.138 2.139 2.140 2.141 2.142 2.143 2.144 2.145 2.146 2.147 2.148 2.149 2.150 2.151 2.152 2.153 2.154 2.155 2.156 2.157 2.158 2.159 2.160 2.161 2.162 2.163 2.164 2.165 2.166 2.167 2.168 2.169 2.170 2.171 2.172 2.173 2.174 2.175 2.176 2.177 2.178 2.179 2.180 2.181 2.182 2.183 2.184 2.185 2.186 2.187 2.188 2.189 2.190 2.191 2.192 2.193 2.194 2.195 2.196 2.197 2.198 2.199 2.200 2.201 2.202 2.203 2.204 2.205 2.206 2.207 2.208 2.209 2.210 2.211 2.212 2.213 2.214 2.215 2.216 2.217 2.218 2.219 2.220 2.221 2.222 2.223 2.224 2.225 2.226 2.227 2.228 2.229 2.230 2.231 2.232 2.233 2.234 2.235 2.236 2.237 2.238 2.239 2.240 2.241 2.242 2.243 2.244 2.245 2.246 2.247 2.248 2.249 2.250 2.251 2.252 2.253 2.254 2.255 2.256 2.257 2.258 2.259 2.260 2.261 2.262 2.263 2.264 2.265 2.266 2.267 2.268 2.269 2.270 2.271 2.272 2.273 2.274 2.275 2.276 2.277 2.278 2.279 2.280 2.281 2.282 2.283 2.284 2.285 2.286 2.287 2.288 2.289 2.290 2.291 2.292 2.293 2.294 2.295 2.296 2.297 2.298 2.299 2.300 2.301 2.302 2.303 2.304 2.305 2.306 2.307 2.308 2.309 2.310 2.311 2.312 2.313 2.314 2.315 2.316 2.317 2.318 2.319 2.320 2.321 2.322 2.323 2.324 2.325 2.326 2.327 2.328 2.329 2.330 2.331 2.332 2.333 2.334 2.335 2.336 2.337 2.338 2.339 2.340 2.341 2.342 2.343 2.344 2.345 2.346 2.347 2.348 2.349 2.350 2.351 2.352 2.353 2.354 2.355 2.356 2.357 2.358 2.359 2.360 2.361 2.362 2.363 2.364 2.365 2.366 2.367 2.368 2.369 2.370 2.371 2.372 2.373 2.374 2.375 2.376 2.377 2.378 2.379 2.380 2.381 2.382 2.383 2.384 2.385 2.386 2.387 2.388 2.389 2.390 2.391 2.392 2.393 2.394 2.395 2.396 2.397 2.398 2.399 2.400 2.401 2.402 2.403 2.404 2.405 2.406 2.407 2.408 2.409 2.410 2.411 2.412 2.413 2.414 2.415 2.416 2.417 2.418 2.419 2.420 2.421 2.422 2.423 2.424 2.425 2.426 2.427 2.428 2.429 2.430 2.431 2.432 2.433 2.434 2.435 2.436 2.437 2.438 2.439 2.440 2.441 2.442 2.443 2.444 2.445 2.446 2.447 2.448 2.449 2.450 2.451 2.452 2.453 2.454 2.455 2.456 2.457 2.458 2.459 2.460 2.461 2.462 2.463 2.464 2.465 2.466 2.467 2.468 2.469 2.470 2.471 2.472 2.473 2.474 2.475 2.476 2.477 2.478 2.479 2.480 2.481 2.482 2.483 2.484 2.485 2.486 2.487 2.488 2.489 2.490 2.491 2.492 2.493 2.494 2.495 2.496 2.497 2.498 2.499 2.500 2.501 2.502 2.503 2.504 2.505 2.506 2.507 2.508 2.509 2.510 2.511 2.512 2.513 2.514 2.515 2.516 2.517 2.518 2.519 2.520 2.521 2.522 2.523 2.524 2.525 2.526 2.527 2.528 2.529 2.530 2.531 2.532 2.533 2.534 2.535 2.536 2.537 2.538 2.539 2.540 2.541 2.542 2.543 2.544 2.545 2.546 2.547 2.548 2.549 2.550 2.551 2.552 2.553 2.554 2.555 2.556 2.557 2.558 2.559 2.560 2.561 2.562 2.563 2.564 2.565 2.566 2.567 2.568 2.569 2.570 2.571 2.572 2.573 2.574 2.575 2.576 2.577 2.578 2.579 2.580 2.581 2.582 2.583 2.584 2.585 2.586 2.587 2.588 2.589 2.590 2.591 2.592 2.593 2.594 2.595 2.596 2.597 2.598 2.599 2.600 2.601 2.602 2.603 2.604 2.605 2.606 2.607 2.608 2.609 2.610 2.611 2.612 2.613 2.614 2.615 2.616 2.617 2.618 2.619 2.620 2.621 2.622 2.623 2.624 2.625 2.626 2.627 2.628 2.629 2.630 2.631 2.632 2.633 2.634 2.635 2.636 2.637 2.638 2.639 2.640 2.641 2.642 2.643 2.644 2.645 2.646 2.647 2.648 2.649 2.650 2.651 2.652 2.653 2.654 2.655 2.656 2.657 2.658 2.659 2.660 2.661 2.662 2.663 2.664 2.665 2.666 2.667 2.668 2.669 2.670 2.671 2.672 2.673 2.674 2.675 2.676 2.677 2.678 2.679 2.680 2.681 2.682 2.683 2.684 2.685 2.686 2.687 2.688 2.689 2.690 2.691 2.692 2.693 2.694 2.695 2.696 2.697 2.698 2.699 2.700 2.701 2.702 2.703 2.704 2.705 2.706 2.707 2.708 2.709 2.710 2.711 2.712 2.713 2.714 2.715 2.716 2.717 2.718 2.719 2.720 2.721 2.722 2.723 2.724 2.725 2.726 2.727 2.728 2.729 2.730 2.731 2.732 2.733 2.734 2.735 2.736 2.737 2.738 2.739 2.740 2.741 2.742 2.743 2.744 2.745 2.746 2.747 2.748 2.749 2.750 2.751 2.752 2.753 2.754 2.755 2.756 2.757 2.758 2.759 2.760 2.761 2.762 2.763 2.764 2.765 2.766 2.767 2.768 2.769 2.770 2.771 2.772 2.773 2.774 2.775 2.776 2.777 2.778 2.779 2.780 2.781 2.782 2.783 2.784 2.785 2.786 2.787 2.788 2.789 2.790 2.791 2.792 2.793 2.794 2.795 2.796 2.797 2.798 2.799 2.800 2.801 2.802 2.803 2.804 2.805 2.806 2.807 2.808 2.809 2.810 2.811 2.812 2.813 2.814 2.815 2.816 2.817 2.818 2.819 2.820 2.821 2.822 2.823 2.824 2.825 2.826 2.827 2.828 2.829 2.830 2.831 2.832 2.833 2.834 2.835 2.836 2.837 2.838 2.839 2.840 2.841 2.842 2.843 2.844 2.845 2.846 2.847 2.848 2.849 2.850 2.851 2.852 2.853 2.854 2.855 2.856 2.857 2.858 2.859 2.860 2.861 2.862 2.863 2.864 2.865 2.866 2.867 2.868 2.869 2.870 2.871 2.872 2.873 2.874 2.875 2.876 2.877 2.878 2.879 2.880 2.881 2.882 2.883 2.884 2.885 2.886 2.887 2.888 2.889 2.890 2.891 2.892 2.893 2.894 2.895 2.896 2.897 2.898 2.899 2.900 2.901 2.902 2.903 2.904 2.905 2.906 2.907 2.908 2.909 2.910 2.911 2.912 2.913 2.914 2.915 2.916 2.917 2.918 2.919 2.920 2.921 2.922 2.923 2.924 2.925 2.926 2.927 2.928 2.929 2.930 2.931 2.932 2.933 2.934 2.935 2.936 2.937 2.938 2.939 2.940 2.941 2.942 2.943 2.944 2.945 2.946 2.947 2.948 2.949 2.950 2.951 2.952 2.953 2.954 2.955 2.956 2.957 2.958 2.959 2.960 2.961 2.962 2.963 2.964 2.965 2.966 2.967 2.968 2.969 2.970 2.971 2.972 2.973 2.974 2.975 2.976 2.977 2.978 2.979 2.980 2.981 2.982 2.983 2.984 2.985 2.986 2.987 2.988 2.989 2.990 2.991 2.992 2.993 2.994 2.995 2.996 2.997 2.998 2.999 3.000]

#define HELD_LIGHT_PBR 1 //[0 1]

#define CAVE_LIGHT_LEAK_FIX_SKY 1 //[0 1]

#define USE_PBR_TO_GET_RIGHT_FACE 0 //[0 1]

#define COPPER_TORCH_R 0.20 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define COPPER_TORCH_G 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define COPPER_TORCH_B 0.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define COPPER_TORCH_LOW_R 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define COPPER_TORCH_LOW_G 0.70 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define COPPER_TORCH_LOW_B 0.25 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define UN_SHADED_NAMETAGS 0 //[0 1]
#define SEE_NAMETAGS_BETTER_THROUGH_WALLS 0 //[0 1]
#define NAMETAGS_OPACITY_THROUGH_WALLS 0.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define HAND_LIGHT_CAPTURE_BACKUP 0 //[0 1]
#define SMALL_GI 0 //[0 1]


#define VANILLA_EMMISIVE_THRSHHOLD 0.968 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.965 0.967 0.968 0.97 0.98 0.99 1.00]

#define USE_EXTENDED_OVERRIDE_LIST 1 //[0 1]

#define END_SKY_GRADIENT 0 //[0 1]
#define END_SKY_TEXTURED 0 //[0 1]
 
#define FORCE_VOXY_BUILT_IN_SHADERS 0 //[0 1 2]

#define WORK_GROUP_SIZE 128 //[64 128 256]

#define SOLAR_GI 0 //[0 1 2]
#define FIX_FLIICKERING_GI 1 //[0 1]
#define REBALANCE_LIGHTING_FOR_GI 2 //[0 1 2]


#define SOLAR_GI_DOT 1 //[0 1] 
#define DIRECTIONAL_SOLAR_GI 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.965 0.967 0.968 0.97 0.98 0.99 1.00]
#define TRACELESS_PT 0 //[0 1]

#define ADJUST_GI_INTENSITY 0 //[0 1] 
#define GI_INTENSITY 1.000 //[0.000 0.001 0.002 0.003 0.004 0.005 0.006 0.007 0.008 0.009 0.010 0.011 0.012 0.013 0.014 0.015 0.016 0.017 0.018 0.019 0.020 0.021 0.022 0.023 0.024 0.025 0.026 0.027 0.028 0.029 0.030 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 0.039 0.040 0.041 0.042 0.043 0.044 0.045 0.046 0.047 0.048 0.049 0.050 0.051 0.052 0.053 0.054 0.055 0.056 0.057 0.058 0.059 0.060 0.061 0.062 0.063 0.064 0.065 0.066 0.067 0.068 0.069 0.070 0.071 0.072 0.073 0.074 0.075 0.076 0.077 0.078 0.079 0.080 0.081 0.082 0.083 0.084 0.085 0.086 0.087 0.088 0.089 0.090 0.091 0.092 0.093 0.094 0.095 0.096 0.097 0.098 0.099 0.100 0.101 0.102 0.103 0.104 0.105 0.106 0.107 0.108 0.109 0.110 0.111 0.112 0.113 0.114 0.115 0.116 0.117 0.118 0.119 0.120 0.121 0.122 0.123 0.124 0.125 0.126 0.127 0.128 0.129 0.130 0.131 0.132 0.133 0.134 0.135 0.136 0.137 0.138 0.139 0.140 0.141 0.142 0.143 0.144 0.145 0.146 0.147 0.148 0.149 0.150 0.151 0.152 0.153 0.154 0.155 0.156 0.157 0.158 0.159 0.160 0.161 0.162 0.163 0.164 0.165 0.166 0.167 0.168 0.169 0.170 0.171 0.172 0.173 0.174 0.175 0.176 0.177 0.178 0.179 0.180 0.181 0.182 0.183 0.184 0.185 0.186 0.187 0.188 0.189 0.190 0.191 0.192 0.193 0.194 0.195 0.196 0.197 0.198 0.199 0.200 0.201 0.202 0.203 0.204 0.205 0.206 0.207 0.208 0.209 0.210 0.211 0.212 0.213 0.214 0.215 0.216 0.217 0.218 0.219 0.220 0.221 0.222 0.223 0.224 0.225 0.226 0.227 0.228 0.229 0.230 0.231 0.232 0.233 0.234 0.235 0.236 0.237 0.238 0.239 0.240 0.241 0.242 0.243 0.244 0.245 0.246 0.247 0.248 0.249 0.250 0.251 0.252 0.253 0.254 0.255 0.256 0.257 0.258 0.259 0.260 0.261 0.262 0.263 0.264 0.265 0.266 0.267 0.268 0.269 0.270 0.271 0.272 0.273 0.274 0.275 0.276 0.277 0.278 0.279 0.280 0.281 0.282 0.283 0.284 0.285 0.286 0.287 0.288 0.289 0.290 0.291 0.292 0.293 0.294 0.295 0.296 0.297 0.298 0.299 0.300 0.301 0.302 0.303 0.304 0.305 0.306 0.307 0.308 0.309 0.310 0.311 0.312 0.313 0.314 0.315 0.316 0.317 0.318 0.319 0.320 0.321 0.322 0.323 0.324 0.325 0.326 0.327 0.328 0.329 0.330 0.331 0.332 0.333 0.334 0.335 0.336 0.337 0.338 0.339 0.340 0.341 0.342 0.343 0.344 0.345 0.346 0.347 0.348 0.349 0.350 0.351 0.352 0.353 0.354 0.355 0.356 0.357 0.358 0.359 0.360 0.361 0.362 0.363 0.364 0.365 0.366 0.367 0.368 0.369 0.370 0.371 0.372 0.373 0.374 0.375 0.376 0.377 0.378 0.379 0.380 0.381 0.382 0.383 0.384 0.385 0.386 0.387 0.388 0.389 0.390 0.391 0.392 0.393 0.394 0.395 0.396 0.397 0.398 0.399 0.400 0.401 0.402 0.403 0.404 0.405 0.406 0.407 0.408 0.409 0.410 0.411 0.412 0.413 0.414 0.415 0.416 0.417 0.418 0.419 0.420 0.421 0.422 0.423 0.424 0.425 0.426 0.427 0.428 0.429 0.430 0.431 0.432 0.433 0.434 0.435 0.436 0.437 0.438 0.439 0.440 0.441 0.442 0.443 0.444 0.445 0.446 0.447 0.448 0.449 0.450 0.451 0.452 0.453 0.454 0.455 0.456 0.457 0.458 0.459 0.460 0.461 0.462 0.463 0.464 0.465 0.466 0.467 0.468 0.469 0.470 0.471 0.472 0.473 0.474 0.475 0.476 0.477 0.478 0.479 0.480 0.481 0.482 0.483 0.484 0.485 0.486 0.487 0.488 0.489 0.490 0.491 0.492 0.493 0.494 0.495 0.496 0.497 0.498 0.499 0.500 0.501 0.502 0.503 0.504 0.505 0.506 0.507 0.508 0.509 0.510 0.511 0.512 0.513 0.514 0.515 0.516 0.517 0.518 0.519 0.520 0.521 0.522 0.523 0.524 0.525 0.526 0.527 0.528 0.529 0.530 0.531 0.532 0.533 0.534 0.535 0.536 0.537 0.538 0.539 0.540 0.541 0.542 0.543 0.544 0.545 0.546 0.547 0.548 0.549 0.550 0.551 0.552 0.553 0.554 0.555 0.556 0.557 0.558 0.559 0.560 0.561 0.562 0.563 0.564 0.565 0.566 0.567 0.568 0.569 0.570 0.571 0.572 0.573 0.574 0.575 0.576 0.577 0.578 0.579 0.580 0.581 0.582 0.583 0.584 0.585 0.586 0.587 0.588 0.589 0.590 0.591 0.592 0.593 0.594 0.595 0.596 0.597 0.598 0.599 0.600 0.601 0.602 0.603 0.604 0.605 0.606 0.607 0.608 0.609 0.610 0.611 0.612 0.613 0.614 0.615 0.616 0.617 0.618 0.619 0.620 0.621 0.622 0.623 0.624 0.625 0.626 0.627 0.628 0.629 0.630 0.631 0.632 0.633 0.634 0.635 0.636 0.637 0.638 0.639 0.640 0.641 0.642 0.643 0.644 0.645 0.646 0.647 0.648 0.649 0.650 0.651 0.652 0.653 0.654 0.655 0.656 0.657 0.658 0.659 0.660 0.661 0.662 0.663 0.664 0.665 0.666 0.667 0.668 0.669 0.670 0.671 0.672 0.673 0.674 0.675 0.676 0.677 0.678 0.679 0.680 0.681 0.682 0.683 0.684 0.685 0.686 0.687 0.688 0.689 0.690 0.691 0.692 0.693 0.694 0.695 0.696 0.697 0.698 0.699 0.700 0.701 0.702 0.703 0.704 0.705 0.706 0.707 0.708 0.709 0.710 0.711 0.712 0.713 0.714 0.715 0.716 0.717 0.718 0.719 0.720 0.721 0.722 0.723 0.724 0.725 0.726 0.727 0.728 0.729 0.730 0.731 0.732 0.733 0.734 0.735 0.736 0.737 0.738 0.739 0.740 0.741 0.742 0.743 0.744 0.745 0.746 0.747 0.748 0.749 0.750 0.751 0.752 0.753 0.754 0.755 0.756 0.757 0.758 0.759 0.760 0.761 0.762 0.763 0.764 0.765 0.766 0.767 0.768 0.769 0.770 0.771 0.772 0.773 0.774 0.775 0.776 0.777 0.778 0.779 0.780 0.781 0.782 0.783 0.784 0.785 0.786 0.787 0.788 0.789 0.790 0.791 0.792 0.793 0.794 0.795 0.796 0.797 0.798 0.799 0.800 0.801 0.802 0.803 0.804 0.805 0.806 0.807 0.808 0.809 0.810 0.811 0.812 0.813 0.814 0.815 0.816 0.817 0.818 0.819 0.820 0.821 0.822 0.823 0.824 0.825 0.826 0.827 0.828 0.829 0.830 0.831 0.832 0.833 0.834 0.835 0.836 0.837 0.838 0.839 0.840 0.841 0.842 0.843 0.844 0.845 0.846 0.847 0.848 0.849 0.850 0.851 0.852 0.853 0.854 0.855 0.856 0.857 0.858 0.859 0.860 0.861 0.862 0.863 0.864 0.865 0.866 0.867 0.868 0.869 0.870 0.871 0.872 0.873 0.874 0.875 0.876 0.877 0.878 0.879 0.880 0.881 0.882 0.883 0.884 0.885 0.886 0.887 0.888 0.889 0.890 0.891 0.892 0.893 0.894 0.895 0.896 0.897 0.898 0.899 0.900 0.901 0.902 0.903 0.904 0.905 0.906 0.907 0.908 0.909 0.910 0.911 0.912 0.913 0.914 0.915 0.916 0.917 0.918 0.919 0.920 0.921 0.922 0.923 0.924 0.925 0.926 0.927 0.928 0.929 0.930 0.931 0.932 0.933 0.934 0.935 0.936 0.937 0.938 0.939 0.940 0.941 0.942 0.943 0.944 0.945 0.946 0.947 0.948 0.949 0.950 0.951 0.952 0.953 0.954 0.955 0.956 0.957 0.958 0.959 0.960 0.961 0.962 0.963 0.964 0.965 0.966 0.967 0.968 0.969 0.970 0.971 0.972 0.973 0.974 0.975 0.976 0.977 0.978 0.979 0.980 0.981 0.982 0.983 0.984 0.985 0.986 0.987 0.988 0.989 0.990 0.991 0.992 0.993 0.994 0.995 0.996 0.997 0.998 0.999 1.000]
// 1.001 1.002 1.003 1.004 1.005 1.006 1.007 1.008 1.009 1.010 1.011 1.012 1.013 1.014 1.015 1.016 1.017 1.018 1.019 1.020 1.021 1.022 1.023 1.024 1.025 1.026 1.027 1.028 1.029 1.030 1.031 1.032 1.033 1.034 1.035 1.036 1.037 1.038 1.039 1.040 1.041 1.042 1.043 1.044 1.045 1.046 1.047 1.048 1.049 1.050 1.051 1.052 1.053 1.054 1.055 1.056 1.057 1.058 1.059 1.060 1.061 1.062 1.063 1.064 1.065 1.066 1.067 1.068 1.069 1.070 1.071 1.072 1.073 1.074 1.075 1.076 1.077 1.078 1.079 1.080 1.081 1.082 1.083 1.084 1.085 1.086 1.087 1.088 1.089 1.090 1.091 1.092 1.093 1.094 1.095 1.096 1.097 1.098 1.099 1.100 1.101 1.102 1.103 1.104 1.105 1.106 1.107 1.108 1.109 1.110 1.111 1.112 1.113 1.114 1.115 1.116 1.117 1.118 1.119 1.120 1.121 1.122 1.123 1.124 1.125 1.126 1.127 1.128 1.129 1.130 1.131 1.132 1.133 1.134 1.135 1.136 1.137 1.138 1.139 1.140 1.141 1.142 1.143 1.144 1.145 1.146 1.147 1.148 1.149 1.150 1.151 1.152 1.153 1.154 1.155 1.156 1.157 1.158 1.159 1.160 1.161 1.162 1.163 1.164 1.165 1.166 1.167 1.168 1.169 1.170 1.171 1.172 1.173 1.174 1.175 1.176 1.177 1.178 1.179 1.180 1.181 1.182 1.183 1.184 1.185 1.186 1.187 1.188 1.189 1.190 1.191 1.192 1.193 1.194 1.195 1.196 1.197 1.198 1.199 1.200 1.201 1.202 1.203 1.204 1.205 1.206 1.207 1.208 1.209 1.210 1.211 1.212 1.213 1.214 1.215 1.216 1.217 1.218 1.219 1.220 1.221 1.222 1.223 1.224 1.225 1.226 1.227 1.228 1.229 1.230 1.231 1.232 1.233 1.234 1.235 1.236 1.237 1.238 1.239 1.240 1.241 1.242 1.243 1.244 1.245 1.246 1.247 1.248 1.249 1.250 1.251 1.252 1.253 1.254 1.255 1.256 1.257 1.258 1.259 1.260 1.261 1.262 1.263 1.264 1.265 1.266 1.267 1.268 1.269 1.270 1.271 1.272 1.273 1.274 1.275 1.276 1.277 1.278 1.279 1.280 1.281 1.282 1.283 1.284 1.285 1.286 1.287 1.288 1.289 1.290 1.291 1.292 1.293 1.294 1.295 1.296 1.297 1.298 1.299 1.300 1.301 1.302 1.303 1.304 1.305 1.306 1.307 1.308 1.309 1.310 1.311 1.312 1.313 1.314 1.315 1.316 1.317 1.318 1.319 1.320 1.321 1.322 1.323 1.324 1.325 1.326 1.327 1.328 1.329 1.330 1.331 1.332 1.333 1.334 1.335 1.336 1.337 1.338 1.339 1.340 1.341 1.342 1.343 1.344 1.345 1.346 1.347 1.348 1.349 1.350 1.351 1.352 1.353 1.354 1.355 1.356 1.357 1.358 1.359 1.360 1.361 1.362 1.363 1.364 1.365 1.366 1.367 1.368 1.369 1.370 1.371 1.372 1.373 1.374 1.375 1.376 1.377 1.378 1.379 1.380 1.381 1.382 1.383 1.384 1.385 1.386 1.387 1.388 1.389 1.390 1.391 1.392 1.393 1.394 1.395 1.396 1.397 1.398 1.399 1.400 1.401 1.402 1.403 1.404 1.405 1.406 1.407 1.408 1.409 1.410 1.411 1.412 1.413 1.414 1.415 1.416 1.417 1.418 1.419 1.420 1.421 1.422 1.423 1.424 1.425 1.426 1.427 1.428 1.429 1.430 1.431 1.432 1.433 1.434 1.435 1.436 1.437 1.438 1.439 1.440 1.441 1.442 1.443 1.444 1.445 1.446 1.447 1.448 1.449 1.450 1.451 1.452 1.453 1.454 1.455 1.456 1.457 1.458 1.459 1.460 1.461 1.462 1.463 1.464 1.465 1.466 1.467 1.468 1.469 1.470 1.471 1.472 1.473 1.474 1.475 1.476 1.477 1.478 1.479 1.480 1.481 1.482 1.483 1.484 1.485 1.486 1.487 1.488 1.489 1.490 1.491 1.492 1.493 1.494 1.495 1.496 1.497 1.498 1.499 1.500 1.501 1.502 1.503 1.504 1.505 1.506 1.507 1.508 1.509 1.510 1.511 1.512 1.513 1.514 1.515 1.516 1.517 1.518 1.519 1.520 1.521 1.522 1.523 1.524 1.525 1.526 1.527 1.528 1.529 1.530 1.531 1.532 1.533 1.534 1.535 1.536 1.537 1.538 1.539 1.540 1.541 1.542 1.543 1.544 1.545 1.546 1.547 1.548 1.549 1.550 1.551 1.552 1.553 1.554 1.555 1.556 1.557 1.558 1.559 1.560 1.561 1.562 1.563 1.564 1.565 1.566 1.567 1.568 1.569 1.570 1.571 1.572 1.573 1.574 1.575 1.576 1.577 1.578 1.579 1.580 1.581 1.582 1.583 1.584 1.585 1.586 1.587 1.588 1.589 1.590 1.591 1.592 1.593 1.594 1.595 1.596 1.597 1.598 1.599 1.600 1.601 1.602 1.603 1.604 1.605 1.606 1.607 1.608 1.609 1.610 1.611 1.612 1.613 1.614 1.615 1.616 1.617 1.618 1.619 1.620 1.621 1.622 1.623 1.624 1.625 1.626 1.627 1.628 1.629 1.630 1.631 1.632 1.633 1.634 1.635 1.636 1.637 1.638 1.639 1.640 1.641 1.642 1.643 1.644 1.645 1.646 1.647 1.648 1.649 1.650 1.651 1.652 1.653 1.654 1.655 1.656 1.657 1.658 1.659 1.660 1.661 1.662 1.663 1.664 1.665 1.666 1.667 1.668 1.669 1.670 1.671 1.672 1.673 1.674 1.675 1.676 1.677 1.678 1.679 1.680 1.681 1.682 1.683 1.684 1.685 1.686 1.687 1.688 1.689 1.690 1.691 1.692 1.693 1.694 1.695 1.696 1.697 1.698 1.699 1.700 1.701 1.702 1.703 1.704 1.705 1.706 1.707 1.708 1.709 1.710 1.711 1.712 1.713 1.714 1.715 1.716 1.717 1.718 1.719 1.720 1.721 1.722 1.723 1.724 1.725 1.726 1.727 1.728 1.729 1.730 1.731 1.732 1.733 1.734 1.735 1.736 1.737 1.738 1.739 1.740 1.741 1.742 1.743 1.744 1.745 1.746 1.747 1.748 1.749 1.750 1.751 1.752 1.753 1.754 1.755 1.756 1.757 1.758 1.759 1.760 1.761 1.762 1.763 1.764 1.765 1.766 1.767 1.768 1.769 1.770 1.771 1.772 1.773 1.774 1.775 1.776 1.777 1.778 1.779 1.780 1.781 1.782 1.783 1.784 1.785 1.786 1.787 1.788 1.789 1.790 1.791 1.792 1.793 1.794 1.795 1.796 1.797 1.798 1.799 1.800 1.801 1.802 1.803 1.804 1.805 1.806 1.807 1.808 1.809 1.810 1.811 1.812 1.813 1.814 1.815 1.816 1.817 1.818 1.819 1.820 1.821 1.822 1.823 1.824 1.825 1.826 1.827 1.828 1.829 1.830 1.831 1.832 1.833 1.834 1.835 1.836 1.837 1.838 1.839 1.840 1.841 1.842 1.843 1.844 1.845 1.846 1.847 1.848 1.849 1.850 1.851 1.852 1.853 1.854 1.855 1.856 1.857 1.858 1.859 1.860 1.861 1.862 1.863 1.864 1.865 1.866 1.867 1.868 1.869 1.870 1.871 1.872 1.873 1.874 1.875 1.876 1.877 1.878 1.879 1.880 1.881 1.882 1.883 1.884 1.885 1.886 1.887 1.888 1.889 1.890 1.891 1.892 1.893 1.894 1.895 1.896 1.897 1.898 1.899 1.900 1.901 1.902 1.903 1.904 1.905 1.906 1.907 1.908 1.909 1.910 1.911 1.912 1.913 1.914 1.915 1.916 1.917 1.918 1.919 1.920 1.921 1.922 1.923 1.924 1.925 1.926 1.927 1.928 1.929 1.930 1.931 1.932 1.933 1.934 1.935 1.936 1.937 1.938 1.939 1.940 1.941 1.942 1.943 1.944 1.945 1.946 1.947 1.948 1.949 1.950 1.951 1.952 1.953 1.954 1.955 1.956 1.957 1.958 1.959 1.960 1.961 1.962 1.963 1.964 1.965 1.966 1.967 1.968 1.969 1.970 1.971 1.972 1.973 1.974 1.975 1.976 1.977 1.978 1.979 1.980 1.981 1.982 1.983 1.984 1.985 1.986 1.987 1.988 1.989 1.990 1.991 1.992 1.993 1.994 1.995 1.996 1.997 1.998 1.999 2.000 2.001 2.002 2.003 2.004 2.005 2.006 2.007 2.008 2.009 2.010 2.011 2.012 2.013 2.014 2.015 2.016 2.017 2.018 2.019 2.020 2.021 2.022 2.023 2.024 2.025 2.026 2.027 2.028 2.029 2.030 2.031 2.032 2.033 2.034 2.035 2.036 2.037 2.038 2.039 2.040 2.041 2.042 2.043 2.044 2.045 2.046 2.047 2.048 2.049 2.050 2.051 2.052 2.053 2.054 2.055 2.056 2.057 2.058 2.059 2.060 2.061 2.062 2.063 2.064 2.065 2.066 2.067 2.068 2.069 2.070 2.071 2.072 2.073 2.074 2.075 2.076 2.077 2.078 2.079 2.080 2.081 2.082 2.083 2.084 2.085 2.086 2.087 2.088 2.089 2.090 2.091 2.092 2.093 2.094 2.095 2.096 2.097 2.098 2.099 2.100 2.101 2.102 2.103 2.104 2.105 2.106 2.107 2.108 2.109 2.110 2.111 2.112 2.113 2.114 2.115 2.116 2.117 2.118 2.119 2.120 2.121 2.122 2.123 2.124 2.125 2.126 2.127 2.128 2.129 2.130 2.131 2.132 2.133 2.134 2.135 2.136 2.137 2.138 2.139 2.140 2.141 2.142 2.143 2.144 2.145 2.146 2.147 2.148 2.149 2.150 2.151 2.152 2.153 2.154 2.155 2.156 2.157 2.158 2.159 2.160 2.161 2.162 2.163 2.164 2.165 2.166 2.167 2.168 2.169 2.170 2.171 2.172 2.173 2.174 2.175 2.176 2.177 2.178 2.179 2.180 2.181 2.182 2.183 2.184 2.185 2.186 2.187 2.188 2.189 2.190 2.191 2.192 2.193 2.194 2.195 2.196 2.197 2.198 2.199 2.200 2.201 2.202 2.203 2.204 2.205 2.206 2.207 2.208 2.209 2.210 2.211 2.212 2.213 2.214 2.215 2.216 2.217 2.218 2.219 2.220 2.221 2.222 2.223 2.224 2.225 2.226 2.227 2.228 2.229 2.230 2.231 2.232 2.233 2.234 2.235 2.236 2.237 2.238 2.239 2.240 2.241 2.242 2.243 2.244 2.245 2.246 2.247 2.248 2.249 2.250 2.251 2.252 2.253 2.254 2.255 2.256 2.257 2.258 2.259 2.260 2.261 2.262 2.263 2.264 2.265 2.266 2.267 2.268 2.269 2.270 2.271 2.272 2.273 2.274 2.275 2.276 2.277 2.278 2.279 2.280 2.281 2.282 2.283 2.284 2.285 2.286 2.287 2.288 2.289 2.290 2.291 2.292 2.293 2.294 2.295 2.296 2.297 2.298 2.299 2.300 2.301 2.302 2.303 2.304 2.305 2.306 2.307 2.308 2.309 2.310 2.311 2.312 2.313 2.314 2.315 2.316 2.317 2.318 2.319 2.320 2.321 2.322 2.323 2.324 2.325 2.326 2.327 2.328 2.329 2.330 2.331 2.332 2.333 2.334 2.335 2.336 2.337 2.338 2.339 2.340 2.341 2.342 2.343 2.344 2.345 2.346 2.347 2.348 2.349 2.350 2.351 2.352 2.353 2.354 2.355 2.356 2.357 2.358 2.359 2.360 2.361 2.362 2.363 2.364 2.365 2.366 2.367 2.368 2.369 2.370 2.371 2.372 2.373 2.374 2.375 2.376 2.377 2.378 2.379 2.380 2.381 2.382 2.383 2.384 2.385 2.386 2.387 2.388 2.389 2.390 2.391 2.392 2.393 2.394 2.395 2.396 2.397 2.398 2.399 2.400 2.401 2.402 2.403 2.404 2.405 2.406 2.407 2.408 2.409 2.410 2.411 2.412 2.413 2.414 2.415 2.416 2.417 2.418 2.419 2.420 2.421 2.422 2.423 2.424 2.425 2.426 2.427 2.428 2.429 2.430 2.431 2.432 2.433 2.434 2.435 2.436 2.437 2.438 2.439 2.440 2.441 2.442 2.443 2.444 2.445 2.446 2.447 2.448 2.449 2.450 2.451 2.452 2.453 2.454 2.455 2.456 2.457 2.458 2.459 2.460 2.461 2.462 2.463 2.464 2.465 2.466 2.467 2.468 2.469 2.470 2.471 2.472 2.473 2.474 2.475 2.476 2.477 2.478 2.479 2.480 2.481 2.482 2.483 2.484 2.485 2.486 2.487 2.488 2.489 2.490 2.491 2.492 2.493 2.494 2.495 2.496 2.497 2.498 2.499 2.500 2.501 2.502 2.503 2.504 2.505 2.506 2.507 2.508 2.509 2.510 2.511 2.512 2.513 2.514 2.515 2.516 2.517 2.518 2.519 2.520 2.521 2.522 2.523 2.524 2.525 2.526 2.527 2.528 2.529 2.530 2.531 2.532 2.533 2.534 2.535 2.536 2.537 2.538 2.539 2.540 2.541 2.542 2.543 2.544 2.545 2.546 2.547 2.548 2.549 2.550 2.551 2.552 2.553 2.554 2.555 2.556 2.557 2.558 2.559 2.560 2.561 2.562 2.563 2.564 2.565 2.566 2.567 2.568 2.569 2.570 2.571 2.572 2.573 2.574 2.575 2.576 2.577 2.578 2.579 2.580 2.581 2.582 2.583 2.584 2.585 2.586 2.587 2.588 2.589 2.590 2.591 2.592 2.593 2.594 2.595 2.596 2.597 2.598 2.599 2.600 2.601 2.602 2.603 2.604 2.605 2.606 2.607 2.608 2.609 2.610 2.611 2.612 2.613 2.614 2.615 2.616 2.617 2.618 2.619 2.620 2.621 2.622 2.623 2.624 2.625 2.626 2.627 2.628 2.629 2.630 2.631 2.632 2.633 2.634 2.635 2.636 2.637 2.638 2.639 2.640 2.641 2.642 2.643 2.644 2.645 2.646 2.647 2.648 2.649 2.650 2.651 2.652 2.653 2.654 2.655 2.656 2.657 2.658 2.659 2.660 2.661 2.662 2.663 2.664 2.665 2.666 2.667 2.668 2.669 2.670 2.671 2.672 2.673 2.674 2.675 2.676 2.677 2.678 2.679 2.680 2.681 2.682 2.683 2.684 2.685 2.686 2.687 2.688 2.689 2.690 2.691 2.692 2.693 2.694 2.695 2.696 2.697 2.698 2.699 2.700 2.701 2.702 2.703 2.704 2.705 2.706 2.707 2.708 2.709 2.710 2.711 2.712 2.713 2.714 2.715 2.716 2.717 2.718 2.719 2.720 2.721 2.722 2.723 2.724 2.725 2.726 2.727 2.728 2.729 2.730 2.731 2.732 2.733 2.734 2.735 2.736 2.737 2.738 2.739 2.740 2.741 2.742 2.743 2.744 2.745 2.746 2.747 2.748 2.749 2.750 2.751 2.752 2.753 2.754 2.755 2.756 2.757 2.758 2.759 2.760 2.761 2.762 2.763 2.764 2.765 2.766 2.767 2.768 2.769 2.770 2.771 2.772 2.773 2.774 2.775 2.776 2.777 2.778 2.779 2.780 2.781 2.782 2.783 2.784 2.785 2.786 2.787 2.788 2.789 2.790 2.791 2.792 2.793 2.794 2.795 2.796 2.797 2.798 2.799 2.800 2.801 2.802 2.803 2.804 2.805 2.806 2.807 2.808 2.809 2.810 2.811 2.812 2.813 2.814 2.815 2.816 2.817 2.818 2.819 2.820 2.821 2.822 2.823 2.824 2.825 2.826 2.827 2.828 2.829 2.830 2.831 2.832 2.833 2.834 2.835 2.836 2.837 2.838 2.839 2.840 2.841 2.842 2.843 2.844 2.845 2.846 2.847 2.848 2.849 2.850 2.851 2.852 2.853 2.854 2.855 2.856 2.857 2.858 2.859 2.860 2.861 2.862 2.863 2.864 2.865 2.866 2.867 2.868 2.869 2.870 2.871 2.872 2.873 2.874 2.875 2.876 2.877 2.878 2.879 2.880 2.881 2.882 2.883 2.884 2.885 2.886 2.887 2.888 2.889 2.890 2.891 2.892 2.893 2.894 2.895 2.896 2.897 2.898 2.899 2.900 2.901 2.902 2.903 2.904 2.905 2.906 2.907 2.908 2.909 2.910 2.911 2.912 2.913 2.914 2.915 2.916 2.917 2.918 2.919 2.920 2.921 2.922 2.923 2.924 2.925 2.926 2.927 2.928 2.929 2.930 2.931 2.932 2.933 2.934 2.935 2.936 2.937 2.938 2.939 2.940 2.941 2.942 2.943 2.944 2.945 2.946 2.947 2.948 2.949 2.950 2.951 2.952 2.953 2.954 2.955 2.956 2.957 2.958 2.959 2.960 2.961 2.962 2.963 2.964 2.965 2.966 2.967 2.968 2.969 2.970 2.971 2.972 2.973 2.974 2.975 2.976 2.977 2.978 2.979 2.980 2.981 2.982 2.983 2.984 2.985 2.986 2.987 2.988 2.989 2.990 2.991 2.992 2.993 2.994 2.995 2.996 2.997 2.998 2.999 3.000]

#define VANILLA_AO_TORCH  1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.965 0.967 0.968 0.97 0.98 0.99 1.00]
#define VANILLA_AO_SKY  1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.965 0.967 0.968 0.97 0.98 0.99 1.00]

#define REDUCE_GI_LEAKS 0 //[0 1]  //don't use

#define FIX_BLOCKLIGHT_GHOSTS 1 //[0 1] 

#define SOLAR_GI_SHADOWMAP_SAMPLES 16 //[1 2 3 4 8 16] 

#define GI_FADE 0.900 //[0.000 0.001 0.002 0.003 0.004 0.005 0.006 0.007 0.008 0.009 0.010 0.011 0.012 0.013 0.014 0.015 0.016 0.017 0.018 0.019 0.020 0.021 0.022 0.023 0.024 0.025 0.026 0.027 0.028 0.029 0.030 0.031 0.032 0.033 0.034 0.035 0.036 0.037 0.038 0.039 0.040 0.041 0.042 0.043 0.044 0.045 0.046 0.047 0.048 0.049 0.050 0.051 0.052 0.053 0.054 0.055 0.056 0.057 0.058 0.059 0.060 0.061 0.062 0.063 0.064 0.065 0.066 0.067 0.068 0.069 0.070 0.071 0.072 0.073 0.074 0.075 0.076 0.077 0.078 0.079 0.080 0.081 0.082 0.083 0.084 0.085 0.086 0.087 0.088 0.089 0.090 0.091 0.092 0.093 0.094 0.095 0.096 0.097 0.098 0.099 0.100 0.101 0.102 0.103 0.104 0.105 0.106 0.107 0.108 0.109 0.110 0.111 0.112 0.113 0.114 0.115 0.116 0.117 0.118 0.119 0.120 0.121 0.122 0.123 0.124 0.125 0.126 0.127 0.128 0.129 0.130 0.131 0.132 0.133 0.134 0.135 0.136 0.137 0.138 0.139 0.140 0.141 0.142 0.143 0.144 0.145 0.146 0.147 0.148 0.149 0.150 0.151 0.152 0.153 0.154 0.155 0.156 0.157 0.158 0.159 0.160 0.161 0.162 0.163 0.164 0.165 0.166 0.167 0.168 0.169 0.170 0.171 0.172 0.173 0.174 0.175 0.176 0.177 0.178 0.179 0.180 0.181 0.182 0.183 0.184 0.185 0.186 0.187 0.188 0.189 0.190 0.191 0.192 0.193 0.194 0.195 0.196 0.197 0.198 0.199 0.200 0.201 0.202 0.203 0.204 0.205 0.206 0.207 0.208 0.209 0.210 0.211 0.212 0.213 0.214 0.215 0.216 0.217 0.218 0.219 0.220 0.221 0.222 0.223 0.224 0.225 0.226 0.227 0.228 0.229 0.230 0.231 0.232 0.233 0.234 0.235 0.236 0.237 0.238 0.239 0.240 0.241 0.242 0.243 0.244 0.245 0.246 0.247 0.248 0.249 0.250 0.251 0.252 0.253 0.254 0.255 0.256 0.257 0.258 0.259 0.260 0.261 0.262 0.263 0.264 0.265 0.266 0.267 0.268 0.269 0.270 0.271 0.272 0.273 0.274 0.275 0.276 0.277 0.278 0.279 0.280 0.281 0.282 0.283 0.284 0.285 0.286 0.287 0.288 0.289 0.290 0.291 0.292 0.293 0.294 0.295 0.296 0.297 0.298 0.299 0.300 0.301 0.302 0.303 0.304 0.305 0.306 0.307 0.308 0.309 0.310 0.311 0.312 0.313 0.314 0.315 0.316 0.317 0.318 0.319 0.320 0.321 0.322 0.323 0.324 0.325 0.326 0.327 0.328 0.329 0.330 0.331 0.332 0.333 0.334 0.335 0.336 0.337 0.338 0.339 0.340 0.341 0.342 0.343 0.344 0.345 0.346 0.347 0.348 0.349 0.350 0.351 0.352 0.353 0.354 0.355 0.356 0.357 0.358 0.359 0.360 0.361 0.362 0.363 0.364 0.365 0.366 0.367 0.368 0.369 0.370 0.371 0.372 0.373 0.374 0.375 0.376 0.377 0.378 0.379 0.380 0.381 0.382 0.383 0.384 0.385 0.386 0.387 0.388 0.389 0.390 0.391 0.392 0.393 0.394 0.395 0.396 0.397 0.398 0.399 0.400 0.401 0.402 0.403 0.404 0.405 0.406 0.407 0.408 0.409 0.410 0.411 0.412 0.413 0.414 0.415 0.416 0.417 0.418 0.419 0.420 0.421 0.422 0.423 0.424 0.425 0.426 0.427 0.428 0.429 0.430 0.431 0.432 0.433 0.434 0.435 0.436 0.437 0.438 0.439 0.440 0.441 0.442 0.443 0.444 0.445 0.446 0.447 0.448 0.449 0.450 0.451 0.452 0.453 0.454 0.455 0.456 0.457 0.458 0.459 0.460 0.461 0.462 0.463 0.464 0.465 0.466 0.467 0.468 0.469 0.470 0.471 0.472 0.473 0.474 0.475 0.476 0.477 0.478 0.479 0.480 0.481 0.482 0.483 0.484 0.485 0.486 0.487 0.488 0.489 0.490 0.491 0.492 0.493 0.494 0.495 0.496 0.497 0.498 0.499 0.500 0.501 0.502 0.503 0.504 0.505 0.506 0.507 0.508 0.509 0.510 0.511 0.512 0.513 0.514 0.515 0.516 0.517 0.518 0.519 0.520 0.521 0.522 0.523 0.524 0.525 0.526 0.527 0.528 0.529 0.530 0.531 0.532 0.533 0.534 0.535 0.536 0.537 0.538 0.539 0.540 0.541 0.542 0.543 0.544 0.545 0.546 0.547 0.548 0.549 0.550 0.551 0.552 0.553 0.554 0.555 0.556 0.557 0.558 0.559 0.560 0.561 0.562 0.563 0.564 0.565 0.566 0.567 0.568 0.569 0.570 0.571 0.572 0.573 0.574 0.575 0.576 0.577 0.578 0.579 0.580 0.581 0.582 0.583 0.584 0.585 0.586 0.587 0.588 0.589 0.590 0.591 0.592 0.593 0.594 0.595 0.596 0.597 0.598 0.599 0.600 0.601 0.602 0.603 0.604 0.605 0.606 0.607 0.608 0.609 0.610 0.611 0.612 0.613 0.614 0.615 0.616 0.617 0.618 0.619 0.620 0.621 0.622 0.623 0.624 0.625 0.626 0.627 0.628 0.629 0.630 0.631 0.632 0.633 0.634 0.635 0.636 0.637 0.638 0.639 0.640 0.641 0.642 0.643 0.644 0.645 0.646 0.647 0.648 0.649 0.650 0.651 0.652 0.653 0.654 0.655 0.656 0.657 0.658 0.659 0.660 0.661 0.662 0.663 0.664 0.665 0.666 0.667 0.668 0.669 0.670 0.671 0.672 0.673 0.674 0.675 0.676 0.677 0.678 0.679 0.680 0.681 0.682 0.683 0.684 0.685 0.686 0.687 0.688 0.689 0.690 0.691 0.692 0.693 0.694 0.695 0.696 0.697 0.698 0.699 0.700 0.701 0.702 0.703 0.704 0.705 0.706 0.707 0.708 0.709 0.710 0.711 0.712 0.713 0.714 0.715 0.716 0.717 0.718 0.719 0.720 0.721 0.722 0.723 0.724 0.725 0.726 0.727 0.728 0.729 0.730 0.731 0.732 0.733 0.734 0.735 0.736 0.737 0.738 0.739 0.740 0.741 0.742 0.743 0.744 0.745 0.746 0.747 0.748 0.749 0.750 0.751 0.752 0.753 0.754 0.755 0.756 0.757 0.758 0.759 0.760 0.761 0.762 0.763 0.764 0.765 0.766 0.767 0.768 0.769 0.770 0.771 0.772 0.773 0.774 0.775 0.776 0.777 0.778 0.779 0.780 0.781 0.782 0.783 0.784 0.785 0.786 0.787 0.788 0.789 0.790 0.791 0.792 0.793 0.794 0.795 0.796 0.797 0.798 0.799 0.800 0.801 0.802 0.803 0.804 0.805 0.806 0.807 0.808 0.809 0.810 0.811 0.812 0.813 0.814 0.815 0.816 0.817 0.818 0.819 0.820 0.821 0.822 0.823 0.824 0.825 0.826 0.827 0.828 0.829 0.830 0.831 0.832 0.833 0.834 0.835 0.836 0.837 0.838 0.839 0.840 0.841 0.842 0.843 0.844 0.845 0.846 0.847 0.848 0.849 0.850 0.851 0.852 0.853 0.854 0.855 0.856 0.857 0.858 0.859 0.860 0.861 0.862 0.863 0.864 0.865 0.866 0.867 0.868 0.869 0.870 0.871 0.872 0.873 0.874 0.875 0.876 0.877 0.878 0.879 0.880 0.881 0.882 0.883 0.884 0.885 0.886 0.887 0.888 0.889 0.890 0.891 0.892 0.893 0.894 0.895 0.896 0.897 0.898 0.899 0.900 0.901 0.902 0.903 0.904 0.905 0.906 0.907 0.908 0.909 0.910 0.911 0.912 0.913 0.914 0.915 0.916 0.917 0.918 0.919 0.920 0.921 0.922 0.923 0.924 0.925 0.926 0.927 0.928 0.929 0.930 0.931 0.932 0.933 0.934 0.935 0.936 0.937 0.938 0.939 0.940 0.941 0.942 0.943 0.944 0.945 0.946 0.947 0.948 0.949 0.950 0.951 0.952 0.953 0.954 0.955 0.956 0.957 0.958 0.959 0.960 0.961 0.962 0.963 0.964 0.965 0.966 0.967 0.968 0.969 0.970 0.971 0.972 0.973 0.974 0.975 0.976 0.977 0.978 0.979 0.980]

#define VOXY_LIGHTING_DIRECTIONALITY  0.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.965 0.967 0.968 0.97 0.98 0.99 1.00]
   
#define VOXY_LIGHTING_ANGLE_X -0.5 //[-1.0 -0.99 -0.98 -0.97 -0.96 -0.95 -0.94 -0.93 -0.92 -0.91 -0.9 -0.89 -0.88 -0.87 -0.86 -0.85 -0.84 -0.83 -0.82 -0.81 -0.8 -0.79 -0.78 -0.77 -0.76 -0.75 -0.74 -0.73 -0.72 -0.71 -0.7 -0.69 -0.68 -0.67 -0.66 -0.65 -0.64 -0.63 -0.62 -0.61 -0.6 -0.59 -0.58 -0.57 -0.56 -0.55 -0.54 -0.53 -0.52 -0.51 -0.5 -0.49 -0.48 -0.47 -0.46 -0.45 -0.44 -0.43 -0.42 -0.41 -0.4 -0.39 -0.38 -0.37 -0.36 -0.35 -0.34 -0.33 -0.32 -0.31 -0.3 -0.29 -0.28 -0.27 -0.26 -0.25 -0.24 -0.23 -0.22 -0.21 -0.2 -0.19 -0.18 -0.17 -0.16 -0.15 -0.14 -0.13 -0.12 -0.11 -0.1 -0.09 -0.08 -0.07 -0.06 -0.05 -0.04 -0.03 -0.02 -0.01 0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define VOXY_LIGHTING_ANGLE_Y 1.0 //[-1.0 -0.99 -0.98 -0.97 -0.96 -0.95 -0.94 -0.93 -0.92 -0.91 -0.9 -0.89 -0.88 -0.87 -0.86 -0.85 -0.84 -0.83 -0.82 -0.81 -0.8 -0.79 -0.78 -0.77 -0.76 -0.75 -0.74 -0.73 -0.72 -0.71 -0.7 -0.69 -0.68 -0.67 -0.66 -0.65 -0.64 -0.63 -0.62 -0.61 -0.6 -0.59 -0.58 -0.57 -0.56 -0.55 -0.54 -0.53 -0.52 -0.51 -0.5 -0.49 -0.48 -0.47 -0.46 -0.45 -0.44 -0.43 -0.42 -0.41 -0.4 -0.39 -0.38 -0.37 -0.36 -0.35 -0.34 -0.33 -0.32 -0.31 -0.3 -0.29 -0.28 -0.27 -0.26 -0.25 -0.24 -0.23 -0.22 -0.21 -0.2 -0.19 -0.18 -0.17 -0.16 -0.15 -0.14 -0.13 -0.12 -0.11 -0.1 -0.09 -0.08 -0.07 -0.06 -0.05 -0.04 -0.03 -0.02 -0.01 0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define VOXY_LIGHTING_ANGLE_Z 0.0 //[-1.0 -0.99 -0.98 -0.97 -0.96 -0.95 -0.94 -0.93 -0.92 -0.91 -0.9 -0.89 -0.88 -0.87 -0.86 -0.85 -0.84 -0.83 -0.82 -0.81 -0.8 -0.79 -0.78 -0.77 -0.76 -0.75 -0.74 -0.73 -0.72 -0.71 -0.7 -0.69 -0.68 -0.67 -0.66 -0.65 -0.64 -0.63 -0.62 -0.61 -0.6 -0.59 -0.58 -0.57 -0.56 -0.55 -0.54 -0.53 -0.52 -0.51 -0.5 -0.49 -0.48 -0.47 -0.46 -0.45 -0.44 -0.43 -0.42 -0.41 -0.4 -0.39 -0.38 -0.37 -0.36 -0.35 -0.34 -0.33 -0.32 -0.31 -0.3 -0.29 -0.28 -0.27 -0.26 -0.25 -0.24 -0.23 -0.22 -0.21 -0.2 -0.19 -0.18 -0.17 -0.16 -0.15 -0.14 -0.13 -0.12 -0.11 -0.1 -0.09 -0.08 -0.07 -0.06 -0.05 -0.04 -0.03 -0.02 -0.01 0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]

#define PITCH_BLACK_CAVES 1 //[0 1] 

#define CHUNK_FADE 0 //[0 1] 



 //Macro Settings
#define USE_MACRO_TEXTURES 0 //[0 2]
#define MACRO_SMOOTHNESS_STRENGTH 0.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define MACRO_NORMALS_STRENGTH 0.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50]
#define MACRO_TILING_SCALE 0.33 //[0.1 0.2 0.25 0.33 0.4 0.5 0.75 1.0 1.25 1.25 2.0]
#define MACRO_TILING_SCALE_MOBS 0.33 //[0.1 0.2 0.25 0.33 0.4 0.5 0.75 1.0 1.25 1.25 2.0]
#define MACRO_RENDER_DISTANCE 6.0 //[1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 15.0 20.0 30.0]
#define MOB_WORLD_SCALING 1 //[0 1]
#define PRESERVE_NORMALSVS_MACRO 1 //[0 1]
#define MACRO_FADE_PERCENT 1.00 //[0.001 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define MACRO_AFFECTS_FILTERIING 0 //[0 1]
#define MACRO_AFFECTS_FILTERIING_MOBS 0 //[0 1]
#define MACRO_FILTERIING_STR 1.00 //[0.001 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.2 2.5 2.7 3.0 4.0 5.0 6.0 7.0 80 9.0 10.0 100.0 1000.0]


#define REDSTONE_DUST_GLOWS 0 //[0 1]

#define ADJUST_SPECULAR 0 //[0 1]
#define ADJUSTED_SPECULAR 1.0 //[1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.3 2.5 2.7 3.0 4.0 5.0 6.0 7.0 10.0 20.0 30.0]
#define MINIMUM_SMOOTHNESS 0.10 //[0.001 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define MINIMIM_F0 0.30 //[0.001 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]




//2026-4

	#define BLOCK_LIGHTS_CATCH_HELD_LIGHT 1 //[0 1]
	#define POM_TOGGLE 1 //[0 1] //internal to ctmpomfix file only
	#define PER_BLOCK_EMMISSIVE 0 //[0 1]  



//2025-5

    #define COPPER_LANTERNS 0 //[0 1 2]
    #define COPPER_BULBS 0 //[0 1 2 3]

    #define SNOW_VISIBILITY 1.01 //[1.01 1.25 1.5 1.75 2.0 2.5 3.0]
	
	#define COLORWHEEL_OIT 0 //[0 1]



//###################### ALSO IN CTMPOMFIX
#define TEXTURE_FILTERING_CPF 0 //[0 1 2 3 4 5 6 7 8 9] //Filter Textures so they aren't pixelated when close up, performance may vary by mode, ALPHA ones are debug use or may not work well . 0 - none, 1-bilinear, 2-bilinear with adaptive contrast, 3-hq like, 4-hq/blended ALPHA, 5-crisp, 6-rounded crisp ALPHA, 7-round blend ALPHA
