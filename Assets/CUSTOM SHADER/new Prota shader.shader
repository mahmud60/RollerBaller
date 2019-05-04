// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'PositionFog()' with multiply of UNITY_MATRIX_MVP by position

Shader "IGNI/OPT/New Prota" {
    Properties {
		_Color ("HairEye", Color) = (1.0,1.0,1.0,1.0)
		_RColor ("WheelLight", Color) = (1.0,1.0,1.0,1.0)
		_GColor ("WheelSteel", Color) = (1.0,1.0,1.0,1.0)
		_BColor ("Body", Color) = (1.0,1.0,1.0,1.0)
		_MainTex ("MaskTexture", 2D) = "white" {}
		_SpecColor ("Specular Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess ("Shininess", Float) = 10
		_RimColor ("Rim Color", Color) = (1.0,1.0,1.0,1.0)
		_RimPower ("Rim Power", Range(0.1,10.0)) = 3.0
		_Waxiness ("Waxiness", Range (0,1)) = 0
		_Gradient ("Gradient", Color) = (1.0,1.0,1.0,1.0)

		//_coinColor ("CoinColor", Color) = (1.0,1.0,1.0,1.0)
		_CoinInten ("CoinInten", Float) = 10
	}
	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" "IgnoreProjector"="True" }
			Lighting Off 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			//user defined variables
			uniform sampler2D _MainTex;
			uniform fixed4 _MainTex_ST;
			uniform fixed4 _Color;
			uniform fixed4 _RColor;
			uniform fixed4 _GColor;
			uniform fixed4 _BColor;
			uniform fixed4 _Gradient;

			//uniform fixed4 _coinColor;
			uniform fixed _CoinInten; 

			uniform fixed4 _SpecColor;
			uniform fixed4 _RimColor;
			uniform fixed _Shininess;
			uniform fixed _RimPower;
			uniform fixed _Waxiness;
			
			//unity defined variables
			uniform fixed4 _LightColor0;
			
			//Base input structs
			struct vertexInput{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;
			};
			
			struct vertexOutput{
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
				fixed4 posWorld : TEXCOORD1;
				fixed3 normalDir : TEXCOORD2;
			};
			
			//vertex function
			vertexOutput vert(vertexInput v){
				vertexOutput o;
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.normalDir = normalize( mul( float4(v.normal, 0.0), unity_WorldToObject ).xyz );
				o.pos = UnityObjectToClipPos(v.vertex);
				o.tex = v.texcoord;
				return o;
			}
			
			//fragment function
			float4 frag(vertexOutput i) : COLOR
			{
				fixed3 normalDirection = i.normalDir;
				fixed3 viewDirection = normalize( _WorldSpaceCameraPos.xyz - i.posWorld.xyz );
				fixed3 lightDirection = normalize( _WorldSpaceLightPos0.xyz );
				fixed atten = 1.0;
				
				//lighting


				fixed3 diffuseReflection = atten * _LightColor0.xyz * (_Waxiness + ((1-_Waxiness)*max (0, dot( normalDirection, lightDirection )) ));
				fixed3 specularReflection = atten * _LightColor0.xyz * saturate( dot( normalDirection, lightDirection ) ) * pow( saturate( dot( reflect(-lightDirection, normalDirection), viewDirection ) ), _Shininess ) * _SpecColor *1 ;
				
				//Rim Lighting
				fixed rim = 1 - saturate(dot(normalize(viewDirection), normalDirection));
				fixed3 rimLighting = _RimColor * pow(rim, _RimPower) *5 ;

				fixed4 tex = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				//fixed4 coin = (_coinColor * _CoinInten);
				fixed3 lightFinal = diffuseReflection + (specularReflection*tex.g) + rimLighting;
								
				return fixed4( (( _Color.xyz * tex.a)+((lerp(_RColor, (_RColor * _Gradient), i.tex.y*3)) * tex.r *1.2)) +  (((lerp((_GColor * .5),_GColor , i.tex.y*2)) * tex.g) + ((lerp((_BColor * .1), (_BColor), i.tex.x *1.2 -0.3)) * tex.b * _CoinInten )) * lightFinal , 1.0);
			}
			
			
			
			ENDCG
		}
    }

    Fallback "VertexLit"
}