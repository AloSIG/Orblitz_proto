Shader "Alo/TestDepth" {
    SubShader {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;

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
               // o.testPos.y = 1 - o.testPos.y;
                //o.testPos.z = 1 - o.testPos.z;
               //#if UNITY_UV_STARTS_AT_TOP
				//if (_MainTex_TexelSize.y < 0)
					//o.grabPos.y = 1 - o.grabPos.y;
				//#endif	

                return o;
            }

            sampler2D _CameraDepthTexture;

            half4 frag(v2f i) : SV_Target {
            	//float value = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.scrPos));
            	//float linearValue = Linear01Depth(value);

            	float rawDepth = DecodeFloatRG(tex2Dproj(_CameraDepthTexture, i.scrPos));
				float linearDepth = 1-Linear01Depth(rawDepth);

               // float depthValue = LinearEyeDepth(tex2D(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)).r);
            	//float linearDepth = Linear01Depth(depthValue2);
            	half4 depth = half4(linearDepth, linearDepth, linearDepth, 1);

            	return depth;
            }
            ENDCG
        }
    }
}