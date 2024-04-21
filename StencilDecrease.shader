Shader "Unlit/StencilDecrease"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ShadowColor ("Shadow Color", COlor) = (0, 0, 0, 0.5)
        _ShadowLength("ShadowLength", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            NAME "StencilBack"
            
            Tags { "LightMode" = "UniversalForward" }
            //カラーチャンネルに書き込むレンダーターゲットを設定する
            //0の場合、全てのカラーチャンネルが無効化され何も書き込まれない
            ColorMask 0
            ZWrite Off
            Cull Front
            ZTest LEqual
            
            Stencil
            {
                Ref 1
                Comp Always
                Pass DecrSat
            }
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            float3 _LightPosition;

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            float _ShadowLength;
            half4 _ShadowColor;

            CBUFFER_START(UnityPerMaterial)
            float4 _MainTex_ST;
            CBUFFER_END

            v2f vert (appdata v)
            {
                v2f o;
                // ライトの取得
                Light light = GetMainLight();

                // 法線をワールド空間に変換
                float3 worldNormal = TransformObjectToWorldNormal(v.normal);
                float nDotL = dot(worldNormal, light.direction);

                // 頂点を押し出す
                float3 vertex2 = v.vertex + TransformWorldToObjectDir(-light.direction) * _ShadowLength;

                o.vertex = TransformObjectToHClip(lerp(v.vertex, vertex2, 1 - step(-0.3, nDotL)));
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                return 0;
            }
            ENDHLSL
        }
    }
}