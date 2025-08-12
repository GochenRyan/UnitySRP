#ifndef CUSTOM_UNLIT_PASS_INCLUDE
#define CUSTOM_UNLIT_PASS_INCLUDE

#include "../ShaderLibrary/Common.hlsl"

/*
// Constant buffers aren't supported on all platforms—like OpenGL ES 2.0—so instead of using cbuffer directly 
// we can use the CBUFFER_START and CBUFFER_END macros that we included from the Core RP Library. 
cbuffer UnityPerMaterial
{
    // The leading underscore is the standard way to indicate that it represents a material property. 
    float4 _BaseColor;
};
*/

/*
    UnityPerDraw:
        Each variable of the Draw Call (such as unity_ObjectToWorld).
    UnityPerFrame:
        The variables of each frame (such as camera parameters).
    UnityPerMaterial:
        Material-related variables (such as color and texture samplers)
*/

CBUFFER_START(UnityPerMaterial)
float4 _BaseColor;
CBUFFER_END


/*
    ': ???' means return value is ???
*/

float4 UnlitPassVertex(float3 positionOS : POSITION) : SV_POSITION
{
    float3 positionWS = TransformObjectToWorld(positionOS.xyz);
    return TransformWorldToHClip(positionWS);
}

float4 UnlitPassFragment() : SV_TARGET
{
    return _BaseColor;
}

#endif