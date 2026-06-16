vec3 seed1 = vec3(gl_FragCoord.xy,10.);//viewPos.xyz;
vec3 seed2 = vec3(gl_FragCoord.yx,20.);//viewPos.xyz;




float ao_steps = AO_SAMPLES;

float ao = 0.;

		float total_weight = 1.;
		for(float i = 1.;i<= AO_SAMPLES ;i++)
		{
			float samplling_width = max(.01, (i/AO_SAMPLES)*AO_WIDTH /(1.+ao_dist) );
			
			float r = i*AO_SPIN;
			
			vec2 spiral=vec2(sin(r),cos(r)) * max(samplling_width,AO_EXTRA_SOFTNESS);
			
			#if AO == 3
				vec3 noise_blur = noise3from3_ver2(vec3(texcoord,i))-.5;
				float mip = 0.;
			#endif
			#if AO == 4
				vec3 noise_blur = noise3from3_ver2(vec3(spiral.xy,i))-.5;
				float mip = 0.;
			#endif
			
			noise_blur=vec3(1.);//+noise_blur*.1;//debug
			
			spiral=spiral*(AO_NOISE_STR*noise_blur.xy) 
			* (mix(1.,noise_blur.z*3.0,SHADOW_NOISE_VARIATION ));
			
			#if FLIP_SHADOW_SPIRAL_RANDOMLY == 1
				spiral *= vec2(sign(random(i)-.5) , sign(random(i+5.)-.5)  );
			#endif
			#if FLIP_SHADOW_SPIRAL_RANDOMLY == 2
				spiral *= vec2(sign(hashfrom3(seed1)-.5) , sign(hashfrom3(seed2)-.5)  );
			#endif
			
			vec2 norm_dir = normals.xy*.0/(ao_dist+1.)*(i/ao_steps);
			float ao_wide = get_depth_at_lod(texcoord+spiral+norm_dir.xy-samplling_width*0.,mip).x;
			
			/*
			float oc = ao_dist - ao_wide;
			oc=oc>.5?oc-(oc-.5):oc;
			//oc=ao_dist<5.?oc*(1.+2.*(1.-ao_dist/5.)) : oc/(ao_dist-5.);
			oc/=ao_dist*.25;
			ao+=max(0.,oc)*pow(1.-i/ao_steps,1.);

			float weight = mix(1.,1.-i/(AO_SAMPLES+1.),AO_SOFTNESS_WEIGHT);
			total_weight+=weight;
			*/
			
			//
			float oclussion_dist = .5 +0.*ao_dist;
			float oc = ao_dist - ao_wide;
			oc=ao_dist<2.?oc*(1.+11.*pow(1.-ao_dist/2.,1.3)) : oc;///(ao_dist-5.);
			//	oc/=1.*pow(ao_dist/far,.8);
			oc=oc<oclussion_dist?oc: oc-(oc-oclussion_dist)/oclussion_dist;
			float weight = pow(1.-i/ao_steps,1.0);
			total_weight+=weight;
			ao+=max(0.,oc)*weight;
			//
				
				;
		}
		
	//	ao=clamp( pow(clamp(ao/(total_weight),0.,1.),SHADOW_WEIGHT_EXPONENT) ,0.,1.);
