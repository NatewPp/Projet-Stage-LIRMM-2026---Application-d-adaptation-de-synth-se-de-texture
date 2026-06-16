
//image.cimage_photonics_lighting = cSampler_photonics_lighting RGBA RGBA8 BYTE true true 
//layout (rgba8) uniform image2D cimage_photonics_lighting;
writeonly uniform image2D cimage_photonics_lighting;
//uniform sampler2D radiosity_direct;
//uniform sampler2D radiosity_direct_soft;
//uniform sampler2D radiosity_handheld;

void write_indirect(vec3 color)
{
    /*
    vec3 ph_direct = texture(radiosity_direct, gl_FragCoord).rgb;

    vec4 ph_direct_soft = texture(radiosity_direct_soft, gl_FragCoord);
    ph_direct_soft.rgb = ph_direct_soft.rgb / max(ph_direct_soft.a, 1.0f);

    vec3 ph_handheld = texture(radiosity_handheld, gl_FragCoord).rgb;
*/

    imageStore(cimage_photonics_lighting, ivec2(gl_FragCoord.xy), vec4(color, 1f));
    
}
