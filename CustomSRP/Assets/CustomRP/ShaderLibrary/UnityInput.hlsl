#ifndef CUSTOM_UNITY_INPUT_INCLUDE
#define CUSTOM_UNITY_INPUT_INCLUDE

CBUFFER_START(UnityPerDraw)  // Define a constant buffer named UnityPerDraw (Predefined constant buffer). Unity will package the variables in this buffer and upload them to the GPU.
float4x4 unity_ObjectToWorld;
float4x4 unity_WorldToObject;
// When defining the (UnityPerDraw) CBuffer, since Unity classifies a set of related data into one Feature, 
// even if we do not use unity_LODFade, we still need to place it in this CBuffer to construct a complete Feature
float4 unity_LODFade;
real4 unity_WorldTransformParams;
CBUFFER_END

float4x4 unity_MatrixVP;
float4x4 unity_MatrixV;
float4x4 unity_MatrixInvV;
float4x4 unity_prev_MatrixM;
float4x4 unity_prev_MatrixIM;
float4x4 glstate_matrix_projection;

#endif