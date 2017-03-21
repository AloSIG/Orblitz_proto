Shader "Alo/DistortModif"
{
	Properties{
	_DisplacementTex ("Distortion Map", 2D) = "white"{}
	_Magnitude ("Distortion Magnitude", Range(0,1)) = 1
	_Bounciness ("Bounciness", Range(0,1)) = 1
	_ImpactTex ("Impact Map", 2D ) = "white"{}
	_NoiseTex ("Noise Map", 2D) = "black"{}
	}
    SubShader
    {

        Tags { "Queue" = "Transparent" }
        Cull Off

        Stencil {
        	Ref 1
        	Comp always
        	Pass Replace
        }
         


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
                float4 scrPos : TEXCOORD2;
            };

            v2f vert(appdata_base v) {
                v2f o;
                //o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.localPos = v.vertex.xyz;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.grabPos = ComputeGrabScreenPos(o.pos);
                o.scrPos = ComputeScreenPos(o.pos);
                o.scrPos.z = 1- o.scrPos.z;

                return o;
            }

            sampler2D _BackgroundTexture;
            sampler2D _DisplacementTex;
            sampler2D _ImpactTex;
            float _Magnitude;
            float _Bounciness;

            float4 _Impacts[20];
            half4 _ImpactsColour[20];
            int _Impacts_Length;

            float _JellyCoeff;

            sampler2D _CameraDepthTexture;


            half4 frag(v2f i) : SV_Target
            {

            	half2 pos = half2(0,0.5);
            	half impactValue = 0;
            	half4 pixelCol = 0;

            	for (int j = 0; j < _Impacts_Length; j++){
            		
            		//pos.x = (distance(i.localPos.xyz, _Impacts[j].xyz) + _Impacts[j].w) / (2 * _Impacts[j].w);
            		//pos.x = saturate(pos.x);

            		float3 vec = i.localPos.xyz - _Impacts[j].xyz;
            		pos.x = (vec.y + _Impacts[j].w) / (2 * _Impacts[j].w);
            		pos.y = (vec.z + _Impacts[j].w) / (2 * _Impacts[j].w);
            		pos = saturate(pos);

            		//mask
            		half maskValue = tex2D(_ImpactTex, pos);
            		impactValue += maskValue;

            		pixelCol.rgb += _ImpactsColour[j].rgb * maskValue;
            		pixelCol.a += _ImpactsColour[j].a * maskValue;
            	}

            	pixelCol.rgb = pixelCol.rgb / (impactValue + 0.001);

            	pixelCol.a = saturate(pixelCol.a);

            	//depth stuff
            	float rawDepth = DecodeFloatRG(tex2Dproj(_CameraDepthTexture, i.scrPos));
            	float adjustedImpact = clamp(impactValue, 1, 10);
				half4 linearDepth = pow(1-Linear01Depth(rawDepth), adjustedImpact);
				linearDepth *= pixelCol;



				impactValue = saturate(impactValue);

            	//distortion
            	float2 disp = tex2D(_DisplacementTex, i.grabPos).xy;
            	disp = ((disp * 2) - 1) *impactValue * _Magnitude;

            	//change float to simulate jelly
            	disp += (sin(_Time.z*_JellyCoeff)*_Bounciness)*impactValue;
            	i.grabPos.xy += disp;

            	half4 endcolor = tex2Dproj(_BackgroundTexture, i.grabPos);
                endcolor.rgb *= (1-impactValue*(1-pixelCol.rgb));

                
               // endcolor = saturate(endcolor);
                endcolor = lerp(endcolor, linearDepth, pixelCol.a);
                return endcolor;
            }
            ENDCG
        }

    }
}


