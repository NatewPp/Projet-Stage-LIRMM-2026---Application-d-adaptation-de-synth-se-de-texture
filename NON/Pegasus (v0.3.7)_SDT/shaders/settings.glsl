// © Copyright 2023-2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 

//last edited: 2024-6


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
 #define METAL_REFLECTIVE 0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //increase metal reflectivity
 
 #define USE_MINECRAFT_TORCH_LIGHTING 0.2 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 3.0 4.0 5.0] //Minecraft ambient light from torches and light blocks . is divided by number of light bounces to not overpower
 
 #if BOUNCE_MORE > 1
	#define TORCH_DIV_BOUNCES USE_MINECRAFT_TORCH_LIGHTING / BOUNCE_MORE
 #else
	#define TORCH_DIV_BOUNCES USE_MINECRAFT_TORCH_LIGHTING 
 #endif
 
 #define RAY_BIAS 0.0001 //[0.0001 0.001 0.01 0.0]
 #define NOISE_AMOUNT_IN_RAYS 0 //[0 1 2 3 4 5 6 7 8 9 10]
 
 #define SCREEN_TANGENT 1 //[0 1] //buggy test, don't use!
 
  #define GEN_NORMAL_MAP 0 //[0 1 2 3] //generate a normal map for blank textures to play better with the light simulation . probably won't work in texture filtering range

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

#define SHADOW_DISTORT_ENABLED 1//[0 1]//Toggles shadow map distortion
#define SHADOW_DISTORT_FACTOR 0.08 //Distortion factor for the shadow map. Has no effect when shadow distortion is disabled. [0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SHADOW_BIAS 1.00 //Increase this if you get shadow acne. Decrease this if you get peter panning. [0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.60 0.70 0.80 0.90 1.00 1.50 2.00 2.50 3.00 3.50 4.00 4.50 5.00 6.00 7.00 8.00 9.00 10.00]
//#define NORMAL_BIAS //Offsets the shadow sample position by the surface normal instead of towards the sun
//#define EXCLUDE_FOLIAGE //If true, foliage will not cast shadows.
#define SHADOW_BRIGHTNESS 0.75 //Light levels are multiplied by this number when the surface is in shadows [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

const int shadowMapResolution = 2048; //Resolution of the shadow map. Higher numbers mean more accurate shadows. [128 256 512 1024 2048 4096 8192]


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
#define BACKGROUND_RESOLUTIION_DIVIDER 3 //[1 2 3 4 5 8 10]// Lower resolution clouds and background for massive fps boost
#define CLOUD_SPECULAR 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 5.0 10.0 100.0]
#define CLOUD_OPACITY 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 3.0 4.0 5.0 10.0 100.0]


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
#define WATER_F0 0.0  //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

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
#define VANILLA_WATER_COLOR 0.0  //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]


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
	
#define POM 1 //[0 1]

#define RAIN_DROPS 2 //[0 1 2]

#define ONLY_DRAW_DH 0 //[0 1]
#define BUGGY_DH_SHADING 1 //[0 1 2]
#define DISABLE_SKY_RAY_TRACE 1 //[0 1]
#define NO_DH_SHADOWS 1 //[0 1]
#define DH_WETNESS 0.3 //wETNESS OF dISTANT bLOCKS [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define VANILLA_CELESTIALS 0 //Vanilla or resource pack sun, moon, and stars will be on if set to 1 //[0 1] 

#define SUN_COLOR_R 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SUN_COLOR_G 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SUN_COLOR_B 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

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

#define REFRACTION_DISTANCE 0.1 //[0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14]

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

#define SATURATION 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 3.0 4.0 5.0 10.0]
#define CONTRAST 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 3.0 4.0 5.0 10.0]
#define BRIGHTNESS 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 3.0 4.0 5.0 10.0]
#define EXPOSURE_PRE 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 3.0 4.0 5.0 10.0]
#define BTIGHTNESS_CONTRAST 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 3.0 4.0 5.0 10.0]
#define BTIGHTNESS_CONTRAST_CENTER 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
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


#define SHADOWS 6 //[0 1 2 3 4 5 6]
#define UPSCALE_TERRAIN 1 //[0 1]
#define UPSCALE_ENTITIES 1 //[0 1]
#define UPSCALE_HAND_HELD 0 //[0 1]
#define UPSCALE_PARTICLES 0 //[0 1]

#define FOG 1 //[0 1]
#define FOG_START 10.0//[10.0 20.0 100.0]
#define FOG_END 200.0//[20.0 100.0 200.0 300.0 400.0 500.0 700.0 1000.0 2000.0 5000.0 10000.0]
#define FOG_MAX 0.5 //[0.0 0.25 0.5 0.75 1.0]
#define BORDER_FOG_START 0.75 //[0.0 0.25 0.5 0.75 0.8 0.9]

#define TORCH_FALLOFF 1.0 //[1.0 2.0 3.0 4.0 5.0]
#define SKY_LIGHT_FALLOFF 1.0 //[1.0 2.0 3.0 4.0 5.0]
#define SKY_LIGHT_BRIGHTNESS 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TORCH_BRIGHTNESS 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.7 2.0 2.5 3.0]

#define CUSTOM_TORCH_COLOR 2 //[0 1 2]
#define TORCH_HI_R  1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TORCH_LOW_R  1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TORCH_HI_G  0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TORCH_LOW_G  0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TORCH_HI_B  0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define TORCH_LOW_B  0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define SUN_BRIGHTNESS 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 3.0]
#define MOON_BRIGHTNESS 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define MINIMUM_LIGHT_LEVEL 0.0 //[0.0 0.001 0.01 0.02 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define EXTRA_DARK_NIGHT 5 //[0 1 2 3 4 5 6 7 8 9 10]
#define DIRECTIONAL_LIGHTING 1 //[0 1]
#define DONT_BLOW_OUT_WHITES 2 //[0 1 2]

#define BACK_LIT_GRASS 2 //[0 1 2 3 4 5 6 7 8 9 10]

#define No_PBR_Textures 0
#define Only_Normal_Maps 1
#define LabPBR_Textures 2

#define PBR LabPBR_Textures //[No_PBR_Textures Only_Normal_Maps LabPBR_Textures]

#define NON_DIRECTIONAL_AMBIENT_SKY_LIGHT  0.8 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define AMBIENT_OCCLUSSION_TEXTURES  1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SHOW_MOB_DAMAGE 1 //[0 1]
#define SUN_WIDTH 0.0025 //[0.001 0.002 0.0025 0.003 0.004 0.005 0.006 0.007 0.008 0.009 0.001 0.002]
#define METAL_SMOOTHER 0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SKY_COLOR_ALTERNATE 0 //[0 1]
#define CUSTOM_SUN_COLOR 0 //[0 1]

#define MOON_COLOR_R 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define MOON_COLOR_G 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define MOON_COLOR_B 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

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
#define SHADOW_NOISE_STR 1.0 //[0.0 0.001 0.01 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FLIP_SHADOW_SPIRAL_RANDOMLY 0 //[0 1 2]
#define SHADOW_WEIGHT_EXPONENT 1.0//[1.0 2.0 3.0 4.0 5.0 7.0 19.0]

#define SHADOW_SUB_PIXEL_SEED_RES 111.0 //[1.0 8.0 10.0 16.0 32.0 64.0 128.0 256.0 512.0 1024.0]
#define SHADOW_EXTRA_SOFTNESS 1.0//[0.0 0.25 0.5 0.75 1.0 2.0 3.0 4.0 5.0]
#define PRENUMBRA_INFO 0 //[0 1]

#define SSS 1 //[0 1 2]

#define PUDDLE_DEPTH 0.85 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.85 0.9 1.0]


#define HAND_HELD_TORCH 1 //[0 1]
#define HAND_HELD_TORCH_RANGE 10.0 //[5.0 10.0 15.0 20.0 30.0]
#define TORCH_LIGHT_3D 2 //[0 1 2]
#define TORCH_HORIZONTAL_OFFSET 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.3 1.4 1.5 1.7 2.0] 
#define TORCH_V_OFFSET 0.2 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.3 1.4 1.5 1.7 2.0]
#define TORCH_Z_OFFSET 0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.3 1.4 1.5 1.7 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0]

#define GRASS_SHADOWS 1 //[0 1]
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
#define FOG_HIDES_DH_BORDERS 0.7 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

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

#define DH_TEXTURE 1 //[0 1]
#define DH_NOISE_FRACTAL_STEPS 2 //[1 2 3 4 5]
#define DH_FANCY_NOISE 1 //[0 1]
#define DH_TEXTURE_STR 0.1 //[0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.1 0.15 0.17 0.2]
#define LONG_SUNSET_SHADOWS 1 //[0 1]

#if DH_SHADOWS == 0
	const float shadowDistanceRenderMult = 1.0;
#else
	const float shadowDistanceRenderMult = -1.0;
#endif
const float shadowDistance = 256.0; //[20.0 50.0 75.0 100.0 120.0 150.0 175.0 200.0 256.0 512.0 1000.0 2000.0 3000.0 5000.0 10000.0 -1.0]
#if DH_SHADOWS == 1 && LONG_SUNSET_SHADOWS == 1
	
	const float shadowNearPlane= -1. ;//[20.0 50.0 100.0 256.0 512.0 1000.0 2000.0 3000.0 5000.0 10000.0 -1.0]
	const float shadowFarPlane= -1. ; //[20.0 50.0 100.0 156.0 256.0 512.0 1000.0 2000.0 3000.0 5000.0 10000.0 -1.0]
	
#endif

#define DUAL_DISTORT 0 //[0 1]


#define DEBUG_SHADOWS 0 //[0 1]

#define GODRAYS 1 //[0 1]
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

#define DH_FLYING_FIX_CIRCLE 0 //[0 1]
#define DH_FLYING_FIX_CIRCLE_ONLY_IN_AIR 1 //[0 1]
#define DH_FLYING_FIX_CIRCLE_SPEED 3.0 //[0.01 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.5 1.7 2.0 2.2 2.5 2.7 3.0 5.0 7.0 10.0 15.0 20.0 30.0];
#define DEBUG_FIX_CIRCLE 0 //[0 1]

#define FORCE_CRISP_SHADOWS 0 //[0 1]
#define BRIGHTER_UNDERWATER 1 //[0 1]
#define FADE_SHADOWS 0 //[0 1]
#define SHADOW_FADE 0.3 //[0.1 0.2 0.3 0.4 0.5]

#define DEBUG_MODE 0 //[0 1 2 3]



#define POTATO_SHADOWS 0 //[0 1]





#define USE_PHYSICS_MOD_OCEAM 0 //[0 1] //forced!

#define OG_WAVES 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 
#define TIDAL_WAVES 1 //[0 1]
#define TIDE_STR 0.0 ////[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 
#define PMOD_SHALLOW_CHK 1 //[0 1 2] 

#define MIN_TIDE_DEPTH 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 						
#define NO_RAY_SCATTER_ON_WATER 0 //[0 1] 
#define CRASH_DISTANCE 14 //[0 1 2 3 4 5 6 7 8 9 0 11 12 13 14 15 16 7 18 19 20]


#define CRASH_WV_STR 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 		
#define SHIRE_FOAM_STR 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 		
#define RD3_COMPONENT_FOAM_STR 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 		

#define WAVE_RESOLUTION 0 //[0 16 32 64 128 256 512 1024]//0 is infinite	
#define DH_WATER_WORKAROUND 0 //[0 1]
#define FOAM_SMOOTHNESS 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 	
#define WATER_F0_METHOD 0 //[0 1]
#define FOAM_BRIGHTNESS 0.97 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0] 	
#define TILE_J_NOISE 1 //[0 1]
#define DEBUG_TIDES 0 //[0 1]
#define TIDE_STR2 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 	
	

#define TWARB3 0.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 	

#define FOAM_F0 0.1 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 	
#define TIDE_STR3 0.3 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 	
#define TIDE_STR4 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 	



#define SKY_ONLY_REFL 1 //[0 1]
#define DH_FOG_EXPONENT 111.0 //[55.0 75.0 111.0 150.0 222.0 333.0 555,0 1111.0]

#define WATER_COL_ABSORB 0 //[0 1 2]
#define BLOOM_PASSES 3 //[0 1 2 3]
#define WATER_VISIBILITY 30.0 //[10.0 15.0 20.0 30.0 40.0 50.0 60.0 70.0 80.0 90.0 100.0]
#define REFRACTIONS 1 //[0 1]

#define PEGASUS 1 //[0 1]
#define FORCE_OLD 0 //[0 1]

#define TWARB 0.4 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 	
#define WAVES_SPEED 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.7 2.0 2.1 3.0 4.0 5.0] 
#define OCEAN_SPEED 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.7 2.0 2.1 3.0 4.0 5.0] 
#define TWARB2 0.4 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 	

#define USE_PHYSICS_MOD_OCEAM 0 //[0 1] //forced!

#define SUN_SPARKLE 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.7 2.0 2.1 2.5 3.0 4.0] 


#define WATER_FRESNEL_CURVE 2.0 //[1.0 1.5 2.0 2.5 3.0 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 9.0 10.0 11.00 15.0 20.0]

#define VANILLA_SUNSETS 0 //[0 1]
#define AA_STRENGTH 0.5 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7] // 3 pixel wide blend
#define BLOOM_STRENGTH1 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] // 3 pixel wide blend
#define BLOOM_THRESHHOLD 0.5 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] 	
#define ANTI_ALIASING 0 //[0 1 2]
#define WATER_COLOR_ABSORB_DIST 30.0 //[10.0 20.0 30.0 40.0 50.0]
#define WATER_SCATTERS_LIGHT 0 //[0 1]

#define CLOUDS_O_FRACTAL_DEPTH 4 //[4 5 6 7]

	#define COLORED_SHADOWS 1 //[0 1] //0: Stained glass will cast ordinary shadows. 1: Stained glass will cast colored shadows.
	#define SHADOW_BRIGHTNESS 0.75 //Light levels are multiplied by this number when the surface is in shadows [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

#define CLOUDS 6 //[0 1 6 8 9 10]
#define CLOUD_PERMUTATION_SPEED  0.75 //[0.0 0.25 0.5 0.75 1.0 1.2 1.5 1.7 2.0]
#define CLOUD_LAYERS 3 //[1 2 3]

#define CLOUD_SAMPLES1 20.0 //[5.0 10.0 15.0 20.0 25.0 30.0 100.0]
#define CLOUD_LAYER_HEIGHT1 20.0 //[5.0 10.0 20.0 30.0 100.0]
#define CLOUD_SHADING_SAMPLES1 5.0 //[3.0 5.0 11.0]

#define CLOUD_SAMPLES2 5.0 //[5.0 10.0 15.0 20.0 25.0 30.0 100.0]
#define CLOUD_LAYER_HEIGHT2 20.0 //[5.0 10.0 20.0 30.0 100.0]
#define CLOUD_SHADING_SAMPLES2 3.0 //[3.0 5.0 11.0]

#define CLOUD_SAMPLES3 5.0 //[5.0 10.0 15.0 20.0 25.0 30.0 100.0]
#define CLOUD_LAYER_HEIGHT3 20.0 //[5.0 10.0 20.0 30.0 100.0]
#define CLOUD_SHADING_SAMPLES3 3.0 //[3.0 5.0 11.0]

#define CLOUD_SHADING 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.75 0.8 0.9 1.0] 

#define CLOUD_SPEED 0.75 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.75 0.8 0.9 1.0] 	
#define SUN_RAYS_OVER_SKY 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]  
#define BORDER_WIDTH 1 //[1 2 3 4 5 6 7 8 9 10]

#define BEACH_TIMING 0 //[0 1 2]

#define CLOUD_COLOR_ABSORD_RED 1.00 //[1.00 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.10 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.30 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.40 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.50 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.60 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.70 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.80 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.90 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.00 2.01 2.02 2.03 2.04 2.05 2.06 2.07 2.08 2.09 2.10 2.11 2.12 2.13 2.14 2.15 2.16 2.17 2.18 2.19 2.20 2.21 2.22 2.23 2.24 2.25 2.26 2.27 2.28 2.29 2.30 2.31 2.32 2.33 2.34 2.35 2.36 2.37 2.38 2.39 2.40 2.41 2.42 2.43 2.44 2.45 2.46 2.47 2.48 2.49 2.50 2.51 2.52 2.53 2.54 2.55 2.56 2.57 2.58 2.59 2.60 2.61 2.62 2.63 2.64 2.65 2.66 2.67 2.68 2.69 2.70 2.71 2.72 2.73 2.74 2.75 2.76 2.77 2.78 2.79 2.80 2.81 2.82 2.83 2.84 2.85 2.86 2.87 2.88 2.89 2.90 2.91 2.92 2.93 2.94 2.95 2.96 2.97 2.98 2.99 3.00 3.01 3.02 3.03 3.04 3.05 3.06 3.07 3.08 3.09 3.10 3.11 3.12 3.13 3.14 3.15 3.16 3.17 3.18 3.19 3.20 3.21 3.22 3.23 3.24 3.25 3.26 3.27 3.28 3.29 3.30 3.31 3.32 3.33 3.34 3.35 3.36 3.37 3.38 3.39 3.40 3.41 3.42 3.43 3.44 3.45 3.46 3.47 3.48 3.49 3.50 3.51 3.52 3.53 3.54 3.55 3.56 3.57 3.58 3.59 3.60 3.61 3.62 3.63 3.64 3.65 3.66 3.67 3.68 3.69 3.70 3.71 3.72 3.73 3.74 3.75 3.76 3.77 3.78 3.79 3.80 3.81 3.82 3.83 3.84 3.85 3.86 3.87 3.88 3.89 3.90 3.91 3.92 3.93 3.94 3.95 3.96 3.97 3.98 3.99 4.00 4.01 4.02 4.03 4.04 4.05 4.06 4.07 4.08 4.09 4.10 4.11 4.12 4.13 4.14 4.15 4.16 4.17 4.18 4.19 4.20 4.21 4.22 4.23 4.24 4.25 4.26 4.27 4.28 4.29 4.30 4.31 4.32 4.33 4.34 4.35 4.36 4.37 4.38 4.39 4.40 4.41 4.42 4.43 4.44 4.45 4.46 4.47 4.48 4.49 4.50 4.51 4.52 4.53 4.54 4.55 4.56 4.57 4.58 4.59 4.60 4.61 4.62 4.63 4.64 4.65 4.66 4.67 4.68 4.69 4.70 4.71 4.72 4.73 4.74 4.75 4.76 4.77 4.78 4.79 4.80 4.81 4.82 4.83 4.84 4.85 4.86 4.87 4.88 4.89 4.90 4.91 4.92 4.93 4.94 4.95 4.96 4.97 4.98 4.99 5.0]

#define CLOUD_COLOR_ABSORD_GREEN 1.10 //[1.00 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.10 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.30 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.40 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.50 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.60 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.70 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.80 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.90 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.00 2.01 2.02 2.03 2.04 2.05 2.06 2.07 2.08 2.09 2.10 2.11 2.12 2.13 2.14 2.15 2.16 2.17 2.18 2.19 2.20 2.21 2.22 2.23 2.24 2.25 2.26 2.27 2.28 2.29 2.30 2.31 2.32 2.33 2.34 2.35 2.36 2.37 2.38 2.39 2.40 2.41 2.42 2.43 2.44 2.45 2.46 2.47 2.48 2.49 2.50 2.51 2.52 2.53 2.54 2.55 2.56 2.57 2.58 2.59 2.60 2.61 2.62 2.63 2.64 2.65 2.66 2.67 2.68 2.69 2.70 2.71 2.72 2.73 2.74 2.75 2.76 2.77 2.78 2.79 2.80 2.81 2.82 2.83 2.84 2.85 2.86 2.87 2.88 2.89 2.90 2.91 2.92 2.93 2.94 2.95 2.96 2.97 2.98 2.99 3.00 3.01 3.02 3.03 3.04 3.05 3.06 3.07 3.08 3.09 3.10 3.11 3.12 3.13 3.14 3.15 3.16 3.17 3.18 3.19 3.20 3.21 3.22 3.23 3.24 3.25 3.26 3.27 3.28 3.29 3.30 3.31 3.32 3.33 3.34 3.35 3.36 3.37 3.38 3.39 3.40 3.41 3.42 3.43 3.44 3.45 3.46 3.47 3.48 3.49 3.50 3.51 3.52 3.53 3.54 3.55 3.56 3.57 3.58 3.59 3.60 3.61 3.62 3.63 3.64 3.65 3.66 3.67 3.68 3.69 3.70 3.71 3.72 3.73 3.74 3.75 3.76 3.77 3.78 3.79 3.80 3.81 3.82 3.83 3.84 3.85 3.86 3.87 3.88 3.89 3.90 3.91 3.92 3.93 3.94 3.95 3.96 3.97 3.98 3.99 4.00 4.01 4.02 4.03 4.04 4.05 4.06 4.07 4.08 4.09 4.10 4.11 4.12 4.13 4.14 4.15 4.16 4.17 4.18 4.19 4.20 4.21 4.22 4.23 4.24 4.25 4.26 4.27 4.28 4.29 4.30 4.31 4.32 4.33 4.34 4.35 4.36 4.37 4.38 4.39 4.40 4.41 4.42 4.43 4.44 4.45 4.46 4.47 4.48 4.49 4.50 4.51 4.52 4.53 4.54 4.55 4.56 4.57 4.58 4.59 4.60 4.61 4.62 4.63 4.64 4.65 4.66 4.67 4.68 4.69 4.70 4.71 4.72 4.73 4.74 4.75 4.76 4.77 4.78 4.79 4.80 4.81 4.82 4.83 4.84 4.85 4.86 4.87 4.88 4.89 4.90 4.91 4.92 4.93 4.94 4.95 4.96 4.97 4.98 4.99 5.0]

#define CLOUD_COLOR_ABSORD_BLUE 1.33 //[1.00 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.10 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.30 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.40 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.50 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.60 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.70 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.80 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.90 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.00 2.01 2.02 2.03 2.04 2.05 2.06 2.07 2.08 2.09 2.10 2.11 2.12 2.13 2.14 2.15 2.16 2.17 2.18 2.19 2.20 2.21 2.22 2.23 2.24 2.25 2.26 2.27 2.28 2.29 2.30 2.31 2.32 2.33 2.34 2.35 2.36 2.37 2.38 2.39 2.40 2.41 2.42 2.43 2.44 2.45 2.46 2.47 2.48 2.49 2.50 2.51 2.52 2.53 2.54 2.55 2.56 2.57 2.58 2.59 2.60 2.61 2.62 2.63 2.64 2.65 2.66 2.67 2.68 2.69 2.70 2.71 2.72 2.73 2.74 2.75 2.76 2.77 2.78 2.79 2.80 2.81 2.82 2.83 2.84 2.85 2.86 2.87 2.88 2.89 2.90 2.91 2.92 2.93 2.94 2.95 2.96 2.97 2.98 2.99 3.00 3.01 3.02 3.03 3.04 3.05 3.06 3.07 3.08 3.09 3.10 3.11 3.12 3.13 3.14 3.15 3.16 3.17 3.18 3.19 3.20 3.21 3.22 3.23 3.24 3.25 3.26 3.27 3.28 3.29 3.30 3.31 3.32 3.33 3.34 3.35 3.36 3.37 3.38 3.39 3.40 3.41 3.42 3.43 3.44 3.45 3.46 3.47 3.48 3.49 3.50 3.51 3.52 3.53 3.54 3.55 3.56 3.57 3.58 3.59 3.60 3.61 3.62 3.63 3.64 3.65 3.66 3.67 3.68 3.69 3.70 3.71 3.72 3.73 3.74 3.75 3.76 3.77 3.78 3.79 3.80 3.81 3.82 3.83 3.84 3.85 3.86 3.87 3.88 3.89 3.90 3.91 3.92 3.93 3.94 3.95 3.96 3.97 3.98 3.99 4.00 4.01 4.02 4.03 4.04 4.05 4.06 4.07 4.08 4.09 4.10 4.11 4.12 4.13 4.14 4.15 4.16 4.17 4.18 4.19 4.20 4.21 4.22 4.23 4.24 4.25 4.26 4.27 4.28 4.29 4.30 4.31 4.32 4.33 4.34 4.35 4.36 4.37 4.38 4.39 4.40 4.41 4.42 4.43 4.44 4.45 4.46 4.47 4.48 4.49 4.50 4.51 4.52 4.53 4.54 4.55 4.56 4.57 4.58 4.59 4.60 4.61 4.62 4.63 4.64 4.65 4.66 4.67 4.68 4.69 4.70 4.71 4.72 4.73 4.74 4.75 4.76 4.77 4.78 4.79 4.80 4.81 4.82 4.83 4.84 4.85 4.86 4.87 4.88 4.89 4.90 4.91 4.92 4.93 4.94 4.95 4.96 4.97 4.98 4.99 5.0]

#define UNDERWATER_CAUSTICS 2 //[0 1 2]

#define REFLECTION_DETAIL 5 //[0 1 3 4 5]
#define WAVE_SHAPE  1 //[0 1 2]
#define BETTER_CLOUDS_MOD 0 //[0 1 2]

#define SSPTGI 0 //[0 1 2]

#define REMOVE_REFLECTION_JITTER 1 //[0 1]
#define CALM_AND_WIND 1 //[0 1]
#define ONION 0 //[0 1]
#define OFF_SCREEN_REFLECTION_QUALITY 1 //[0 1 2 3 4 5 6 7 8 9 10] 
#define HAZY_DAYS 0 //[0 1]

//Screen Space Reflections
#define REFLECTION_THRESHHOLD 0.01 //[0.0 0.01 0.25 0.5 0.75]
#define FRESNEL_EXPONENT 6.0 //[1.0 3.0 6.0 7.0 8.0 10.0]
#define SSR_STEPS 10 //[5 10 20 30]
#define SSR_REFINEMENT_STEPS 0 //[0 1 2 3 4 5 6 7 8 9 10]

#define CLOUD_SHADOWS 0 //[0 1]
#define PUDDLES 1 //[0 1] 

 #define ROUGH_FRESNEL 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
  #define FRESNEL 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
  
  #define DYNAMIC_CLOUD_COLORATION 1 //[0 1] 
  
 #define WATER_FOG 0.05 //[0.0 0.01 0.02 0.05]
  
  #define TONEMAPPING2_STRENGTH 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
  
   #define ONLY_REFRACT_X 1 //[0 1] 
  
  #define OFFFSCREEN_REFLECTIONS_ATYLE 0 //[0 1] 
  
  #define SUNSET_EXPONENT 3.0 //[3.0 4.0 4.1 4.2 4.3 4.4 4.5 5.0]
  
     #define UNDERWATER_GODRAYS 0 //[0 1] 
  
    
     #define VANILLA_CLOUDS 0 //[2 0 1] 
  
  
  
//Voxelizing
#define WHERE_TO_VOXELIZE 2 //[1 2]
#define FLOODFILL_LIGHTING 7 //[0 1 2 3 4 7]
//get voxel map position
#define VOXEL_AREA 128 //[32 64 128 256]
#define VOXEL_RADIUS (VOXEL_AREA/2)
#define VOXEL_AREA_X_2 (VOXEL_AREA * 2)

//get which voxel this is in 2 ways
#define VOXEL_POSITION_RECONSTRUCTION_METHOD 1 //[1 2]
#define FLICKERING_TORCHES 2 //[0 1 2 3]
#define LIGHT_FALLOFF 2 //[1 2] 
#define LIGHT_FALLOFF_RATE 0.89 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98]
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

#define LIGHT_UPDATE_SPEED 3 //[1 3 5]
#define FADE_LIGHT_UPDATES 1 //[0 1]
#define FADE_LIGHT_UPDATES_AMOUNT 0.80 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90]

#define PBR_LPV_EMISSION 0 //[0 1]

#define PARTICLES_LPV 0 //[0 1]

#define LPV_PARTICLES_BY_LM 1 //[0 1]

#define LIGHT_VIIBRANCE 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define GLOWING_CONCRETE 0 //[0 1]

#define GLOWING_ROCKETS 1 //[0 1]



#define ADJUST_SATURATION 0 //[0 1]
#define LIGHT_COLOR_SATURATION 1.0 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
 
#define PBR_EMMISIVENESS_IN_VOXELS_TERRAIN 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

 
#define EPBR_EMMISIVENESS_IN_VOXELS_ENTITY 0.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define VOXELIZE_GRASS 1 //[0 1]//10000

#define VANILLA_lIGHTING 1 //[0 1]

#define TONEMAPPING_BRIGHTNESS 0.90 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define TONEMAPPING_RANGE 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define TONEMAPPING2_STRENGTH 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]

#define NAMETAG_OPACITY 0.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]


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

#define SOUL_FIRE_DARK_R 0.50 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SOUL_FIRE_DARK_G 0.70 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SOUL_FIRE_DARK_B 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
 
//RED_STONE_R RED_STONE_G RED_STONE_B vec3(1.,0.1,.04)
#define RED_STONE_R 1.00 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define RED_STONE_G 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define RED_STONE_B 0.04 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
 
 #define COLORED_LIGHT_SPEC 1//[0 1]
 
 #define DBLX_MULT 2.0 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.25 1.5 1.75 2.0 3.0 5.0]
 
 #define CRYSTAL_SSS 0 //[0 1]
 
  #define VANILLA_AO_EXPONENT 3.0 //[1.0 1.1 1.2 1.3 1.5 1.7 2.0 3.0 4.0 5.0]
  
  #define CONSTRAIN_TO_VANILLA_LIGHTMAP_DISTANCE 0 //[0 1] 
  
  
   #define METAL_AMBIENT 0.20 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
 
 #define METAL_AMBIENT_LIT 1 //[0 1]

 #define DIFFFUSE_VX_BEHAVIOR 1 //[1 2]
  #define SPECULAR_VX_BEHAVIOR 1 //[1 2 3]
 
  
 #define NETHER_RED_AMBIENT_LIGHT 1 //[0 1]


#define GLOW_FRAME_R 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define GLOW_FRAME_G 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define GLOW_FRAME_B 0.10 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]


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






const float entityShadowDistanceMul = 1.0; //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]


#define PIXEL_LOCKED_SHADOW_RES 0 //[0 8 16 32 64 128 256]

#define TINT_METALS 1 //[0 1]


//V0.3.6

#define VX_FIRECTIONALITY 0.90 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.25 1.5 1.75 2.0 3.0]

#define VX_FIRECTIONALITY2 0.90 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00 1.25 1.5 1.75 2.0 3.0]

#if POM > 0 && PBR < 1
	#define PBR 1
#endif


#include "/version_check.glsl"


//v0.3.7

#define AO 4 //[0 1 2 3 4]
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

#define TONEMAPPING 0 //[0 1]

