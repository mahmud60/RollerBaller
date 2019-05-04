Shader "IGNI/CollectiblesTry"{
    Properties {
		_Color ("HairEye", Color) = (1.0,1.0,1.0,1.0)
		_SpecColor ("Specular Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess ("Shininess", Float) = 10	
		_Waxiness ("Waxiness", Range (0,1)) = 0


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
		
			

			//uniform fixed4 _coinColor;
			uniform fixed _CoinInten; 

			uniform fixed4 _SpecColor;

			uniform fixed _Shininess;

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
				
		


				//fixed4 tex = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				//fixed4 coin = (_coinColor * _CoinInten);
				fixed3 lightFinal = diffuseReflection + (specularReflection *2) ;
								
				return fixed4( _Color.xyz *2  * lightFinal , 1.0);
			}
			
			
			
			ENDCG
		}
    }

    Fallback "VertexLit"
}