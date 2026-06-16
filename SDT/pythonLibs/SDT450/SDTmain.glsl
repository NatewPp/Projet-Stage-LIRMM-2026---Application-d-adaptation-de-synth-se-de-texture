// Required includes for texture synthesis

#ifndef GBUFFERMODELVIEWINVERSE
uniform mat4 gbufferModelViewInverse;
#define GBUFFERMODELVIEWINVERSE
#endif

#ifndef GBUFFERPROJECTIONINVERSE
uniform mat4 gbufferProjectionInverse;
#define GBUFFERPROJECTIONINVERSE
#endif 

#ifndef VIEWWIDTH
uniform float viewWidth;
#define VIEWWIDTH
#endif  

#ifndef VIEWHEIGHT
uniform float viewHeight;
#define VIEWHEIGHT
#endif

#ifndef CAMERAPOSITION
uniform vec3 cameraPosition;
#define CAMERAPOSITION
#endif

#ifndef TEX
uniform sampler2D tex;
#define TEX
#endif

//========== DÉCLARATION DES MATRICES MODERNES UNIFORMS ==========
// Si le moteur ne les fournit pas sous ce nom, remplacez-les par celles de votre projet
#ifndef MODELVIEWMATRIX
uniform mat4 modelViewMatrix;
#define MODELVIEWMATRIX
#endif

#ifndef NORMALMATRIX
uniform mat3 normalMatrix; 
#define NORMALMATRIX
#endif

#ifdef VSHSDT
//========== VERTEX SHADER COMPONENT ==========

// Attributs d'entrée (obligatoires en 450 si non déclarés dans le .vsh principal)
#ifndef VAPOSITION
in vec4 vaPosition;  // Remplace gl_Vertex
#define VAPOSITION
#endif
#ifndef VANORMAL
in vec3 vaNormal;
#define VANORMAL
#endif
#ifndef VAUV0
#define VAUV0
in vec4 vaUV0;       // Remplace gl_MultiTexCoord0
#endif
// Les varyings deviennent des 'out' dans le Vertex Shader
#ifndef VARYINGSDT
#define VARYINGSDT
out vec2 sdtTexCoord;
out vec3 sdtNormal;
out vec4 sdtWavingOffset;
out vec3 sdtPlayerPos;
#endif

void PrepareTextureSynthesisVSH() {
    // Passage des coordonnées de texture (sans la vieille matrice gl_TextureMatrix)
    sdtTexCoord = vaUV0.xy;

    // Calcul de la normale avec la matrice Uniform
    sdtNormal = normalize(normalMatrix * vaNormal);
    
    // WavingOffset is shader specific.
    sdtWavingOffset = vec4(0.0);

    // Calcul de la position du joueur (relative à la caméra)
    sdtPlayerPos = (gbufferModelViewInverse * (modelViewMatrix * vaPosition)).xyz;
}

#endif // VSHSDT

#ifdef FSHSDT
//========== FRAGMENT SHADER COMPONENT ==========

// Les varyings deviennent des 'in' dans le Fragment Shader
in vec2 sdtTexCoord;
in vec3 sdtNormal;
in vec4 sdtWavingOffset;
in vec3 sdtPlayerPos;

#include "/lib/sdt/textureSynthesis.glsl"
#ifndef ATLASSIZE
uniform ivec2 atlasSize;
#define ATLASSIZE
#endif

#include "/lib/sdt/textureSynthesisUVHints.glsl"

vec3 SDTViewToPlayer(vec3 pos) {
    return mat3(gbufferModelViewInverse) * pos + gbufferModelViewInverse[3].xyz;
}

vec3 SDTSDTScreenToView(vec3 pos) {
    vec4 iProjDiag = vec4(gbufferProjectionInverse[0].x,
                          gbufferProjectionInverse[1].y,
                          gbufferProjectionInverse[2].zw);
    vec3 p3 = pos * 2.0 - 1.0;
    vec4 viewPos = iProjDiag * p3.xyzz + gbufferProjectionInverse[3];
    return viewPos.xyz / viewPos.w;
}

void ApplyTextureSynthesis(inout vec4 color) {
    // (Le reste de votre logique interne reste identique...)
    vec2 texCoord = sdtTexCoord;
    vec3 normal = sdtNormal;
    vec4 wavingOffset = sdtWavingOffset;
    
    vec3 playerPos = sdtPlayerPos;
    vec3 playerPosWithoutWaves = playerPos + wavingOffset.xyz;
    ivec3 blockPosFrag = ivec3(floor(playerPosWithoutWaves + cameraPosition + 0.001));
    vec3 worldGeoNormal = normalize(SDTViewToPlayer(normal * 10000.0));
    bool applyTilingAndBlending = false;

    #ifndef ANISOTROPIC_FILTER
        #define ANISOTROPIC_FILTER 0
    #endif

    // [ ... Tout votre gros bloc de boucles If/Else pour l'atlas reste ici inchangé ... ]

    // Fallback texture si aucune synthèse n'est appliquée
    if (!applyTilingAndBlending) {
        #if ANISOTROPIC_FILTER == 0
            // 💡 Remplacement de texture2D par texture (Standard GLSL 450)
            color.rgba = texture(tex, texCoord); 
        #else
            color.rgba = textureAF(tex, texCoord);
        #endif
    }
}

#endif // FSHSDT