Shader "Custom RP/Unlit"
{
    Properties
    {
        // The property name must be followed by a string for use in the inspector and a Color type identifier, as if providing arguments to a method.
        _BaseColor("Color", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader
    {
        Pass
        {
            HLSLPROGRAM
            #pragma multi_compile_instancing
            #pragma vertex UnlitPassVertex
            #pragma fragment UnlitPassFragment
            #include "UnlitPass.hlsl"
            ENDHLSL
        }
    }
}
