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
            //�J���[�`�����l���ɏ������ރ����_�[�^�[�Q�b�g��ݒ肷��
            //0�̏ꍇ�A�S�ẴJ���[�`�����l�������������ꉽ���������܂�Ȃ�
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
                // ���C�g�̎擾
                Light light = GetMainLight();

                // �@�������[���h��Ԃɕϊ�
                float3 worldNormal = TransformObjectToWorldNormal(v.normal);
                float nDotL = dot(worldNormal, light.direction);

                // ���_�������o��
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