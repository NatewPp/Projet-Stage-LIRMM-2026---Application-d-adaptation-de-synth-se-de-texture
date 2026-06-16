// © Copyright 2023-2024 timetravelbeard (contact: https://www.patreon.com/timetravelbeard , https://youtube.com/@timetravelbeard3588 , https://discord.gg/S6F4r6K5yU )

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//NOTE:  In case you don't know, copyright means all rights are reserved. You cannot modify, redistribute, or make derivative works of this. Do not steal any of this code or use "code snippets". 


#if GEN_NORMAL_MAP > 0 && IS_AN_ENTITY != 1

		//check for blank _s or _n texture
		if ( abs(normals_pixel.r - N_BLANK_R )+abs(normals_pixel.g - N_BLANK_G )+abs(normals_pixel.b - N_BLANK_B )+abs(normals_pixel.a - N_BLANK_A ) < 5.0/255.0)
		{
			#if DEBUG_GEN_NORMAL_MAP == 1
				color.rgb=vec3(0.0,1.0,0.0) ;
			#else	
				normals_pixel= atlas_uv_to_generated_normals(pom_target_coord.xy, 0.0);
			#endif

		}
#endif		
		
		
		
#endif