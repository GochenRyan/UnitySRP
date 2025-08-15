using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Rendering;

public class CustomRenderPipeline : RenderPipeline
{
    CameraRenderer renderer = new CameraRenderer();
    bool useDynamicBatching;
    bool useGPUInstancing;

    public CustomRenderPipeline(bool useDynamicBatching, bool useGPUInstancing, bool useSRPBatcher)
    {
        this.useDynamicBatching = useDynamicBatching;
        this.useGPUInstancing = useGPUInstancing;
        /*
            Rather than reducing the amount of draw calls the SRP batches makes them leaner. 
            It caches material properties on the GPU so they don't have to be sent every draw call. 
            This reduces both the **amount of data** that has to be communicated and the work that the CPU has to do per draw call. 
            But this only works if the shader adheres to a strict structure for uniform data.
         */
        GraphicsSettings.useScriptableRenderPipelineBatching = useSRPBatcher;
    }

    protected override void Render(ScriptableRenderContext context, Camera[] cameras)
    {

    }

    protected override void Render(ScriptableRenderContext context, List<Camera> cameras) 
    {
        for (int i = 0; i < cameras.Count(); ++i)
        {
            renderer.Render(context, cameras[i], useDynamicBatching, useGPUInstancing);
        }
    }
}
