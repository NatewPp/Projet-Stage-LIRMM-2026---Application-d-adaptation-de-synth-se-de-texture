
#if IS_THE_NETHER == 1

	void main() {

		discard;
		return;
		
	}

#else

	uniform sampler2D lightmap;
	uniform sampler2D texture;

	varying vec2 lmcoord;
	varying vec2 texcoord;
	varying vec4 glcolor;

    #if IS_COLOR_WHEEL == 1
         layout(location = 0) out vec4 color;
    #endif

	void main() {

		
        #if IS_COLOR_WHEEL == 1
            vec4 color = texture(texture, texcoord);
            vec2 lmcoord;
            float ao;
            vec4 overlayColor;

            clrwl_computeFragment(color, color, lmcoord, ao, overlayColor);
 

        #else
            
            vec4 color = texture(texture, texcoord) * glcolor;
		    color.rgb=color.a > 254.6/255.?vec3(1.):color.rgb;
		    gl_FragData[0] = color;

        #endif
		
	}

#endif
	
	
