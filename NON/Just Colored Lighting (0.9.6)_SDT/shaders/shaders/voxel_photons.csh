// © Copyright 2025 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets".  '


#include "/settings.glsl"
#if SOLAR_GI >= 2  
	#define SOLAR_GI_DOT  1
#endif

//#define VOXEL_AREA 128 //[32 48 64 96 128 160 192 224 256 512]

#if WORK_GROUP_SIZE == 256
    layout (local_size_x = 8, local_size_y = 8, local_size_z = 4) in;
    #if VOXEL_AREA == 1024
	    const ivec3 workGroups = ivec3(128, 128, 256); 
    #endif
    #if VOXEL_AREA == 512
	    const ivec3 workGroups = ivec3(64, 64, 128); 
    #endif	
    #if VOXEL_AREA == 256
	    const ivec3 workGroups = ivec3(32, 32, 64); 
    #endif	
    #if VOXEL_AREA == 224
	    const ivec3 workGroups = ivec3(28, 28, 56); 
    #endif
    #if VOXEL_AREA == 192
	    const ivec3 workGroups = ivec3(24, 24, 48); 
    #endif
    #if VOXEL_AREA == 160
	    const ivec3 workGroups = ivec3(20, 20, 40); 
    #endif
    #if VOXEL_AREA == 128
	    const ivec3 workGroups = ivec3(16, 16, 32); 
    #endif
    #if VOXEL_AREA == 96
	    const ivec3 workGroups = ivec3(12, 12, 24); 
    #endif
    #if VOXEL_AREA == 64
	    const ivec3 workGroups = ivec3(8, 8, 16); 
    #endif
    #if VOXEL_AREA == 48
	    const ivec3 workGroups = ivec3(6, 6, 12); 
    #endif
    #if VOXEL_AREA == 32
	    const ivec3 workGroups = ivec3(4, 4, 8); 
    #endif

#endif 

#if WORK_GROUP_SIZE == 128
    layout (local_size_x = 8, local_size_y = 8, local_size_z = 2) in;
    #if VOXEL_AREA == 1024
	    const ivec3 workGroups = ivec3(128, 128, 512); 
    #endif
    #if VOXEL_AREA == 512
	    const ivec3 workGroups = ivec3(64, 64, 256); 
    #endif	
    #if VOXEL_AREA == 256
	    const ivec3 workGroups = ivec3(32, 32, 128); 
    #endif	
    #if VOXEL_AREA == 224
	    const ivec3 workGroups = ivec3(28, 28, 112); 
    #endif
    #if VOXEL_AREA == 192
	    const ivec3 workGroups = ivec3(24, 24, 96); 
    #endif
    #if VOXEL_AREA == 160
	    const ivec3 workGroups = ivec3(20, 20, 80); 
    #endif
    #if VOXEL_AREA == 128
	    const ivec3 workGroups = ivec3(16, 16, 64); 
    #endif
    #if VOXEL_AREA == 96
	    const ivec3 workGroups = ivec3(12, 12, 48); 
    #endif
    #if VOXEL_AREA == 64
	    const ivec3 workGroups = ivec3(8, 8, 32); 
    #endif
    #if VOXEL_AREA == 48
	    const ivec3 workGroups = ivec3(6, 6, 24); 
    #endif
    #if VOXEL_AREA == 32
	    const ivec3 workGroups = ivec3(4, 4, 16); 
    #endif

#endif 

#if WORK_GROUP_SIZE == 64
    layout (local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

    #if VOXEL_AREA == 1024
	    const ivec3 workGroups = ivec3(128, 128, 1024); 
    #endif
    #if VOXEL_AREA == 512
	    const ivec3 workGroups = ivec3(64, 64, 512); 
    #endif	
    #if VOXEL_AREA == 256
	    const ivec3 workGroups = ivec3(32, 32, 256); 
    #endif	
    #if VOXEL_AREA == 224
	    const ivec3 workGroups = ivec3(28, 28, 224); 
    #endif
    #if VOXEL_AREA == 192
	    const ivec3 workGroups = ivec3(24, 24, 192); 
    #endif
    #if VOXEL_AREA == 160
	    const ivec3 workGroups = ivec3(20, 20, 160); 
    #endif
    #if VOXEL_AREA == 128
	    const ivec3 workGroups = ivec3(16, 16, 128); 
    #endif
    #if VOXEL_AREA == 96
	    const ivec3 workGroups = ivec3(12, 12, 96); 
    #endif
    #if VOXEL_AREA == 64
	    const ivec3 workGroups = ivec3(8, 8, 64); 
    #endif
    #if VOXEL_AREA == 48
	    const ivec3 workGroups = ivec3(6, 6, 48); 
    #endif
    #if VOXEL_AREA == 32
	    const ivec3 workGroups = ivec3(4, 4, 32); 
    #endif
#endif 

uniform int frameCounter;
//to read/write to a 3d image
//layout (r32ui) uniform uimage3D c_image1;

#if FLOODFILL_LIGHTING >= 1
	//our 3d image with voxel data
	uniform usampler3D cSampler1;
	layout (r32ui) uniform uimage3D cimage1;
	
	//buffer 3, where we read 
	uniform sampler3D cSampler3_colored_light;
	layout (rgba8) uniform image3D cimage3_colored_light;

	uniform ivec3 cameraPositionInt;
	uniform ivec3 previousCameraPositionInt;
	#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif
	uniform vec3 previousCameraPosition;



	#if AUTO_HAND_HELD_COLOR_DETECTION > 0
		layout (r32ui) uniform uimage2D cimage_held_light;
	#endif
	
	//these shouldn't have to be here
	#define FIRST_FLOOD_PASS 1
	#define COLORED_SHADOWS 1
	 
	
	#if FIRST_FLOOD_PASS == 1  
		#if SOLAR_GI >= 1
			uniform ivec2 eyeBrightnessSmooth;//float(eyeBrightnessSmooth.y/240.)
			#if CUSTOM_SUN_COLOR == 0
				uniform sampler2D lightmap;
			#endif
			float sum_rgb(inout vec4 c)
			{
				return c.r+c.g+c.b;
			}
			#if COLORED_SHADOWS == 1
				uniform sampler2D shadowcolor0;
				uniform sampler2D shadowtex0;
			#endif
			uniform mat4 shadowModelView;
			uniform mat4 shadowProjection;
			#include "/distort.glsl"
			uniform sampler2D shadowtex1;
			uniform float sunAngle;
			
			#if TRACELESS_PT == 1
			
			#endif
			uniform vec3 shadowLightPosition;
			#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif
			
			//image.cimage4_gi = cSampler4_gi RGBA RGBA8 BYTE false false 128 128 768
			uniform sampler3D cSampler4_gi;
			layout (rgba8) uniform image3D cimage4_gi;
			

		#endif
	#endif		
	
#endif

void main()
{
	#if FLOODFILL_LIGHTING >= 1
	    //get index of thread
        ivec3 orig_voxel_pos = ivec3(gl_GlobalInvocationID.xyz);
		
		#if FLIP_V_BUFFERS == 1
			ivec3 double_buffer_offset_write =mod(frameCounter,2)!=0? ivec3(0,VOXEL_AREA,0):ivec3(0);
			ivec3 double_buffer_offset_read = mod(frameCounter,2)==0? ivec3(0,VOXEL_AREA,0):ivec3(0);
		#else
			ivec3 double_buffer_offset_write =mod(frameCounter,2)==0? ivec3(0,VOXEL_AREA,0):ivec3(0);
			ivec3 double_buffer_offset_read = mod(frameCounter,2)!=0? ivec3(0,VOXEL_AREA,0):ivec3(0);
		#endif
		
		
		//positions
		#if FLIP_V_BUFFERS >= 1
			ivec3 camshift = ivec3(0);
		#else
			ivec3 camshift = cameraPositionInt-previousCameraPositionInt;
		#endif
	
		
        ivec3 voxel_pos = orig_voxel_pos +camshift;
		
		ivec3 voxel_pos_new=orig_voxel_pos + double_buffer_offset_write;
		
		voxel_pos+=double_buffer_offset_read;
		
			//load data and unpack
			uint og_int_data = imageLoad(cimage1, orig_voxel_pos ).r;
			vec4 og_voxel_data = unpackUnorm4x8(og_int_data ); 
			
			vec4 voxel_data = og_voxel_data;
			
			
			
			
			 
			//do stuff
	
			#if LIGHT_FALLOFF == 1
				#define LIGHT_FADE_VXFL -1./15.
			#endif
			#if LIGHT_FALLOFF == 2
				#define LIGHT_FADE_VXFL * LIGHT_FALLOFF_RATE
			#endif
			
			#if VOXEL_PHOTON_SIMULATION_QUALITY >= 2
				int opacity_type = int(voxel_data.a *10.);
				
				ivec3 neighbor;
				vec4 bytes;
				
				#include "/shaders/gi.glsl"
				
				 
				#define APPLY_OPACITY_TYPE *1. 
				//clamp((bytes.a-.03)*10.,0.,1.)


				float od = voxel_data.a ;
                #define LIGHT_UP_STAIRS 0.0
					
                   // glass_mult.rgb/=max( max(glass_mult.r,glass_mult.g),max(glass_mult.b,0.001) );
    				vec4 glass_mult= vec4(voxel_data.rgb,1.)/max( max(voxel_data.r,voxel_data.g),max(voxel_data.b,0.001) );  
					

                    vec4 glass_mult_east = voxel_data.a < .05 ? vec4(1.) 
					: voxel_data.a > .4 ? vec4(0.,0.,0.,1.)  
					: voxel_data.a < .2 ? vec4(glass_mult.rgb,1.)  
                    : abs(voxel_data.a - .31 )<.009 ? vec4(.5,.5,.5,1.) //slabs
                    : abs(voxel_data.a - .32 )<.009 ? vec4(LIGHT_UP_STAIRS,LIGHT_UP_STAIRS,LIGHT_UP_STAIRS,1.) //stairs east
                    : abs(voxel_data.a - .33 )<.009 ? vec4(0.,0.,0.,1.) //stairs west
                    : abs(voxel_data.a - .34 )<.009 ? vec4(.25,.25,.25,1.) //stairs north
                    : abs(voxel_data.a - .35 )<.009 ? vec4(.25,.25,.25,1.) //stairs south
					: vec4(0.);
                     vec4 glass_mult_west = voxel_data.a < .05 ? vec4(1.) 
					: voxel_data.a > .4 ? vec4(0.,0.,0.,1.)  
					: voxel_data.a < .2 ? vec4(glass_mult.rgb,1.)  
                    : abs(voxel_data.a - .31 )<.009 ? vec4(.5,.5,.5,1.) //slabs
                    : abs(voxel_data.a - .32 )<.009 ? vec4(0.,0.,0.,1.) //stairs east
                    : abs(voxel_data.a - .33 )<.009 ? vec4(LIGHT_UP_STAIRS,LIGHT_UP_STAIRS,LIGHT_UP_STAIRS,1.) //stairs west
                    : abs(voxel_data.a - .34 )<.009 ? vec4(.25,.25,.25,1.) //stairs north
                    : abs(voxel_data.a - .35 )<.009 ? vec4(.25,.25,.25,1.) //stairs south
					: vec4(0.);

                    vec4 glass_mult_north = voxel_data.a < .05 ? vec4(1.) 
					: voxel_data.a > .4 ? vec4(0.,0.,0.,1.)  
					: voxel_data.a < .2 ? vec4(glass_mult.rgb,1.)  
                    : abs(voxel_data.a - .31 )<.009 ? vec4(.5,.5,.5,1.) //slabs
                    : abs(voxel_data.a - .32 )<.009 ? vec4(.25,.25,.25,1.) //stairs east
                    : abs(voxel_data.a - .33 )<.009 ? vec4(.25,.25,.25,1.) //stairs west
                    : abs(voxel_data.a - .34 )<.009 ? vec4(LIGHT_UP_STAIRS,LIGHT_UP_STAIRS,LIGHT_UP_STAIRS,1.) //stairs north
                    : abs(voxel_data.a - .35 )<.009 ? vec4(0.,0.,0.,1.) //stairs south
					: vec4(0.);

                     vec4 glass_mult_south = voxel_data.a < .05 ? vec4(1.) 
					: voxel_data.a > .4 ? vec4(0.,0.,0.,1.)  
					: voxel_data.a < .2 ? vec4(glass_mult.rgb,1.)  
                    : abs(voxel_data.a - .31 )<.009 ? vec4(.5,.5,.5,1.) //slabs
                    : abs(voxel_data.a - .32 )<.009 ? vec4(.25,.25,.25,1.) //stairs east
                    : abs(voxel_data.a - .33 )<.009 ? vec4(.25,.25,.25,1.) //stairs west
                    : abs(voxel_data.a - .34 )<.009 ? vec4(0.,0.,0.,1.) //stairs north
                    : abs(voxel_data.a - .35 )<.009 ? vec4(LIGHT_UP_STAIRS,LIGHT_UP_STAIRS,LIGHT_UP_STAIRS,1.) //stairs south
					: vec4(0.);

                    vec4 glass_mult_vert = voxel_data.a < .05 ? vec4(1.) 
					: voxel_data.a > .4 ? vec4(0.,0.,0.,1.)  
					: voxel_data.a < .2 ? vec4(glass_mult.rgb,1.)  
                    : abs(voxel_data.a - .31 )<.009  ? vec4(0.,0.,0.,1.) //slabs
                    : abs(voxel_data.a - .32 )<.009 ? vec4(0.,0.,0.,1.) //stairs east
                    : abs(voxel_data.a - .33 )<.009 ? vec4(0.,0.,0.,1.) //stairs west
                    : abs(voxel_data.a - .34 )<.009 ? vec4(0.,0.,0.,1.) //stairs north
                    : abs(voxel_data.a - .35 )<.009 ? vec4(0.,0.,0.,1.) //stairs south
					: vec4(0.);

					
					
					voxel_data.rgb*=opacity_type == 4
					#if SOLAR_GI >= 1
						|| bounce_light 
					#endif
					? 1. : 0.;
					
				//floodfill
				neighbor = ivec3(1.,0.,0.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);
				voxel_data=clamp(max(voxel_data,glass_mult_east* bytes APPLY_OPACITY_TYPE LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(-1.,0.,0.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);	
				voxel_data=clamp(max(voxel_data,glass_mult_west*bytes APPLY_OPACITY_TYPE LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(0.,0,1.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);		
				voxel_data=clamp(max(voxel_data,glass_mult_north*bytes APPLY_OPACITY_TYPE LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(0.,0,-1.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);	
				voxel_data=clamp(max(voxel_data,glass_mult_south*bytes APPLY_OPACITY_TYPE LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(0.,1.,0.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);		
				voxel_data=clamp(max(voxel_data,glass_mult_vert*bytes APPLY_OPACITY_TYPE LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(0.,-1.,0.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);		
				voxel_data=clamp(max(voxel_data,glass_mult_vert*bytes APPLY_OPACITY_TYPE LIGHT_FADE_VXFL),0.,1.);
				
				
				
				voxel_data.a = od;

			#else
				//floodfill
				ivec3 neighbor = ivec3(1.,0.,0.);
				vec4 bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);
				voxel_data=clamp(max(voxel_data, bytes LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(-1.,0.,0.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);	
				voxel_data=clamp(max(voxel_data,bytes LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(0.,0,1.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);		
				voxel_data=clamp(max(voxel_data,bytes LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(0.,0,-1.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);	
				voxel_data=clamp(max(voxel_data,bytes LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(0.,1.,0.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);		
				voxel_data=clamp(max(voxel_data,bytes LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(0.,-1.,0.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);		
				voxel_data=clamp(max(voxel_data,bytes LIGHT_FADE_VXFL),0.,1.);
			#endif
			#if SAVE_WRITES == 1
			if(any(greaterThan(voxel_data + og_voxel_data, vec4(0.5/255.) )))
			{
			#endif
				
				#if FADE_LIGHT_UPDATES == 1
					vec4 old_voxel_data = imageLoad(cimage3_colored_light, voxel_pos ); 
					#if FIX_BLOCKLIGHT_GHOSTS == 1
						old_voxel_data.rgb = clamp(old_voxel_data.rgb-1./255.,0.,1.);
					#endif
					voxel_data = mix(voxel_data,old_voxel_data, 
					#if SOLAR_GI >= 1 && FIX_FLIICKERING_GI == 1
						mix(FADE_LIGHT_UPDATES_AMOUNT,GI_FADE,lmy_og)
					#else
						FADE_LIGHT_UPDATES_AMOUNT
					#endif
					
					);
				#endif
				
			
				//pack data
				//uint integerValue = packUnorm4x8( voxel_data );
				
				//write data
				imageStore(cimage3_colored_light, voxel_pos_new, voxel_data);
			#if SAVE_WRITES == 1
			}
			#endif
		
		#if AUTO_HAND_HELD_COLOR_DETECTION > 0

			//fade hand held lights
			if(orig_voxel_pos==ivec3(0) )
			{
				//	layout (r32ui) uniform uimage2D cimage_held_light;
			     #if AUTO_HAND_HELD_COLOR_DETECTION == 61
				 
                        //for hand lights
	uniform int heldBlockLightValue;
	uniform int heldBlockLightValue2;
	uniform int heldItemId;
	uniform int heldItemId2;
	uniform float frameTimeCounter;
	
                    #define IS_HAND_CHECK_FROM_LIST 1
                    float flow_gredient=1.;
                    float flicker = (.7+.2*sin((frameTimeCounter*1.+voxel_pos_new.x)*flow_gredient) +.2*sin((frameTimeCounter*2.+voxel_pos_new.z)*flow_gredient)+.1*sin((frameTimeCounter*5.+voxel_pos_new.y)*flow_gredient));

                    #include "/hard_coded_blocks_hand.glsl"
                        //    vec4 hand_color;
                        //    vec4 hand_color2;

				
                    vec4 hand_data = hand_color;//unpackUnorm4x8( imageLoad(cimage_held_light,  ivec2(0) ).r); 
				    hand_data=max(vec4(0.), hand_data*.9-1./255.);
				    imageStore(cimage_held_light,  ivec2(0),  ivec4(packUnorm4x8(hand_data)) );
					    //fade in
					    vec4 hand_data2 = unpackUnorm4x8( imageLoad(cimage_held_light,  ivec2(1,0) ).r); 
					    hand_data2=mix(hand_data2,hand_data,.1);
					    imageStore(cimage_held_light,  ivec2(1,0),  ivec4(packUnorm4x8(hand_data2)) );
					    
				    hand_data = hand_color2;//unpackUnorm4x8( imageLoad(cimage_held_light,  ivec2(1)).r); 
				    hand_data=max(vec4(0.), hand_data*.9-1./255.);
				    imageStore(cimage_held_light,  ivec2(1),  ivec4(packUnorm4x8(hand_data)) );
					    //fade in
					    hand_data2 = unpackUnorm4x8( imageLoad(cimage_held_light,  ivec2(1,1)).r); 
					    hand_data2=mix(hand_data2,hand_data,.1);
					    imageStore(cimage_held_light,  ivec2(1,1),  ivec4(packUnorm4x8(hand_data2)) );
				    
				    hand_data = unpackUnorm4x8( imageLoad(cimage_held_light,  ivec2(2) ).r); 
				    hand_data=max(vec4(0.), hand_data*.9-1./255.);
				    imageStore(cimage_held_light,  ivec2(2), ivec4(packUnorm4x8(hand_data)) );
				    //fade in
					    hand_data2 = unpackUnorm4x8( imageLoad(cimage_held_light,  ivec2(1,2) ).r); 
					    hand_data2=mix(hand_data2,hand_data,.1);
					    imageStore(cimage_held_light,  ivec2(1,2), ivec4(packUnorm4x8(hand_data2)) );
					    
				    


                #else


				
				    vec4 hand_data = unpackUnorm4x8( imageLoad(cimage_held_light,  ivec2(0) ).r); 
				    hand_data=max(vec4(0.), hand_data*.9-1./255.);
				    imageStore(cimage_held_light,  ivec2(0),  ivec4(packUnorm4x8(hand_data)) );
					    //fade in
					    vec4 hand_data2 = unpackUnorm4x8( imageLoad(cimage_held_light,  ivec2(1,0) ).r); 
					    hand_data2=mix(hand_data2,hand_data,.1);
					    imageStore(cimage_held_light,  ivec2(1,0),  ivec4(packUnorm4x8(hand_data2)) );
					    
				    hand_data = unpackUnorm4x8( imageLoad(cimage_held_light,  ivec2(1)).r); 
				    hand_data=max(vec4(0.), hand_data*.9-1./255.);
				    imageStore(cimage_held_light,  ivec2(1),  ivec4(packUnorm4x8(hand_data)) );
					    //fade in
					    hand_data2 = unpackUnorm4x8( imageLoad(cimage_held_light,  ivec2(1,1)).r); 
					    hand_data2=mix(hand_data2,hand_data,.1);
					    imageStore(cimage_held_light,  ivec2(1,1),  ivec4(packUnorm4x8(hand_data2)) );
				    
				    hand_data = unpackUnorm4x8( imageLoad(cimage_held_light,  ivec2(2) ).r); 
				    hand_data=max(vec4(0.), hand_data*.9-1./255.);
				    imageStore(cimage_held_light,  ivec2(2), ivec4(packUnorm4x8(hand_data)) );
				    //fade in
					    hand_data2 = unpackUnorm4x8( imageLoad(cimage_held_light,  ivec2(1,2) ).r); 
					    hand_data2=mix(hand_data2,hand_data,.1);
					    imageStore(cimage_held_light,  ivec2(1,2), ivec4(packUnorm4x8(hand_data2)) );
					    
				    
				#endif    

			}
		#endif

    #endif
}

