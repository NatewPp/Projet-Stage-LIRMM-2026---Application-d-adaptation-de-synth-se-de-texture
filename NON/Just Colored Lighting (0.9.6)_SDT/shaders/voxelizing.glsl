// © Copyright 2025 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 

				#if  (HAND_LIGHT_CAPTURE_BACKUP == 1 && IS_HAND == 1) && FLOODFILL_LIGHTING > 011
					//debug
					#if AUTO_HAND_HELD_COLOR_DETECTION == 4
						//layout (r32ui) uniform uimage2D cimage_held_light; //8x8
						vec4 hand_data;// = emmissiveness > 0.001 ? vec4(light_color.rgb,emmissiveness/15.) : vec4(0.);
					//	hand_data.rgb*=hand_data.a;
						hand_data=vec4(1.);
						
						imageAtomicMax( cimage_held_light, ivec2(0), packUnorm4x8(vec4(hand_data.rgb,hand_data.r) ) );
						imageAtomicMax( cimage_held_light, ivec2(1), packUnorm4x8(vec4(hand_data.rgb,hand_data.g) ) );
						imageAtomicMax( cimage_held_light, ivec2(2), packUnorm4x8(vec4(hand_data.rgb,hand_data.b) ) );

						//integerValue=0u; //prevent voxelization
					#endif
				#endif
	
#if VOXELIZE_PLAYER == 0 || OTHER_PLAYER_LIGHTS == 0
	//positions
	vec3 shadow_view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
	vec3 foot_pos = (shadowModelViewInverse * vec4( shadow_view_pos ,1.) ).xyz;
	vec3 world_pos = foot_pos + cameraPosition;
	vec3 abs_foot = abs(world_pos-eyePosition);
#endif
	
	
#if DONT_VOXELIZE_CARPETS == 1 && IS_PARTICLE != 1 && IS_HAND!=1
	if(mc_Entity.x != 10100. 
	#if VOXELIZE_GRASS == 0
		&& mc_Entity.x != 10000.
	#endif
	
	#if VOXELIZE_PLAYER == 0 && OTHER_PLAYER_LIGHTS == 0
		&& !(entityId == 20014)
	#endif
	#if VOXELIZE_PLAYER == 0 && OTHER_PLAYER_LIGHTS == 1
		&& !(entityId == 20014
		&& max(max(abs_foot.x,abs_foot.y),abs_foot.z) < RANGE_FOR_DISABLING_PLAYER_HELD_LIGHTS)
	#endif
	#if VOXELIZE_PLAYER == 1 && OTHER_PLAYER_LIGHTS == 0
		&& !(entityId == 20014
		&& max(max(abs_foot.x,abs_foot.y),abs_foot.z) > RANGE_FOR_DISABLING_PLAYER_HELD_LIGHTS)
	#endif

	)//no carpets
#endif
{
	
	//#if IS_PARTICLE == 1
	#if ((IS_PARTICLE == 1 && PARTICLES_LPV == 1) || (HAND_LIGHT_CAPTURE_BACKUP == 1 && IS_HAND == 1)) && FLOODFILL_LIGHTING > 0
		//positions
		vec3 view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
		vec3 foot_pos = (gbufferModelViewInverse * vec4( view_pos ,1.) ).xyz;
		vec3 world_pos = foot_pos + cameraPosition;
		
		ivec3 double_buffer_offset_write =mod(frameCounter,2)==0? ivec3(0,VOXEL_AREA,0):ivec3(0);
		ivec3 double_buffer_offset_read = mod(frameCounter,2)!=0? ivec3(0,VOXEL_AREA,0):ivec3(0);
	#else
		#if !(VOXELIZE_PLAYER == 0 || OTHER_PLAYER_LIGHTS == 0)
			//positions
			vec3 shadow_view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
			vec3 foot_pos = (shadowModelViewInverse * vec4( shadow_view_pos ,1.) ).xyz;
			vec3 world_pos = foot_pos + cameraPosition;
		#endif
	#endif


	//voxel map position
	
//#if IS_PARTICLE == 1
#if ((IS_PARTICLE == 1 && PARTICLES_LPV == 1) || (HAND_LIGHT_CAPTURE_BACKUP == 1 && IS_HAND == 1)) && FLOODFILL_LIGHTING > 0
  vec3 block_centered_relative_pos = foot_pos + 
	( vec3(0.) )
	+fract(cameraPosition);
#else
	vec3 block_centered_relative_pos = foot_pos 
          + (renderStage == MC_RENDER_STAGE_ENTITIES? vec3(0.) : at_midBlock.xyz/64.0)
   	//(renderStage == MC_RENDER_STAGE_ENTITIES? vec3(0.) : at_midBlock.xyz/64.0)
	+fract(cameraPosition);
#endif

ivec3 voxel_pos = ivec3(block_centered_relative_pos + VOXEL_RADIUS);


	//write voxel data
	if(
		#define WRITE_ALL_PLAYER_VERTEXES 0
		#if WRITE_ALL_PLAYER_VERTEXES == 1
			(renderStage == MC_RENDER_STAGE_ENTITIES 
					&& entityId == 20014 //player
				//	&& (currentRenderedItemId == heldItemId || currentRenderedItemId == heldItemId2)
					&& max(max(abs_foot.x,abs_foot.y),abs_foot.z) < RANGE_FOR_DISABLING_PLAYER_HELD_LIGHTS)
			||
		#endif
		mod(gl_VertexID,4)==0  //only write for 1 vertex
		&& clamp(voxel_pos,0,VOXEL_AREA) == voxel_pos //and in voxel range	
	) //for one vertex per face, write if in range
	{
	
	#if PBR_LPV_EMISSION == 1
		vec2 quad_center= (gl_TextureMatrix[0] *  mc_midTexCoord).st;
		float pbr_emmissive = vec4(textureLod(specular, quad_center,
			//0
			log2(float(textureSize(texture, 0).x))
		)).a;
		pbr_emmissive =  pbr_emmissive < 254.5/255. ? pbr_emmissive : 0.;
	
	#endif
	
	//#if IS_PARTICLE == 1
	#if ((IS_PARTICLE == 1 && PARTICLES_LPV == 1) || (HAND_LIGHT_CAPTURE_BACKUP == 1 && IS_HAND == 1)) && FLOODFILL_LIGHTING > 0
		#if IS_PARTICLE == 1
			bool light_source = 
				false
				//vec4(textureLod(texture, texcoord,log2(float(textureSize(specular, 0).x))).rgb* glcolor.rgb,1.).a
				#if PBR_LPV_EMISSION == 1
					|| pbr_emmissive > 0.01
				#endif
			#if LPV_PARTICLES_BY_LM == 1
				 || lmcoord.x > .9
			#endif
				;
				
		#endif
		#if IS_HAND == 1
			bool light_source = 
				//false
				(isRightHanded?
					(heldBlockLightValue2 > 0 && g_pos.x<-.5) ||( heldBlockLightValue > 0 && g_pos.x >.5) 
				:
					(heldBlockLightValue2 > 0 && g_pos.x>.5) ||( heldBlockLightValue > 0 && g_pos.x <-.5) 
				)
				
				//vec4(textureLod(texture, texcoord,log2(float(textureSize(specular, 0).x))).rgb* glcolor.rgb,1.).a
				#if PBR_LPV_EMISSION == 1
					|| pbr_emmissive > 0.01
				#endif
			#if LPV_PARTICLES_BY_LM == 1
			//	 || lmcoord.x > .9
			#endif
				;
				
		#endif
		
	#else
	
		bool light_source = 
			#if SOLAR_GI == 1
			//	||
			#endif
			#if PBR_LPV_EMISSION == 1
				pbr_emmissive > 0.01 ||
			#endif
			((renderStage == MC_RENDER_STAGE_TERRAIN_SOLID
			#if TRANSLECENT_LIGHTS == 1
				|| renderStage == MC_RENDER_STAGE_TERRAIN_TRANSLUCENT
			#endif
			)
			&& at_midBlock.w>0. ) ||
			
			//(currentRenderedItemId >= 10000 && currentRenderedItemId <= 10008) ||
			 (currentRenderedItemId >= 10030 && currentRenderedItemId <= 10039)
			  || (currentRenderedItemId >= 10070 && currentRenderedItemId <= 10079)
			|| (mc_Entity.x >= 10030 && mc_Entity.x <= 10039)
			|| entityId <= 20012 && entityId >= 20010 
			||(mc_Entity.x >= 10101 && mc_Entity.x <= 10199) 
			
					
			
		#if LPV_BLOCKS_BY_LM == 1
			|| lmcoord.x > .93
		#endif
		
			;
	#endif
		
	
	bool flame_light = 
				currentRenderedItemId == 10000 || currentRenderedItemId == 10030
				|| entityId == 20010 || entityId == 10030  
				|| mc_Entity.x == 10030.0;
				
	bool blue_flame_light = 
				currentRenderedItemId == 10033 ||  currentRenderedItemId == 10001
				//|| entityId == 20010
				|| mc_Entity.x == 10033.0
				;
	bool red_light = 
				currentRenderedItemId == 100023 ||  currentRenderedItemId == 10034
				//|| entityId == 20010
				|| mc_Entity.x == 10034.0
				;			
	

				
	
	

	#if IS_PARTICLE == 1 || IS_HAND == 1
		float emmissiveness = light_source ?  15. : 0. ;
	#else
		
		float emmissiveness = !light_source ?  0. :
                renderStage == MC_RENDER_STAGE_ENTITIES? 

				( light_source ? 15. 
				#if PBR_LPV_EMISSION == 1
					* EPBR_EMMISIVENESS_IN_VOXELS_ENTITY
				#endif
				: 0. )
			: 
				mc_Entity.x == 10037. ? 15. :  
					mc_Entity.x == 10038. ? 5. : 
						mc_Entity.x == 10039. ? 2. : 
						
						mc_Entity.x == 10039. ? 2. : 
                        (mc_Entity.x >= 10101 && mc_Entity.x <= 10199) ? 15.:
							#if PBR_LPV_EMISSION == 1
								max(at_midBlock.w,pbr_emmissive * 15. 
									* PBR_EMMISIVENESS_IN_VOXELS_TERRAIN 
								)
							#else
								at_midBlock.w
							#endif
			;
			
	
	#endif
	
	 #if IS_COLOR_WHEEL == 1

       
		if(
			(mc_Entity.x >= 10071 && mc_Entity.x <= 10075)
			|| (mc_Entity.x >= 10101 && mc_Entity.x <= 10199) 
			|| at_midBlock.w > 0.
		)
		{
			light_source = true;//lmcoord_cw.x>.9;
			emmissiveness = at_midBlock.w > 0.?at_midBlock.w : 15.;//at_midBlock.w;
			
		}
//		emmissiveness = at_midBlock.w;
     #endif		
	
		
	#if MOB_SHADOWS == 0
	if( !(renderStage == MC_RENDER_STAGE_ENTITIES && emmissiveness<0.01) )
	#endif
	{
	#if VOXEL_PHOTON_SIMULATION_QUALITY < 2
	if(emmissiveness>0.01)
	#endif
	{
		//pick data to send
		#define VISUALIZED_DATA 3 //[0 1 2 3 4]
		#if VISUALIZED_DATA == 0
			//visualize color average
			vec4 voxel_data =	vec4(textureLod(texture, texcoord,log2(float(textureSize(texture, 0).x))).rgb* glcolor.rgb,1.);
		#endif
		#if VISUALIZED_DATA == 1
			//visualize position
			vec4 voxel_data = vec4(fract((block_centered_relative_pos.xyz+floor(cameraPosition))*.05),1.);
		#endif
		#if VISUALIZED_DATA == 2
			//visualize color of one pixel
			vec4 voxel_data =	vec4(textureLod(texture, texcoord,0).rgb* glcolor.rgb,1.);
		#endif
		#if VISUALIZED_DATA == 3
		
			#if PBR_LPV_EMISSION != 1
				vec2 quad_center= (gl_TextureMatrix[0] *  mc_midTexCoord).st;
			#endif
			//light value
			vec4 light_color =  textureLod(texture, quad_center,
			log2(float(textureSize(texture, 0).x))
			//textureQueryLevels(texture)
		//	0
			);
			//light_color =texture(texture, quad_center);
			
			light_color.rgb*=glcolor.rgb;
			
			
			light_color.rgb=mix(light_color.rgb,light_color.rgb /max(max(light_color.r,0.001),max(light_color.g,light_color.b)), LIGHT_VIIBRANCE );
			#if ADJUST_SATURATION > 0
				#if SMART_COLOR_SATURATION == 1
					vec3 gray = vec3(light_color.r+light_color.g+light_color.b)*.333;
					float dynamic_saturation = (1.+ SMART_COLOR_SATURATION_BOOST *(1.-length(light_color.rgb - gray)));
					dynamic_saturation= max( LIGHT_COLOR_SATURATION , dynamic_saturation );
					light_color.rgb = mix( gray , light_color.rgb, dynamic_saturation );
				#else
					light_color.rgb = mix( vec3(light_color.r+light_color.g+light_color.b)*.333, light_color.rgb, LIGHT_COLOR_SATURATION);
				#endif
			
			#endif
			
				
			#if FLICKERING_TORCHES == 1
				light_color.rgb =( flame_light) ? 
				vec3(TORCH_HI_R,TORCH_HI_G,TORCH_HI_B)
				: (mc_Entity.x == 10032.0) ?  
					mix(vec3(TORCH_HI_R,TORCH_HI_G,TORCH_HI_B),
					vec3(TORCH_LOW_R,TORCH_LOW_G,TORCH_LOW_B),
				( (mc_Entity.x == 10032.0) ?  
				
					//lava flicker
					#if IS_THE_NETHER == 1 
						clamp((world_pos.y-LAVA_LEVEL)/100.
					
						#if PULSING_AMBIENT_LIGHT == 1
							*(2.+1.*sin(frameTimeCounter))
						#endif
						
						,0.,1.)
					#else
						.5
					#endif
				
				
				 : 
				 //TORCH FLICKER
				 (.7+.2*sin(frameTimeCounter*1.+world_pos.x)+.2*sin(frameTimeCounter*2.+world_pos.z)+.1*sin(frameTimeCounter*5. +world_pos.y))
				 )
				)
				
				: (blue_flame_light)  ?  vec3(SOUL_FIRE_DARK_R,SOUL_FIRE_DARK_G,SOUL_FIRE_DARK_B)
				: (red_light) ?  vec3(RED_STONE_R, RED_STONE_G, RED_STONE_B)
				: mc_Entity.x == 10035.0 ? vec3(TORCH_HI_R,TORCH_HI_G,TORCH_HI_B)
				: mc_Entity.x == 10036.0 ? vec3(SOUL_FIRE_BRIGHT_R,SOUL_FIRE_BRIGHT_G,SOUL_FIRE_BRIGHT_B)
				: light_color.rgb;
			#endif
			
			
			#if FLICKERING_TORCHES >= 2 || FLICKERING_TORCHES == 3
				float flow_gredient = (mc_Entity.x == 10032.0) ?  .5:1.;
				float flicker = 
				( (mc_Entity.x == 10032.0) ?  
					//lava flicker
					#if LAVA_NOISE_ORGANIC == 1
						(1.-fractal_noise_3d_lava(frameTimeCounter*vec3(.0,.5,.0)+world_pos*.2)-.5)*2.
					#else
						#if FLICKERING_TORCHES >= 2
								//TORCH FLICKER
								(.7+.2*sin((frameTimeCounter*1.+world_pos.x)*flow_gredient) +.2*sin((frameTimeCounter*2.+world_pos.z)*flow_gredient)+.1*sin((frameTimeCounter*5.+world_pos.y)*flow_gredient))					
						#else
								1.
						#endif
					#endif
				
				 : 
					1.
					 #if FLICKERING_TORCHES == 2
						*	 //TORCH FLICKER
						(.7+.2*sin((frameTimeCounter*1.+world_pos.x)*flow_gredient) +.2*sin((frameTimeCounter*2.+world_pos.z)*flow_gredient)+.1*sin((frameTimeCounter*5.+world_pos.y)*flow_gredient))
					 #endif
				 )
				 
				
				 ;
				 
				light_color.rgb =
				(flame_light) 
				|| (mc_Entity.x == 10032.0)
				? mix(vec3(TORCH_LOW_R,TORCH_LOW_G,TORCH_LOW_B),
				vec3(TORCH_HI_R,TORCH_HI_G,TORCH_HI_B),
				
				.3+.5* flicker
				
				) 
				
				*((entityId == 20010.0) ? 1. :  //entity flame, blaze
					.5 +.5*flicker)
				
				: (blue_flame_light) ?   mix( vec3(SOUL_FIRE_BRIGHT_R,SOUL_FIRE_BRIGHT_G,SOUL_FIRE_BRIGHT_B),vec3(SOUL_FIRE_DARK_R,SOUL_FIRE_DARK_G,SOUL_FIRE_DARK_B),.3+.5* flicker) 
				: (red_light) ?  vec3(RED_STONE_R, RED_STONE_G, RED_STONE_B)
				: mc_Entity.x == 10035.0 ? vec3(TORCH_HI_R,TORCH_HI_G,TORCH_HI_B)
				: mc_Entity.x == 10036.0 ?   mix( vec3(SOUL_LANTERN_R_HIGH,SOUL_LANTERN_R_HIGH,SOUL_LANTERN_G_HIGH),vec3(SOUL_LANTERN_R_HIGH,SOUL_LANTERN_G_HIGH,SOUL_LANTERN_B_HIGH),.3+.5* flicker) 
				: light_color.rgb;
			#endif
			
			#include "/hard_coded_blocks.glsl"
			
			
			
			#if VOXEL_PHOTON_SIMULATION_QUALITY >= 2
				vec4 voxel_data =	emmissiveness > 0.001 ? vec4(emmissiveness/15.*light_color.rgb,.43
				#if PBR_LPV_EMISSION == 1 && USE_PBR_TO_GET_RIGHT_FACE == 1
					+.06* pbr_emmissive
				#endif
				)
				: renderStage == MC_RENDER_STAGE_TERRAIN_TRANSLUCENT || light_color.a< .8 ? vec4(light_color.rgb,.1)
                : c_id==10200.? vec4(light_color.rgb,.31)
                : c_id==10201.? vec4(light_color.rgb,.32)
                : c_id==10202.? vec4(light_color.rgb,.33)
                : c_id==10203.? vec4(light_color.rgb,.34)
                : c_id==10204.? vec4(light_color.rgb,.35)

				:  vec4(light_color.rgb,0.23)
				;
				
				
				
				
				//voxel_data.rgb=emmissiveness > 0.001 ?  vec3(1.,1.,1.) : vec3(1.,0.,0.);
			#else
				vec4 voxel_data =	vec4(emmissiveness/15.*light_color.rgb,.23)
				
			;
			#endif
			
		
		#endif
		
		

		
		//pack data
		uint integerValue = packUnorm4x8( voxel_data );
		
		
		#if IS_PARTICLE == 1
			//write data
			voxel_data= light_source ? vec4(light_color.rgb,1.) : vec4(0.);//(mc_Entity.x == 10033.0) ?  vec4(0.,1.,0.,1.) :  vec4(1.,0.,1.,1.);//debug
			
			imageStore(cimage3_colored_light, voxel_pos+double_buffer_offset_write, voxel_data);

		#else
			//write to 3d image	 
			//          //imageStore(  //imageAtomicMax(   are some options for writing, look up on khronos.org (opengl documentation)
			
			
			#if AUTO_HAND_HELD_COLOR_DETECTION >= 1  
				#if !(VOXELIZE_PLAYER == 0 || OTHER_PLAYER_LIGHTS == 0)
					vec3 abs_foot = abs(world_pos-eyePosition);
				#endif
				
				
				
				
				
					
					
					
					
				if(
					#if  (HAND_LIGHT_CAPTURE_BACKUP == 1 && IS_HAND == 1) && FLOODFILL_LIGHTING > 0
						emmissiveness>0.0001
					#else
						renderStage == MC_RENDER_STAGE_ENTITIES 
						&& entityId == 20014 //player
					//	&& (currentRenderedItemId == heldItemId || currentRenderedItemId == heldItemId2)
						&& max(max(abs_foot.x,abs_foot.y),abs_foot.z) < RANGE_FOR_DISABLING_PLAYER_HELD_LIGHTS
					#endif
				)
				{
				
					#if AUTO_HAND_HELD_COLOR_DETECTION == 1  
						//layout (r32ui) uniform uimage2D cimage_held_light; //8x8
						vec4 hand_data = emmissiveness > 0.001 ? voxel_data : vec4(0.);
						float gray = (hand_data.r+hand_data.g+hand_data.b)*.33;
				//		hand_data*=vec4(vec3(hand_data.a),gray);
						hand_data.a=gray;
										
						uint hand_integerValue = packUnorm4x8(hand_data);
						
						imageAtomicMax( cimage_held_light, ivec2(0), hand_integerValue );

						integerValue=0u; //prevent voxelization
					#endif
					
					#if AUTO_HAND_HELD_COLOR_DETECTION == 2
						//layout (r32ui) uniform uimage2D cimage_held_light; //8x8
						vec4 hand_data = emmissiveness > 0.001 ? vec4(light_color.rgb,emmissiveness/15.) : vec4(0.);
						hand_data.rgb*=hand_data.a;
						
						imageAtomicMax( cimage_held_light, ivec2(0), packUnorm4x8(vec4(hand_data.r) ) );
						imageAtomicMax( cimage_held_light, ivec2(1), packUnorm4x8(vec4(hand_data.g) ) );
						imageAtomicMax( cimage_held_light, ivec2(2), packUnorm4x8(vec4(hand_data.b) ) );

						integerValue=0u; //prevent voxelization
					#endif
					
					#if AUTO_HAND_HELD_COLOR_DETECTION == 3  
						//vec3 side_body = cross(normalize(playerBodyVector
							// +2.*(cameraPosition-previousCameraPosition)
						//	),
						//	vec3(0.,1.,0.) 
						//	);
						
						//layout (r32ui) uniform uimage2D cimage_held_light; //8x8
						vec4 hand_data = emmissiveness > 0.001 ? voxel_data : vec4(0.);
						float gray = (hand_data.r+hand_data.g+hand_data.b)*.33;
				//		hand_data*=vec4(vec3(hand_data.a),gray);
						hand_data.a=gray;
						
				//		hand_data=vec4(1.,0.,0.,1.);///deebug
										
						uint hand_integerValue = packUnorm4x8(hand_data);
						
						
						
						imageAtomicMax( cimage_held_light, 
							//(dot(normalize(foot_pos),side_body)> 0.
							(hand_data.r > hand_data.b && hand_data.r > hand_data.g ? ivec2(0) 
							: hand_data.b > hand_data.g && hand_data.b > hand_data.r ? ivec2(1)
							: ivec2(2)
							)
							, hand_integerValue );

						integerValue=0u; //prevent voxelization
					#endif
					#if AUTO_HAND_HELD_COLOR_DETECTION == 4
						//layout (r32ui) uniform uimage2D cimage_held_light; //8x8
						vec4 hand_data = emmissiveness > 0.001 ? vec4(light_color.rgb,emmissiveness/15.) : vec4(0.);
						hand_data.rgb*=hand_data.a;
						
						imageAtomicMax( cimage_held_light, ivec2(0), packUnorm4x8(vec4(hand_data.rgb,hand_data.r) ) );
						imageAtomicMax( cimage_held_light, ivec2(1), packUnorm4x8(vec4(hand_data.rgb,hand_data.g) ) );
						imageAtomicMax( cimage_held_light, ivec2(2), packUnorm4x8(vec4(hand_data.rgb,hand_data.b) ) );

						integerValue=0u; //prevent voxelization
					#endif
					#if AUTO_HAND_HELD_COLOR_DETECTION == 5 
						vec3 side_body = cross(normalize(playerBodyVector
							// +2.*(cameraPosition-previousCameraPosition)
							),
							vec3(0.,1.,0.) 
							);
						
						//layout (r32ui) uniform uimage2D cimage_held_light; //8x8
						vec4 hand_data = emmissiveness > 0.001 ? vec4(light_color.rgb,emmissiveness/15.) : vec4(0.);
						float gray = (hand_data.r+hand_data.g+hand_data.b)*.33;
						hand_data*=vec4(vec3(hand_data.a),gray);
										
						uint hand_integerValue = packUnorm4x8(hand_data);
						
						imageAtomicMax( cimage_held_light, 
							(dot(normalize(foot_pos),side_body)> 0. ? ivec2(0) : ivec2(1))
							, hand_integerValue );

						integerValue=0u; //prevent voxelization
					#endif
                #if AUTO_HAND_HELD_COLOR_DETECTION == 6
                        //hard coded lists in prepare 
					
					#endif
					
				}
			#endif
			
			
			
			#if PARTIAL_BLOCKS_OCCLUDE == 0
				if( 
					renderStage == MC_RENDER_STAGE_TERRAIN_TRANSLUCENT ||
                    (c_id>=10200.&&c_id<=10204.)||
					!(abs(length(at_midBlock.xyz)-55.) > .5  || light_color.a < .9)
					|| emmissiveness >0.
				
				)
				{
		
					imageAtomicMax( cimage1, voxel_pos, integerValue );	
					
					
				}
			#else
				imageAtomicMax( cimage1, voxel_pos, integerValue );	
			#endif
			
			
			
			
		#endif
		
		
						
				
			
	}//if a light source
		
	}
	
	}//not a carpet
	
	}//not an unglowing entity, if not doing all entities
	
	
	
	
	
	
	
		
