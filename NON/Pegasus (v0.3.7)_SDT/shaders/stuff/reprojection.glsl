

vec3 last_world_pos_dir = 	
			(gbufferModelViewInverse*vec4((view_pos.xyz ), 1.)).xyz
			//+(cameraPosition-previousCameraPosition)
			;

vec4 old_raydir;

old_raydir.xyz = 
	(gbufferPreviousModelView*
	vec4(last_world_pos_dir.xyz
	,1.)).xyz;

old_raydir= gbufferPreviousProjection*vec4(old_raydir.xyz,1.);
float sz = old_raydir.z;
old_raydir.xyz/=old_raydir.w;
old_raydir.xyz=old_raydir.xyz*.5+.5;

vec4 ray_color;

if((old_raydir.x>=0. &&old_raydir.x<1.&&old_raydir.y>=0.&&old_raydir.y<=1. && sz>0.) )
{
	ray_color = texture2D(colortex6,old_raydir.xy);
}else{
	ray_color.rgb = color.rgb;
}

color.rgb = clamp(mix(color.rgb, ray_color.rgb,.9),0.,1.);