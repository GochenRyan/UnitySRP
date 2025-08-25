#ifndef CUSTOM_LIGHTING_INCLUDED
#define CUSTOM_LIGHTING_INCLUDED

float3 IncomingLight(Surface surface, Light light)
{
    return dot(surface.normal, light.direction) * light.color;
}

float3 GetLighting(Surface surface)
{
    return IncomingLight(surface, GetDirectionalLight());
}

float3 GetLighting(Surface surface, Light light)
{
    return IncomingLight(surface, light);
}

#endif