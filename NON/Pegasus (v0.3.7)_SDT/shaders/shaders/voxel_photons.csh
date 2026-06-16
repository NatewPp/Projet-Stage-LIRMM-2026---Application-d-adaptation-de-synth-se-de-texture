// © Copyright 2025 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets".  '


#include "/settings.glsl"


#if VOXEL_AREA == 512
	const ivec3 workGroups = ivec3(32, 32, 512); 
#endif	
#if VOXEL_AREA == 256
	const ivec3 workGroups = ivec3(32, 32, 256); 
#endif	
#if VOXEL_AREA == 128
	const ivec3 workGroups = ivec3(16, 16, 128); 
#endif
#if VOXEL_AREA == 64
	const ivec3 workGroups = ivec3(8, 8, 64); 
#endif
#if VOXEL_AREA == 32
	const ivec3 workGroups = ivec3(4, 4, 32); 
#endif

uniform int frameCounter;

layout (local_size_x = 8, local_size_y = 8, local_size_z = 1) in;


//to read/write to a 3d image
//layout (r32ui) uniform uimage3D c_image1;

#if FLOODFILL_LIGHTING >= 1
	//our 3d image with voxel data
	uniform usampler3D cSampler1;
	layout (r32ui) uniform uimage3D cimage1a;
	
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
			vec4 og_voxel_data = unpackUnorm4x8( imageLoad(cimage1a, orig_voxel_pos ).r); 
			
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
				 
				#define APPLY_OPACITY_TYPE *1. 
				//clamp((bytes.a-.03)*10.,0.,1.)


				float od = voxel_data.a ;
					

					vec4 glass_mult= voxel_data.a < .05 ? vec4(1.) 
					: voxel_data.a > .4 ? vec4(0.,0.,0.,1.)  
					: voxel_data.a < .2 ? vec4(voxel_data.rgb,1.)  
					: vec4(0.);
					
					glass_mult.rgb/=max( max(glass_mult.r,glass_mult.g),max(glass_mult.b,0.001) );
					voxel_data.rgb*=opacity_type == 4 ? 1. : 0.;
					
					//floodfill
				ivec3 neighbor = ivec3(1.,0.,0.);
				vec4 bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);
				voxel_data=clamp(max(voxel_data,glass_mult* bytes APPLY_OPACITY_TYPE LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(-1.,0.,0.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);	
				voxel_data=clamp(max(voxel_data,glass_mult*bytes APPLY_OPACITY_TYPE LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(0.,0,1.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);		
				voxel_data=clamp(max(voxel_data,glass_mult*bytes APPLY_OPACITY_TYPE LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(0.,0,-1.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);	
				voxel_data=clamp(max(voxel_data,glass_mult*bytes APPLY_OPACITY_TYPE LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(0.,1.,0.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);		
				voxel_data=clamp(max(voxel_data,glass_mult*bytes APPLY_OPACITY_TYPE LIGHT_FADE_VXFL),0.,1.);
				
				neighbor = ivec3(0.,-1.,0.);
				bytes = imageLoad(cimage3_colored_light, voxel_pos +neighbor);		
				voxel_data=clamp(max(voxel_data,glass_mult*bytes APPLY_OPACITY_TYPE LIGHT_FADE_VXFL),0.,1.);
				
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
					voxel_data = mix(voxel_data,old_voxel_data, FADE_LIGHT_UPDATES_AMOUNT );
				#endif
				
				//pack data
				//uint integerValue = packUnorm4x8( voxel_data );
				
				//write data
				imageStore(cimage3_colored_light, voxel_pos_new, voxel_data);
			#if SAVE_WRITES == 1
			}
			#endif
		

    #endif
}

