// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "IGNI/VERTEXLIT" {
	Properties {
		_Color ("Color", Color) = (1.0,1.0,1.0,1.0)
	}
	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"

			//user defined variables
			uniform fixed4 _Color;
			
			//Unity defined variables
			uniform fixed4 _LightColor0;
			//Unity 3 definitions
			//float4x4 _Object2World;
			//float4x4 _World2Object;
			//float4 _WorldSpaceLightPos0;
			
			//base input structs
			struct vertexInput{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			struct vertexOutput{

				UNITY_FOG_COORDS(1)
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};
			
			//vertex function
			vertexOutput vert(vertexInput v){
				vertexOutput o;

				fixed3 normalDirection = normalize( mul( float4( v.normal, 0.0 ), unity_WorldToObject ).xyz );
				fixed3 lightDirection;
				//o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				//fixed atten = 1.0;
				
				lightDirection = normalize( _WorldSpaceLightPos0.xyz );
				
				fixed3 diffuseReflection = 2* _LightColor0.xyz * _Color.rgb * max( 0.5f, dot(normalDirection, lightDirection) );
				
				o.col = float4(diffuseReflection, 1.0);
				o.pos = UnityObjectToClipPos(v.vertex);

				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}
			
			//fragment function
			float4 frag(vertexOutput i) : COLOR
			{
				UNITY_APPLY_FOG(i.fogCoord, i.col);
				//return gradient;
				return i.col;
			}
			
			ENDCG
		}
	}
	//Fallback "Diffuse"
}