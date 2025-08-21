#ifndef CUSTOM_LIT_PASS_INCLUDE
#define CUSTOM_LIT_PASS_INCLUDE

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

TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);

// To use GPU Instancing, each instance data needs to be constructed as an array, and each instance data is wrapped using UNITY_INSTANCING_BUFFER_START(END)
UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
    // Unity makes the tiling and offset of the texture available via a float4 that has the same name as the texture property but with _ST appended, 
    // which stands for scale and translation or something like that.
    UNITY_DEFINE_INSTANCED_PROP(float4, _BaseMap_ST)
    // The definition format of _BaseColor in an array
    UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
    UNITY_DEFINE_INSTANCED_PROP(float, _Cutoff)
UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)

struct Attributes
{
    float3 positionOS : POSITION;
    float3 normalOS : NORMAL;
    float2 baseUV : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varyings
{
    float4 positionCS : SV_POSITION;
    float3 normalWS : VAR_NORMAL;
    float2 baseUV : VAR_BASE_UV;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};


/*
    ': ???' means return value is ???
*/

Varyings LitPassVertex(Attributes input)
{
    Varyings output;
    // Extract the ID of the instance from the input and store it in the global static variable on which other instantiated macros depend
    UNITY_SETUP_INSTANCE_ID(input);
    // Pass instance ID to output
    UNITY_TRANSFER_INSTANCE_ID(input, output);
    float3 positionWS = TransformObjectToWorld(input.positionOS);
    output.positionCS = TransformWorldToHClip(positionWS);
    output.normalWS = TransformObjectToWorldNormal(input.normalOS);
    
    float4 baseST = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _BaseMap_ST);
    output.baseUV = input.baseUV * baseST.xy + baseST.zw;
    return output;
}

float4 LitPassFragment(Varyings input) : SV_TARGET
{
    // Extract the ID of the instance from the input and store it in the global static variable on which other instantiated macros depend
    UNITY_SETUP_INSTANCE_ID(input);
    float4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.baseUV);
    // Obtain the data for each instance
    float4 baseColor = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _BaseColor);
    float4 base = baseMap * baseColor;
    
    /*
    // To verify whether we get a correct normal vector in LitPassFragment we can use it as a color.
    base.rgb = input.normalWS;
    */
    
    /*
    // Although the normal vectors are unit-lengh in the vertex program, linear interpolation across triangles affects their length. 
    // We can visualize the error by rendering the difference between one and the vector's length, magnified by ten to make it more obvious.
    base.rgb = abs(length(input.normalWS) - 1) * 10;
    */
    
    base.rgb = normalize(input.normalWS);
    
#if defined(_CLIPPING)
    // It will abort and discard the fragment if the value we pass it is zero or less. 
    clip(base.a - UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _Cutoff));
#endif
    return base;
}

#endif