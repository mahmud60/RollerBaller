// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'PositionFog()' with multiply of UNITY_MATRIX_MVP by position

Shader "IGNI/OPT/Illum VertexLit Rim OPT" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Illum ("Illum (RGB)", 2D) = "black" {}
        _RimColor ("Rim Color", Color) = (1, 1, 1, 1)
        _Color ("Main Color", Color) = (1,1,1,1)

    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 80

        Pass {
            Lighting On
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"

           
            struct appdata {
                    fixed4 vertex : POSITION;
                    fixed3 normal : NORMAL;
                    fixed2 texcoord : TEXCOORD0;
                };

            fixed3 Shade2VertexLights (fixed4 vertex, fixed3 normal)
            {           
                fixed3 viewpos = mul (UNITY_MATRIX_MV, vertex).xyz;
                fixed3 viewN = mul ((float3x3)UNITY_MATRIX_IT_MV, normal);
                fixed3 lightColor = UNITY_LIGHTMODEL_AMBIENT.xyz;
                for (int i = 0; i < 2; i++) {
                    fixed3 toLight = unity_LightPosition[i].xyz - viewpos.xyz * unity_LightPosition[i].w;
                    fixed lengthSq = dot(toLight, toLight);
                    fixed atten = 1.0 / (1.0 + lengthSq * unity_LightAtten[i].z);
                    fixed diff = max (0, dot (viewN, normalize(toLight)));
                    lightColor += unity_LightColor[i].rgb * (diff * atten);
                }
                return lightColor;
            }


            struct v2f
            {
                half2 uv_MainTex : TEXCOORD0;
                half2 uv_Illum : TEXCOORD1;
                fixed4 color : COLOR0;
                fixed4 pos : SV_POSITION;

                 //float4 pos : SV_POSITION;
                    //float2 uv : TEXCOORD0;
                    //float3 color : COLOR0;

            };

            fixed4 _MainTex_ST;
            fixed4 _Illum_ST;
            fixed4 _RimColor;

            v2f vert (appdata_base v)
            {
                v2f o;

                 o.pos = UnityObjectToClipPos (v.vertex);
                 fixed3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
                 fixed dotProduct = 1 - dot(v.normal, viewDir);
                 fixed rimWidth = 0.5;
                 o.color = smoothstep((1 - rimWidth), 1.5 , dotProduct);
                 o.color  *= _RimColor*6;	

                   


                //o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.uv_MainTex = TRANSFORM_TEX(v.texcoord,_MainTex);
                o.uv_Illum = TRANSFORM_TEX(v.texcoord,_Illum);
                o.color += fixed4 (Shade2VertexLights(v.vertex, v.normal) * 2.0, 1);
                return o; 
            }

            sampler2D _MainTex;
            sampler2D _Illum;
            fixed4 _Color;

            fixed4 frag (v2f i) : COLOR {
            
                // base texture
                fixed4 texcol = tex2D(_MainTex, i.uv_MainTex);
                // modulate with lighting
                texcol.rgb *= i.color;
                 	texcol *= _Color;

                // add illumination texture
                texcol += tex2D(_Illum, i.uv_Illum);

                return texcol;
            }
            ENDCG
        }
    }

    Fallback "VertexLit"
}