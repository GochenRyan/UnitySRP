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

// Wrap the material properties using the CBUFFER macro directive of the Core RP Library to enable the Shader to support SRP Batcher, and automatically disable it on platforms that do not support SRP Batcher.
// After CBUFFER_START, a parameter should be added, which represents the name of the C buffer (Unity has some built-in names, such as UnityPerMaterial and UnityPerDraw).
// CBUFFER_START(UnityPerMaterial)
// float4 _BaseColor;
// CBUFFER_END

// To use GPU Instancing, each instance data needs to be constructed as an array, and each instance data is wrapped using UNITY_INSTANCING_BUFFER_START(END)
UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
    // The definition format of _BaseColor in an array
    UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)

struct Attributes
{
    float3 positionOS : POSITION;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varyings
{
    float4 positionCS : SV_POSITION;
	UNITY_VERTEX_INPUT_INSTANCE_ID
};


/*
    ': ???' means return value is ???
*/

Varyings UnlitPassVertex(Attributes input)
{
    Varyings output;
    // Extract the ID of the instance from the input and store it in the global static variable on which other instantiated macros depend
    UNITY_SETUP_INSTANCE_ID(input);
    // Pass instance ID to output
    UNITY_TRANSFER_INSTANCE_ID(input, output);
    float3 positionWS = TransformObjectToWorld(input.positionOS);
    output.positionCS = TransformWorldToHClip(positionWS);
    return output;
}

float4 UnlitPassFragment(Varyings input) : SV_TARGET
{
    // Extract the ID of the instance from the input and store it in the global static variable on which other instantiated macros depend
    UNITY_SETUP_INSTANCE_ID(input);
    // Obtain the data for each instance
    return UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _BaseColor);;
}

#endif