// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "IGNI/OPT/GradientVertDirOPT" 

{
	Properties 
	{
		_Color1 ("First Color", Color) = (1,1,1,1)
		_Color2 ("Second Color", Color) = (1,1,1,1)
		//_Color3 ("ambientCol", Color) = (1,1,1,1)
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
				
				//user defined variables
				fixed4 _Color1;
				fixed4 _Color2;
				fixed4 _Color3;
				fixed _Emi; 
				fixed _Height;

				//float3 worldPos : TEXCOORD2;
				uniform fixed4 _LightColor0;

			
					
				//base input structs
				struct vertexInput
					{
						fixed4 vertex : POSITION;
						fixed3 normal : NORMAL;
					};
				struct vertexOutput
					{
						fixed4 pos : SV_POSITION;
						fixed4 col : COLOR;
						fixed3 worldPos : TEXCOORD2;
					};
				
				//vertex function
				vertexOutput vert(vertexInput v){
					vertexOutput o;
					
					fixed3 normalDirection = normalize( mul( float4( v.normal, 0.0 ), unity_WorldToObject ).xyz );
					//float3 lightDirection;
					//float atten = 1.0;
					
					//lightDirection = normalize( _WorldSpaceLightPos0.xyz );
					
					fixed3 diffuseReflection = 1.0* _LightColor0.xyz *  max( _Emi, dot(normalDirection, normalize( _WorldSpaceLightPos0.xyz )) );

					o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
					o.col = fixed4(diffuseReflection, 1.0);
					o.pos = UnityObjectToClipPos(v.vertex);
					return o;
				}
				
				//fragment function
				float4 frag(vertexOutput i) : COLOR
					{
						fixed4 gradient = lerp(_Color1, _Color2, i.worldPos.y / _Height);
						return fixed4 (i.col*gradient);
					}
				
				ENDCG
			}
	}
	//Fallback "Diffuse"
}