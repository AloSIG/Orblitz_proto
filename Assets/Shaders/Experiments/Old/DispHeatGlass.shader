Shader "Alo/DispHeatGlass"
{
	Properties{
	_DisplacementTex ("Distortion Map", 2D) = "white"{}
	_Magnitude ("Magnitude", Range(0,1)) = 0
	}
    SubShader
    {
        // Draw ourselves after all opaque geometry
        Tags { "Queue" = "Transparent" }

        // Grab the screen behind the object into _BackgroundTexture
        GrabPass
        {
            "_BackgroundTexture"
        }

        // Render the object with the texture generated above, and invert the colors
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float3 myFloat;

            struct v2f
            {
                float4 grabPos : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD1;


            };

            v2f vert(appdata_base v) {
                v2f o;
                // use UnityObjectToClipPos from UnityCG.cginc to calculate 
                // the clip-space of the vertex
                o.pos = UnityObjectToClipPos(v.vertex);
                // use ComputeGrabScreenPos function from UnityCG.cginc
                // to get the correct texture coordinate
                o.grabPos = ComputeGrabScreenPos(o.pos);
                //o.worldPos = mul(_Object2World, o.pos).xyz;
                //myFloat = mul(UNITY_MATRIX_MVP, v.vertex).xyz;
                return o;
            }

            sampler2D _BackgroundTexture;
            sampler2D _DisplacementTex;
            float _Magnitude;
            int _Impacts_Length = 0;
            float3 _Impacts[20];

            half4 frag(v2f i) : SV_Target
            {
            	half h = 0;


            	for (int j = 0; j < _Impacts_Length; j++){
            		half dist = distance(i.grabPos, _Impacts[j].xyz);
            		half hi = 1 - saturate(dist/1);

            		h += hi;
            		h = saturate(h);
            	}

            	float2 disp = tex2D(_DisplacementTex, i.grabPos).xy;
            	disp = ((disp * 2) - 1) * _Magnitude * h;
            	i.grabPos.xy += disp;
                half4 bgcolor = tex2Dproj(_BackgroundTexture, i.grabPos);
                return half4(h,h,h,1);
                //return bgcolor;
            }
            ENDCG
        }

    }
}


