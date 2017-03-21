Shader "Alo/DisplacementGP"
{
	Properties{
		_Magnitude("Magnitude", Range(0,1)) = 0
		_DisplacementTex("Displacement map", 2D) = "white"{}
		_Colour("Colour", color) = (1,1,1,1)
	}
    SubShader
    {
        // Draw ourselves after all opaque geometry
        Tags { "Queue" = "Transparent" }

        Cull Off
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

            struct v2f
            {
                float4 grabPos : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            v2f vert(appdata_base v) {
                v2f o;
                // use UnityObjectToClipPos from UnityCG.cginc to calculate 
                // the clip-space of the vertex
                o.pos = UnityObjectToClipPos(v.vertex);
                // use ComputeGrabScreenPos function from UnityCG.cginc
                // to get the correct texture coordinate
                o.grabPos = ComputeGrabScreenPos(o.pos);
                return o;
            }

            sampler2D _BackgroundTexture;
            float _Magnitude;
            sampler2D _DisplacementTex;
            half4 _Colour;

            half4 frag(v2f i) : SV_Target
            {
            	float2 disp = tex2D(_DisplacementTex, i.grabPos).xy;
				disp = ((disp * 2) - 1) * _Magnitude;

				i.grabPos.xy += disp;
                half4 col = tex2Dproj(_BackgroundTexture, i.grabPos);
                //col = 0;
               // return col;
                return _Colour;
            }
            ENDCG
        }

    }
}
