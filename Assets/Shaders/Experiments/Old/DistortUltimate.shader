Shader "Alo/DistortUltimate"
{
	Properties{
	_DisplacementTex ("Distortion Map", 2D) = "white"{}
	//_Magnitude ("Magnitude", Range(0,1)) = 1
	}
    SubShader
    {

        Tags { "Queue" = "Transparent" }
        Cull Off

        GrabPass
        {
            "_BackgroundTexture"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 grabPos : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 localPos : TEXCOORD1;
            };

            v2f vert(appdata_base v) {
                v2f o;
                //o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.localPos = v.vertex.xyz;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.grabPos = ComputeGrabScreenPos(o.pos);
               
                return o;
            }

            sampler2D _BackgroundTexture;
            sampler2D _DisplacementTex;
            float _Magnitude;

            float4 _Impacts[20];
            float4 _ImpactsColour[20];
            int _Impacts_Length;

            float _JellyCoeff;



            half4 frag(v2f i) : SV_Target
            {

            	half h = 0;
            	half r = 0;
            	half g = 0;
            	half b = 0;
            	half alpha = 0;

            	for (int j = 0; j < _Impacts_Length; j++){
            		half dist = distance(i.localPos, _Impacts[j].xyz);

            		half rad = 1 - saturate(dist/_Impacts[j].w);
            		//change float here for distortion amount (higher = less distorted)
            		h += rad/15;
            		r += rad * _ImpactsColour[j].x;
            		g += rad * _ImpactsColour[j].y;
            		b += rad * _ImpactsColour[j].z;
            		alpha += rad * _ImpactsColour[j].w;
            	}
            	h = saturate(h);
            	float2 disp = tex2D(_DisplacementTex, i.grabPos).xy;
            	disp = ((disp * 2) - 1) * h;
            	//change float to simulate jelly
            	disp += sin(_Time.z*_JellyCoeff)*h;
            	i.grabPos.xy += disp;
                half4 endcolor = tex2Dproj(_BackgroundTexture, i.grabPos);
                endcolor.b -= b;
                endcolor.g -= g;
                endcolor.r -= r;
                endcolor.a -= alpha;
                endcolor = saturate(endcolor);
                return endcolor;
            }
            ENDCG
        }

    }
}


