// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "IGNI/GradientDirectionalLight"
{
	Properties
	{
		//_MainTex ("Texture", 2D) = "white" {}
		_Color1 ("First Color", Color) = (1,1,1,1)
		_Color2 ("Second Color", Color) = (1,1,1,1)
		_Color3 ("ambientCol", Color) = (1,1,1,1)
		_Height ("Height", Float) = 10.0
		_SpecColor ("Specular Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess ("Shininess", Float) = 10
		_Emi ("Emission", Float) = .5	
	}
	SubShader
	{
		Tags { "LightMode" = "ForwardBase"}
		ZWrite On
		//Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				//float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				//float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				float3 normalDir : TEXCOORD3;
				float3 worldPos : TEXCOORD2;			
			};

			//sampler2D _MainTex;
			//float4 _MainTex_ST;
			float4 _Color1;
			float4 _Color2;
			float4 _Color3;
			float _Emi; 
			float _Height;
			uniform float4 _LightColor0;
			uniform float4 _SpecColor;
			uniform float _Shininess;

			
			v2f vert (appdata v)
			{
				v2f o;

				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.normalDir = normalize( mul( float4(v.normal, 0.0), unity_WorldToObject ).xyz );
				 				

				o.vertex = UnityObjectToClipPos(v.vertex);
				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			half4 frag (v2f i) : COLOR
			{
				// sample the texture
				//fixed4 col = tex2D(_MainTex, i.uv);
				float3 normalDirection = i.normalDir;
				float3 viewDirection = normalize( _WorldSpaceCameraPos.xyz - i.posWorld.xyz );
				float3 lightDirection;
				float atten = 1.0;

				lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float3 diffuseReflection = atten * _LightColor0.xyz * max( _Emi, dot( normalDirection, lightDirection ) ) + _Color3;
				float3 specularReflection = atten * _LightColor0.xyz * _SpecColor.rgb * max( 0.7, dot( normalDirection, lightDirection ) ) * pow( max( 0.0, dot( reflect( -lightDirection, normalDirection ), viewDirection ) ), _Shininess );
				float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT;

				fixed4 gradient = lerp(_Color1, _Color2, i.worldPos.y / _Height);
				
				//col = col * gradient;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, gradient);
				return float4(lightFinal * gradient, 1.0);;
			}
			ENDCG
		}
	}
}