

#include "/settings.glsl"

//Uniforms

    //uniform float viewWidth;
    //uniform float viewHeight;
    //uniform mat4 gbufferProjectionInverse;
    //uniform mat4 gbufferModelViewInverse;
    //uniform vec3 cameraPosition;
    uniform float far, near;
    uniform vec3 sunPosition;
    uniform vec3 skyColor;

    uniform sampler2D colortex4;//albedo
    //uniform sampler2D colortex10;//early reflectoin
    uniform sampler2D colortex8;//pbr
    //uniform sampler2D colortex6;//sky
    uniform sampler2D colortex9;//sky cubemap
    uniform sampler2D colortex5;//solids
    uniform sampler2D colortex2;//normals
    #if REFRACTIONS == 1
	    uniform sampler2D colortex7;//water
	    uniform sampler2D colortex3;//hand
	    uniform sampler2D depthtex1;
    #endif
    #if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1	
	    uniform sampler2D dhDepthTex1;
    #endif

    //temporary
    uniform sampler2D colortex16;//world pos




//helper functions

    vec3 projectAndDivide(mat4 projectionMatrix, in vec3 position)
    {
	    vec4 position2= projectionMatrix*vec4(position,1.);
	    return position2.xyz/position2.w;
    }

    float linearize_depth(in float d)
    {

        // from gl_FragCoord.z to world measurements
        return 2.0 * near  * far / (far + near - (2.0 * d - 1.0) * (far - near));

    }

    float get_depth_at(vec2 uv)
    {
    #if defined IS_IRIS && defined DISTANT_HORIZONS && BORDERS_IN_DH == 1
	    return texture(colortex1,uv).x;
    #else
	    return linearize_depth(texture(depthtex0,uv).r);
    #endif

    }




//Photonics functions

    vec3 load_world_position()
    {
        vec2 texcoord = (gl_FragCoord.xy/vec2(viewWidth,viewHeight))/PHOTONICS_RENDER_SCALE;
 /*
    vec2 texcoord = gl_FragCoord.xy/vec2(viewWidth,viewHeight);
    vec3 view_dir = vec3(texcoord,1.);
    view_dir+view_dir*2.-1.;
    view_dir = projectAndDivide(gbufferProjectionInverse, view_dir);
    
    vec3 world_dir = (gbufferModelViewInverse*vec4(view_dir,1.)).xyz;

    float depth = get_depth_at(texcoord);

    vec3 world_pos = cameraPosition + world_dir * abs(depth);
    */
   // return world_pos; 
        return texture(colortex16,texcoord).xyz+cameraPosition;
    };


    void load_fragment_variables(
        out vec3 albedo,
        out vec3 world_pos,
        out vec3 world_normal,
        out vec3 world_normal_mapped
    )
    {
        vec2 texcoord = (gl_FragCoord.xy/vec2(viewWidth,viewHeight))/PHOTONICS_RENDER_SCALE;
        albedo = texture(colortex4, texcoord).rgb;

        vec3 normals = normalize( texture(colortex2, texcoord).xyz*2.-1.);

        //not usingf normal maps in test, so pixel and face normals are the samr
        world_normal_mapped = normalize( (gbufferModelViewInverse*vec4(normals.xyz,1.)).xyz );
        world_normal = world_normal_mapped;

        world_pos = load_world_position()-world_normal*.01;


    };


    vec3 sun_direction = normalize( (gbufferModelViewInverse*vec4(sunPosition.xyz,1.)).xyz );

    vec3 indirect_light_color=skyColor*PHOTONICS_SKY/PHOTONICS_BRIGHTNESS;//nullified to rule it out

    vec2 get_taa_jitter()
    {
        return vec2(0.);
    };


    bool is_in_world() {
        // vec2 texcoord = gl_FragCoord.xy/vec2(viewWidth,viewHeight);
        ///   return abs(get_depth_at(texcoord))>0.001;

     return texelFetch(depthtex0, ivec2(gl_FragCoord.xy/PHOTONICS_RENDER_SCALE), 0).x <= 0.99999f;
    }

