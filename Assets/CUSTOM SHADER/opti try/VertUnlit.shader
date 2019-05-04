// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "IGNI/OPT/LightMap" 

{
	Properties 
	{
		_Color1 ("First Color", Color) = (1,1,1,1)
		_Color2 ("Second Color", Color) = (1,1,1,1)
		_Color3 ("ambientCol", Color) = (1,1,1,1)
		_Height ("Height", Float) = 10.0
		_Emi ("Emission", Float) = 0.5

		//_Color ("Color", Color) = (1.0,1.0,1.0,1.0)
	}
	SubShader 
	{
		Tags { "LightMode" = "ForwardBase"}
			ZWrite On
			Pass 
			{		
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"
				#pragma multi_compile_fog
				
				//user defined variables
				fixed4 _Color1;
				fixed4 _Color2;
				fixed4 _Color3;
				fixed _Emi; 
				fixed _Height;

				//float3 worldPos : TEXCOORD2;
				uniform fixed4 _LightColor0;

				// sampler2D unity_Lightmap;
     			// float4 unity_LightmapST;
				
					
				//base input structs
				struct vertexInput
					{
						fixed4 vertex : POSITION;
						fixed3 normal : NORMAL;
						float2 texcoord1 : TEXCOORD1;
					};
				struct vertexOutput
					{
						UNITY_FOG_COORDS(1)
						fixed4 pos : SV_POSITION;
						fixed4 col : COLOR;
						//fixed2 uv1 : TEXCOORD1;
						fixed3 worldPos : TEXCOORD2;
					};
				
				//vertex function
				vertexOutput vert(vertexInput v){
					vertexOutput o;
					
					fixed3 normalDirection = normalize( mul( float4( v.normal, 0.0 ), unity_WorldToObject ).xyz );
					//float3 lightDirection;
					//float atten = 1.0;
					
					//lightDirection = normalize( _WorldSpaceLightPos0.xyz );
					
					fixed3 diffuseReflection = 1.0* _LightColor0.xyz *  max( _Emi, dot(normalDirection, normalize( _WorldSpaceLightPos0.xyz )) + _Color3  );

					o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
					o.col = fixed4(diffuseReflection, 1.0);
					o.pos = UnityObjectToClipPos(v.vertex);
					//o.uv1 = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					UNITY_TRANSFER_FOG(o,o.pos);

					return o;
				}
				
				//fragment function
				float4 frag(vertexOutput i) : COLOR
					{
						fixed4 gradient = lerp(_Color1, _Color2, i.worldPos.y / _Height);
						//gradient *= (DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv1)),1);
						UNITY_APPLY_FOG(i.fogCoord, gradient);
						return fixed4 (i.col*gradient );
					}
				
				ENDCG
			}
	}
	//Fallback "Diffuse"
}