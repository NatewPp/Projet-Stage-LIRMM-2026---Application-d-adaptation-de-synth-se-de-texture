void get_shadow_light(inout float sss, inout float light, in vec2 uv_check, in  float catcher_z)
{
	light =
#if SSS == 1
		1.-clamp((catcher_z - texture2D(shadowtex1, uv_check.xy).r)*Shadow_map_depth,0.,1.);
		sss=sss*light;
		 light = light<0.999?0.:1.;
	#else
 texture2D(shadowtex1, uv_check.xy).r < catcher_z? 0.:1.;
	#endif
	
	
}


