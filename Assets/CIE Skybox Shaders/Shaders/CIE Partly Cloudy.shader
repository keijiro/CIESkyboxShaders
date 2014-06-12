Shader "CIE Skybox/CIE Partly Cloudy"
{
    Properties
    {
        _SkyColor("Color at Zenith", Color) = (0.5, 0.5, 0.5, 1)
        _SunVector("Direction of Sun", Vector) = (0, 0.7071, 0.7071, 0)
        _SunAzimuth("Azimuth of Sun (editor only)", Range(-180, 180)) = 0
        _SunAltitude("Altitude of Sun (editor only)", Range(0, 90)) = 45
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
    half3 _SunVector;
    
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

        float g = dot(v, _SunVector);
        float s = _SunVector.y;

        float a = (0.526 + 5 * exp(-1.5 * acos(g))) * (1 - exp(-0.8 / max(g, 0)));
        float b = (0.526 + 5 * exp(-1.5 * acos(s))) * (1 - exp(-0.8));

        return half4(_SkyColor.rgb * a / b, _SkyColor.a);
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
    CustomEditor "CieSkyboxShaderInspector"
}
