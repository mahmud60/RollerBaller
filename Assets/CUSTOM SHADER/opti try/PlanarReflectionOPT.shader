Shader "IGNI/OPT/MirrorRelfOPT"
{
	Properties
		{
			_MainAlpha("MainAlpha", Range(0, 1)) = 1
			_ReflectionAlpha("ReflectionAlpha", Range(0, 1)) = 1
			//_TintColor ("Tint Color (RGB)", Color) = (1,1,1)
			//_MainTex ("MainTex (RGBA)", 2D) = ""
			_ReflectionTex ("ReflectionTex", 2D) = "white" { TexGen ObjectLinear }
		}

	//Two texture cards: full thing
	Subshader
		{
			Tags {Queue = Transparent}
			ZWrite Off
			//Colormask RGBA

			//Color [_TintColor]
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

				#pragma surface surf BlinnPhong  noshadow halfasview interpolateview //nofog  

					fixed _MainAlpha;
					half _ReflectionAlpha;
					//sampler2D _MainTex;
					sampler2D _ReflectionTex;
					//sampler2D _TintColor;

				struct Input
					{
						//half2 uv_MainTex;
						half4 screenPos;
					};

				void surf(Input IN, inout SurfaceOutput o)
					{
						//o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * _MainAlpha;
						o.Albedo =  _MainAlpha  ;
						o.Emission = tex2D(_ReflectionTex, IN.screenPos.xy / IN.screenPos.w).rgb * _ReflectionAlpha ;
					}
			ENDCG
		}

	//Fallback: just main texture
	Subshader
		{
			Pass
				{
					SetTexture [_MainTex] { combine texture }
				}
		}
}