Shader "Depth"
{
     // Unity �V�F�[�_�[�̃v���p�e�B�u���b�N�B���̗�ł͏o�͂̐F���t���O�����g�V�F�[�_�[��
    // �R�[�h���Ɏ��O��`����Ă��邽�߁A���̃u���b�N�͋�ł��B
    Properties
    { }

    // �V�F�[�_�[�̃R�[�h���܂܂�� SubShader �u���b�N�B
    SubShader
    {
        // SubShader Tags �ł� SubShader �u���b�N�܂��̓p�X�����s�����^�C�~���O�Ə�����
        // ��`���܂��B
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            // HLSL �R�[�h�u���b�N�BUnity SRP �ł� HLSL ������g�p���܂��B
            HLSLPROGRAM
            // ���̍s�ł͒��_�V�F�[�_�[�̖��O���`���܂��B
            #pragma vertex vert
            // ���̍s�ł̓t���O�����g�V�F�[�_�[�̖��O���`���܂��B
            #pragma fragment frag

            // Core.hlsl �t�@�C���ɂ́A�悭�g�p����� HLSL �}�N������ъ֐���
            // ��`���܂܂�A���̑��� HLSL �t�@�C�� (Common.hlsl�A
            // SpaceTransforms.hlsl �Ȃ�) �ւ� #include �Q�Ƃ��܂܂�Ă��܂��B
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            // ���̍\���̒�`�ł͍\���̂Ɋ܂܂��ϐ����`���܂��B
            // ���̗�ł� Attributes �\���̂𒸓_�V�F�[�_�[�̓��͍\���̂Ƃ���
            // �g�p���Ă��܂��B
            struct Attributes
            {
                // positionOS �ϐ��ɂ̓I�u�W�F�N�g��ԓ��ł̒��_�ʒu��
                // �܂܂�܂��B
                float4 positionOS   : POSITION;
            };

            struct Varyings
            {
                // ���̍\���̓��̈ʒu�ɂ� SV_POSITION �Z�}���e�B�N�X���K�v�ł��B
                float4 positionHCS  : SV_POSITION;
            };

            // Varyings �\���̓��ɒ�`���ꂽ�v���p�e�B���܂ޒ��_�V�F�[�_�[��
            // ��`�Bvert �֐��̌^�͖߂�l�̌^ (�\����) �Ɉ�v������
            // �K�v������܂��B
            Varyings vert(Attributes IN)
            {
                // Varyings �\���̂ł̏o�̓I�u�W�F�N�g (OUT) �̐錾�B
                Varyings OUT;
                // TransformObjectToHClip �֐��͒��_�ʒu���I�u�W�F�N�g��Ԃ���
                // ����̃N���b�v�X�y�[�X�ɕϊ����܂��B
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                // �o�͂�Ԃ��܂��B
                return OUT;
            }

            // �t���O�����g�V�F�[�_�[�̒�`�B
            half4 frag(Varyings IN) : SV_Target
            {
                // �F�ϐ����`���ĕԂ��܂��B
                half4 customColor = IN.positionHCS.z;
                return 0.5;
            }
            ENDHLSL
        }
    }
}