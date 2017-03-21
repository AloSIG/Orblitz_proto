Shader "Alo/DistortDepth"
{
	Properties{
	_DisplacementTex ("Distortion Map", 2D) = "white"{}
	_Magnitude ("Distortion Magnitude", Range(0,1)) = 1
	_Bounciness ("Bounciness", Range(0,1)) = 1
	_ImpactTex ("Impact Map", 2D ) = "white"{}
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
            sampler2D _ImpactTex;
            float _Magnitude;
            float _Bounciness;

            float4 _Impacts[20];
            float4 _ImpactsColour[20];
            int _Impacts_Length;

            float _JellyCoeff;

            sampler2D _globalDepthTex;

            half4 frag(v2f i) : SV_Target
            {

            	half2 pos = half2(0,0);
            	half impactValue = 0;

            	for (int j = 0; j < _Impacts_Length; j++){
            		pos.x = (i.localPos.x - _Impacts[j].x + _Impacts[j].w) / (2 * _Impacts[j].w);
            		pos.y = (i.localPos.z - _Impacts[j].z + _Impacts[j].w) / (2 * _Impacts[j].w);
            		pos = saturate(pos);

            		impactValue += tex2D(_ImpactTex, pos);
            	}



            	float2 disp = tex2D(_DisplacementTex, i.grabPos).xy;
            	disp = ((disp * 2) - 1) * impactValue * _Magnitude;
            	//change float to simulate jelly
            	disp += (sin(_Time.z*_JellyCoeff)*_Bounciness)*impactValue;
            	i.grabPos.xy += disp;
                half4 endcolor = tex2Dproj(_BackgroundTexture, i.grabPos);
               // half4 testCol = half4(impactValue, impactValue, impactValue, 1);
                return endcolor;
              // return testCol;
            }
            ENDCG
        }

    }
}


