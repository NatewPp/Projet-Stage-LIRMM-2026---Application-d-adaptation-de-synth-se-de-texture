vec3 dual_distort(vec3 uv1) {
uv1 = uv1*.5+.5;
	vec2 uv = uv1.xy;//gl_FragCoord.xy / resolution.xy;

//inner 0 to 1
#define DSTR 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
//outer 0 to 1?
#define DHSTR2 0.7 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]


vec2 s = sign(uv-.5);
uv=(uv-.5)*2.;

#define FAR .5
float sint = 1.;//clamp(sin(time),0.,1.);
float sint2 = 1.;// clamp(sin(time*2.),0.,1.);

float d = 1.*(distance((uv/FAR),vec2(0.))-.5)*2.;

float bf = clamp(((d/FAR)*.75)*4.,0.,1.);
uv= ((1.-abs(uv)));


	;

	vec2 uvn = 1.-uv*1.;
	vec2 uv0=
	//uvn;;
	mix(uvn,pow(uvn,vec2(1./2.)),clamp(DSTR*sint2,0.,1.));
	
	uv0 = uv0/(uv0.xy + SHADOW_DISTORT_FACTOR);

uv.x=pow(1.-uv.x,1./clamp(1.+DHSTR2*sint,1.,9.));
uv.y=pow(1.-uv.y,1./clamp(1.+DHSTR2*sint,1.,9.));
;

uv=mix(uv0,uv,bf);

uv=.5+.5*uv*s;

;
uv=uv*2.-1.;
return vec3(uv,uv1.z);


}
 