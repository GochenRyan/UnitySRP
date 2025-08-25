using UnityEngine;
using UnityEngine.Rendering;

public class Lighting
{
    const string bufferName = "Lighting";

    static int dirlightColorId = Shader.PropertyToID("_DirectionalLightColor");
    static int dirlightDirectionId = Shader.PropertyToID("_DirectionalLightDirection");

    CommandBuffer buffer = new CommandBuffer
    {
        name = bufferName
    };

    public void Setup(ScriptableRenderContext context)
    {
        buffer.BeginSample(bufferName);
        SetupDirectionalLight();
        buffer.EndSample(bufferName);
        context.ExecuteCommandBuffer(buffer);
        buffer.Clear();
    }

    void SetupDirectionalLight()
    {
        Light light = RenderSettings.sun;
        buffer.SetGlobalVector(dirlightColorId, light.color.linear);
        /*
            Yes, vectors send to the GPU always have four components, even if we define them with less. 
            The extra components are implicitly masked out in the shader. Likewise, there's an implicit conversion from Vector3 to Vector4, though not in the other direction.
        */
        buffer.SetGlobalVector(dirlightDirectionId, -light.transform.forward);
    }
}
