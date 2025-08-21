Shader "Custom RP/Lit"
{
    Properties
    {
        // '{}':  It was used to control the texture settings long ago, but should still be included today to prevent weird errors in some cases.
        _BaseMap("Texture", 2D) = "white" {}
        // The property name must be followed by a string for use in the inspector and a Color type identifier, as if providing arguments to a method.
        _BaseColor("Color", Color) = (0.5, 0.5, 0.5, 1.0)
        //  Alpha Clipping : the usual ways that this is done is by defining a cutoff threshold. Fragments with alpha values below this threshold are to be discarded while all others are kept.
        _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5
        [Toggle(_CLIPPING)]
        _Clipping("Alpha Clipping", Float) = 0
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
            /*
                We're going to use a custom lighting approach by setting the light mode of our shader to CustomLit.
            */
            Tags
            {
                "LightMode" = "CustomLit"
            }

            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]

            HLSLPROGRAM
            /*
                Enabling the toggle will add the _CLIPPING keyword to the material's list of active keywords, while disabling will remove it. But that doesn't do anything on its own. 
                We have to tell Unity to compile a different version of our shader based on whether the keyword is defined or not. 
            */
            #pragma shader_feature _CLIPPING
            // This command will cause Unity to generate two variants of this Shader, one supporting GPU Instancing and the other not.
            #pragma multi_compile_instancing
            #pragma vertex LitPassVertex
            #pragma fragment LitPassFragment
            #include "LitPass.hlsl"
            ENDHLSL
        }
    }
}
