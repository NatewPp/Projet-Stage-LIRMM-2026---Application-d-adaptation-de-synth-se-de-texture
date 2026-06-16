// © Copyright 2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


//last noted update: 2024-5-16




//standard conversions between equrectangular abd cartesuan


vec3 unrolled_to_raydir(in vec2 uv) {
    //convert to lat, long 
    float azimuth = uv.x * 2.0 * 3.14 - 3.14;//east, west
    float inclination = uv.y * 3.14;//north, south
    //wrap map onto globe, retirn
    return 
      normalize( vec3(
       sin(inclination) * cos(azimuth),
       cos(inclination),
        sin(inclination) * sin(azimuth)
      ));
}//func


vec2 raydir_to_unrolled(in vec3 raydir) {
    //get long, lat
    float azimuth = atan(raydir.z, raydir.x);
    float inclination = acos(raydir.y);
    // Normalize 0.to 1., return
    return vec2(
        (azimuth + 3.14) / (2.0 * 3.14),
         inclination / 3.14
       );
}//func




//for multiplayer boxes


vec3 mp_screen_coords_int_to_raydir(in ivec2 uvi,in ivec4 rect) {
	//get 0to1 uv in box from multiplayer screen uvi 
	vec2 uv=vec2(uvi-rect.xy)/vec2(rect.zw-rect.xy);
       //convert to lat, long radian junk
    float azimuth = uv.x * 2.0 * 3.14 - 3.14;
    float inclination = uv.y * 3.14;
    //wrap map onto globe
    return 
      normalize( vec3(
       sin(inclination) * cos(azimuth),
       -cos(inclination),
        sin(inclination) * sin(azimuth)
      ));
}


ivec2 raydir_to_mp_screen_coords_int(in vec3 raydir, in vec4 rect) {
    //get long, lat
    float azimuth = atan(raydir.z, raydir.x);
    float inclination = acos(raydir.y);
    // Normalize 0.to 1., put in box, return
    return ivec2(
		rect.xy+(rect.zw-rect.xy)*vec2(
			(azimuth + 3.14) / (2.0 * 3.14),
			-inclination / 3.14
			)
		);
}
