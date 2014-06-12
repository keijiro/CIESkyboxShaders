Shader "CIE Skybox/CIE Overcast"
{
    Properties
    {
        _SkyColor("Luminance at Zenith", Color) = (0.5, 0.5, 0.5, 1)
    }

    CGINCLUDE

    #include "UnityCG.cginc"

    struct appdata
    {
        float4 position : POSITION;
        float3 texcoord : TEXCOORD0;
    };
    
    struct v2f
    {
        float4 position : SV_POSITION;
        float3 texcoord : TEXCOORD0;
    };
    
    half4 _SkyColor;
    
    v2f vert (appdata v)
    {
        v2f o;
        o.position = mul (UNITY_MATRIX_MVP, v.position);
        o.texcoord = v.texcoord;
        return o;
    }
    
    half4 frag (v2f i) : COLOR
    {
        half3 v = normalize(i.texcoord);
        half l = (1 + 2 * max(v.y, 0)) / 3;
        return half4(_SkyColor.rgb * l, _SkyColor.a);
    }

    ENDCG

    SubShader
    {
        Tags { "RenderType"="Background" "Queue"="Background" }
        Pass
        {
            ZWrite Off
            Cull Off
            Fog { Mode Off }
            CGPROGRAM
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    } 
}
