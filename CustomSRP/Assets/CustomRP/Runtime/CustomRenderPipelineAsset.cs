using UnityEngine;
using UnityEngine.Rendering;

/// <summary>
/// The main purpose of the RP asset is to give Unity a way to get a hold of a pipeline object instance that is responsible for rendering. 
/// The asset itself is just a handle and a place to store settings.
/// </summary>
[CreateAssetMenu(menuName = "Rendering/Custom Render Pipeline")]
public class CustomRenderPipelineAsset : RenderPipelineAsset
{
    [SerializeField]
    bool useDynamicBatching = true;
    [SerializeField]
    bool useGPUInstancing = true;
    [SerializeField]
    bool useSRPBather = true;
    protected override RenderPipeline CreatePipeline()
    {
        return new CustomRenderPipeline(useDynamicBatching, useGPUInstancing, useSRPBather);
    }
}
