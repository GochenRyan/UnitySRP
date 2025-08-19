Shader "Custom RP/Unlit"
{
    Properties
    {
        // '{}':  It was used to control the texture settings long ago, but should still be included today to prevent weird errors in some cases.
        _BaseMap("Texture", 2D) = "white" {}
        // The property name must be followed by a string for use in the inspector and a Color type identifier, as if providing arguments to a method.
        _BaseColor("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        [Enum(UnityEngine.Rendering.BlendMode)]

        // The "source" refers to the color to be drawn, and the "destination" refers to the current color of the pixel.
        _SrcBlend("Src Blend", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend("Dst Blend", Float) = 0

        [Enum(Off, 0, On, 1)]
        _ZWrite("Z Write", Float) = 1
    }
    SubShader
    {
        Pass
        {
            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]

            HLSLPROGRAM
            // This command will cause Unity to generate two variants of this Shader, one supporting GPU Instancing and the other not.
            #pragma multi_compile_instancing
            #pragma vertex UnlitPassVertex
            #pragma fragment UnlitPassFragment
            #include "UnlitPass.hlsl"
            ENDHLSL
        }
    }
}
