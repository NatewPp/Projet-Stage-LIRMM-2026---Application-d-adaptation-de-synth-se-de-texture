#if MC_VERSION >= 11300
    #if WATERCOLOR_MODE >= 2
        vec3 glColorM = glColor.rgb;

        #if WATERCOLOR_MODE >= 3
            glColorM.g = max(glColorM.g, 0.39);
        #endif

        glColorM = sqrt1(glColorM) * vec3(1.0, 0.85, 0.8);
    #else
        vec3 glColorM = vec3(0.43, 0.6, 0.8);
    #endif

    #if WATER_STYLE < 3
        vec3 colorPM = pow2(colorP.rgb);
        color.rgb = colorPM * glColorM;
    #else
        vec3 colorPM = vec3(0.25);
        color.rgb = 0.375 * glColorM;
    #endif
#else
    #if WATER_STYLE < 3
        color.rgb = mix(color.rgb, vec3(GetLuminance(color.rgb)), 0.88);
        color.rgb = pow2(color.rgb) * vec3(2.3, 3.5, 3.1) * 0.9;
    #endif
#endif

#ifdef WATERCOLOR_CHANGED
    color.rgb *= vec3(WATERCOLOR_RM, WATERCOLOR_GM, WATERCOLOR_BM);
#endif

#ifdef GBUFFERS_WATER
   #if WATERCOLOR_B = 200
         reflectMult = 1.0;
   #else
         reflectMult = 0.0;
#endif

    ////

    float fresnel2 = pow2(fresnel);
    float fresnel4 = pow2(fresnel2);

    // Final Tweaks
    reflectMult *= 0.3 + 0.3 * NdotUmax0;

	#if WATER_REFLECT_QUALITY > 0
		color.a = mix(color.a, 1, fresnel4);
	#else
		color.a = mix(color.a, 0.5, fresnel4);
	#endif
#endif
