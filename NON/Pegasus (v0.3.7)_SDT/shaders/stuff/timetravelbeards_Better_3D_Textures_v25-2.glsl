// © Copyright 2023-2025 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 



//NOTE: IF YOU WANT A STANDARDIZED VERSION OF MY PATCHES THAT CAN BE INCLUDED IN YOUR SHADER IF YOU GET MY PERMISSION, COME TO MY DISCORD AND ASK, THIS IS A MODIFIED TEST VERSION JUST FOR THIS SHADER VERSION AND IS NOT A VERSION THAT CAN BE INCLUDED IN OTHER SHADERS



//last revised 2025-8-7, v 1.95 for icarus, pegasus

//#####################################
//For shader specific sdjustments

#define CPF_SHADER_STYLE 8

//#####################################

#if CPF_SHADER_STYLE == 8
	#define Material_id ipbr_id
#else
	#define Material_id material_type.x
#endif

//Relates to ctmpomfix
//<<for updated ctmpomfix

vec2 max_alpha;

//#define HARD_ALPHA 1
//#define FILTER_HERE UPSCALE_TERRAIN

//2024-11-12,  added t upscx to water
#if IS_WATER_SHADER == 1

#else
	#define HARD_ALPHA 1 
#endif

//>>


#if IS_AN_ENTITY  == 1 || IS_GBUFFERS_BLOCK == 1
	#include "/stuff/version_check.glsl"
	//#define HARD_ALPHA 1


	#if TEXTURE_SIZE_AVAILABLE == 1

		#define FILTER_HERE UPSCALE_ENTITIES 
	#else
		#define FILTER_HERE 0 
	#endif


#define CHFXS 1
	#if CHFXS == 1
		#if TEXTURE_FILTERING_CPF == 1 || TEXTURE_FILTERING_CPF == 2 
			//default
			#if ENTITY_TEX_FILTER_FIX == 1
				//1-pixel a, 2-greatest of corners
				//define SKIP_TEX_FILTERING_CPF_ALPHA 1
				int SKIP_TEX_FILTERING_CPF_ALPHA = abs(Material_id-20005.)<=.5?  1 : 0;//still blend on known entities
			#endif
			//alternate
			#if ENTITY_TEX_FILTER_FIX == 2
				//1-pixel a, 2-greatest of corners
				int SKIP_TEX_FILTERING_CPF_ALPHA = abs(Material_id-20005.)<=.5?  2 : 0;//still blend on known entities
				//ivec2 Texture_size = textureSize(texture,0);
				//int Skip_Tex_Filtering_Mode = ENTITY_TEX_FILTER_FIX;//Texture_size.x!= Texture_size.y || Texture_size.x>16 || Texture_size.y>16? 2 : 2;
			#endif
			#if ENTITY_TEX_FILTER_FIX !=1 && ENTITY_TEX_FILTER_FIX != 2
				int SKIP_TEX_FILTERING_CPF_ALPHA =0;
			#endif
		#else
			#if ENTITY_TEX_FILTER_FIX == 1
				//1-pixel a, 2-greatest of corners
				//define SKIP_TEX_FILTERING_CPF_ALPHA 1
				int SKIP_TEX_FILTERING_CPF_ALPHA = abs(Material_id-20005.)<=.5?  2 : 0;//still blend on known entities
			#endif
			#if ENTITY_TEX_FILTER_FIX == 2
				//1-pixel a, 2-greatest of corners
				int SKIP_TEX_FILTERING_CPF_ALPHA = abs(Material_id-20005.)<=.5?  1 : 0;//still blend on known entities
				//ivec2 Texture_size = textureSize(texture,0);
				//int Skip_Tex_Filtering_Mode = ENTITY_TEX_FILTER_FIX;//Texture_size.x!= Texture_size.y || Texture_size.x>16 || Texture_size.y>16? 2 : 2;
			#endif
			#if ENTITY_TEX_FILTER_FIX !=1 && ENTITY_TEX_FILTER_FIX != 2
				int SKIP_TEX_FILTERING_CPF_ALPHA =0;
			#endif
		#endif	
	#else
		int SKIP_TEX_FILTERING_CPF_ALPHA =0;
	#endif	
#endif
#if IS_HAND == 1
	int SKIP_TEX_FILTERING_CPF_ALPHA = HAND_TEX_FILTER_FIX;
	#define FILTER_HERE UPSCALE_HAND_HELD
#endif
#if IS_HAND != 1 && IS_AN_ENTITY  != 1 && IS_GBUFFERS_BLOCK != 1
	int SKIP_TEX_FILTERING_CPF_ALPHA =0;
	#define FILTER_HERE UPSCALE_TERRAIN
#endif	






//#####################
// COMPATIBILITY ZONE 
//#####################

//shader specific sdjustments
//#define CPF_SHADER_STYLE 8

//phrasing style 0, default, ch
#if CPF_SHADER_STYLE == 0
uniform float near;
uniform float far;
//uniform ivec2 Texture_size1;

#define ALBEDO_TEXTURE_CALL_FOR_FLAG_CHECK textureLod(texture,fract(coord) * vtexcoordam.pq + vtexcoordam.st,0)
#define ALBEDO_TEXTURE_CALL_PREFIX textureGrad(texture, 
#define ALBEDO_TEXTURE_CALL_SUFFIX * vtexcoordam.pq + vtexcoordam.st, dcdx, dcdy)
#define ALBEDO_TEXTURE_SET_UV_SUFFIX * vtexcoordam.pq+vtexcoordam.st

#define ALBEDO_TEXTURE_CALL_PREFIX_FAST textureLod(texture,
#define TEXTURE_CALL_SUFFIX_FAST * vtexcoordam.pq + vtexcoordam.st, 0 )

#define ALBEDO_TEXTURE_SAMPLER texture 
#define SPECULAR_TEXTURE_SAMPLER specular 
#define NORMAL_TEXTURE_SAMPLER normals 

#define NORMAL_TEXTURE_CALL_PREFIX texture2DGradARB(normals,
#define NORMAL_TEXTURE_CALL_SUFFIX *vtexcoordam.pq+vtexcoordam.st,dcdx,dcdy)

#define TEXTURE_CALL_PREFIX texture2DGradARB(
#define TEXTURE_CALL_SUFFIX  *vtexcoordam.pq+vtexcoordam.st,dcdx,dcdy)

#define QUAD_TEXTURE_SIZE_COMPONENT vec2(vtexcoordam.pq )
#define QUAD_TEXTURE_POSITION_COMPONENT vec2(vtexcoordam.st )
#define TEXTURE_CALL_GRADS , dcdx, dcdy

#define CPF_NEAR_FAR_WORKAROUND 0
#define DEFER_DEPTH_WRITE_CPF 0
#define SHADER_NOISE_FUNCTION 0.0
#endif
//>

//phrasing style 1, bliss
#if CPF_SHADER_STYLE == 1 
#define ALBEDO_TEXTURE_CALL_FOR_FLAG_CHECK textureGrad(texture, fract(coord) * vtexcoordam.pq + vtexcoordam.st, dcdx, dcdy)
#define ALBEDO_TEXTURE_CALL_PREFIX textureGrad(texture, 
#define ALBEDO_TEXTURE_CALL_SUFFIX * vtexcoordam.pq + vtexcoordam.st, dcdx, dcdy)
#define ALBEDO_TEXTURE_SET_UV_SUFFIX * vtexcoordam.pq+vtexcoordam.st

#define ALBEDO_TEXTURE_SAMPLER texture
#define SPECULAR_TEXTURE_SAMPLER specular
#define NORMAL_TEXTURE_SAMPLER normals

#define NORMAL_TEXTURE_CALL_PREFIX texture2DGradARB(normals,
#define NORMAL_TEXTURE_CALL_SUFFIX *vtexcoordam.pq+vtexcoordam.st,dcdx,dcdy)

#define TEXTURE_CALL_PREFIX texture2DGradARB(
#define TEXTURE_CALL_SUFFIX  *vtexcoordam.pq+vtexcoordam.st,dcdx,dcdy)

#define QUAD_TEXTURE_SIZE_COMPONENT vtexcoordam.pq 
#define QUAD_TEXTURE_POSITION_COMPONENT vtexcoordam.st 
#define TEXTURE_CALL_GRADS , dcdx, dcdy

#define CPF_NEAR_FAR_WORKAROUND 0
#define DEFER_DEPTH_WRITE_CPF 0
#define SHADER_NOISE_FUNCTION 2* interleaved_gradientNoise()
#endif
//>

//phrasing style 2, Complimentary Reimagined
#if CPF_SHADER_STYLE == 2

#define CPF_NEAR_FAR_WORKAROUND 1
#define DEFER_DEPTH_WRITE_CPF 0
#define RENDER_DISTANCE_CPF 8 // [2 3 4 5 6 7 8 9 10 11 12 12 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 40 45 50 55 60 64] //Select your minecraft render distance . This doesn't actually matter right now. THIS IS A WORKAROUND TO NOT HAVE TO PATCH 12 FILES BECAUSE 'NEAR' AND 'FAR' VARIABLES ARE DECLARED IN THEM INSTEAD OF IN THE COMMON FILE

#define ALBEDO_TEXTURE_CALL_FOR_FLAG_CHECK textureGrad(tex, fract(coord) * vTexCoordAM.pq + vTexCoordAM.st, dcdx, dcdy)
#define ALBEDO_TEXTURE_CALL_PREFIX textureGrad(tex, 
#define ALBEDO_TEXTURE_CALL_SUFFIX * vTexCoordAM.pq + vTexCoordAM.st, dcdx, dcdy)
#define ALBEDO_TEXTURE_SET_UV_SUFFIX * vTexCoordAM.pq + vTexCoordAM.st

#define ALBEDO_TEXTURE_SAMPLER tex
#define SPECULAR_TEXTURE_SAMPLER tex
#define NORMAL_TEXTURE_SAMPLER normals

#define NORMAL_TEXTURE_CALL_PREFIX textureGrad(normals,
#define NORMAL_TEXTURE_CALL_SUFFIX * vTexCoordAM.pq + vTexCoordAM.st, dcdx, dcdy)

#define TEXTURE_CALL_PREFIX textureGrad(
#define TEXTURE_CALL_SUFFIX  * vTexCoordAM.pq + vTexCoordAM.st, dcdx, dcdy)

#define QUAD_TEXTURE_SIZE_COMPONENT vTexCoordAM.pq
#define QUAD_TEXTURE_POSITION_COMPONENT vTexCoordAM.st
#define TEXTURE_CALL_GRADS  , dcdx, dcdy


#define SHADER_NOISE_FUNCTION 0.0

// NOTES:
// paste "define SKIP_TEX_FILTERING_CPF" in gbuffer entities
// turn on pom on cutouts for texture filtering to do outlines
#endif
//>


//phrasing style 3, gfme
#if CPF_SHADER_STYLE == 3

#define DEFER_DEPTH_WRITE_CPF 1
#define CPF_NEAR_FAR_WORKAROUND 0

#define ALBEDO_TEXTURE_CALL_FOR_FLAG_CHECK texture2DLod(texture, fract(coord) * local_uv_components.pq + local_uv_components.st,0)
#define ALBEDO_TEXTURE_CALL_PREFIX texture2DLod(texture, 
#define ALBEDO_TEXTURE_CALL_SUFFIX * local_uv_components.pq + local_uv_components.st,0)
#define ALBEDO_TEXTURE_SET_UV_SUFFIX * local_uv_components.pq + local_uv_components.st 
#define NORMAL_TEXTURE_CALL_PREFIX texture2DLod(normals,
#define NORMAL_TEXTURE_CALL_SUFFIX *local_uv_components.pq+local_uv_components.st,0)


#define POM_QUALITY_VARIABLE 80
#define POM_DEPTH_VARIABLE 0.25
#define POM_DIST_VARIABLE 25

#define ALBEDO_TEXTURE_SAMPLER texture
#define SPECULAR_TEXTURE_SAMPLER specular
#define NORMAL_TEXTURE_SAMPLER normals

#define TEXTURE_CALL_PREFIX texture2DLod(
#define TEXTURE_CALL_SUFFIX   * local_uv_components.pq + local_uv_components.st,0)

#define QUAD_TEXTURE_SIZE_COMPONENT local_uv_components.pq

#define CPF_ADDS_DEPTH_WRITE 0
#define SHADER_NOISE_FUNCTION 0.0
#endif
//>



//phrasing style 7, ttb
#if CPF_SHADER_STYLE == 7

//uniform ivec2 Texture_size1;

#define ALBEDO_TEXTURE_CALL_FOR_FLAG_CHECK textureLod(texture,fract(coord) * vlocal_uv_components.pq + vlocal_uv_components.st,0)
#define ALBEDO_TEXTURE_CALL_PREFIX textureGrad(texture, 
#define ALBEDO_TEXTURE_CALL_SUFFIX * vlocal_uv_components.pq + vlocal_uv_components.st, dfdx, dfdy)
#define ALBEDO_TEXTURE_SET_UV_SUFFIX * vlocal_uv_components.pq+vlocal_uv_components.st

#define ALBEDO_TEXTURE_CALL_PREFIX_FAST textureLod(texture,
#define TEXTURE_CALL_SUFFIX_FAST * vlocal_uv_components.pq + vlocal_uv_components.st, 0 )

#define ALBEDO_TEXTURE_SAMPLER texture 
#define SPECULAR_TEXTURE_SAMPLER specular 
#define NORMAL_TEXTURE_SAMPLER normals 

#define NORMAL_TEXTURE_CALL_PREFIX texture2DGradARB(normals,
#define NORMAL_TEXTURE_CALL_SUFFIX *vlocal_uv_components.pq+vlocal_uv_components.st,dfdx,dfdy)

#define TEXTURE_CALL_PREFIX texture2DGradARB(
#define TEXTURE_CALL_SUFFIX  *vlocal_uv_components.pq+vlocal_uv_components.st,dfdx,dfdy)

#define QUAD_TEXTURE_SIZE_COMPONENT vlocal_uv_components.pq 
#define QUAD_TEXTURE_POSITION_COMPONENT vlocal_uv_components.st 
#define TEXTURE_CALL_GRADS , dfdx, dfdy

#define CPF_NEAR_FAR_WORKAROUND 0
#define DEFER_DEPTH_WRITE_CPF 0
#define SHADER_NOISE_FUNCTION 0.0
#endif

//phrasing style 8, Upscaled
#if CPF_SHADER_STYLE == 8

//uniform ivec2 Texture_size1;
#if VERY_OLD_MC == 1
	#define ALBEDO_TEXTURE_CALL_FOR_FLAG_CHECK texture2D(texture,fract(coord) * vlocal_uv_components.pq + vlocal_uv_components.st)
	#define ALBEDO_TEXTURE_CALL_PREFIX texture2D(texture, 
	#define ALBEDO_TEXTURE_CALL_SUFFIX * vlocal_uv_components.pq + vlocal_uv_components.st)
	#define ALBEDO_TEXTURE_SET_UV_SUFFIX * vlocal_uv_components.pq+vlocal_uv_components.st

	#define ALBEDO_TEXTURE_CALL_PREFIX_FAST texture2D(texture,
	#define TEXTURE_CALL_SUFFIX_FAST * vlocal_uv_components.pq + vlocal_uv_components.st )

	#define ALBEDO_TEXTURE_SAMPLER texture 
	#define SPECULAR_TEXTURE_SAMPLER specular 
	#define NORMAL_TEXTURE_SAMPLER normals 

	#define NORMAL_TEXTURE_CALL_PREFIX texture2D(normals,
	#define NORMAL_TEXTURE_CALL_SUFFIX *vlocal_uv_components.pq+vlocal_uv_components.st)

	#define TEXTURE_CALL_PREFIX texture2D(
	#define TEXTURE_CALL_SUFFIX  *vlocal_uv_components.pq+vlocal_uv_components.st)

	#define QUAD_TEXTURE_SIZE_COMPONENT vec2(vlocal_uv_components.pq)
	#define QUAD_TEXTURE_POSITION_COMPONENT vec2(vlocal_uv_components.st)
	#define TEXTURE_CALL_GRADS  
#else
	#define ALBEDO_TEXTURE_CALL_FOR_FLAG_CHECK textureLod(texture,fract(coord) * vlocal_uv_components.pq + vlocal_uv_components.st,0)
	#define ALBEDO_TEXTURE_CALL_PREFIX textureGrad(texture, 
	#define ALBEDO_TEXTURE_CALL_SUFFIX * vlocal_uv_components.pq + vlocal_uv_components.st, dfdx, dfdy)
	#define ALBEDO_TEXTURE_SET_UV_SUFFIX * vlocal_uv_components.pq+vlocal_uv_components.st

	#define ALBEDO_TEXTURE_CALL_PREFIX_FAST textureLod(texture,
	#define TEXTURE_CALL_SUFFIX_FAST * vlocal_uv_components.pq + vlocal_uv_components.st, 0 )

	#define ALBEDO_TEXTURE_SAMPLER texture 
	#define SPECULAR_TEXTURE_SAMPLER specular 
	#define NORMAL_TEXTURE_SAMPLER normals 

	#define NORMAL_TEXTURE_CALL_PREFIX texture2DGradARB(normals,
	#define NORMAL_TEXTURE_CALL_SUFFIX *vlocal_uv_components.pq+vlocal_uv_components.st,dfdx,dfdy)

	#define TEXTURE_CALL_PREFIX texture2DGradARB(
	#define TEXTURE_CALL_SUFFIX  *vlocal_uv_components.pq+vlocal_uv_components.st,dfdx,dfdy)

	#define QUAD_TEXTURE_SIZE_COMPONENT vec2(vlocal_uv_components.pq)
	#define QUAD_TEXTURE_POSITION_COMPONENT vec2(vlocal_uv_components.st)
	#define TEXTURE_CALL_GRADS , dfdx, dfdy
#endif


#define CPF_NEAR_FAR_WORKAROUND 0
#define DEFER_DEPTH_WRITE_CPF 0
#define SHADER_NOISE_FUNCTION 0.0

#define BLEND_PIXELS 0 //[0 1]
#define BLEND_PIXELS_SOFTNESS 0.3 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define G_NORM_MAP_STR 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 3.0 4.0 5.0 7.0 10.0]
#define G_NORM_MAP_SUB_PIXEL_STR 0.2 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define G_NORM_SP_RES 16.0 //[1.0 8.0 16.0 32.0 64.0 128.0]

float pom_depth_forward;
float Metal = .9;

#endif

//>



//see if these are faster for checking flags or pixels, try
//texelFetch()
//textureLod()



//#####################
//#####################




//DOCUMENTATION

//This is exhaustedly commented in an attempt to serve as documentation

//for additional help making compatible resource packs, come to my discord server listed above.



//SETTINGS

//some of these defines go in a settings toggle, at least CTMPOMFIX



#define CTMPOMFIX 1 // [1]  //CTMPOMFIX overhauls 3D textures (POM) with special features, including fixing seams on 3D Connected Textures in resource packs formatted for it. in many cases it vastly improves quality/performance . Turn on POM, turn off Video Settings/Quality/Better Grass 

#define INITIAL_POM_QUALITY_CPF 30 // [5 10 20 25 30 40 50 75 100 200 400 1000] //Initial POM Quality . This is EXPONENTIALLY INCREASED by the REFINE_POM Setting . Recommend 20+ but you don't need much more . 20 Initial with 5 Refine is like 1,000 Quality for the cost of 25

#define POM_DISTANCE_CPF 25 // [5 10 15 20 25 30 40 50 60 75 100 200] //How far out 3D textures (POM) will be 3D 

#define POM_DEPTH_CPF 0.25 //[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00] //Depth of 3D Textures. 0.25 is the standard . Changing may break Seamlessness and look bad

#define FADE_IN_POM_CPF 5 // [0 1 2 3 4 5 6 7 8 9 10] //3D fade in for pom . how much of POM distance is used for fade . 0 is none, 10 is all . Recommend around 5 

#define DYNAMIC_QUALITY_CPF 0 // [0 1] //lower pom quality at a distance . might improve performance . might make it worse . requires fade_in

#define FAR_FIXES_CPF 1 // [0 1] //CTMPOMFIX OPTION: . just leave this on. hides buggy 3D overlays out of pom range and fixes UVs for textures using ctmpomfix mode 11 (some mods). also potentially improves performance in some cases

#define ENABLE_CTMPOMFIX_POM_SPACE 1 // [0 1] //CTMPOMFIX OPTION: . this is an alternate POM implementation with even more special features in the works

#define CPF_RELATIVE_SPACE 0 // [0 1] //CTMPOMFIX OPTION: 

#define INCREASE_QUALITY_AT_ANGLES_CPF 2 // [2 3 4 5 0]  // Increase the quality of POM at grazing angles . lower is better quality, but 0 is Off . this also limits the distance rays can go inside of blocks

#define DEPTH_WRITE_CPF 1 // [0 1] //for 3D transitions and edges to be seamless and display correctly . also screen space shadows . OFF BREAKS A LOT OF STUFF . leave on unless not using any of it

#define SMOOTHING_NOISE_CPF 0 //[0 1 2 3] //You can apply Noise to gently Smooth POM, it blurs it but reduces visible layers, especially at angles. Can also help de-flicker Pom Refinement if it's flickering, or cause it to flicker, or make 3D overlays to have seams.  0 - disable noise 1 - use noise . 2 - blur distance  3 - blur close to smooth

#define NOISE_FUNCTION_CPF 0 //[0 1 2 3 4] //Some shaders inject noise functions into POM, it helps hide layers but can blur . generally it's good . 0 - use a Shader Supplied noise function, if any . 1-x use other functions . 1+ may introduce some banding in pom until I find better alt noise functions

#define NOISE_STRENGTH_CPF 1.0 //[0.0 0.1 0.25 0.33 0.5 0.75 0.9 1.0 1.5 2.0 2.5 3.0] //Some shaders inject noise functions into POM, it helps hide layers but can blur . Adjust its strength . This can improve or worsen POM appearance . This may create or solve flickering

 #define REFINE_POM_CPF 10 //[0 1 2 3 4 5 6 7 10 20] //POM Refinement Steps . EXPONENTIAL QUALITY INCREASE FOR ALMOST FREE . 1 is ~4x quality at the cost of 1 quality . an extra 2x for every additional step . not great on very low quality for sharp stuff like grass, atleast 20 Initial Quality recommended . on some shaders low values may flicker

#define TEXTURE_FILTERING_CPF 0 //[0 1 2 3 4 5 6 7 8 9] //Filter Textures so they aren't pixelated when close up, performance may vary by mode, ALPHA ones are debug use or may not work well . 0 - none, 1-bilinear, 2-bilinear with adaptive contrast, 3-hq like, 4-hq/blended ALPHA, 5-crisp, 6-rounded crisp ALPHA, 7-round blend ALPHA

#define TEXTURE_FILTERING_DISTANCE_CPF 10 //[0 1 2 5 10 20 30 50 100 200 500 10000] //Filter Textures so they aren't pixelated when close up . How far out to use this effect . very low is fine for high res packs

#define POM_STYLE_CPF 0 //[0 1 2] //0 - sharp voxel cubes. 1 - tesselate .  2 - smooth polygons

#define EXTEND_3D_SHADOWS_CPF 0 //[0 1 2] //Depth writing for 3D Shadows, ao, etc in Textures out of POM range . 0 - off . 1 and 2 look the same, but either may be faster on your machine

#define UPSCALE_RESOLUTION_CPF 1 //[1 2 4 8 16 32 64 1] // Multplier for Upscaling and Texture filtering . 1 is infinite . these all cost the same, it's just visual preference

#define TEXTURE_BLEND_SOFTNESS_CPF 1.0 //[0.0 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //1 is Softer Texture Blending . lOWER will sharpen Adaptive Contrast to maintain high contrast areas even more, but in doing so limits softer blending.

#define TEXTURE_FILTER_FADE_CPF 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] //fade in for texture filtering . may not work with every style

#define FAST_TEX_READS_CPF 0 // [0 1 2] //coming soon

#define ALPHA_CUTOFF_CPF 0.25 // [0.05 0.1 0.2 0.25 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95] //Things more opaque than this will be solid in Texture Filtering . Thickens Grass at lower numbers

 #define COLOR_MERGE_DIST_CPF 0.1 //[ 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 ] //Texture Filtering will use this value to blend or link colors that are this close to each other . Effect will vary per filter . just leave it or it will probably break texture filtering
  


#define CTMPOMFIX_INFO 0 // [0 1]  //CTMPOMFIX is an enhanced alternative POM with special features and usually a vast quality/performance increase. TURN ON POM, TURN OFF BETTER GRASS .  please report bugs and incompatibilities to timetravelbeard on discord or patreon  . More features coming soon

#define CAPTURE_CPF_POM_DEPTH 1 //[0 1]

//start of core code
#if CTMPOMFIX != 1111 


//UTILITIES


float capf(in float f,in float fmin,in float fmax)
{
return f< fmin?fmin:f>fmax?fmax:f;
}

int roundi(in float f)
{//round float to int
return  fract(f)<.5?int(f):int(f)+1; 
}

float fract_signed(in float f)
{
	return f-int(f);
}

float fract_signed_oct(in float f)
{
	f*=8;
	return (f-int(f))*.125;
}

float smooth_c(float t) {
  return t * t * (3.0 - 2.0 * t);
}

float easy_noise_cpf()
{
#if NOISE_FUNCTION_CPF == 0
return NOISE_STRENGTH_CPF * SHADER_NOISE_FUNCTION;
#endif

#if NOISE_FUNCTION_CPF == 1
return NOISE_STRENGTH_CPF *  0.1 * fract(sin(frameTimeCounter*1.3147+17.5*gl_FragCoord.x+11.7*gl_FragCoord.y));
#endif

#if NOISE_FUNCTION_CPF == 2
return NOISE_STRENGTH_CPF *  0.1 * fract(sin(1*fract(frameTimeCounter*1.3147)+fract(1.37*gl_FragCoord.x)+fract(111.7*gl_FragCoord.y)));
#endif

#if NOISE_FUNCTION_CPF == 3
return NOISE_STRENGTH_CPF *  fract(sin(frameTimeCounter*1.3147+17.5*gl_FragCoord.x+11.7*gl_FragCoord.y));
#endif

#if NOISE_FUNCTION_CPF == 4
return NOISE_STRENGTH_CPF *  fract(sin(1*fract(frameTimeCounter*1.3147)+fract(1.37*gl_FragCoord.x)+fract(111.7*gl_FragCoord.y)));
#endif
}






#if CPF_SHADER_STYLE == 0

	vec3 normal_tex_to_world_cpf(in vec3 bumpy)
	{
	//bumpy = gl_Normal.rgb;
 bumpy = (bumpy*2-1);
bumpy.b = 1-(abs(bumpy.g)+abs(bumpy.r));
vec3 normal = normalMat.xyz;
        vec3 tangent2 = normalize(cross(tangent.rgb,normal)*tangent.w);
		mat3 tbnMatrix = mat3(tangent.x, tangent2.x, normal.x,
								  tangent.y, tangent2.y, normal.y,
						     	  tangent.z, tangent2.z, normal.z);
return (bumpy * tbnMatrix)*mat3(gl_ModelViewMatrix);	  
}
	
vec3 normal_tex_to_view_cpf(in vec3 bumpy)
	{
	//bumpy = gl_Normal.rgb;
 bumpy = (bumpy*2-1);
bumpy.b = 1-(abs(bumpy.g)+abs(bumpy.r));
vec3 normal = normalMat.xyz;
        vec3 tangent2 = normalize(cross(tangent.rgb,normal)*tangent.w);
		mat3 tbnMatrix = mat3(tangent.x, tangent2.x, normal.x,
								  tangent.y, tangent2.y, normal.y,
						     	  tangent.z, tangent2.z, normal.z);
return (bumpy * tbnMatrix);//*mat3(gl_ModelViewMatrix);	  
}

vec3 normal_to_view_cpf(in vec3 bumpy)
	{
	//bumpy = gl_Normal.rgb;
 bumpy = (bumpy*2-1);
bumpy.b = 1-(abs(bumpy.g)+abs(bumpy.r));
vec3 normal = normalMat.xyz;
        vec3 tangent2 = normalize(cross(tangent.rgb,normal)*tangent.w);
		mat3 tbnMatrix = mat3(tangent.x, tangent2.x, normal.x,
								  tangent.y, tangent2.y, normal.y,
						     	  tangent.z, tangent2.z, normal.z);
return bumpy * tbnMatrix;//*mat3(gl_ModelViewMatrix);	    
}

#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif

vec3 normal_tex_to_world2_cpf(in vec3 bumpy)
	{
	//bumpy = gl_Normal.rgb;
 bumpy = (bumpy*2-1);
bumpy.b = 1-(abs(bumpy.g)+abs(bumpy.r));
vec3 normal = normalMat.xyz;
        vec3 tangent2 = normalize(cross(tangent.rgb,normal)*tangent.w);
		mat3 tbnMatrix = mat3(tangent.x, tangent2.x, normal.x,
								  tangent.y, tangent2.y, normal.y,
						     	  tangent.z, tangent2.z, normal.z);
return (bumpy * tbnMatrix*mat3(gl_ModelViewMatrix));	  
}

      #endif



#if DECCED_LIN_DEPTH != 1
#define DECCED_LIN_DEPTH 1
float linearize_depth_cpf(in float d)
{
#if CPF_NEAR_FAR_WORKAROUND == 1
float far = RENDER_DISTANCE_CPF;
float near = 0.05;
#endif
    // from gl_FragCoord.z to world measurements
    return 2.0 * near  * far / (far + near - (2.0 * d - 1.0) * (far - near));

}



float delinearize_depth_cpf(in float dee)
{// from world measurements to gl_FragDepth

#if CPF_NEAR_FAR_WORKAROUND == 1
float far = RENDER_DISTANCE_CPF;
float near = 0.05;
#endif
    return ( ( (far + near - 2.0 * near * far / dee) / (far - near) )  + 1.0) / 2.0;
}
#endif


void fast_depth_write_cpf(in float fee)
{
	  #if DEPTH_WRITE_CPF == 2
	  //gl_FragDepth = ((gl_FragCoord.z));
      gl_FragDepth = ((gl_FragCoord.z) + fee *0.000001); 
      #endif
	  #if DEPTH_WRITE_CPF == 1
      gl_FragDepth = delinearize_depth_cpf(linearize_depth_cpf(gl_FragCoord.z) + fee); 
      #endif
}



//VARIABLES


float Ctm_pom_fix_margin;
int Ctm_pom_fix_mode;




#define DEBUG_552 1
#if DEBUG_552 == 1


#if TEXTURE_FILTERING_CPF == 1111
//&&  POM_STYLE_CPF == 0 
//&& GEN_NORMAL_MAP == 0
#else


#define DEBUG_55 1


//
//for: softness of texture filtering, fade
//sub_pixel_position = softness==0?sub_pixel_position*0:  (1+ (sub_pixel_position-1) / softness);


//for: adaptive_contrast_bilinear_filter_cpf



vec4 Normalize_rgba_cpf(in vec4 v)
{//get color profile
float t =(v.r+v.g+v.b);//*v.a;
//float it = t<=0 ? 0 : 1.0/t;
return t<= 0? v*0 : v/t;// vec4(v.r*it,v.g*it,v.b*it,v.a);
}



vec4 blend_with_alpha_cpf(in vec4 a, in vec4 b,in float bxy)
{//blend 2 rgb with alpha weight
 
    bxy = clamp(bxy,0.0,1.0);
	 float abxy = bxy;

	bxy=a.a<ALPHA_CUTOFF_CPF?1.:b.a<ALPHA_CUTOFF_CPF?0.:bxy;
	
	vec4 c=  (a* (1-bxy) + b * bxy );
	c.a= (a.a* (1-bxy) + b.a * bxy );

	//if(abs(abxy -.5)>.49) return vec4(0,0,0,1); //debug grid

		c.a= 
		#if WIDEN_FILTERED_THINGS == 0
			(SKIP_TEX_FILTERING_CPF_ALPHA == 1) ? a.a: 
			(SKIP_TEX_FILTERING_CPF_ALPHA == 2)? ENTITY_TEX_FILTER_FIX == 1? max(a.a,b.a) : a.a
			:
		#endif
		c.a	;// max(a.a,b.a);

	return c;

}

vec4 blend_with_alpha_cpf_old(in vec4 a, in vec4 b,in float bxy)
{//blend 2 rgb with alpha weight
 
    bxy = clamp(bxy,0.0,1.0);
	  float abxy = bxy;
	  #if defined IS_ENTITY_WITH_ALPHA_GLOW 
#else
#if defined SKIP_TEX_FILTERING_CPF_ALPHA
#else
bxy=a.a<ALPHA_CUTOFF_CPF?1:b.a<ALPHA_CUTOFF_CPF?0:bxy;
#endif
	
	#endif
	vec4 c=  (a* (1-bxy) + b * bxy );
	c.a= (a.a* (1-abxy) + b.a * abxy );
	//c.a=c.a>= ALPHA_CUTOFF_CPF ?1:0;
	
	//if(abs(abxy -.5)>.49) return vec4(0,0,0,1); //debug grid
	#if defined SKIP_TEX_FILTERING_CPF_ALPHA
	c.a=a.a;//max(a.a,b.a);
	#endif
	return c;

}


vec4 blend_with_external_alpha_cpf(in vec4 a, in vec4 b,in float bxy, inout vec2 alphas)
{//blend 2 rgb with alpha weight
 
    bxy = clamp(bxy,0.0,1.0);
	 float abxy = bxy;

	bxy=alphas.x<ALPHA_CUTOFF_CPF?1.:alphas.y <ALPHA_CUTOFF_CPF?0.:bxy;
	
	vec4 c=  (a* (1-bxy) + b * bxy );
	c.a= (a.a* (1-bxy) + b.a * bxy );

	//if(abs(abxy -.5)>.49) return vec4(0,0,0,1); //debug grid

		c.a= 
		#if WIDEN_FILTERED_THINGS == 0
			(SKIP_TEX_FILTERING_CPF_ALPHA == 1) ? alphas.x : 
			(SKIP_TEX_FILTERING_CPF_ALPHA == 2)? ENTITY_TEX_FILTER_FIX == 1? max(  alphas.x , alphas.y ) : alphas.x
			:
		#endif
		c.a	;// max(a.a,b.a);
alphas.x=c.a;
	return c;

}





vec4 double_hawk_blend_cpf( in vec4 a, in vec4 b, in vec4 c, in vec4 d, in vec2 sub_pixel_position)
{//blend type 3 - sharp , and 4 -with bilinear underneath
	
	// do hq, this, this with adaptive contrast
	
	//use texture lod for lookups and flags
	

  //triple hawk blend
  
	 //arrange colors in triangles, take closest corner color
    vec4 color_main;
    vec4 color_left;
    vec4 color_right;
    vec4 color_opposing;
	
  
    if(sub_pixel_position.x> 0.5 && sub_pixel_position.y > 0.5)
        color_main = d , color_left = c, color_right = b,color_opposing=a;
    else if(sub_pixel_position.y > 0.5)
        color_main = c, color_left = a , color_right = d,color_opposing=b;
    else if(sub_pixel_position.x < 0.5)
        color_main = a, color_left = c, color_right = b,color_opposing=d ;
    else
        color_main = b, color_left = a, color_right = d,  color_opposing=c;
    
	
		vec4 color_main_og =  color_main;


    	//check diagonal match
        vec4 side_colors_difference = abs(color_left - color_right);
        float color_difference = (side_colors_difference.r + side_colors_difference.g + side_colors_difference.b);
        //check opposite match
        vec4 main_colors_difference = abs(color_main - color_opposing);
        float color_difference_juxtapose = (main_colors_difference.r + main_colors_difference.g + main_colors_difference.b);
    
	  
    //if in center or not 
    float center_distance = abs(sub_pixel_position.x-0.5) + abs(sub_pixel_position.y-0.5);

   
   //if in center
    if(center_distance < 0.5) {    
    

       #if TEXTURE_FILTERING_CPF == 3
				 color_main= (color_left.a>color_main.a&&color_right.a>color_main.a)||(color_left.a>color_opposing.a&&color_right.a>color_opposing.a)||(color_difference < COLOR_MERGE_DIST_CPF && ((color_left.a>= ALPHA_CUTOFF_CPF)==(color_right.a>= ALPHA_CUTOFF_CPF)) &&(color_left.a>=color_opposing.a) && (color_difference < color_difference_juxtapose || (color_difference == color_difference_juxtapose && color_main == a )))  ?  color_left :  (color_main == b||color_main == d)&&((color_left.a<color_main.a||color_right.a<color_main.a) && color_opposing.a>(color_left.a+color_right.a)*.5) ? color_opposing : color_main ;
				 
				 // color_main= (color_difference < COLOR_MERGE_DIST_CPF && (color_difference < color_difference_juxtapose || (color_difference == color_difference_juxtapose && color_main == a )))  ?  color_left :  (color_left.a<color_main.a||color_right.a< color_main.a)? color_opposing : color_main ;
      #else 
		sub_pixel_position = clamp((sub_pixel_position-.5)*4+.5,0,1);
       
	//blend and connect side diagonals that are opaque and closer in color
      // color_main= (color_difference < COLOR_MERGE_DIST_CPF && color_left.a>= ALPHA_CUTOFF_CPF && (color_difference <color_difference_juxtapose || (color_difference == color_difference_juxtapose && (color_main == a||color_main == d)))  ? mix(color_left, color_right,sub_pixel_position.x)  : color_main ;
	  
	    color_main= (color_left.a>color_main.a&&color_right.a>color_main.a)||(color_left.a>color_opposing.a&&color_right.a>color_opposing.a)||(color_difference < COLOR_MERGE_DIST_CPF && ((color_left.a>= ALPHA_CUTOFF_CPF)==(color_right.a>= ALPHA_CUTOFF_CPF)) &&(color_left.a>=color_opposing.a) && (color_difference < color_difference_juxtapose || (color_difference == color_difference_juxtapose && color_main == a )))   ?  blend_with_alpha_cpf(color_left, color_right,sub_pixel_position.x)  :  color_main ;
		
			 
	   
    }else{
	sub_pixel_position = clamp((sub_pixel_position-.5)*4+.5,0,1);
    	//corners
    	  //blend if opposite doesn't connect
		//  color_main= (color_difference < COLOR_MERGE_DIST_CPF && ((color_left.a>= ALPHA_CUTOFF_CPF)==(color_right.a>= ALPHA_CUTOFF_CPF)) && (color_difference < color_difference_juxtapose || (color_difference == color_difference_juxtapose && color_main == a )))  ? color_main : mix( mix( a,b,sub_pixel_position.x),mix( c,d,sub_pixel_position.x) ,sub_pixel_position.y); ;
     
	 // color_main= (color_difference_juxtapose < COLOR_MERGE_DIST_CPF && color_main.a>= ALPHA_CUTOFF_CPF && (color_difference_juxtapose  < color_difference  || (color_difference == color_difference_juxtapose && color_main != a )))  ?  color_main : blend_with_alpha_cpf( blend_with_alpha_cpf( a,b,sub_pixel_position.x),blend_with_alpha_cpf( c,d,sub_pixel_position.x) ,sub_pixel_position.y);
    #endif
    }
    
    //treat alpha for crisp edges

		color_main.a= (SKIP_TEX_FILTERING_CPF_ALPHA == 1) ? a.a :color_main.a;

		if (SKIP_TEX_FILTERING_CPF_ALPHA == 2)
		{
			//color_main.a=a.a;
			if(color_main.a<0.001)
			{
				
				//color_main.a= max(max(a.a,b.a),max(c.a,d.a));
				//sort
				vec4 o1 = color_left.a > color_right.a ? color_left: color_right;
				vec4 o2 = color_main_og.a > o1.a? color_main_og: o1;
				color_main.rgb=SKIP_TEX_FILTERING_CPF_ALPHA == 2? o2.rgb:vec3(0.);
				color_main.a=SKIP_TEX_FILTERING_CPF_ALPHA >= 1? a.a:color_main.a;
				//color_main=color_main_og;
			}
		}
		

	#if HARD_ALPHA == 1
		color_main.a=
		SKIP_TEX_FILTERING_CPF_ALPHA >= 1 ? color_main.a :
		color_main.a>=ALPHA_CUTOFF_CPF ?max_alpha.y:max_alpha.x;
   	#endif
    
    //output
	
    return color_main;
}




vec4 adaptive_contrast_bilinear_filter_cpf(in vec4 a, in vec4 b, in vec4 c, in vec4 d, in vec2 sub_pixel_position)
{
	
	//get a,b,c,d etc
	//...
	
	
	//TODO: Optimizecwith dot instead of dist
	
	#if UPSCALE_RESOLUTION_CPF == 1
	#else
	//limit upscale resolution
	sub_pixel_position= floor(sub_pixel_position*UPSCALE_RESOLUTION_CPF )/ UPSCALE_RESOLUTION_CPF ;
	#endif
	
	
	
//blend with contrast by color profile

//a to b
//get pixel color similarity


	
float softness = 1- TEXTURE_BLEND_SOFTNESS_CPF * distance(Normalize_rgba_cpf(a).rgb,Normalize_rgba_cpf(b).rgb)*a.a*b.a;

//apply that softness to sub_pixel_position
float xyp= softness<=0?0: (1+ (sub_pixel_position.x -1) / softness);
//blend a,b
vec4 y1 = blend_with_alpha_cpf_old(a,b,xyp);



//c to d
//get pixel color similarity
softness = 1- TEXTURE_BLEND_SOFTNESS_CPF * distance(Normalize_rgba_cpf(c).rgb,Normalize_rgba_cpf(d).rgb)*c.a*d.a;
//apply that softness to sub_pixel_position
 xyp= softness<=0?0:  (1+ (sub_pixel_position.x -1) / softness);
//blend c,d
vec4 y2 = blend_with_alpha_cpf_old(c,d,xyp);

//y1 to y2
//get pixel color similarity
softness = 1- TEXTURE_BLEND_SOFTNESS_CPF * distance(Normalize_rgba_cpf(y1).rgb, Normalize_rgba_cpf(y2).rgb)*y1.a*y2.a;
//apply that softness to sub_pixel_position
 xyp= softness<=0?0:  (1+ (sub_pixel_position.y -1) / softness);
//blend y1, y2
return blend_with_alpha_cpf_old(y1,y2,xyp);



	
return vec4(0.0,0.0,0.0,0.0);
}//func
//


//in frag per pixel for texture filtering
// ivec2  atlas_size; //uniform ivec2 Texture_size1;
#if IS_AN_ENTITY == 1 
	#if TEXTURE_SIZE_AVAILABLE == 1
		vec2 Texture_size1=vec2(textureSize(texture,0));
		vec2 pixel_size_in_atlas_space =  1.0/Texture_size1;
	#else
		vec2 Texture_size1=vec2(64.);
		vec2 pixel_size_in_atlas_space =  1.0/Texture_size1;
	#endif
#else
	#if TEXTURE_SIZE_AVAILABLE == 1
		vec2 Texture_size1=vec2(textureSize(texture,0));	
	#else
		#ifndef ATLASSIZE
uniform ivec2 atlasSize;
#define ATLASSIZE
#endif
		vec2 Texture_size1=vec2(atlasSize);//(texture,0));
	#endif
	vec2 pixel_size_in_atlas_space =  1.0/Texture_size1;
	
#endif

vec2 pixelsize;



//for texture filtering/blending


//vec2 pixel_size_in_local_space = pq/pixel_size_in_atlas_space;


	



vec2 local_to_atlas_pixel_space(vec4 uv_comp, vec2 uv_local)
{
 return (uv_comp.st+uv_comp.pq*uv_local)*Texture_size1;
}

//QUAD_TEXTURE_SIZE_COMPONENT vtexcoordam.pq define QUAD_TEXTURE_POSITION_COMPONENT vtexcoordam.pq 



/*
vec4 local_uv_to_bilinear_data(in vec2 uv)
{

//if(	textureQueryLod( ALBEDO_TEXTURE_SAMPLER,	coordinate).y >=1)
 return ALBEDO_TEXTURE_CALL_PREFIX uv ALBEDO_TEXTURE_CALL_SUFFIX;

//Get position in pixel space and blend %
vec2 uv_in_pixel_space =  QUAD_TEXTURE_POSITION_COMPONENT + QUAD_TEXTURE_SIZE_COMPONENT * uv *Texture_size1;
vec2 sub_pixel_position=fract(uv_in_pixel_space);
uv = floor(uv_in_pixel_space)* pixel_size_in_atlas_space;

//Get data
#if FAST_TEX_READS_CPF == 1

	//vec4 a = ALBEDO_TEXTURE_CALL_PREFIX_FAST uv ,0);//* QUAD_TEXTURE_SIZE_COMPONENT + QUAD_TEXTURE_POSITION_COMPONENT ,0);
	//vec4 b = textureLod( ALBEDO_TEXTURE_SAMPLER , (uv + vec2( pixel_size_in_atlas_space.x, 0.0))* QUAD_TEXTURE_SIZE_COMPONENT + QUAD_TEXTURE_POSITION_COMPONENT ,0);
	//vec4 c = textureLod( ALBEDO_TEXTURE_SAMPLER , (uv + vec2( 0.0, pixel_size_in_atlas_space.y))* QUAD_TEXTURE_SIZE_COMPONENT + QUAD_TEXTURE_POSITION_COMPONENT ,0);
	//vec4 d = textureLod( ALBEDO_TEXTURE_SAMPLER , (uv + pixel_size_in_atlas_space) * QUAD_TEXTURE_SIZE_COMPONENT + QUAD_TEXTURE_POSITION_COMPONENT ,0);

	vec4 a = ALBEDO_TEXTURE_CALL_PREFIX uv ALBEDO_TEXTURE_CALL_SUFFIX;
	vec4 b = ALBEDO_TEXTURE_CALL_PREFIX uv + vec2( pixel_size_in_atlas_space.x, 0.0) ALBEDO_TEXTURE_CALL_SUFFIX;
	vec4 c = ALBEDO_TEXTURE_CALL_PREFIX (uv + vec2( 0.0, pixel_size_in_atlas_space.y)) ALBEDO_TEXTURE_CALL_SUFFIX;
	vec4 d = ALBEDO_TEXTURE_CALL_PREFIX (uv + pixel_size_in_atlas_space) ALBEDO_TEXTURE_CALL_SUFFIX;

#else
	vec4 a = ALBEDO_TEXTURE_CALL_PREFIX uv ALBEDO_TEXTURE_CALL_SUFFIX;
	vec4 b = ALBEDO_TEXTURE_CALL_PREFIX uv + vec2( pixel_size_in_atlas_space.x, 0.0) ALBEDO_TEXTURE_CALL_SUFFIX;
	vec4 c = ALBEDO_TEXTURE_CALL_PREFIX (uv + vec2( 0.0, pixel_size_in_atlas_space.y)) ALBEDO_TEXTURE_CALL_SUFFIX;
	vec4 d = ALBEDO_TEXTURE_CALL_PREFIX (uv + pixel_size_in_atlas_space) ALBEDO_TEXTURE_CALL_SUFFIX;
#endif

//Blend data, return
return mix( mix(a,b,sub_pixel_position.x), mix(c,d,sub_pixel_position.x), sub_pixel_position.y);

}//Func
*/









vec4 atlas_uv_to_bilinear_data(in vec2 uv, in float dist,out vec4 alphas)
{





#if defined SKIP_TEX_FILTERING_CPF 
//|| IS_ENTITY == 1
return  ALBEDO_TEXTURE_CALL_PREFIX uv TEXTURE_CALL_GRADS );
#endif


if(	dist > TEXTURE_FILTERING_DISTANCE_CPF || abs(Material_id-20001.)<.5) return  ALBEDO_TEXTURE_CALL_PREFIX uv TEXTURE_CALL_GRADS );

//Get position in pixel space and blend %
	
	vec2 uv_in_pixel_space =  uv *Texture_size1;


vec2 sub_pixel_position=fract(uv_in_pixel_space);
uv = floor(uv_in_pixel_space)* pixel_size_in_atlas_space;




 
//setup distance fade
float iTEXDIST=1.0/TEXTURE_FILTERING_DISTANCE_CPF;
float iTEXFADE=1.0/TEXTURE_FILTER_FADE_CPF;
//apply that softness to sub_pixel_position
vec2 sharpness = clamp((sub_pixel_position-(1.-TEXTURE_BLEND_SOFTNESS_CPF))/(TEXTURE_BLEND_SOFTNESS_CPF),0.,1.);
//apply distance fade
float distfade = clamp((dist-(TEXTURE_FILTERING_DISTANCE_CPF-TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF))/(TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF),0.,1.);
sub_pixel_position*=(sharpness);//
sub_pixel_position = clamp(sub_pixel_position*(1.-distfade)+distfade*0.,0.,1.);
 
 

 
 	#if UPSCALE_RESOLUTION_CPF == 1
	#else
	//limit upscale resolution
	sub_pixel_position= floor(sub_pixel_position*UPSCALE_RESOLUTION_CPF )/ UPSCALE_RESOLUTION_CPF ;
	#endif


//cut off 
float bx = uv.x < QUAD_TEXTURE_POSITION_COMPONENT.x + QUAD_TEXTURE_SIZE_COMPONENT.x
	* (1.+ 0.*Ctm_pom_fix_margin)  -pixel_size_in_atlas_space.x*1.5
	?1.0:0.0;
float by = uv.y < QUAD_TEXTURE_POSITION_COMPONENT.y + QUAD_TEXTURE_SIZE_COMPONENT.y
	* (1.+ 0.*Ctm_pom_fix_margin)  -pixel_size_in_atlas_space.y*1.5
	?1.0:0.0;



//Get data
#if FAST_TEX_READS_CPF == 1

	vec4 a = ALBEDO_TEXTURE_CALL_PREFIX_FAST uv ,0);//TEXTURE_CALL_SUFFIX_FAST;
	vec4 b = ALBEDO_TEXTURE_CALL_PREFIX_FAST (uv + vec2( pixel_size_in_atlas_space.x * bx, 0.0)),0);// TEXTURE_CALL_SUFFIX_FAST;
	vec4 c = ALBEDO_TEXTURE_CALL_PREFIX_FAST (uv + vec2( 0.0, pixel_size_in_atlas_space.y * by)) ,0);//TEXTURE_CALL_SUFFIX_FAST;
	vec4 d = ALBEDO_TEXTURE_CALL_PREFIX_FAST (uv + vec2( pixel_size_in_atlas_space.x * bx, pixel_size_in_atlas_space.y * by)),0);// TEXTURE_CALL_SUFFIX_FAST;

#else
	vec4 a = ALBEDO_TEXTURE_CALL_PREFIX uv TEXTURE_CALL_GRADS );
	vec4 b = ALBEDO_TEXTURE_CALL_PREFIX uv + vec2( pixel_size_in_atlas_space.x * bx, 0.0) TEXTURE_CALL_GRADS );
	vec4 c = ALBEDO_TEXTURE_CALL_PREFIX (uv + vec2( 0.0, pixel_size_in_atlas_space.y * by))TEXTURE_CALL_GRADS  );
	vec4 d = ALBEDO_TEXTURE_CALL_PREFIX (uv + vec2( pixel_size_in_atlas_space.x * bx, pixel_size_in_atlas_space.y * by)) TEXTURE_CALL_GRADS );
#endif

//return vec4(a.a);//debug
//return vec4(vlocal_uv.st,0.,1.);//debug

alphas = vec4(a.a,b.a,c.a,d.a);
max_alpha = vec2(
min(min(a.a,b.a),min(c.a,d.a)),
max(max(a.a,b.a),max(c.a,d.a))
);


#if TEXTURE_FILTERING_CPF == 1 || TEXTURE_FILTERING_CPF == 10 || TEXTURE_FILTERING_CPF == 12

//Blend data, return
a= blend_with_alpha_cpf_old( blend_with_alpha_cpf_old(a,b,sub_pixel_position.x), blend_with_alpha_cpf_old(c,d,sub_pixel_position.x), sub_pixel_position.y);
#if HARD_ALPHA == 1
a.a=a.a>= ALPHA_CUTOFF_CPF ?max_alpha.y:max_alpha.x;
#endif

return a;
#endif

#if TEXTURE_FILTERING_CPF == 2 
//Blend data, return
a= adaptive_contrast_bilinear_filter_cpf(a,b,c,d,sub_pixel_position);
#if HARD_ALPHA == 1
a.a=a.a>= ALPHA_CUTOFF_CPF ?max_alpha.y:max_alpha.x;
#endif
return a;
#endif

#if TEXTURE_FILTERING_CPF == 3 || TEXTURE_FILTERING_CPF == 4
//Blend data, return
a= double_hawk_blend_cpf(a,b,c,d,sub_pixel_position);
#if HARD_ALPHA == 1
	a.a=a.a>= ALPHA_CUTOFF_CPF ?max_alpha.y:max_alpha.x;
#endif

return a;
#endif


#if TEXTURE_FILTERING_CPF == 5
//Blend data, return

//Blend data, return

vec4 f = blend_with_alpha_cpf_old( blend_with_alpha_cpf_old(a,b,sub_pixel_position.x), blend_with_alpha_cpf_old(c,d,sub_pixel_position.x), sub_pixel_position.y);

#if HARD_ALPHA == 1
	f.a = f.a>= ALPHA_CUTOFF_CPF ?max_alpha.y:max_alpha.x;
#endif
//crisp
//get closest color
 float ap = distance(f,a);//+ 1-a.a;
 float bp = distance(f,b);//+ 1-b.a;;
float  cp = distance(f,c);//+ 1-c.a;;
float  dp = distance(f,d);//+ 1-d.a;;


//sort
vec4 o1 = ap < bp ? a: b;
vec4 o2 = cp < dp? c: d;
float o1d = ap < bp ? ap: bp;
float o2d = cp < dp? cp: dp;

return o1d<o2d?o1:o2;

#endif

#if TEXTURE_FILTERING_CPF == 6
//Blend data, return
//Blend data, return
//rounded subpixel blend 
float ap = a.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(0.0,0.0)),0.,1.):0.;
float bp = b.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(1.,0.)),0.,1.):0.;
float cp = c.a > ALPHA_CUTOFF_CPF ? clamp( 1-distance(sub_pixel_position,vec2(0.,1.)),0.,1.):0.;
float dp = d.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(1.,1.)),0.,1.):0.;

if (ap+bp+cp+dp == 0. ) return vec4(0.,0.,0.,0.);
vec4 f =  (a*ap+b*bp+c*cp+d*dp)/(ap+bp+cp+dp);

//f.a = f.a>= ALPHA_CUTOFF_CPF ? 1:0;

//crisp
//get closest color
 ap = distance(f,a);
 bp = distance(f,b);
 cp = distance(f,c);
 dp = distance(f,d);
//sort
vec4 o1 = ap < bp ? a: b;
vec4 o2 = cp < dp? c: d;
float o1d = ap < bp ? ap: bp;
float o2d = cp < dp? cp: dp;
return o1d<o2d?o1:o2;

#endif

#if TEXTURE_FILTERING_CPF == 7 
//Blend data, return
//rounded subpixel blend 
float ap = a.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(0.0,0.0)),0,1):0;
float bp = b.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(1,0)),0,1):0;
float cp = c.a > ALPHA_CUTOFF_CPF ? clamp( 1-distance(sub_pixel_position,vec2(0,1)),0,1):0;
float dp = d.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(1,1)),0,1):0;

if (ap+bp+cp+dp == 0. ) return vec4(0.,0.,0.,0.);
a =  (a*ap+b*bp+c*cp+d*dp)/(ap+bp+cp+dp);
a.a = a.a>= ALPHA_CUTOFF_CPF ? 1.:0.;

//if(abs(sub_pixel_position.x -.5)>.49 || abs(sub_pixel_position.y -.5)>.49) return vec4(0.,0.,0.,1.); //debug grid

return a;
#endif

#if TEXTURE_FILTERING_CPF == 8
//Blend data, return

//Blend data, return

vec4 f = blend_with_alpha_cpf_old( blend_with_alpha_cpf_old(a,b,sub_pixel_position.x), blend_with_alpha_cpf_old(c,d,sub_pixel_position.x), sub_pixel_position.y);

#if HARD_ALPHA == 1
	f.a = f.a>= ALPHA_CUTOFF_CPF ?max_alpha.y:max_alpha.x;
#endif
//crisp
//get closest color
 float ap = distance(f,a);//+ 1-a.a;
 float bp = distance(f,b);//+ 1-b.a;;
float  cp = distance(f,c);//+ 1-c.a;;
float  dp = distance(f,d);//+ 1-d.a;;


//sort
vec4 o1 = ap < bp ? a: b;
vec4 o2 = cp < dp? c: d;
float o1d = ap < bp ? ap: bp;
float o2d = cp < dp? cp: dp;

vec4 sofar= o1d<o2d?o1:o2;

//Blend data, return
vec4 aa= blend_with_alpha_cpf_old( blend_with_alpha_cpf_old(a,b,sub_pixel_position.x), blend_with_alpha_cpf_old(c,d,sub_pixel_position.x), sub_pixel_position.y);

return mix(aa,sofar,pow(distance(a,aa)/1.41,1.));

#endif

#if TEXTURE_FILTERING_CPF == 9
//Blend data, return
vec4 aaa= double_hawk_blend_cpf(a,b,c,d,sub_pixel_position);


//Blend data, return
vec4 aa= 
	//adaptive_contrast_bilinear_filter_cpf(a,b,c,d,sub_pixel_position);
	blend_with_alpha_cpf_old( blend_with_alpha_cpf_old(a,b,sub_pixel_position.x), blend_with_alpha_cpf_old(c,d,sub_pixel_position.x), sub_pixel_position.y);

aaa= mix(aa,aaa,smooth_c(pow(min(1.,distance(a,aa)),1.)));
#if HARD_ALPHA == 1
	aaa.a=aaa.a>= ALPHA_CUTOFF_CPF ?max_alpha.y:max_alpha.x;
#endif
return aaa;

#endif

//debug
return  ALBEDO_TEXTURE_CALL_PREFIX uv TEXTURE_CALL_GRADS );
#if DEBUGGING_BLEND1 == 1
//debug
#endif
//debug

}//Func




vec4 atlas_uv_to_bilinear_data_specular(in vec2 uv, in float dist, in vec4 alphas)
{



#if defined SKIP_TEX_FILTERING_CPF
return  TEXTURE_CALL_PREFIX SPECULAR_TEXTURE_SAMPLER ,  uv TEXTURE_CALL_GRADS );
#endif

if(	dist > TEXTURE_FILTERING_DISTANCE_CPF  || abs(Material_id-20001.)<.5 ) return   TEXTURE_CALL_PREFIX SPECULAR_TEXTURE_SAMPLER ,  uv TEXTURE_CALL_GRADS );

//Get position in pixel space and blend %
vec2 uv_in_pixel_space =  uv *Texture_size1;
vec2 sub_pixel_position=fract(uv_in_pixel_space);
uv = floor(uv_in_pixel_space)* pixel_size_in_atlas_space;

//setup distance fade
float iTEXDIST=1.0/TEXTURE_FILTERING_DISTANCE_CPF;
float iTEXFADE=1.0/TEXTURE_FILTER_FADE_CPF;
//apply that softness to sub_pixel_position
vec2 sharpness = clamp((sub_pixel_position-(1-TEXTURE_BLEND_SOFTNESS_CPF))/(TEXTURE_BLEND_SOFTNESS_CPF),0,1);
//apply distance fade
float distfade = clamp((dist-(TEXTURE_FILTERING_DISTANCE_CPF-TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF))/(TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF),0,1);
sub_pixel_position*=(sharpness);//
sub_pixel_position=clamp(sub_pixel_position*(1.-distfade)+distfade*0.,0.,1.);
 
 	#if UPSCALE_RESOLUTION_CPF == 1
	#else
	//limit upscale resolution
	sub_pixel_position= floor(sub_pixel_position*UPSCALE_RESOLUTION_CPF )/ UPSCALE_RESOLUTION_CPF ;
	#endif

//cut off QUAD_TEXTURE_SIZE_COMPONENT vtexcoordam.pq  QUAD_TEXTURE_POSITION_COMPONENT vtexcoordam.st 
float bx = uv.x < QUAD_TEXTURE_POSITION_COMPONENT.x + QUAD_TEXTURE_SIZE_COMPONENT.x * (1+ Ctm_pom_fix_margin)  -pixel_size_in_atlas_space.x?1.0:0.0;
float by = uv.y < QUAD_TEXTURE_POSITION_COMPONENT.y + QUAD_TEXTURE_SIZE_COMPONENT.y * (1+ Ctm_pom_fix_margin)  -pixel_size_in_atlas_space.y?1.0:0.0;

//Get data
vec4 a = TEXTURE_CALL_PREFIX SPECULAR_TEXTURE_SAMPLER ,  uv TEXTURE_CALL_GRADS );
vec4 b = TEXTURE_CALL_PREFIX SPECULAR_TEXTURE_SAMPLER ,  uv + vec2( pixel_size_in_atlas_space.x*bx, 0.0) TEXTURE_CALL_GRADS );
vec4 c = TEXTURE_CALL_PREFIX SPECULAR_TEXTURE_SAMPLER ,  (uv + vec2( 0.0, pixel_size_in_atlas_space.y*by))TEXTURE_CALL_GRADS  );
vec4 d = TEXTURE_CALL_PREFIX SPECULAR_TEXTURE_SAMPLER , (uv + vec2( pixel_size_in_atlas_space.x*bx,pixel_size_in_atlas_space.y*by)) TEXTURE_CALL_GRADS );




//spec overlap
#if DEBUG_TEX_EMISSIVE == 1
a.a=a.a>=254.5/255.? 0. : a.a;
b.a=b.a>=254.5/255.? 0. : b.a;
c.a=c.a>=254.5/255.? 0. : c.a;
d.a=d.a>=254.5/255.? 0. : d.a;
#endif

//pbr_conflict 2024-9-22
#define RESPECT_PBR_EDGES 1
#if RESPECT_PBR_EDGES == 1
if(a.g >= Metal)
{
	b.g=b.g<Metal ? a.g : b.g;
	c.g=c.g<Metal? a.g : c.g;
	d.g=d.g<Metal? a.g : d.g;
}else{
	b.g=b.g>=Metal? a.g : b.g;
	c.g=c.g>=Metal? a.g : c.g;
	d.g=d.g>=Metal? a.g : d.g;
}
#endif
//

//hcm p1
//float hcm = a.g;

#if TEXTURE_FILTERING_CPF == 7 
//Blend data, return
//rounded subpixel blend 
float ap = a.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(0.0,0.0)),0,1):0;
float bp = b.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(1,0)),0,1):0;
float cp = c.a > ALPHA_CUTOFF_CPF ? clamp( 1-distance(sub_pixel_position,vec2(0,1)),0,1):0;
float dp = d.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(1,1)),0,1):0;

if (ap+bp+cp+dp == 0 ) return vec4(0,0,0,0);
a =  (a*ap+b*bp+c*cp+d*dp)/(ap+bp+cp+dp);
a.a = a.a>= ALPHA_CUTOFF_CPF ? 1:0;

//if(abs(sub_pixel_position.x -.5)>.49 || abs(sub_pixel_position.y -.5)>.49) return vec4(0,0,0,1); //debug grid

//hcm fix
//a.g=(a.g>230./255.||a.g>230./255.||a.g>230./255.||a.g>230./255.)?hcm:a.g;

return a;
#else
//Blend data, return
vec4 bb =  blend_with_external_alpha_cpf(
blend_with_external_alpha_cpf(a,b,sub_pixel_position.x, alphas.xy),
blend_with_external_alpha_cpf(c,d,sub_pixel_position.x, alphas.zw),
sub_pixel_position.y, alphas.xz);

bb.a = a.a;
return bb;

//return mix( mix(a,b,sub_pixel_position.x), mix(c,d,sub_pixel_position.x), sub_pixel_position.y);



#endif




}//Func




vec4 atlas_uv_to_bilinear_data_normal(in vec2 uv, in float dist)
{

#if defined SKIP_TEX_FILTERING_CPF
return  TEXTURE_CALL_PREFIX NORMAL_TEXTURE_SAMPLER ,  uv TEXTURE_CALL_GRADS );
#endif

if(	dist > TEXTURE_FILTERING_DISTANCE_CPF  || abs(Material_id-20001.)<.5 ) return  TEXTURE_CALL_PREFIX NORMAL_TEXTURE_SAMPLER ,  uv TEXTURE_CALL_GRADS );

//Get position in pixel space and blend %
vec2 uv_in_pixel_space =  uv *Texture_size1;
vec2 sub_pixel_position=fract(uv_in_pixel_space);
 
uv = floor(uv_in_pixel_space)* pixel_size_in_atlas_space;

//setup distance fade
float iTEXDIST=1.0/TEXTURE_FILTERING_DISTANCE_CPF;
float iTEXFADE=1.0/TEXTURE_FILTER_FADE_CPF;
//apply that softness to sub_pixel_position
vec2 sharpness = clamp((sub_pixel_position-(1-TEXTURE_BLEND_SOFTNESS_CPF))/(TEXTURE_BLEND_SOFTNESS_CPF),0,1);
//apply distance fade
float distfade = clamp((dist-(TEXTURE_FILTERING_DISTANCE_CPF-TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF))/(TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF),0,1);
sub_pixel_position*=(sharpness);//
sub_pixel_position=clamp(sub_pixel_position*(1-distfade)+distfade*0,0,1);

 	#if UPSCALE_RESOLUTION_CPF == 1
	#else
	//limit upscale resolution
	sub_pixel_position= floor(sub_pixel_position*UPSCALE_RESOLUTION_CPF )/ UPSCALE_RESOLUTION_CPF ;
	#endif

//cut off QUAD_TEXTURE_SIZE_COMPONENT vtexcoordam.pq  QUAD_TEXTURE_POSITION_COMPONENT vtexcoordam.st 
float bx = uv.x < QUAD_TEXTURE_POSITION_COMPONENT.x + QUAD_TEXTURE_SIZE_COMPONENT.x * (1+ Ctm_pom_fix_margin)  -pixel_size_in_atlas_space.x?1.0:0.0;
float by = uv.y < QUAD_TEXTURE_POSITION_COMPONENT.y + QUAD_TEXTURE_SIZE_COMPONENT.y * (1+ Ctm_pom_fix_margin)  -pixel_size_in_atlas_space.y?1.0:0.0;

//Get data
vec4 a = TEXTURE_CALL_PREFIX NORMAL_TEXTURE_SAMPLER ,  uv TEXTURE_CALL_GRADS );
vec4 b = TEXTURE_CALL_PREFIX NORMAL_TEXTURE_SAMPLER ,  uv + vec2( pixel_size_in_atlas_space.x*bx, 0.0) TEXTURE_CALL_GRADS );
vec4 c = TEXTURE_CALL_PREFIX NORMAL_TEXTURE_SAMPLER ,  (uv + vec2( 0.0, pixel_size_in_atlas_space.y*by))TEXTURE_CALL_GRADS  );
vec4 d = TEXTURE_CALL_PREFIX NORMAL_TEXTURE_SAMPLER , (uv + vec2( pixel_size_in_atlas_space.x*bx,pixel_size_in_atlas_space.y*by)) TEXTURE_CALL_GRADS );

#if TEXTURE_FILTERING_CPF == 7 
//Blend data, return
//rounded subpixel blend 
float ap = a.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(0.0,0.0)),0,1):0;
float bp = b.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(1,0)),0,1):0;
float cp = c.a > ALPHA_CUTOFF_CPF ? clamp( 1-distance(sub_pixel_position,vec2(0,1)),0,1):0;
float dp = d.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(1,1)),0,1):0;

if (ap+bp+cp+dp == 0 ) return vec4(0,0,0,0);
a =  (a*ap+b*bp+c*cp+d*dp)/(ap+bp+cp+dp);
a.a = a.a>= ALPHA_CUTOFF_CPF ? 1:0;

//if(abs(sub_pixel_position.x -.5)>.49 || abs(sub_pixel_position.y -.5)>.49) return vec4(0,0,0,1); //debug grid

return a;
#else
//Blend data, return
return mix( mix(a,b,sub_pixel_position.x), mix(c,d,sub_pixel_position.x), sub_pixel_position.y);

#endif




}//Func



vec4 atlas_uv_to_quick_bilinear(in vec2 uv, in float dist)  //2024-6
{




//if(	dist > TEXTURE_FILTERING_DISTANCE_CPF ) return  ALBEDO_TEXTURE_CALL_PREFIX uv TEXTURE_CALL_GRADS );

//Get position in pixel space and blend %
vec2 uv_in_pixel_space =  uv *Texture_size1;
vec2 sub_pixel_position=fract(uv_in_pixel_space);
uv = floor(uv_in_pixel_space)* pixel_size_in_atlas_space;




 
//setup distance fade
float iTEXDIST=1.0/TEXTURE_FILTERING_DISTANCE_CPF;
float iTEXFADE=1.0/TEXTURE_FILTER_FADE_CPF;
//apply that softness to sub_pixel_position
vec2 sharpness = clamp((sub_pixel_position-(1-BLEND_PIXELS_SOFTNESS))/(BLEND_PIXELS_SOFTNESS),0,1);
sub_pixel_position*=(sharpness);//

/*
//apply distance fade
float distfade = clamp((dist-(TEXTURE_FILTERING_DISTANCE_CPF-TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF))/(TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF),0,1);
sub_pixel_position = clamp(sub_pixel_position*(1-distfade)+distfade*0,0,1);
*/
 


//cut off 
float bx = uv.x < QUAD_TEXTURE_POSITION_COMPONENT.x + QUAD_TEXTURE_SIZE_COMPONENT.x * (1.+ Ctm_pom_fix_margin) -pixel_size_in_atlas_space.x*1.5?1.0:0.0;
float by = uv.y < QUAD_TEXTURE_POSITION_COMPONENT.y + QUAD_TEXTURE_SIZE_COMPONENT.y * (1.+ Ctm_pom_fix_margin)  -pixel_size_in_atlas_space.y*1.5?1.0:0.0;

//Get data
#if FAST_TEX_READS_CPF == 1

	vec4 a = ALBEDO_TEXTURE_CALL_PREFIX_FAST uv ,0);//TEXTURE_CALL_SUFFIX_FAST;
	vec4 b = ALBEDO_TEXTURE_CALL_PREFIX_FAST (uv + vec2( pixel_size_in_atlas_space.x * bx, 0.0)),0);// TEXTURE_CALL_SUFFIX_FAST;
	vec4 c = ALBEDO_TEXTURE_CALL_PREFIX_FAST (uv + vec2( 0.0, pixel_size_in_atlas_space.y * by)) ,0);//TEXTURE_CALL_SUFFIX_FAST;
	vec4 d = ALBEDO_TEXTURE_CALL_PREFIX_FAST (uv + vec2( pixel_size_in_atlas_space.x * bx, pixel_size_in_atlas_space.y * by)),0);// TEXTURE_CALL_SUFFIX_FAST;

#else
	vec4 a = ALBEDO_TEXTURE_CALL_PREFIX uv TEXTURE_CALL_GRADS );
	vec4 b = ALBEDO_TEXTURE_CALL_PREFIX uv + vec2( pixel_size_in_atlas_space.x * bx, 0.0) TEXTURE_CALL_GRADS );
	vec4 c = ALBEDO_TEXTURE_CALL_PREFIX (uv + vec2( 0.0, pixel_size_in_atlas_space.y * by))TEXTURE_CALL_GRADS  );
	vec4 d = ALBEDO_TEXTURE_CALL_PREFIX (uv + vec2( pixel_size_in_atlas_space.x * bx, pixel_size_in_atlas_space.y * by)) TEXTURE_CALL_GRADS );
#endif



//Blend data, return
a= blend_with_alpha_cpf( blend_with_alpha_cpf(a,b,sub_pixel_position.x), blend_with_alpha_cpf(c,d,sub_pixel_position.x), sub_pixel_position.y);
a.a=a.a>= ALPHA_CUTOFF_CPF ?1:0;

return a;

a.a=(a.r+a.g+a.b)*.333*a.a;
b.a=(b.r+b.g+b.b)*.333*b.a;
c.a=(c.r+c.g+c.b)*.333*c.a;
vec4 n;
n.r=clamp((a.a-b.a)*3.,0.,1.)*.5+.5;
n.g=clamp((a.a-c.a)*3.,0.,1.)*.5+.5;
n.b=1.;
n.a=1.;
return a;

}//Func


//#if DEBUG_55 == 2



vec4 atlas_uv_to_generated_normals(in vec2 uv, in float dist)  //2024-6
{




//if(	dist > TEXTURE_FILTERING_DISTANCE_CPF ) return  ALBEDO_TEXTURE_CALL_PREFIX uv TEXTURE_CALL_GRADS );

//Get position in pixel space and blend %
vec2 uv_in_pixel_space =  uv *Texture_size1;
vec2 sub_pixel_position=fract(uv_in_pixel_space);
uv = floor(uv_in_pixel_space)* pixel_size_in_atlas_space;




 
//setup distance fade
float iTEXDIST=1.0/TEXTURE_FILTERING_DISTANCE_CPF;
float iTEXFADE=1.0/TEXTURE_FILTER_FADE_CPF;
//apply that softness to sub_pixel_position
vec2 sharpness = clamp((sub_pixel_position-(1-TEXTURE_BLEND_SOFTNESS_CPF))/(TEXTURE_BLEND_SOFTNESS_CPF),0,1);
sub_pixel_position*=(sharpness);//

/*
//apply distance fade
float distfade = clamp((dist-(TEXTURE_FILTERING_DISTANCE_CPF-TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF))/(TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF),0,1);
sub_pixel_position = clamp(sub_pixel_position*(1-distfade)+distfade*0,0,1);
*/
 


//cut off 
float bx = uv.x < QUAD_TEXTURE_POSITION_COMPONENT.x + QUAD_TEXTURE_SIZE_COMPONENT.x * (1.+ Ctm_pom_fix_margin) -pixel_size_in_atlas_space.x*1.5?1.0:0.0;
float by = uv.y < QUAD_TEXTURE_POSITION_COMPONENT.y + QUAD_TEXTURE_SIZE_COMPONENT.y * (1.+ Ctm_pom_fix_margin)  -pixel_size_in_atlas_space.y*1.5?1.0:0.0;

//Get data
#if FAST_TEX_READS_CPF == 1

	vec4 a = ALBEDO_TEXTURE_CALL_PREFIX_FAST uv ,0);//TEXTURE_CALL_SUFFIX_FAST;
	vec4 b = ALBEDO_TEXTURE_CALL_PREFIX_FAST (uv + vec2( pixel_size_in_atlas_space.x * bx, 0.0)),0);// TEXTURE_CALL_SUFFIX_FAST;
	vec4 c = ALBEDO_TEXTURE_CALL_PREFIX_FAST (uv + vec2( 0.0, pixel_size_in_atlas_space.y * by)) ,0);//TEXTURE_CALL_SUFFIX_FAST;
	vec4 d = ALBEDO_TEXTURE_CALL_PREFIX_FAST (uv + vec2( pixel_size_in_atlas_space.x * bx, pixel_size_in_atlas_space.y * by)),0);// TEXTURE_CALL_SUFFIX_FAST;

#else
	vec4 a = ALBEDO_TEXTURE_CALL_PREFIX uv TEXTURE_CALL_GRADS );
	vec4 b = ALBEDO_TEXTURE_CALL_PREFIX uv + vec2( pixel_size_in_atlas_space.x * bx, 0.0) TEXTURE_CALL_GRADS );
	vec4 c = ALBEDO_TEXTURE_CALL_PREFIX (uv + vec2( 0.0, pixel_size_in_atlas_space.y * by))TEXTURE_CALL_GRADS  );
	vec4 d = ALBEDO_TEXTURE_CALL_PREFIX (uv + vec2( pixel_size_in_atlas_space.x * bx, pixel_size_in_atlas_space.y * by)) TEXTURE_CALL_GRADS );
	#if GEN_NORMAL_MAP == 4
		vec4 lx = ALBEDO_TEXTURE_CALL_PREFIX (uv + vec2( pixel_size_in_atlas_space.x *2.0, pixel_size_in_atlas_space.y * by)) TEXTURE_CALL_GRADS );
		vec4 ly = ALBEDO_TEXTURE_CALL_PREFIX (uv + vec2( pixel_size_in_atlas_space.x *2.0, pixel_size_in_atlas_space.y * by)) TEXTURE_CALL_GRADS );
		vec4 vx = ALBEDO_TEXTURE_CALL_PREFIX (uv + vec2( pixel_size_in_atlas_space.x *2.0, pixel_size_in_atlas_space.y * 2.)) TEXTURE_CALL_GRADS );
		vec4 vy = ALBEDO_TEXTURE_CALL_PREFIX (uv + vec2( pixel_size_in_atlas_space.x *2.0, pixel_size_in_atlas_space.y * 2.)) TEXTURE_CALL_GRADS );
	#endif
#endif



#if TEXTURE_FILTERING_CPF == 11111 
//Blend data, return
a= blend_with_alpha_cpf( blend_with_alpha_cpf(a,b,sub_pixel_position.x), blend_with_alpha_cpf(c,d,sub_pixel_position.x), sub_pixel_position.y);
a.a=a.a>= ALPHA_CUTOFF_CPF ?1:0;
return a;
#endif

#if TEXTURE_FILTERING_CPF == 2222
//Blend data, return
a= adaptive_contrast_bilinear_filter_cpf(a,b,c,d,sub_pixel_position);
a.a=a.a>= ALPHA_CUTOFF_CPF ?1:0;
return a;
#endif

a.a=(a.r+a.g+a.b)*.333*a.a;
b.a=(b.r+b.g+b.b)*.333*b.a;
c.a=(c.r+c.g+c.b)*.333*c.a;
d.a=(d.r+d.g+d.b)*.333*d.a;
vec4 n;



n.r=clamp( 
	#if GEN_NORMAL_MAP == 1
		(a.a-b.a)
	#endif
	#if GEN_NORMAL_MAP == 2 ||  GEN_NORMAL_MAP == 3
		mix(a.a-b.a,c.a-d.a,sub_pixel_position.y)
	#endif
	#if GEN_NORMAL_MAP == 0
		0.
	#endif
	
	* G_NORM_MAP_STR
	//+(fract(sin(floor(sub_pixel_position.x*64.)/64.*31478.6+floor(sub_pixel_position.y*64.)/64.*2138.))-.5)
	//+(noise3(floor(sub_pixel_position*G_NORM_SP_RES)/	G_NORM_SP_RES)-.5) * G_NORM_MAP_SUB_PIXEL_STR
	//+sin(sub_pixel_position.y)*.2
	#if GEN_NORMAL_MAP == 3
		*distance(sub_pixel_position,vec2(0.5))
	#endif
	,-1.,1.)*.5+.5;
	
	
	
	
n.g=clamp( 
	#if GEN_NORMAL_MAP == 1
		(a.a-c.a)
	#endif
	#if GEN_NORMAL_MAP == 2 ||  GEN_NORMAL_MAP == 3
		mix(a.a-c.a,b.a-d.a,sub_pixel_position.x)
	#endif
	#if GEN_NORMAL_MAP == 0
		0.
	#endif
	
	* G_NORM_MAP_STR
	//+(fract(sin(floor(sub_pixel_position.y*64.)/64.*31478.6+floor(sub_pixel_position.x*64.)/64.*2138.))-.5)
	//+(noise3(floor(sub_pixel_position*G_NORM_SP_RES)/G_NORM_SP_RES)-.5) * G_NORM_MAP_SUB_PIXEL_STR
	//+sin(sub_pixel_position.y)*.2
	#if GEN_NORMAL_MAP == 3
		*distance(sub_pixel_position,vec2(0.5))
	#endif

	
	,-1.,1.)*.5+.5;
//n.g=clamp((a.a-c.a)*5.,0.,1.)*.5+.5;
n.b=1.;
n.a=1.;



return n;



}//Func


float mixf(in float f, in float f2, in float f3)
{
return f*(1-f3)+f2*f3;
}

vec4 atlas_uv_to_bilinear_data_normal_2h(in vec2 uv, in float dist)
{

if(	dist > TEXTURE_FILTERING_DISTANCE_CPF ) return  TEXTURE_CALL_PREFIX NORMAL_TEXTURE_SAMPLER ,  uv TEXTURE_CALL_GRADS );


//Get position in pixel space and blend %
vec2 uv_in_pixel_space =  uv *Texture_size1;
vec2 sub_pixel_position=fract(uv_in_pixel_space);
 
uv = floor(uv_in_pixel_space)* pixel_size_in_atlas_space;


 
 	#if UPSCALE_RESOLUTION_CPF == 1 ||  POM_STYLE_CPF == 2
	#else
	//setup distance fade
float iTEXDIST=1.0/TEXTURE_FILTERING_DISTANCE_CPF;
float iTEXFADE=1.0/TEXTURE_FILTER_FADE_CPF;
//apply that softness to sub_pixel_position
vec2 sharpness = clamp((sub_pixel_position-(1-TEXTURE_BLEND_SOFTNESS_CPF))/(TEXTURE_BLEND_SOFTNESS_CPF),0,1);
//apply distance fade
float distfade = clamp((dist-(TEXTURE_FILTERING_DISTANCE_CPF-TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF))/(TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF),0,1);
sub_pixel_position*=(sharpness);//
sub_pixel_position=clamp(sub_pixel_position*(1-distfade)+distfade*0,0,1);

	//limit upscale resolution
	sub_pixel_position= floor(sub_pixel_position*UPSCALE_RESOLUTION_CPF )/ UPSCALE_RESOLUTION_CPF ;
	#endif

//cut off QUAD_TEXTURE_SIZE_COMPONENT vtexcoordam.pq  QUAD_TEXTURE_POSITION_COMPONENT vtexcoordam.st 
float bx = uv.x < QUAD_TEXTURE_POSITION_COMPONENT.x + QUAD_TEXTURE_SIZE_COMPONENT.x * (1+ Ctm_pom_fix_margin)  -pixel_size_in_atlas_space.x?1.0:0.0;
float by = uv.y < QUAD_TEXTURE_POSITION_COMPONENT.y + QUAD_TEXTURE_SIZE_COMPONENT.y * (1+ Ctm_pom_fix_margin)  -pixel_size_in_atlas_space.y?1.0:0.0;

//Get data
vec4 a = TEXTURE_CALL_PREFIX NORMAL_TEXTURE_SAMPLER ,  uv TEXTURE_CALL_GRADS );
vec4 b = TEXTURE_CALL_PREFIX NORMAL_TEXTURE_SAMPLER ,  uv + vec2( pixel_size_in_atlas_space.x*bx, 0.0) TEXTURE_CALL_GRADS );
vec4 c = TEXTURE_CALL_PREFIX NORMAL_TEXTURE_SAMPLER ,  (uv + vec2( 0.0, pixel_size_in_atlas_space.y*by))TEXTURE_CALL_GRADS  );
vec4 d = TEXTURE_CALL_PREFIX NORMAL_TEXTURE_SAMPLER , (uv + vec2( pixel_size_in_atlas_space.x*bx,pixel_size_in_atlas_space.y*by)) TEXTURE_CALL_GRADS );


//Blend data, return
return mix( mix(a,b,sub_pixel_position.x), mix(c,d,sub_pixel_position.x), sub_pixel_position.y);

}//Func






/*
float atlas_uv_to_bilinear_data_height(in vec2 uv)
{

//if(	textureQueryLod( ALBEDO_TEXTURE_SAMPLER,	coordinate).y >=1)
 //return ALBEDO_TEXTURE_CALL_PREFIX uv ALBEDO_TEXTURE_CALL_SUFFIX;

//Get position in pixel space and blend %
vec2 uv_in_pixel_space =  uv *Texture_size1;
vec2 sub_pixel_position=fract(uv_in_pixel_space);
uv = floor(uv_in_pixel_space)* pixel_size_in_atlas_space;


//setup distance fade
float iTEXDIST=1.0/TEXTURE_FILTERING_DISTANCE_CPF;
float iTEXFADE=1.0/TEXTURE_FILTER_FADE_CPF;
//apply that softness to sub_pixel_position
vec2 sharpness = clamp((sub_pixel_position-(1-TEXTURE_BLEND_SOFTNESS_CPF))/(TEXTURE_BLEND_SOFTNESS_CPF),0,1);
//apply distance fade
float distfade = clamp((dist-(TEXTURE_FILTERING_DISTANCE_CPF-TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF))/(TEXTURE_FILTERING_DISTANCE_CPF*TEXTURE_FILTER_FADE_CPF),0,1);
sub_pixel_position*=(sharpness);//
sub_pixel_position=clamp(sub_pixel_position*(1-distfade)+distfade*0,0,1);
	

 
 	#if UPSCALE_RESOLUTION_CPF == 1
	#else
	//limit upscale resolution
	sub_pixel_position= floor(sub_pixel_position*UPSCALE_RESOLUTION_CPF )/ UPSCALE_RESOLUTION_CPF ;
	#endif


//cut off QUAD_TEXTURE_SIZE_COMPONENT vtexcoordam.pq  QUAD_TEXTURE_POSITION_COMPONENT vtexcoordam.st 
float bx = uv.x < QUAD_TEXTURE_POSITION_COMPONENT.x + QUAD_TEXTURE_SIZE_COMPONENT.x -pixel_size_in_atlas_space.x?1.0:0.0;
float by = uv.y < QUAD_TEXTURE_POSITION_COMPONENT.y + QUAD_TEXTURE_SIZE_COMPONENT.y -pixel_size_in_atlas_space.y?1.0:0.0;

//Get data
  vec4 aa  = 1;//textureGather(NORMAL_TEXTURE_SAMPLER, uv, 4);
float a = aa.r;
float b = aa.g;
float c = aa.b;
float d = aa.a;
//Blend data, return
//debug here

#if TEXTURE_FILTERING_CPF == 7 
//Blend data, return
//rounded subpixel blend 
float ap = a.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(0.0,0.0)),0,1):0;
float bp = b.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(1,0)),0,1):0;
float cp = c.a > ALPHA_CUTOFF_CPF ? clamp( 1-distance(sub_pixel_position,vec2(0,1)),0,1):0;
float dp = d.a > ALPHA_CUTOFF_CPF ? clamp(1-distance(sub_pixel_position,vec2(1,1)),0,1):0;

if (ap+bp+cp+dp == 0 ) return vec4(0,0,0,0);
a =  (a*ap+b*bp+c*cp+d*dp)/(ap+bp+cp+dp);
a.a = a.a>= ALPHA_CUTOFF_CPF ? 1:0;

//if(abs(sub_pixel_position.x -.5)>.49 || abs(sub_pixel_position.y -.5)>.49) return vec4(0,0,0,1); //debug grid

return a;
#else
//Blend data, return
return mix( mix(a,b,sub_pixel_position.x), mix(c,d,sub_pixel_position.x), sub_pixel_position.y);

#endif

}//Func
*/




void bilinear_filter_setupc()
{
	vec2 atlas_size=Texture_size1; //TextureSize( texture ,1);
    pixelsize = 1.0/atlas_size;

}

vec4 bilinear_interpolationc(vec4 a, vec4 b, vec4 c, vec4 d, float xp, float yp)
{
  return mix( mix(a, b, xp), mix(c, d, xp), yp);
 
}

//textureGather( 	gsampler2D sampler,  	vec2 P,  	[int comp]); //get 4 heights
 
// texelFetch( 	gsampler1D sampler,  	int P,	int lod);	//get 1 rgba
  	
  	//vec2 textureSize( 	gsampler2D sampler, int lod);}
//  	vec2 textureQueryLod( 	gsampler1D sampler,	float P); //x = mipmap, y = lod.



#if CTMPOMFIX == 1
//debugging

#endif
//debugging

#if DEBUG_55 == 2
#endif
//debug_55

#endif
//>end if using texture filtering









//EXTRAS


//v1.3


//individual blades of grass

vec3 wavy_grass(in vec3 p) {
    //wavy grass
    float t = 0;//frameTimeCounter;
    vec3 bend;
    bend.x=(1-p.z)* .5*( sin(p.x+p.y*.5+t)+sin(t+.2) );
    bend.y=(1-p.z)* bend.x* sin(t);
    bend.z= 0;//-(abs(bend.x)+ abs(bend.y));
    return bend;
}
vec2 wavy_grass_test(in vec2 p) {
    //wavy grass
    float t = 0;//frameTimeCounter;
    vec2 bend;
    bend.x= .5*( sin(p.x+p.y*.5+t)+sin(t+.2) );
    bend.y= bend.x* sin(t);
    //bend.z= 0;//-(abs(bend.x)+ abs(bend.y));
    return bend;
}

//multilevel pom


//v1.4

//3D animated lava with variations

//diamond material


//v1.5

//3D cube map


//1.6

//full voxel models







//CTMPOMFIX FUNCTIONS
	
	
void checkForCtmPomFixFlag(in vec2 coord)
	{
		#if CTMPOMFIX_VERSION == 0
			Ctm_pom_fix_margin=0.;
			Ctm_pom_fix_mode=0;
		#else
			//this checks the albedo map for flagged pixel values, specifically in the alpha channel. these values change how POM is handled, similar to how metalness is handled in pbr_s textures
			
			//put local coord into texture space and check for flags
			// v1 Core CTMPOMFIX, flag mode 0:
			//defined extra redundant texture margin for pom ray march is an additional 1/16th of visible texture width * (255-a) with a in ranges 0 to 16
			Ctm_pom_fix_margin=15.9375*(1-( ALBEDO_TEXTURE_CALL_FOR_FLAG_CHECK).a);
			//v 1.2+ extra CTMPOMFIX flags and modes ((255-a) with a>16):
			Ctm_pom_fix_mode=roundi(Ctm_pom_fix_margin<1.05?0:(Ctm_pom_fix_margin-1)*16);
			//limit modes to those currently implemented, default to mode 0
			Ctm_pom_fix_mode=Ctm_pom_fix_mode>7?0:Ctm_pom_fix_mode;
			//disregard margin flags over 100%  in case Cutouts use ctmpomfix
			Ctm_pom_fix_margin=Ctm_pom_fix_margin>1?0:Ctm_pom_fix_margin;
		#endif
	}//func
	
		vec4 checkForCtmPomFixFlag_return(in vec2 coord)
	{
		
		//this checks the albedo map for flagged pixel values, specifically in the alpha channel. these values change how POM is handled, similar to how metalness is handled in pbr_s textures
		
		//put local coord into texture space and check for flags
		// v1 Core CTMPOMFIX, flag mode 0:
		//defined extra redundant texture margin for pom ray march is an additional 1/16th of visible texture width * (255-a) with a in ranges 0 to 16
		vec4 albedo=ALBEDO_TEXTURE_CALL_FOR_FLAG_CHECK;
		#if CTMPOMFIX_VERSION == 0
			Ctm_pom_fix_margin=0.;
			Ctm_pom_fix_mode=0;
		#else
			Ctm_pom_fix_margin=15.9375*(1-albedo.a);
			//v 1.2+ extra CTMPOMFIX flags and modes ((255-a) with a>16):
			Ctm_pom_fix_mode=roundi(Ctm_pom_fix_margin<1.05?0:(Ctm_pom_fix_margin-1)*16);
			//limit modes to those currently implemented, default to mode 0
			Ctm_pom_fix_mode=Ctm_pom_fix_mode>7?0:Ctm_pom_fix_mode;
			//disregard margin flags over 100%  in case Cutouts use ctmpomfix
			Ctm_pom_fix_margin=Ctm_pom_fix_margin>1?0:Ctm_pom_fix_margin;
		#endif
		return albedo;
	}//func
	
	
//the following function has 2 variations, to accomodate certain pom modes without branching

//for height checking normal maps in pom raymarch
vec2 fract_ctmpomfix_h(in vec2 v)
{
	#if VERY_OLD_MC == 1
	//alternate pom tiling functiionalities to change pom raymarch behavior
	if(Ctm_pom_fix_mode == 0)
	{
//case 0://ctmpomfix core
//this is a safely dynamically wider tiling for the pom raymarch
v.x= v.x<0-Ctm_pom_fix_margin?v.x+1+Ctm_pom_fix_margin*2:v.x>=1+Ctm_pom_fix_margin?v.x-(1+Ctm_pom_fix_margin*2):v.x;
v.y= v.y<0-Ctm_pom_fix_margin?v.y+1+Ctm_pom_fix_margin*2:v.y>=1+Ctm_pom_fix_margin?v.y-(1+Ctm_pom_fix_margin*2):v.y;

v.x= v.x<0-Ctm_pom_fix_margin?v.x+1+Ctm_pom_fix_margin*2:v.x>=1+Ctm_pom_fix_margin?v.x-(1+Ctm_pom_fix_margin*2):v.x;
v.y= v.y<0-Ctm_pom_fix_margin?v.y+1+Ctm_pom_fix_margin*2:v.y>=1+Ctm_pom_fix_margin?v.y-(1+Ctm_pom_fix_margin*2):v.y;

v.x= v.x<0-Ctm_pom_fix_margin?0-Ctm_pom_fix_margin:v.x>=1+Ctm_pom_fix_margin?1+Ctm_pom_fix_margin:v.x;
v.y= v.y<0-Ctm_pom_fix_margin?0-Ctm_pom_fix_margin:v.y>=1+Ctm_pom_fix_margin?1+Ctm_pom_fix_margin:v.y;
}//break;

//added for v1.2
if(Ctm_pom_fix_mode == 1)
	{//case 1://tile quarter (half distance) twice, then clamp 238
v.x=v.x<0? .5+v.x:v.x>1?.5+(v.x-1):v.x;
v.x=v.x<0? .5+v.x:v.x>1?.5+(v.x-1):v.x;
v.x=v.x<0?0:v.x>1?1:v.x;
v.y=v.y<0? .5+v.y:v.y>1?.5+(v.y-1):v.y;
v.y=v.y<0? .5+v.y:v.y>1?.5+(v.y-1):v.y;
v.y=v.y<0?0:v.y>1?1:v.y;
}//break;
if(Ctm_pom_fix_mode == 2)
	{//case 2://mirror once and clamp 237
v.x=v.x<=0? 0-v.x:v.x>=1?1-(v.x-1):v.x;
v.x=v.x<0?0:v.x>1?1:v.x;
v.y=v.y<=0? 0-v.y:v.y>=1?1-(v.y-1):v.y;
v.y=v.y<0?0:v.y>1?1:v.y;
}//break;
if(Ctm_pom_fix_mode == 3 || Ctm_pom_fix_mode == 5 || Ctm_pom_fix_mode == 6)
	{//case 3://crop and extend (for overlay borders) 236
//case 5://outward corners fix a, tile a 0.5, crop n 234
//case 6://outward corners fix b, tile a 1.0, crop n 233
v.x=v.x<0?0:v.x>1?1:v.x;
v.y=v.y<0?0:v.y>1?1:v.y;
}//break;
if(Ctm_pom_fix_mode == 4)
{//case 4://drop/discard (shaped/contoured edges) 235
if (v.x< 0||v.x>1||v.y<0||v.y>1) discard;
}//break;
if(Ctm_pom_fix_mode == 7)
{//case 7:// 1/8th tile, 232 ##### ALPHA, TELL ME IF YOU USE THIS OR IT MIGHT BE DELETED FROM FUTURE VERSIONS
v.x=v.x<0?0.125+fract_signed_oct(v.x):v.x>1?0.875+fract_signed_oct(v.x):v.x;
v.y=v.y<0?0.125+fract_signed_oct(v.y):v.y>1?0.875+fract_signed_oct(v.y):v.y;
}//break;
//230, 229 reserved as 90% opacity

//in the future:
//fade in pom? requires core vs patch function sets
//maybe single pixel flags instead of using pom_depth_writing for borders. would free albedo.a and allow more data encoding in a single invisible strip
//v1.3 multilevel pom and moving grass
//v1.4 specialty shader flags
//v1.5  cube mapped shapes with full depth
//v1.6 full voxel models in pom space as extra effective lod (dh van pom voxl)
	//}}}}};//switch
	#else
	//alternate pom tiling functiionalities to change pom raymarch behavior
	switch (Ctm_pom_fix_mode)
	{
case 0://ctmpomfix core
//this is a safely dynamically wider tiling for the pom raymarch
v.x= v.x<0-Ctm_pom_fix_margin?v.x+1+Ctm_pom_fix_margin*2:v.x>=1+Ctm_pom_fix_margin?v.x-(1+Ctm_pom_fix_margin*2):v.x;
v.y= v.y<0-Ctm_pom_fix_margin?v.y+1+Ctm_pom_fix_margin*2:v.y>=1+Ctm_pom_fix_margin?v.y-(1+Ctm_pom_fix_margin*2):v.y;

v.x= v.x<0-Ctm_pom_fix_margin?v.x+1+Ctm_pom_fix_margin*2:v.x>=1+Ctm_pom_fix_margin?v.x-(1+Ctm_pom_fix_margin*2):v.x;
v.y= v.y<0-Ctm_pom_fix_margin?v.y+1+Ctm_pom_fix_margin*2:v.y>=1+Ctm_pom_fix_margin?v.y-(1+Ctm_pom_fix_margin*2):v.y;

v.x= v.x<0-Ctm_pom_fix_margin?0-Ctm_pom_fix_margin:v.x>=1+Ctm_pom_fix_margin?1+Ctm_pom_fix_margin:v.x;
v.y= v.y<0-Ctm_pom_fix_margin?0-Ctm_pom_fix_margin:v.y>=1+Ctm_pom_fix_margin?1+Ctm_pom_fix_margin:v.y;
break;

//added for v1.2
case 1://tile quarter (half distance) twice, then clamp 238
v.x=v.x<0? .5+v.x:v.x>1?.5+(v.x-1):v.x;
v.x=v.x<0? .5+v.x:v.x>1?.5+(v.x-1):v.x;
v.x=v.x<0?0:v.x>1?1:v.x;
v.y=v.y<0? .5+v.y:v.y>1?.5+(v.y-1):v.y;
v.y=v.y<0? .5+v.y:v.y>1?.5+(v.y-1):v.y;
v.y=v.y<0?0:v.y>1?1:v.y;
break;
case 2://mirror once and clamp 237
v.x=v.x<=0? 0-v.x:v.x>=1?1-(v.x-1):v.x;
v.x=v.x<0?0:v.x>1?1:v.x;
v.y=v.y<=0? 0-v.y:v.y>=1?1-(v.y-1):v.y;
v.y=v.y<0?0:v.y>1?1:v.y;
break;
case 3://crop and extend (for overlay borders) 236
case 5://outward corners fix a, tile a 0.5, crop n 234
case 6://outward corners fix b, tile a 1.0, crop n 233
v.x=v.x<0?0:v.x>1?1:v.x;
v.y=v.y<0?0:v.y>1?1:v.y;
break;
case 4://drop/discard (shaped/contoured edges) 235
if (v.x< 0||v.x>1||v.y<0||v.y>1) discard;
break;
case 7:// 1/8th tile, 232 ##### ALPHA, TELL ME IF YOU USE THIS OR IT MIGHT BE DELETED FROM FUTURE VERSIONS
v.x=v.x<0?0.125+fract_signed_oct(v.x):v.x>1?0.875+fract_signed_oct(v.x):v.x;
v.y=v.y<0?0.125+fract_signed_oct(v.y):v.y>1?0.875+fract_signed_oct(v.y):v.y;
break;
//230, 229 reserved as 90% opacity

//in the future:
//fade in pom? requires core vs patch function sets
//maybe single pixel flags instead of using pom_depth_writing for borders. would free albedo.a and allow more data encoding in a single invisible strip
//v1.3 multilevel pom and moving grass
//v1.4 specialty shader flags
//v1.5  cube mapped shapes with full depth
//v1.6 full voxel models in pom space as extra effective lod (dh van pom voxl)
	};//switch
	#endif
	
return v;
}//func


//for reading albedo map (and normal map normals, and specular data)
vec2 fract_ctmpomfix_a(in vec2 v)
{
#if VERY_OLD_MC == 1
		//alternate pom tiling functiionalities to change pom raymarch behavior
		if(Ctm_pom_fix_mode == 0||Ctm_pom_fix_mode == 6)
		{
	//case 0://ctmpomfix core
	//this is a safely dynamically wider tiling for the pom raymarch
	//case 6://outward corners fix b, tile a 1.0, crop n 233
	v.x= v.x<0-Ctm_pom_fix_margin?v.x+1+Ctm_pom_fix_margin*2:v.x>=1+Ctm_pom_fix_margin?v.x-(1+Ctm_pom_fix_margin*2):v.x;
	v.y= v.y<0-Ctm_pom_fix_margin?v.y+1+Ctm_pom_fix_margin*2:v.y>=1+Ctm_pom_fix_margin?v.y-(1+Ctm_pom_fix_margin*2):v.y;

	v.x= v.x<0-Ctm_pom_fix_margin?v.x+1+Ctm_pom_fix_margin*2:v.x>=1+Ctm_pom_fix_margin?v.x-(1+Ctm_pom_fix_margin*2):v.x;
	v.y= v.y<0-Ctm_pom_fix_margin?v.y+1+Ctm_pom_fix_margin*2:v.y>=1+Ctm_pom_fix_margin?v.y-(1+Ctm_pom_fix_margin*2):v.y;

	v.x= v.x<0-Ctm_pom_fix_margin?0-Ctm_pom_fix_margin:v.x>=1+Ctm_pom_fix_margin?1+Ctm_pom_fix_margin:v.x;
	v.y= v.y<0-Ctm_pom_fix_margin?0-Ctm_pom_fix_margin:v.y>=1+Ctm_pom_fix_margin?1+Ctm_pom_fix_margin:v.y;
	}//break;

	if(Ctm_pom_fix_mode == 1 || Ctm_pom_fix_mode == 5)
		{
	//added for v1.2
	//case 1://tile quarter (half distance) twice, then clamp 238
	//case 5://outward corners fix a, tile a 0.5, crop n 234
	v.x=v.x<0? .5+v.x:v.x>1?.5+(v.x-1):v.x;
	v.x=v.x<0? .5+v.x:v.x>1?.5+(v.x-1):v.x;
	v.x=v.x<0?0:v.x>1?1:v.x;
	v.y=v.y<0? .5+v.y:v.y>1?.5+(v.y-1):v.y;
	v.y=v.y<0? .5+v.y:v.y>1?.5+(v.y-1):v.y;
	v.y=v.y<0?0:v.y>1?1:v.y;
	}//break;
	if(Ctm_pom_fix_mode == 2)
		{
	//case 2://mirror once and clamp 237
	v.x=v.x<=0? 0-v.x:v.x>=1?1-(v.x-1):v.x;
	v.x=v.x<0?0:v.x>1?1:v.x;
	v.y=v.y<=0? 0-v.y:v.y>=1?1-(v.y-1):v.y;
	v.y=v.y<0?0:v.y>1?1:v.y;
	}//break;
	if(Ctm_pom_fix_mode == 3)
		{//case 3://crop and extend (for overlay borders) 236
	v.x=v.x<0?0:v.x>1?1:v.x;
	v.y=v.y<0?0:v.y>1?1:v.y;
	}//break;
	if(Ctm_pom_fix_mode == 4)
		{//case 4://drop/discard (shaped/contoured edges) 235
	if (v.x< 0||v.x>1||v.y<0||v.y>1) discard;
	}//break;
	if(Ctm_pom_fix_mode == 7)
		{//case 7:// 1/8th tile, 232 ##### ALPHA, TELL ME IF YOU USE THIS OR IT MIGHT BE DELETED FROM FUTURE VERSIONS
	v.x=v.x<0?0.125+fract_signed_oct(v.x):v.x>1?0.875+fract_signed_oct(v.x):v.x;
	v.y=v.y<0?0.125+fract_signed_oct(v.y):v.y>1?0.875+fract_signed_oct(v.y):v.y;
	}//break;

	//230, 229 reserved as 90% opacity

//}}}}}
	//};//switch
#else
		//alternate pom tiling functiionalities to change pom raymarch behavior
	switch (Ctm_pom_fix_mode)
	{
case 0://ctmpomfix core
//this is a safely dynamically wider tiling for the pom raymarch
case 6://outward corners fix b, tile a 1.0, crop n 233
v.x= v.x<0-Ctm_pom_fix_margin?v.x+1+Ctm_pom_fix_margin*2:v.x>=1+Ctm_pom_fix_margin?v.x-(1+Ctm_pom_fix_margin*2):v.x;
v.y= v.y<0-Ctm_pom_fix_margin?v.y+1+Ctm_pom_fix_margin*2:v.y>=1+Ctm_pom_fix_margin?v.y-(1+Ctm_pom_fix_margin*2):v.y;

v.x= v.x<0-Ctm_pom_fix_margin?v.x+1+Ctm_pom_fix_margin*2:v.x>=1+Ctm_pom_fix_margin?v.x-(1+Ctm_pom_fix_margin*2):v.x;
v.y= v.y<0-Ctm_pom_fix_margin?v.y+1+Ctm_pom_fix_margin*2:v.y>=1+Ctm_pom_fix_margin?v.y-(1+Ctm_pom_fix_margin*2):v.y;

v.x= v.x<0-Ctm_pom_fix_margin?0-Ctm_pom_fix_margin:v.x>=1+Ctm_pom_fix_margin?1+Ctm_pom_fix_margin:v.x;
v.y= v.y<0-Ctm_pom_fix_margin?0-Ctm_pom_fix_margin:v.y>=1+Ctm_pom_fix_margin?1+Ctm_pom_fix_margin:v.y;
break;

//added for v1.2
case 1://tile quarter (half distance) twice, then clamp 238
case 5://outward corners fix a, tile a 0.5, crop n 234
v.x=v.x<0? .5+v.x:v.x>1?.5+(v.x-1):v.x;
v.x=v.x<0? .5+v.x:v.x>1?.5+(v.x-1):v.x;
v.x=v.x<0?0:v.x>1?1:v.x;
v.y=v.y<0? .5+v.y:v.y>1?.5+(v.y-1):v.y;
v.y=v.y<0? .5+v.y:v.y>1?.5+(v.y-1):v.y;
v.y=v.y<0?0:v.y>1?1:v.y;
break;
case 2://mirror once and clamp 237
v.x=v.x<=0? 0-v.x:v.x>=1?1-(v.x-1):v.x;
v.x=v.x<0?0:v.x>1?1:v.x;
v.y=v.y<=0? 0-v.y:v.y>=1?1-(v.y-1):v.y;
v.y=v.y<0?0:v.y>1?1:v.y;
break;
case 3://crop and extend (for overlay borders) 236
v.x=v.x<0?0:v.x>1?1:v.x;
v.y=v.y<0?0:v.y>1?1:v.y;
break;
case 4://drop/discard (shaped/contoured edges) 235
if (v.x< 0||v.x>1||v.y<0||v.y>1) discard;
break;
case 7:// 1/8th tile, 232 ##### ALPHA, TELL ME IF YOU USE THIS OR IT MIGHT BE DELETED FROM FUTURE VERSIONS
v.x=v.x<0?0.125+fract_signed_oct(v.x):v.x>1?0.875+fract_signed_oct(v.x):v.x;
v.y=v.y<0?0.125+fract_signed_oct(v.y):v.y>1?0.875+fract_signed_oct(v.y):v.y;
break;

//230, 229 reserved as 90% opacity


	};//switch
#endif

return v;
}//func


void do_FAR_FIXES_CPF()
{
    if(Ctm_pom_fix_mode!=0) discard;
}



//MODIFIED TEXTURE READ FUNCTIONS


    //for normal map
	vec4 readNormal_h(in vec2 coord,in float dist)
	{//for height map reads
	
	#if POM_STYLE_CPF == 0
		
		return NORMAL_TEXTURE_CALL_PREFIX fract_ctmpomfix_h(coord) NORMAL_TEXTURE_CALL_SUFFIX
			#if SAND_STEPS_POM == 1 && VOXELIZE > 0  && IS_TERRAIN == 1 && GRASS_SHADER > 0 && GRASS_FOOT_STEPS > 0 && GRASS_SHADER > 0
				- pom_extra_depth;
			#endif
		;
	#else
	
	//return  vec4(0.0 , 0.0, 0.0, atlas_uv_to_bilinear_data_height( fract_ctmpomfix_h(coord) * QUAD_TEXTURE_SIZE_COMPONENT + QUAD_TEXTURE_POSITION_COMPONENT ));
//return vec4(0.0 , 0.0, 0.0,  atlas_uv_to_bilinear_data_height( fract_ctmpomfix_h(coord) * QUAD_TEXTURE_SIZE_COMPONENT + QUAD_TEXTURE_POSITION_COMPONENT ) );



	return  atlas_uv_to_bilinear_data_normal_2h( fract_ctmpomfix_h(coord) * QUAD_TEXTURE_SIZE_COMPONENT + QUAD_TEXTURE_POSITION_COMPONENT ,dist)
		#if SAND_STEPS_POM == 1 && VOXELIZE > 0  && IS_TERRAIN == 1 && GRASS_SHADER > 0 && GRASS_FOOT_STEPS > 0 && GRASS_SHADER > 0
			- pom_extra_depth;
		#endif
			;




		#endif
	}
	

	
	vec4 readNormal_basic(in vec2 coord)
	{//basic unmodified read at UVs
		return NORMAL_TEXTURE_CALL_PREFIX fract(coord) NORMAL_TEXTURE_CALL_SUFFIX
		#if SAND_STEPS_POM == 1 && VOXELIZE > 0  && IS_TERRAIN == 1 && GRASS_SHADER > 0 && GRASS_FOOT_STEPS > 0 && GRASS_SHADER > 0
			- pom_extra_depth;
		#endif
		;
	}
	
	vec4 readNormal_basic2(in vec2 coord,out vec4 ntex)
	{//basic unmodified read + double return to be sneaky in a multipart if statement
		ntex= NORMAL_TEXTURE_CALL_PREFIX fract(coord) NORMAL_TEXTURE_CALL_SUFFIX
		#if SAND_STEPS_POM == 1 && VOXELIZE > 0  && IS_TERRAIN == 1 && GRASS_SHADER > 0 && GRASS_FOOT_STEPS > 0 && GRASS_SHADER > 0
			- pom_extra_depth;
		#endif
		;
		return ntex;
	}
	
	//for albedo map

	
	vec4 readTexture_basic(in vec2 coord)
	{//for albedo 
		return ALBEDO_TEXTURE_CALL_PREFIX fract(coord) ALBEDO_TEXTURE_CALL_SUFFIX;
	}



#if FADE_IN_POM_CPF == 0
const float iFADE_IN_POM_CPF = 10.0 ;
#else
const float iFADE_IN_POM_CPF = 10.0 / FADE_IN_POM_CPF;
#endif
//variables
const float iPom_distance = 1.0/POM_DISTANCE_CPF;

	#endif
//debug_55


#if ENABLE_CTMPOMFIX_POM_SPACE == 1
//a custom POM implementation with special features




#if CTMPOMFIX != 1111
//debugging

	#if PBR_QUALITY_CPF != 0
		uniform vec3 sunPosition;
		uniform vec3 upPosition;
		//uniform float wetneSS;
		uniform float rainStrength;
		#if PBR_QUALITY_CPF != 0 && PBR_QUALITY_CPF != 1
			//varying float sky_exposure_cpf;
			#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif
			#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif
		#endif
	#endif




//functions
void Ctmpomfix_alt_pom_as_insert_for_coords(in float dist, in vec4 tex_coord, in vec3 view_vector, inout vec2 pom_target_coord, in float noise_in)
{

#if SMOOTHING_NOISE_CPF == 0
  noise_in = 0; //disable shader noise
 #else
 #if NOISE_FUNCTION_CPF == 0 
  noise_in = noise_in==0.0?easy_noise_cpf() : noise_in*NOISE_STRENGTH_CPF;
  #else
    noise_in=easy_noise_cpf();
   #endif
 #endif
 
//check if skip pom if not needed or invalid and check im pom range
 
  vec4 pixel_normal;//=readNormal_basic(tex_coord.st);


float fade_in=1.0-dist*iPom_distance;

	

 #if FAR_FIXES_CPF == 1  
 checkForCtmPomFixFlag(tex_coord.st);
 #endif

#if EXTEND_3D_SHADOWS_CPF == 2
				pixel_normal = readNormal_basic(tex_coord.st);
				float extended_shadow  = (1-pixel_normal.a )* POM_DEPTH_CPF;
				//fast_depth_write_cpf(extended_shadow );
			
			
	if(fade_in<=0||view_vector.z >= 0.0 ||pixel_normal.a== 1 ||  pixel_normal.a==0 ) 
	{//not doing pom
  
#else		
    

	if(fade_in<=0||view_vector.z >= 0.0 ||readNormal_basic2(tex_coord.st,pixel_normal).a== 1 ||  pixel_normal.a==0 ) 
	{//not doing pom
  
#endif
  
  
  #if FAR_FIXES_CPF == 1  
  //do_FAR_FIXES_CPF(); //fix things out of pom range
  #if EXTEND_3D_SHADOWS_CPF == 0
	if(fade_in<0&&Ctm_pom_fix_mode!=0) discard;
  #endif
	#endif
	

	
	
	//export, done
	pom_target_coord=tex_coord.st ALBEDO_TEXTURE_SET_UV_SUFFIX;



     //depth write pom    
      #if DEPTH_WRITE_CPF == 0
	  #else
		#if EXTEND_3D_SHADOWS_CPF == 0 
			gl_FragDepth = gl_FragCoord.z;
		#else
		
		
			#if EXTEND_3D_SHADOWS_CPF == 1
				//vec3 bumpy = vec3(.5,.5,1);
				//bumpy = abs(normal_to_view_cpf(bumpy));
				//bumpy.b = 1;
				
				//extended_shadow=extended_shadow==1?0:extended_shadow;
				//extended_shadow= (1-normal_to_view_cpf(vec3(0.0,0.0,extended_shadow)).b ) *POM_DEPTH_CPF;
				
				float extended_shadow  = (1-readNormal_basic(tex_coord.st).a )* POM_DEPTH_CPF;
				//float extended_shadow  = (1-pixel_normal.a )* POM_DEPTH_CPF;
				fast_depth_write_cpf(extended_shadow );
			#endif
			#if EXTEND_3D_SHADOWS_CPF == 2
				//float extended_shadow  = (1-readNormal_basic(tex_coord.st).a )* POM_DEPTH_CPF;
				fast_depth_write_cpf(extended_shadow );
			#endif
		
		
		
		#endif
		
      #endif


	 

  }//did not do pom
  else
{//in range and valid, do pom


		

//check for flagged pixels
   // pixel_albedo =
    #if FAR_FIXES_CPF == 0
    checkForCtmPomFixFlag(tex_coord.st);
	#endif
	
	
	
	//better fade ins for POM
	float POM_DEPTH_CPF_faded=POM_DEPTH_CPF;
    #if FADE_IN_POM_CPF == 0 

		 fade_in=1.0;
		 POM_DEPTH_CPF_faded=POM_DEPTH_CPF;
		 const float pom_quality = INITIAL_POM_QUALITY_CPF;
		 const float ipom_quality = 1.0/pom_quality;
	#else
	
	

		  fade_in=capf(fade_in,0.0,1.0);
		  
		  #if SMOOTHING_NOISE_CPF == 2
			noise_in *= clamp(dist,0.0,1.0); //blur distance
			#endif
			#if SMOOTHING_NOISE_CPF == 3
			noise_in *= (1.0- clamp(dist,0.0,2.0)*.5); //blur close
			#endif
		  
		//pom height fade in from 100 - 50% range
		 //POM_DEPTH_CPF_faded =fade_in>.5?POM_DEPTH_CPF: POM_DEPTH_CPF * fade_in *2;
		 //POM_DEPTH_CPF_faded = capf(fade_in *iFADE_IN_POM_CPF,0.0,1.0);
		
		
	
        #if EXTEND_3D_SHADOWS_CPF == 0
			POM_DEPTH_CPF_faded = POM_DEPTH_CPF* capf(fade_in *iFADE_IN_POM_CPF,0.0,1.0);
			#if FAR_FIXES_CPF == 1  
				//transitions stay deep, this can potentially be animated for rain and stuff for erosion
				POM_DEPTH_CPF_faded=Ctm_pom_fix_mode==0?POM_DEPTH_CPF_faded: POM_DEPTH_CPF;
			#else
				//fade transitions and base pom down
				POM_DEPTH_CPF_faded=Ctm_pom_fix_mode!=0?POM_DEPTH_CPF_faded: POM_DEPTH_CPF;
			#endif
		#else
			POM_DEPTH_CPF_faded = POM_DEPTH_CPF* capf(fade_in *iFADE_IN_POM_CPF,0.0,1.0);
			float pom_fade_amont= POM_DEPTH_CPF_faded / POM_DEPTH_CPF;
		#endif
			 

		#if DYNAMIC_QUALITY_CPF == 1
		//dynamic pom quality based on distance, 10% - 100% at 25% - 100% distance
		 float pom_quality =fade_in>0.75?INITIAL_POM_QUALITY_CPF: INITIAL_POM_QUALITY_CPF*(0.1+fade_in*1.2);
		  float ipom_quality = 1.0/pom_quality;
		#else
		//no DYNAMIC_QUALITY_CPF == 0
		 const float pom_quality = INITIAL_POM_QUALITY_CPF;
		 const float ipom_quality = 1.0/pom_quality;
		#endif
		
		

	#endif	




  

		//set up pom ray march
     
	  
  

      #if INCREASE_QUALITY_AT_ANGLES_CPF == 0
	  
		
		#if RECESS_POM_IN_PTX == 4 || RECESS_POM_IN_PTX == 7
			 float total_penetration = sqrt(POM_DEPTH_CPF_faded*POM_DEPTH_CPF_faded+(POM_DEPTH_CPF_faded / -view_vector.z)*(POM_DEPTH_CPF_faded / -view_vector.z) ); //POM_DEPTH_CPF_faded / -view_vector.z;
			 float ray_error = ipom_quality*total_penetration;
		#else
			 float ray_error = ipom_quality*POM_DEPTH_CPF_faded / -view_vector.z;
		#endif
	  
	  #else
	  #if RECESS_POM_IN_PTX == 4 || RECESS_POM_IN_PTX == 7
			 float total_penetration = POM_DEPTH_CPF_faded / -view_vector.z;
			 float ray_error = ipom_quality*total_penetration;
			   ray_error=ray_error> INCREASE_QUALITY_AT_ANGLES_CPF * ipom_quality ? INCREASE_QUALITY_AT_ANGLES_CPF * ipom_quality:ray_error;
		#else
			  // const float fSHARPEN_GRAZING_ANGLES = 2;
		   float ray_error = ipom_quality*POM_DEPTH_CPF_faded / -view_vector.z;
		   ray_error=ray_error> INCREASE_QUALITY_AT_ANGLES_CPF * ipom_quality ? INCREASE_QUALITY_AT_ANGLES_CPF * ipom_quality:ray_error;
		#endif
	 
	   
		#endif
		
		  		   
				

  vec3 rayvelocity = view_vector.xyz *ray_error;
  
 
  
      vec3 ray = vec3(tex_coord.st, 1.0);
      
	#if CUTOUT_POM == 1
		Ctm_pom_fix_mode = 4;
	 #endif 
	  
	 //enter relative space
	  rayvelocity.z/=POM_DEPTH_CPF_faded;
	  
	   //start pom ray march
      ray += noise_in*rayvelocity;
     
	  
	       //loop pom raymarch using updated readNormal function and dynamic depth
	       int raysteps;
			for (raysteps = 0;
          (raysteps < pom_quality) && (readNormal_h(ray.st,dist).a  < ray.p);
          ++raysteps) {
               ray = ray+rayvelocity;
      }//>pom ray march
	  
	   // SUPER POM 1
	  

#if REFINE_POM_CPF == 0
#else
float  refined_rayv = 0.5;
float refined_ray_total= -0.5;
for (int i=0;i< REFINE_POM_CPF ;i++)
{
	refined_rayv*= 0.5;
	refined_ray_total=(readNormal_h(ray.xy+refined_ray_total*rayvelocity.xy,dist).a < ray.z+refined_ray_total*rayvelocity.z)? refined_ray_total + refined_rayv:refined_ray_total - refined_rayv;
}

      #endif
	  
	  
      //leave relative space
	  rayvelocity.z*=POM_DEPTH_CPF_faded;
	
	 	

     //no oob safety

			 //update albedo UV to pom target
			 #if REFINE_POM_CPF == 0
			 pom_target_coord = fract_ctmpomfix_a(ray.st) ALBEDO_TEXTURE_SET_UV_SUFFIX;
#else
			
				   pom_target_coord = fract_ctmpomfix_a(ray.st+refined_ray_total*rayvelocity.xy) ALBEDO_TEXTURE_SET_UV_SUFFIX;
				   
      #endif
				    
				   
	#if CAPTURE_CPF_POM_DEPTH == 1
		//send pom depth forward in shader
		
		#if RECESS_POM_IN_PTX == 1
			pom_depth_forward = (1.-ray.z)*POM_DEPTH_CPF_faded+refined_ray_total*rayvelocity.z;
			
		#endif
		#if RECESS_POM_IN_PTX == 2
			pom_depth_forward = (raysteps+refined_ray_total) *ray_error;
		#endif
		#if RECESS_POM_IN_PTX == 3
			//pom_depth_forward = (1.-(ray.z+refined_ray_total*rayvelocity.z))*POM_DEPTH_CPF_faded;
			pom_depth_forward = (1.-(ray.z+refined_ray_total*rayvelocity.z)/POM_DEPTH_CPF_faded)*POM_DEPTH_CPF_faded;
			pom_depth_forward = (1.-(ray.z+refined_ray_total*rayvelocity.z)/POM_DEPTH_CPF_faded)
			//*total_penetration
			*POM_DEPTH_CPF_faded/(-view_vector.z/POM_DEPTH_CPF_faded);
		#endif
		#if RECESS_POM_IN_PTX == 4
			//pom_depth_forward = (1.-(ray.z+refined_ray_total*rayvelocity.z))*POM_DEPTH_CPF_faded;
			pom_depth_forward = (1.-(ray.z+refined_ray_total*rayvelocity.z)/POM_DEPTH_CPF_faded)*POM_DEPTH_CPF_faded;
			pom_depth_forward = (1.-(ray.z+refined_ray_total*rayvelocity.z)/POM_DEPTH_CPF_faded)
			*POM_DEPTH_CPF_faded
			*total_penetration;
		#endif
		#if RECESS_POM_IN_PTX == 5
			float longy = POM_DEPTH_CPF_faded / -view_vector.z;
			pom_depth_forward = (1.-(ray.z+refined_ray_total*rayvelocity.z))
			*sqrt(POM_DEPTH_CPF_faded*POM_DEPTH_CPF_faded+longy*longy);
		#endif
		#if RECESS_POM_IN_PTX == 6
			float longy = POM_DEPTH_CPF_faded / -view_vector.z;
			pom_depth_forward = -.25+(1.-(ray.z+refined_ray_total*rayvelocity.z))
			*sqrt(POM_DEPTH_CPF_faded*POM_DEPTH_CPF_faded+longy*longy);
		#endif
		#if RECESS_POM_IN_PTX == 7

			pom_depth_forward = (1.-(ray.z+refined_ray_total*rayvelocity.z)) //*POM_DEPTH_CPF_faded

			
			*total_penetration;
		#endif
	#endif
   
     //depth write pom    
      #if DEPTH_WRITE_CPF == 0
	  #else
	  
		#if EXTEND_3D_SHADOWS_CPF == 0
			#if REFINE_POM_CPF == 0
			
				fast_depth_write_cpf( raysteps *ray_error);
			#else
				fast_depth_write_cpf( (raysteps+refined_ray_total) *ray_error);

			#endif
		#else
			#if EXTEND_3D_SHADOWS_CPF == 1
				float extended_shadow  = (1-pixel_normal.a )* POM_DEPTH_CPF;
			#endif
			#if REFINE_POM_CPF == 0
			
				fast_depth_write_cpf( raysteps *ray_error*pom_fade_amont + extended_shadow*(1-pom_fade_amont)  );
			#else
				fast_depth_write_cpf( (raysteps+refined_ray_total)*pom_fade_amont *ray_error  + extended_shadow*(1-pom_fade_amont));

			#endif
		#endif
		  
      #endif
	  
	  

		#define CDDDD 0
#if CDDDD == 1
 #endif
	//debug
	
	
    }//> do pom (passed checks)
	
	//vec4 pixel_albedo = texture2DGradARB(texture, pom_target_coord.xy,dcdx,dcdy);
	

	
	}//func
	
	

//uniform vec3 skyColor;
//uniform float sunAngle;

	
void Ctmpomfix_alt_pom_as_insert_for_texture_data(in float dist, in vec4 tex_coord, in vec3 view_vector, inout vec2 pom_target_coord, in float noise_in, inout vec4 albedo_target, inout vec4 normal_target,inout vec4 specular_target)
{
Ctmpomfix_alt_pom_as_insert_for_coords(dist, tex_coord, view_vector,pom_target_coord, noise_in);

#if TEXTURE_FILTERING_CPF == 0 || FILTER_HERE != 1
albedo_target = ALBEDO_TEXTURE_CALL_PREFIX pom_target_coord TEXTURE_CALL_GRADS );
normal_target= TEXTURE_CALL_PREFIX NORMAL_TEXTURE_SAMPLER ,  pom_target_coord TEXTURE_CALL_GRADS );
specular_target= TEXTURE_CALL_PREFIX SPECULAR_TEXTURE_SAMPLER ,  pom_target_coord TEXTURE_CALL_GRADS );
return;
#endif


vec4 alphas;
#if TEXTURE_FILTERING_CPF == 1 || TEXTURE_FILTERING_CPF == 2 || TEXTURE_FILTERING_CPF == 3  || TEXTURE_FILTERING_CPF == 4  || TEXTURE_FILTERING_CPF == 5  || TEXTURE_FILTERING_CPF == 6  || TEXTURE_FILTERING_CPF == 7 || TEXTURE_FILTERING_CPF == 8 || TEXTURE_FILTERING_CPF == 9

albedo_target = atlas_uv_to_bilinear_data(pom_target_coord,dist,alphas);
specular_target=atlas_uv_to_bilinear_data_specular(pom_target_coord,dist,alphas);
normal_target= atlas_uv_to_bilinear_data_normal(pom_target_coord,dist);

#endif









#if TEXTURE_FILTERING_CPF == 87
albedo_target=vec4(1.0,1.0,1.0,1.0);
normal_target=vec4(0.5,0.5,1.0,1.0);
specular_target=vec4(0.0,0.0,0.0,1.0);
#endif

#if TEXTURE_FILTERING_CPF == 99
vec3 bumpy = atlas_uv_to_bilinear_data_normal(pom_target_coord,dist).rgb;
bumpy = normal_tex_to_view_cpf(bumpy);
bumpy= (bumpy+1)*.5;
albedo_target=vec4(bumpy.r,bumpy.g,bumpy.b,1.0);
normal_target= atlas_uv_to_bilinear_data_normal(pom_target_coord,dist);
specular_target=atlas_uv_to_bilinear_data_specular(pom_target_coord,dist);
#endif

#if TEXTURE_FILTERING_CPF == 10
vec3 bumpy = atlas_uv_to_bilinear_data_normal(pom_target_coord,dist).rgb;
bumpy = vec3(.5,.5,1);
bumpy = normal_to_view_cpf(bumpy);
bumpy= (bumpy+1)*.5;
bumpy.b=bumpy.b*2-1;
albedo_target=vec4(bumpy.b,bumpy.b,bumpy.b,1.0);
normal_target= atlas_uv_to_bilinear_data_normal(pom_target_coord,dist);
specular_target=atlas_uv_to_bilinear_data_specular(pom_target_coord,dist);
#endif

#if TEXTURE_FILTERING_CPF == 11
vec3 face_normals = normal_tex_to_view_cpf(vec3(0.5,0.5,1.0));
face_normals= (face_normals+1)*.5;
albedo_target.rgb = vec3(face_normals);
normal_target= atlas_uv_to_bilinear_data_normal(pom_target_coord,dist);
specular_target=atlas_uv_to_bilinear_data_specular(pom_target_coord,dist);
#endif




}

	
#endif
//end if ENABLE_CTMPOMFIX_POM_SPACE




#endif
#endif
//end if CTMPOMFIX == 1





// /> end of core CTMPOMFIX code, just inserts to function calls after this and optimizations

// © Copyright 2023 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )