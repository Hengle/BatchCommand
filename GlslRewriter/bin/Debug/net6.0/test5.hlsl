
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

struct appdata
{
    float4 vertex : POSITION;
    float4 uv : NORMAL;
};

struct v2f
{
    float4 vertex : SV_POSITION;
    float4 fs_attr0 : NORMAL;
    float4 fs_attr1 : TANGENT;
    float4 fs_attr2 : COLOR;
    float4 fs_attr3 : TEXCOORD0;
    float4 fs_attr4 : TEXCOORD1;
    float4 fs_attr5 : TEXCOORD2;
    float4 fs_attr6 : TEXCOORD3;
    float4 fs_attr7 : TEXCOORD4;
    float4 fs_attr8 : TEXCOORD5;
    float4 fs_attr9 : TEXCOORD6;
    float4 fs_attr10 : TEXCOORD7;
    float4 fs_attr11 : NORMAL1;
    float4 fs_attr12 : TANGENT1;
    float4 fs_attr13 : COLOR1;
    float4 fs_attr14 : NORMAL2;
    float4 fs_attr15 : TANGENT2;
    float4 fs_attr16 : COLOR2;
    float4 fs_attr17 : NORMAL3;
    float4 fs_attr18 : TANGENT3;
    float4 fs_attr19 : COLOR3;
    float4 fs_attr20 : NORMAL4;
    float4 fs_attr21 : TANGENT4;
    float4 fs_attr22 : COLOR4;
    float4 fs_attr23 : NORMAL5;
};

float4 uni_attr3;
float4 uni_attr4; //固定值 277.38879   -253.98657   -1225.84583   1000 (xyzw全用)，xyz可能是某个原始坐标，使用uni_attr5\6\7作为变换矩阵变换到另一个坐标系，w小于0会提前结束shader
float4 uni_attr5; //固定值 0   0   0   1060.5 (只用w)shader需符合条件 (uni_attr1.w > vs_cbuf10_2.x) || (vs_cbuf10_2.x - uni_attr1.w) > uni_attr0.w 才会继续执行，
                  //后续会使用 (vs_cbuf10_2.x - uni_attr1.w) / uni_attr0.w
                  //或者 (uni_attr3.x * vs_cbuf9_12.z * vs_cbuf_9[11].y + vs_cbuf10_2.x - uni_attr1.w) * vs_cbuf9_11.y的小数部分
float4 uni_attr6; //固定值 256.74911   175.44524   175.44524   1       (用xyz)，tex0的纵向12个像素是顶点动画的12个顶点坐标，xyz分别用于缩放坐标的xyz，y也用于计算o.fs_attr5.y
float4 uni_attr7; //固定值 0.33394   0.62269     0.01691     0.7787    (xyzw全用),x是序列帧动画进度[0,1], xy分别是计算o.fs_attr1.zw的系数，zw是乘系数前的叠加值

float4 camera_wpos;
float4 view_proj[8];
float4 vs_cbuf1[16];
float4 vs_cbuf16[16];

float4 vs_cbuf8_24;
float4 vs_cbuf8_25;
float4 vs_cbuf8_26;
float4 vs_cbuf8_28;
float4 vs_cbuf8_30;
float4 vs_cbuf9_7;
float4 vs_cbuf9_12;
float4 vs_cbuf9_13;
float4 vs_cbuf9_14;
float4 vs_cbuf9_15;
float4 vs_cbuf9_16;
float4 vs_cbuf9_78;
float4 vs_cbuf9_113;
float4 vs_cbuf9_129;
float4 vs_cbuf9_141;
float4 vs_cbuf9_142;
float4 vs_cbuf9_143;
float4 vs_cbuf9_144;
float4 vs_cbuf9_145;
float4 vs_cbuf9_146;
float4 vs_cbuf9_147;
float4 vs_cbuf10_0;
float4 vs_cbuf10_1;
float4 vs_cbuf10_2;
float4 vs_cbuf10_3;
float4 vs_cbuf10_4;
float4 vs_cbuf10_5;
float4 vs_cbuf10_6;
float4 vs_cbuf15_1;
float4 vs_cbuf15_22;
float4 vs_cbuf15_23;
float4 vs_cbuf15_24;
float4 vs_cbuf15_25;
float4 vs_cbuf15_26;
float4 vs_cbuf15_27;
float4 vs_cbuf15_28;
float4 vs_cbuf15_54;
float4 vs_cbuf15_55;
float4 vs_cbuf15_57;
float4 vs_cbuf15_60;
float4 vs_cbuf15_61;

float4 fs_cbuf8_1;
float4 fs_cbuf8_2;
float4 fs_cbuf8_30;
float4 fs_cbuf9_78;
float4 fs_cbuf9_139;
float4 fs_cbuf9_140;
float4 fs_cbuf9_189;
float4 fs_cbuf9_190;
float4 fs_cbuf9_191;
float4 fs_cbuf9_192;
float4 fs_cbuf10_9;
float4 fs_cbuf10_139;
float4 fs_cbuf10_140;
float4 fs_cbuf10_189;
float4 fs_cbuf10_190;
float4 fs_cbuf15_1;
float4 fs_cbuf15_25;
float4 fs_cbuf15_26;
float4 fs_cbuf15_28;
float4 fs_cbuf15_42;
float4 fs_cbuf15_43;
float4 fs_cbuf15_44;
float4 fs_cbuf15_57;
float4 fs_cbuf16_7;
float4 fs_cbuf16_10;

Texture2D tex0; //8*13
Texture2D tex1; //256*256
Texture2D tex2; //256*256
Texture2DArray tex3; //64*64
Texture2DArray tex4; //64*64
Texture2D tex5; //512*512

TEXTURE2D_X_FLOAT(_CameraDepthTexture);
SamplerState s_linear_clamp_sampler;

//#define ftoi floatBitsToInt
//#define ftou floatBitsToUint
//#define itof intBitsToFloat
//#define utof uintBitsToFloat
#define ftou
#define utof
#define ftou2 asuint
#define utof2 asfloat

int2 textureSize(Texture2D tex, int lod)
{
    uint w, h, lvls;
    tex.GetDimensions(uint(lod), w, h, lvls);
    return int2(w, h);
}

float4 texelFetch(Texture2D tex, int2 pos, int lod)
{
    return tex.Load(int3(pos, lod));
}

float2 textureQueryLod(Texture2D tex, float2 uv)
{
    float lod = tex.CalculateLevelOfDetail(s_linear_clamp_sampler, uv);
    uint w, h, lvls;
    tex.GetDimensions(uint(lod), w, h, lvls);
    return float2(lvls, lod);
}

float2 textureQueryLod(Texture2DArray tex, float2 uv)
{
    float lod = tex.CalculateLevelOfDetail(s_linear_clamp_sampler, uv);
    uint w, h, elems, lvls;
    tex.GetDimensions(uint(lod), w, h, elems, lvls);
    return float2(lvls, lod);
}

float4 textureLod(Texture2D tex, float2 uv, float lod)
{
    return tex.SampleLevel(s_linear_clamp_sampler, uv, lod);
}

float4 textureLod(Texture2DArray tex, float3 uvw, float lod)
{
    return tex.SampleLevel(s_linear_clamp_sampler, uvw, lod);
}

float4 textureSample(Texture2D tex, float2 uv)
{
    return tex.Sample(s_linear_clamp_sampler, uv);
}

float4 textureSample(Texture2DArray tex, float3 uv)
{
    return tex.Sample(s_linear_clamp_sampler, uv);
}

float roundEven(float v)
{
    return round(v);
}

float inversesqrt(float v)
{
    return rsqrt(v);
}

uint bitfieldExtract(uint uval, uint offset, uint bits)
{
    if (bits == 0)
        return 0;
    uint mask = (1u << bits) - 1u;
    uint v = (uval >> offset) & mask;
    return v;
}
int bitfieldExtract(int ival, int offset, int bits)
{
    if (bits == 0)
        return 0;
    int shifted = ival >> offset;
    int signBit = shifted & (int) (1u << (bits - 1));
    int mask = (int) ((1u << bits) - 1u);

    int v = -signBit | (shifted & mask);
    return v;
}
uint bitfieldInsert(uint uval, uint insert, uint offset, uint bits)
{
    if (bits == 0)
        return uval;
    uint maskBits = (1u << bits) - 1u;
    uint mask = maskBits << offset;
    uint src = insert << offset;
    uint v = (src & mask) | (uval & ~mask);
    return v;
}

v2f vert(appdata v)
{
	// vs_cbuf1[0] = float4(0.00, 0.00, 0.00, -0.0187293);
	// vs_cbuf1[1] = float4(-0.2121144, 1.570729, 3.141593, 2.356194);
	// vs_cbuf1[2] = float4(-0.8233629, 28.84247, -6.565555, 19.69667);
	// vs_cbuf1[3] = float4(1.00, 0.00001, 6.283185, 0.30);
	// vs_cbuf1[4] = float4(0.40, 0.6366197, -0.10, 0.22);
	// vs_cbuf1[5] = float4(0.06, -0.90, 0.001, 0.20);
	// vs_cbuf1[6] = float4(-0.0008333, 0.01, -0.85, 0.002);
	// vs_cbuf1[7] = float4(0.0001, 0.98, 0.90, -0.0006);
	// vs_cbuf1[8] = float4(-0.00125, 0.00, 0.00, 0.00);
	// vs_cbuf1[9] = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf1[10] = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf1[11] = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf1[12] = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf1[13] = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf1[14] = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf1[15] = float4(0.00, 0.00, 0.00, 0.00);
	// view_proj[0] = float4(0.9936762, 0.00, 0.1122834, -442.3171);
	// view_proj[1] = float4(0.0627182, 0.829457, -0.5550383, -629.7858);
	// view_proj[2] = float4(-0.0931343, 0.5585706, 0.8242117, -2058.403);
	// view_proj[3] = float4(0.00, 0.00, 0.00, 1.00);
	// view_proj[4] = float4(1.206285, 0.00, 0.00, 0.00);
	// view_proj[5] = float4(0.00, 2.144507, 0.00, 0.00);
	// view_proj[6] = float4(0.00, 0.00, -1.00008, -2.00008);
	// view_proj[7] = float4(0.00, 0.00, -1.00, 0.00);
	// vs_cbuf8_24 = float4(0.9936762, 0.0627182, -0.0931343, 0.00);
	// vs_cbuf8_25 = float4(0.00, 0.829457, 0.5585706, 0.00);
	// vs_cbuf8_26 = float4(0.1122834, -0.5550383, 0.8242117, 0.00);
	// vs_cbuf8_28 = float4(-0.0931343, 0.5585706, 0.8242117, 0.00);
	// camera_wpos = float4(287.3111, 1672.144, 1396.669, 0.00);
	// vs_cbuf8_30 = float4(1.00, 25000.00, 25000.00, 24999.00);
	// vs_cbuf9_7 = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf9_12 = float4(360.00, 0.00, 0.00, 0.00);
	// vs_cbuf9_13 = float4(0.00, 1.00, 0.00, 0.00);
	// vs_cbuf9_14 = float4(0.00, -1.00, 0.00, 0.00);
	// vs_cbuf9_15 = float4(0.95, 0.00, 0.00, 0.00);
	// vs_cbuf9_16 = float4(0.00, 0.00, 0.00, 40.00);
	// vs_cbuf9_78 = float4(1.00, 1.00, 16.00, 16.00);
	// vs_cbuf9_113 = float4(1.00, 1.00, 1.00, 0.00);
	// vs_cbuf9_129 = float4(0.10, 1.00, 1.00, 0.00);
	// vs_cbuf9_141 = float4(1.00, 1.00, 1.00, 0.00);
	// vs_cbuf9_142 = float4(1.01, 1.00181, 1.01, 0.10);
	// vs_cbuf9_143 = float4(1.04, 1.008, 1.04, 0.40);
	// vs_cbuf9_144 = float4(1.05, 1.01, 1.05, 0.50);
	// vs_cbuf9_145 = float4(1.04, 1.00781, 1.04, 0.60);
	// vs_cbuf9_146 = float4(1.01, 1.00195, 1.01, 0.90);
	// vs_cbuf9_147 = float4(1.00, 1.00, 1.00, 1.00);
	// vs_cbuf10_0 = float4(1.00, 1.00, 1.00, 1.00);
	// vs_cbuf10_1 = float4(1.00, 1.00, 1.00, 1.00);
	// vs_cbuf10_2 = float4(1605.00, 3.00, 1.00, 1.00);
	// vs_cbuf10_3 = float4(1.00, 0.9027278, 0.9027278, 0.9027278);
	// vs_cbuf10_4 = float4(0.9027278, 0.00, 0.00, 538.25);
	// vs_cbuf10_5 = float4(0.00, 0.9027278, 0.00, 1550.75);
	// vs_cbuf10_6 = float4(0.00, 0.00, 0.9027278, 941.75);
	// vs_cbuf15_1 = float4(0.00, 1.00, 1.895482, 1.00);
	// vs_cbuf15_22 = float4(0.0000418, 0.0029252, 0.00, 0.00);
	// vs_cbuf15_23 = float4(42.50, 2.50, 0.85, -0.0229271);
	// vs_cbuf15_24 = float4(0.0033333, 0.00, 0.576, 4.00);
	// vs_cbuf15_25 = float4(0.682, 0.99055, 0.63965, 0.12);
	// vs_cbuf15_26 = float4(1.12035, 1.3145, 0.66605, 0.4519901);
	// vs_cbuf15_27 = float4(-0.0909091, 0.0045455, 250.00, 0.00);
	// vs_cbuf15_28 = float4(0.5226594, -0.5741013, -0.6302658, 0.00);
	// vs_cbuf15_54 = float4(0.8137476, 1.689872, 75.00, 2000.00);
	// vs_cbuf15_55 = float4(0.8511029, 0.825, 1.060784, 0.70);
	// vs_cbuf15_57 = float4(-4731.44, 907.7282, 3000.00, 1.00);
	// vs_cbuf15_60 = float4(0.75, 0.50, 4.00, 1672.144);
	// vs_cbuf15_61 = float4(1.00, 0.00, 0.00, 0.00);
	// vs_cbuf16[0] = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf16[1] = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf16[2] = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf16[3] = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf16[4] = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf16[5] = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf16[6] = float4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf16[7] = float4(0.00, 0.00, 0.00, 39.37191);
	// vs_cbuf16[8] = float4(1.00, 1.00, 0.8777541, 0.00);
	// vs_cbuf16[9] = float4(0.00, 0.00001, 0.00, 0.00);
	// vs_cbuf16[10] = float4(538.25, 1550.75, 941.75, 0.9297899);
	// vs_cbuf16[11] = float4(506.0051, 1546.241, 941.75, 0.3245889);
	// vs_cbuf16[12] = float4(562.7867, 1553.388, 919.1711, 0.4507039);
	// vs_cbuf16[13] = float4(0.00, 0.00, 0.00, 1.00);
	// vs_cbuf16[14] = float4(0.00, 0.00, 0.00, 4.00);
	// vs_cbuf16[15] = float4(0.00, 0.00, 0.00, 4.00);

    bool b_0_17;
    bool b_0_20;
    bool b_0_29;
    bool b_0_3;
    bool b_0_30;
    bool b_0_31;
    bool b_0_33;
    bool b_0_8;
    bool b_1_10;
    bool b_1_11;
    bool b_1_12;
    bool b_1_13;
    bool b_1_14;
    bool b_1_21;
    bool b_1_26;
    bool b_1_34;
    bool b_1_41;
    bool b_1_43;
    bool b_1_48;
    bool b_1_49;
    bool b_1_50;
    bool b_1_51;
    bool b_1_59;
    bool b_1_62;
    bool b_1_64;
    bool b_1_67;
    bool b_1_78;
    bool b_1_8;
    bool b_1_82;
    bool b_1_83;
    bool b_1_9;
    bool b_1_phi_241;
    bool b_2_0;
    bool b_2_11;
    bool b_2_19;
    bool b_2_20;
    bool b_2_21;
    bool b_2_39;
    bool b_2_61;
    bool b_2_91;
    bool b_2_96;
    bool b_2_97;
    bool b_2_phi_130;
    bool b_2_phi_242;
    bool b_3_105;
    bool b_3_106;
    bool b_3_109;
    bool b_3_112;
    bool b_3_113;
    bool b_3_24;
    bool b_3_46;
    bool b_3_76;
    bool b_3_77;
    bool b_3_8;
    bool b_3_88;
    bool b_3_phi_121;
    bool b_3_phi_243;
    bool b_4_18;
    bool b_4_19;
    bool b_4_2;
    bool b_4_22;
    bool b_4_3;
    bool b_4_41;
    bool b_4_43;
    bool b_4_44;
    bool b_5_1;
    bool b_5_10;
    bool b_5_11;
    bool b_5_5;
    bool b_5_6;
    bool b_5_7;
    bool b_6_0;
    bool b_6_11;
    bool b_6_4;
    bool b_6_9;
    bool b_7_0;
    bool b_7_1;
    bool b_7_2;
    bool b_7_3;
    bool b_7_4;
    bool b_7_8;
    bool b_7_phi_28;
    bool b_7_phi_33;
    bool b_8_0;
    bool b_8_1;
    bool b_8_2;
    bool b_8_3;
    bool b_8_phi_135;
    bool b_8_phi_140;
    float f_0_22;
    float f_0_46;
    float f_0_54;
    float f_0_55;
    float f_0_57;
    float f_0_61;
    float f_0_69;
    float f_0_8;
    float f_1_25;
    float f_1_26;
    float f_1_31;
    float f_1_33;
    float f_1_35;
    float f_1_36;
    float f_1_37;
    float f_1_38;
    float f_1_39;
    float f_1_40;
    float f_1_44;
    float f_1_47;
    float f_1_59;
    float f_1_60;
    float f_1_61;
    float f_1_64;
    float f_1_65;
    float f_1_66;
    float f_1_69;
    float f_1_71;
    float f_1_74;
    float f_1_75;
    float f_1_76;
    float f_1_77;
    float f_1_79;
    float f_1_80;
    float f_1_83;
    float f_1_86;
    float f_1_89;
    float f_1_96;
    float f_1_97;
    float f_10_10;
    float f_10_101;
    float f_10_102;
    float f_10_25;
    float f_10_26;
    float f_10_27;
    float f_10_28;
    float f_10_34;
    float f_10_42;
    float f_10_45;
    float f_10_60;
    float f_10_64;
    float f_10_65;
    float f_10_70;
    float f_10_71;
    float f_10_72;
    float f_10_74;
    float f_10_80;
    float f_10_81;
    float f_10_82;
    float f_10_84;
    float f_10_98;
    float f_11_11;
    float f_11_12;
    float f_11_14;
    float f_11_23;
    float f_11_28;
    float f_11_29;
    float f_11_31;
    float f_11_33;
    float f_11_38;
    float f_11_43;
    float f_11_46;
    float f_11_47;
    float f_11_64;
    float f_11_65;
    float f_11_8;
    float f_12_1;
    float f_12_4;
    float f_13_0;
    float f_13_1;
    float f_13_10;
    float f_13_11;
    float f_13_12;
    float f_13_13;
    float f_13_18;
    float f_13_29;
    float f_13_3;
    float f_13_33;
    float f_13_46;
    float f_13_51;
    float f_13_8;
    float f_14_15;
    float f_14_5;
    float f_14_6;
    float f_14_9;
    float f_15_0;
    float f_15_1;
    float f_16_2;
    float f_16_26;
    float f_16_3;
    float f_16_30;
    float f_16_31;
    float f_16_32;
    float f_16_33;
    float f_16_34;
    float f_16_38;
    float f_16_42;
    float f_16_5;
    float f_17_2;
    float f_17_3;
    float f_17_5;
    float f_18_0;
    float f_18_21;
    float f_18_22;
    float f_18_23;
    float f_18_26;
    float f_19_2;
    float f_19_4;
    float f_2_12;
    float f_2_16;
    float f_2_18;
    float f_2_20;
    float f_2_34;
    float f_2_63;
    float f_2_65;
    float f_2_88;
    float f_20_0;
    float f_20_10;
    float f_20_15;
    float f_20_18;
    float f_20_19;
    float f_21_4;
    float f_27_0;
    float f_28_4;
    float f_3_101;
    float f_3_107;
    float f_3_109;
    float f_3_56;
    float f_3_83;
    float f_3_84;
    float f_3_88;
    float f_3_90;
    float f_3_91;
    float f_3_93;
    float f_3_97;
    float f_3_98;
    float f_30_2;
    float f_4_28;
    float f_4_29;
    float f_4_31;
    float f_4_33;
    float f_4_34;
    float f_4_36;
    float f_4_37;
    float f_4_38;
    float f_4_39;
    float f_4_41;
    float f_4_42;
    float f_4_45;
    float f_4_51;
    float f_4_52;
    float f_4_64;
    float f_4_71;
    float f_5_22;
    float f_5_25;
    float f_5_32;
    float f_5_37;
    float f_5_41;
    float f_5_44;
    float f_5_49;
    float f_5_50;
    float f_5_55;
    float f_5_58;
    float f_5_62;
    float f_5_63;
    float f_5_64;
    float f_5_65;
    float f_6_27;
    float f_6_28;
    float f_6_29;
    float f_6_33;
    float f_6_34;
    float f_6_35;
    float f_6_38;
    float f_6_39;
    float f_6_40;
    float f_6_44;
    float f_6_45;
    float f_6_49;
    float f_6_51;
    float f_6_52;
    float f_6_53;
    float f_6_56;
    float f_6_57;
    float f_7_102;
    float f_7_103;
    float f_7_104;
    float f_7_107;
    float f_7_108;
    float f_7_13;
    float f_7_25;
    float f_7_32;
    float f_7_33;
    float f_7_35;
    float f_7_41;
    float f_7_43;
    float f_7_46;
    float f_7_49;
    float f_7_52;
    float f_7_62;
    float f_7_66;
    float f_7_67;
    float f_7_71;
    float f_7_72;
    float f_7_75;
    float f_7_79;
    float f_7_87;
    float f_7_88;
    float f_7_89;
    float f_7_91;
    float f_7_92;
    float f_7_93;
    float f_7_94;
    float f_7_97;
    float f_7_99;
    float f_8_10;
    float f_8_106;
    float f_8_107;
    float f_8_108;
    float f_8_111;
    float f_8_112;
    float f_8_113;
    float f_8_117;
    float f_8_13;
    float f_8_15;
    float f_8_26;
    float f_8_27;
    float f_8_3;
    float f_8_30;
    float f_8_36;
    float f_8_4;
    float f_8_40;
    float f_8_48;
    float f_8_54;
    float f_8_57;
    float f_8_71;
    float f_8_72;
    float f_8_73;
    float f_8_76;
    float f_8_77;
    float f_8_80;
    float f_8_81;
    float f_8_82;
    float f_8_86;
    float f_8_89;
    float f_8_9;
    float f_8_90;
    float f_8_91;
    float f_8_98;
    float f_9_13;
    float f_9_14;
    float f_9_19;
    float f_9_2;
    float f_9_23;
    float f_9_24;
    float f_9_30;
    float f_9_32;
    float f_9_39;
    float f_9_4;
    float f_9_40;
    float f_9_51;
    float f_9_52;
    float f_9_54;
    float f_9_57;
    float f_9_6;
    float f_9_75;
    float f_9_76;
    float f_9_77;
    float f_9_80;
    float f_9_82;
    float f_9_84;
    float f_9_85;
    float f_9_86;
    float f_9_92;
    float f_9_93;
    float2 f2_0_1;
    float2 f2_0_2;
    float4 f4_0_0;
    float4 f4_0_1;
    float4 f4_0_2;
    float4 f4_0_3;
    float4 f4_0_4;
    float4 f4_0_5;
    float4 f4_0_6;
    float4 f4_0_7;
    precise float pf_0_1;
    precise float pf_0_10;
    precise float pf_0_11;
    precise float pf_0_13;
    precise float pf_0_14;
    precise float pf_0_17;
    precise float pf_0_18;
    precise float pf_0_19;
    precise float pf_0_28;
    precise float pf_0_3;
    precise float pf_0_32;
    precise float pf_0_33;
    precise float pf_0_37;
    precise float pf_0_7;
    precise float pf_0_9;
    precise float pf_1_1;
    precise float pf_1_10;
    precise float pf_1_12;
    precise float pf_1_2;
    precise float pf_1_23;
    precise float pf_1_25;
    precise float pf_1_26;
    precise float pf_1_27;
    precise float pf_1_28;
    precise float pf_1_3;
    precise float pf_1_30;
    precise float pf_1_31;
    precise float pf_1_7;
    precise float pf_1_8;
    precise float pf_10_1;
    precise float pf_10_10;
    precise float pf_10_11;
    precise float pf_10_12;
    precise float pf_10_13;
    precise float pf_10_3;
    precise float pf_10_7;
    precise float pf_11_1;
    precise float pf_11_11;
    precise float pf_11_12;
    precise float pf_11_15;
    precise float pf_11_16;
    precise float pf_11_17;
    precise float pf_11_19;
    precise float pf_11_4;
    precise float pf_11_8;
    precise float pf_12_1;
    precise float pf_12_11;
    precise float pf_12_14;
    precise float pf_12_15;
    precise float pf_12_16;
    precise float pf_12_17;
    precise float pf_12_2;
    precise float pf_12_4;
    precise float pf_12_8;
    precise float pf_13_1;
    precise float pf_13_12;
    precise float pf_13_13;
    precise float pf_13_19;
    precise float pf_13_21;
    precise float pf_13_23;
    precise float pf_13_24;
    precise float pf_13_27;
    precise float pf_13_28;
    precise float pf_13_3;
    precise float pf_13_6;
    precise float pf_14_11;
    precise float pf_14_14;
    precise float pf_14_16;
    precise float pf_14_17;
    precise float pf_14_18;
    precise float pf_14_2;
    precise float pf_14_20;
    precise float pf_14_24;
    precise float pf_14_27;
    precise float pf_14_5;
    precise float pf_14_8;
    precise float pf_15_12;
    precise float pf_15_14;
    precise float pf_15_16;
    precise float pf_15_2;
    precise float pf_15_20;
    precise float pf_15_22;
    precise float pf_15_25;
    precise float pf_15_26;
    precise float pf_15_5;
    precise float pf_15_6;
    precise float pf_15_7;
    precise float pf_16_1;
    precise float pf_16_12;
    precise float pf_16_18;
    precise float pf_16_21;
    precise float pf_16_27;
    precise float pf_16_33;
    precise float pf_16_37;
    precise float pf_16_42;
    precise float pf_16_43;
    precise float pf_16_44;
    precise float pf_16_48;
    precise float pf_16_49;
    precise float pf_16_5;
    precise float pf_16_50;
    precise float pf_16_52;
    precise float pf_16_56;
    precise float pf_16_59;
    precise float pf_16_6;
    precise float pf_16_62;
    precise float pf_16_64;
    precise float pf_16_66;
    precise float pf_16_67;
    precise float pf_16_68;
    precise float pf_16_70;
    precise float pf_17_1;
    precise float pf_17_11;
    precise float pf_17_15;
    precise float pf_17_17;
    precise float pf_17_19;
    precise float pf_17_25;
    precise float pf_17_31;
    precise float pf_17_33;
    precise float pf_17_38;
    precise float pf_17_44;
    precise float pf_17_47;
    precise float pf_17_49;
    precise float pf_17_50;
    precise float pf_17_51;
    precise float pf_17_54;
    precise float pf_17_56;
    precise float pf_17_59;
    precise float pf_17_6;
    precise float pf_18_14;
    precise float pf_18_2;
    precise float pf_18_20;
    precise float pf_18_27;
    precise float pf_18_30;
    precise float pf_18_34;
    precise float pf_18_37;
    precise float pf_18_39;
    precise float pf_18_41;
    precise float pf_18_44;
    precise float pf_18_47;
    precise float pf_18_49;
    precise float pf_18_51;
    precise float pf_18_53;
    precise float pf_18_54;
    precise float pf_18_55;
    precise float pf_18_58;
    precise float pf_18_6;
    precise float pf_18_61;
    precise float pf_18_63;
    precise float pf_18_66;
    precise float pf_18_67;
    precise float pf_18_68;
    precise float pf_19_10;
    precise float pf_19_15;
    precise float pf_19_16;
    precise float pf_19_2;
    precise float pf_19_23;
    precise float pf_19_26;
    precise float pf_19_28;
    precise float pf_19_3;
    precise float pf_19_30;
    precise float pf_19_33;
    precise float pf_19_38;
    precise float pf_19_4;
    precise float pf_19_40;
    precise float pf_19_5;
    precise float pf_19_6;
    precise float pf_19_8;
    precise float pf_19_9;
    precise float pf_2_0;
    precise float pf_2_10;
    precise float pf_2_18;
    precise float pf_2_19;
    precise float pf_2_25;
    precise float pf_2_30;
    precise float pf_2_33;
    precise float pf_2_38;
    precise float pf_2_39;
    precise float pf_2_40;
    precise float pf_2_6;
    precise float pf_2_8;
    precise float pf_2_9;
    precise float pf_20_10;
    precise float pf_20_13;
    precise float pf_20_14;
    precise float pf_20_17;
    precise float pf_20_18;
    precise float pf_20_19;
    precise float pf_20_2;
    precise float pf_20_21;
    precise float pf_20_23;
    precise float pf_20_5;
    precise float pf_20_6;
    precise float pf_20_7;
    precise float pf_20_8;
    precise float pf_21_1;
    precise float pf_21_13;
    precise float pf_21_14;
    precise float pf_21_16;
    precise float pf_21_20;
    precise float pf_21_27;
    precise float pf_21_28;
    precise float pf_21_3;
    precise float pf_21_34;
    precise float pf_21_37;
    precise float pf_21_4;
    precise float pf_21_6;
    precise float pf_21_9;
    precise float pf_22_1;
    precise float pf_22_11;
    precise float pf_22_13;
    precise float pf_22_15;
    precise float pf_22_19;
    precise float pf_22_2;
    precise float pf_22_21;
    precise float pf_22_23;
    precise float pf_22_25;
    precise float pf_22_26;
    precise float pf_22_3;
    precise float pf_22_31;
    precise float pf_22_33;
    precise float pf_22_34;
    precise float pf_22_35;
    precise float pf_22_39;
    precise float pf_22_4;
    precise float pf_22_41;
    precise float pf_22_44;
    precise float pf_22_6;
    precise float pf_22_7;
    precise float pf_23_1;
    precise float pf_23_11;
    precise float pf_23_13;
    precise float pf_23_16;
    precise float pf_23_17;
    precise float pf_23_18;
    precise float pf_23_19;
    precise float pf_23_23;
    precise float pf_23_7;
    precise float pf_23_9;
    precise float pf_24_1;
    precise float pf_24_11;
    precise float pf_24_15;
    precise float pf_24_18;
    precise float pf_24_20;
    precise float pf_24_21;
    precise float pf_24_24;
    precise float pf_24_26;
    precise float pf_24_28;
    precise float pf_24_31;
    precise float pf_24_32;
    precise float pf_24_35;
    precise float pf_24_36;
    precise float pf_24_4;
    precise float pf_24_42;
    precise float pf_24_43;
    precise float pf_24_44;
    precise float pf_24_48;
    precise float pf_24_49;
    precise float pf_24_50;
    precise float pf_24_51;
    precise float pf_24_52;
    precise float pf_24_57;
    precise float pf_24_58;
    precise float pf_24_59;
    precise float pf_24_63;
    precise float pf_24_64;
    precise float pf_24_65;
    precise float pf_24_7;
    precise float pf_24_70;
    precise float pf_25_1;
    precise float pf_25_10;
    precise float pf_25_11;
    precise float pf_25_15;
    precise float pf_25_19;
    precise float pf_25_20;
    precise float pf_25_23;
    precise float pf_25_26;
    precise float pf_25_4;
    precise float pf_25_5;
    precise float pf_25_6;
    precise float pf_25_9;
    precise float pf_26_0;
    precise float pf_26_1;
    precise float pf_26_11;
    precise float pf_26_12;
    precise float pf_26_13;
    precise float pf_26_15;
    precise float pf_26_17;
    precise float pf_26_20;
    precise float pf_26_23;
    precise float pf_26_24;
    precise float pf_26_25;
    precise float pf_26_27;
    precise float pf_26_3;
    precise float pf_26_32;
    precise float pf_26_33;
    precise float pf_26_34;
    precise float pf_26_38;
    precise float pf_26_39;
    precise float pf_26_40;
    precise float pf_26_43;
    precise float pf_26_44;
    precise float pf_26_49;
    precise float pf_26_5;
    precise float pf_26_52;
    precise float pf_26_54;
    precise float pf_26_56;
    precise float pf_26_6;
    precise float pf_26_7;
    precise float pf_26_8;
    precise float pf_27_10;
    precise float pf_27_12;
    precise float pf_27_13;
    precise float pf_27_14;
    precise float pf_27_17;
    precise float pf_27_21;
    precise float pf_27_22;
    precise float pf_27_23;
    precise float pf_27_24;
    precise float pf_27_25;
    precise float pf_27_29;
    precise float pf_27_30;
    precise float pf_27_32;
    precise float pf_27_33;
    precise float pf_27_40;
    precise float pf_27_41;
    precise float pf_27_44;
    precise float pf_27_48;
    precise float pf_27_50;
    precise float pf_27_52;
    precise float pf_27_54;
    precise float pf_27_55;
    precise float pf_27_60;
    precise float pf_27_63;
    precise float pf_27_9;
    precise float pf_28_11;
    precise float pf_28_13;
    precise float pf_28_15;
    precise float pf_28_17;
    precise float pf_28_18;
    precise float pf_28_20;
    precise float pf_28_27;
    precise float pf_28_29;
    precise float pf_28_3;
    precise float pf_28_30;
    precise float pf_28_36;
    precise float pf_28_39;
    precise float pf_28_40;
    precise float pf_28_44;
    precise float pf_28_45;
    precise float pf_28_46;
    precise float pf_28_47;
    precise float pf_28_5;
    precise float pf_29_10;
    precise float pf_29_11;
    precise float pf_29_13;
    precise float pf_29_17;
    precise float pf_29_19;
    precise float pf_29_2;
    precise float pf_29_22;
    precise float pf_29_23;
    precise float pf_29_24;
    precise float pf_29_26;
    precise float pf_29_28;
    precise float pf_29_29;
    precise float pf_29_31;
    precise float pf_29_34;
    precise float pf_29_37;
    precise float pf_29_39;
    precise float pf_29_4;
    precise float pf_29_41;
    precise float pf_29_43;
    precise float pf_29_47;
    precise float pf_29_48;
    precise float pf_29_51;
    precise float pf_29_53;
    precise float pf_29_7;
    precise float pf_3_12;
    precise float pf_3_14;
    precise float pf_3_16;
    precise float pf_3_17;
    precise float pf_3_19;
    precise float pf_3_21;
    precise float pf_3_23;
    precise float pf_3_33;
    precise float pf_3_34;
    precise float pf_3_35;
    precise float pf_3_4;
    precise float pf_3_6;
    precise float pf_3_9;
    precise float pf_30_0;
    precise float pf_30_10;
    precise float pf_30_15;
    precise float pf_30_17;
    precise float pf_30_18;
    precise float pf_30_21;
    precise float pf_30_24;
    precise float pf_30_4;
    precise float pf_30_6;
    precise float pf_30_7;
    precise float pf_30_8;
    precise float pf_30_9;
    precise float pf_31_10;
    precise float pf_31_12;
    precise float pf_31_13;
    precise float pf_31_14;
    precise float pf_31_16;
    precise float pf_31_17;
    precise float pf_31_19;
    precise float pf_31_20;
    precise float pf_31_22;
    precise float pf_31_24;
    precise float pf_31_25;
    precise float pf_31_3;
    precise float pf_31_31;
    precise float pf_31_33;
    precise float pf_31_38;
    precise float pf_31_39;
    precise float pf_31_40;
    precise float pf_31_5;
    precise float pf_31_7;
    precise float pf_31_8;
    precise float pf_31_9;
    precise float pf_32_11;
    precise float pf_32_12;
    precise float pf_32_13;
    precise float pf_32_15;
    precise float pf_32_17;
    precise float pf_32_18;
    precise float pf_32_19;
    precise float pf_32_22;
    precise float pf_32_24;
    precise float pf_32_27;
    precise float pf_32_29;
    precise float pf_32_3;
    precise float pf_32_33;
    precise float pf_32_36;
    precise float pf_32_37;
    precise float pf_32_5;
    precise float pf_32_7;
    precise float pf_33_1;
    precise float pf_33_10;
    precise float pf_33_12;
    precise float pf_33_13;
    precise float pf_33_14;
    precise float pf_33_17;
    precise float pf_33_19;
    precise float pf_33_23;
    precise float pf_33_24;
    precise float pf_33_27;
    precise float pf_33_28;
    precise float pf_33_29;
    precise float pf_33_32;
    precise float pf_33_33;
    precise float pf_33_36;
    precise float pf_33_37;
    precise float pf_33_42;
    precise float pf_33_46;
    precise float pf_33_8;
    precise float pf_34_1;
    precise float pf_34_10;
    precise float pf_34_11;
    precise float pf_34_13;
    precise float pf_34_14;
    precise float pf_34_16;
    precise float pf_34_17;
    precise float pf_34_18;
    precise float pf_34_22;
    precise float pf_34_25;
    precise float pf_34_29;
    precise float pf_34_30;
    precise float pf_34_32;
    precise float pf_34_33;
    precise float pf_34_34;
    precise float pf_34_35;
    precise float pf_34_37;
    precise float pf_34_4;
    precise float pf_34_44;
    precise float pf_34_5;
    precise float pf_34_6;
    precise float pf_34_7;
    precise float pf_34_8;
    precise float pf_34_9;
    precise float pf_35_1;
    precise float pf_35_10;
    precise float pf_35_14;
    precise float pf_35_15;
    precise float pf_35_19;
    precise float pf_35_2;
    precise float pf_35_21;
    precise float pf_35_27;
    precise float pf_35_29;
    precise float pf_35_32;
    precise float pf_35_33;
    precise float pf_35_37;
    precise float pf_35_39;
    precise float pf_35_41;
    precise float pf_35_43;
    precise float pf_35_6;
    precise float pf_35_8;
    precise float pf_36_1;
    precise float pf_36_10;
    precise float pf_36_16;
    precise float pf_36_19;
    precise float pf_36_21;
    precise float pf_36_24;
    precise float pf_36_28;
    precise float pf_36_3;
    precise float pf_36_32;
    precise float pf_36_38;
    precise float pf_36_41;
    precise float pf_36_5;
    precise float pf_36_8;
    precise float pf_37_0;
    precise float pf_37_10;
    precise float pf_37_14;
    precise float pf_37_17;
    precise float pf_37_20;
    precise float pf_37_21;
    precise float pf_37_22;
    precise float pf_37_24;
    precise float pf_37_26;
    precise float pf_37_27;
    precise float pf_37_32;
    precise float pf_37_34;
    precise float pf_37_4;
    precise float pf_37_5;
    precise float pf_37_6;
    precise float pf_37_8;
    precise float pf_38_0;
    precise float pf_38_14;
    precise float pf_38_16;
    precise float pf_38_17;
    precise float pf_38_3;
    precise float pf_38_6;
    precise float pf_38_7;
    precise float pf_38_9;
    precise float pf_39_1;
    precise float pf_39_10;
    precise float pf_39_12;
    precise float pf_39_13;
    precise float pf_39_14;
    precise float pf_39_2;
    precise float pf_39_5;
    precise float pf_39_6;
    precise float pf_39_8;
    precise float pf_4_0;
    precise float pf_4_10;
    precise float pf_4_3;
    precise float pf_4_4;
    precise float pf_4_7;
    precise float pf_40_10;
    precise float pf_40_12;
    precise float pf_40_14;
    precise float pf_40_17;
    precise float pf_40_18;
    precise float pf_40_2;
    precise float pf_40_4;
    precise float pf_40_5;
    precise float pf_40_6;
    precise float pf_40_7;
    precise float pf_41_0;
    precise float pf_41_11;
    precise float pf_41_12;
    precise float pf_41_14;
    precise float pf_41_3;
    precise float pf_41_4;
    precise float pf_41_7;
    precise float pf_41_9;
    precise float pf_42_0;
    precise float pf_42_10;
    precise float pf_42_11;
    precise float pf_42_12;
    precise float pf_42_15;
    precise float pf_42_17;
    precise float pf_42_19;
    precise float pf_42_20;
    precise float pf_42_4;
    precise float pf_42_6;
    precise float pf_42_7;
    precise float pf_42_8;
    precise float pf_43_0;
    precise float pf_43_1;
    precise float pf_43_10;
    precise float pf_43_11;
    precise float pf_43_18;
    precise float pf_43_4;
    precise float pf_43_7;
    precise float pf_43_8;
    precise float pf_44_0;
    precise float pf_44_5;
    precise float pf_44_6;
    precise float pf_45_10;
    precise float pf_45_3;
    precise float pf_45_4;
    precise float pf_45_7;
    precise float pf_46_3;
    precise float pf_46_4;
    precise float pf_46_8;
    precise float pf_47_0;
    precise float pf_47_10;
    precise float pf_47_7;
    precise float pf_48_0;
    precise float pf_48_2;
    precise float pf_49_0;
    precise float pf_5_11;
    precise float pf_5_12;
    precise float pf_5_13;
    precise float pf_5_16;
    precise float pf_5_19;
    precise float pf_5_2;
    precise float pf_5_21;
    precise float pf_5_22;
    precise float pf_5_30;
    precise float pf_5_6;
    precise float pf_5_8;
    precise float pf_5_9;
    precise float pf_51_0;
    precise float pf_51_1;
    precise float pf_6_0;
    precise float pf_6_1;
    precise float pf_6_11;
    precise float pf_6_13;
    precise float pf_6_14;
    precise float pf_6_19;
    precise float pf_6_2;
    precise float pf_6_20;
    precise float pf_6_5;
    precise float pf_6_7;
    precise float pf_6_9;
    precise float pf_7_0;
    precise float pf_7_1;
    precise float pf_7_11;
    precise float pf_7_2;
    precise float pf_7_4;
    precise float pf_7_5;
    precise float pf_7_6;
    precise float pf_7_7;
    precise float pf_7_8;
    precise float pf_8_12;
    precise float pf_8_18;
    precise float pf_8_19;
    precise float pf_8_2;
    precise float pf_8_23;
    precise float pf_8_4;
    precise float pf_8_5;
    precise float pf_8_6;
    precise float pf_8_7;
    precise float pf_8_9;
    precise float pf_9_1;
    precise float pf_9_10;
    precise float pf_9_18;
    precise float pf_9_19;
    precise float pf_9_21;
    precise float pf_9_25;
    precise float pf_9_26;
    precise float pf_9_27;
    precise float pf_9_3;
    precise float pf_9_31;
    precise float pf_9_34;
    precise float pf_9_35;
    precise float pf_9_5;
    precise float pf_9_6;
    precise float pf_9_8;
    uint u_0_1;
    uint u_0_10;
    uint u_0_11;
    uint u_0_14;
    uint u_0_15;
    uint u_0_16;
    uint u_0_17;
    uint u_0_19;
    uint u_0_2;
    uint u_0_20;
    uint u_0_21;
    uint u_0_22;
    uint u_0_23;
    uint u_0_26;
    uint u_0_28;
    uint u_0_30;
    uint u_0_31;
    uint u_0_33;
    uint u_0_34;
    uint u_0_36;
    uint u_0_37;
    uint u_0_5;
    uint u_0_6;
    uint u_0_8;
    uint u_0_9;
    uint u_0_phi_103;
    uint u_0_phi_114;
    uint u_0_phi_116;
    uint u_0_phi_151;
    uint u_0_phi_154;
    uint u_0_phi_240;
    uint u_0_phi_46;
    uint u_0_phi_59;
    uint u_0_phi_74;
    uint u_0_phi_76;
    uint u_0_phi_95;
    uint u_1_1;
    uint u_1_12;
    uint u_1_13;
    uint u_1_14;
    uint u_1_15;
    uint u_1_17;
    uint u_1_18;
    uint u_1_2;
    uint u_1_20;
    uint u_1_24;
    uint u_1_27;
    uint u_1_28;
    uint u_1_3;
    uint u_1_31;
    uint u_1_33;
    uint u_1_36;
    uint u_1_37;
    uint u_1_4;
    uint u_1_45;
    uint u_1_46;
    uint u_1_48;
    uint u_1_49;
    uint u_1_5;
    uint u_1_52;
    uint u_1_53;
    uint u_1_55;
    uint u_1_56;
    uint u_1_57;
    uint u_1_58;
    uint u_1_59;
    uint u_1_6;
    uint u_1_60;
    uint u_1_phi_138;
    uint u_1_phi_185;
    uint u_1_phi_19;
    uint u_1_phi_201;
    uint u_1_phi_205;
    uint u_1_phi_21;
    uint u_1_phi_22;
    uint u_1_phi_220;
    uint u_1_phi_222;
    uint u_1_phi_239;
    uint u_1_phi_30;
    uint u_1_phi_37;
    uint u_1_phi_44;
    uint u_1_phi_51;
    uint u_10_10;
    uint u_10_11;
    uint u_10_12;
    uint u_10_13;
    uint u_10_15;
    uint u_10_16;
    uint u_10_17;
    uint u_10_18;
    uint u_10_20;
    uint u_10_21;
    uint u_10_23;
    uint u_10_24;
    uint u_10_29;
    uint u_10_31;
    uint u_10_32;
    uint u_10_33;
    uint u_10_34;
    uint u_10_35;
    uint u_10_36;
    uint u_10_4;
    uint u_10_40;
    uint u_10_43;
    uint u_10_46;
    uint u_10_48;
    uint u_10_49;
    uint u_10_5;
    uint u_10_50;
    uint u_10_51;
    uint u_10_53;
    uint u_10_54;
    uint u_10_55;
    uint u_10_56;
    uint u_10_9;
    uint u_10_phi_121;
    uint u_10_phi_136;
    uint u_10_phi_139;
    uint u_10_phi_188;
    uint u_10_phi_192;
    uint u_10_phi_20;
    uint u_10_phi_209;
    uint u_10_phi_219;
    uint u_10_phi_41;
    uint u_10_phi_43;
    uint u_10_phi_81;
    uint u_10_phi_99;
    uint u_11_1;
    uint u_11_11;
    uint u_11_12;
    uint u_11_13;
    uint u_11_14;
    uint u_11_15;
    uint u_11_16;
    uint u_11_17;
    uint u_11_19;
    uint u_11_2;
    uint u_11_20;
    uint u_11_7;
    uint u_11_8;
    uint u_11_9;
    uint u_11_phi_133;
    uint u_11_phi_39;
    uint u_11_phi_45;
    uint u_11_phi_49;
    uint u_11_phi_53;
    uint u_11_phi_56;
    uint u_12_1;
    uint u_12_10;
    uint u_12_12;
    uint u_12_13;
    uint u_12_15;
    uint u_12_16;
    uint u_12_18;
    uint u_12_19;
    uint u_12_2;
    uint u_12_23;
    uint u_12_24;
    uint u_12_3;
    uint u_12_5;
    uint u_12_6;
    uint u_12_8;
    uint u_12_phi_101;
    uint u_12_phi_120;
    uint u_12_phi_133;
    uint u_12_phi_83;
    uint u_13_11;
    uint u_13_14;
    uint u_13_16;
    uint u_13_17;
    uint u_13_18;
    uint u_13_19;
    uint u_13_21;
    uint u_13_22;
    uint u_13_23;
    uint u_13_24;
    uint u_13_4;
    uint u_13_phi_189;
    uint u_13_phi_199;
    uint u_13_phi_221;
    uint u_13_phi_224;
    uint u_14_18;
    uint u_14_19;
    uint u_14_22;
    uint u_14_23;
    uint u_14_25;
    uint u_14_26;
    uint u_14_29;
    uint u_14_3;
    uint u_14_30;
    uint u_14_31;
    uint u_14_33;
    uint u_14_37;
    uint u_14_38;
    uint u_14_39;
    uint u_14_40;
    uint u_14_44;
    uint u_14_47;
    uint u_14_5;
    uint u_14_50;
    uint u_14_54;
    uint u_14_57;
    uint u_14_58;
    uint u_14_59;
    uint u_14_60;
    uint u_14_63;
    uint u_14_64;
    uint u_14_66;
    uint u_14_67;
    uint u_14_8;
    uint u_14_phi_119;
    uint u_14_phi_137;
    uint u_14_phi_144;
    uint u_14_phi_167;
    uint u_14_phi_184;
    uint u_14_phi_204;
    uint u_14_phi_227;
    uint u_14_phi_61;
    uint u_14_phi_79;
    uint u_14_phi_97;
    uint u_15_14;
    uint u_15_15;
    uint u_15_16;
    uint u_15_17;
    uint u_15_18;
    uint u_15_19;
    uint u_15_20;
    uint u_15_21;
    uint u_15_22;
    uint u_15_23;
    uint u_15_26;
    uint u_15_27;
    uint u_15_28;
    uint u_15_29;
    uint u_15_30;
    uint u_15_31;
    uint u_15_32;
    uint u_15_36;
    uint u_15_38;
    uint u_15_39;
    uint u_15_44;
    uint u_15_45;
    uint u_15_46;
    uint u_15_5;
    uint u_15_6;
    uint u_15_phi_113;
    uint u_15_phi_141;
    uint u_15_phi_143;
    uint u_15_phi_145;
    uint u_15_phi_160;
    uint u_15_phi_63;
    uint u_15_phi_77;
    uint u_15_phi_93;
    uint u_16_0;
    uint u_16_1;
    uint u_16_10;
    uint u_16_11;
    uint u_16_14;
    uint u_16_15;
    uint u_16_16;
    uint u_16_17;
    uint u_16_18;
    uint u_16_19;
    uint u_16_21;
    uint u_16_22;
    uint u_16_23;
    uint u_16_24;
    uint u_16_25;
    uint u_16_26;
    uint u_16_28;
    uint u_16_29;
    uint u_16_3;
    uint u_16_31;
    uint u_16_32;
    uint u_16_38;
    uint u_16_39;
    uint u_16_4;
    uint u_16_41;
    uint u_16_42;
    uint u_16_43;
    uint u_16_44;
    uint u_16_7;
    uint u_16_8;
    uint u_16_phi_115;
    uint u_16_phi_123;
    uint u_16_phi_142;
    uint u_16_phi_147;
    uint u_16_phi_149;
    uint u_16_phi_207;
    uint u_16_phi_227;
    uint u_16_phi_54;
    uint u_16_phi_60;
    uint u_16_phi_75;
    uint u_16_phi_80;
    uint u_16_phi_94;
    uint u_16_phi_96;
    uint u_17_0;
    uint u_17_13;
    uint u_17_14;
    uint u_17_15;
    uint u_17_16;
    uint u_17_17;
    uint u_17_18;
    uint u_17_19;
    uint u_17_22;
    uint u_17_23;
    uint u_17_24;
    uint u_17_25;
    uint u_17_26;
    uint u_17_27;
    uint u_17_4;
    uint u_17_5;
    uint u_17_6;
    uint u_17_8;
    uint u_17_9;
    uint u_17_phi_100;
    uint u_17_phi_117;
    uint u_17_phi_148;
    uint u_17_phi_150;
    uint u_17_phi_152;
    uint u_17_phi_183;
    uint u_17_phi_207;
    uint u_17_phi_227;
    uint u_18_1;
    uint u_18_10;
    uint u_18_11;
    uint u_18_12;
    uint u_18_13;
    uint u_18_14;
    uint u_18_15;
    uint u_18_2;
    uint u_18_3;
    uint u_18_4;
    uint u_18_8;
    uint u_18_9;
    uint u_18_phi_146;
    uint u_18_phi_153;
    uint u_18_phi_155;
    uint u_18_phi_158;
    uint u_18_phi_162;
    uint u_18_phi_55;
    uint u_19_0;
    uint u_19_1;
    uint u_19_10;
    uint u_19_13;
    uint u_19_14;
    uint u_19_16;
    uint u_19_17;
    uint u_19_18;
    uint u_19_19;
    uint u_19_2;
    uint u_19_20;
    uint u_19_21;
    uint u_19_3;
    uint u_19_4;
    uint u_19_5;
    uint u_19_7;
    uint u_19_8;
    uint u_19_9;
    uint u_19_phi_118;
    uint u_19_phi_163;
    uint u_19_phi_187;
    uint u_19_phi_207;
    uint u_19_phi_227;
    uint u_19_phi_47;
    uint u_19_phi_73;
    uint u_19_phi_98;
    uint u_2_1;
    uint u_2_11;
    uint u_2_14;
    uint u_2_15;
    uint u_2_19;
    uint u_2_2;
    uint u_2_22;
    uint u_2_23;
    uint u_2_26;
    uint u_2_27;
    uint u_2_29;
    uint u_2_3;
    uint u_2_30;
    uint u_2_32;
    uint u_2_33;
    uint u_2_34;
    uint u_2_36;
    uint u_2_37;
    uint u_2_4;
    uint u_2_41;
    uint u_2_43;
    uint u_2_44;
    uint u_2_45;
    uint u_2_46;
    uint u_2_8;
    uint u_2_phi_159;
    uint u_2_phi_187;
    uint u_2_phi_20;
    uint u_2_phi_206;
    uint u_2_phi_22;
    uint u_2_phi_227;
    uint u_2_phi_24;
    uint u_2_phi_244;
    uint u_2_phi_246;
    uint u_20_11;
    uint u_20_12;
    uint u_20_14;
    uint u_20_15;
    uint u_20_16;
    uint u_20_17;
    uint u_20_18;
    uint u_20_19;
    uint u_20_2;
    uint u_20_20;
    uint u_20_21;
    uint u_20_22;
    uint u_20_23;
    uint u_20_3;
    uint u_20_4;
    uint u_20_5;
    uint u_20_8;
    uint u_20_9;
    uint u_20_phi_101;
    uint u_20_phi_121;
    uint u_20_phi_164;
    uint u_20_phi_187;
    uint u_20_phi_207;
    uint u_20_phi_227;
    uint u_20_phi_50;
    uint u_20_phi_57;
    uint u_20_phi_78;
    uint u_21_0;
    uint u_21_1;
    uint u_21_10;
    uint u_21_11;
    uint u_21_12;
    uint u_21_13;
    uint u_21_14;
    uint u_21_15;
    uint u_21_16;
    uint u_21_17;
    uint u_21_18;
    uint u_21_19;
    uint u_21_3;
    uint u_21_4;
    uint u_21_5;
    uint u_21_6;
    uint u_21_7;
    uint u_21_8;
    uint u_21_phi_101;
    uint u_21_phi_121;
    uint u_21_phi_167;
    uint u_21_phi_187;
    uint u_21_phi_207;
    uint u_21_phi_228;
    uint u_21_phi_232;
    uint u_21_phi_48;
    uint u_21_phi_81;
    uint u_22_0;
    uint u_22_1;
    uint u_22_10;
    uint u_22_11;
    uint u_22_12;
    uint u_22_13;
    uint u_22_14;
    uint u_22_15;
    uint u_22_17;
    uint u_22_18;
    uint u_22_2;
    uint u_22_3;
    uint u_22_4;
    uint u_22_5;
    uint u_22_6;
    uint u_22_7;
    uint u_22_8;
    uint u_22_9;
    uint u_22_phi_101;
    uint u_22_phi_121;
    uint u_22_phi_167;
    uint u_22_phi_187;
    uint u_22_phi_208;
    uint u_22_phi_212;
    uint u_22_phi_230;
    uint u_22_phi_58;
    uint u_22_phi_81;
    uint u_23_1;
    uint u_23_10;
    uint u_23_11;
    uint u_23_12;
    uint u_23_14;
    uint u_23_15;
    uint u_23_16;
    uint u_23_17;
    uint u_23_19;
    uint u_23_2;
    uint u_23_20;
    uint u_23_3;
    uint u_23_4;
    uint u_23_5;
    uint u_23_6;
    uint u_23_7;
    uint u_23_8;
    uint u_23_9;
    uint u_23_phi_101;
    uint u_23_phi_121;
    uint u_23_phi_167;
    uint u_23_phi_187;
    uint u_23_phi_210;
    uint u_23_phi_231;
    uint u_23_phi_234;
    uint u_23_phi_61;
    uint u_23_phi_81;
    uint u_24_0;
    uint u_24_1;
    uint u_24_11;
    uint u_24_12;
    uint u_24_13;
    uint u_24_14;
    uint u_24_16;
    uint u_24_17;
    uint u_24_19;
    uint u_24_2;
    uint u_24_20;
    uint u_24_3;
    uint u_24_4;
    uint u_24_5;
    uint u_24_6;
    uint u_24_7;
    uint u_24_8;
    uint u_24_9;
    uint u_24_phi_101;
    uint u_24_phi_121;
    uint u_24_phi_167;
    uint u_24_phi_190;
    uint u_24_phi_211;
    uint u_24_phi_214;
    uint u_24_phi_233;
    uint u_24_phi_61;
    uint u_24_phi_81;
    uint u_25_0;
    uint u_25_1;
    uint u_25_10;
    uint u_25_11;
    uint u_25_12;
    uint u_25_13;
    uint u_25_14;
    uint u_25_15;
    uint u_25_17;
    uint u_25_18;
    uint u_25_2;
    uint u_25_20;
    uint u_25_21;
    uint u_25_23;
    uint u_25_24;
    uint u_25_3;
    uint u_25_4;
    uint u_25_5;
    uint u_25_6;
    uint u_25_7;
    uint u_25_8;
    uint u_25_9;
    uint u_25_phi_102;
    uint u_25_phi_106;
    uint u_25_phi_122;
    uint u_25_phi_126;
    uint u_25_phi_167;
    uint u_25_phi_191;
    uint u_25_phi_194;
    uint u_25_phi_213;
    uint u_25_phi_235;
    uint u_25_phi_61;
    uint u_25_phi_81;
    uint u_26_0;
    uint u_26_1;
    uint u_26_10;
    uint u_26_11;
    uint u_26_12;
    uint u_26_13;
    uint u_26_14;
    uint u_26_15;
    uint u_26_17;
    uint u_26_18;
    uint u_26_2;
    uint u_26_20;
    uint u_26_21;
    uint u_26_22;
    uint u_26_23;
    uint u_26_3;
    uint u_26_4;
    uint u_26_5;
    uint u_26_7;
    uint u_26_8;
    uint u_26_phi_104;
    uint u_26_phi_124;
    uint u_26_phi_168;
    uint u_26_phi_172;
    uint u_26_phi_193;
    uint u_26_phi_215;
    uint u_26_phi_236;
    uint u_26_phi_61;
    uint u_26_phi_82;
    uint u_26_phi_86;
    uint u_27_0;
    uint u_27_1;
    uint u_27_10;
    uint u_27_11;
    uint u_27_13;
    uint u_27_14;
    uint u_27_16;
    uint u_27_17;
    uint u_27_19;
    uint u_27_20;
    uint u_27_21;
    uint u_27_22;
    uint u_27_23;
    uint u_27_24;
    uint u_27_3;
    uint u_27_4;
    uint u_27_5;
    uint u_27_6;
    uint u_27_8;
    uint u_27_9;
    uint u_27_phi_105;
    uint u_27_phi_108;
    uint u_27_phi_125;
    uint u_27_phi_128;
    uint u_27_phi_170;
    uint u_27_phi_195;
    uint u_27_phi_216;
    uint u_27_phi_236;
    uint u_27_phi_61;
    uint u_27_phi_84;
    uint u_28_0;
    uint u_28_1;
    uint u_28_10;
    uint u_28_11;
    uint u_28_13;
    uint u_28_14;
    uint u_28_15;
    uint u_28_16;
    uint u_28_18;
    uint u_28_19;
    uint u_28_2;
    uint u_28_20;
    uint u_28_21;
    uint u_28_22;
    uint u_28_23;
    uint u_28_24;
    uint u_28_25;
    uint u_28_3;
    uint u_28_4;
    uint u_28_5;
    uint u_28_7;
    uint u_28_8;
    uint u_28_phi_107;
    uint u_28_phi_127;
    uint u_28_phi_171;
    uint u_28_phi_174;
    uint u_28_phi_196;
    uint u_28_phi_216;
    uint u_28_phi_236;
    uint u_28_phi_62;
    uint u_28_phi_66;
    uint u_28_phi_85;
    uint u_28_phi_88;
    uint u_29_1;
    uint u_29_10;
    uint u_29_11;
    uint u_29_13;
    uint u_29_14;
    uint u_29_15;
    uint u_29_16;
    uint u_29_17;
    uint u_29_18;
    uint u_29_19;
    uint u_29_2;
    uint u_29_20;
    uint u_29_4;
    uint u_29_5;
    uint u_29_7;
    uint u_29_8;
    uint u_29_phi_109;
    uint u_29_phi_129;
    uint u_29_phi_173;
    uint u_29_phi_196;
    uint u_29_phi_216;
    uint u_29_phi_236;
    uint u_29_phi_64;
    uint u_29_phi_87;
    uint u_3_1;
    uint u_3_11;
    uint u_3_12;
    uint u_3_13;
    uint u_3_14;
    uint u_3_15;
    uint u_3_2;
    uint u_3_3;
    uint u_3_4;
    uint u_3_7;
    uint u_3_8;
    uint u_3_phi_10;
    uint u_3_phi_18;
    uint u_3_phi_229;
    uint u_3_phi_23;
    uint u_3_phi_242;
    uint u_30_0;
    uint u_30_1;
    uint u_30_10;
    uint u_30_11;
    uint u_30_13;
    uint u_30_14;
    uint u_30_15;
    uint u_30_16;
    uint u_30_17;
    uint u_30_18;
    uint u_30_19;
    uint u_30_20;
    uint u_30_3;
    uint u_30_4;
    uint u_30_6;
    uint u_30_7;
    uint u_30_8;
    uint u_30_9;
    uint u_30_phi_110;
    uint u_30_phi_130;
    uint u_30_phi_175;
    uint u_30_phi_196;
    uint u_30_phi_216;
    uint u_30_phi_236;
    uint u_30_phi_65;
    uint u_30_phi_68;
    uint u_30_phi_89;
    uint u_31_1;
    uint u_31_10;
    uint u_31_11;
    uint u_31_12;
    uint u_31_13;
    uint u_31_14;
    uint u_31_15;
    uint u_31_16;
    uint u_31_2;
    uint u_31_3;
    uint u_31_4;
    uint u_31_5;
    uint u_31_6;
    uint u_31_7;
    uint u_31_8;
    uint u_31_9;
    uint u_31_phi_110;
    uint u_31_phi_130;
    uint u_31_phi_176;
    uint u_31_phi_196;
    uint u_31_phi_216;
    uint u_31_phi_236;
    uint u_31_phi_67;
    uint u_31_phi_90;
    uint u_32_1;
    uint u_32_10;
    uint u_32_11;
    uint u_32_12;
    uint u_32_13;
    uint u_32_14;
    uint u_32_15;
    uint u_32_16;
    uint u_32_2;
    uint u_32_3;
    uint u_32_4;
    uint u_32_5;
    uint u_32_6;
    uint u_32_7;
    uint u_32_8;
    uint u_32_9;
    uint u_32_phi_110;
    uint u_32_phi_130;
    uint u_32_phi_176;
    uint u_32_phi_196;
    uint u_32_phi_216;
    uint u_32_phi_237;
    uint u_32_phi_69;
    uint u_32_phi_90;
    uint u_33_0;
    uint u_33_1;
    uint u_33_10;
    uint u_33_11;
    uint u_33_12;
    uint u_33_13;
    uint u_33_14;
    uint u_33_15;
    uint u_33_2;
    uint u_33_3;
    uint u_33_4;
    uint u_33_5;
    uint u_33_6;
    uint u_33_7;
    uint u_33_8;
    uint u_33_9;
    uint u_33_phi_110;
    uint u_33_phi_130;
    uint u_33_phi_176;
    uint u_33_phi_196;
    uint u_33_phi_217;
    uint u_33_phi_237;
    uint u_33_phi_70;
    uint u_33_phi_90;
    uint u_34_0;
    uint u_34_1;
    uint u_34_10;
    uint u_34_11;
    uint u_34_12;
    uint u_34_13;
    uint u_34_14;
    uint u_34_15;
    uint u_34_2;
    uint u_34_3;
    uint u_34_4;
    uint u_34_5;
    uint u_34_6;
    uint u_34_7;
    uint u_34_8;
    uint u_34_9;
    uint u_34_phi_110;
    uint u_34_phi_130;
    uint u_34_phi_176;
    uint u_34_phi_197;
    uint u_34_phi_217;
    uint u_34_phi_237;
    uint u_34_phi_70;
    uint u_34_phi_90;
    uint u_35_0;
    uint u_35_1;
    uint u_35_10;
    uint u_35_11;
    uint u_35_12;
    uint u_35_13;
    uint u_35_14;
    uint u_35_15;
    uint u_35_2;
    uint u_35_3;
    uint u_35_4;
    uint u_35_5;
    uint u_35_6;
    uint u_35_7;
    uint u_35_8;
    uint u_35_9;
    uint u_35_phi_110;
    uint u_35_phi_130;
    uint u_35_phi_176;
    uint u_35_phi_197;
    uint u_35_phi_217;
    uint u_35_phi_237;
    uint u_35_phi_70;
    uint u_35_phi_90;
    uint u_36_0;
    uint u_36_1;
    uint u_36_10;
    uint u_36_11;
    uint u_36_12;
    uint u_36_13;
    uint u_36_14;
    uint u_36_15;
    uint u_36_2;
    uint u_36_3;
    uint u_36_4;
    uint u_36_5;
    uint u_36_6;
    uint u_36_7;
    uint u_36_8;
    uint u_36_9;
    uint u_36_phi_111;
    uint u_36_phi_131;
    uint u_36_phi_176;
    uint u_36_phi_197;
    uint u_36_phi_217;
    uint u_36_phi_237;
    uint u_36_phi_70;
    uint u_36_phi_90;
    uint u_37_0;
    uint u_37_1;
    uint u_37_10;
    uint u_37_11;
    uint u_37_12;
    uint u_37_13;
    uint u_37_14;
    uint u_37_15;
    uint u_37_2;
    uint u_37_3;
    uint u_37_4;
    uint u_37_5;
    uint u_37_6;
    uint u_37_7;
    uint u_37_8;
    uint u_37_9;
    uint u_37_phi_111;
    uint u_37_phi_131;
    uint u_37_phi_177;
    uint u_37_phi_197;
    uint u_37_phi_217;
    uint u_37_phi_237;
    uint u_37_phi_70;
    uint u_37_phi_91;
    uint u_38_0;
    uint u_38_1;
    uint u_38_10;
    uint u_38_11;
    uint u_38_12;
    uint u_38_13;
    uint u_38_15;
    uint u_38_16;
    uint u_38_2;
    uint u_38_3;
    uint u_38_4;
    uint u_38_5;
    uint u_38_6;
    uint u_38_7;
    uint u_38_8;
    uint u_38_9;
    uint u_38_phi_111;
    uint u_38_phi_131;
    uint u_38_phi_177;
    uint u_38_phi_197;
    uint u_38_phi_217;
    uint u_38_phi_238;
    uint u_38_phi_70;
    uint u_38_phi_91;
    uint u_39_0;
    uint u_39_1;
    uint u_39_10;
    uint u_39_11;
    uint u_39_13;
    uint u_39_14;
    uint u_39_16;
    uint u_39_17;
    uint u_39_2;
    uint u_39_3;
    uint u_39_4;
    uint u_39_5;
    uint u_39_6;
    uint u_39_7;
    uint u_39_8;
    uint u_39_9;
    uint u_39_phi_111;
    uint u_39_phi_131;
    uint u_39_phi_177;
    uint u_39_phi_197;
    uint u_39_phi_218;
    uint u_39_phi_238;
    uint u_39_phi_71;
    uint u_39_phi_91;
    uint u_4_1;
    uint u_4_14;
    uint u_4_17;
    uint u_4_18;
    uint u_4_19;
    uint u_4_2;
    uint u_4_20;
    uint u_4_21;
    uint u_4_23;
    uint u_4_24;
    uint u_4_25;
    uint u_4_26;
    uint u_4_31;
    uint u_4_32;
    uint u_4_34;
    uint u_4_35;
    uint u_4_6;
    uint u_4_8;
    uint u_4_9;
    uint u_4_phi_165;
    uint u_4_phi_182;
    uint u_4_phi_200;
    uint u_4_phi_202;
    uint u_4_phi_225;
    uint u_4_phi_248;
    uint u_4_phi_27;
    uint u_4_phi_4;
    uint u_40_0;
    uint u_40_1;
    uint u_40_11;
    uint u_40_12;
    uint u_40_14;
    uint u_40_15;
    uint u_40_17;
    uint u_40_18;
    uint u_40_2;
    uint u_40_3;
    uint u_40_4;
    uint u_40_5;
    uint u_40_6;
    uint u_40_7;
    uint u_40_8;
    uint u_40_9;
    uint u_40_phi_111;
    uint u_40_phi_131;
    uint u_40_phi_177;
    uint u_40_phi_198;
    uint u_40_phi_218;
    uint u_40_phi_238;
    uint u_40_phi_71;
    uint u_40_phi_91;
    uint u_41_0;
    uint u_41_1;
    uint u_41_11;
    uint u_41_12;
    uint u_41_14;
    uint u_41_15;
    uint u_41_17;
    uint u_41_18;
    uint u_41_2;
    uint u_41_3;
    uint u_41_4;
    uint u_41_5;
    uint u_41_6;
    uint u_41_7;
    uint u_41_8;
    uint u_41_9;
    uint u_41_phi_111;
    uint u_41_phi_131;
    uint u_41_phi_177;
    uint u_41_phi_198;
    uint u_41_phi_218;
    uint u_41_phi_238;
    uint u_41_phi_71;
    uint u_41_phi_91;
    uint u_42_0;
    uint u_42_1;
    uint u_42_10;
    uint u_42_11;
    uint u_42_13;
    uint u_42_14;
    uint u_42_16;
    uint u_42_17;
    uint u_42_19;
    uint u_42_2;
    uint u_42_20;
    uint u_42_3;
    uint u_42_4;
    uint u_42_5;
    uint u_42_6;
    uint u_42_8;
    uint u_42_9;
    uint u_42_phi_112;
    uint u_42_phi_132;
    uint u_42_phi_177;
    uint u_42_phi_198;
    uint u_42_phi_218;
    uint u_42_phi_238;
    uint u_42_phi_71;
    uint u_42_phi_91;
    uint u_43_0;
    uint u_43_1;
    uint u_43_10;
    uint u_43_12;
    uint u_43_13;
    uint u_43_15;
    uint u_43_16;
    uint u_43_18;
    uint u_43_19;
    uint u_43_2;
    uint u_43_21;
    uint u_43_22;
    uint u_43_3;
    uint u_43_4;
    uint u_43_5;
    uint u_43_6;
    uint u_43_7;
    uint u_43_9;
    uint u_43_phi_112;
    uint u_43_phi_132;
    uint u_43_phi_178;
    uint u_43_phi_198;
    uint u_43_phi_218;
    uint u_43_phi_238;
    uint u_43_phi_71;
    uint u_43_phi_92;
    uint u_44_0;
    uint u_44_1;
    uint u_44_10;
    uint u_44_12;
    uint u_44_13;
    uint u_44_15;
    uint u_44_16;
    uint u_44_18;
    uint u_44_19;
    uint u_44_2;
    uint u_44_3;
    uint u_44_4;
    uint u_44_5;
    uint u_44_6;
    uint u_44_7;
    uint u_44_9;
    uint u_44_phi_112;
    uint u_44_phi_132;
    uint u_44_phi_178;
    uint u_44_phi_198;
    uint u_44_phi_218;
    uint u_44_phi_71;
    uint u_44_phi_92;
    uint u_45_0;
    uint u_45_1;
    uint u_45_10;
    uint u_45_11;
    uint u_45_13;
    uint u_45_14;
    uint u_45_16;
    uint u_45_17;
    uint u_45_2;
    uint u_45_3;
    uint u_45_4;
    uint u_45_5;
    uint u_45_7;
    uint u_45_8;
    uint u_45_phi_112;
    uint u_45_phi_132;
    uint u_45_phi_178;
    uint u_45_phi_198;
    uint u_45_phi_72;
    uint u_45_phi_92;
    uint u_46_0;
    uint u_46_1;
    uint u_46_10;
    uint u_46_11;
    uint u_46_13;
    uint u_46_14;
    uint u_46_2;
    uint u_46_4;
    uint u_46_5;
    uint u_46_7;
    uint u_46_8;
    uint u_46_phi_112;
    uint u_46_phi_132;
    uint u_46_phi_178;
    uint u_46_phi_72;
    uint u_46_phi_92;
    uint u_47_0;
    uint u_47_1;
    uint u_47_10;
    uint u_47_11;
    uint u_47_13;
    uint u_47_14;
    uint u_47_2;
    uint u_47_4;
    uint u_47_5;
    uint u_47_6;
    uint u_47_7;
    uint u_47_8;
    uint u_47_phi_112;
    uint u_47_phi_132;
    uint u_47_phi_178;
    uint u_47_phi_72;
    uint u_47_phi_92;
    uint u_48_1;
    uint u_48_10;
    uint u_48_2;
    uint u_48_3;
    uint u_48_4;
    uint u_48_5;
    uint u_48_9;
    uint u_48_phi_178;
    uint u_48_phi_72;
    uint u_48_phi_92;
    uint u_49_1;
    uint u_49_2;
    uint u_49_3;
    uint u_49_phi_72;
    uint u_5_1;
    uint u_5_10;
    uint u_5_11;
    uint u_5_12;
    uint u_5_14;
    uint u_5_15;
    uint u_5_17;
    uint u_5_18;
    uint u_5_20;
    uint u_5_21;
    uint u_5_22;
    uint u_5_24;
    uint u_5_25;
    uint u_5_26;
    uint u_5_27;
    uint u_5_29;
    uint u_5_30;
    uint u_5_4;
    uint u_5_7;
    uint u_5_8;
    uint u_5_9;
    uint u_5_phi_169;
    uint u_5_phi_180;
    uint u_5_phi_186;
    uint u_5_phi_207;
    uint u_5_phi_223;
    uint u_5_phi_249;
    uint u_5_phi_29;
    uint u_5_phi_32;
    uint u_50_0;
    uint u_50_1;
    uint u_50_2;
    uint u_50_3;
    uint u_50_phi_72;
    uint u_51_0;
    uint u_51_1;
    uint u_52_0;
    uint u_52_1;
    uint u_53_0;
    uint u_53_2;
    uint u_56_0;
    uint u_6_0;
    uint u_6_1;
    uint u_6_3;
    uint u_6_phi_2;
    uint u_7_14;
    uint u_7_15;
    uint u_7_3;
    uint u_7_4;
    uint u_7_6;
    uint u_7_7;
    uint u_7_phi_16;
    uint u_7_phi_20;
    uint u_7_phi_31;
    uint u_8_0;
    uint u_8_1;
    uint u_8_10;
    uint u_8_11;
    uint u_8_12;
    uint u_8_13;
    uint u_8_18;
    uint u_8_2;
    uint u_8_20;
    uint u_8_23;
    uint u_8_25;
    uint u_8_26;
    uint u_8_28;
    uint u_8_29;
    uint u_8_30;
    uint u_8_31;
    uint u_8_32;
    uint u_8_33;
    uint u_8_34;
    uint u_8_35;
    uint u_8_36;
    uint u_8_37;
    uint u_8_38;
    uint u_8_40;
    uint u_8_41;
    uint u_8_42;
    uint u_8_5;
    uint u_8_6;
    uint u_8_7;
    uint u_8_8;
    uint u_8_9;
    uint u_8_phi_157;
    uint u_8_phi_166;
    uint u_8_phi_179;
    uint u_8_phi_181;
    uint u_8_phi_203;
    uint u_8_phi_226;
    uint u_8_phi_26;
    uint u_8_phi_34;
    uint u_8_phi_36;
    uint u_8_phi_38;
    uint u_8_phi_8;
    uint u_9_10;
    uint u_9_11;
    uint u_9_13;
    uint u_9_14;
    uint u_9_16;
    uint u_9_17;
    uint u_9_2;
    uint u_9_20;
    uint u_9_22;
    uint u_9_23;
    uint u_9_25;
    uint u_9_28;
    uint u_9_29;
    uint u_9_3;
    uint u_9_30;
    uint u_9_31;
    uint u_9_4;
    uint u_9_5;
    uint u_9_7;
    uint u_9_8;
    uint u_9_phi_134;
    uint u_9_phi_15;
    uint u_9_phi_156;
    uint u_9_phi_161;
    uint u_9_phi_17;
    uint u_9_phi_35;
    uint u_9_phi_40;
    uint u_9_phi_42;
    uint u_9_phi_52;
    uint2 u2_0_2;
    
    v2f o;
	// 221.7905  <=>  float(221.7905)
    o.vertex.x = float(221.7905);
	// 333.1893  <=>  float(333.18927)
    o.vertex.y = float(333.18927);
	// 430.2862  <=>  float(430.28619)
    o.vertex.z = float(430.28619);
	// 432.2517  <=>  float(432.25171)
    o.vertex.w = float(432.25171);
	// 0.00  <=>  float(0.00)
    o.fs_attr0.x = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr0.y = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr0.z = float(0.00);
	// 1.00  <=>  float(1.00)
    o.fs_attr0.w = float(1.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr1.x = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr1.y = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr1.z = float(0.00);
	// 0.10  <=>  float(0.10)
    o.fs_attr1.w = float(0.10);
	// 0.03125  <=>  float(0.03125)
    o.fs_attr2.x = float(0.03125);
	// 0.03125  <=>  float(0.03125)
    o.fs_attr2.y = float(0.03125);
	// 1.73624  <=>  float(1.73624)
    o.fs_attr2.z = float(1.73624);
	// 2.79527  <=>  float(2.79527)
    o.fs_attr2.w = float(2.79527);
	// 327.0211  <=>  float(327.02112)
    o.fs_attr3.x = float(327.02112);
	// 49.53122  <=>  float(49.53122)
    o.fs_attr3.y = float(49.53122);
	// 431.269  <=>  float(431.26895)
    o.fs_attr3.z = float(431.26895);
	// 432.2517  <=>  float(432.25171)
    o.fs_attr3.w = float(432.25171);
	// 0.00  <=>  float(0.00)
    o.fs_attr4.x = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr4.y = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr4.z = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr4.w = float(0.00);
	// 1.00  <=>  float(1.00)
    o.fs_attr5.x = float(1.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr5.y = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr5.z = float(0.00);
	// 1.00  <=>  float(1.00)
    o.fs_attr5.w = float(1.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr6.x = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr6.y = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr6.z = float(0.00);
	// 1.00  <=>  float(1.00)
    o.fs_attr6.w = float(1.00);
	// 520.0128  <=>  float(520.01276)
    o.fs_attr7.x = float(520.01276);
	// 1559.572  <=>  float(1559.57239)
    o.fs_attr7.y = float(1559.57239);
	// 974.8118  <=>  float(974.81177)
    o.fs_attr7.z = float(974.81177);
	// 1.00  <=>  float(1.00)
    o.fs_attr7.w = float(1.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr8.x = float(0.00);
	// 89.89288  <=>  float(89.89288)
    o.fs_attr8.y = float(89.89288);
	// 0.00  <=>  float(0.00)
    o.fs_attr8.z = float(0.00);
	// 1.00  <=>  float(1.00)
    o.fs_attr8.w = float(1.00);
	// 520.0128  <=>  float(520.01276)
    o.fs_attr9.x = float(520.01276);
	// 1559.572  <=>  float(1559.57239)
    o.fs_attr9.y = float(1559.57239);
	// 974.8118  <=>  float(974.81177)
    o.fs_attr9.z = float(974.81177);
	// 1.00  <=>  float(1.00)
    o.fs_attr9.w = float(1.00);
	// 0.12  <=>  float(0.12)
    o.fs_attr10.x = float(0.12);
	// 0.00  <=>  float(0.00)
    o.fs_attr10.y = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr10.z = float(0.00);
	// 1.00  <=>  float(1.00)
    o.fs_attr10.w = float(1.00);
	// 1.04062  <=>  float(1.04062)
    o.fs_attr11.x = float(1.04062);
	// 1.28819  <=>  float(1.28819)
    o.fs_attr11.y = float(1.28819);
	// 1.48423  <=>  float(1.48423)
    o.fs_attr11.z = float(1.48423);
	// 1.00  <=>  float(1.00)
    o.fs_attr11.w = float(1.00);
	// 0.75843  <=>  float(0.75843)
    o.fs_attr12.x = float(0.75843);
	// 0.22514  <=>  float(0.22514)
    o.fs_attr12.y = float(0.22514);
	// 0.89314  <=>  float(0.89314)
    o.fs_attr12.z = float(0.89314);
	// 0.78952  <=>  float(0.78952)
    o.fs_attr12.w = float(0.78952);
	// 38.77518  <=>  float(38.77518)
    o.fs_attr13.x = float(38.77518);
	// 0.00  <=>  float(0.00)
    o.fs_attr13.y = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr13.z = float(0.00);
	// 1.00  <=>  float(1.00)
    o.fs_attr13.w = float(1.00);
	// 0.11038  <=>  float(0.11038)
    o.fs_attr14.x = float(0.11038);
	// 0.13027  <=>  float(0.13027)
    o.fs_attr14.y = float(0.13027);
	// 0.17039  <=>  float(0.17039)
    o.fs_attr14.z = float(0.17039);
	// 0.85808  <=>  float(0.85808)
    o.fs_attr14.w = float(0.85808);
	// 0.26314  <=>  float(0.26314)
    o.fs_attr15.x = float(0.26314);
	// 0.93948  <=>  float(0.93948)
    o.fs_attr15.y = float(0.93948);
	// 0.63155  <=>  float(0.63155)
    o.fs_attr15.z = float(0.63155);
	// 1.00  <=>  float(1.00)
    o.fs_attr15.w = float(1.00);
	// 4.46875  <=>  float(4.46875)
    o.fs_attr16.x = float(4.46875);
	// 3.0293  <=>  float(3.0293)
    o.fs_attr16.y = float(3.0293);
	// 1.74707  <=>  float(1.74707)
    o.fs_attr16.z = float(1.74707);
	// 0.00  <=>  float(0.00)
    o.fs_attr16.w = float(0.00);
	// 0.20862  <=>  float(0.20862)
    o.fs_attr17.x = float(0.20862);
	// 0.45313  <=>  float(0.45313)
    o.fs_attr17.y = float(0.45313);
	// 0.84766  <=>  float(0.84766)
    o.fs_attr17.z = float(0.84766);
	// 0.00  <=>  float(0.00)
    o.fs_attr17.w = float(0.00);
	// 0.90504  <=>  float(0.90504)
    o.fs_attr18.x = float(0.90504);
	// 0.00  <=>  float(0.00)
    o.fs_attr18.y = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr18.z = float(0.00);
	// 1.00  <=>  float(1.00)
    o.fs_attr18.w = float(1.00);
	// 0.40417  <=>  float(0.40417)
    o.fs_attr19.x = float(0.40417);
	// 0.00  <=>  float(0.00)
    o.fs_attr19.y = float(0.00);
	// 0.00  <=>  float(0.00)
    o.fs_attr19.z = float(0.00);
	// 1.00  <=>  float(1.00)
    o.fs_attr19.w = float(1.00);
	// 0.34375  <=>  float(0.34375)
    o.fs_attr20.x = float(0.34375);
	// 0.40625  <=>  float(0.40625)
    o.fs_attr20.y = float(0.40625);
	// 0.00  <=>  float(0.00)
    o.fs_attr20.z = float(0.00);
	// 1.00  <=>  float(1.00)
    o.fs_attr20.w = float(1.00);
	// 0.40625  <=>  float(0.40625)
    o.fs_attr21.x = float(0.40625);
	// 0.40625  <=>  float(0.40625)
    o.fs_attr21.y = float(0.40625);
	// 0.00  <=>  float(0.00)
    o.fs_attr21.z = float(0.00);
	// 1.00  <=>  float(1.00)
    o.fs_attr21.w = float(1.00);
	// 0.34375  <=>  float(0.34375)
    o.fs_attr22.x = float(0.34375);
	// 0.46875  <=>  float(0.46875)
    o.fs_attr22.y = float(0.46875);
	// 0.00  <=>  float(0.00)
    o.fs_attr22.z = float(0.00);
	// 1.00  <=>  float(1.00)
    o.fs_attr22.w = float(1.00);
	// 0.40625  <=>  float(0.40625)
    o.fs_attr23.x = float(0.40625);
	// 0.46875  <=>  float(0.46875)
    o.fs_attr23.y = float(0.46875);
	// 0.00  <=>  float(0.00)
    o.fs_attr23.z = float(0.00);
	// 1.00  <=>  float(1.00)
    o.fs_attr23.w = float(1.00);
	// 268435008  <=>  (isnan({uni_attr3.w : 268435000.00}) ? 0u : uint(clamp(trunc({uni_attr3.w : 268435000.00}), float(-2147483600.f), float(2147483600.f))))
    u_5_1 = (isnan(uni_attr3.w) ? 0u : uint(clamp(trunc(uni_attr3.w), float(-2147483600.f), float(2147483600.f))));
	// False  <=>  if(((int({u_5_1 : 268435008}) <= int(0u)) ? true : false))
    if (((int(u_5_1) <= int(0u)) ? true : false))
    {
		// 0.00  <=>  0.f
        o.vertex.x = 0.f;
    }
	// 0  <=>  0u
    u_6_0 = 0u;
    u_6_phi_2 = u_6_0;
	// False  <=>  if(((int({u_5_1 : 268435008}) <= int(0u)) ? true : false))
    if (((int(u_5_1) <= int(0u)) ? true : false))
    {
		// 1187205120  <=>  {vs_cbuf8_30.y : 1187205120}
        u_6_1 = ftou2(vs_cbuf8_30.y);
        u_6_phi_2 = u_6_1;
    }
	// False  <=>  if(((int({u_5_1 : 268435008}) <= int(0u)) ? true : false))
    if (((int(u_5_1) <= int(0u)) ? true : false))
    {
		// 0.00  <=>  0.f
        o.vertex.y = 0.f;
    }
	// 0  <=>  {u_6_phi_2 : 0}
    u_4_1 = u_6_phi_2;
    u_4_phi_4 = u_4_1;
	// False  <=>  if(((int({u_5_1 : 268435008}) <= int(0u)) ? true : false))
    if (((int(u_5_1) <= int(0u)) ? true : false))
    {
		// 0  <=>  {ftou2(({utof2(u_6_phi_2) : 0.00} * 5.f)) : 0}
        u_4_2 = ftou2(( utof2(u_6_phi_2) * 5.f));
        u_4_phi_4 = u_4_2;
    }
	// False  <=>  if(((int({u_5_1 : 268435008}) <= int(0u)) ? true : false))
    if (((int(u_5_1) <= int(0u)) ? true : false))
    {
		// 0.00  <=>  0.f
        o.fs_attr5.x = 0.f;
    }
	// False  <=>  if(((int({u_5_1 : 268435008}) <= int(0u)) ? true : false))
    if (((int(u_5_1) <= int(0u)) ? true : false))
    {
		// 0.00  <=>  {utof2(u_4_phi_4) : 0.00}
        o.vertex.z = utof2(u_4_phi_4);
    }
	// False  <=>  if(((int({u_5_1 : 268435008}) <= int(0u)) ? true : false))
    if (((int(u_5_1) <= int(0u)) ? true : false))
    {
        return o;
    }
	// 1605.00  <=>  ((0.f - {uni_attr4.w : 0.00}) + {utof(vs_cbuf10_2.x) : 1605.00})
    pf_0_1 = ((0.f - uni_attr4.w) + utof(vs_cbuf10_2.x));
	// 0  <=>  (isnan({uni_attr7.w : 0.00}) ? 0u : uint(clamp(trunc({uni_attr7.w : 0.00}), float(-2147483600.f), float(2147483600.f))))
    u_6_3 = (isnan(uni_attr7.w) ? 0u : uint(clamp(trunc(uni_attr7.w), float(-2147483600.f), float(2147483600.f))));
	// False  <=>  ((({pf_0_1 : 1605.00} >= float(int({u_5_1 : 268435008}))) && (! isnan({pf_0_1 : 1605.00}))) && (! isnan(float(int({u_5_1 : 268435008})))))
    b_0_3 = (((pf_0_1 >= float(int(u_5_1))) && (!isnan(pf_0_1))) && (!isnan(float(int(u_5_1)))));
	// 0.00  <=>  float(int({u_6_3 : 0}))
    o.fs_attr4.w = float(int(u_6_3));
	// False  <=>  ((((({uni_attr4.w : 0.00} > {utof(vs_cbuf10_2.x) : 1605.00}) && (! isnan({uni_attr4.w : 0.00}))) && (! isnan({utof(vs_cbuf10_2.x) : 1605.00}))) || {b_0_3 : False}) ? true : false)
    b_1_8 = (((((uni_attr4.w > utof(vs_cbuf10_2.x)) && (!isnan(uni_attr4.w))) && (!isnan( utof(vs_cbuf10_2.x)))) || b_0_3) ? true : false);
	// 0  <=>  0u
    u_8_0 = 0u;
    u_8_phi_8 = u_8_0;
	// False  <=>  if({b_1_8 : False})
    if (b_1_8)
    {
		// 1187205120  <=>  {vs_cbuf8_30.y : 1187205120}
        u_8_1 = ftou2(vs_cbuf8_30.y);
        u_8_phi_8 = u_8_1;
    }
	// False  <=>  ((((({uni_attr4.w : 0.00} > {utof(vs_cbuf10_2.x) : 1605.00}) && (! isnan({uni_attr4.w : 0.00}))) && (! isnan({utof(vs_cbuf10_2.x) : 1605.00}))) || {b_0_3 : False}) ? true : false)
    b_1_9 = (((((uni_attr4.w > utof(vs_cbuf10_2.x)) && (!isnan(uni_attr4.w))) && (!isnan( utof(vs_cbuf10_2.x)))) || b_0_3) ? true : false);
	// False  <=>  if({b_1_9 : False})
    if (b_1_9)
    {
		// 0.00  <=>  0.f
        o.vertex.x = 0.f;
    }
	// False  <=>  ((((({uni_attr4.w : 0.00} > {utof(vs_cbuf10_2.x) : 1605.00}) && (! isnan({uni_attr4.w : 0.00}))) && (! isnan({utof(vs_cbuf10_2.x) : 1605.00}))) || {b_0_3 : False}) ? true : false)
    b_1_10 = (((((uni_attr4.w > utof(vs_cbuf10_2.x)) && (!isnan(uni_attr4.w))) && (!isnan( utof(vs_cbuf10_2.x)))) || b_0_3) ? true : false);
	// 0  <=>  {u_8_phi_8 : 0}
    u_3_1 = u_8_phi_8;
    u_3_phi_10 = u_3_1;
	// False  <=>  if({b_1_10 : False})
    if (b_1_10)
    {
		// 0  <=>  {ftou2(({utof2(u_8_phi_8) : 0.00} * 5.f)) : 0}
        u_3_2 = ftou2(( utof2(u_8_phi_8) * 5.f));
        u_3_phi_10 = u_3_2;
    }
	// False  <=>  ((((({uni_attr4.w : 0.00} > {utof(vs_cbuf10_2.x) : 1605.00}) && (! isnan({uni_attr4.w : 0.00}))) && (! isnan({utof(vs_cbuf10_2.x) : 1605.00}))) || {b_0_3 : False}) ? true : false)
    b_1_11 = (((((uni_attr4.w > utof(vs_cbuf10_2.x)) && (!isnan(uni_attr4.w))) && (!isnan( utof(vs_cbuf10_2.x)))) || b_0_3) ? true : false);
	// False  <=>  if({b_1_11 : False})
    if (b_1_11)
    {
		// 0.00  <=>  0.f
        o.vertex.y = 0.f;
    }
	// False  <=>  ((((({uni_attr4.w : 0.00} > {utof(vs_cbuf10_2.x) : 1605.00}) && (! isnan({uni_attr4.w : 0.00}))) && (! isnan({utof(vs_cbuf10_2.x) : 1605.00}))) || {b_0_3 : False}) ? true : false)
    b_1_12 = (((((uni_attr4.w > utof(vs_cbuf10_2.x)) && (!isnan(uni_attr4.w))) && (!isnan( utof(vs_cbuf10_2.x)))) || b_0_3) ? true : false);
	// False  <=>  if({b_1_12 : False})
    if (b_1_12)
    {
		// 0.00  <=>  {utof2(u_3_phi_10) : 0.00}
        o.vertex.z = utof2(u_3_phi_10);
    }
	// False  <=>  ((((({uni_attr4.w : 0.00} > {utof(vs_cbuf10_2.x) : 1605.00}) && (! isnan({uni_attr4.w : 0.00}))) && (! isnan({utof(vs_cbuf10_2.x) : 1605.00}))) || {b_0_3 : False}) ? true : false)
    b_1_13 = (((((uni_attr4.w > utof(vs_cbuf10_2.x)) && (!isnan(uni_attr4.w))) && (!isnan( utof(vs_cbuf10_2.x)))) || b_0_3) ? true : false);
	// False  <=>  if({b_1_13 : False})
    if (b_1_13)
    {
		// 0.00  <=>  0.f
        o.fs_attr5.x = 0.f;
    }
	// False  <=>  ((((({uni_attr4.w : 0.00} > {utof(vs_cbuf10_2.x) : 1605.00}) && (! isnan({uni_attr4.w : 0.00}))) && (! isnan({utof(vs_cbuf10_2.x) : 1605.00}))) || {b_0_3 : False}) ? true : false)
    b_1_14 = (((((uni_attr4.w > utof(vs_cbuf10_2.x)) && (!isnan(uni_attr4.w))) && (!isnan( utof(vs_cbuf10_2.x)))) || b_0_3) ? true : false);
	// False  <=>  if({b_1_14 : False})
    if (b_1_14)
    {
        return o;
    }
	// 1606.00  <=>  ({pf_0_1 : 1605.00} + {utof(vs_cbuf10_2.w) : 1.00})
    pf_1_1 = (pf_0_1 + utof(vs_cbuf10_2.w));
	// 1154007040  <=>  {ftou2(pf_1_1) : 1154007040}
    u_8_2 = ftou2(pf_1_1);
	// 0  <=>  {ftou2(float(int({u_6_3 : 0}))) : 0}
    u_9_2 = ftou2(float(int(u_6_3)));
    u_9_phi_15 = u_9_2;
	// False  <=>  if((((({utof(vs_cbuf9_15.x) : 0.95} == 1.f) && (! isnan({utof(vs_cbuf9_15.x) : 0.95}))) && (! isnan(1.f))) ? true : false))
    if ((((( utof(vs_cbuf9_15.x) == 1.f) && (!isnan( utof(vs_cbuf9_15.x)))) && (!isnan(1.f))) ? true : false))
    {
		// 2579236.00  <=>  ({pf_1_1 : 1606.00} * {pf_1_1 : 1606.00})
        pf_2_0 = (pf_1_1 * pf_1_1);
		// 1243442320  <=>  {ftou2(pf_2_0) : 1243442320}
        u_9_3 = ftou2(pf_2_0);
        u_9_phi_15 = u_9_3;
    }
	// 0  <=>  {u_9_phi_15 : 0}
    u_7_3 = u_9_phi_15;
    u_7_phi_16 = u_7_3;
	// False  <=>  if((((({utof(vs_cbuf9_15.x) : 0.95} == 1.f) && (! isnan({utof(vs_cbuf9_15.x) : 0.95}))) && (! isnan(1.f))) ? true : false))
    if ((((( utof(vs_cbuf9_15.x) == 1.f) && (!isnan( utof(vs_cbuf9_15.x)))) && (!isnan(1.f))) ? true : false))
    {
		// 0  <=>  {ftou2(({utof2(u_9_phi_15) : 0.00} * {utof(vs_cbuf9_14.w) : 0.00})) : 0}
        u_7_4 = ftou2(( utof2(u_9_phi_15) * utof(vs_cbuf9_14.w)));
        u_7_phi_16 = u_7_4;
    }
	// 0  <=>  {u_3_phi_10 : 0}
    u_9_4 = u_3_phi_10;
    u_9_phi_17 = u_9_4;
	// False  <=>  if((((({utof(vs_cbuf9_15.x) : 0.95} == 1.f) && (! isnan({utof(vs_cbuf9_15.x) : 0.95}))) && (! isnan(1.f))) ? true : false))
    if ((((( utof(vs_cbuf9_15.x) == 1.f) && (!isnan( utof(vs_cbuf9_15.x)))) && (!isnan(1.f))) ? true : false))
    {
		// 0  <=>  {ftou2((({utof2(u_7_phi_16) : 0.00} * 0.5f) * {utof(vs_cbuf9_14.x) : 0.00})) : 0}
        u_9_5 = ftou2((( utof2(u_7_phi_16) * 0.5f) * utof(vs_cbuf9_14.x)));
        u_9_phi_17 = u_9_5;
    }
	// 0  <=>  0u
    u_3_3 = 0u;
    u_3_phi_18 = u_3_3;
	// False  <=>  if((((({utof(vs_cbuf9_15.x) : 0.95} == 1.f) && (! isnan({utof(vs_cbuf9_15.x) : 0.95}))) && (! isnan(1.f))) ? true : false))
    if ((((( utof(vs_cbuf9_15.x) == 1.f) && (!isnan( utof(vs_cbuf9_15.x)))) && (!isnan(1.f))) ? true : false))
    {
		// 2147483648  <=>  {ftou2((({utof2(u_7_phi_16) : 0.00} * 0.5f) * {utof(vs_cbuf9_14.y) : -1.00})) : 2147483648}
        u_3_4 = ftou2((( utof2(u_7_phi_16) * 0.5f) * utof(vs_cbuf9_14.y)));
        u_3_phi_18 = u_3_4;
    }
	// 0  <=>  0u
    u_1_1 = 0u;
    u_1_phi_19 = u_1_1;
	// False  <=>  if((((({utof(vs_cbuf9_15.x) : 0.95} == 1.f) && (! isnan({utof(vs_cbuf9_15.x) : 0.95}))) && (! isnan(1.f))) ? true : false))
    if ((((( utof(vs_cbuf9_15.x) == 1.f) && (!isnan( utof(vs_cbuf9_15.x)))) && (!isnan(1.f))) ? true : false))
    {
		// 0  <=>  {ftou2((({utof2(u_7_phi_16) : 0.00} * 0.5f) * {utof(vs_cbuf9_14.z) : 0.00})) : 0}
        u_1_2 = ftou2((( utof2(u_7_phi_16) * 0.5f) * utof(vs_cbuf9_14.z)));
        u_1_phi_19 = u_1_2;
    }
	// True  <=>  ((! ((({utof(vs_cbuf9_15.x) : 0.95} == 1.f) && (! isnan({utof(vs_cbuf9_15.x) : 0.95}))) && (! isnan(1.f)))) ? true : false)
    b_2_0 = ((!((( utof(vs_cbuf9_15.x) == 1.f) && (!isnan( utof(vs_cbuf9_15.x)))) && (!isnan(1.f)))) ? true : false);
	// 0  <=>  {u_3_phi_18 : 0}
    u_2_1 = u_3_phi_18;
	// 0  <=>  {u_1_phi_19 : 0}
    u_7_6 = u_1_phi_19;
	// 0  <=>  {u_9_phi_17 : 0}
    u_10_4 = u_9_phi_17;
    u_2_phi_20 = u_2_1;
    u_7_phi_20 = u_7_6;
    u_10_phi_20 = u_10_4;
	// True  <=>  if({b_2_0 : True})
    if (b_2_0)
    {
		// -118.845  <=>  (log2(abs({utof(vs_cbuf9_15.x) : 0.95})) * {pf_1_1 : 1606.00})
        pf_2_6 = (log2(abs( utof(vs_cbuf9_15.x))) * pf_1_1);
		// 0.00  <=>  exp2({pf_2_6 : -118.845})
        f_11_8 = exp2(pf_2_6);
		// 19.49572  <=>  (0.f - ((1.0f / log2({utof(vs_cbuf9_15.x) : 0.95})) * 1.442695f))
        f_10_10 = (0.f - ((1.0f / log2( utof(vs_cbuf9_15.x))) * 1.442695f));
		// 19.49572  <=>  ((((1.0f / log2({utof(vs_cbuf9_15.x) : 0.95})) * 1.442695f) * {f_11_8 : 0.00}) + {f_10_10 : 19.49572})
        pf_2_8 = ((((1.0f / log2( utof(vs_cbuf9_15.x))) * 1.442695f) * f_11_8) + f_10_10);
		// 1586.504  <=>  ((0.f - {pf_2_8 : 19.49572}) + {pf_1_1 : 1606.00})
        pf_2_9 = ((0.f - pf_2_8) + pf_1_1);
		// 31730.08  <=>  ({pf_2_9 : 1586.504} * (1.0f / ((0.f - {utof(vs_cbuf9_15.x) : 0.95}) + 1.f)))
        pf_2_10 = (pf_2_9 * (1.0f / ((0.f - utof(vs_cbuf9_15.x)) + 1.f)));
		// 2147483648  <=>  {ftou2((({pf_2_10 : 31730.08} * {utof(vs_cbuf9_14.w) : 0.00}) * {utof(vs_cbuf9_14.y) : -1.00})) : 2147483648}
        u_2_2 = ftou2(((pf_2_10 * utof(vs_cbuf9_14.w)) * utof(vs_cbuf9_14.y)));
		// 0  <=>  {ftou2((({pf_2_10 : 31730.08} * {utof(vs_cbuf9_14.w) : 0.00}) * {utof(vs_cbuf9_14.z) : 0.00})) : 0}
        u_7_7 = ftou2(((pf_2_10 * utof(vs_cbuf9_14.w)) * utof(vs_cbuf9_14.z)));
		// 0  <=>  {ftou2((({pf_2_10 : 31730.08} * {utof(vs_cbuf9_14.w) : 0.00}) * {utof(vs_cbuf9_14.x) : 0.00})) : 0}
        u_10_5 = ftou2(((pf_2_10 * utof(vs_cbuf9_14.w)) * utof(vs_cbuf9_14.x)));
        u_2_phi_20 = u_2_2;
        u_7_phi_20 = u_7_7;
        u_10_phi_20 = u_10_5;
    }
	// True  <=>  ((! ((({utof(vs_cbuf9_15.x) : 0.95} == 1.f) && (! isnan({utof(vs_cbuf9_15.x) : 0.95}))) && (! isnan(1.f)))) ? true : false)
    b_1_21 = ((!((( utof(vs_cbuf9_15.x) == 1.f) && (!isnan( utof(vs_cbuf9_15.x)))) && (!isnan(1.f)))) ? true : false);
	// 1154007040  <=>  {u_8_2 : 1154007040}
    u_1_3 = u_8_2;
    u_1_phi_21 = u_1_3;
	// True  <=>  if({b_1_21 : True})
    if (b_1_21)
    {
		// -118.845  <=>  (log2(abs({utof(vs_cbuf9_15.x) : 0.95})) * {pf_1_1 : 1606.00})
        pf_1_2 = (log2(abs( utof(vs_cbuf9_15.x))) * pf_1_1);
		// -20.00  <=>  (0.f - (1.0f / ((0.f - {utof(vs_cbuf9_15.x) : 0.95}) + 1.f)))
        f_12_1 = (0.f - (1.0f / ((0.f - utof(vs_cbuf9_15.x)) + 1.f)));
		// 20.00  <=>  ((exp2({pf_1_2 : -118.845}) * {f_12_1 : -20.00}) + (1.0f / ((0.f - {utof(vs_cbuf9_15.x) : 0.95}) + 1.f)))
        pf_1_3 = ((exp2(pf_1_2) * f_12_1) + (1.0f / ((0.f - utof(vs_cbuf9_15.x)) + 1.f)));
		// 1101004798  <=>  {ftou2(pf_1_3) : 1101004798}
        u_1_4 = ftou2(pf_1_3);
        u_1_phi_21 = u_1_4;
    }
	// 121.1511  <=>  (clamp((min(0.f, {uni_attr6.x : 0.17155}) + (0.f - 0.f)), 0.0, 1.0) + {uni_attr5.x : 121.1511})
    pf_4_0 = (clamp((min(0.f, uni_attr6.x) + (0.f - 0.f)), 0.0, 1.0) + uni_attr5.x);
	// 1300234212  <=>  {ftou2(float(int({u_5_1 : 268435008}))) : 1300234212}
    u_1_5 = ftou2(float(int(u_5_1)));
	// 1153998848  <=>  {ftou2(pf_0_1) : 1153998848}
    u_2_3 = ftou2(pf_0_1);
    u_1_phi_22 = u_1_5;
    u_2_phi_22 = u_2_3;
	// True  <=>  if(((((0.f < {utof(vs_cbuf9_12.x) : 360.00}) && (! isnan(0.f))) && (! isnan({utof(vs_cbuf9_12.x) : 360.00}))) ? true : false))
    if (((((0.f < utof(vs_cbuf9_12.x)) && (!isnan(0.f))) && (!isnan( utof(vs_cbuf9_12.x)))) ? true : false))
    {
		// 4.629884  <=>  (((({uni_attr6.x : 0.17155} * {utof(vs_cbuf9_13.y) : 1.00}) * {utof(vs_cbuf9_12.x) : 360.00}) + {pf_0_1 : 1605.00}) * (1.0f / {utof(vs_cbuf9_12.x) : 360.00}))
        pf_0_3 = ((((uni_attr6.x * utof(vs_cbuf9_13.y)) * utof(vs_cbuf9_12.x)) + pf_0_1) * (1.0f / utof(vs_cbuf9_12.x)));
		// 1083451394  <=>  {ftou2(pf_0_3) : 1083451394}
        u_1_6 = ftou2(pf_0_3);
		// 1059143696  <=>  {ftou2(({pf_0_3 : 4.629884} + (0.f - floor({pf_0_3 : 4.629884})))) : 1059143696}
        u_2_4 = ftou2((pf_0_3 + (0.f - floor(pf_0_3))));
        u_1_phi_22 = u_1_6;
        u_2_phi_22 = u_2_4;
    }
	// False  <=>  ((! (((0.f < {utof(vs_cbuf9_12.x) : 360.00}) && (! isnan(0.f))) && (! isnan({utof(vs_cbuf9_12.x) : 360.00})))) ? true : false)
    b_0_8 = ((!(((0.f < utof(vs_cbuf9_12.x)) && (!isnan(0.f))) && (!isnan( utof(vs_cbuf9_12.x))))) ? true : false);
	// 1059143696  <=>  {u_2_phi_22 : 1059143696}
    u_3_7 = u_2_phi_22;
    u_3_phi_23 = u_3_7;
	// False  <=>  if({b_0_8 : False})
    if (b_0_8)
    {
		// 1040928772  <=>  {ftou2(({utof2(u_2_phi_22) : 0.6298838} * (1.0f / {utof2(u_1_phi_22) : 4.629884}))) : 1040928772}
        u_3_8 = ftou2(( utof2(u_2_phi_22) * (1.0f / utof2(u_1_phi_22))));
        u_3_phi_23 = u_3_8;
    }
	// 0.00  <=>  (((((({utof2(u_1_phi_21) : 20.00} * {uni_attr4.y : 0.00}) + {utof2(u_2_phi_20) : -0.00}) * {uni_attr5.w : 1.15048}) + {uni_attr3.y : 0.00}) * {utof(vs_cbuf10_4.y) : 0.00}) + ((((({utof2(u_1_phi_21) : 20.00} * {uni_attr4.x : 0.00}) + {utof2(u_10_phi_20) : 0.00}) * {uni_attr5.w : 1.15048}) + {uni_attr3.x : 0.00}) * {utof(vs_cbuf10_4.x) : 0.9027278}))
    pf_0_7 = (((((( utof2(u_1_phi_21) * uni_attr4.y) + utof2(u_2_phi_20)) * uni_attr5.w) + uni_attr3.y) * utof(vs_cbuf10_4.y)) + ((((( utof2(u_1_phi_21) * uni_attr4.x) + utof2(u_10_phi_20)) * uni_attr5.w) + uni_attr3.x) * utof(vs_cbuf10_4.x)));
	// 0.00  <=>  (((((({utof2(u_1_phi_21) : 20.00} * {uni_attr4.y : 0.00}) + {utof2(u_2_phi_20) : -0.00}) * {uni_attr5.w : 1.15048}) + {uni_attr3.y : 0.00}) * {utof(vs_cbuf10_5.y) : 0.9027278}) + ((((({utof2(u_1_phi_21) : 20.00} * {uni_attr4.x : 0.00}) + {utof2(u_10_phi_20) : 0.00}) * {uni_attr5.w : 1.15048}) + {uni_attr3.x : 0.00}) * {utof(vs_cbuf10_5.x) : 0.00}))
    pf_5_2 = (((((( utof2(u_1_phi_21) * uni_attr4.y) + utof2(u_2_phi_20)) * uni_attr5.w) + uni_attr3.y) * utof(vs_cbuf10_5.y)) + ((((( utof2(u_1_phi_21) * uni_attr4.x) + utof2(u_10_phi_20)) * uni_attr5.w) + uni_attr3.x) * utof(vs_cbuf10_5.x)));
	// 0.00  <=>  (((((({utof2(u_1_phi_21) : 20.00} * {uni_attr4.y : 0.00}) + {utof2(u_2_phi_20) : -0.00}) * {uni_attr5.w : 1.15048}) + {uni_attr3.y : 0.00}) * {utof(vs_cbuf10_6.y) : 0.00}) + ((((({utof2(u_1_phi_21) : 20.00} * {uni_attr4.x : 0.00}) + {utof2(u_10_phi_20) : 0.00}) * {uni_attr5.w : 1.15048}) + {uni_attr3.x : 0.00}) * {utof(vs_cbuf10_6.x) : 0.00}))
    pf_1_7 = (((((( utof2(u_1_phi_21) * uni_attr4.y) + utof2(u_2_phi_20)) * uni_attr5.w) + uni_attr3.y) * utof(vs_cbuf10_6.y)) + ((((( utof2(u_1_phi_21) * uni_attr4.x) + utof2(u_10_phi_20)) * uni_attr5.w) + uni_attr3.x) * utof(vs_cbuf10_6.x)));
	// 0.00  <=>  (((((({utof2(u_1_phi_21) : 20.00} * {uni_attr4.z : 0.00}) + {utof2(u_7_phi_20) : 0.00}) * {uni_attr5.w : 1.15048}) + {uni_attr3.z : 0.00}) * {utof(vs_cbuf10_6.z) : 0.9027278}) + {pf_1_7 : 0.00})
    pf_1_8 = (((((( utof2(u_1_phi_21) * uni_attr4.z) + utof2(u_7_phi_20)) * uni_attr5.w) + uni_attr3.z) * utof(vs_cbuf10_6.z)) + pf_1_7);
	// 538.25  <=>  ((((((({utof2(u_1_phi_21) : 20.00} * {uni_attr4.z : 0.00}) + {utof2(u_7_phi_20) : 0.00}) * {uni_attr5.w : 1.15048}) + {uni_attr3.z : 0.00}) * {utof(vs_cbuf10_4.z) : 0.00}) + {pf_0_7 : 0.00}) + {utof(vs_cbuf10_4.w) : 538.25})
    pf_0_9 = ((((((( utof2(u_1_phi_21) * uni_attr4.z) + utof2(u_7_phi_20)) * uni_attr5.w) + uni_attr3.z) * utof(vs_cbuf10_4.z)) + pf_0_7) + utof(vs_cbuf10_4.w));
	// 1550.75  <=>  ((((((({utof2(u_1_phi_21) : 20.00} * {uni_attr4.z : 0.00}) + {utof2(u_7_phi_20) : 0.00}) * {uni_attr5.w : 1.15048}) + {uni_attr3.z : 0.00}) * {utof(vs_cbuf10_5.z) : 0.00}) + {pf_5_2 : 0.00}) + {utof(vs_cbuf10_5.w) : 1550.75})
    pf_2_18 = ((((((( utof2(u_1_phi_21) * uni_attr4.z) + utof2(u_7_phi_20)) * uni_attr5.w) + uni_attr3.z) * utof(vs_cbuf10_5.z)) + pf_5_2) + utof(vs_cbuf10_5.w));
	// -250.9389  <=>  ((0.f - {pf_0_9 : 538.25}) + {utof(camera_wpos.x) : 287.3111})
    pf_3_4 = ((0.f - pf_0_9) + utof(camera_wpos.x));
	// 121.3937  <=>  ((0.f - {pf_2_18 : 1550.75}) + {utof(camera_wpos.y) : 1672.144})
    pf_6_0 = ((0.f - pf_2_18) + utof(camera_wpos.y));
	// -1  <=>  (~ (((1u & {vs_cbuf9_7.y : 0}) == 1u) ? 4294967295u : 0u))
    u_2_8 = (~(((1u & ftou2(vs_cbuf9_7.y)) == 1u) ? 4294967295u : 0u));
	// -1  <=>  (~ (((({uni_attr6.x : 0.17155} > 0.5f) && (! isnan({uni_attr6.x : 0.17155}))) && (! isnan(0.5f))) ? 4294967295u : 0u))
    u_5_4 = (~((((uni_attr6.x > 0.5f) && (!isnan(uni_attr6.x))) && (!isnan(0.5f))) ? 4294967295u : 0u));
	// 454.9194  <=>  ((0.f - ({pf_1_8 : 0.00} + {utof(vs_cbuf10_6.w) : 941.75})) + {utof(camera_wpos.z) : 1396.669})
    pf_7_0 = ((0.f - (pf_1_8 + utof(vs_cbuf10_6.w))) + utof(camera_wpos.z));
	// -1  <=>  (~ (((2u & {vs_cbuf9_7.y : 0}) == 2u) ? 4294967295u : 0u))
    u_2_11 = (~(((2u & ftou2(vs_cbuf9_7.y)) == 2u) ? 4294967295u : 0u));
	// -1  <=>  (~ (((({uni_attr6.y : 0.40601} > 0.5f) && (! isnan({uni_attr6.y : 0.40601}))) && (! isnan(0.5f))) ? 4294967295u : 0u))
    u_4_6 = (~((((uni_attr6.y > 0.5f) && (!isnan(uni_attr6.y))) && (!isnan(0.5f))) ? 4294967295u : 0u));
	// 284658.40  <=>  (({pf_7_0 : 454.9194} * {pf_7_0 : 454.9194}) + (({pf_6_0 : 121.3937} * {pf_6_0 : 121.3937}) + ({pf_3_4 : -250.9389} * {pf_3_4 : -250.9389})))
    pf_5_6 = ((pf_7_0 * pf_7_0) + ((pf_6_0 * pf_6_0) + (pf_3_4 * pf_3_4)));
	// 0.0999999  <=>  (({utof(vs_cbuf9_142.x) : 1.01} + (0.f - {utof(vs_cbuf9_141.x) : 1.00})) * (1.0f / ({utof(vs_cbuf9_142.w) : 0.10} + (0.f - {utof(vs_cbuf9_141.w) : 0.00}))))
    pf_5_8 = (( utof(vs_cbuf9_142.x) + (0.f - utof(vs_cbuf9_141.x))) * (1.0f / ( utof(vs_cbuf9_142.w) + (0.f - utof(vs_cbuf9_141.w)))));
	// 0.0999999  <=>  (({utof(vs_cbuf9_143.x) : 1.04} + (0.f - {utof(vs_cbuf9_142.x) : 1.01})) * (1.0f / ({utof(vs_cbuf9_143.w) : 0.40} + (0.f - {utof(vs_cbuf9_142.w) : 0.10}))))
    pf_11_1 = (( utof(vs_cbuf9_143.x) + (0.f - utof(vs_cbuf9_142.x))) * (1.0f / ( utof(vs_cbuf9_143.w) + (0.f - utof(vs_cbuf9_142.w)))));
	// 0.0180996  <=>  (({utof(vs_cbuf9_142.y) : 1.00181} + (0.f - {utof(vs_cbuf9_141.y) : 1.00})) * (1.0f / ({utof(vs_cbuf9_142.w) : 0.10} + (0.f - {utof(vs_cbuf9_141.w) : 0.00}))))
    pf_8_2 = (( utof(vs_cbuf9_142.y) + (0.f - utof(vs_cbuf9_141.y))) * (1.0f / ( utof(vs_cbuf9_142.w) + (0.f - utof(vs_cbuf9_141.w)))));
	// 0.0999999  <=>  (({utof(vs_cbuf9_142.z) : 1.01} + (0.f - {utof(vs_cbuf9_141.z) : 1.00})) * (1.0f / ({utof(vs_cbuf9_142.w) : 0.10} + (0.f - {utof(vs_cbuf9_141.w) : 0.00}))))
    pf_9_1 = (( utof(vs_cbuf9_142.z) + (0.f - utof(vs_cbuf9_141.z))) * (1.0f / ( utof(vs_cbuf9_142.w) + (0.f - utof(vs_cbuf9_141.w)))));
	// 0.0206335  <=>  (({utof(vs_cbuf9_143.y) : 1.008} + (0.f - {utof(vs_cbuf9_142.y) : 1.00181})) * (1.0f / ({utof(vs_cbuf9_143.w) : 0.40} + (0.f - {utof(vs_cbuf9_142.w) : 0.10}))))
    pf_10_1 = (( utof(vs_cbuf9_143.y) + (0.f - utof(vs_cbuf9_142.y))) * (1.0f / ( utof(vs_cbuf9_143.w) + (0.f - utof(vs_cbuf9_142.w)))));
	// 0.0999999  <=>  (({utof(vs_cbuf9_143.z) : 1.04} + (0.f - {utof(vs_cbuf9_142.z) : 1.01})) * (1.0f / ({utof(vs_cbuf9_143.w) : 0.40} + (0.f - {utof(vs_cbuf9_142.w) : 0.10}))))
    pf_12_1 = (( utof(vs_cbuf9_143.z) + (0.f - utof(vs_cbuf9_142.z))) * (1.0f / ( utof(vs_cbuf9_143.w) + (0.f - utof(vs_cbuf9_142.w)))));
	// 0.2275276  <=>  ({pf_6_0 : 121.3937} * inversesqrt({pf_5_6 : 284658.40}))
    pf_6_1 = (pf_6_0 * inversesqrt(pf_5_6));
	// 0.8526533  <=>  ({pf_7_0 : 454.9194} * inversesqrt({pf_5_6 : 284658.40}))
    pf_7_1 = (pf_7_0 * inversesqrt(pf_5_6));
	// 0.0199997  <=>  (((0.f - {utof(vs_cbuf9_143.y) : 1.008}) + {utof(vs_cbuf9_144.y) : 1.01}) * (1.0f / ((0.f - {utof(vs_cbuf9_143.w) : 0.40}) + {utof(vs_cbuf9_144.w) : 0.50})))
    pf_13_1 = (((0.f - utof(vs_cbuf9_143.y)) + utof(vs_cbuf9_144.y)) * (1.0f / ((0.f - utof(vs_cbuf9_143.w)) + utof(vs_cbuf9_144.w))));
	// -0.0999999  <=>  (({utof(vs_cbuf9_145.z) : 1.04} + (0.f - {utof(vs_cbuf9_144.z) : 1.05})) * (1.0f / ({utof(vs_cbuf9_145.w) : 0.60} + (0.f - {utof(vs_cbuf9_144.w) : 0.50}))))
    pf_15_2 = (( utof(vs_cbuf9_145.z) + (0.f - utof(vs_cbuf9_144.z))) * (1.0f / ( utof(vs_cbuf9_145.w) + (0.f - utof(vs_cbuf9_144.w)))));
	// 0.0999999  <=>  (((0.f - {utof(vs_cbuf9_143.x) : 1.04}) + {utof(vs_cbuf9_144.x) : 1.05}) * (1.0f / ((0.f - {utof(vs_cbuf9_143.w) : 0.40}) + {utof(vs_cbuf9_144.w) : 0.50})))
    pf_16_1 = (((0.f - utof(vs_cbuf9_143.x)) + utof(vs_cbuf9_144.x)) * (1.0f / ((0.f - utof(vs_cbuf9_143.w)) + utof(vs_cbuf9_144.w))));
	// 0.0999999  <=>  (((0.f - {utof(vs_cbuf9_143.z) : 1.04}) + {utof(vs_cbuf9_144.z) : 1.05}) * (1.0f / ((0.f - {utof(vs_cbuf9_143.w) : 0.40}) + {utof(vs_cbuf9_144.w) : 0.50})))
    pf_14_2 = (((0.f - utof(vs_cbuf9_143.z)) + utof(vs_cbuf9_144.z)) * (1.0f / ((0.f - utof(vs_cbuf9_143.w)) + utof(vs_cbuf9_144.w))));
	// -0.0218999  <=>  (({utof(vs_cbuf9_145.y) : 1.00781} + (0.f - {utof(vs_cbuf9_144.y) : 1.01})) * (1.0f / ({utof(vs_cbuf9_145.w) : 0.60} + (0.f - {utof(vs_cbuf9_144.w) : 0.50}))))
    pf_17_1 = (( utof(vs_cbuf9_145.y) + (0.f - utof(vs_cbuf9_144.y))) * (1.0f / ( utof(vs_cbuf9_145.w) + (0.f - utof(vs_cbuf9_144.w)))));
	// 0.8736611  <=>  (({pf_7_1 : 0.8526533} * {utof(vs_cbuf8_28.z) : 0.8242117}) + (({pf_6_1 : 0.2275276} * {utof(vs_cbuf8_28.y) : 0.5585706}) + (({pf_3_4 : -250.9389} * inversesqrt({pf_5_6 : 284658.40})) * {utof(vs_cbuf8_28.x) : -0.0931343})))
    pf_18_2 = ((pf_7_1 * utof(vs_cbuf8_28.z)) + ((pf_6_1 * utof(vs_cbuf8_28.y)) + ((pf_3_4 * inversesqrt(pf_5_6)) * utof(vs_cbuf8_28.x))));
	// -0.0195332  <=>  (((0.f - {utof(vs_cbuf9_145.y) : 1.00781}) + {utof(vs_cbuf9_146.y) : 1.00195}) * (1.0f / ((0.f - {utof(vs_cbuf9_145.w) : 0.60}) + {utof(vs_cbuf9_146.w) : 0.90})))
    pf_19_2 = (((0.f - utof(vs_cbuf9_145.y)) + utof(vs_cbuf9_146.y)) * (1.0f / ((0.f - utof(vs_cbuf9_145.w)) + utof(vs_cbuf9_146.w))));
	// -0.0999999  <=>  (({utof(vs_cbuf9_145.x) : 1.04} + (0.f - {utof(vs_cbuf9_144.x) : 1.05})) * (1.0f / ({utof(vs_cbuf9_145.w) : 0.60} + (0.f - {utof(vs_cbuf9_144.w) : 0.50}))))
    pf_20_2 = (( utof(vs_cbuf9_145.x) + (0.f - utof(vs_cbuf9_144.x))) * (1.0f / ( utof(vs_cbuf9_145.w) + (0.f - utof(vs_cbuf9_144.w)))));
	// -0.0999999  <=>  (({utof(vs_cbuf9_147.x) : 1.00} + (0.f - {utof(vs_cbuf9_146.x) : 1.01})) * (1.0f / ({utof(vs_cbuf9_147.w) : 1.00} + (0.f - {utof(vs_cbuf9_146.w) : 0.90}))))
    pf_21_1 = (( utof(vs_cbuf9_147.x) + (0.f - utof(vs_cbuf9_146.x))) * (1.0f / ( utof(vs_cbuf9_147.w) + (0.f - utof(vs_cbuf9_146.w)))));
	// 0.00  <=>  clamp((({pf_18_2 : 0.8736611} + -0.9f) * 10.010009f), 0.0, 1.0)
    f_5_22 = clamp(((pf_18_2 + -0.9f) * 10.010009f), 0.0, 1.0);
	// -0.0999999  <=>  (((0.f - {utof(vs_cbuf9_145.x) : 1.04}) + {utof(vs_cbuf9_146.x) : 1.01}) * (1.0f / ((0.f - {utof(vs_cbuf9_145.w) : 0.60}) + {utof(vs_cbuf9_146.w) : 0.90})))
    pf_22_1 = (((0.f - utof(vs_cbuf9_145.x)) + utof(vs_cbuf9_146.x)) * (1.0f / ((0.f - utof(vs_cbuf9_145.w)) + utof(vs_cbuf9_146.w))));
	// -0.0999999  <=>  (((0.f - {utof(vs_cbuf9_145.z) : 1.04}) + {utof(vs_cbuf9_146.z) : 1.01}) * (1.0f / ((0.f - {utof(vs_cbuf9_145.w) : 0.60}) + {utof(vs_cbuf9_146.w) : 0.90})))
    pf_24_1 = (((0.f - utof(vs_cbuf9_145.z)) + utof(vs_cbuf9_146.z)) * (1.0f / ((0.f - utof(vs_cbuf9_145.w)) + utof(vs_cbuf9_146.w))));
	// 1.062988  <=>  (({pf_5_8 : 0.0999999} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_141.w) : 0.00}))) + {utof(vs_cbuf9_141.x) : 1.00})
    pf_5_9 = ((pf_5_8 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_141.w)))) + utof(vs_cbuf9_141.x));
	// 3.00  <=>  (({f_5_22 : 0.00} * -2.f) + 3.f)
    pf_23_1 = ((f_5_22 * -2.f) + 3.f);
	// 0.00  <=>  ({f_5_22 : 0.00} * {f_5_22 : 0.00})
    pf_26_0 = (f_5_22 * f_5_22);
	// -0.0195003  <=>  (({utof(vs_cbuf9_147.y) : 1.00} + (0.f - {utof(vs_cbuf9_146.y) : 1.00195})) * (1.0f / ({utof(vs_cbuf9_147.w) : 1.00} + (0.f - {utof(vs_cbuf9_146.w) : 0.90}))))
    pf_18_6 = (( utof(vs_cbuf9_147.y) + (0.f - utof(vs_cbuf9_146.y))) * (1.0f / ( utof(vs_cbuf9_147.w) + (0.f - utof(vs_cbuf9_146.w)))));
	// 1.062988  <=>  (({pf_12_1 : 0.0999999} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_142.w) : 0.10}))) + {utof(vs_cbuf9_142.z) : 1.01})
    pf_12_2 = ((pf_12_1 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_142.w)))) + utof(vs_cbuf9_142.z));
	// 0.4703335  <=>  (0.f - ({pf_3_4 : -250.9389} * inversesqrt({pf_5_6 : 284658.40})))
    f_5_25 = (0.f - (pf_3_4 * inversesqrt(pf_5_6)));
	// -0.0999999  <=>  (({utof(vs_cbuf9_147.z) : 1.00} + (0.f - {utof(vs_cbuf9_146.z) : 1.01})) * (1.0f / ({utof(vs_cbuf9_147.w) : 1.00} + (0.f - {utof(vs_cbuf9_146.w) : 0.90}))))
    pf_26_1 = (( utof(vs_cbuf9_147.z) + (0.f - utof(vs_cbuf9_146.z))) * (1.0f / ( utof(vs_cbuf9_147.w) + (0.f - utof(vs_cbuf9_146.w)))));
	// 0.331043  <=>  ((0.f - {pf_6_1 : 0.2275276}) + {utof(vs_cbuf8_28.y) : 0.5585706})
    pf_30_0 = ((0.f - pf_6_1) + utof(vs_cbuf8_28.y));
	// -0.4703335  <=>  ((({pf_23_1 : 3.00} * {pf_26_0 : 0.00}) * ({f_5_25 : 0.4703335} + {utof(vs_cbuf8_28.x) : -0.0931343})) + ({pf_3_4 : -250.9389} * inversesqrt({pf_5_6 : 284658.40})))
    pf_3_6 = (((pf_23_1 * pf_26_0) * (f_5_25 + utof(vs_cbuf8_28.x))) + (pf_3_4 * inversesqrt(pf_5_6)));
	// 0.2275276  <=>  ((({pf_23_1 : 3.00} * {pf_26_0 : 0.00}) * {pf_30_0 : 0.331043}) + {pf_6_1 : 0.2275276})
    pf_6_2 = (((pf_23_1 * pf_26_0) * pf_30_0) + pf_6_1);
	// 0.8526533  <=>  ((({pf_23_1 : 3.00} * {pf_26_0 : 0.00}) * ((0.f - {pf_7_1 : 0.8526533}) + {utof(vs_cbuf8_28.z) : 0.8242117})) + {pf_7_1 : 0.8526533})
    pf_7_2 = (((pf_23_1 * pf_26_0) * ((0.f - pf_7_1) + utof(vs_cbuf8_28.z))) + pf_7_1);
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_141.w) : 0.00}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_141.w) : 0.00}))) ? 1065353216u : 0u)) : 1.00}
    f_6_27 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_141.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_141.w)))) ? 1065353216u : 0u));
	// 0.00  <=>  (({f_6_27 : 1.00} * (0.f - {utof(vs_cbuf9_141.y) : 1.00})) + {utof(vs_cbuf9_141.y) : 1.00})
    pf_25_1 = ((f_6_27 * (0.f - utof(vs_cbuf9_141.y))) + utof(vs_cbuf9_141.y));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_141.w) : 0.00}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_141.w) : 0.00}))) ? 1065353216u : 0u)) : 1.00}
    f_6_28 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_141.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_141.w)))) ? 1065353216u : 0u));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_141.w) : 0.00}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_141.w) : 0.00}))) ? 1065353216u : 0u)) : 1.00}
    f_4_28 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_141.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_141.w)))) ? 1065353216u : 0u));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_142.w) : 0.10}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_142.w) : 0.10}))) ? 1065353216u : 0u)) : 1.00}
    f_5_32 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_142.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_142.w)))) ? 1065353216u : 0u));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_141.w) : 0.00}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_141.w) : 0.00}))) ? 1065353216u : 0u)) : 1.00}
    f_6_29 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_141.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_141.w)))) ? 1065353216u : 0u));
	// 1.00  <=>  inversesqrt((({pf_7_2 : 0.8526533} * {pf_7_2 : 0.8526533}) + (({pf_6_2 : 0.2275276} * {pf_6_2 : 0.2275276}) + ({pf_3_6 : -0.4703335} * {pf_3_6 : -0.4703335}))))
    f_4_29 = inversesqrt(((pf_7_2 * pf_7_2) + ((pf_6_2 * pf_6_2) + (pf_3_6 * pf_3_6))));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_141.w) : 0.00}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_141.w) : 0.00}))) ? 1065353216u : 0u)) : 1.00}
    f_7_13 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_141.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_141.w)))) ? 1065353216u : 0u));
	// 1056964608  <=>  {ftou2(v.vertex.x) : 1056964608}
    u_2_14 = ftou2(v.vertex.x);
    u_2_phi_24 = u_2_14;
	// False  <=>  if(((! (({u_2_8 : 4294967295} | {u_5_4 : 4294967295}) != 0u)) ? true : false))
    if (((!((u_2_8 | u_5_4) != 0u)) ? true : false))
    {
		// 1056964608  <=>  {ftou2(((0.f - {v.vertex.x : 0.50}) + 1.f)) : 1056964608}
        u_2_15 = ftou2(((0.f - v.vertex.x) + 1.f));
        u_2_phi_24 = u_2_15;
    }
	// 0.00  <=>  (((({pf_8_2 : 0.0180996} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_141.w) : 0.00}))) + {utof(vs_cbuf9_141.y) : 1.00}) * (({f_6_29 : 1.00} * (0.f - {f_5_32 : 1.00})) + {f_4_28 : 1.00})) + {pf_25_1 : 0.00})
    pf_8_4 = ((((pf_8_2 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_141.w)))) + utof(vs_cbuf9_141.y)) * ((f_6_29 * (0.f - f_5_32)) + f_4_28)) + pf_25_1);
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_142.w) : 0.10}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_142.w) : 0.10}))) ? 1065353216u : 0u)) : 1.00}
    f_2_12 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_142.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_142.w)))) ? 1065353216u : 0u));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_143.w) : 0.40}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_143.w) : 0.40}))) ? 1065353216u : 0u)) : 1.00}
    f_5_37 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_143.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_143.w)))) ? 1065353216u : 0u));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_142.w) : 0.10}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_142.w) : 0.10}))) ? 1065353216u : 0u)) : 1.00}
    f_6_33 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_142.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_142.w)))) ? 1065353216u : 0u));
	// 0.00  <=>  (((({pf_9_1 : 0.0999999} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_141.w) : 0.00}))) + {utof(vs_cbuf9_141.z) : 1.00}) * (({f_6_29 : 1.00} * (0.f - {f_5_32 : 1.00})) + {f_4_28 : 1.00})) + (({f_6_28 : 1.00} * (0.f - {utof(vs_cbuf9_141.z) : 1.00})) + {utof(vs_cbuf9_141.z) : 1.00}))
    pf_9_3 = ((((pf_9_1 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_141.w)))) + utof(vs_cbuf9_141.z)) * ((f_6_29 * (0.f - f_5_32)) + f_4_28)) + ((f_6_28 * (0.f - utof(vs_cbuf9_141.z))) + utof(vs_cbuf9_141.z)));
	// 1.037012  <=>  (({pf_22_1 : -0.0999999} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_145.w) : 0.60}))) + {utof(vs_cbuf9_145.x) : 1.04})
    pf_22_2 = ((pf_22_1 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_145.w)))) + utof(vs_cbuf9_145.x));
	// 172  <=>  (({u_6_3 : 0} << 4u) + 172u)
    u_5_7 = ((u_6_3 << 4u) + 172u);
	// 0.00  <=>  (((({pf_11_1 : 0.0999999} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_142.w) : 0.10}))) + {utof(vs_cbuf9_142.x) : 1.01}) * (({f_6_33 : 1.00} * (0.f - {f_5_37 : 1.00})) + {f_2_12 : 1.00})) + (({pf_5_9 : 1.062988} * (({f_6_29 : 1.00} * (0.f - {f_5_32 : 1.00})) + {f_4_28 : 1.00})) + (({f_7_13 : 1.00} * (0.f - {utof(vs_cbuf9_141.x) : 1.00})) + {utof(vs_cbuf9_141.x) : 1.00})))
    pf_5_11 = ((((pf_11_1 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_142.w)))) + utof(vs_cbuf9_142.x)) * ((f_6_33 * (0.f - f_5_37)) + f_2_12)) + ((pf_5_9 * ((f_6_29 * (0.f - f_5_32)) + f_4_28)) + ((f_7_13 * (0.f - utof(vs_cbuf9_141.x))) + utof(vs_cbuf9_141.x))));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_143.w) : 0.40}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_143.w) : 0.40}))) ? 1065353216u : 0u)) : 1.00}
    f_2_16 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_143.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_143.w)))) ? 1065353216u : 0u));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_144.w) : 0.50}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_144.w) : 0.50}))) ? 1065353216u : 0u)) : 1.00}
    f_5_41 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_144.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_144.w)))) ? 1065353216u : 0u));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_143.w) : 0.40}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_143.w) : 0.40}))) ? 1065353216u : 0u)) : 1.00}
    f_6_34 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_143.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_143.w)))) ? 1065353216u : 0u));
	// 0.00  <=>  (((({pf_10_1 : 0.0206335} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_142.w) : 0.10}))) + {utof(vs_cbuf9_142.y) : 1.00181}) * (({f_6_33 : 1.00} * (0.f - {f_5_37 : 1.00})) + {f_2_12 : 1.00})) + {pf_8_4 : 0.00})
    pf_8_5 = ((((pf_10_1 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_142.w)))) + utof(vs_cbuf9_142.y)) * ((f_6_33 * (0.f - f_5_37)) + f_2_12)) + pf_8_4);
	// 0.2275276  <=>  (abs(({pf_6_2 : 0.2275276} * {f_4_29 : 1.00})) + (0.f - 0.f))
    pf_10_3 = (abs((pf_6_2 * f_4_29)) + (0.f - 0.f));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_144.w) : 0.50}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_144.w) : 0.50}))) ? 1065353216u : 0u)) : 1.00}
    f_2_18 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_144.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_144.w)))) ? 1065353216u : 0u));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_145.w) : 0.60}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_145.w) : 0.60}))) ? 1065353216u : 0u)) : 1.00}
    f_5_44 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_145.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_145.w)))) ? 1065353216u : 0u));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_144.w) : 0.50}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_144.w) : 0.50}))) ? 1065353216u : 0u)) : 1.00}
    f_6_35 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_144.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_144.w)))) ? 1065353216u : 0u));
	// 0.00  <=>  (((({pf_16_1 : 0.0999999} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_143.w) : 0.40}))) + {utof(vs_cbuf9_143.x) : 1.04}) * (({f_6_34 : 1.00} * (0.f - {f_5_41 : 1.00})) + {f_2_16 : 1.00})) + {pf_5_11 : 0.00})
    pf_5_12 = ((((pf_16_1 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_143.w)))) + utof(vs_cbuf9_143.x)) * ((f_6_34 * (0.f - f_5_41)) + f_2_16)) + pf_5_11);
	// -0.2275276  <=>  (0.f - abs(({pf_6_2 : 0.2275276} * {f_4_29 : 1.00})))
    f_2_20 = (0.f - abs((pf_6_2 * f_4_29)));
	// 0.00  <=>  (((({pf_13_1 : 0.0199997} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_143.w) : 0.40}))) + {utof(vs_cbuf9_143.y) : 1.008}) * (({f_6_34 : 1.00} * (0.f - {f_5_41 : 1.00})) + {f_2_16 : 1.00})) + {pf_8_5 : 0.00})
    pf_8_6 = ((((pf_13_1 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_143.w)))) + utof(vs_cbuf9_143.y)) * ((f_6_34 * (0.f - f_5_41)) + f_2_16)) + pf_8_5);
	// 0.0699996  <=>  (({pf_10_3 : 0.2275276} * -0.0187293f) + 0.074261f)
    pf_13_3 = ((pf_10_3 * -0.0187293f) + 0.074261f);
	// 0.00  <=>  (((({pf_14_2 : 0.0999999} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_143.w) : 0.40}))) + {utof(vs_cbuf9_143.z) : 1.04}) * (({f_6_34 : 1.00} * (0.f - {f_5_41 : 1.00})) + {f_2_16 : 1.00})) + (({pf_12_2 : 1.062988} * (({f_6_33 : 1.00} * (0.f - {f_5_37 : 1.00})) + {f_2_12 : 1.00})) + {pf_9_3 : 0.00}))
    pf_9_5 = ((((pf_14_2 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_143.w)))) + utof(vs_cbuf9_143.z)) * ((f_6_34 * (0.f - f_5_41)) + f_2_16)) + ((pf_12_2 * ((f_6_33 * (0.f - f_5_37)) + f_2_12)) + pf_9_3));
	// 1.007226  <=>  (({pf_19_2 : -0.0195332} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_145.w) : 0.60}))) + {utof(vs_cbuf9_145.y) : 1.00781})
    pf_11_4 = ((pf_19_2 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_145.w)))) + utof(vs_cbuf9_145.y));
	// 0.00  <=>  (((({pf_20_2 : -0.0999999} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_144.w) : 0.50}))) + {utof(vs_cbuf9_144.x) : 1.05}) * (({f_6_35 : 1.00} * (0.f - {f_5_44 : 1.00})) + {f_2_18 : 1.00})) + {pf_5_12 : 0.00})
    pf_5_13 = ((((pf_20_2 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_144.w)))) + utof(vs_cbuf9_144.x)) * ((f_6_35 * (0.f - f_5_44)) + f_2_18)) + pf_5_12);
	// 0.00  <=>  (((({pf_17_1 : -0.0218999} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_144.w) : 0.50}))) + {utof(vs_cbuf9_144.y) : 1.01}) * (({f_6_35 : 1.00} * (0.f - {f_5_44 : 1.00})) + {f_2_18 : 1.00})) + {pf_8_6 : 0.00})
    pf_8_7 = ((((pf_17_1 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_144.w)))) + utof(vs_cbuf9_144.y)) * ((f_6_35 * (0.f - f_5_44)) + f_2_18)) + pf_8_6);
	// 0.00  <=>  (((({pf_15_2 : -0.0999999} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_144.w) : 0.50}))) + {utof(vs_cbuf9_144.z) : 1.05}) * (({f_6_35 : 1.00} * (0.f - {f_5_44 : 1.00})) + {f_2_18 : 1.00})) + {pf_9_5 : 0.00})
    pf_9_6 = ((((pf_15_2 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_144.w)))) + utof(vs_cbuf9_144.z)) * ((f_6_35 * (0.f - f_5_44)) + f_2_18)) + pf_9_5);
	// 1.037012  <=>  (({pf_24_1 : -0.0999999} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_145.w) : 0.60}))) + {utof(vs_cbuf9_145.z) : 1.04})
    pf_12_4 = ((pf_24_1 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_145.w)))) + utof(vs_cbuf9_145.z));
	// False  <=>  if(((! (({u_2_8 : 4294967295} | {u_5_4 : 4294967295}) != 0u)) ? true : false))
    if (((!((u_2_8 | u_5_4) != 0u)) ? true : false))
    {
    }
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_145.w) : 0.60}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_145.w) : 0.60}))) ? 1065353216u : 0u)) : 1.00}
    f_8_3 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_145.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_145.w)))) ? 1065353216u : 0u));
	// 0.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_146.w) : 0.90}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_146.w) : 0.90}))) ? 1065353216u : 0u)) : 0.00}
    f_9_2 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_146.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_146.w)))) ? 1065353216u : 0u));
	// 1.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_145.w) : 0.60}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_145.w) : 0.60}))) ? 1065353216u : 0u)) : 1.00}
    f_10_25 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_145.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_145.w)))) ? 1065353216u : 0u));
	// False  <=>  (((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) < 0.f) && (! isnan(({pf_6_2 : 0.2275276} * {f_4_29 : 1.00})))) && (! isnan(0.f)))
    b_2_11 = ((((pf_6_2 * f_4_29) < 0.f) && (!isnan((pf_6_2 * f_4_29)))) && (!isnan(0.f)));
	// 1056964608  <=>  {ftou2(v.vertex.y) : 1056964608}
    u_8_5 = ftou2(v.vertex.y);
    u_8_phi_26 = u_8_5;
	// False  <=>  if(((! (({u_2_11 : 4294967295} | {u_4_6 : 4294967295}) != 0u)) ? true : false))
    if (((!((u_2_11 | u_4_6) != 0u)) ? true : false))
    {
		// 1056964608  <=>  {ftou2(((0.f - {v.vertex.y : 0.50}) + 1.f)) : 1056964608}
        u_8_6 = ftou2(((0.f - v.vertex.y) + 1.f));
        u_8_phi_26 = u_8_6;
    }
	// 1.037012  <=>  (({pf_21_1 : -0.0999999} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_146.w) : 0.90}))) + {utof(vs_cbuf9_146.x) : 1.01})
    pf_14_5 = ((pf_21_1 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_146.w)))) + utof(vs_cbuf9_146.x));
	// 0.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_146.w) : 0.90}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_146.w) : 0.90}))) ? 1065353216u : 0u)) : 0.00}
    f_3_56 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_146.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_146.w)))) ? 1065353216u : 0u));
	// 0.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_147.w) : 1.00}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_147.w) : 1.00}))) ? 1065353216u : 0u)) : 0.00}
    f_8_4 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_147.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_147.w)))) ? 1065353216u : 0u));
	// 0.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_146.w) : 0.90}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_146.w) : 0.90}))) ? 1065353216u : 0u)) : 0.00}
    f_9_4 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_146.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_146.w)))) ? 1065353216u : 0u));
	// 0.00  <=>  (((((({pf_13_3 : 0.0699996} * {pf_10_3 : 0.2275276}) + -0.2121144f) * {pf_10_3 : 0.2275276}) + 1.5707288f) * sqrt(({f_2_20 : -0.2275276} + 1.f))) * {utof2(({b_2_11 : False} ? 1065353216u : 0u)) : 0.00})
    pf_13_6 = ((((((pf_13_3 * pf_10_3) + -0.2121144f) * pf_10_3) + 1.5707288f) * sqrt((f_2_20 + 1.f))) * utof2((b_2_11 ? 1065353216u : 0u)));
	// 1.007226  <=>  (((({pf_18_6 : -0.0195003} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_146.w) : 0.90}))) + {utof(vs_cbuf9_146.y) : 1.00195}) * (({f_9_4 : 0.00} * (0.f - {f_8_4 : 0.00})) + {f_3_56 : 0.00})) + (({pf_11_4 : 1.007226} * (({f_10_25 : 1.00} * (0.f - {f_9_2 : 0.00})) + {f_8_3 : 1.00})) + {pf_8_7 : 0.00}))
    pf_8_9 = ((((pf_18_6 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_146.w)))) + utof(vs_cbuf9_146.y)) * ((f_9_4 * (0.f - f_8_4)) + f_3_56)) + ((pf_11_4 * ((f_10_25 * (0.f - f_9_2)) + f_8_3)) + pf_8_7));
	// True  <=>  (((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) != 0.f) || isnan(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}))) || isnan(0.f))
    b_1_26 = ((((pf_3_6 * f_4_29) != 0.f) || isnan((pf_3_6 * f_4_29))) || isnan(0.f));
	// 1.037012  <=>  (((({pf_26_1 : -0.0999999} * ({utof2(u_3_phi_23) : 0.6298838} + (0.f - {utof(vs_cbuf9_146.w) : 0.90}))) + {utof(vs_cbuf9_146.z) : 1.01}) * (({f_9_4 : 0.00} * (0.f - {f_8_4 : 0.00})) + {f_3_56 : 0.00})) + (({pf_12_4 : 1.037012} * (({f_10_25 : 1.00} * (0.f - {f_9_2 : 0.00})) + {f_8_3 : 1.00})) + {pf_9_6 : 0.00}))
    pf_9_8 = ((((pf_26_1 * ( utof2(u_3_phi_23) + (0.f - utof(vs_cbuf9_146.w)))) + utof(vs_cbuf9_146.z)) * ((f_9_4 * (0.f - f_8_4)) + f_3_56)) + ((pf_12_4 * ((f_10_25 * (0.f - f_9_2)) + f_8_3)) + pf_9_6));
	// 0.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_147.w) : 1.00}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_147.w) : 1.00}))) ? 1065353216u : 0u)) : 0.00}
    f_6_38 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_147.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_147.w)))) ? 1065353216u : 0u));
	// 1.037012  <=>  (({f_6_38 : 0.00} * {utof(vs_cbuf9_147.x) : 1.00}) + (({pf_14_5 : 1.037012} * (({f_9_4 : 0.00} * (0.f - {f_8_4 : 0.00})) + {f_3_56 : 0.00})) + (({pf_22_2 : 1.037012} * (({f_10_25 : 1.00} * (0.f - {f_9_2 : 0.00})) + {f_8_3 : 1.00})) + {pf_5_13 : 0.00})))
    pf_5_16 = ((f_6_38 * utof(vs_cbuf9_147.x)) + ((pf_14_5 * ((f_9_4 * (0.f - f_8_4)) + f_3_56)) + ((pf_22_2 * ((f_10_25 * (0.f - f_9_2)) + f_8_3)) + pf_5_13)));
	// 0.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_147.w) : 1.00}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_147.w) : 1.00}))) ? 1065353216u : 0u)) : 0.00}
    f_6_39 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_147.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_147.w)))) ? 1065353216u : 0u));
	// 0.00  <=>  {utof2((((({utof2(u_3_phi_23) : 0.6298838} >= {utof(vs_cbuf9_147.w) : 1.00}) && (! isnan({utof2(u_3_phi_23) : 0.6298838}))) && (! isnan({utof(vs_cbuf9_147.w) : 1.00}))) ? 1065353216u : 0u)) : 0.00}
    f_6_40 = utof2((((( utof2(u_3_phi_23) >= utof(vs_cbuf9_147.w)) && (!isnan( utof2(u_3_phi_23)))) && (!isnan( utof(vs_cbuf9_147.w)))) ? 1065353216u : 0u));
	// 1.341287  <=>  (({utof2(({b_2_11 : False} ? 1065353216u : 0u)) : 0.00} * 3.1415927f) + (({pf_13_6 : 0.00} * -2.f) + ((((({pf_13_3 : 0.0699996} * {pf_10_3 : 0.2275276}) + -0.2121144f) * {pf_10_3 : 0.2275276}) + 1.5707288f) * sqrt(({f_2_20 : -0.2275276} + 1.f)))))
    pf_10_7 = (( utof2((b_2_11 ? 1065353216u : 0u)) * 3.1415927f) + ((pf_13_6 * -2.f) + (((((pf_13_3 * pf_10_3) + -0.2121144f) * pf_10_3) + 1.5707288f) * sqrt((f_2_20 + 1.f)))));
	// 1.00  <=>  ({utof(vs_cbuf9_113.x) : 1.00} * {utof(vs_cbuf10_0.w) : 1.00})
    o.fs_attr0.w = ( utof(vs_cbuf9_113.x) * utof(vs_cbuf10_0.w));
	// 0.10  <=>  ({utof(vs_cbuf9_129.x) : 0.10} * {utof(vs_cbuf10_1.w) : 1.00})
    o.fs_attr1.w = ( utof(vs_cbuf9_129.x) * utof(vs_cbuf10_1.w));
	// 1.10134  <=>  ({utof(vs_cbuf16[({u_5_7 : 172} >> 4)][(({u_5_7 : 172} >> 2) % 4)]) : 0.9297899} + {uni_attr6.x : 0.17155})
    pf_9_10 = ( utof(vs_cbuf16[(u_5_7 >> 4)][((u_5_7 >> 2) % 4)]) + uni_attr6.x);
	// 1036831949  <=>  {ftou2(({utof(vs_cbuf9_129.x) : 0.10} * {utof(vs_cbuf10_1.w) : 1.00})) : 1036831949}
    u_4_8 = ftou2(( utof(vs_cbuf9_129.x) * utof(vs_cbuf10_1.w)));
    u_4_phi_27 = u_4_8;
	// True  <=>  if(({b_1_26 : True} ? true : false))
    if ((b_1_26 ? true : false))
    {
		// 0  <=>  ((((abs(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00})) == 0.f) && (! isnan(abs(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}))))) && (! isnan(0.f))) ? 4294967295u : 0u)
        u_5_8 = ((((abs((pf_3_6 * f_4_29)) == 0.f) && (!isnan(abs((pf_3_6 * f_4_29))))) && (!isnan(0.f))) ? 4294967295u : 0u);
		// False  <=>  ((((abs(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00})) == 0.f) && (! isnan(abs(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}))))) && (! isnan(0.f))) && (((abs(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00})) == 0.f) && (! isnan(abs(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}))))) && (! isnan(0.f))))
        b_5_1 = ((((abs((pf_3_6 * f_4_29)) == 0.f) && (!isnan(abs((pf_3_6 * f_4_29))))) && (!isnan(0.f))) && (((abs((pf_7_2 * f_4_29)) == 0.f) && (!isnan(abs((pf_7_2 * f_4_29))))) && (!isnan(0.f))));
		// False  <=>  ({b_5_1 : False} ? true : false)
        b_6_0 = (b_5_1 ? true : false);
		// True  <=>  ((({u_2_8 : 4294967295} | {u_5_4 : 4294967295}) != 0u) ? true : false)
        b_7_0 = (((u_2_8 | u_5_4) != 0u) ? true : false);
        b_7_phi_28 = b_7_0;
		// False  <=>  if({b_6_0 : False})
        if (b_6_0)
        {
			// True  <=>  ((((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) < 0.f) && (! isnan(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00})))) && (! isnan(0.f))) ? true : false)
            b_7_1 = (((((pf_3_6 * f_4_29) < 0.f) && (!isnan((pf_3_6 * f_4_29)))) && (!isnan(0.f))) ? true : false);
            b_7_phi_28 = b_7_1;
        }
		// 1065353216  <=>  {ftou2(({utof(vs_cbuf9_113.x) : 1.00} * {utof(vs_cbuf10_0.w) : 1.00})) : 1065353216}
        u_5_9 = ftou2(( utof(vs_cbuf9_113.x) * utof(vs_cbuf10_0.w)));
        u_5_phi_29 = u_5_9;
		// False  <=>  if(({b_5_1 : False} ? true : false))
        if ((b_5_1 ? true : false))
        {
			// 1078530011  <=>  ({b_7_phi_28 : True} ? 1078530011u : 0u)
            u_5_10 = (b_7_phi_28 ? 1078530011u : 0u);
            u_5_phi_29 = u_5_10;
        }
		// 1036831949  <=>  {ftou2(({utof(vs_cbuf9_129.x) : 0.10} * {utof(vs_cbuf10_1.w) : 1.00})) : 1036831949}
        u_1_12 = ftou2(( utof(vs_cbuf9_129.x) * utof(vs_cbuf10_1.w)));
        u_1_phi_30 = u_1_12;
		// False  <=>  if(({b_5_1 : False} ? true : false))
        if ((b_5_1 ? true : false))
        {
			// 3212836864  <=>  {ftou2(((0.f - {utof2(u_5_phi_29) : 1.00}) + (0.f - 0.f))) : 3212836864}
            u_1_13 = ftou2(((0.f - utof2(u_5_phi_29)) + (0.f - 0.f)));
            u_1_phi_30 = u_1_13;
        }
		// False  <=>  (((((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) < 0.f) && (! isnan(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00})))) && (! isnan(0.f))) && {b_5_1 : False}) ? true : false)
        b_6_4 = ((((((pf_7_2 * f_4_29) < 0.f) && (!isnan((pf_7_2 * f_4_29)))) && (!isnan(0.f))) && b_5_1) ? true : false);
		// 1065353216  <=>  {u_5_phi_29 : 1065353216}
        u_7_14 = u_5_phi_29;
        u_7_phi_31 = u_7_14;
		// False  <=>  if({b_6_4 : False})
        if (b_6_4)
        {
			// 1036831949  <=>  {u_1_phi_30 : 1036831949}
            u_7_15 = u_1_phi_30;
            u_7_phi_31 = u_7_15;
        }
		// False  <=>  ((((abs(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00})) == 0.f) && (! isnan(abs(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}))))) && (! isnan(0.f))) && ((! ({u_5_8 : 0} == 0u)) || (! ({u_5_8 : 0} == 0u))))
        b_0_17 = ((((abs((pf_7_2 * f_4_29)) == 0.f) && (!isnan(abs((pf_7_2 * f_4_29))))) && (!isnan(0.f))) && ((!(u_5_8 == 0u)) || (!(u_5_8 == 0u))));
		// 1065353216  <=>  {u_7_phi_31 : 1065353216}
        u_5_11 = u_7_phi_31;
        u_5_phi_32 = u_5_11;
		// True  <=>  if(((! {b_0_17 : False}) ? true : false))
        if (((!b_0_17) ? true : false))
        {
			// 0  <=>  ((((abs(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00})) == {utof2(0x7f800000) : ∞}) && (! isnan(abs(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}))))) && (! isnan({utof2(0x7f800000) : ∞}))) ? 4294967295u : 0u)
            u_8_7 = ((((abs((pf_3_6 * f_4_29)) == utof2(0x7f800000)) && (!isnan(abs((pf_3_6 * f_4_29))))) && (!isnan( utof2(0x7f800000)))) ? 4294967295u : 0u);
			// False  <=>  ((((abs(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00})) == {utof2(0x7f800000) : ∞}) && (! isnan(abs(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}))))) && (! isnan({utof2(0x7f800000) : ∞}))) && (((abs(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00})) == {utof2(0x7f800000) : ∞}) && (! isnan(abs(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}))))) && (! isnan({utof2(0x7f800000) : ∞}))))
            b_4_2 = ((((abs((pf_3_6 * f_4_29)) == utof2(0x7f800000)) && (!isnan(abs((pf_3_6 * f_4_29))))) && (!isnan( utof2(0x7f800000)))) && (((abs((pf_7_2 * f_4_29)) == utof2(0x7f800000)) && (!isnan(abs((pf_7_2 * f_4_29))))) && (!isnan( utof2(0x7f800000)))));
			// False  <=>  ({b_5_1 : False} ? true : false)
            b_7_2 = (b_5_1 ? true : false);
            b_7_phi_33 = b_7_2;
			// False  <=>  if(({b_4_2 : False} ? true : false))
            if ((b_4_2 ? true : false))
            {
				// True  <=>  ((((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) < 0.f) && (! isnan(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00})))) && (! isnan(0.f))) ? true : false)
                b_7_3 = (((((pf_3_6 * f_4_29) < 0.f) && (!isnan((pf_3_6 * f_4_29)))) && (!isnan(0.f))) ? true : false);
                b_7_phi_33 = b_7_3;
            }
			// 1065353216  <=>  {u_7_phi_31 : 1065353216}
            u_8_8 = u_7_phi_31;
            u_8_phi_34 = u_8_8;
			// False  <=>  if(({b_4_2 : False} ? true : false))
            if ((b_4_2 ? true : false))
            {
				// 1061752795  <=>  1061752795u
                u_8_9 = 1061752795u;
                u_8_phi_34 = u_8_9;
            }
			// 1065353216  <=>  {u_8_phi_34 : 1065353216}
            u_9_7 = u_8_phi_34;
            u_9_phi_35 = u_9_7;
			// False  <=>  if(({b_4_2 : False} ? true : false))
            if ((b_4_2 ? true : false))
            {
				// 1065353216  <=>  ({b_7_phi_33 : False} ? 1075235812u : {u_8_phi_34 : 1065353216})
                u_9_8 = (b_7_phi_33 ? 1075235812u : u_8_phi_34);
                u_9_phi_35 = u_9_8;
            }
			// 1036831949  <=>  {u_1_phi_30 : 1036831949}
            u_8_10 = u_1_phi_30;
            u_8_phi_36 = u_8_10;
			// False  <=>  if(({b_4_2 : False} ? true : false))
            if ((b_4_2 ? true : false))
            {
				// 3212836864  <=>  {ftou2(((0.f - {utof2(u_9_phi_35) : 1.00}) + (0.f - 0.f))) : 3212836864}
                u_8_11 = ftou2(((0.f - utof2(u_9_phi_35)) + (0.f - 0.f)));
                u_8_phi_36 = u_8_11;
            }
			// False  <=>  (((((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) < 0.f) && (! isnan(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00})))) && (! isnan(0.f))) && {b_4_2 : False}) ? true : false)
            b_4_3 = ((((((pf_7_2 * f_4_29) < 0.f) && (!isnan((pf_7_2 * f_4_29)))) && (!isnan(0.f))) && b_4_2) ? true : false);
			// 1065353216  <=>  {u_9_phi_35 : 1065353216}
            u_1_14 = u_9_phi_35;
            u_1_phi_37 = u_1_14;
			// False  <=>  if({b_4_3 : False})
            if (b_4_3)
            {
				// 1036831949  <=>  {u_8_phi_36 : 1036831949}
                u_1_15 = u_8_phi_36;
                u_1_phi_37 = u_1_15;
            }
			// False  <=>  ((((abs(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00})) == {utof2(0x7f800000) : ∞}) && (! isnan(abs(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}))))) && (! isnan({utof2(0x7f800000) : ∞}))) && ((! ({u_8_7 : 0} == 0u)) || (! ({u_8_7 : 0} == 0u))))
            b_0_20 = ((((abs((pf_7_2 * f_4_29)) == utof2(0x7f800000)) && (!isnan(abs((pf_7_2 * f_4_29))))) && (!isnan( utof2(0x7f800000)))) && ((!(u_8_7 == 0u)) || (!(u_8_7 == 0u))));
			// 1065353216  <=>  {u_1_phi_37 : 1065353216}
            u_8_12 = u_1_phi_37;
            u_8_phi_38 = u_8_12;
			// True  <=>  if(((! {b_0_20 : False}) ? true : false))
            if (((!b_0_20) ? true : false))
            {
				// 0.8526533  <=>  max(abs(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00})), abs(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00})))
                f_2_34 = max(abs((pf_3_6 * f_4_29)), abs((pf_7_2 * f_4_29)));
				// False  <=>  ((({f_2_34 : 0.8526533} >= 16.f) && (! isnan({f_2_34 : 0.8526533}))) && (! isnan(16.f)))
                b_1_34 = (((f_2_34 >= 16.f) && (!isnan(f_2_34))) && (!isnan(16.f)));
				// 1062881148  <=>  {ftou2(f_2_34) : 1062881148}
                u_11_1 = ftou2(f_2_34);
                u_11_phi_39 = u_11_1;
				// False  <=>  if(({b_1_34 : False} ? true : false))
                if ((b_1_34 ? true : false))
                {
					// 1029326716  <=>  {ftou2(({f_2_34 : 0.8526533} * 0.0625f)) : 1029326716}
                    u_12_1 = ftou2((f_2_34 * 0.0625f));
					// 1029326716  <=>  {u_12_1 : 1029326716}
                    u_11_2 = u_12_1;
                    u_11_phi_39 = u_11_2;
                }
				// 1055969165  <=>  {ftou2(min(abs(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00})), abs(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00})))) : 1055969165}
                u_9_10 = ftou2(min(abs((pf_3_6 * f_4_29)), abs((pf_7_2 * f_4_29))));
                u_9_phi_40 = u_9_10;
				// False  <=>  if(({b_1_34 : False} ? true : false))
                if ((b_1_34 ? true : false))
                {
					// 1022414733  <=>  {ftou2((min(abs(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00})), abs(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}))) * 0.0625f)) : 1022414733}
                    u_12_2 = ftou2((min(abs((pf_3_6 * f_4_29)), abs((pf_7_2 * f_4_29))) * 0.0625f));
					// 1022414733  <=>  {u_12_2 : 1022414733}
                    u_9_11 = u_12_2;
                    u_9_phi_40 = u_9_11;
                }
				// 0.4703335  <=>  abs(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}))
                f_4_31 = abs((pf_3_6 * f_4_29));
				// 0.5516117  <=>  ((1.0f / {utof2(u_11_phi_39) : 0.8526533}) * {utof2(u_9_phi_40) : 0.4703335})
                pf_13_12 = ((1.0f / utof2(u_11_phi_39)) * utof2(u_9_phi_40));
				// 11.63966  <=>  (({pf_13_12 : 0.5516117} * {pf_13_12 : 0.5516117}) + 11.335388f)
                pf_15_5 = ((pf_13_12 * pf_13_12) + 11.335388f);
				// -5.925396  <=>  ((({pf_13_12 : 0.5516117} * {pf_13_12 : 0.5516117}) * -0.82336295f) + (0.f - 5.674867f))
                pf_16_5 = (((pf_13_12 * pf_13_12) * -0.82336295f) + (0.f - 5.674867f));
				// 32.38413  <=>  ((({pf_13_12 : 0.5516117} * {pf_13_12 : 0.5516117}) * {pf_15_5 : 11.63966}) + 28.842468f)
                pf_15_6 = (((pf_13_12 * pf_13_12) * pf_15_5) + 28.842468f);
				// -8.368507  <=>  ((({pf_13_12 : 0.5516117} * {pf_13_12 : 0.5516117}) * {pf_16_5 : -5.925396}) + -6.565555f)
                pf_16_6 = (((pf_13_12 * pf_13_12) * pf_16_5) + -6.565555f);
				// 29.55037  <=>  ((({pf_13_12 : 0.5516117} * {pf_13_12 : 0.5516117}) * {pf_15_6 : 32.38413}) + 19.69667f)
                pf_15_7 = (((pf_13_12 * pf_13_12) * pf_15_6) + 19.69667f);
				// -2.546331  <=>  (({pf_13_12 : 0.5516117} * {pf_13_12 : 0.5516117}) * {pf_16_6 : -8.368507})
                pf_14_8 = ((pf_13_12 * pf_13_12) * pf_16_6);
				// 0.5040797  <=>  ((({pf_13_12 : 0.5516117} * {pf_14_8 : -2.546331}) * (1.0f / {pf_15_7 : 29.55037})) + {pf_13_12 : 0.5516117})
                pf_13_13 = (((pf_13_12 * pf_14_8) * (1.0f / pf_15_7)) + pf_13_12);
				// True  <=>  ((((abs(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00})) > {f_4_31 : 0.4703335}) && (! isnan(abs(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}))))) && (! isnan({f_4_31 : 0.4703335}))) ? true : false)
                b_3_8 = ((((abs((pf_7_2 * f_4_29)) > f_4_31) && (!isnan(abs((pf_7_2 * f_4_29))))) && (!isnan(f_4_31))) ? true : false);
				// 1057033054  <=>  {ftou2(pf_13_13) : 1057033054}
                u_10_9 = ftou2(pf_13_13);
                u_10_phi_41 = u_10_9;
				// True  <=>  if({b_3_8 : True})
                if (b_3_8)
                {
					// 1065912876  <=>  {ftou2(((0.f - {pf_13_13 : 0.5040797}) + 1.5707964f)) : 1065912876}
                    u_10_10 = ftou2(((0.f - pf_13_13) + 1.5707964f));
                    u_10_phi_41 = u_10_10;
                }
				// 1065912876  <=>  {u_10_phi_41 : 1065912876}
                u_9_13 = u_10_phi_41;
                u_9_phi_42 = u_9_13;
				// True  <=>  if(((((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) < 0.f) && (! isnan(({pf_3_6 : -0.4703335} * {f_4_29 : 1.00})))) && (! isnan(0.f))) ? true : false))
                if ((((((pf_3_6 * f_4_29) < 0.f) && (!isnan((pf_3_6 * f_4_29)))) && (!isnan(0.f))) ? true : false))
                {
					// 1074055877  <=>  {ftou2(((0.f - {utof2(u_10_phi_41) : 1.066717}) + 3.1415927f)) : 1074055877}
                    u_9_14 = ftou2(((0.f - utof2(u_10_phi_41)) + 3.1415927f));
                    u_9_phi_42 = u_9_14;
                }
				// 1074055877  <=>  {u_9_phi_42 : 1074055877}
                u_10_11 = u_9_phi_42;
                u_10_phi_43 = u_10_11;
				// False  <=>  if(((((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) < 0.f) && (! isnan(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00})))) && (! isnan(0.f))) ? true : false))
                if ((((((pf_7_2 * f_4_29) < 0.f) && (!isnan((pf_7_2 * f_4_29)))) && (!isnan(0.f))) ? true : false))
                {
					// 3221539525  <=>  {ftou2(((0.f - {utof2(u_9_phi_42) : 2.074876}) + (0.f - 0.f))) : 3221539525}
                    u_10_12 = ftou2(((0.f - utof2(u_9_phi_42)) + (0.f - 0.f)));
                    u_10_phi_43 = u_10_12;
                }
				// 1074055877  <=>  {u_10_phi_43 : 1074055877}
                u_8_13 = u_10_phi_43;
                u_8_phi_38 = u_8_13;
            }
			// 1074055877  <=>  {u_8_phi_38 : 1074055877}
            u_5_12 = u_8_phi_38;
            u_5_phi_32 = u_5_12;
        }
		// 1059656572  <=>  {ftou2(({utof2(u_5_phi_32) : 2.074876} * 0.31830987f)) : 1059656572}
        u_4_9 = ftou2(( utof2(u_5_phi_32) * 0.31830987f));
        u_4_phi_27 = u_4_9;
    }
	// 1059656572  <=>  {u_4_phi_27 : 1059656572}
    u_1_17 = u_4_phi_27;
    u_1_phi_44 = u_1_17;
	// False  <=>  if(((! {b_1_26 : True}) ? true : false))
    if (((!b_1_26) ? true : false))
    {
		// 1056964608  <=>  ((((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) <= 0.f) || isnan(({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}))) || isnan(0.f)) ? 3204448256u : 1056964608u)
        u_1_18 = (((((pf_7_2 * f_4_29) <= 0.f) || isnan((pf_7_2 * f_4_29))) || isnan(0.f)) ? 3204448256u : 1056964608u);
        u_1_phi_44 = u_1_18;
    }
	// 16  <=>  (isnan({utof(vs_cbuf9_78.z) : 16.00}) ? 0u : uint(clamp(trunc({utof(vs_cbuf9_78.z) : 16.00}), float(-2147483600.f), float(2147483600.f))))
    u_2_19 = (isnan( utof(vs_cbuf9_78.z)) ? 0u : uint(clamp(trunc( utof(vs_cbuf9_78.z)), float(-2147483600.f), float(2147483600.f))));
	// 16  <=>  (isnan({utof(vs_cbuf9_78.w) : 16.00}) ? 0u : uint(clamp(trunc({utof(vs_cbuf9_78.w) : 16.00}), float(-2147483600.f), float(2147483600.f))))
    u_1_20 = (isnan( utof(vs_cbuf9_78.w)) ? 0u : uint(clamp(trunc( utof(vs_cbuf9_78.w)), float(-2147483600.f), float(2147483600.f))));
	// -0.2075762  <=>  ((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * (0.f - {utof(view_proj[1].z) : -0.5550383})) + (0.f - (({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * (0.f - {utof(view_proj[1].x) : 0.0627182}))))
    pf_14_11 = (((pf_3_6 * f_4_29) * (0.f - utof(view_proj[1].z))) + (0.f - ((pf_7_2 * f_4_29) * (0.f - utof(view_proj[1].x)))));
	// 0.3302268  <=>  ((({utof2(u_1_phi_44) : 0.6604536} * 0.5f) + 1.f) + (0.f - floor((({utof2(u_1_phi_44) : 0.6604536} * 0.5f) + 1.f))))
    pf_13_19 = ((( utof2(u_1_phi_44) * 0.5f) + 1.f) + (0.f - floor((( utof2(u_1_phi_44) * 0.5f) + 1.f))));
	// False  <=>  (! (uint(bitfieldExtract(uint(uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(32u)))), int(0u), int(32u))) == 0))
    b_0_29 = (!(uint(bitfieldExtract(uint(uint(bitfieldExtract(uint(u_2_19), int(0u), int(32u)))), int(0u), int(32u))) == 0));
	// False  <=>  ((int(uint(bitfieldExtract(uint(uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(32u)))), int(0u), int(32u)))) < 0) || {b_0_29 : False})
    b_0_30 = ((int(uint(bitfieldExtract(uint(uint(bitfieldExtract(uint(u_2_19), int(0u), int(32u)))), int(0u), int(32u)))) < 0) || b_0_29);
	// 0.4315667  <=>  (({pf_9_10 : 1.10134} + {pf_13_19 : 0.3302268}) + (0.f - floor(({pf_9_10 : 1.10134} + {pf_13_19 : 0.3302268}))))
    pf_13_21 = ((pf_9_10 + pf_13_19) + (0.f - floor((pf_9_10 + pf_13_19))));
	// 6  <=>  int(clamp(floor((float(int({u_2_19 : 16})) * {pf_13_21 : 0.4315667})), float(-2147483600.f), float(2147483600.f)))
    u_10_13 = int(clamp(floor((float(int(u_2_19)) * pf_13_21)), float(-2147483600.f), float(2147483600.f)));
	// 21  <=>  (({u_2_19 : 16} + 4294967295u) + (isnan((float(int({u_2_19 : 16})) * {pf_13_21 : 0.4315667})) ? 0u : {u_10_13 : 6}))
    u_11_7 = ((u_2_19 + 4294967295u) + (isnan((float(int(u_2_19)) * pf_13_21)) ? 0u : u_10_13));
	// 0.0625  <=>  {utof2(({ftou2((1.0f / float({u_2_19 : 16}))) : 1031798784} + 4294967294u)) : 0.0625}
    f_4_33 = utof2(( ftou2((1.0f / float(u_2_19))) + 4294967294u));
	// 1  <=>  uint(clamp(trunc(({f_4_33 : 0.0625} * float({u_11_7 : 21}))), float(0.f), float(4294967300.f)))
    u_12_3 = uint(clamp(trunc((f_4_33 * float(u_11_7))), float(0.f), float(4294967300.f)));
	// 65536  <=>  bitfieldInsert(uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(16u))) * uint(bitfieldExtract(uint({u_12_3 : 1}), int(16u), int(16u))))), uint(bitfieldExtract(uint({u_12_3 : 1}), int(0u), int(16u))), int(16u), int(16u))
    u_14_3 = bitfieldInsert(uint((uint(bitfieldExtract(uint(u_2_19), int(0u), int(16u))) * uint(bitfieldExtract(uint(u_12_3), int(16u), int(16u))))), uint(bitfieldExtract(uint(u_12_3), int(0u), int(16u))), int(16u), int(16u));
	// 1  <=>  uint(bitfieldExtract(uint({u_14_3 : 65536}), int(16u), int(16u)))
    u_16_0 = uint(bitfieldExtract(uint(u_14_3), int(16u), int(16u)));
	// 16  <=>  ((uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(16u), int(16u))) * {u_16_0 : 1})) << 16u) + (({u_14_3 : 65536} << 16u) + uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(16u))) * uint(bitfieldExtract(uint({u_12_3 : 1}), int(0u), int(16u)))))))
    u_13_4 = ((uint((uint(bitfieldExtract(uint(u_2_19), int(16u), int(16u))) * u_16_0)) << 16u) + ((u_14_3 << 16u) + uint((uint(bitfieldExtract(uint(u_2_19), int(0u), int(16u))) * uint(bitfieldExtract(uint(u_12_3), int(0u), int(16u)))))));
	// 0.0625  <=>  {utof2(({ftou2((1.0f / float({u_2_19 : 16}))) : 1031798784} + 4294967294u)) : 0.0625}
    f_4_34 = utof2(( ftou2((1.0f / float(u_2_19))) + 4294967294u));
	// 0.00  <=>  trunc(({f_4_34 : 0.0625} * float(({u_11_7 : 21} + uint((int(0) - int({u_13_4 : 16})))))))
    f_2_63 = trunc((f_4_34 * float((u_11_7 + uint((int(0) - int(u_13_4)))))));
	// 0.0625  <=>  (1.0f / float(int({u_2_19 : 16})))
    f_2_65 = (1.0f / float(int(u_2_19)));
	// 1  <=>  uint(bitfieldExtract(uint(({u_12_3 : 1} + uint(clamp({f_2_63 : 0.00}, float(0.f), float(4294967300.f))))), int(0u), int(16u)))
    u_14_5 = uint(bitfieldExtract(uint((u_12_3 + uint(clamp(f_2_63, float(0.f), float(4294967300.f))))), int(0u), int(16u)));
	// 0  <=>  uint(bitfieldExtract(uint(({u_12_3 : 1} + uint(clamp({f_2_63 : 0.00}, float(0.f), float(4294967300.f))))), int(16u), int(16u)))
    u_15_5 = uint(bitfieldExtract(uint((u_12_3 + uint(clamp(f_2_63, float(0.f), float(4294967300.f))))), int(16u), int(16u)));
	// 1  <=>  uint(bitfieldExtract(uint(({u_12_3 : 1} + uint(clamp({f_2_63 : 0.00}, float(0.f), float(4294967300.f))))), int(0u), int(16u)))
    u_15_6 = uint(bitfieldExtract(uint((u_12_3 + uint(clamp(f_2_63, float(0.f), float(4294967300.f))))), int(0u), int(16u)));
	// 65536  <=>  bitfieldInsert(uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(16u))) * {u_15_5 : 0})), {u_15_6 : 1}, int(16u), int(16u))
    u_14_8 = bitfieldInsert(uint((uint(bitfieldExtract(uint(u_2_19), int(0u), int(16u))) * u_15_5)), u_15_6, int(16u), int(16u));
	// 1  <=>  uint(bitfieldExtract(uint({u_14_8 : 65536}), int(16u), int(16u)))
    u_16_1 = uint(bitfieldExtract(uint(u_14_8), int(16u), int(16u)));
	// 16  <=>  ((uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(16u), int(16u))) * {u_16_1 : 1})) << 16u) + (({u_14_8 : 65536} << 16u) + uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(16u))) * {u_14_5 : 1}))))
    u_13_11 = ((uint((uint(bitfieldExtract(uint(u_2_19), int(16u), int(16u))) * u_16_1)) << 16u) + ((u_14_8 << 16u) + uint((uint(bitfieldExtract(uint(u_2_19), int(0u), int(16u))) * u_14_5))));
	// 0  <=>  ((uint(({u_11_7 : 21} + uint((int(0) - int({u_13_11 : 16}))))) >= uint({u_2_19 : 16})) ? 4294967295u : 0u)
    u_13_14 = ((uint((u_11_7 + uint((int(0) - int(u_13_11))))) >= uint(u_2_19)) ? 4294967295u : 0u);
	// 4294967295  <=>  uint((int(0) - int(({u_12_3 : 1} + uint(clamp({f_2_63 : 0.00}, float(0.f), float(4294967300.f)))))))
    u_12_5 = uint((int(0) - int((u_12_3 + uint(clamp(f_2_63, float(0.f), float(4294967300.f)))))));
	// 4294967295  <=>  ({u_12_5 : 4294967295} + {u_13_14 : 0})
    u_12_6 = (u_12_5 + u_13_14);
	// 15.00  <=>  float(int(({u_1_20 : 16} + 4294967295u)))
    f_5_49 = float(int((u_1_20 + 4294967295u)));
	// 4294967280  <=>  bitfieldInsert(uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(16u))) * uint(bitfieldExtract(uint({u_12_6 : 4294967295}), int(16u), int(16u))))), uint(bitfieldExtract(uint({u_12_6 : 4294967295}), int(0u), int(16u))), int(16u), int(16u))
    u_12_8 = bitfieldInsert(uint((uint(bitfieldExtract(uint(u_2_19), int(0u), int(16u))) * uint(bitfieldExtract(uint(u_12_6), int(16u), int(16u))))), uint(bitfieldExtract(uint(u_12_6), int(0u), int(16u))), int(16u), int(16u));
	// 4294967280  <=>  ((uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(16u), int(16u))) * uint(bitfieldExtract(uint({u_12_8 : 4294967280}), int(16u), int(16u))))) << 16u) + (({u_12_8 : 4294967280} << 16u) + uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(16u))) * uint(bitfieldExtract(uint({u_12_6 : 4294967295}), int(0u), int(16u)))))))
    u_1_24 = ((uint((uint(bitfieldExtract(uint(u_2_19), int(16u), int(16u))) * uint(bitfieldExtract(uint(u_12_8), int(16u), int(16u))))) << 16u) + ((u_12_8 << 16u) + uint((uint(bitfieldExtract(uint(u_2_19), int(0u), int(16u))) * uint(bitfieldExtract(uint(u_12_6), int(0u), int(16u)))))));
	// 6  <=>  int(clamp(floor((({pf_10_7 : 1.341287} * 0.31830987f) * {f_5_49 : 15.00})), float(-2147483600.f), float(2147483600.f)))
    u_12_10 = int(clamp(floor(((pf_10_7 * 0.31830987f) * f_5_49)), float(-2147483600.f), float(2147483600.f)));
	// 6.00  <=>  float(int((isnan((({pf_10_7 : 1.341287} * 0.31830987f) * {f_5_49 : 15.00})) ? 0u : {u_12_10 : 6})))
    f_8_9 = float(int((isnan(((pf_10_7 * 0.31830987f) * f_5_49)) ? 0u : u_12_10)));
	// False  <=>  ((isnan((({pf_10_7 : 1.341287} * 0.31830987f) * {f_5_49 : 15.00})) ? 0u : {u_12_10 : 6}) == 0u)
    b_1_41 = ((isnan(((pf_10_7 * 0.31830987f) * f_5_49)) ? 0u : u_12_10) == 0u);
	// 0.4041748  <=>  ((({pf_10_7 : 1.341287} * 0.31830987f) * {f_5_49 : 15.00}) + (0.f - floor((({pf_10_7 : 1.341287} * 0.31830987f) * {f_5_49 : 15.00}))))
    pf_10_10 = (((pf_10_7 * 0.31830987f) * f_5_49) + (0.f - floor(((pf_10_7 * 0.31830987f) * f_5_49))));
	// 0  <=>  0u
    u_11_8 = 0u;
    u_11_phi_45 = u_11_8;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
        u_11_9 = ftou2((pf_9_10 * 6.2831855f));
        u_11_phi_45 = u_11_9;
    }
	// -1.10134  <=>  (({f_2_65 : 0.0625} * float(int(({b_0_30 : False} ? ({u_11_7 : 21} + {u_1_24 : 4294967280}) : 4294967295u)))) + ((0.f - {pf_9_10 : 1.10134}) + {f_2_65 : 0.0625}))
    pf_19_3 = ((f_2_65 * float(int((b_0_30 ? (u_11_7 + u_1_24) : 4294967295u)))) + ((0.f - pf_9_10) + f_2_65));
	// 0  <=>  {u_11_phi_45 : 0}
    u_0_1 = u_11_phi_45;
    u_0_phi_46 = u_0_1;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 0  <=>  {u_11_phi_45 : 0}
        u_0_2 = u_11_phi_45;
        u_0_phi_46 = u_0_2;
    }
	// 0.3090169  <=>  cos((({f_8_9 : 6.00} * (1.0f / {f_5_49 : 15.00})) * 3.1415927f))
    f_9_6 = cos(((f_8_9 * (1.0f / f_5_49)) * 3.1415927f));
	// -0.3090169  <=>  (0.f - {f_9_6 : 0.3090169})
    f_7_25 = (0.f - f_9_6);
	// 0.9045086  <=>  (({f_9_6 : 0.3090169} * {f_7_25 : -0.3090169}) + 1.f)
    pf_19_4 = ((f_9_6 * f_7_25) + 1.f);
	// 0.8040398  <=>  cos((({pf_19_3 : -1.10134} + (0.f - floor({pf_19_3 : -1.10134}))) * 6.2831855f))
    f_10_26 = cos(((pf_19_3 + (0.f - floor(pf_19_3))) * 6.2831855f));
	// -0.5945755  <=>  sin((({pf_19_3 : -1.10134} + (0.f - floor({pf_19_3 : -1.10134}))) * 6.2831855f))
    f_11_11 = sin(((pf_19_3 + (0.f - floor(pf_19_3))) * 6.2831855f));
	// 0.7646873  <=>  ({f_10_26 : 0.8040398} * sqrt({pf_19_4 : 0.9045086}))
    pf_19_5 = (f_10_26 * sqrt(pf_19_4));
	// -0.5654749  <=>  ({f_11_11 : -0.5945755} * sqrt({pf_19_4 : 0.9045086}))
    pf_20_5 = (f_11_11 * sqrt(pf_19_4));
	// 0.6802381  <=>  (({f_9_6 : 0.3090169} * {f_9_6 : 0.3090169}) + ({pf_19_5 : 0.7646873} * {pf_19_5 : 0.7646873}))
    pf_21_3 = ((f_9_6 * f_9_6) + (pf_19_5 * pf_19_5));
	// 0.9999999  <=>  (({pf_20_5 : -0.5654749} * {pf_20_5 : -0.5654749}) + {pf_21_3 : 0.6802381})
    pf_21_4 = ((pf_20_5 * pf_20_5) + pf_21_3);
	// 0.7646874  <=>  ({pf_19_5 : 0.7646873} * inversesqrt({pf_21_4 : 0.9999999}))
    pf_19_6 = (pf_19_5 * inversesqrt(pf_21_4));
	// 0.3090169  <=>  ({f_9_6 : 0.3090169} * inversesqrt({pf_21_4 : 0.9999999}))
    pf_22_3 = (f_9_6 * inversesqrt(pf_21_4));
	// -0.565475  <=>  ({pf_20_5 : -0.5654749} * inversesqrt({pf_21_4 : 0.9999999}))
    pf_20_6 = (pf_20_5 * inversesqrt(pf_21_4));
	// -0.4043915  <=>  ((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * (0.f - {utof(view_proj[1].x) : 0.0627182})) + (0.f - (({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * (0.f - {utof(view_proj[1].y) : 0.829457}))))
    pf_21_6 = (((pf_6_2 * f_4_29) * (0.f - utof(view_proj[1].x))) + (0.f - ((pf_3_6 * f_4_29) * (0.f - utof(view_proj[1].y)))));
	// 0.6802382  <=>  (({pf_22_3 : 0.3090169} * {pf_22_3 : 0.3090169}) + ({pf_19_6 : 0.7646874} * {pf_19_6 : 0.7646874}))
    pf_23_7 = ((pf_22_3 * pf_22_3) + (pf_19_6 * pf_19_6));
	// 0.9999999  <=>  inversesqrt((({pf_20_6 : -0.565475} * {pf_20_6 : -0.565475}) + {pf_23_7 : 0.6802382}))
    f_7_32 = inversesqrt(((pf_20_6 * pf_20_6) + pf_23_7));
	// -0.1262865  <=>  (0.f - (({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * (0.f - {utof(view_proj[1].z) : -0.5550383})))
    f_12_4 = (0.f - ((pf_6_2 * f_4_29) * (0.f - utof(view_proj[1].z))));
	// -0.8335257  <=>  ((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * (0.f - {utof(view_proj[1].y) : 0.829457})) + {f_12_4 : -0.1262865})
    pf_23_9 = (((pf_7_2 * f_4_29) * (0.f - utof(view_proj[1].y))) + f_12_4);
	// 0.7378531  <=>  (({pf_14_11 : -0.2075762} * {pf_14_11 : -0.2075762}) + ({pf_23_9 : -0.8335257} * {pf_23_9 : -0.8335257}))
    pf_24_4 = ((pf_14_11 * pf_14_11) + (pf_23_9 * pf_23_9));
	// 0.5654749  <=>  (0.f - ({pf_20_6 : -0.565475} * {f_7_32 : 0.9999999}))
    f_7_33 = (0.f - (pf_20_6 * f_7_32));
	// 0.5654749  <=>  ((0.f * ({pf_22_3 : 0.3090169} * {f_7_32 : 0.9999999})) + {f_7_33 : 0.5654749})
    pf_28_3 = ((0.f * (pf_22_3 * f_7_32)) + f_7_33);
	// 0.7646873  <=>  ((0.f - 0.f) + ({pf_19_6 : 0.7646874} * {f_7_32 : 0.9999999}))
    pf_29_2 = ((0.f - 0.f) + (pf_19_6 * f_7_32));
	// 1.053282  <=>  inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))
    f_7_35 = inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4));
	// 0.9045086  <=>  (({pf_29_2 : 0.7646873} * {pf_29_2 : 0.7646873}) + (({pf_28_3 : 0.5654749} * {pf_28_3 : 0.5654749}) + 0.f))
    pf_30_4 = ((pf_29_2 * pf_29_2) + ((pf_28_3 * pf_28_3) + 0.f));
	// 0.8779377  <=>  (0.f - ({pf_23_9 : -0.8335257} * {f_7_35 : 1.053282}))
    f_7_41 = (0.f - (pf_23_9 * f_7_35));
	// -0.0895083  <=>  ((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * (0.f - ({pf_21_6 : -0.4043915} * {f_7_35 : 1.053282}))) + (0.f - (({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * (0.f - ({pf_14_11 : -0.2075762} * {f_7_35 : 1.053282})))))
    pf_33_1 = (((pf_6_2 * f_4_29) * (0.f - (pf_21_6 * f_7_35))) + (0.f - ((pf_7_2 * f_4_29) * (0.f - (pf_14_11 * f_7_35)))));
	// 0.8779377  <=>  (0.f - ({pf_23_9 : -0.8335257} * {f_7_35 : 1.053282}))
    f_7_43 = (0.f - (pf_23_9 * f_7_35));
	// 0.9489095  <=>  ((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * {f_7_43 : 0.8779377}) + (0.f - (({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * (0.f - ({pf_21_6 : -0.4043915} * {f_7_35 : 1.053282})))))
    pf_34_1 = (((pf_7_2 * f_4_29) * f_7_43) + (0.f - ((pf_3_6 * f_4_29) * (0.f - (pf_21_6 * f_7_35)))));
	// 0.00  <=>  (({pf_20_6 : -0.565475} * {f_7_32 : 0.9999999}) * (0.f * (0.f - inversesqrt({pf_30_4 : 0.9045086}))))
    pf_37_0 = ((pf_20_6 * f_7_32) * (0.f * (0.f - inversesqrt(pf_30_4))));
	// -0.614839  <=>  (({pf_19_6 : 0.7646874} * {f_7_32 : 0.9999999}) * ({pf_29_2 : 0.7646873} * (0.f - inversesqrt({pf_30_4 : 0.9045086}))))
    pf_38_0 = ((pf_19_6 * f_7_32) * (pf_29_2 * (0.f - inversesqrt(pf_30_4))));
	// 7  <=>  ((isnan((({pf_10_7 : 1.341287} * 0.31830987f) * {f_5_49 : 15.00})) ? 0u : {u_12_10 : 6}) + 1u)
    u_17_0 = ((isnan(((pf_10_7 * 0.31830987f) * f_5_49)) ? 0u : u_12_10) + 1u);
	// -0.199755  <=>  (0.f - (({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * {f_7_41 : 0.8779377}))
    f_9_13 = (0.f - ((pf_6_2 * f_4_29) * f_7_41));
	// -0.302587  <=>  ((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * (0.f - ({pf_14_11 : -0.2075762} * {f_7_35 : 1.053282}))) + {f_9_13 : -0.199755})
    pf_36_1 = (((pf_3_6 * f_4_29) * (0.f - (pf_14_11 * f_7_35))) + f_9_13);
	// -0.2484618  <=>  ((({pf_22_3 : 0.3090169} * {f_7_32 : 0.9999999}) * ({pf_29_2 : 0.7646873} * (0.f - inversesqrt({pf_30_4 : 0.9045086})))) + (0.f - {pf_37_0 : 0.00}))
    pf_29_4 = (((pf_22_3 * f_7_32) * (pf_29_2 * (0.f - inversesqrt(pf_30_4)))) + (0.f - pf_37_0));
	// 0.614839  <=>  (0.f - {pf_38_0 : -0.614839})
    f_7_46 = (0.f - pf_38_0);
	// 0.9510565  <=>  ((({pf_20_6 : -0.565475} * {f_7_32 : 0.9999999}) * ({pf_28_3 : 0.5654749} * (0.f - inversesqrt({pf_30_4 : 0.9045086})))) + {f_7_46 : 0.614839})
    pf_28_5 = (((pf_20_6 * f_7_32) * (pf_28_3 * (0.f - inversesqrt(pf_30_4)))) + f_7_46);
	// 3206034970  <=>  {ftou2(({pf_28_3 : 0.5654749} * (0.f - inversesqrt({pf_30_4 : 0.9045086})))) : 3206034970}
    u_19_0 = ftou2((pf_28_3 * (0.f - inversesqrt(pf_30_4))));
    u_19_phi_47 = u_19_0;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 0  <=>  {ftou2(sin({utof2(u_0_phi_46) : 0.00})) : 0}
        u_19_1 = ftou2(sin( utof2(u_0_phi_46)));
        u_19_phi_47 = u_19_1;
    }
	// 0.1837339  <=>  (0.f - (({pf_22_3 : 0.3090169} * {f_7_32 : 0.9999999}) * ({pf_28_3 : 0.5654749} * (0.f - inversesqrt({pf_30_4 : 0.9045086})))))
    f_7_49 = (0.f - ((pf_22_3 * f_7_32) * (pf_28_3 * (0.f - inversesqrt(pf_30_4)))));
	// 0.1837339  <=>  ((({pf_19_6 : 0.7646874} * {f_7_32 : 0.9999999}) * (0.f * (0.f - inversesqrt({pf_30_4 : 0.9045086})))) + {f_7_49 : 0.1837339})
    pf_35_1 = (((pf_19_6 * f_7_32) * (0.f * (0.f - inversesqrt(pf_30_4)))) + f_7_49);
	// 7  <=>  ((int(({u_2_19 : 16} + ((int({u_2_19 : 16}) >> 31u) & 1u))) >> 1u) + 4294967295u)
    u_4_14 = ((int((u_2_19 + ((int(u_2_19) >> 31u) & 1u))) >> 1u) + 4294967295u);
	// 2147483648  <=>  {ftou2((0.f * (0.f - inversesqrt({pf_30_4 : 0.9045086})))) : 2147483648}
    u_21_0 = ftou2((0.f * (0.f - inversesqrt(pf_30_4))));
    u_21_phi_48 = u_21_0;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 0  <=>  0u
        u_21_1 = 0u;
        u_21_phi_48 = u_21_1;
    }
	// 1.00  <=>  inversesqrt((({pf_36_1 : -0.302587} * {pf_36_1 : -0.302587}) + (({pf_34_1 : 0.9489095} * {pf_34_1 : 0.9489095}) + ({pf_33_1 : -0.0895083} * {pf_33_1 : -0.0895083}))))
    f_9_14 = inversesqrt(((pf_36_1 * pf_36_1) + ((pf_34_1 * pf_34_1) + (pf_33_1 * pf_33_1))));
	// 0.9050674  <=>  ((float(int({u_2_19 : 16})) * {pf_13_21 : 0.4315667}) + (0.f - floor((float(int({u_2_19 : 16})) * {pf_13_21 : 0.4315667}))))
    pf_13_23 = ((float(int(u_2_19)) * pf_13_21) + (0.f - floor((float(int(u_2_19)) * pf_13_21))));
	// 1086324736  <=>  {ftou2(floor((float(int({u_2_19 : 16})) * {pf_13_21 : 0.4315667}))) : 1086324736}
    u_11_11 = ftou2(floor((float(int(u_2_19)) * pf_13_21)));
    u_11_phi_49 = u_11_11;
	// True  <=>  if(((! {b_1_41 : False}) ? true : false))
    if (((!b_1_41) ? true : false))
    {
		// 4294967295  <=>  ({b_0_30 : False} ? ({u_11_7 : 21} + {u_1_24 : 4294967280}) : 4294967295u)
        u_11_12 = (b_0_30 ? (u_11_7 + u_1_24) : 4294967295u);
        u_11_phi_49 = u_11_12;
    }
	// 1.00  <=>  inversesqrt((({pf_35_1 : 0.1837339} * {pf_35_1 : 0.1837339}) + (({pf_28_5 : 0.9510565} * {pf_28_5 : 0.9510565}) + ({pf_29_4 : -0.2484618} * {pf_29_4 : -0.2484618}))))
    f_7_52 = inversesqrt(((pf_35_1 * pf_35_1) + ((pf_28_5 * pf_28_5) + (pf_29_4 * pf_29_4))));
	// 1088222800  <=>  {ftou2((float(int({u_2_19 : 16})) * {pf_13_21 : 0.4315667})) : 1088222800}
    u_20_2 = ftou2((float(int(u_2_19)) * pf_13_21));
    u_20_phi_50 = u_20_2;
	// True  <=>  if(((! ({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u))) ? true : false))
    if (((!(u_17_0 == (u_1_20 + 4294967295u))) ? true : false))
    {
		// 4294967295  <=>  ({b_0_30 : False} ? ({u_11_7 : 21} + {u_1_24 : 4294967280}) : 4294967295u)
        u_20_3 = (b_0_30 ? (u_11_7 + u_1_24) : 4294967295u);
        u_20_phi_50 = u_20_3;
    }
	// 4294967295  <=>  {u_11_phi_49 : 4294967295}
    u_1_27 = u_11_phi_49;
    u_1_phi_51 = u_1_27;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 7  <=>  {u_4_14 : 7}
        u_1_28 = u_4_14;
        u_1_phi_51 = u_1_28;
    }
	// 4294967295  <=>  {u_20_phi_50 : 4294967295}
    u_9_16 = u_20_phi_50;
    u_9_phi_52 = u_9_16;
	// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
    if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
    {
		// 7  <=>  {u_4_14 : 7}
        u_9_17 = u_4_14;
        u_9_phi_52 = u_9_17;
    }
	// 3182907418  <=>  {ftou2(pf_33_1) : 3182907418}
    u_11_13 = ftou2(pf_33_1);
    u_11_phi_53 = u_11_13;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 7  <=>  {u_4_14 : 7}
        u_11_14 = u_4_14;
        u_11_phi_53 = u_11_14;
    }
	// 3197824176  <=>  {ftou2(pf_36_1) : 3197824176}
    u_16_3 = ftou2(pf_36_1);
    u_16_phi_54 = u_16_3;
	// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
    if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
    {
		// 7  <=>  {u_4_14 : 7}
        u_16_4 = u_4_14;
        u_16_phi_54 = u_16_4;
    }
	// 3182907418  <=>  {u_11_phi_53 : 3182907418}
    u_18_1 = u_11_phi_53;
    u_18_phi_55 = u_18_1;
	// True  <=>  if(((! {b_1_41 : False}) ? true : false))
    if (((!b_1_41) ? true : false))
    {
		// 6  <=>  (isnan((float(int({u_2_19 : 16})) * {pf_13_21 : 0.4315667})) ? 0u : {u_10_13 : 6})
        u_18_2 = (isnan((float(int(u_2_19)) * pf_13_21)) ? 0u : u_10_13);
        u_18_phi_55 = u_18_2;
    }
	// 3197824176  <=>  {u_16_phi_54 : 3197824176}
    u_11_15 = u_16_phi_54;
    u_11_phi_56 = u_11_15;
	// True  <=>  if(((! ({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u))) ? true : false))
    if (((!(u_17_0 == (u_1_20 + 4294967295u))) ? true : false))
    {
		// 6  <=>  (isnan((float(int({u_2_19 : 16})) * {pf_13_21 : 0.4315667})) ? 0u : {u_10_13 : 6})
        u_11_16 = (isnan((float(int(u_2_19)) * pf_13_21)) ? 0u : u_10_13);
        u_11_phi_56 = u_11_16;
    }
	// 3195956426  <=>  {ftou2(({pf_29_4 : -0.2484618} * {f_7_52 : 1.00})) : 3195956426}
    u_20_4 = ftou2((pf_29_4 * f_7_52));
    u_20_phi_57 = u_20_4;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 1065353216  <=>  {ftou2(cos({utof2(u_0_phi_46) : 0.00})) : 1065353216}
        u_20_5 = ftou2(cos( utof2(u_0_phi_46)));
        u_20_phi_57 = u_20_5;
    }
	// 1064532083  <=>  {ftou2(({pf_28_5 : 0.9510565} * {f_7_52 : 1.00})) : 1064532083}
    u_22_0 = ftou2((pf_28_5 * f_7_52));
    u_22_phi_58 = u_22_0;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 0  <=>  0u
        u_22_1 = 0u;
        u_22_phi_58 = u_22_1;
    }
	// 1044128955  <=>  {ftou2(({pf_35_1 : 0.1837339} * {f_7_52 : 1.00})) : 1044128955}
    u_0_5 = ftou2((pf_35_1 * f_7_52));
    u_0_phi_59 = u_0_5;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 1058551322  <=>  {ftou2(((0.f - {utof2(u_19_phi_47) : -0.5945755}) + (0.f - 0.f))) : 1058551322}
        u_0_6 = ftou2(((0.f - utof2(u_19_phi_47)) + (0.f - 0.f)));
        u_0_phi_59 = u_0_6;
    }
	// 3209549197  <=>  {ftou2(({pf_29_2 : 0.7646873} * (0.f - inversesqrt({pf_30_4 : 0.9045086})))) : 3209549197}
    u_16_7 = ftou2((pf_29_2 * (0.f - inversesqrt(pf_30_4))));
    u_16_phi_60 = u_16_7;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 3195956426  <=>  {u_20_phi_57 : 3195956426}
        u_16_8 = u_20_phi_57;
        u_16_phi_60 = u_16_8;
    }
	// 1044128955  <=>  {u_0_phi_59 : 1044128955}
    u_14_18 = u_0_phi_59;
	// 3209549197  <=>  {u_16_phi_60 : 3209549197}
    u_23_1 = u_16_phi_60;
	// 3195956426  <=>  {u_20_phi_57 : 3195956426}
    u_24_0 = u_20_phi_57;
	// 3206034970  <=>  {u_19_phi_47 : 3206034970}
    u_25_0 = u_19_phi_47;
	// 1064532083  <=>  {u_22_phi_58 : 1064532083}
    u_26_0 = u_22_phi_58;
	// 2147483648  <=>  {u_21_phi_48 : 2147483648}
    u_27_0 = u_21_phi_48;
    u_14_phi_61 = u_14_18;
    u_23_phi_61 = u_23_1;
    u_24_phi_61 = u_24_0;
    u_25_phi_61 = u_25_0;
    u_26_phi_61 = u_26_0;
    u_27_phi_61 = u_27_0;
	// True  <=>  if(((! {b_1_41 : False}) ? true : false))
    if (((!b_1_41) ? true : false))
    {
		// False  <=>  ((isnan((({pf_10_7 : 1.341287} * 0.31830987f) * {f_5_49 : 15.00})) ? 0u : {u_12_10 : 6}) == ({u_1_20 : 16} + 4294967295u))
        b_3_24 = ((isnan(((pf_10_7 * 0.31830987f) * f_5_49)) ? 0u : u_12_10) == (u_1_20 + 4294967295u));
		// 1044128954  <=>  {ftou2(pf_35_1) : 1044128954}
        u_28_0 = ftou2(pf_35_1);
        u_28_phi_62 = u_28_0;
		// False  <=>  if(({b_3_24 : False} ? true : false))
        if ((b_3_24 ? true : false))
        {
			// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
            u_28_1 = ftou2((pf_9_10 * 6.2831855f));
            u_28_phi_62 = u_28_1;
        }
		// 2147483648  <=>  {u_21_phi_48 : 2147483648}
        u_15_14 = u_21_phi_48;
        u_15_phi_63 = u_15_14;
		// False  <=>  if(({b_3_24 : False} ? true : false))
        if ((b_3_24 ? true : false))
        {
			// 0  <=>  0u
            u_15_15 = 0u;
            u_15_phi_63 = u_15_15;
        }
		// 1064532083  <=>  {u_22_phi_58 : 1064532083}
        u_29_1 = u_22_phi_58;
        u_29_phi_64 = u_29_1;
		// False  <=>  if(({b_3_24 : False} ? true : false))
        if ((b_3_24 ? true : false))
        {
			// 0  <=>  0u
            u_29_2 = 0u;
            u_29_phi_64 = u_29_2;
        }
		// 1044128954  <=>  {u_28_phi_62 : 1044128954}
        u_30_0 = u_28_phi_62;
        u_30_phi_65 = u_30_0;
		// False  <=>  if(({b_3_24 : False} ? true : false))
        if ((b_3_24 ? true : false))
        {
			// 1044128954  <=>  {u_28_phi_62 : 1044128954}
            u_30_1 = u_28_phi_62;
            u_30_phi_65 = u_30_1;
        }
		// 3209549197  <=>  {u_16_phi_60 : 3209549197}
        u_28_2 = u_16_phi_60;
        u_28_phi_66 = u_28_2;
		// False  <=>  if(({b_3_24 : False} ? true : false))
        if ((b_3_24 ? true : false))
        {
			// 1065070828  <=>  {ftou2(cos({utof2(u_30_phi_65) : 0.1837339})) : 1065070828}
            u_28_3 = ftou2(cos( utof2(u_30_phi_65)));
            u_28_phi_66 = u_28_3;
        }
		// 3206034970  <=>  {u_19_phi_47 : 3206034970}
        u_31_1 = u_19_phi_47;
        u_31_phi_67 = u_31_1;
		// False  <=>  if(({b_3_24 : False} ? true : false))
        if ((b_3_24 ? true : false))
        {
			// 1044059697  <=>  {ftou2(sin({utof2(u_30_phi_65) : 0.1837339})) : 1044059697}
            u_31_2 = ftou2(sin( utof2(u_30_phi_65)));
            u_31_phi_67 = u_31_2;
        }
		// 3195956426  <=>  {u_20_phi_57 : 3195956426}
        u_30_3 = u_20_phi_57;
        u_30_phi_68 = u_30_3;
		// False  <=>  if(({b_3_24 : False} ? true : false))
        if ((b_3_24 ? true : false))
        {
			// 1062065549  <=>  {ftou2(((0.f - {utof2(u_28_phi_66) : -0.8040398}) + (0.f - 0.f))) : 1062065549}
            u_30_4 = ftou2(((0.f - utof2(u_28_phi_66)) + (0.f - 0.f)));
            u_30_phi_68 = u_30_4;
        }
		// 1044128955  <=>  {u_0_phi_59 : 1044128955}
        u_32_1 = u_0_phi_59;
        u_32_phi_69 = u_32_1;
		// False  <=>  if(({b_3_24 : False} ? true : false))
        if ((b_3_24 ? true : false))
        {
			// 3206034970  <=>  {u_31_phi_67 : 3206034970}
            u_32_2 = u_31_phi_67;
            u_32_phi_69 = u_32_2;
        }
		// 1044128955  <=>  {u_32_phi_69 : 1044128955}
        u_33_0 = u_32_phi_69;
		// 3209549197  <=>  {u_28_phi_66 : 3209549197}
        u_34_0 = u_28_phi_66;
		// 3195956426  <=>  {u_30_phi_68 : 3195956426}
        u_35_0 = u_30_phi_68;
		// 3206034970  <=>  {u_31_phi_67 : 3206034970}
        u_36_0 = u_31_phi_67;
		// 1064532083  <=>  {u_29_phi_64 : 1064532083}
        u_37_0 = u_29_phi_64;
		// 2147483648  <=>  {u_15_phi_63 : 2147483648}
        u_38_0 = u_15_phi_63;
        u_33_phi_70 = u_33_0;
        u_34_phi_70 = u_34_0;
        u_35_phi_70 = u_35_0;
        u_36_phi_70 = u_36_0;
        u_37_phi_70 = u_37_0;
        u_38_phi_70 = u_38_0;
		// True  <=>  if(((! {b_3_24 : False}) ? true : false))
        if (((!b_3_24) ? true : false))
        {
			// 0.60  <=>  ((0.f - ({f_8_9 : 6.00} * (1.0f / {f_5_49 : 15.00}))) + 1.f)
            pf_28_11 = ((0.f - (f_8_9 * (1.0f / f_5_49))) + 1.f);
			// False  <=>  ((({pf_28_11 : 0.60} < float(1e-05)) && (! isnan({pf_28_11 : 0.60}))) && (! isnan(float(1e-05))))
            b_4_18 = (((pf_28_11 < float(1e-05)) && (!isnan(pf_28_11))) && (!isnan(float(1e-05))));
			// False  <=>  ((((({f_8_9 : 6.00} * (1.0f / {f_5_49 : 15.00})) < float(1e-05)) && (! isnan(({f_8_9 : 6.00} * (1.0f / {f_5_49 : 15.00}))))) && (! isnan(float(1e-05)))) ? true : false)
            b_5_5 = (((((f_8_9 * (1.0f / f_5_49)) < float(1e-05)) && (!isnan((f_8_9 * (1.0f / f_5_49))))) && (!isnan(float(1e-05)))) ? true : false);
			// 1044128955  <=>  {u_32_phi_69 : 1044128955}
            u_39_0 = u_32_phi_69;
			// 3209549197  <=>  {u_28_phi_66 : 3209549197}
            u_40_0 = u_28_phi_66;
			// 3195956426  <=>  {u_30_phi_68 : 3195956426}
            u_41_0 = u_30_phi_68;
			// 3206034970  <=>  {u_31_phi_67 : 3206034970}
            u_42_0 = u_31_phi_67;
			// 1064532083  <=>  {u_29_phi_64 : 1064532083}
            u_43_0 = u_29_phi_64;
			// 2147483648  <=>  {u_15_phi_63 : 2147483648}
            u_44_0 = u_15_phi_63;
            u_39_phi_71 = u_39_0;
            u_40_phi_71 = u_40_0;
            u_41_phi_71 = u_41_0;
            u_42_phi_71 = u_42_0;
            u_43_phi_71 = u_43_0;
            u_44_phi_71 = u_44_0;
			// False  <=>  if({b_5_5 : False})
            if (b_5_5)
            {
				// -0.8040397  <=>  cos(((({pf_19_3 : -1.10134} + (0.f - floor({pf_19_3 : -1.10134}))) * 6.2831855f) + 3.1415927f))
                f_7_62 = cos((((pf_19_3 + (0.f - floor(pf_19_3))) * 6.2831855f) + 3.1415927f));
				// 0.5945756  <=>  sin(((({pf_19_3 : -1.10134} + (0.f - floor({pf_19_3 : -1.10134}))) * 6.2831855f) + 3.1415927f))
                f_9_19 = sin((((pf_19_3 + (0.f - floor(pf_19_3))) * 6.2831855f) + 3.1415927f));
				// 1.00  <=>  inversesqrt((({f_9_19 : 0.5945756} * {f_9_19 : 0.5945756}) + (({f_7_62 : -0.8040397} * {f_7_62 : -0.8040397}) + 0.f)))
                f_13_0 = inversesqrt(((f_9_19 * f_9_19) + ((f_7_62 * f_7_62) + 0.f)));
				// 1058551324  <=>  {ftou2(({f_9_19 : 0.5945756} * {f_13_0 : 1.00})) : 1058551324}
                u_45_0 = ftou2((f_9_19 * f_13_0));
				// 3209549195  <=>  {ftou2(({f_7_62 : -0.8040397} * {f_13_0 : 1.00})) : 3209549195}
                u_46_0 = ftou2((f_7_62 * f_13_0));
				// 0  <=>  {ftou2((0.f * {f_13_0 : 1.00})) : 0}
                u_47_0 = ftou2((0.f * f_13_0));
				// 0.1837339  <=>  (({pf_22_3 : 0.3090169} * {f_7_32 : 0.9999999}) * ({f_9_19 : 0.5945756} * {f_13_0 : 1.00}))
                pf_35_2 = ((pf_22_3 * f_7_32) * (f_9_19 * f_13_0));
				// 0.4546643  <=>  (({pf_20_6 : -0.565475} * {f_7_32 : 0.9999999}) * ({f_7_62 : -0.8040397} * {f_13_0 : 1.00}))
                pf_37_4 = ((pf_20_6 * f_7_32) * (f_7_62 * f_13_0));
				// 0.00  <=>  (({pf_19_6 : 0.7646874} * {f_7_32 : 0.9999999}) * (0.f * {f_13_0 : 1.00}))
                pf_38_3 = ((pf_19_6 * f_7_32) * (0.f * f_13_0));
				// -0.1837339  <=>  ((({pf_20_6 : -0.565475} * {f_7_32 : 0.9999999}) * (0.f * {f_13_0 : 1.00})) + (0.f - {pf_35_2 : 0.1837339}))
                pf_29_7 = (((pf_20_6 * f_7_32) * (0.f * f_13_0)) + (0.f - pf_35_2));
				// 0.0000002  <=>  ((({pf_19_6 : 0.7646874} * {f_7_32 : 0.9999999}) * ({f_9_19 : 0.5945756} * {f_13_0 : 1.00})) + (0.f - {pf_37_4 : 0.4546643}))
                pf_18_14 = (((pf_19_6 * f_7_32) * (f_9_19 * f_13_0)) + (0.f - pf_37_4));
				// -0.2484618  <=>  ((({pf_22_3 : 0.3090169} * {f_7_32 : 0.9999999}) * ({f_7_62 : -0.8040397} * {f_13_0 : 1.00})) + (0.f - {pf_38_3 : 0.00}))
                pf_28_13 = (((pf_22_3 * f_7_32) * (f_7_62 * f_13_0)) + (0.f - pf_38_3));
				// 3.236069  <=>  inversesqrt((({pf_28_13 : -0.2484618} * {pf_28_13 : -0.2484618}) + (({pf_18_14 : 0.0000002} * {pf_18_14 : 0.0000002}) + ({pf_29_7 : -0.1837339} * {pf_29_7 : -0.1837339}))))
                f_7_66 = inversesqrt(((pf_28_13 * pf_28_13) + ((pf_18_14 * pf_18_14) + (pf_29_7 * pf_29_7))));
				// 3209549195  <=>  {ftou2(({pf_28_13 : -0.2484618} * {f_7_66 : 3.236069})) : 3209549195}
                u_50_0 = ftou2((pf_28_13 * f_7_66));
				// 1058551324  <=>  {u_45_0 : 1058551324}
                u_39_1 = u_45_0;
				// 3209549195  <=>  {u_50_0 : 3209549195}
                u_40_1 = u_50_0;
				// 3209549195  <=>  {u_46_0 : 3209549195}
                u_41_1 = u_46_0;
				// 3206034972  <=>  {ftou2(({pf_29_7 : -0.1837339} * {f_7_66 : 3.236069})) : 3206034972}
                u_42_1 = ftou2((pf_29_7 * f_7_66));
				// 0  <=>  {u_47_0 : 0}
                u_43_1 = u_47_0;
				// 891232957  <=>  {ftou2(({pf_18_14 : 0.0000002} * {f_7_66 : 3.236069})) : 891232957}
                u_44_1 = ftou2((pf_18_14 * f_7_66));
                u_39_phi_71 = u_39_1;
                u_40_phi_71 = u_40_1;
                u_41_phi_71 = u_41_1;
                u_42_phi_71 = u_42_1;
                u_43_phi_71 = u_43_1;
                u_44_phi_71 = u_44_1;
            }
			// 1044128955  <=>  {u_39_phi_71 : 1044128955}
            u_45_1 = u_39_phi_71;
			// 3209549197  <=>  {u_40_phi_71 : 3209549197}
            u_46_1 = u_40_phi_71;
			// 3195956426  <=>  {u_41_phi_71 : 3195956426}
            u_47_1 = u_41_phi_71;
			// 3206034970  <=>  {u_42_phi_71 : 3206034970}
            u_48_1 = u_42_phi_71;
			// 1064532083  <=>  {u_43_phi_71 : 1064532083}
            u_49_1 = u_43_phi_71;
			// 2147483648  <=>  {u_44_phi_71 : 2147483648}
            u_50_1 = u_44_phi_71;
            u_45_phi_72 = u_45_1;
            u_46_phi_72 = u_46_1;
            u_47_phi_72 = u_47_1;
            u_48_phi_72 = u_48_1;
            u_49_phi_72 = u_49_1;
            u_50_phi_72 = u_50_1;
			// False  <=>  if(({b_4_18 : False} ? true : false))
            if ((b_4_18 ? true : false))
            {
				// 1.00  <=>  inversesqrt((({f_11_11 : -0.5945755} * {f_11_11 : -0.5945755}) + (({f_10_26 : 0.8040398} * {f_10_26 : 0.8040398}) + 0.f)))
                f_7_67 = inversesqrt(((f_11_11 * f_11_11) + ((f_10_26 * f_10_26) + 0.f)));
				// 3206034970  <=>  {ftou2(({f_11_11 : -0.5945755} * {f_7_67 : 1.00})) : 3206034970}
                u_51_0 = ftou2((f_11_11 * f_7_67));
				// 1062065549  <=>  {ftou2(({f_10_26 : 0.8040398} * {f_7_67 : 1.00})) : 1062065549}
                u_52_0 = ftou2((f_10_26 * f_7_67));
				// 0  <=>  {ftou2((0.f * {f_7_67 : 1.00})) : 0}
                u_53_0 = ftou2((0.f * f_7_67));
				// -0.1837339  <=>  (({pf_22_3 : 0.3090169} * {f_7_32 : 0.9999999}) * ({f_11_11 : -0.5945755} * {f_7_67 : 1.00}))
                pf_35_6 = ((pf_22_3 * f_7_32) * (f_11_11 * f_7_67));
				// -0.4546643  <=>  (({pf_20_6 : -0.565475} * {f_7_32 : 0.9999999}) * ({f_10_26 : 0.8040398} * {f_7_67 : 1.00}))
                pf_37_5 = ((pf_20_6 * f_7_32) * (f_10_26 * f_7_67));
				// 0.1837339  <=>  ((({pf_20_6 : -0.565475} * {f_7_32 : 0.9999999}) * (0.f * {f_7_67 : 1.00})) + (0.f - {pf_35_6 : -0.1837339}))
                pf_26_3 = (((pf_20_6 * f_7_32) * (0.f * f_7_67)) + (0.f - pf_35_6));
				// 0.00  <=>  (({pf_19_6 : 0.7646874} * {f_7_32 : 0.9999999}) * (0.f * {f_7_67 : 1.00}))
                pf_29_10 = ((pf_19_6 * f_7_32) * (0.f * f_7_67));
				// -0.00  <=>  ((({pf_19_6 : 0.7646874} * {f_7_32 : 0.9999999}) * ({f_11_11 : -0.5945755} * {f_7_67 : 1.00})) + (0.f - {pf_37_5 : -0.4546643}))
                pf_18_20 = (((pf_19_6 * f_7_32) * (f_11_11 * f_7_67)) + (0.f - pf_37_5));
				// 0.2484618  <=>  ((({pf_22_3 : 0.3090169} * {f_7_32 : 0.9999999}) * ({f_10_26 : 0.8040398} * {f_7_67 : 1.00})) + (0.f - {pf_29_10 : 0.00}))
                pf_25_4 = (((pf_22_3 * f_7_32) * (f_10_26 * f_7_67)) + (0.f - pf_29_10));
				// 3.236069  <=>  inversesqrt((({pf_25_4 : 0.2484618} * {pf_25_4 : 0.2484618}) + (({pf_18_20 : -0.00} * {pf_18_20 : -0.00}) + ({pf_26_3 : 0.1837339} * {pf_26_3 : 0.1837339}))))
                f_7_71 = inversesqrt(((pf_25_4 * pf_25_4) + ((pf_18_20 * pf_18_20) + (pf_26_3 * pf_26_3))));
				// 1062065549  <=>  {ftou2(({pf_25_4 : 0.2484618} * {f_7_71 : 3.236069})) : 1062065549}
                u_56_0 = ftou2((pf_25_4 * f_7_71));
				// 3206034970  <=>  {u_51_0 : 3206034970}
                u_45_2 = u_51_0;
				// 1062065549  <=>  {u_56_0 : 1062065549}
                u_46_2 = u_56_0;
				// 1062065549  <=>  {u_52_0 : 1062065549}
                u_47_2 = u_52_0;
				// 1058551322  <=>  {ftou2(({pf_26_3 : 0.1837339} * {f_7_71 : 3.236069})) : 1058551322}
                u_48_2 = ftou2((pf_26_3 * f_7_71));
				// 0  <=>  {u_53_0 : 0}
                u_49_2 = u_53_0;
				// 3017891900  <=>  {ftou2(({pf_18_20 : -0.00} * {f_7_71 : 3.236069})) : 3017891900}
                u_50_2 = ftou2((pf_18_20 * f_7_71));
                u_45_phi_72 = u_45_2;
                u_46_phi_72 = u_46_2;
                u_47_phi_72 = u_47_2;
                u_48_phi_72 = u_48_2;
                u_49_phi_72 = u_49_2;
                u_50_phi_72 = u_50_2;
            }
			// 1044128955  <=>  {u_45_phi_72 : 1044128955}
            u_33_1 = u_45_phi_72;
			// 3209549197  <=>  {u_46_phi_72 : 3209549197}
            u_34_1 = u_46_phi_72;
			// 3195956426  <=>  {u_47_phi_72 : 3195956426}
            u_35_1 = u_47_phi_72;
			// 3206034970  <=>  {u_48_phi_72 : 3206034970}
            u_36_1 = u_48_phi_72;
			// 1064532083  <=>  {u_49_phi_72 : 1064532083}
            u_37_1 = u_49_phi_72;
			// 2147483648  <=>  {u_50_phi_72 : 2147483648}
            u_38_1 = u_50_phi_72;
            u_33_phi_70 = u_33_1;
            u_34_phi_70 = u_34_1;
            u_35_phi_70 = u_35_1;
            u_36_phi_70 = u_36_1;
            u_37_phi_70 = u_37_1;
            u_38_phi_70 = u_38_1;
        }
		// 1044128955  <=>  {u_33_phi_70 : 1044128955}
        u_14_19 = u_33_phi_70;
		// 3209549197  <=>  {u_34_phi_70 : 3209549197}
        u_23_2 = u_34_phi_70;
		// 3195956426  <=>  {u_35_phi_70 : 3195956426}
        u_24_1 = u_35_phi_70;
		// 3206034970  <=>  {u_36_phi_70 : 3206034970}
        u_25_1 = u_36_phi_70;
		// 1064532083  <=>  {u_37_phi_70 : 1064532083}
        u_26_1 = u_37_phi_70;
		// 2147483648  <=>  {u_38_phi_70 : 2147483648}
        u_27_1 = u_38_phi_70;
        u_14_phi_61 = u_14_19;
        u_23_phi_61 = u_23_2;
        u_24_phi_61 = u_24_1;
        u_25_phi_61 = u_25_1;
        u_26_phi_61 = u_26_1;
        u_27_phi_61 = u_27_1;
    }
	// 6.00  <=>  float(int((isnan((float(int({u_2_19 : 16})) * {pf_13_21 : 0.4315667})) ? 0u : {u_10_13 : 6})))
    f_7_72 = float(int((isnan((float(int(u_2_19)) * pf_13_21)) ? 0u : u_10_13)));
	// 0.00  <=>  (((({utof2(u_8_phi_26) : 0.50} * {utof(vs_cbuf9_78.y) : 1.00}) * (1.0f / {utof(vs_cbuf9_78.w) : 16.00})) * float(int({u_1_20 : 16}))) + -0.5f)
    pf_25_5 = (((( utof2(u_8_phi_26) * utof(vs_cbuf9_78.y)) * (1.0f / utof(vs_cbuf9_78.w))) * float(int(u_1_20))) + -0.5f);
	// 0.00  <=>  (((({utof2(u_2_phi_24) : 0.50} * {utof(vs_cbuf9_78.x) : 1.00}) * (1.0f / {utof(vs_cbuf9_78.z) : 16.00})) * float(int({u_2_19 : 16}))) + -0.5f)
    pf_26_5 = (((( utof2(u_2_phi_24) * utof(vs_cbuf9_78.x)) * (1.0f / utof(vs_cbuf9_78.z))) * float(int(u_2_19))) + -0.5f);
	// 0.3090169  <=>  cos((({f_8_9 : 6.00} * (1.0f / {f_5_49 : 15.00})) * 3.1415927f))
    f_10_27 = cos(((f_8_9 * (1.0f / f_5_49)) * 3.1415927f));
	// -0.00  <=>  (({pf_36_1 : -0.302587} * {f_9_14 : 1.00}) * {pf_25_5 : 0.00})
    pf_25_6 = ((pf_36_1 * f_9_14) * pf_25_5);
	// -0.6638399  <=>  (((0.f - {pf_9_10 : 1.10134}) + {f_2_65 : 0.0625}) + ({f_2_65 : 0.0625} * {f_7_72 : 6.00}))
    pf_28_15 = (((0.f - pf_9_10) + f_2_65) + (f_2_65 * f_7_72));
	// -0.3090169  <=>  (0.f - {f_10_27 : 0.3090169})
    f_11_12 = (0.f - f_10_27);
	// 0.9045086  <=>  (({f_10_27 : 0.3090169} * {f_11_12 : -0.3090169}) + 1.f)
    pf_29_11 = ((f_10_27 * f_11_12) + 1.f);
	// -0.5153016  <=>  cos((({pf_28_15 : -0.6638399} + (0.f - floor({pf_28_15 : -0.6638399}))) * 6.2831855f))
    f_7_75 = cos(((pf_28_15 + (0.f - floor(pf_28_15))) * 6.2831855f));
	// 0.8570089  <=>  sin((({pf_28_15 : -0.6638399} + (0.f - floor({pf_28_15 : -0.6638399}))) * 6.2831855f))
    f_13_1 = sin(((pf_28_15 + (0.f - floor(pf_28_15))) * 6.2831855f));
	// -0.490081  <=>  ({f_7_75 : -0.5153016} * sqrt({pf_29_11 : 0.9045086}))
    pf_29_13 = (f_7_75 * sqrt(pf_29_11));
	// 0.8150639  <=>  ({f_13_1 : 0.8570089} * sqrt({pf_29_11 : 0.9045086}))
    pf_30_6 = (f_13_1 * sqrt(pf_29_11));
	// 0.3356708  <=>  (({f_10_27 : 0.3090169} * {f_10_27 : 0.3090169}) + ({pf_29_13 : -0.490081} * {pf_29_13 : -0.490081}))
    pf_31_3 = ((f_10_27 * f_10_27) + (pf_29_13 * pf_29_13));
	// 1.00  <=>  inversesqrt((({pf_30_6 : 0.8150639} * {pf_30_6 : 0.8150639}) + {pf_31_3 : 0.3356708}))
    f_11_14 = inversesqrt(((pf_30_6 * pf_30_6) + pf_31_3));
	// 0.3090169  <=>  ({f_10_27 : 0.3090169} * {f_11_14 : 1.00})
    pf_31_5 = (f_10_27 * f_11_14);
	// 0.8150639  <=>  ({pf_30_6 : 0.8150639} * {f_11_14 : 1.00})
    pf_30_7 = (pf_30_6 * f_11_14);
	// 1.00  <=>  inversesqrt((({pf_30_7 : 0.8150639} * {pf_30_7 : 0.8150639}) + (({pf_31_5 : 0.3090169} * {pf_31_5 : 0.3090169}) + (({pf_29_13 : -0.490081} * {f_11_14 : 1.00}) * ({pf_29_13 : -0.490081} * {f_11_14 : 1.00})))))
    f_10_28 = inversesqrt(((pf_30_7 * pf_30_7) + ((pf_31_5 * pf_31_5) + ((pf_29_13 * f_11_14) * (pf_29_13 * f_11_14)))));
	// -0.00  <=>  ((({pf_23_9 : -0.8335257} * {f_7_35 : 1.053282}) * {pf_26_5 : 0.00}) + (({pf_33_1 : -0.0895083} * {f_9_14 : 1.00}) * {pf_25_5 : 0.00}))
    pf_24_7 = (((pf_23_9 * f_7_35) * pf_26_5) + ((pf_33_1 * f_9_14) * pf_25_5));
	// 0.3596581  <=>  (({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * (0.f - {pf_19_6 : 0.7646874}))
    pf_26_6 = ((pf_3_6 * f_4_29) * (0.f - pf_19_6));
	// 0.2893482  <=>  ((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * (0.f - {pf_22_3 : 0.3090169})) + {pf_26_6 : 0.3596581})
    pf_26_7 = (((pf_6_2 * f_4_29) * (0.f - pf_22_3)) + pf_26_6);
	// -0.8150639  <=>  ((0.f * ({pf_31_5 : 0.3090169} * {f_10_28 : 1.00})) + (0.f - ({pf_30_7 : 0.8150639} * {f_10_28 : 1.00})))
    pf_36_3 = ((0.f * (pf_31_5 * f_10_28)) + (0.f - (pf_30_7 * f_10_28)));
	// -0.490081  <=>  ((0.f - 0.f) + (({pf_29_13 : -0.490081} * {f_11_14 : 1.00}) * {f_10_28 : 1.00}))
    pf_37_6 = ((0.f - 0.f) + ((pf_29_13 * f_11_14) * f_10_28));
	// 0.7715023  <=>  ((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * (0.f - {pf_20_6 : -0.565475})) + {pf_26_7 : 0.2893482})
    pf_26_8 = (((pf_7_2 * f_4_29) * (0.f - pf_20_6)) + pf_26_7);
	// 0.00  <=>  (({pf_22_3 : 0.3090169} * (0.f + ((({pf_14_11 : -0.2075762} * {f_7_35 : 1.053282}) * {pf_26_5 : 0.00}) + (({pf_34_1 : 0.9489095} * {f_9_14 : 1.00}) * {pf_25_5 : 0.00})))) + ({pf_19_6 : 0.7646874} * (0.f + {pf_24_7 : -0.00})))
    pf_19_8 = ((pf_22_3 * (0.f + (((pf_14_11 * f_7_35) * pf_26_5) + ((pf_34_1 * f_9_14) * pf_25_5)))) + (pf_19_6 * (0.f + pf_24_7)));
	// 0.9045086  <=>  (({pf_37_6 : -0.490081} * {pf_37_6 : -0.490081}) + (({pf_36_3 : -0.8150639} * {pf_36_3 : -0.8150639}) + 0.f))
    pf_22_4 = ((pf_37_6 * pf_37_6) + ((pf_36_3 * pf_36_3) + 0.f));
	// 0.00  <=>  (({pf_20_6 : -0.565475} * (0.f + ((({pf_21_6 : -0.4043915} * {f_7_35 : 1.053282}) * {pf_26_5 : 0.00}) + {pf_25_6 : -0.00}))) + {pf_19_8 : 0.00})
    pf_19_9 = ((pf_20_6 * (0.f + (((pf_21_6 * f_7_35) * pf_26_5) + pf_25_6))) + pf_19_8);
	// 0.00  <=>  ({pf_19_9 : 0.00} * (1.0f / {pf_26_8 : 0.7715023}))
    pf_19_10 = (pf_19_9 * (1.0f / pf_26_8));
	// 0.8779377  <=>  (0.f - ({pf_23_9 : -0.8335257} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))))
    f_10_34 = (0.f - (pf_23_9 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))));
	// 0.199755  <=>  (({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * {f_10_34 : 0.8779377})
    pf_20_7 = ((pf_6_2 * f_4_29) * f_10_34);
	// 1057221327  <=>  {ftou2(({pf_37_6 : -0.490081} * (0.f - inversesqrt({pf_22_4 : 0.9045086})))) : 1057221327}
    u_10_15 = ftou2((pf_37_6 * (0.f - inversesqrt(pf_22_4))));
	// 1062954223  <=>  {ftou2(({pf_36_3 : -0.8150639} * (0.f - inversesqrt({pf_22_4 : 0.9045086})))) : 1062954223}
    u_15_16 = ftou2((pf_36_3 * (0.f - inversesqrt(pf_22_4))));
	// 0.186421  <=>  (({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * (0.f - ({pf_14_11 : -0.2075762} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531})))))
    pf_39_1 = ((pf_7_2 * f_4_29) * (0.f - (pf_14_11 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4)))));
	// 0.00  <=>  ((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * {pf_19_10 : 0.00}) + (0.f + ((({pf_14_11 : -0.2075762} * {f_7_35 : 1.053282}) * {pf_26_5 : 0.00}) + (({pf_34_1 : 0.9489095} * {f_9_14 : 1.00}) * {pf_25_5 : 0.00}))))
    pf_18_27 = (((pf_6_2 * f_4_29) * pf_19_10) + (0.f + (((pf_14_11 * f_7_35) * pf_26_5) + ((pf_34_1 * f_9_14) * pf_25_5))));
	// -0.2525395  <=>  ((({pf_29_13 : -0.490081} * {f_11_14 : 1.00}) * {f_10_28 : 1.00}) * ({pf_37_6 : -0.490081} * (0.f - inversesqrt({pf_22_4 : 0.9045086}))))
    pf_41_0 = (((pf_29_13 * f_11_14) * f_10_28) * (pf_37_6 * (0.f - inversesqrt(pf_22_4))));
	// 0.2648302  <=>  (({pf_31_5 : 0.3090169} * {f_10_28 : 1.00}) * ({pf_36_3 : -0.8150639} * (0.f - inversesqrt({pf_22_4 : 0.9045086}))))
    pf_42_0 = ((pf_31_5 * f_10_28) * (pf_36_3 * (0.f - inversesqrt(pf_22_4))));
	// -0.2003331  <=>  (({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * (0.f - ({pf_21_6 : -0.4043915} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531})))))
    pf_43_0 = ((pf_3_6 * f_4_29) * (0.f - (pf_21_6 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4)))));
	// -0.0895083  <=>  ((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * (0.f - ({pf_21_6 : -0.4043915} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))))) + (0.f - {pf_39_1 : 0.186421}))
    pf_39_2 = (((pf_6_2 * f_4_29) * (0.f - (pf_21_6 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))))) + (0.f - pf_39_1));
	// -0.302587  <=>  ((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * (0.f - ({pf_14_11 : -0.2075762} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))))) + (0.f - {pf_20_7 : 0.199755}))
    pf_20_8 = (((pf_3_6 * f_4_29) * (0.f - (pf_14_11 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))))) + (0.f - pf_20_7));
	// 0.00  <=>  (0.f - (({pf_30_7 : 0.8150639} * {f_10_28 : 1.00}) * (0.f * (0.f - inversesqrt({pf_22_4 : 0.9045086})))))
    f_10_42 = (0.f - ((pf_30_7 * f_10_28) * (0.f * (0.f - inversesqrt(pf_22_4)))));
	// 0.1592369  <=>  ((({pf_31_5 : 0.3090169} * {f_10_28 : 1.00}) * ({pf_37_6 : -0.490081} * (0.f - inversesqrt({pf_22_4 : 0.9045086})))) + {f_10_42 : 0.00})
    pf_26_11 = (((pf_31_5 * f_10_28) * (pf_37_6 * (0.f - inversesqrt(pf_22_4)))) + f_10_42);
	// 0.9510565  <=>  ((({pf_30_7 : 0.8150639} * {f_10_28 : 1.00}) * ({pf_36_3 : -0.8150639} * (0.f - inversesqrt({pf_22_4 : 0.9045086})))) + (0.f - {pf_41_0 : -0.2525395}))
    pf_36_5 = (((pf_30_7 * f_10_28) * (pf_36_3 * (0.f - inversesqrt(pf_22_4)))) + (0.f - pf_41_0));
	// -0.2648302  <=>  (((({pf_29_13 : -0.490081} * {f_11_14 : 1.00}) * {f_10_28 : 1.00}) * (0.f * (0.f - inversesqrt({pf_22_4 : 0.9045086})))) + (0.f - {pf_42_0 : 0.2648302}))
    pf_22_6 = ((((pf_29_13 * f_11_14) * f_10_28) * (0.f * (0.f - inversesqrt(pf_22_4)))) + (0.f - pf_42_0));
	// 0.8779377  <=>  (0.f - ({pf_23_9 : -0.8335257} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))))
    f_10_45 = (0.f - (pf_23_9 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))));
	// 0.9489095  <=>  ((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * {f_10_45 : 0.8779377}) + (0.f - {pf_43_0 : -0.2003331}))
    pf_40_2 = (((pf_7_2 * f_4_29) * f_10_45) + (0.f - pf_43_0));
	// 0.0253564  <=>  ({pf_26_11 : 0.1592369} * {pf_26_11 : 0.1592369})
    pf_43_1 = (pf_26_11 * pf_26_11);
	// 0.908441  <=>  (({pf_40_2 : 0.9489095} * {pf_40_2 : 0.9489095}) + ({pf_39_2 : -0.0895083} * {pf_39_2 : -0.0895083}))
    pf_25_9 = ((pf_40_2 * pf_40_2) + (pf_39_2 * pf_39_2));
	// 2147483648  <=>  {ftou2((0.f * (0.f - inversesqrt({pf_22_4 : 0.9045086})))) : 2147483648}
    u_19_2 = ftou2((0.f * (0.f - inversesqrt(pf_22_4))));
    u_19_phi_73 = u_19_2;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 0  <=>  0u
        u_19_3 = 0u;
        u_19_phi_73 = u_19_3;
    }
	// 1020246067  <=>  {ftou2(pf_43_1) : 1020246067}
    u_0_8 = ftou2(pf_43_1);
    u_0_phi_74 = u_0_8;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
        u_0_9 = ftou2((pf_9_10 * 6.2831855f));
        u_0_phi_74 = u_0_9;
    }
	// 0.9999999  <=>  (({pf_22_6 : -0.2648302} * {pf_22_6 : -0.2648302}) + (({pf_36_5 : 0.9510565} * {pf_36_5 : 0.9510565}) + {pf_43_1 : 0.0253564}))
    pf_25_10 = ((pf_22_6 * pf_22_6) + ((pf_36_5 * pf_36_5) + pf_43_1));
	// 1020246067  <=>  {u_0_phi_74 : 1020246067}
    u_16_10 = u_0_phi_74;
    u_16_phi_75 = u_16_10;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 1020246067  <=>  {u_0_phi_74 : 1020246067}
        u_16_11 = u_0_phi_74;
        u_16_phi_75 = u_16_11;
    }
	// -0.00  <=>  ((((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * {pf_19_10 : 0.00}) + (0.f + ((({pf_21_6 : -0.4043915} * {f_7_35 : 1.053282}) * {pf_26_5 : 0.00}) + {pf_25_6 : -0.00}))) * {utof2(u_23_phi_61) : -0.8040398}) + ((((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * {pf_19_10 : 0.00}) + (0.f + {pf_24_7 : -0.00})) * {utof2(u_25_phi_61) : -0.5945755}) + ({pf_18_27 : 0.00} * {utof2(u_27_phi_61) : -0.00})))
    pf_24_11 = (((((pf_7_2 * f_4_29) * pf_19_10) + (0.f + (((pf_21_6 * f_7_35) * pf_26_5) + pf_25_6))) * utof2(u_23_phi_61)) + (((((pf_3_6 * f_4_29) * pf_19_10) + (0.f + pf_24_7)) * utof2(u_25_phi_61)) + (pf_18_27 * utof2(u_27_phi_61))));
	// 1062954223  <=>  {u_15_16 : 1062954223}
    u_0_10 = u_15_16;
    u_0_phi_76 = u_0_10;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 1020244608  <=>  {ftou2(sin({utof2(u_16_phi_75) : 0.0253564})) : 1020244608}
        u_0_11 = ftou2(sin( utof2(u_16_phi_75)));
        u_0_phi_76 = u_0_11;
    }
	// 0.00  <=>  ((((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * {pf_19_10 : 0.00}) + (0.f + ((({pf_21_6 : -0.4043915} * {f_7_35 : 1.053282}) * {pf_26_5 : 0.00}) + {pf_25_6 : -0.00}))) * {utof2(u_14_phi_61) : 0.1837339}) + ((((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * {pf_19_10 : 0.00}) + (0.f + {pf_24_7 : -0.00})) * {utof2(u_24_phi_61) : -0.2484619}) + ({pf_18_27 : 0.00} * {utof2(u_26_phi_61) : 0.9510567})))
    pf_18_30 = (((((pf_7_2 * f_4_29) * pf_19_10) + (0.f + (((pf_21_6 * f_7_35) * pf_26_5) + pf_25_6))) * utof2(u_14_phi_61)) + (((((pf_3_6 * f_4_29) * pf_19_10) + (0.f + pf_24_7)) * utof2(u_24_phi_61)) + (pf_18_27 * utof2(u_26_phi_61))));
	// 0.50  <=>  clamp(({pf_18_30 : 0.00} + 0.5f), 0.0, 1.0)
    f_15_0 = clamp((pf_18_30 + 0.5f), 0.0, 1.0);
	// 1042484992  <=>  {ftou2(({pf_26_11 : 0.1592369} * inversesqrt({pf_25_10 : 0.9999999}))) : 1042484992}
    u_15_17 = ftou2((pf_26_11 * inversesqrt(pf_25_10)));
    u_15_phi_77 = u_15_17;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 1065347823  <=>  {ftou2(cos({utof2(u_16_phi_75) : 0.0253564})) : 1065347823}
        u_15_18 = ftou2(cos( utof2(u_16_phi_75)));
        u_15_phi_77 = u_15_18;
    }
	// -0.2648302  <=>  ({pf_22_6 : -0.2648302} * inversesqrt({pf_25_10 : 0.9999999}))
    pf_22_7 = (pf_22_6 * inversesqrt(pf_25_10));
	// 1064532083  <=>  {ftou2(({pf_36_5 : 0.9510565} * inversesqrt({pf_25_10 : 0.9999999}))) : 1064532083}
    u_20_8 = ftou2((pf_36_5 * inversesqrt(pf_25_10)));
    u_20_phi_78 = u_20_8;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 0  <=>  0u
        u_20_9 = 0u;
        u_20_phi_78 = u_20_9;
    }
	// 3196557267  <=>  {ftou2(pf_22_7) : 3196557267}
    u_14_22 = ftou2(pf_22_7);
    u_14_phi_79 = u_14_22;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 3210437871  <=>  {ftou2(((0.f - {utof2(u_0_phi_76) : 0.8570089}) + (0.f - 0.f))) : 3210437871}
        u_14_23 = ftou2(((0.f - utof2(u_0_phi_76)) + (0.f - 0.f)));
        u_14_phi_79 = u_14_23;
    }
	// 1057221327  <=>  {u_10_15 : 1057221327}
    u_16_14 = u_10_15;
    u_16_phi_80 = u_16_14;
	// False  <=>  if(({b_1_41 : False} ? true : false))
    if ((b_1_41 ? true : false))
    {
		// 1042484992  <=>  {u_15_phi_77 : 1042484992}
        u_16_15 = u_15_phi_77;
        u_16_phi_80 = u_16_15;
    }
	// 3196557267  <=>  {u_14_phi_79 : 3196557267}
    u_10_16 = u_14_phi_79;
	// 1057221327  <=>  {u_16_phi_80 : 1057221327}
    u_21_3 = u_16_phi_80;
	// 1042484992  <=>  {u_15_phi_77 : 1042484992}
    u_22_2 = u_15_phi_77;
	// 1062954223  <=>  {u_0_phi_76 : 1062954223}
    u_23_3 = u_0_phi_76;
	// 1064532083  <=>  {u_20_phi_78 : 1064532083}
    u_24_2 = u_20_phi_78;
	// 2147483648  <=>  {u_19_phi_73 : 2147483648}
    u_25_2 = u_19_phi_73;
    u_10_phi_81 = u_10_16;
    u_21_phi_81 = u_21_3;
    u_22_phi_81 = u_22_2;
    u_23_phi_81 = u_23_3;
    u_24_phi_81 = u_24_2;
    u_25_phi_81 = u_25_2;
	// True  <=>  if(((! {b_1_41 : False}) ? true : false))
    if (((!b_1_41) ? true : false))
    {
		// False  <=>  ((isnan((({pf_10_7 : 1.341287} * 0.31830987f) * {f_5_49 : 15.00})) ? 0u : {u_12_10 : 6}) == ({u_1_20 : 16} + 4294967295u))
        b_1_43 = ((isnan(((pf_10_7 * 0.31830987f) * f_5_49)) ? 0u : u_12_10) == (u_1_20 + 4294967295u));
		// 6  <=>  (isnan((({pf_10_7 : 1.341287} * 0.31830987f) * {f_5_49 : 15.00})) ? 0u : {u_12_10 : 6})
        u_26_2 = (isnan(((pf_10_7 * 0.31830987f) * f_5_49)) ? 0u : u_12_10);
        u_26_phi_82 = u_26_2;
		// False  <=>  if(({b_1_43 : False} ? true : false))
        if ((b_1_43 ? true : false))
        {
			// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
            u_26_3 = ftou2((pf_9_10 * 6.2831855f));
            u_26_phi_82 = u_26_3;
        }
		// 2147483648  <=>  {u_19_phi_73 : 2147483648}
        u_12_12 = u_19_phi_73;
        u_12_phi_83 = u_12_12;
		// False  <=>  if(({b_1_43 : False} ? true : false))
        if ((b_1_43 ? true : false))
        {
			// 0  <=>  0u
            u_12_13 = 0u;
            u_12_phi_83 = u_12_13;
        }
		// 1064532083  <=>  {u_20_phi_78 : 1064532083}
        u_27_3 = u_20_phi_78;
        u_27_phi_84 = u_27_3;
		// False  <=>  if(({b_1_43 : False} ? true : false))
        if ((b_1_43 ? true : false))
        {
			// 0  <=>  0u
            u_27_4 = 0u;
            u_27_phi_84 = u_27_4;
        }
		// 6  <=>  {u_26_phi_82 : 6}
        u_28_4 = u_26_phi_82;
        u_28_phi_85 = u_28_4;
		// False  <=>  if(({b_1_43 : False} ? true : false))
        if ((b_1_43 ? true : false))
        {
			// 6  <=>  {u_26_phi_82 : 6}
            u_28_5 = u_26_phi_82;
            u_28_phi_85 = u_28_5;
        }
		// 1057221327  <=>  {u_16_phi_80 : 1057221327}
        u_26_4 = u_16_phi_80;
        u_26_phi_86 = u_26_4;
		// False  <=>  if(({b_1_43 : False} ? true : false))
        if ((b_1_43 ? true : false))
        {
			// 1065353216  <=>  {ftou2(cos({utof2(u_28_phi_85) : 0.00})) : 1065353216}
            u_26_5 = ftou2(cos( utof2(u_28_phi_85)));
            u_26_phi_86 = u_26_5;
        }
		// 1062954223  <=>  {u_0_phi_76 : 1062954223}
        u_29_4 = u_0_phi_76;
        u_29_phi_87 = u_29_4;
		// False  <=>  if(({b_1_43 : False} ? true : false))
        if ((b_1_43 ? true : false))
        {
			// 6  <=>  {ftou2(sin({utof2(u_28_phi_85) : 0.00})) : 6}
            u_29_5 = ftou2(sin( utof2(u_28_phi_85)));
            u_29_phi_87 = u_29_5;
        }
		// 1042484992  <=>  {u_15_phi_77 : 1042484992}
        u_28_7 = u_15_phi_77;
        u_28_phi_88 = u_28_7;
		// False  <=>  if(({b_1_43 : False} ? true : false))
        if ((b_1_43 ? true : false))
        {
			// 3204704975  <=>  {ftou2(((0.f - {utof2(u_26_phi_86) : 0.5153016}) + (0.f - 0.f))) : 3204704975}
            u_28_8 = ftou2(((0.f - utof2(u_26_phi_86)) + (0.f - 0.f)));
            u_28_phi_88 = u_28_8;
        }
		// 3196557267  <=>  {u_14_phi_79 : 3196557267}
        u_30_6 = u_14_phi_79;
        u_30_phi_89 = u_30_6;
		// False  <=>  if(({b_1_43 : False} ? true : false))
        if ((b_1_43 ? true : false))
        {
			// 1062954223  <=>  {u_29_phi_87 : 1062954223}
            u_30_7 = u_29_phi_87;
            u_30_phi_89 = u_30_7;
        }
		// 3196557267  <=>  {u_30_phi_89 : 3196557267}
        u_31_3 = u_30_phi_89;
		// 1057221327  <=>  {u_26_phi_86 : 1057221327}
        u_32_3 = u_26_phi_86;
		// 1042484992  <=>  {u_28_phi_88 : 1042484992}
        u_33_2 = u_28_phi_88;
		// 1062954223  <=>  {u_29_phi_87 : 1062954223}
        u_34_2 = u_29_phi_87;
		// 1064532083  <=>  {u_27_phi_84 : 1064532083}
        u_35_2 = u_27_phi_84;
		// 2147483648  <=>  {u_12_phi_83 : 2147483648}
        u_36_2 = u_12_phi_83;
        u_31_phi_90 = u_31_3;
        u_32_phi_90 = u_32_3;
        u_33_phi_90 = u_33_2;
        u_34_phi_90 = u_34_2;
        u_35_phi_90 = u_35_2;
        u_36_phi_90 = u_36_2;
		// True  <=>  if(((! {b_1_43 : False}) ? true : false))
        if (((!b_1_43) ? true : false))
        {
			// 0.60  <=>  ((0.f - ({f_8_9 : 6.00} * (1.0f / {f_5_49 : 15.00}))) + 1.f)
            pf_22_11 = ((0.f - (f_8_9 * (1.0f / f_5_49))) + 1.f);
			// False  <=>  ((({pf_22_11 : 0.60} < float(1e-05)) && (! isnan({pf_22_11 : 0.60}))) && (! isnan(float(1e-05))))
            b_3_46 = (((pf_22_11 < float(1e-05)) && (!isnan(pf_22_11))) && (!isnan(float(1e-05))));
			// False  <=>  ((((({f_8_9 : 6.00} * (1.0f / {f_5_49 : 15.00})) < float(1e-05)) && (! isnan(({f_8_9 : 6.00} * (1.0f / {f_5_49 : 15.00}))))) && (! isnan(float(1e-05)))) ? true : false)
            b_4_19 = (((((f_8_9 * (1.0f / f_5_49)) < float(1e-05)) && (!isnan((f_8_9 * (1.0f / f_5_49))))) && (!isnan(float(1e-05)))) ? true : false);
			// 3196557267  <=>  {u_30_phi_89 : 3196557267}
            u_37_2 = u_30_phi_89;
			// 1057221327  <=>  {u_26_phi_86 : 1057221327}
            u_38_2 = u_26_phi_86;
			// 1042484992  <=>  {u_28_phi_88 : 1042484992}
            u_39_2 = u_28_phi_88;
			// 1062954223  <=>  {u_29_phi_87 : 1062954223}
            u_40_2 = u_29_phi_87;
			// 1064532083  <=>  {u_27_phi_84 : 1064532083}
            u_41_2 = u_27_phi_84;
			// 2147483648  <=>  {u_12_phi_83 : 2147483648}
            u_42_2 = u_12_phi_83;
            u_37_phi_91 = u_37_2;
            u_38_phi_91 = u_38_2;
            u_39_phi_91 = u_39_2;
            u_40_phi_91 = u_40_2;
            u_41_phi_91 = u_41_2;
            u_42_phi_91 = u_42_2;
			// False  <=>  if({b_4_19 : False})
            if (b_4_19)
            {
				// 0.5153019  <=>  cos(((({pf_28_15 : -0.6638399} + (0.f - floor({pf_28_15 : -0.6638399}))) * 6.2831855f) + 3.1415927f))
                f_10_60 = cos((((pf_28_15 + (0.f - floor(pf_28_15))) * 6.2831855f) + 3.1415927f));
				// -0.8570087  <=>  sin(((({pf_28_15 : -0.6638399} + (0.f - floor({pf_28_15 : -0.6638399}))) * 6.2831855f) + 3.1415927f))
                f_11_23 = sin((((pf_28_15 + (0.f - floor(pf_28_15))) * 6.2831855f) + 3.1415927f));
				// 1.00  <=>  inversesqrt((({f_11_23 : -0.8570087} * {f_11_23 : -0.8570087}) + (({f_10_60 : 0.5153019} * {f_10_60 : 0.5153019}) + 0.f)))
                f_16_2 = inversesqrt(((f_11_23 * f_11_23) + ((f_10_60 * f_10_60) + 0.f)));
				// 3210437868  <=>  {ftou2(({f_11_23 : -0.8570087} * {f_16_2 : 1.00})) : 3210437868}
                u_43_2 = ftou2((f_11_23 * f_16_2));
				// 1057221332  <=>  {ftou2(({f_10_60 : 0.5153019} * {f_16_2 : 1.00})) : 1057221332}
                u_44_2 = ftou2((f_10_60 * f_16_2));
				// 0  <=>  {ftou2((0.f * {f_16_2 : 1.00})) : 0}
                u_45_3 = ftou2((0.f * f_16_2));
				// -0.2648301  <=>  (({pf_31_5 : 0.3090169} * {f_10_28 : 1.00}) * ({f_11_23 : -0.8570087} * {f_16_2 : 1.00}))
                pf_25_11 = ((pf_31_5 * f_10_28) * (f_11_23 * f_16_2));
				// 0.420004  <=>  (({pf_30_7 : 0.8150639} * {f_10_28 : 1.00}) * ({f_10_60 : 0.5153019} * {f_16_2 : 1.00}))
                pf_26_12 = ((pf_30_7 * f_10_28) * (f_10_60 * f_16_2));
				// -0.00  <=>  ((({pf_29_13 : -0.490081} * {f_11_14 : 1.00}) * {f_10_28 : 1.00}) * (0.f * {f_16_2 : 1.00}))
                pf_28_17 = (((pf_29_13 * f_11_14) * f_10_28) * (0.f * f_16_2));
				// 0.2648301  <=>  ((({pf_30_7 : 0.8150639} * {f_10_28 : 1.00}) * (0.f * {f_16_2 : 1.00})) + (0.f - {pf_25_11 : -0.2648301}))
                pf_24_15 = (((pf_30_7 * f_10_28) * (0.f * f_16_2)) + (0.f - pf_25_11));
				// -0.0000003  <=>  (((({pf_29_13 : -0.490081} * {f_11_14 : 1.00}) * {f_10_28 : 1.00}) * ({f_11_23 : -0.8570087} * {f_16_2 : 1.00})) + (0.f - {pf_26_12 : 0.420004}))
                pf_16_12 = ((((pf_29_13 * f_11_14) * f_10_28) * (f_11_23 * f_16_2)) + (0.f - pf_26_12));
				// 0.159237  <=>  ((({pf_31_5 : 0.3090169} * {f_10_28 : 1.00}) * ({f_10_60 : 0.5153019} * {f_16_2 : 1.00})) + (0.f - {pf_28_17 : -0.00}))
                pf_22_13 = (((pf_31_5 * f_10_28) * (f_10_60 * f_16_2)) + (0.f - pf_28_17));
				// 3.236069  <=>  inversesqrt((({pf_22_13 : 0.159237} * {pf_22_13 : 0.159237}) + (({pf_16_12 : -0.0000003} * {pf_16_12 : -0.0000003}) + ({pf_24_15 : 0.2648301} * {pf_24_15 : 0.2648301}))))
                f_10_64 = inversesqrt(((pf_22_13 * pf_22_13) + ((pf_16_12 * pf_16_12) + (pf_24_15 * pf_24_15))));
				// 1057221332  <=>  {ftou2(({pf_22_13 : 0.159237} * {f_10_64 : 3.236069})) : 1057221332}
                u_48_3 = ftou2((pf_22_13 * f_10_64));
				// 3210437868  <=>  {u_43_2 : 3210437868}
                u_37_3 = u_43_2;
				// 1057221332  <=>  {u_48_3 : 1057221332}
                u_38_3 = u_48_3;
				// 1057221332  <=>  {u_44_2 : 1057221332}
                u_39_3 = u_44_2;
				// 1062954221  <=>  {ftou2(({pf_24_15 : 0.2648301} * {f_10_64 : 3.236069})) : 1062954221}
                u_40_3 = ftou2((pf_24_15 * f_10_64));
				// 0  <=>  {u_45_3 : 0}
                u_41_3 = u_45_3;
				// 3045817656  <=>  {ftou2(({pf_16_12 : -0.0000003} * {f_10_64 : 3.236069})) : 3045817656}
                u_42_3 = ftou2((pf_16_12 * f_10_64));
                u_37_phi_91 = u_37_3;
                u_38_phi_91 = u_38_3;
                u_39_phi_91 = u_39_3;
                u_40_phi_91 = u_40_3;
                u_41_phi_91 = u_41_3;
                u_42_phi_91 = u_42_3;
            }
			// 3196557267  <=>  {u_37_phi_91 : 3196557267}
            u_43_3 = u_37_phi_91;
			// 1057221327  <=>  {u_38_phi_91 : 1057221327}
            u_44_3 = u_38_phi_91;
			// 1042484992  <=>  {u_39_phi_91 : 1042484992}
            u_45_4 = u_39_phi_91;
			// 1062954223  <=>  {u_40_phi_91 : 1062954223}
            u_46_4 = u_40_phi_91;
			// 1064532083  <=>  {u_41_phi_91 : 1064532083}
            u_47_4 = u_41_phi_91;
			// 2147483648  <=>  {u_42_phi_91 : 2147483648}
            u_48_4 = u_42_phi_91;
            u_43_phi_92 = u_43_3;
            u_44_phi_92 = u_44_3;
            u_45_phi_92 = u_45_4;
            u_46_phi_92 = u_46_4;
            u_47_phi_92 = u_47_4;
            u_48_phi_92 = u_48_4;
			// False  <=>  if(({b_3_46 : False} ? true : false))
            if ((b_3_46 ? true : false))
            {
				// 1.00  <=>  inversesqrt((({f_13_1 : 0.8570089} * {f_13_1 : 0.8570089}) + (({f_7_75 : -0.5153016} * {f_7_75 : -0.5153016}) + 0.f)))
                f_10_65 = inversesqrt(((f_13_1 * f_13_1) + ((f_7_75 * f_7_75) + 0.f)));
				// 1062954223  <=>  {ftou2(({f_13_1 : 0.8570089} * {f_10_65 : 1.00})) : 1062954223}
                u_49_3 = ftou2((f_13_1 * f_10_65));
				// 3204704975  <=>  {ftou2(({f_7_75 : -0.5153016} * {f_10_65 : 1.00})) : 3204704975}
                u_50_3 = ftou2((f_7_75 * f_10_65));
				// 0  <=>  {ftou2((0.f * {f_10_65 : 1.00})) : 0}
                u_51_1 = ftou2((0.f * f_10_65));
				// 0.2648302  <=>  (({pf_31_5 : 0.3090169} * {f_10_28 : 1.00}) * ({f_13_1 : 0.8570089} * {f_10_65 : 1.00}))
                pf_25_15 = ((pf_31_5 * f_10_28) * (f_13_1 * f_10_65));
				// -0.4200038  <=>  (({pf_30_7 : 0.8150639} * {f_10_28 : 1.00}) * ({f_7_75 : -0.5153016} * {f_10_65 : 1.00}))
                pf_26_13 = ((pf_30_7 * f_10_28) * (f_7_75 * f_10_65));
				// -0.00  <=>  ((({pf_29_13 : -0.490081} * {f_11_14 : 1.00}) * {f_10_28 : 1.00}) * (0.f * {f_10_65 : 1.00}))
                pf_28_18 = (((pf_29_13 * f_11_14) * f_10_28) * (0.f * f_10_65));
				// -0.2648302  <=>  ((({pf_30_7 : 0.8150639} * {f_10_28 : 1.00}) * (0.f * {f_10_65 : 1.00})) + (0.f - {pf_25_15 : 0.2648302}))
                pf_24_18 = (((pf_30_7 * f_10_28) * (0.f * f_10_65)) + (0.f - pf_25_15));
				// -0.00  <=>  (((({pf_29_13 : -0.490081} * {f_11_14 : 1.00}) * {f_10_28 : 1.00}) * ({f_13_1 : 0.8570089} * {f_10_65 : 1.00})) + (0.f - {pf_26_13 : -0.4200038}))
                pf_16_18 = ((((pf_29_13 * f_11_14) * f_10_28) * (f_13_1 * f_10_65)) + (0.f - pf_26_13));
				// -0.1592369  <=>  ((({pf_31_5 : 0.3090169} * {f_10_28 : 1.00}) * ({f_7_75 : -0.5153016} * {f_10_65 : 1.00})) + (0.f - {pf_28_18 : -0.00}))
                pf_22_15 = (((pf_31_5 * f_10_28) * (f_7_75 * f_10_65)) + (0.f - pf_28_18));
				// 3.236069  <=>  inversesqrt((({pf_22_15 : -0.1592369} * {pf_22_15 : -0.1592369}) + (({pf_16_18 : -0.00} * {pf_16_18 : -0.00}) + ({pf_24_18 : -0.2648302} * {pf_24_18 : -0.2648302}))))
                f_7_79 = inversesqrt(((pf_22_15 * pf_22_15) + ((pf_16_18 * pf_16_18) + (pf_24_18 * pf_24_18))));
				// 3204704975  <=>  {ftou2(({pf_22_15 : -0.1592369} * {f_7_79 : 3.236069})) : 3204704975}
                u_52_1 = ftou2((pf_22_15 * f_7_79));
				// 1062954223  <=>  {u_49_3 : 1062954223}
                u_43_4 = u_49_3;
				// 3204704975  <=>  {u_52_1 : 3204704975}
                u_44_4 = u_52_1;
				// 3204704975  <=>  {u_50_3 : 3204704975}
                u_45_5 = u_50_3;
				// 3210437870  <=>  {ftou2(({pf_24_18 : -0.2648302} * {f_7_79 : 3.236069})) : 3210437870}
                u_46_5 = ftou2((pf_24_18 * f_7_79));
				// 0  <=>  {u_51_1 : 0}
                u_47_5 = u_51_1;
				// 2995268110  <=>  {ftou2(({pf_16_18 : -0.00} * {f_7_79 : 3.236069})) : 2995268110}
                u_48_5 = ftou2((pf_16_18 * f_7_79));
                u_43_phi_92 = u_43_4;
                u_44_phi_92 = u_44_4;
                u_45_phi_92 = u_45_5;
                u_46_phi_92 = u_46_5;
                u_47_phi_92 = u_47_5;
                u_48_phi_92 = u_48_5;
            }
			// 3196557267  <=>  {u_43_phi_92 : 3196557267}
            u_31_4 = u_43_phi_92;
			// 1057221327  <=>  {u_44_phi_92 : 1057221327}
            u_32_4 = u_44_phi_92;
			// 1042484992  <=>  {u_45_phi_92 : 1042484992}
            u_33_3 = u_45_phi_92;
			// 1062954223  <=>  {u_46_phi_92 : 1062954223}
            u_34_3 = u_46_phi_92;
			// 1064532083  <=>  {u_47_phi_92 : 1064532083}
            u_35_3 = u_47_phi_92;
			// 2147483648  <=>  {u_48_phi_92 : 2147483648}
            u_36_3 = u_48_phi_92;
            u_31_phi_90 = u_31_4;
            u_32_phi_90 = u_32_4;
            u_33_phi_90 = u_33_3;
            u_34_phi_90 = u_34_3;
            u_35_phi_90 = u_35_3;
            u_36_phi_90 = u_36_3;
        }
		// 3196557267  <=>  {u_31_phi_90 : 3196557267}
        u_10_17 = u_31_phi_90;
		// 1057221327  <=>  {u_32_phi_90 : 1057221327}
        u_21_4 = u_32_phi_90;
		// 1042484992  <=>  {u_33_phi_90 : 1042484992}
        u_22_3 = u_33_phi_90;
		// 1062954223  <=>  {u_34_phi_90 : 1062954223}
        u_23_4 = u_34_phi_90;
		// 1064532083  <=>  {u_35_phi_90 : 1064532083}
        u_24_3 = u_35_phi_90;
		// 2147483648  <=>  {u_36_phi_90 : 2147483648}
        u_25_3 = u_36_phi_90;
        u_10_phi_81 = u_10_17;
        u_21_phi_81 = u_21_4;
        u_22_phi_81 = u_22_3;
        u_23_phi_81 = u_23_4;
        u_24_phi_81 = u_24_3;
        u_25_phi_81 = u_25_3;
    }
	// -1.10134  <=>  (((0.f - {pf_9_10 : 1.10134}) + {f_2_65 : 0.0625}) + ({f_2_65 : 0.0625} * float(int(({b_0_30 : False} ? ({u_11_7 : 21} + {u_1_24 : 4294967280}) : 4294967295u)))))
    pf_16_21 = (((0.f - pf_9_10) + f_2_65) + (f_2_65 * float(int((b_0_30 ? (u_11_7 + u_1_24) : 4294967295u)))));
	// 0.00  <=>  (((({utof2(u_8_phi_26) : 0.50} * {utof(vs_cbuf9_78.y) : 1.00}) * (1.0f / {utof(vs_cbuf9_78.w) : 16.00})) * float(int({u_1_20 : 16}))) + -0.5f)
    pf_11_8 = (((( utof2(u_8_phi_26) * utof(vs_cbuf9_78.y)) * (1.0f / utof(vs_cbuf9_78.w))) * float(int(u_1_20))) + -0.5f);
	// 0.00  <=>  (((({utof2(u_2_phi_24) : 0.50} * {utof(vs_cbuf9_78.x) : 1.00}) * (1.0f / {utof(vs_cbuf9_78.z) : 16.00})) * float(int({u_2_19 : 16}))) + -0.5f)
    pf_12_8 = (((( utof2(u_2_phi_24) * utof(vs_cbuf9_78.x)) * (1.0f / utof(vs_cbuf9_78.z))) * float(int(u_2_19))) + -0.5f);
	// 0.4666667  <=>  (float(int({u_17_0 : 7})) * (1.0f / {f_5_49 : 15.00}))
    pf_20_10 = (float(int(u_17_0)) * (1.0f / f_5_49));
	// -0.00  <=>  ((({pf_23_9 : -0.8335257} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))) * {pf_12_8 : 0.00}) + (({pf_39_2 : -0.0895083} * inversesqrt((({pf_20_8 : -0.302587} * {pf_20_8 : -0.302587}) + {pf_25_9 : 0.908441}))) * {pf_11_8 : 0.00}))
    pf_17_6 = (((pf_23_9 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))) * pf_12_8) + ((pf_39_2 * inversesqrt(((pf_20_8 * pf_20_8) + pf_25_9))) * pf_11_8));
	// 0.00  <=>  ((({pf_14_11 : -0.2075762} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))) * {pf_12_8 : 0.00}) + (({pf_40_2 : 0.9489095} * inversesqrt((({pf_20_8 : -0.302587} * {pf_20_8 : -0.302587}) + {pf_25_9 : 0.908441}))) * {pf_11_8 : 0.00}))
    pf_18_34 = (((pf_14_11 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))) * pf_12_8) + ((pf_40_2 * inversesqrt(((pf_20_8 * pf_20_8) + pf_25_9))) * pf_11_8));
	// -0.00  <=>  ((({pf_21_6 : -0.4043915} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))) * {pf_12_8 : 0.00}) + (({pf_20_8 : -0.302587} * inversesqrt((({pf_20_8 : -0.302587} * {pf_20_8 : -0.302587}) + {pf_25_9 : 0.908441}))) * {pf_11_8 : 0.00}))
    pf_19_15 = (((pf_21_6 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))) * pf_12_8) + ((pf_20_8 * inversesqrt(((pf_20_8 * pf_20_8) + pf_25_9))) * pf_11_8));
	// 5.646448  <=>  (({pf_16_21 : -1.10134} + (0.f - floor({pf_16_21 : -1.10134}))) * 6.2831855f)
    pf_25_19 = ((pf_16_21 + (0.f - floor(pf_16_21))) * 6.2831855f);
	// 0.00  <=>  (0.f + {pf_19_15 : -0.00})
    pf_19_16 = (0.f + pf_19_15);
	// 0.1045283  <=>  cos(({pf_20_10 : 0.4666667} * 3.1415927f))
    f_10_70 = cos((pf_20_10 * 3.1415927f));
	// -0.1045283  <=>  (0.f - {f_10_70 : 0.1045283})
    f_16_3 = (0.f - f_10_70);
	// 0.9890738  <=>  (({f_10_70 : 0.1045283} * {f_16_3 : -0.1045283}) + 1.f)
    pf_24_20 = ((f_10_70 * f_16_3) + 1.f);
	// 0.7996352  <=>  (cos({pf_25_19 : 5.646448}) * sqrt({pf_24_20 : 0.9890738}))
    pf_24_21 = (cos(pf_25_19) * sqrt(pf_24_20));
	// -0.5913184  <=>  (sin({pf_25_19 : 5.646448}) * sqrt({pf_24_20 : 0.9890738}))
    pf_25_20 = (sin(pf_25_19) * sqrt(pf_24_20));
	// 0.6503426  <=>  (({f_10_70 : 0.1045283} * {f_10_70 : 0.1045283}) + ({pf_24_21 : 0.7996352} * {pf_24_21 : 0.7996352}))
    pf_26_15 = ((f_10_70 * f_10_70) + (pf_24_21 * pf_24_21));
	// 1.00  <=>  inversesqrt((({pf_25_20 : -0.5913184} * {pf_25_20 : -0.5913184}) + {pf_26_15 : 0.6503426}))
    f_16_5 = inversesqrt(((pf_25_20 * pf_25_20) + pf_26_15));
	// 0.1045283  <=>  ({f_10_70 : 0.1045283} * {f_16_5 : 1.00})
    pf_26_17 = (f_10_70 * f_16_5);
	// 0.6503426  <=>  (({pf_26_17 : 0.1045283} * {pf_26_17 : 0.1045283}) + (({pf_24_21 : 0.7996352} * {f_16_5 : 1.00}) * ({pf_24_21 : 0.7996352} * {f_16_5 : 1.00})))
    pf_28_20 = ((pf_26_17 * pf_26_17) + ((pf_24_21 * f_16_5) * (pf_24_21 * f_16_5)));
	// 1.00  <=>  inversesqrt(((({pf_25_20 : -0.5913184} * {f_16_5 : 1.00}) * ({pf_25_20 : -0.5913184} * {f_16_5 : 1.00})) + {pf_28_20 : 0.6503426}))
    f_10_71 = inversesqrt((((pf_25_20 * f_16_5) * (pf_25_20 * f_16_5)) + pf_28_20));
	// 0.5913184  <=>  (0.f - (({pf_25_20 : -0.5913184} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}))
    f_10_72 = (0.f - ((pf_25_20 * f_16_5) * f_10_71));
	// 0.5913184  <=>  ((0.f * ({pf_26_17 : 0.1045283} * {f_10_71 : 1.00})) + {f_10_72 : 0.5913184})
    pf_34_4 = ((0.f * (pf_26_17 * f_10_71)) + f_10_72);
	// 0.7996352  <=>  ((0.f - 0.f) + (({pf_24_21 : 0.7996352} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}))
    pf_35_8 = ((0.f - 0.f) + ((pf_24_21 * f_16_5) * f_10_71));
	// 1.005508  <=>  inversesqrt((({pf_35_8 : 0.7996352} * {pf_35_8 : 0.7996352}) + (({pf_34_4 : 0.5913184} * {pf_34_4 : 0.5913184}) + 0.f)))
    f_10_74 = inversesqrt(((pf_35_8 * pf_35_8) + ((pf_34_4 * pf_34_4) + 0.f)));
	// -0.9957783  <=>  ((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * (0.f - {pf_30_7 : 0.8150639})) + ((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * (0.f - {pf_31_5 : 0.3090169})) + (({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * (0.f - ({pf_29_13 : -0.490081} * {f_11_14 : 1.00})))))
    pf_22_19 = (((pf_7_2 * f_4_29) * (0.f - pf_30_7)) + (((pf_6_2 * f_4_29) * (0.f - pf_31_5)) + ((pf_3_6 * f_4_29) * (0.f - (pf_29_13 * f_11_14)))));
	// -1.00424  <=>  (1.0f / {pf_22_19 : -0.9957783})
    f_9_23 = (1.0f / pf_22_19);
	// 0.00  <=>  ((({pf_25_20 : -0.5913184} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}) * (0.f * (0.f - {f_10_74 : 1.005508})))
    pf_34_5 = (((pf_25_20 * f_16_5) * f_10_71) * (0.f * (0.f - f_10_74)));
	// 0.186421  <=>  (({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * (0.f - ({pf_14_11 : -0.2075762} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531})))))
    pf_36_8 = ((pf_7_2 * f_4_29) * (0.f - (pf_14_11 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4)))));
	// 0.00  <=>  (({pf_30_7 : 0.8150639} * {pf_19_16 : 0.00}) + (({pf_31_5 : 0.3090169} * (0.f + {pf_18_34 : 0.00})) + (({pf_29_13 : -0.490081} * {f_11_14 : 1.00}) * (0.f + {pf_17_6 : -0.00}))))
    pf_29_17 = ((pf_30_7 * pf_19_16) + ((pf_31_5 * (0.f + pf_18_34)) + ((pf_29_13 * f_11_14) * (0.f + pf_17_6))));
	// -0.2003331  <=>  (({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * (0.f - ({pf_21_6 : -0.4043915} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531})))))
    pf_30_8 = ((pf_3_6 * f_4_29) * (0.f - (pf_21_6 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4)))));
	// -0.6429385  <=>  ((({pf_24_21 : 0.7996352} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}) * ({pf_35_8 : 0.7996352} * (0.f - {f_10_74 : 1.005508})))
    pf_37_8 = (((pf_24_21 * f_16_5) * f_10_71) * (pf_35_8 * (0.f - f_10_74)));
	// -0.0840449  <=>  ((({pf_26_17 : 0.1045283} * {f_10_71 : 1.00}) * ({pf_35_8 : 0.7996352} * (0.f - {f_10_74 : 1.005508}))) + (0.f - {pf_34_5 : 0.00}))
    pf_34_6 = (((pf_26_17 * f_10_71) * (pf_35_8 * (0.f - f_10_74))) + (0.f - pf_34_5));
	// -0.0895083  <=>  ((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * (0.f - ({pf_21_6 : -0.4043915} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))))) + (0.f - {pf_36_8 : 0.186421}))
    pf_35_10 = (((pf_6_2 * f_4_29) * (0.f - (pf_21_6 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))))) + (0.f - pf_36_8));
	// 0.8779377  <=>  (0.f - ({pf_23_9 : -0.8335257} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))))
    f_10_80 = (0.f - (pf_23_9 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))));
	// 0.9489095  <=>  ((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * {f_10_80 : 0.8779377}) + (0.f - {pf_30_8 : -0.2003331}))
    pf_30_9 = (((pf_7_2 * f_4_29) * f_10_80) + (0.f - pf_30_8));
	// 0.6429385  <=>  (0.f - {pf_37_8 : -0.6429385})
    f_10_81 = (0.f - pf_37_8);
	// 0.9945219  <=>  (((({pf_25_20 : -0.5913184} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}) * ({pf_34_4 : 0.5913184} * (0.f - {f_10_74 : 1.005508}))) + {f_10_81 : 0.6429385})
    pf_22_21 = ((((pf_25_20 * f_16_5) * f_10_71) * (pf_34_4 * (0.f - f_10_74))) + f_10_81);
	// 0.8779377  <=>  (0.f - ({pf_23_9 : -0.8335257} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))))
    f_9_24 = (0.f - (pf_23_9 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))));
	// 0.06215  <=>  (((({pf_24_21 : 0.7996352} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}) * (0.f * (0.f - {f_10_74 : 1.005508}))) + (0.f - (({pf_26_17 : 0.1045283} * {f_10_71 : 1.00}) * ({pf_34_4 : 0.5913184} * (0.f - {f_10_74 : 1.005508})))))
    pf_31_7 = ((((pf_24_21 * f_16_5) * f_10_71) * (0.f * (0.f - f_10_74))) + (0.f - ((pf_26_17 * f_10_71) * (pf_34_4 * (0.f - f_10_74)))));
	// 0.0080117  <=>  ({pf_35_10 : -0.0895083} * {pf_35_10 : -0.0895083})
    pf_38_6 = (pf_35_10 * pf_35_10);
	// 2147483648  <=>  {ftou2((0.f * (0.f - {f_10_74 : 1.005508}))) : 2147483648}
    u_15_19 = ftou2((0.f * (0.f - f_10_74)));
    u_15_phi_93 = u_15_19;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 0  <=>  0u
        u_15_20 = 0u;
        u_15_phi_93 = u_15_20;
    }
	// 0.9961374  <=>  (({pf_22_21 : 0.9945219} * {pf_22_21 : 0.9945219}) + ({pf_34_6 : -0.0840449} * {pf_34_6 : -0.0840449}))
    pf_36_10 = ((pf_22_21 * pf_22_21) + (pf_34_6 * pf_34_6));
	// -0.199755  <=>  (0.f - (({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * {f_9_24 : 0.8779377}))
    f_10_82 = (0.f - ((pf_6_2 * f_4_29) * f_9_24));
	// -0.302587  <=>  ((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * (0.f - ({pf_14_11 : -0.2075762} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))))) + {f_10_82 : -0.199755})
    pf_37_10 = (((pf_3_6 * f_4_29) * (0.f - (pf_14_11 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))))) + f_10_82);
	// 0.908441  <=>  (({pf_30_9 : 0.9489095} * {pf_30_9 : 0.9489095}) + {pf_38_6 : 0.0080117})
    pf_38_7 = ((pf_30_9 * pf_30_9) + pf_38_6);
	// -0.00  <=>  (((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * ({pf_29_17 : 0.00} * {f_9_23 : -1.00424})) + (0.f + {pf_18_34 : 0.00})) * {utof2(u_25_phi_81) : -0.00})
    pf_29_19 = ((((pf_6_2 * f_4_29) * (pf_29_17 * f_9_23)) + (0.f + pf_18_34)) * utof2(u_25_phi_81));
	// 0.00  <=>  (((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * ({pf_29_17 : 0.00} * {f_9_23 : -1.00424})) + (0.f + {pf_18_34 : 0.00})) * {utof2(u_24_phi_81) : 0.9510567})
    pf_18_37 = ((((pf_6_2 * f_4_29) * (pf_29_17 * f_9_23)) + (0.f + pf_18_34)) * utof2(u_24_phi_81));
	// 1063817111  <=>  {ftou2(pf_38_7) : 1063817111}
    u_16_16 = ftou2(pf_38_7);
    u_16_phi_94 = u_16_16;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
        u_16_17 = ftou2((pf_9_10 * 6.2831855f));
        u_16_phi_94 = u_16_17;
    }
	// 1062954223  <=>  {u_23_phi_81 : 1062954223}
    u_0_14 = u_23_phi_81;
    u_0_phi_95 = u_0_14;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 1063817111  <=>  {u_16_phi_94 : 1063817111}
        u_0_15 = u_16_phi_94;
        u_0_phi_95 = u_0_15;
    }
	// 3206034970  <=>  {ftou2(({pf_34_4 : 0.5913184} * (0.f - {f_10_74 : 1.005508}))) : 3206034970}
    u_16_18 = ftou2((pf_34_4 * (0.f - f_10_74)));
    u_16_phi_96 = u_16_18;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 1061257690  <=>  {ftou2(sin({utof2(u_0_phi_95) : 0.8570089})) : 1061257690}
        u_16_19 = ftou2(sin( utof2(u_0_phi_95)));
        u_16_phi_96 = u_16_19;
    }
	// 3182174141  <=>  {ftou2(({pf_34_6 : -0.0840449} * inversesqrt((({pf_31_7 : 0.06215} * {pf_31_7 : 0.06215}) + {pf_36_10 : 0.9961374})))) : 3182174141}
    u_10_18 = ftou2((pf_34_6 * inversesqrt(((pf_31_7 * pf_31_7) + pf_36_10))));
	// 3182174141  <=>  {u_10_18 : 3182174141}
    u_14_25 = u_10_18;
    u_14_phi_97 = u_14_25;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 1059560066  <=>  {ftou2(cos({utof2(u_0_phi_95) : 0.8570089})) : 1059560066}
        u_14_26 = ftou2(cos( utof2(u_0_phi_95)));
        u_14_phi_97 = u_14_26;
    }
	// 1031704823  <=>  {ftou2(({pf_31_7 : 0.06215} * inversesqrt((({pf_31_7 : 0.06215} * {pf_31_7 : 0.06215}) + {pf_36_10 : 0.9961374})))) : 1031704823}
    u_17_4 = ftou2((pf_31_7 * inversesqrt(((pf_31_7 * pf_31_7) + pf_36_10))));
	// 0.50  <=>  (((((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * ({pf_29_17 : 0.00} * {f_9_23 : -1.00424})) + {pf_19_16 : 0.00}) * {utof2(u_21_phi_81) : 0.5153016}) + ((((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * ({pf_29_17 : 0.00} * {f_9_23 : -1.00424})) + (0.f + {pf_17_6 : -0.00})) * {utof2(u_23_phi_81) : 0.8570089}) + {pf_29_19 : -0.00})) + 0.5f)
    pf_18_39 = ((((((pf_7_2 * f_4_29) * (pf_29_17 * f_9_23)) + pf_19_16) * utof2(u_21_phi_81)) + (((((pf_3_6 * f_4_29) * (pf_29_17 * f_9_23)) + (0.f + pf_17_6)) * utof2(u_23_phi_81)) + pf_29_19)) + 0.5f);
	// 0.50  <=>  clamp({pf_18_39 : 0.50}, 0.0, 1.0)
    f_9_30 = clamp(pf_18_39, 0.0, 1.0);
	// 0.50  <=>  (((((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * ({pf_29_17 : 0.00} * {f_9_23 : -1.00424})) + {pf_19_16 : 0.00}) * {utof2(u_10_phi_81) : -0.2648302}) + ((((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * ({pf_29_17 : 0.00} * {f_9_23 : -1.00424})) + (0.f + {pf_17_6 : -0.00})) * {utof2(u_22_phi_81) : 0.1592369}) + {pf_18_37 : 0.00})) + 0.5f)
    pf_17_11 = ((((((pf_7_2 * f_4_29) * (pf_29_17 * f_9_23)) + pf_19_16) * utof2(u_10_phi_81)) + (((((pf_3_6 * f_4_29) * (pf_29_17 * f_9_23)) + (0.f + pf_17_6)) * utof2(u_22_phi_81)) + pf_18_37)) + 0.5f);
	// 0.50  <=>  clamp({pf_17_11 : 0.50}, 0.0, 1.0)
    f_10_84 = clamp(pf_17_11, 0.0, 1.0);
	// 1065261309  <=>  {ftou2(({pf_22_21 : 0.9945219} * inversesqrt((({pf_31_7 : 0.06215} * {pf_31_7 : 0.06215}) + {pf_36_10 : 0.9961374})))) : 1065261309}
    u_19_4 = ftou2((pf_22_21 * inversesqrt(((pf_31_7 * pf_31_7) + pf_36_10))));
    u_19_phi_98 = u_19_4;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 0  <=>  0u
        u_19_5 = 0u;
        u_19_phi_98 = u_19_5;
    }
	// 1031704823  <=>  {u_17_4 : 1031704823}
    u_10_20 = u_17_4;
    u_10_phi_99 = u_10_20;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 1058551322  <=>  {ftou2(((0.f - {utof2(u_16_phi_96) : -0.5945755}) + (0.f - 0.f))) : 1058551322}
        u_10_21 = ftou2(((0.f - utof2(u_16_phi_96)) + (0.f - 0.f)));
        u_10_phi_99 = u_10_21;
    }
	// 3209549197  <=>  {ftou2(({pf_35_8 : 0.7996352} * (0.f - {f_10_74 : 1.005508}))) : 3209549197}
    u_17_5 = ftou2((pf_35_8 * (0.f - f_10_74)));
    u_17_phi_100 = u_17_5;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 3182174141  <=>  {u_14_phi_97 : 3182174141}
        u_17_6 = u_14_phi_97;
        u_17_phi_100 = u_17_6;
    }
	// 1031704823  <=>  {u_10_phi_99 : 1031704823}
    u_12_15 = u_10_phi_99;
	// 3209549197  <=>  {u_17_phi_100 : 3209549197}
    u_20_11 = u_17_phi_100;
	// 3182174141  <=>  {u_14_phi_97 : 3182174141}
    u_21_5 = u_14_phi_97;
	// 1065261309  <=>  {u_19_phi_98 : 1065261309}
    u_22_4 = u_19_phi_98;
	// 3206034970  <=>  {u_16_phi_96 : 3206034970}
    u_23_5 = u_16_phi_96;
	// 2147483648  <=>  {u_15_phi_93 : 2147483648}
    u_24_4 = u_15_phi_93;
    u_12_phi_101 = u_12_15;
    u_20_phi_101 = u_20_11;
    u_21_phi_101 = u_21_5;
    u_22_phi_101 = u_22_4;
    u_23_phi_101 = u_23_5;
    u_24_phi_101 = u_24_4;
	// True  <=>  if(((! ({u_17_0 : 7} == 0u)) ? true : false))
    if (((!(u_17_0 == 0u)) ? true : false))
    {
		// 1062954223  <=>  {u_0_phi_95 : 1062954223}
        u_25_4 = u_0_phi_95;
        u_25_phi_102 = u_25_4;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
            u_25_5 = ftou2((pf_9_10 * 6.2831855f));
            u_25_phi_102 = u_25_5;
        }
		// 1065261309  <=>  {u_19_phi_98 : 1065261309}
        u_0_16 = u_19_phi_98;
        u_0_phi_103 = u_0_16;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 0  <=>  0u
            u_0_17 = 0u;
            u_0_phi_103 = u_0_17;
        }
		// 2147483648  <=>  {u_15_phi_93 : 2147483648}
        u_26_7 = u_15_phi_93;
        u_26_phi_104 = u_26_7;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 0  <=>  0u
            u_26_8 = 0u;
            u_26_phi_104 = u_26_8;
        }
		// 1062954223  <=>  {u_25_phi_102 : 1062954223}
        u_27_5 = u_25_phi_102;
        u_27_phi_105 = u_27_5;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1062954223  <=>  {u_25_phi_102 : 1062954223}
            u_27_6 = u_25_phi_102;
            u_27_phi_105 = u_27_6;
        }
		// 3209549197  <=>  {u_17_phi_100 : 3209549197}
        u_25_6 = u_17_phi_100;
        u_25_phi_106 = u_25_6;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1059560066  <=>  {ftou2(cos({utof2(u_27_phi_105) : 0.8570089})) : 1059560066}
            u_25_7 = ftou2(cos( utof2(u_27_phi_105)));
            u_25_phi_106 = u_25_7;
        }
		// 3206034970  <=>  {u_16_phi_96 : 3206034970}
        u_28_10 = u_16_phi_96;
        u_28_phi_107 = u_28_10;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1061257690  <=>  {ftou2(sin({utof2(u_27_phi_105) : 0.8570089})) : 1061257690}
            u_28_11 = ftou2(sin( utof2(u_27_phi_105)));
            u_28_phi_107 = u_28_11;
        }
		// 3182174141  <=>  {u_14_phi_97 : 3182174141}
        u_27_8 = u_14_phi_97;
        u_27_phi_108 = u_27_8;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1062065549  <=>  {ftou2(((0.f - {utof2(u_25_phi_106) : -0.8040398}) + (0.f - 0.f))) : 1062065549}
            u_27_9 = ftou2(((0.f - utof2(u_25_phi_106)) + (0.f - 0.f)));
            u_27_phi_108 = u_27_9;
        }
		// 1031704823  <=>  {u_10_phi_99 : 1031704823}
        u_29_7 = u_10_phi_99;
        u_29_phi_109 = u_29_7;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 3206034970  <=>  {u_28_phi_107 : 3206034970}
            u_29_8 = u_28_phi_107;
            u_29_phi_109 = u_29_8;
        }
		// 1031704823  <=>  {u_29_phi_109 : 1031704823}
        u_30_8 = u_29_phi_109;
		// 3209549197  <=>  {u_25_phi_106 : 3209549197}
        u_31_5 = u_25_phi_106;
		// 3182174141  <=>  {u_27_phi_108 : 3182174141}
        u_32_5 = u_27_phi_108;
		// 1065261309  <=>  {u_0_phi_103 : 1065261309}
        u_33_4 = u_0_phi_103;
		// 3206034970  <=>  {u_28_phi_107 : 3206034970}
        u_34_4 = u_28_phi_107;
		// 2147483648  <=>  {u_26_phi_104 : 2147483648}
        u_35_4 = u_26_phi_104;
        u_30_phi_110 = u_30_8;
        u_31_phi_110 = u_31_5;
        u_32_phi_110 = u_32_5;
        u_33_phi_110 = u_33_4;
        u_34_phi_110 = u_34_4;
        u_35_phi_110 = u_35_4;
		// True  <=>  if(((! ({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u))) ? true : false))
        if (((!(u_17_0 == (u_1_20 + 4294967295u))) ? true : false))
        {
			// 0.5333333  <=>  ((0.f - {pf_20_10 : 0.4666667}) + 1.f)
            pf_17_15 = ((0.f - pf_20_10) + 1.f);
			// False  <=>  ((({pf_17_15 : 0.5333333} < float(1e-05)) && (! isnan({pf_17_15 : 0.5333333}))) && (! isnan(float(1e-05))))
            b_4_22 = (((pf_17_15 < float(1e-05)) && (!isnan(pf_17_15))) && (!isnan(float(1e-05))));
			// False  <=>  (((({pf_20_10 : 0.4666667} < float(1e-05)) && (! isnan({pf_20_10 : 0.4666667}))) && (! isnan(float(1e-05)))) ? true : false)
            b_5_6 = ((((pf_20_10 < float(1e-05)) && (!isnan(pf_20_10))) && (!isnan(float(1e-05)))) ? true : false);
			// 1031704823  <=>  {u_29_phi_109 : 1031704823}
            u_36_4 = u_29_phi_109;
			// 3209549197  <=>  {u_25_phi_106 : 3209549197}
            u_37_4 = u_25_phi_106;
			// 3182174141  <=>  {u_27_phi_108 : 3182174141}
            u_38_4 = u_27_phi_108;
			// 1065261309  <=>  {u_0_phi_103 : 1065261309}
            u_39_4 = u_0_phi_103;
			// 3206034970  <=>  {u_28_phi_107 : 3206034970}
            u_40_4 = u_28_phi_107;
			// 2147483648  <=>  {u_26_phi_104 : 2147483648}
            u_41_4 = u_26_phi_104;
            u_36_phi_111 = u_36_4;
            u_37_phi_111 = u_37_4;
            u_38_phi_111 = u_38_4;
            u_39_phi_111 = u_39_4;
            u_40_phi_111 = u_40_4;
            u_41_phi_111 = u_41_4;
			// False  <=>  if({b_5_6 : False})
            if (b_5_6)
            {
				// -0.8040397  <=>  cos(((({pf_16_21 : -1.10134} + (0.f - floor({pf_16_21 : -1.10134}))) * 6.2831855f) + 3.1415927f))
                f_16_26 = cos((((pf_16_21 + (0.f - floor(pf_16_21))) * 6.2831855f) + 3.1415927f));
				// 0.5945756  <=>  sin(((({pf_16_21 : -1.10134} + (0.f - floor({pf_16_21 : -1.10134}))) * 6.2831855f) + 3.1415927f))
                f_17_2 = sin((((pf_16_21 + (0.f - floor(pf_16_21))) * 6.2831855f) + 3.1415927f));
				// 1.00  <=>  inversesqrt((({f_17_2 : 0.5945756} * {f_17_2 : 0.5945756}) + (({f_16_26 : -0.8040397} * {f_16_26 : -0.8040397}) + 0.f)))
                f_18_0 = inversesqrt(((f_17_2 * f_17_2) + ((f_16_26 * f_16_26) + 0.f)));
				// 1058551324  <=>  {ftou2(({f_17_2 : 0.5945756} * {f_18_0 : 1.00})) : 1058551324}
                u_42_4 = ftou2((f_17_2 * f_18_0));
				// 3209549195  <=>  {ftou2(({f_16_26 : -0.8040397} * {f_18_0 : 1.00})) : 3209549195}
                u_43_5 = ftou2((f_16_26 * f_18_0));
				// 0  <=>  {ftou2((0.f * {f_18_0 : 1.00})) : 0}
                u_44_5 = ftou2((0.f * f_18_0));
				// 0.06215  <=>  (({pf_26_17 : 0.1045283} * {f_10_71 : 1.00}) * ({f_17_2 : 0.5945756} * {f_18_0 : 1.00}))
                pf_30_10 = ((pf_26_17 * f_10_71) * (f_17_2 * f_18_0));
				// 0.4754434  <=>  ((({pf_25_20 : -0.5913184} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}) * ({f_16_26 : -0.8040397} * {f_18_0 : 1.00}))
                pf_31_8 = (((pf_25_20 * f_16_5) * f_10_71) * (f_16_26 * f_18_0));
				// 0.00  <=>  ((({pf_24_21 : 0.7996352} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}) * (0.f * {f_18_0 : 1.00}))
                pf_34_7 = (((pf_24_21 * f_16_5) * f_10_71) * (0.f * f_18_0));
				// -0.06215  <=>  (((({pf_25_20 : -0.5913184} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}) * (0.f * {f_18_0 : 1.00})) + (0.f - {pf_30_10 : 0.06215}))
                pf_18_41 = ((((pf_25_20 * f_16_5) * f_10_71) * (0.f * f_18_0)) + (0.f - pf_30_10));
				// 0.0000002  <=>  (((({pf_24_21 : 0.7996352} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}) * ({f_17_2 : 0.5945756} * {f_18_0 : 1.00})) + (0.f - {pf_31_8 : 0.4754434}))
                pf_16_27 = ((((pf_24_21 * f_16_5) * f_10_71) * (f_17_2 * f_18_0)) + (0.f - pf_31_8));
				// -0.0840449  <=>  ((({pf_26_17 : 0.1045283} * {f_10_71 : 1.00}) * ({f_16_26 : -0.8040397} * {f_18_0 : 1.00})) + (0.f - {pf_34_7 : 0.00}))
                pf_17_17 = (((pf_26_17 * f_10_71) * (f_16_26 * f_18_0)) + (0.f - pf_34_7));
				// 9.566788  <=>  inversesqrt((({pf_17_17 : -0.0840449} * {pf_17_17 : -0.0840449}) + (({pf_16_27 : 0.0000002} * {pf_16_27 : 0.0000002}) + ({pf_18_41 : -0.06215} * {pf_18_41 : -0.06215}))))
                f_16_30 = inversesqrt(((pf_17_17 * pf_17_17) + ((pf_16_27 * pf_16_27) + (pf_18_41 * pf_18_41))));
				// 3209549195  <=>  {ftou2(({pf_17_17 : -0.0840449} * {f_16_30 : 9.566788})) : 3209549195}
                u_47_6 = ftou2((pf_17_17 * f_16_30));
				// 1058551324  <=>  {u_42_4 : 1058551324}
                u_36_5 = u_42_4;
				// 3209549195  <=>  {u_47_6 : 3209549195}
                u_37_5 = u_47_6;
				// 3209549195  <=>  {u_43_5 : 3209549195}
                u_38_5 = u_43_5;
				// 0  <=>  {u_44_5 : 0}
                u_39_5 = u_44_5;
				// 3206034973  <=>  {ftou2(({pf_18_41 : -0.06215} * {f_16_30 : 9.566788})) : 3206034973}
                u_40_5 = ftou2((pf_18_41 * f_16_30));
				// 903845471  <=>  {ftou2(({pf_16_27 : 0.0000002} * {f_16_30 : 9.566788})) : 903845471}
                u_41_5 = ftou2((pf_16_27 * f_16_30));
                u_36_phi_111 = u_36_5;
                u_37_phi_111 = u_37_5;
                u_38_phi_111 = u_38_5;
                u_39_phi_111 = u_39_5;
                u_40_phi_111 = u_40_5;
                u_41_phi_111 = u_41_5;
            }
			// 1031704823  <=>  {u_36_phi_111 : 1031704823}
            u_42_5 = u_36_phi_111;
			// 3209549197  <=>  {u_37_phi_111 : 3209549197}
            u_43_6 = u_37_phi_111;
			// 3182174141  <=>  {u_38_phi_111 : 3182174141}
            u_44_6 = u_38_phi_111;
			// 1065261309  <=>  {u_39_phi_111 : 1065261309}
            u_45_7 = u_39_phi_111;
			// 3206034970  <=>  {u_40_phi_111 : 3206034970}
            u_46_7 = u_40_phi_111;
			// 2147483648  <=>  {u_41_phi_111 : 2147483648}
            u_47_7 = u_41_phi_111;
            u_42_phi_112 = u_42_5;
            u_43_phi_112 = u_43_6;
            u_44_phi_112 = u_44_6;
            u_45_phi_112 = u_45_7;
            u_46_phi_112 = u_46_7;
            u_47_phi_112 = u_47_7;
			// False  <=>  if(({b_4_22 : False} ? true : false))
            if ((b_4_22 ? true : false))
            {
				// 1.00  <=>  inversesqrt(((sin({pf_25_19 : 5.646448}) * sin({pf_25_19 : 5.646448})) + ((cos({pf_25_19 : 5.646448}) * cos({pf_25_19 : 5.646448})) + 0.f)))
                f_16_31 = inversesqrt(((sin(pf_25_19) * sin(pf_25_19)) + ((cos(pf_25_19) * cos(pf_25_19)) + 0.f)));
				// -0.4754435  <=>  ((({pf_25_20 : -0.5913184} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}) * (cos({pf_25_19 : 5.646448}) * {f_16_31 : 1.00}))
                pf_31_9 = (((pf_25_20 * f_16_5) * f_10_71) * (cos(pf_25_19) * f_16_31));
				// 0.00  <=>  ((({pf_24_21 : 0.7996352} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}) * (0.f * {f_16_31 : 1.00}))
                pf_34_8 = (((pf_24_21 * f_16_5) * f_10_71) * (0.f * f_16_31));
				// 0.06215  <=>  (((({pf_25_20 : -0.5913184} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}) * (0.f * {f_16_31 : 1.00})) + (0.f - (({pf_26_17 : 0.1045283} * {f_10_71 : 1.00}) * (sin({pf_25_19 : 5.646448}) * {f_16_31 : 1.00}))))
                pf_18_44 = ((((pf_25_20 * f_16_5) * f_10_71) * (0.f * f_16_31)) + (0.f - ((pf_26_17 * f_10_71) * (sin(pf_25_19) * f_16_31))));
				// -0.00  <=>  (((({pf_24_21 : 0.7996352} * {f_16_5 : 1.00}) * {f_10_71 : 1.00}) * (sin({pf_25_19 : 5.646448}) * {f_16_31 : 1.00})) + (0.f - {pf_31_9 : -0.4754435}))
                pf_16_33 = ((((pf_24_21 * f_16_5) * f_10_71) * (sin(pf_25_19) * f_16_31)) + (0.f - pf_31_9));
				// 0.0840449  <=>  ((({pf_26_17 : 0.1045283} * {f_10_71 : 1.00}) * (cos({pf_25_19 : 5.646448}) * {f_16_31 : 1.00})) + (0.f - {pf_34_8 : 0.00}))
                pf_17_19 = (((pf_26_17 * f_10_71) * (cos(pf_25_19) * f_16_31)) + (0.f - pf_34_8));
				// 9.566787  <=>  inversesqrt((({pf_17_19 : 0.0840449} * {pf_17_19 : 0.0840449}) + (({pf_16_33 : -0.00} * {pf_16_33 : -0.00}) + ({pf_18_44 : 0.06215} * {pf_18_44 : 0.06215}))))
                f_11_28 = inversesqrt(((pf_17_19 * pf_17_19) + ((pf_16_33 * pf_16_33) + (pf_18_44 * pf_18_44))));
				// 1062065548  <=>  {ftou2(({pf_17_19 : 0.0840449} * {f_11_28 : 9.566787})) : 1062065548}
                u_53_2 = ftou2((pf_17_19 * f_11_28));
				// 3206034970  <=>  {ftou2((sin({pf_25_19 : 5.646448}) * {f_16_31 : 1.00})) : 3206034970}
                u_42_6 = ftou2((sin(pf_25_19) * f_16_31));
				// 1062065548  <=>  {u_53_2 : 1062065548}
                u_43_7 = u_53_2;
				// 1062065549  <=>  {ftou2((cos({pf_25_19 : 5.646448}) * {f_16_31 : 1.00})) : 1062065549}
                u_44_7 = ftou2((cos(pf_25_19) * f_16_31));
				// 0  <=>  {ftou2((0.f * {f_16_31 : 1.00})) : 0}
                u_45_8 = ftou2((0.f * f_16_31));
				// 1058551321  <=>  {ftou2(({pf_18_44 : 0.06215} * {f_11_28 : 9.566787})) : 1058551321}
                u_46_8 = ftou2((pf_18_44 * f_11_28));
				// 3024436092  <=>  {ftou2(({pf_16_33 : -0.00} * {f_11_28 : 9.566787})) : 3024436092}
                u_47_8 = ftou2((pf_16_33 * f_11_28));
                u_42_phi_112 = u_42_6;
                u_43_phi_112 = u_43_7;
                u_44_phi_112 = u_44_7;
                u_45_phi_112 = u_45_8;
                u_46_phi_112 = u_46_8;
                u_47_phi_112 = u_47_8;
            }
			// 1031704823  <=>  {u_42_phi_112 : 1031704823}
            u_30_9 = u_42_phi_112;
			// 3209549197  <=>  {u_43_phi_112 : 3209549197}
            u_31_6 = u_43_phi_112;
			// 3182174141  <=>  {u_44_phi_112 : 3182174141}
            u_32_6 = u_44_phi_112;
			// 1065261309  <=>  {u_45_phi_112 : 1065261309}
            u_33_5 = u_45_phi_112;
			// 3206034970  <=>  {u_46_phi_112 : 3206034970}
            u_34_5 = u_46_phi_112;
			// 2147483648  <=>  {u_47_phi_112 : 2147483648}
            u_35_5 = u_47_phi_112;
            u_30_phi_110 = u_30_9;
            u_31_phi_110 = u_31_6;
            u_32_phi_110 = u_32_6;
            u_33_phi_110 = u_33_5;
            u_34_phi_110 = u_34_5;
            u_35_phi_110 = u_35_5;
        }
		// 1031704823  <=>  {u_30_phi_110 : 1031704823}
        u_12_16 = u_30_phi_110;
		// 3209549197  <=>  {u_31_phi_110 : 3209549197}
        u_20_12 = u_31_phi_110;
		// 3182174141  <=>  {u_32_phi_110 : 3182174141}
        u_21_6 = u_32_phi_110;
		// 1065261309  <=>  {u_33_phi_110 : 1065261309}
        u_22_5 = u_33_phi_110;
		// 3206034970  <=>  {u_34_phi_110 : 3206034970}
        u_23_6 = u_34_phi_110;
		// 2147483648  <=>  {u_35_phi_110 : 2147483648}
        u_24_5 = u_35_phi_110;
        u_12_phi_101 = u_12_16;
        u_20_phi_101 = u_20_12;
        u_21_phi_101 = u_21_6;
        u_22_phi_101 = u_22_5;
        u_23_phi_101 = u_23_6;
        u_24_phi_101 = u_24_5;
    }
	// -1.00  <=>  floor((((0.f - {pf_9_10 : 1.10134}) + {f_2_65 : 0.0625}) + ({f_2_65 : 0.0625} * {f_7_72 : 6.00})))
    f_11_29 = floor((((0.f - pf_9_10) + f_2_65) + (f_2_65 * f_7_72)));
	// -0.00  <=>  (({pf_12_8 : 0.00} * ({pf_23_9 : -0.8335257} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531})))) + ({pf_11_8 : 0.00} * ({pf_35_10 : -0.0895083} * inversesqrt((({pf_37_10 : -0.302587} * {pf_37_10 : -0.302587}) + {pf_38_7 : 0.908441})))))
    pf_18_47 = ((pf_12_8 * (pf_23_9 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4)))) + (pf_11_8 * (pf_35_10 * inversesqrt(((pf_37_10 * pf_37_10) + pf_38_7)))));
	// 0.1045283  <=>  cos(({pf_20_10 : 0.4666667} * 3.1415927f))
    f_13_3 = cos((pf_20_10 * 3.1415927f));
	// 0.3361601  <=>  ((((0.f - {pf_9_10 : 1.10134}) + {f_2_65 : 0.0625}) + ({f_2_65 : 0.0625} * {f_7_72 : 6.00})) + (0.f - {f_11_29 : -1.00}))
    pf_16_37 = ((((0.f - pf_9_10) + f_2_65) + (f_2_65 * f_7_72)) + (0.f - f_11_29));
	// -0.1045283  <=>  (0.f - {f_13_3 : 0.1045283})
    f_11_31 = (0.f - f_13_3);
	// 0.9890738  <=>  (({f_13_3 : 0.1045283} * {f_11_31 : -0.1045283}) + 1.f)
    pf_27_9 = ((f_13_3 * f_11_31) + 1.f);
	// -0.5153016  <=>  cos(({pf_16_37 : 0.3361601} * 6.2831855f))
    f_16_32 = cos((pf_16_37 * 6.2831855f));
	// 0.8570089  <=>  sin(({pf_16_37 : 0.3361601} * 6.2831855f))
    f_17_3 = sin((pf_16_37 * 6.2831855f));
	// -0.5124788  <=>  ({f_16_32 : -0.5153016} * sqrt({pf_27_9 : 0.9890738}))
    pf_18_49 = (f_16_32 * sqrt(pf_27_9));
	// 0.8523141  <=>  ({f_17_3 : 0.8570089} * sqrt({pf_27_9 : 0.9890738}))
    pf_27_10 = (f_17_3 * sqrt(pf_27_9));
	// 0.2735606  <=>  (({f_13_3 : 0.1045283} * {f_13_3 : 0.1045283}) + ({pf_18_49 : -0.5124788} * {pf_18_49 : -0.5124788}))
    pf_28_27 = ((f_13_3 * f_13_3) + (pf_18_49 * pf_18_49));
	// 1.00  <=>  inversesqrt((({pf_27_10 : 0.8523141} * {pf_27_10 : 0.8523141}) + {pf_28_27 : 0.2735606}))
    f_11_33 = inversesqrt(((pf_27_10 * pf_27_10) + pf_28_27));
	// 0.1045283  <=>  ({f_13_3 : 0.1045283} * {f_11_33 : 1.00})
    pf_28_29 = (f_13_3 * f_11_33);
	// 0.2626345  <=>  (({pf_18_49 : -0.5124788} * {f_11_33 : 1.00}) * ({pf_18_49 : -0.5124788} * {f_11_33 : 1.00}))
    pf_29_22 = ((pf_18_49 * f_11_33) * (pf_18_49 * f_11_33));
	// 0.2735606  <=>  (({pf_28_29 : 0.1045283} * {pf_28_29 : 0.1045283}) + {pf_29_22 : 0.2626345})
    pf_29_23 = ((pf_28_29 * pf_28_29) + pf_29_22);
	// 1.00  <=>  ((({pf_27_10 : 0.8523141} * {f_11_33 : 1.00}) * ({pf_27_10 : 0.8523141} * {f_11_33 : 1.00})) + {pf_29_23 : 0.2735606})
    pf_29_24 = (((pf_27_10 * f_11_33) * (pf_27_10 * f_11_33)) + pf_29_23);
	// 0.8523141  <=>  (({pf_27_10 : 0.8523141} * {f_11_33 : 1.00}) * inversesqrt({pf_29_24 : 1.00}))
    pf_30_15 = ((pf_27_10 * f_11_33) * inversesqrt(pf_29_24));
	// -0.5124788  <=>  (({pf_18_49 : -0.5124788} * {f_11_33 : 1.00}) * inversesqrt({pf_29_24 : 1.00}))
    pf_31_10 = ((pf_18_49 * f_11_33) * inversesqrt(pf_29_24));
	// 0.3760952  <=>  (({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * (0.f - ({pf_24_21 : 0.7996352} * {f_16_5 : 1.00})))
    pf_32_3 = ((pf_3_6 * f_4_29) * (0.f - (pf_24_21 * f_16_5)));
	// -0.8523141  <=>  ((0.f * ({pf_28_29 : 0.1045283} * inversesqrt({pf_29_24 : 1.00}))) + (0.f - {pf_30_15 : 0.8523141}))
    pf_33_8 = ((0.f * (pf_28_29 * inversesqrt(pf_29_24))) + (0.f - pf_30_15));
	// -0.5124788  <=>  ((0.f - 0.f) + {pf_31_10 : -0.5124788})
    pf_34_9 = ((0.f - 0.f) + pf_31_10);
	// 0.00  <=>  (({pf_12_8 : 0.00} * ({pf_14_11 : -0.2075762} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531})))) + ({pf_11_8 : 0.00} * ({pf_30_9 : 0.9489095} * inversesqrt((({pf_37_10 : -0.302587} * {pf_37_10 : -0.302587}) + {pf_38_7 : 0.908441})))))
    pf_19_23 = ((pf_12_8 * (pf_14_11 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4)))) + (pf_11_8 * (pf_30_9 * inversesqrt(((pf_37_10 * pf_37_10) + pf_38_7)))));
	// 1.005508  <=>  inversesqrt((({pf_34_9 : -0.5124788} * {pf_34_9 : -0.5124788}) + (({pf_33_8 : -0.8523141} * {pf_33_8 : -0.8523141}) + 0.f)))
    f_11_38 = inversesqrt(((pf_34_9 * pf_34_9) + ((pf_33_8 * pf_33_8) + 0.f)));
	// -0.00  <=>  ({pf_11_8 : 0.00} * ({pf_37_10 : -0.302587} * inversesqrt((({pf_37_10 : -0.302587} * {pf_37_10 : -0.302587}) + {pf_38_7 : 0.908441}))))
    pf_22_23 = (pf_11_8 * (pf_37_10 * inversesqrt(((pf_37_10 * pf_37_10) + pf_38_7))));
	// 0.8565017  <=>  ((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * (0.f - ({pf_25_20 : -0.5913184} * {f_16_5 : 1.00}))) + ((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * (0.f - {pf_26_17 : 0.1045283})) + {pf_32_3 : 0.3760952}))
    pf_32_5 = (((pf_7_2 * f_4_29) * (0.f - (pf_25_20 * f_16_5))) + (((pf_6_2 * f_4_29) * (0.f - pf_26_17)) + pf_32_3));
	// 0.00  <=>  (({pf_26_17 : 0.1045283} * (0.f + {pf_19_23 : 0.00})) + (({pf_24_21 : 0.7996352} * {f_16_5 : 1.00}) * (0.f + {pf_18_47 : -0.00})))
    pf_24_24 = ((pf_26_17 * (0.f + pf_19_23)) + ((pf_24_21 * f_16_5) * (0.f + pf_18_47)));
	// 0.00  <=>  (0.f + (({pf_12_8 : 0.00} * ({pf_21_6 : -0.4043915} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531})))) + {pf_22_23 : -0.00}))
    pf_22_25 = (0.f + ((pf_12_8 * (pf_21_6 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4)))) + pf_22_23));
	// 0.186421  <=>  (({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * (0.f - ({pf_14_11 : -0.2075762} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531})))))
    pf_34_10 = ((pf_7_2 * f_4_29) * (0.f - (pf_14_11 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4)))));
	// -0.0895083  <=>  ((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * (0.f - ({pf_21_6 : -0.4043915} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))))) + (0.f - {pf_34_10 : 0.186421}))
    pf_34_11 = (((pf_6_2 * f_4_29) * (0.f - (pf_21_6 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))))) + (0.f - pf_34_10));
	// 0.0538636  <=>  ((({pf_28_29 : 0.1045283} * inversesqrt({pf_29_24 : 1.00})) * ({pf_34_9 : -0.5124788} * (0.f - {f_11_38 : 1.005508}))) + (0.f - ({pf_30_15 : 0.8523141} * (0.f * (0.f - {f_11_38 : 1.005508})))))
    pf_32_7 = (((pf_28_29 * inversesqrt(pf_29_24)) * (pf_34_9 * (0.f - f_11_38))) + (0.f - (pf_30_15 * (0.f * (0.f - f_11_38)))));
	// 0.2640812  <=>  (0.f - ({pf_31_10 : -0.5124788} * ({pf_34_9 : -0.5124788} * (0.f - {f_11_38 : 1.005508}))))
    f_11_43 = (0.f - (pf_31_10 * (pf_34_9 * (0.f - f_11_38))));
	// 0.994522  <=>  (({pf_30_15 : 0.8523141} * ({pf_33_8 : -0.8523141} * (0.f - {f_11_38 : 1.005508}))) + {f_11_43 : 0.2640812})
    pf_33_10 = ((pf_30_15 * (pf_33_8 * (0.f - f_11_38))) + f_11_43);
	// -0.2003331  <=>  (({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * (0.f - ({pf_21_6 : -0.4043915} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531})))))
    pf_35_14 = ((pf_3_6 * f_4_29) * (0.f - (pf_21_6 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4)))));
	// 0.00  <=>  (((({pf_25_20 : -0.5913184} * {f_16_5 : 1.00}) * {pf_22_25 : 0.00}) + {pf_24_24 : 0.00}) * (1.0f / {pf_32_5 : 0.8565017}))
    pf_24_26 = ((((pf_25_20 * f_16_5) * pf_22_25) + pf_24_24) * (1.0f / pf_32_5));
	// -0.0895817  <=>  (({pf_31_10 : -0.5124788} * (0.f * (0.f - {f_11_38 : 1.005508}))) + (0.f - (({pf_28_29 : 0.1045283} * inversesqrt({pf_29_24 : 1.00})) * ({pf_33_8 : -0.8523141} * (0.f - {f_11_38 : 1.005508})))))
    pf_25_23 = ((pf_31_10 * (0.f * (0.f - f_11_38))) + (0.f - ((pf_28_29 * inversesqrt(pf_29_24)) * (pf_33_8 * (0.f - f_11_38)))));
	// 0.8779377  <=>  (0.f - ({pf_23_9 : -0.8335257} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))))
    f_11_46 = (0.f - (pf_23_9 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))));
	// 0.8779377  <=>  (0.f - ({pf_23_9 : -0.8335257} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))))
    f_11_47 = (0.f - (pf_23_9 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))));
	// 0.9489095  <=>  ((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * {f_11_47 : 0.8779377}) + (0.f - {pf_35_14 : -0.2003331}))
    pf_35_15 = (((pf_7_2 * f_4_29) * f_11_47) + (0.f - pf_35_14));
	// -0.199755  <=>  (0.f - (({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * {f_11_46 : 0.8779377}))
    f_13_8 = (0.f - ((pf_6_2 * f_4_29) * f_11_46));
	// -0.302587  <=>  ((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * (0.f - ({pf_14_11 : -0.2075762} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531}))))) + {f_13_8 : -0.199755})
    pf_26_20 = (((pf_3_6 * f_4_29) * (0.f - (pf_14_11 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4))))) + f_13_8);
	// 2147483648  <=>  {ftou2((0.f * (0.f - {f_11_38 : 1.005508}))) : 2147483648}
    u_15_21 = ftou2((0.f * (0.f - f_11_38)));
    u_15_phi_113 = u_15_21;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 0  <=>  0u
        u_15_22 = 0u;
        u_15_phi_113 = u_15_22;
    }
	// 1.00  <=>  (({pf_25_23 : -0.0895817} * {pf_25_23 : -0.0895817}) + (({pf_33_10 : 0.994522} * {pf_33_10 : 0.994522}) + ({pf_32_7 : 0.0538636} * {pf_32_7 : 0.0538636})))
    pf_36_16 = ((pf_25_23 * pf_25_23) + ((pf_33_10 * pf_33_10) + (pf_32_7 * pf_32_7)));
	// -0.00  <=>  (((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * {pf_24_26 : 0.00}) + (0.f + {pf_19_23 : 0.00})) * {utof2(u_24_phi_101) : -0.00})
    pf_38_9 = ((((pf_6_2 * f_4_29) * pf_24_26) + (0.f + pf_19_23)) * utof2(u_24_phi_101));
	// 2147483648  <=>  {u_24_phi_101 : 2147483648}
    u_0_19 = u_24_phi_101;
    u_0_phi_114 = u_0_19;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
        u_0_20 = ftou2((pf_9_10 * 6.2831855f));
        u_0_phi_114 = u_0_20;
    }
	// 0.00  <=>  (((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * {pf_24_26 : 0.00}) + (0.f + {pf_19_23 : 0.00})) * {utof2(u_22_phi_101) : 0.9945219})
    pf_19_26 = ((((pf_6_2 * f_4_29) * pf_24_26) + (0.f + pf_19_23)) * utof2(u_22_phi_101));
	// 0.00  <=>  ((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * {pf_24_26 : 0.00}) + {pf_22_25 : 0.00})
    pf_22_26 = (((pf_7_2 * f_4_29) * pf_24_26) + pf_22_25);
	// 1.00  <=>  inversesqrt((({pf_26_20 : -0.302587} * {pf_26_20 : -0.302587}) + (({pf_35_15 : 0.9489095} * {pf_35_15 : 0.9489095}) + ({pf_34_11 : -0.0895083} * {pf_34_11 : -0.0895083}))))
    f_13_10 = inversesqrt(((pf_26_20 * pf_26_20) + ((pf_35_15 * pf_35_15) + (pf_34_11 * pf_34_11))));
	// 1065261309  <=>  {u_22_phi_101 : 1065261309}
    u_16_21 = u_22_phi_101;
    u_16_phi_115 = u_16_21;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 2147483648  <=>  {u_0_phi_114 : 2147483648}
        u_16_22 = u_0_phi_114;
        u_16_phi_115 = u_16_22;
    }
	// 1062954224  <=>  {ftou2(({pf_33_8 : -0.8523141} * (0.f - {f_11_38 : 1.005508}))) : 1062954224}
    u_0_21 = ftou2((pf_33_8 * (0.f - f_11_38)));
    u_0_phi_116 = u_0_21;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 1062643671  <=>  {ftou2(sin({utof2(u_16_phi_115) : 0.9945219})) : 1062643671}
        u_0_22 = ftou2(sin( utof2(u_16_phi_115)));
        u_0_phi_116 = u_0_22;
    }
	// 0.0538636  <=>  ({pf_32_7 : 0.0538636} * inversesqrt({pf_36_16 : 1.00}))
    pf_24_28 = (pf_32_7 * inversesqrt(pf_36_16));
	// 1029480469  <=>  {ftou2(pf_24_28) : 1029480469}
    u_17_8 = ftou2(pf_24_28);
    u_17_phi_117 = u_17_8;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 1057717969  <=>  {ftou2(cos({utof2(u_16_phi_115) : 0.9945219})) : 1057717969}
        u_17_9 = ftou2(cos( utof2(u_16_phi_115)));
        u_17_phi_117 = u_17_9;
    }
	// 1065261310  <=>  {ftou2(({pf_33_10 : 0.994522} * inversesqrt({pf_36_16 : 1.00}))) : 1065261310}
    u_14_29 = ftou2((pf_33_10 * inversesqrt(pf_36_16)));
	// 1065261310  <=>  {u_14_29 : 1065261310}
    u_19_7 = u_14_29;
    u_19_phi_118 = u_19_7;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 0  <=>  0u
        u_19_8 = 0u;
        u_19_phi_118 = u_19_8;
    }
	// 0.50  <=>  ((({pf_22_26 : 0.00} * {utof2(u_20_phi_101) : -0.8040398}) + ((((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * {pf_24_26 : 0.00}) + (0.f + {pf_18_47 : -0.00})) * {utof2(u_23_phi_101) : -0.5945755}) + {pf_38_9 : -0.00})) + 0.5f)
    pf_19_28 = (((pf_22_26 * utof2(u_20_phi_101)) + (((((pf_3_6 * f_4_29) * pf_24_26) + (0.f + pf_18_47)) * utof2(u_23_phi_101)) + pf_38_9)) + 0.5f);
	// 0.50  <=>  ((({pf_22_26 : 0.00} * {utof2(u_12_phi_101) : 0.06215}) + ((((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * {pf_24_26 : 0.00}) + (0.f + {pf_18_47 : -0.00})) * {utof2(u_21_phi_101) : -0.0840449}) + {pf_19_26 : 0.00})) + 0.5f)
    pf_17_25 = (((pf_22_26 * utof2(u_12_phi_101)) + (((((pf_3_6 * f_4_29) * pf_24_26) + (0.f + pf_18_47)) * utof2(u_21_phi_101)) + pf_19_26)) + 0.5f);
	// 0.50  <=>  clamp({pf_17_25 : 0.50}, 0.0, 1.0)
    f_13_11 = clamp(pf_17_25, 0.0, 1.0);
	// 3182917275  <=>  {ftou2(({pf_25_23 : -0.0895817} * inversesqrt({pf_36_16 : 1.00}))) : 3182917275}
    u_14_30 = ftou2((pf_25_23 * inversesqrt(pf_36_16)));
    u_14_phi_119 = u_14_30;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 3210437872  <=>  {ftou2(((0.f - {utof2(u_0_phi_116) : 0.8570089}) + (0.f - 0.f))) : 3210437872}
        u_14_31 = ftou2(((0.f - utof2(u_0_phi_116)) + (0.f - 0.f)));
        u_14_phi_119 = u_14_31;
    }
	// 1057221327  <=>  {ftou2(({pf_34_9 : -0.5124788} * (0.f - {f_11_38 : 1.005508}))) : 1057221327}
    u_12_18 = ftou2((pf_34_9 * (0.f - f_11_38)));
    u_12_phi_120 = u_12_18;
	// False  <=>  if((({u_17_0 : 7} == 0u) ? true : false))
    if (((u_17_0 == 0u) ? true : false))
    {
		// 1029480469  <=>  {u_17_phi_117 : 1029480469}
        u_12_19 = u_17_phi_117;
        u_12_phi_120 = u_12_19;
    }
	// False  <=>  (({u_17_0 : 7} == 0u) ? true : false)
    b_3_76 = ((u_17_0 == 0u) ? true : false);
	// 3182917275  <=>  {u_14_phi_119 : 3182917275}
    u_10_23 = u_14_phi_119;
	// 1057221327  <=>  {u_12_phi_120 : 1057221327}
    u_20_14 = u_12_phi_120;
	// 1029480469  <=>  {u_17_phi_117 : 1029480469}
    u_21_7 = u_17_phi_117;
	// 1062954224  <=>  {u_0_phi_116 : 1062954224}
    u_22_6 = u_0_phi_116;
	// 1065261310  <=>  {u_19_phi_118 : 1065261310}
    u_23_7 = u_19_phi_118;
	// 2147483648  <=>  {u_15_phi_113 : 2147483648}
    u_24_6 = u_15_phi_113;
    b_3_phi_121 = b_3_76;
    u_10_phi_121 = u_10_23;
    u_20_phi_121 = u_20_14;
    u_21_phi_121 = u_21_7;
    u_22_phi_121 = u_22_6;
    u_23_phi_121 = u_23_7;
    u_24_phi_121 = u_24_6;
	// True  <=>  if(((! ({u_17_0 : 7} == 0u)) ? true : false))
    if (((!(u_17_0 == 0u)) ? true : false))
    {
		// 1065261309  <=>  {u_16_phi_115 : 1065261309}
        u_25_8 = u_16_phi_115;
        u_25_phi_122 = u_25_8;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
            u_25_9 = ftou2((pf_9_10 * 6.2831855f));
            u_25_phi_122 = u_25_9;
        }
		// 2147483648  <=>  {u_15_phi_113 : 2147483648}
        u_16_23 = u_15_phi_113;
        u_16_phi_123 = u_16_23;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 0  <=>  0u
            u_16_24 = 0u;
            u_16_phi_123 = u_16_24;
        }
		// 1065261310  <=>  {u_19_phi_118 : 1065261310}
        u_26_10 = u_19_phi_118;
        u_26_phi_124 = u_26_10;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 0  <=>  0u
            u_26_11 = 0u;
            u_26_phi_124 = u_26_11;
        }
		// 1065261309  <=>  {u_25_phi_122 : 1065261309}
        u_27_10 = u_25_phi_122;
        u_27_phi_125 = u_27_10;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1065261309  <=>  {u_25_phi_122 : 1065261309}
            u_27_11 = u_25_phi_122;
            u_27_phi_125 = u_27_11;
        }
		// 1057221327  <=>  {u_12_phi_120 : 1057221327}
        u_25_10 = u_12_phi_120;
        u_25_phi_126 = u_25_10;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1057717969  <=>  {ftou2(cos({utof2(u_27_phi_125) : 0.9945219})) : 1057717969}
            u_25_11 = ftou2(cos( utof2(u_27_phi_125)));
            u_25_phi_126 = u_25_11;
        }
		// 1062954224  <=>  {u_0_phi_116 : 1062954224}
        u_28_13 = u_0_phi_116;
        u_28_phi_127 = u_28_13;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1062643671  <=>  {ftou2(sin({utof2(u_27_phi_125) : 0.9945219})) : 1062643671}
            u_28_14 = ftou2(sin( utof2(u_27_phi_125)));
            u_28_phi_127 = u_28_14;
        }
		// 1029480469  <=>  {u_17_phi_117 : 1029480469}
        u_27_13 = u_17_phi_117;
        u_27_phi_128 = u_27_13;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 3204704975  <=>  {ftou2(((0.f - {utof2(u_25_phi_126) : 0.5153016}) + (0.f - 0.f))) : 3204704975}
            u_27_14 = ftou2(((0.f - utof2(u_25_phi_126)) + (0.f - 0.f)));
            u_27_phi_128 = u_27_14;
        }
		// 3182917275  <=>  {u_14_phi_119 : 3182917275}
        u_29_10 = u_14_phi_119;
        u_29_phi_129 = u_29_10;
		// False  <=>  if((({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_17_0 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1062954224  <=>  {u_28_phi_127 : 1062954224}
            u_29_11 = u_28_phi_127;
            u_29_phi_129 = u_29_11;
        }
		// False  <=>  (({u_17_0 : 7} == 0u) ? true : false)
        b_2_19 = ((u_17_0 == 0u) ? true : false);
		// 1065261310  <=>  {u_26_phi_124 : 1065261310}
        u_30_10 = u_26_phi_124;
		// 3182917275  <=>  {u_29_phi_129 : 3182917275}
        u_31_7 = u_29_phi_129;
		// 1057221327  <=>  {u_25_phi_126 : 1057221327}
        u_32_7 = u_25_phi_126;
		// 1062954224  <=>  {u_28_phi_127 : 1062954224}
        u_33_6 = u_28_phi_127;
		// 2147483648  <=>  {u_16_phi_123 : 2147483648}
        u_34_6 = u_16_phi_123;
		// 1029480469  <=>  {u_27_phi_128 : 1029480469}
        u_35_6 = u_27_phi_128;
        b_2_phi_130 = b_2_19;
        u_30_phi_130 = u_30_10;
        u_31_phi_130 = u_31_7;
        u_32_phi_130 = u_32_7;
        u_33_phi_130 = u_33_6;
        u_34_phi_130 = u_34_6;
        u_35_phi_130 = u_35_6;
		// True  <=>  if(((! ({u_17_0 : 7} == ({u_1_20 : 16} + 4294967295u))) ? true : false))
        if (((!(u_17_0 == (u_1_20 + 4294967295u))) ? true : false))
        {
			// False  <=>  (((((0.f - {pf_20_10 : 0.4666667}) + 1.f) < float(1e-05)) && (! isnan(((0.f - {pf_20_10 : 0.4666667}) + 1.f)))) && (! isnan(float(1e-05))))
            b_5_7 = (((((0.f - pf_20_10) + 1.f) < float(1e-05)) && (!isnan(((0.f - pf_20_10) + 1.f)))) && (!isnan(float(1e-05))));
			// False  <=>  (((({pf_20_10 : 0.4666667} < float(1e-05)) && (! isnan({pf_20_10 : 0.4666667}))) && (! isnan(float(1e-05)))) ? true : false)
            b_6_9 = ((((pf_20_10 < float(1e-05)) && (!isnan(pf_20_10))) && (!isnan(float(1e-05)))) ? true : false);
			// 1065261310  <=>  {u_26_phi_124 : 1065261310}
            u_36_6 = u_26_phi_124;
			// 3182917275  <=>  {u_29_phi_129 : 3182917275}
            u_37_6 = u_29_phi_129;
			// 1057221327  <=>  {u_25_phi_126 : 1057221327}
            u_38_6 = u_25_phi_126;
			// 1062954224  <=>  {u_28_phi_127 : 1062954224}
            u_39_6 = u_28_phi_127;
			// 2147483648  <=>  {u_16_phi_123 : 2147483648}
            u_40_6 = u_16_phi_123;
			// 1029480469  <=>  {u_27_phi_128 : 1029480469}
            u_41_6 = u_27_phi_128;
            u_36_phi_131 = u_36_6;
            u_37_phi_131 = u_37_6;
            u_38_phi_131 = u_38_6;
            u_39_phi_131 = u_39_6;
            u_40_phi_131 = u_40_6;
            u_41_phi_131 = u_41_6;
			// False  <=>  if({b_6_9 : False})
            if (b_6_9)
            {
				// 0.5153019  <=>  cos((({pf_16_37 : 0.3361601} * 6.2831855f) + 3.1415927f))
                f_18_21 = cos(((pf_16_37 * 6.2831855f) + 3.1415927f));
				// -0.8570087  <=>  sin((({pf_16_37 : 0.3361601} * 6.2831855f) + 3.1415927f))
                f_19_2 = sin(((pf_16_37 * 6.2831855f) + 3.1415927f));
				// 1.00  <=>  inversesqrt((({f_19_2 : -0.8570087} * {f_19_2 : -0.8570087}) + (({f_18_21 : 0.5153019} * {f_18_21 : 0.5153019}) + 0.f)))
                f_20_0 = inversesqrt(((f_19_2 * f_19_2) + ((f_18_21 * f_18_21) + 0.f)));
				// 0.0895817  <=>  (0.f - (({pf_28_29 : 0.1045283} * inversesqrt({pf_29_24 : 1.00})) * ({f_19_2 : -0.8570087} * {f_20_0 : 1.00})))
                f_18_22 = (0.f - ((pf_28_29 * inversesqrt(pf_29_24)) * (f_19_2 * f_20_0)));
				// 0.0895817  <=>  (({pf_30_15 : 0.8523141} * (0.f * {f_20_0 : 1.00})) + {f_18_22 : 0.0895817})
                pf_19_30 = ((pf_30_15 * (0.f * f_20_0)) + f_18_22);
				// -0.4391991  <=>  (0.f - ({pf_30_15 : 0.8523141} * ({f_18_21 : 0.5153019} * {f_20_0 : 1.00})))
                f_18_23 = (0.f - (pf_30_15 * (f_18_21 * f_20_0)));
				// -0.0000004  <=>  (({pf_31_10 : -0.5124788} * ({f_19_2 : -0.8570087} * {f_20_0 : 1.00})) + {f_18_23 : -0.4391991})
                pf_16_42 = ((pf_31_10 * (f_19_2 * f_20_0)) + f_18_23);
				// 0.0538636  <=>  ((({pf_28_29 : 0.1045283} * inversesqrt({pf_29_24 : 1.00})) * ({f_18_21 : 0.5153019} * {f_20_0 : 1.00})) + (0.f - ({pf_31_10 : -0.5124788} * (0.f * {f_20_0 : 1.00}))))
                pf_17_31 = (((pf_28_29 * inversesqrt(pf_29_24)) * (f_18_21 * f_20_0)) + (0.f - (pf_31_10 * (0.f * f_20_0))));
				// 0.0080249  <=>  (({pf_16_42 : -0.0000004} * {pf_16_42 : -0.0000004}) + ({pf_19_30 : 0.0895817} * {pf_19_30 : 0.0895817}))
                pf_20_13 = ((pf_16_42 * pf_16_42) + (pf_19_30 * pf_19_30));
				// 0.0109262  <=>  (({pf_17_31 : 0.0538636} * {pf_17_31 : 0.0538636}) + {pf_20_13 : 0.0080249})
                pf_20_14 = ((pf_17_31 * pf_17_31) + pf_20_13);
				// -0.0000034  <=>  ({pf_16_42 : -0.0000004} * inversesqrt({pf_20_14 : 0.0109262}))
                pf_16_43 = (pf_16_42 * inversesqrt(pf_20_14));
				// 0.5153019  <=>  ({pf_17_31 : 0.0538636} * inversesqrt({pf_20_14 : 0.0109262}))
                pf_16_44 = (pf_17_31 * inversesqrt(pf_20_14));
				// 0  <=>  {ftou2((0.f * {f_20_0 : 1.00})) : 0}
                u_36_7 = ftou2((0.f * f_20_0));
				// 3210437868  <=>  {ftou2(({f_19_2 : -0.8570087} * {f_20_0 : 1.00})) : 3210437868}
                u_37_7 = ftou2((f_19_2 * f_20_0));
				// 1057221332  <=>  {ftou2(pf_16_44) : 1057221332}
                u_38_7 = ftou2(pf_16_44);
				// 1062954219  <=>  {ftou2(({pf_19_30 : 0.0895817} * inversesqrt({pf_20_14 : 0.0109262}))) : 1062954219}
                u_39_7 = ftou2((pf_19_30 * inversesqrt(pf_20_14)));
				// 3060153332  <=>  {ftou2(pf_16_43) : 3060153332}
                u_40_7 = ftou2(pf_16_43);
				// 1057221332  <=>  {ftou2(({f_18_21 : 0.5153019} * {f_20_0 : 1.00})) : 1057221332}
                u_41_7 = ftou2((f_18_21 * f_20_0));
                u_36_phi_131 = u_36_7;
                u_37_phi_131 = u_37_7;
                u_38_phi_131 = u_38_7;
                u_39_phi_131 = u_39_7;
                u_40_phi_131 = u_40_7;
                u_41_phi_131 = u_41_7;
            }
			// 1065261310  <=>  {u_36_phi_131 : 1065261310}
            u_42_8 = u_36_phi_131;
			// 3182917275  <=>  {u_37_phi_131 : 3182917275}
            u_43_9 = u_37_phi_131;
			// 1057221327  <=>  {u_38_phi_131 : 1057221327}
            u_44_9 = u_38_phi_131;
			// 1062954224  <=>  {u_39_phi_131 : 1062954224}
            u_45_10 = u_39_phi_131;
			// 2147483648  <=>  {u_40_phi_131 : 2147483648}
            u_46_10 = u_40_phi_131;
			// 1029480469  <=>  {u_41_phi_131 : 1029480469}
            u_47_10 = u_41_phi_131;
            u_42_phi_132 = u_42_8;
            u_43_phi_132 = u_43_9;
            u_44_phi_132 = u_44_9;
            u_45_phi_132 = u_45_10;
            u_46_phi_132 = u_46_10;
            u_47_phi_132 = u_47_10;
			// False  <=>  if(({b_5_7 : False} ? true : false))
            if ((b_5_7 ? true : false))
            {
				// 1.00  <=>  inversesqrt((({f_17_3 : 0.8570089} * {f_17_3 : 0.8570089}) + (({f_16_32 : -0.5153016} * {f_16_32 : -0.5153016}) + 0.f)))
                f_18_26 = inversesqrt(((f_17_3 * f_17_3) + ((f_16_32 * f_16_32) + 0.f)));
				// -0.0895817  <=>  (0.f - (({pf_28_29 : 0.1045283} * inversesqrt({pf_29_24 : 1.00})) * ({f_17_3 : 0.8570089} * {f_18_26 : 1.00})))
                f_16_33 = (0.f - ((pf_28_29 * inversesqrt(pf_29_24)) * (f_17_3 * f_18_26)));
				// -0.0895817  <=>  (({pf_30_15 : 0.8523141} * (0.f * {f_18_26 : 1.00})) + {f_16_33 : -0.0895817})
                pf_19_33 = ((pf_30_15 * (0.f * f_18_26)) + f_16_33);
				// 0.4391989  <=>  (0.f - ({pf_30_15 : 0.8523141} * ({f_16_32 : -0.5153016} * {f_18_26 : 1.00})))
                f_16_34 = (0.f - (pf_30_15 * (f_16_32 * f_18_26)));
				// -0.00  <=>  (({pf_31_10 : -0.5124788} * ({f_17_3 : 0.8570089} * {f_18_26 : 1.00})) + {f_16_34 : 0.4391989})
                pf_16_48 = ((pf_31_10 * (f_17_3 * f_18_26)) + f_16_34);
				// -0.0538636  <=>  ((({pf_28_29 : 0.1045283} * inversesqrt({pf_29_24 : 1.00})) * ({f_16_32 : -0.5153016} * {f_18_26 : 1.00})) + (0.f - ({pf_31_10 : -0.5124788} * (0.f * {f_18_26 : 1.00}))))
                pf_17_33 = (((pf_28_29 * inversesqrt(pf_29_24)) * (f_16_32 * f_18_26)) + (0.f - (pf_31_10 * (0.f * f_18_26))));
				// 0.0080249  <=>  (({pf_16_48 : -0.00} * {pf_16_48 : -0.00}) + ({pf_19_33 : -0.0895817} * {pf_19_33 : -0.0895817}))
                pf_20_17 = ((pf_16_48 * pf_16_48) + (pf_19_33 * pf_19_33));
				// 0.0109262  <=>  (({pf_17_33 : -0.0538636} * {pf_17_33 : -0.0538636}) + {pf_20_17 : 0.0080249})
                pf_20_18 = ((pf_17_33 * pf_17_33) + pf_20_17);
				// -0.00  <=>  ({pf_16_48 : -0.00} * inversesqrt({pf_20_18 : 0.0109262}))
                pf_16_49 = (pf_16_48 * inversesqrt(pf_20_18));
				// -0.5153016  <=>  ({pf_17_33 : -0.0538636} * inversesqrt({pf_20_18 : 0.0109262}))
                pf_16_50 = (pf_17_33 * inversesqrt(pf_20_18));
				// 0  <=>  {ftou2((0.f * {f_18_26 : 1.00})) : 0}
                u_42_9 = ftou2((0.f * f_18_26));
				// 1062954223  <=>  {ftou2(({f_17_3 : 0.8570089} * {f_18_26 : 1.00})) : 1062954223}
                u_43_10 = ftou2((f_17_3 * f_18_26));
				// 3204704974  <=>  {ftou2(pf_16_50) : 3204704974}
                u_44_10 = ftou2(pf_16_50);
				// 3210437871  <=>  {ftou2(({pf_19_33 : -0.0895817} * inversesqrt({pf_20_18 : 0.0109262}))) : 3210437871}
                u_45_11 = ftou2((pf_19_33 * inversesqrt(pf_20_18)));
				// 2991398974  <=>  {ftou2(pf_16_49) : 2991398974}
                u_46_11 = ftou2(pf_16_49);
				// 3204704975  <=>  {ftou2(({f_16_32 : -0.5153016} * {f_18_26 : 1.00})) : 3204704975}
                u_47_11 = ftou2((f_16_32 * f_18_26));
                u_42_phi_132 = u_42_9;
                u_43_phi_132 = u_43_10;
                u_44_phi_132 = u_44_10;
                u_45_phi_132 = u_45_11;
                u_46_phi_132 = u_46_11;
                u_47_phi_132 = u_47_11;
            }
			// False  <=>  ({b_5_7 : False} ? true : false)
            b_2_20 = (b_5_7 ? true : false);
			// 1065261310  <=>  {u_42_phi_132 : 1065261310}
            u_30_11 = u_42_phi_132;
			// 3182917275  <=>  {u_43_phi_132 : 3182917275}
            u_31_8 = u_43_phi_132;
			// 1057221327  <=>  {u_44_phi_132 : 1057221327}
            u_32_8 = u_44_phi_132;
			// 1062954224  <=>  {u_45_phi_132 : 1062954224}
            u_33_7 = u_45_phi_132;
			// 2147483648  <=>  {u_46_phi_132 : 2147483648}
            u_34_7 = u_46_phi_132;
			// 1029480469  <=>  {u_47_phi_132 : 1029480469}
            u_35_7 = u_47_phi_132;
            b_2_phi_130 = b_2_20;
            u_30_phi_130 = u_30_11;
            u_31_phi_130 = u_31_8;
            u_32_phi_130 = u_32_8;
            u_33_phi_130 = u_33_7;
            u_34_phi_130 = u_34_7;
            u_35_phi_130 = u_35_7;
        }
		// False  <=>  ({b_2_phi_130 : False} ? true : false)
        b_3_77 = (b_2_phi_130 ? true : false);
		// 3182917275  <=>  {u_31_phi_130 : 3182917275}
        u_10_24 = u_31_phi_130;
		// 1057221327  <=>  {u_32_phi_130 : 1057221327}
        u_20_15 = u_32_phi_130;
		// 1029480469  <=>  {u_35_phi_130 : 1029480469}
        u_21_8 = u_35_phi_130;
		// 1062954224  <=>  {u_33_phi_130 : 1062954224}
        u_22_7 = u_33_phi_130;
		// 1065261310  <=>  {u_30_phi_130 : 1065261310}
        u_23_8 = u_30_phi_130;
		// 2147483648  <=>  {u_34_phi_130 : 2147483648}
        u_24_7 = u_34_phi_130;
        b_3_phi_121 = b_3_77;
        u_10_phi_121 = u_10_24;
        u_20_phi_121 = u_20_15;
        u_21_phi_121 = u_21_8;
        u_22_phi_121 = u_22_7;
        u_23_phi_121 = u_23_8;
        u_24_phi_121 = u_24_7;
    }
	// 6.50  <=>  ({f_8_9 : 6.00} + {f_10_84 : 0.50})
    pf_20_19 = (f_8_9 + f_10_84);
	// -0.00  <=>  (({pf_12_8 : 0.00} * ({pf_23_9 : -0.8335257} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531})))) + ({pf_11_8 : 0.00} * ({pf_34_11 : -0.0895083} * {f_13_10 : 1.00})))
    pf_16_52 = ((pf_12_8 * (pf_23_9 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4)))) + (pf_11_8 * (pf_34_11 * f_13_10)));
	// 0.5124788  <=>  (0.f - ({pf_18_49 : -0.5124788} * {f_11_33 : 1.00}))
    f_8_10 = (0.f - (pf_18_49 * f_11_33));
	// -0.2410359  <=>  (({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * {f_8_10 : 0.5124788})
    pf_23_11 = ((pf_3_6 * f_4_29) * f_8_10);
	// 0.00  <=>  (0.f + (({pf_12_8 : 0.00} * ({pf_14_11 : -0.2075762} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531})))) + ({pf_11_8 : 0.00} * ({pf_35_15 : 0.9489095} * {f_13_10 : 1.00}))))
    pf_14_14 = (0.f + ((pf_12_8 * (pf_14_11 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4)))) + (pf_11_8 * (pf_35_15 * f_13_10))));
	// 0.00  <=>  (0.f + (({pf_12_8 : 0.00} * ({pf_21_6 : -0.4043915} * inversesqrt((({pf_21_6 : -0.4043915} * {pf_21_6 : -0.4043915}) + {pf_24_4 : 0.7378531})))) + ({pf_11_8 : 0.00} * ({pf_26_20 : -0.302587} * {f_13_10 : 1.00}))))
    pf_11_11 = (0.f + ((pf_12_8 * (pf_21_6 * inversesqrt(((pf_21_6 * pf_21_6) + pf_24_4)))) + (pf_11_8 * (pf_26_20 * f_13_10))));
	// -0.00  <=>  (({pf_18_49 : -0.5124788} * {f_11_33 : 1.00}) * (0.f + {pf_16_52 : -0.00}))
    pf_18_51 = ((pf_18_49 * f_11_33) * (0.f + pf_16_52));
	// 7.00  <=>  floor((((1.0f / float(int({u_1_20 : 16}))) * (float(int({u_17_0 : 7})) + {f_13_11 : 0.50})) * {utof(vs_cbuf9_78.w) : 16.00}))
    f_8_13 = floor((((1.0f / float(int(u_1_20))) * (float(int(u_17_0)) + f_13_11)) * utof(vs_cbuf9_78.w)));
	// 7  <=>  int(clamp({f_8_13 : 7.00}, float(-2147483600.f), float(2147483600.f)))
    u_0_23 = int(clamp(f_8_13, float(-2147483600.f), float(2147483600.f)));
	// False  <=>  isnan((((1.0f / float(int({u_1_20 : 16}))) * (float(int({u_17_0 : 7})) + {f_13_11 : 0.50})) * {utof(vs_cbuf9_78.w) : 16.00}))
    b_1_48 = isnan((((1.0f / float(int(u_1_20))) * (float(int(u_17_0)) + f_13_11)) * utof(vs_cbuf9_78.w)));
	// -0.8523141  <=>  (0.f - ({pf_27_10 : 0.8523141} * {f_11_33 : 1.00}))
    f_8_15 = (0.f - (pf_27_10 * f_11_33));
	// -0.9915474  <=>  ((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * {f_8_15 : -0.8523141}) + ((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * (0.f - {pf_28_29 : 0.1045283})) + {pf_23_11 : -0.2410359}))
    pf_12_11 = (((pf_7_2 * f_4_29) * f_8_15) + (((pf_6_2 * f_4_29) * (0.f - pf_28_29)) + pf_23_11));
	// 6.00  <=>  floor((((1.0f / float(int({u_1_20 : 16}))) * {pf_20_19 : 6.50}) * {utof(vs_cbuf9_78.w) : 16.00}))
    f_9_32 = floor((((1.0f / float(int(u_1_20))) * pf_20_19) * utof(vs_cbuf9_78.w)));
	// False  <=>  isnan((((1.0f / float(int({u_1_20 : 16}))) * {pf_20_19 : 6.50}) * {utof(vs_cbuf9_78.w) : 16.00}))
    b_1_49 = isnan((((1.0f / float(int(u_1_20))) * pf_20_19) * utof(vs_cbuf9_78.w)));
	// 0.00  <=>  ((({pf_27_10 : 0.8523141} * {f_11_33 : 1.00}) * {pf_11_11 : 0.00}) + (({pf_28_29 : 0.1045283} * {pf_14_14 : 0.00}) + {pf_18_51 : -0.00}))
    pf_18_53 = (((pf_27_10 * f_11_33) * pf_11_11) + ((pf_28_29 * pf_14_14) + pf_18_51));
	// -0.00  <=>  ({pf_18_53 : 0.00} * (1.0f / {pf_12_11 : -0.9915474}))
    pf_18_54 = (pf_18_53 * (1.0f / pf_12_11));
	// 0.00  <=>  ((({pf_7_2 : 0.8526533} * {f_4_29 : 1.00}) * {pf_18_54 : -0.00}) + {pf_11_11 : 0.00})
    pf_7_4 = (((pf_7_2 * f_4_29) * pf_18_54) + pf_11_11);
	// 6.00  <=>  floor((((1.0f / float(int({u_1_20 : 16}))) * ({f_8_9 : 6.00} + {f_15_0 : 0.50})) * {utof(vs_cbuf9_78.w) : 16.00}))
    f_13_12 = floor((((1.0f / float(int(u_1_20))) * (f_8_9 + f_15_0)) * utof(vs_cbuf9_78.w)));
	// 6.00  <=>  clamp({f_13_12 : 6.00}, float(-2147483600.f), float(2147483600.f))
    f_13_13 = clamp(f_13_12, float(-2147483600.f), float(2147483600.f));
	// False  <=>  isnan((((1.0f / float(int({u_1_20 : 16}))) * ({f_8_9 : 6.00} + {f_15_0 : 0.50})) * {utof(vs_cbuf9_78.w) : 16.00}))
    b_1_50 = isnan((((1.0f / float(int(u_1_20))) * (f_8_9 + f_15_0)) * utof(vs_cbuf9_78.w)));
	// -0.00  <=>  (((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * {pf_18_54 : -0.00}) + {pf_14_14 : 0.00}) * {utof2(u_24_phi_121) : -0.00})
    pf_11_12 = ((((pf_6_2 * f_4_29) * pf_18_54) + pf_14_14) * utof2(u_24_phi_121));
	// 0.00  <=>  (((({pf_6_2 : 0.2275276} * {f_4_29 : 1.00}) * {pf_18_54 : -0.00}) + {pf_14_14 : 0.00}) * {utof2(u_23_phi_121) : 0.994522})
    pf_6_5 = ((((pf_6_2 * f_4_29) * pf_18_54) + pf_14_14) * utof2(u_23_phi_121));
	// 0.00  <=>  ((((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * {pf_18_54 : -0.00}) + (0.f + {pf_16_52 : -0.00})) * {utof2(u_21_phi_121) : 0.0538636}) + {pf_6_5 : 0.00})
    pf_3_9 = (((((pf_3_6 * f_4_29) * pf_18_54) + (0.f + pf_16_52)) * utof2(u_21_phi_121)) + pf_6_5);
	// -0.03125  <=>  ({f_2_65 : 0.0625} * (clamp({pf_19_28 : 0.50}, 0.0, 1.0) + float(int({u_9_phi_52 : 4294967295}))))
    pf_6_7 = (f_2_65 * (clamp(pf_19_28, 0.0, 1.0) + float(int(u_9_phi_52))));
	// -0.03125  <=>  ({f_2_65 : 0.0625} * (clamp(({pf_24_11 : -0.00} + 0.5f), 0.0, 1.0) + float(int({u_1_phi_51 : 4294967295}))))
    pf_7_5 = (f_2_65 * (clamp((pf_24_11 + 0.5f), 0.0, 1.0) + float(int(u_1_phi_51))));
	// 0.50  <=>  ((({pf_7_4 : 0.00} * {utof2(u_20_phi_121) : 0.5153016}) + ((((({pf_3_6 : -0.4703335} * {f_4_29 : 1.00}) * {pf_18_54 : -0.00}) + (0.f + {pf_16_52 : -0.00})) * {utof2(u_22_phi_121) : 0.8570089}) + {pf_11_12 : -0.00})) + 0.5f)
    pf_11_15 = (((pf_7_4 * utof2(u_20_phi_121)) + (((((pf_3_6 * f_4_29) * pf_18_54) + (0.f + pf_16_52)) * utof2(u_22_phi_121)) + pf_11_12)) + 0.5f);
	// 0.50  <=>  clamp({pf_11_15 : 0.50}, 0.0, 1.0)
    f_9_39 = clamp(pf_11_15, 0.0, 1.0);
	// 6.00  <=>  floor((({f_2_65 : 0.0625} * ({f_9_30 : 0.50} + float(int({u_18_phi_55 : 6})))) * {utof(vs_cbuf9_78.z) : 16.00}))
    f_13_18 = floor(((f_2_65 * (f_9_30 + float(int(u_18_phi_55)))) * utof(vs_cbuf9_78.z)));
	// False  <=>  isnan((({f_2_65 : 0.0625} * ({f_9_30 : 0.50} + float(int({u_18_phi_55 : 6})))) * {utof(vs_cbuf9_78.z) : 16.00}))
    b_1_51 = isnan(((f_2_65 * (f_9_30 + float(int(u_18_phi_55)))) * utof(vs_cbuf9_78.z)));
	// -0.50  <=>  ({pf_6_7 : -0.03125} * {utof(vs_cbuf9_78.z) : 16.00})
    pf_3_12 = (pf_6_7 * utof(vs_cbuf9_78.z));
	// -1  <=>  int(clamp(floor(({pf_7_5 : -0.03125} * {utof(vs_cbuf9_78.z) : 16.00})), float(-2147483600.f), float(2147483600.f)))
    u_11_17 = int(clamp(floor((pf_7_5 * utof(vs_cbuf9_78.z))), float(-2147483600.f), float(2147483600.f)));
	// 7.50  <=>  (float(int({u_17_0 : 7})) + clamp(((({pf_7_4 : 0.00} * {utof2(u_10_phi_121) : -0.0895817}) + {pf_3_9 : 0.00}) + 0.5f), 0.0, 1.0))
    pf_6_9 = (float(int(u_17_0)) + clamp((((pf_7_4 * utof2(u_10_phi_121)) + pf_3_9) + 0.5f), 0.0, 1.0));
	// 12  <=>  (isnan({v.vertex.z : 12.00}) ? 0u : uint(clamp(trunc({v.vertex.z : 12.00}), float(-2147483600.f), float(2147483600.f))))
    u_14_33 = (isnan(v.vertex.z) ? 0u : uint(clamp(trunc(v.vertex.z), float(-2147483600.f), float(2147483600.f))));
	// 0.40625  <=>  ({f_2_65 : 0.0625} * ({f_9_39 : 0.50} + float(int({u_11_phi_56 : 6}))))
    pf_3_14 = (f_2_65 * (f_9_39 + float(int(u_11_phi_56))));
	// 102  <=>  ((({b_1_49 : False} ? 0u : uint(clamp({f_9_32 : 6.00}, float(-2147483600.f), float(2147483600.f)))) << 4u) + ({b_1_51 : False} ? 0u : uint(clamp({f_13_18 : 6.00}, float(-2147483600.f), float(2147483600.f)))))
    u_9_20 = (((b_1_49 ? 0u : uint(clamp(f_9_32, float(-2147483600.f), float(2147483600.f)))) << 4u) + (b_1_51 ? 0u : uint(clamp(f_13_18, float(-2147483600.f), float(2147483600.f)))));
	// 111  <=>  ((({b_1_48 : False} ? 0u : {u_0_23 : 7}) << 4u) + (isnan({pf_3_12 : -0.50}) ? 0u : uint(clamp(floor({pf_3_12 : -0.50}), float(-2147483600.f), float(2147483600.f)))))
    u_0_26 = (((b_1_48 ? 0u : u_0_23) << 4u) + (isnan(pf_3_12) ? 0u : uint(clamp(floor(pf_3_12), float(-2147483600.f), float(2147483600.f)))));
	// float4(0.50,0.50,0.50,1.00)  <=>  texelFetch({tex0 : tex0}, int2(uint2({u_0_26 : 111}, {u_14_33 : 12})), int(0u))
    f4_0_0 = texelFetch(tex0, int2(uint2(u_0_26, u_14_33)), int(0u));
	// 0.50  <=>  {f4_0_0.z : 0.50}
    f_9_40 = f4_0_0.z;
	// 95  <=>  ((({b_1_50 : False} ? 0u : uint({f_13_13 : 6.00})) << 4u) + (isnan(({pf_7_5 : -0.03125} * {utof(vs_cbuf9_78.z) : 16.00})) ? 0u : {u_11_17 : 4294967295}))
    u_0_28 = (((b_1_50 ? 0u : uint(f_13_13)) << 4u) + (isnan((pf_7_5 * utof(vs_cbuf9_78.z))) ? 0u : u_11_17));
	// 6  <=>  int(clamp(floor(({pf_3_14 : 0.40625} * {utof(vs_cbuf9_78.z) : 16.00})), float(-2147483600.f), float(2147483600.f)))
    u_1_31 = int(clamp(floor((pf_3_14 * utof(vs_cbuf9_78.z))), float(-2147483600.f), float(2147483600.f)));
	// 7.50  <=>  (((1.0f / float(int({u_1_20 : 16}))) * {pf_6_9 : 7.50}) * {utof(vs_cbuf9_78.w) : 16.00})
    pf_3_16 = (((1.0f / float(int(u_1_20))) * pf_6_9) * utof(vs_cbuf9_78.w));
	// 112  <=>  ((isnan({pf_3_16 : 7.50}) ? 0u : uint(clamp(floor({pf_3_16 : 7.50}), float(-2147483600.f), float(2147483600.f)))) << 4u)
    u_10_29 = ((isnan(pf_3_16) ? 0u : uint(clamp(floor(pf_3_16), float(-2147483600.f), float(2147483600.f)))) << 4u);
	// 118  <=>  ({u_10_29 : 112} + (isnan(({pf_3_14 : 0.40625} * {utof(vs_cbuf9_78.z) : 16.00})) ? 0u : {u_1_31 : 6}))
    u_1_33 = (u_10_29 + (isnan((pf_3_14 * utof(vs_cbuf9_78.z))) ? 0u : u_1_31));
	// float4(0.50,0.50,0.50,1.00)  <=>  texelFetch({tex0 : tex0}, int2(uint2({u_1_33 : 118}, {u_14_33 : 12})), int(0u))
    f4_0_1 = texelFetch(tex0, int2(uint2(u_1_33, u_14_33)), int(0u));
	// uint2(95,12)  <=>  uint2({u_0_28 : 95}, {u_14_33 : 12})
    u2_0_2 = uint2(u_0_28, u_14_33);
	// float4(0.50,0.50,0.50,1.00)  <=>  texelFetch({tex0 : tex0}, int2({u2_0_2 : uint2(95,12)}), int(0u))
    f4_0_2 = texelFetch(tex0, int2(u2_0_2), int(0u));
	// 0.50  <=>  {f4_0_2.x : 0.50}
    f_14_5 = f4_0_2.x;
	// 0.50  <=>  {f4_0_2.y : 0.50}
    f_15_1 = f4_0_2.y;
	// 0.50  <=>  {f4_0_2.z : 0.50}
    f_16_38 = f4_0_2.z;
	// float4(0.50,0.50,0.50,1.00)  <=>  texelFetch({tex0 : tex0}, int2(uint2({u_9_20 : 102}, {u_14_33 : 12})), int(0u))
    f4_0_3 = texelFetch(tex0, int2(uint2(u_9_20, u_14_33)), int(0u));
	// -250.9389  <=>  ((0.f - {pf_0_9 : 538.25}) + {utof(camera_wpos.x) : 287.3111})
    pf_3_17 = ((0.f - pf_0_9) + utof(camera_wpos.x));
	// 121.3937  <=>  ((0.f - {pf_2_18 : 1550.75}) + {utof(camera_wpos.y) : 1672.144})
    pf_6_11 = ((0.f - pf_2_18) + utof(camera_wpos.y));
	// 454.9194  <=>  ((0.f - ({pf_1_8 : 0.00} + {utof(vs_cbuf10_6.w) : 941.75})) + {utof(camera_wpos.z) : 1396.669})
    pf_7_6 = ((0.f - (pf_1_8 + utof(vs_cbuf10_6.w))) + utof(camera_wpos.z));
	// 250.9389  <=>  ({pf_0_9 : 538.25} + (0.f - {utof(camera_wpos.x) : 287.3111}))
    pf_11_16 = (pf_0_9 + (0.f - utof(camera_wpos.x)));
	// -121.3937  <=>  ({pf_2_18 : 1550.75} + (0.f - {utof(camera_wpos.y) : 1672.144}))
    pf_12_14 = (pf_2_18 + (0.f - utof(camera_wpos.y)));
	// -454.9194  <=>  (({pf_1_8 : 0.00} + {utof(vs_cbuf10_6.w) : 941.75}) + (0.f - {utof(camera_wpos.z) : 1396.669}))
    pf_14_16 = ((pf_1_8 + utof(vs_cbuf10_6.w)) + (0.f - utof(camera_wpos.z)));
	// 284658.40  <=>  (({pf_7_6 : 454.9194} * {pf_7_6 : 454.9194}) + (({pf_6_11 : 121.3937} * {pf_6_11 : 121.3937}) + ({pf_3_17 : -250.9389} * {pf_3_17 : -250.9389})))
    pf_16_56 = ((pf_7_6 * pf_7_6) + ((pf_6_11 * pf_6_11) + (pf_3_17 * pf_3_17)));
	// 0.0018743  <=>  inversesqrt({pf_16_56 : 284658.40})
    f_20_10 = inversesqrt(pf_16_56);
	// 0.8526533  <=>  ({pf_7_6 : 454.9194} * {f_20_10 : 0.0018743})
    pf_7_7 = (pf_7_6 * f_20_10);
	// 0.331043  <=>  ((0.f - ({pf_6_11 : 121.3937} * {f_20_10 : 0.0018743})) + {utof(vs_cbuf8_28.y) : 0.5585706})
    pf_17_38 = ((0.f - (pf_6_11 * f_20_10)) + utof(vs_cbuf8_28.y));
	// 0.8736611  <=>  (({pf_7_7 : 0.8526533} * {utof(vs_cbuf8_28.z) : 0.8242117}) + ((({pf_6_11 : 121.3937} * {f_20_10 : 0.0018743}) * {utof(vs_cbuf8_28.y) : 0.5585706}) + (({pf_3_17 : -250.9389} * {f_20_10 : 0.0018743}) * {utof(vs_cbuf8_28.x) : -0.0931343})))
    pf_16_59 = ((pf_7_7 * utof(vs_cbuf8_28.z)) + (((pf_6_11 * f_20_10) * utof(vs_cbuf8_28.y)) + ((pf_3_17 * f_20_10) * utof(vs_cbuf8_28.x))));
	// 0.00  <=>  clamp((({pf_16_59 : 0.8736611} + -0.9f) * 10.010009f), 0.0, 1.0)
    f_20_15 = clamp(((pf_16_59 + -0.9f) * 10.010009f), 0.0, 1.0);
	// 3.00  <=>  (({f_20_15 : 0.00} * -2.f) + 3.f)
    pf_16_62 = ((f_20_15 * -2.f) + 3.f);
	// 0.00  <=>  ({f_20_15 : 0.00} * {f_20_15 : 0.00})
    pf_18_55 = (f_20_15 * f_20_15);
	// 0.4703335  <=>  (0.f - ({pf_3_17 : -250.9389} * {f_20_10 : 0.0018743}))
    f_21_4 = (0.f - (pf_3_17 * f_20_10));
	// 0.2275276  <=>  ((({pf_16_62 : 3.00} * {pf_18_55 : 0.00}) * {pf_17_38 : 0.331043}) + ({pf_6_11 : 121.3937} * {f_20_10 : 0.0018743}))
    pf_6_13 = (((pf_16_62 * pf_18_55) * pf_17_38) + (pf_6_11 * f_20_10));
	// -0.4703335  <=>  ((({pf_16_62 : 3.00} * {pf_18_55 : 0.00}) * ({f_21_4 : 0.4703335} + {utof(vs_cbuf8_28.x) : -0.0931343})) + ({pf_3_17 : -250.9389} * {f_20_10 : 0.0018743}))
    pf_3_19 = (((pf_16_62 * pf_18_55) * (f_21_4 + utof(vs_cbuf8_28.x))) + (pf_3_17 * f_20_10));
	// 0.8526533  <=>  ((({pf_16_62 : 3.00} * {pf_18_55 : 0.00}) * ((0.f - {pf_7_7 : 0.8526533}) + {utof(vs_cbuf8_28.z) : 0.8242117})) + {pf_7_7 : 0.8526533})
    pf_7_8 = (((pf_16_62 * pf_18_55) * ((0.f - pf_7_7) + utof(vs_cbuf8_28.z))) + pf_7_7);
	// 0.2729824  <=>  (({pf_6_13 : 0.2275276} * {pf_6_13 : 0.2275276}) + ({pf_3_19 : -0.4703335} * {pf_3_19 : -0.4703335}))
    pf_16_64 = ((pf_6_13 * pf_6_13) + (pf_3_19 * pf_3_19));
	// 1.00  <=>  inversesqrt((({pf_7_8 : 0.8526533} * {pf_7_8 : 0.8526533}) + {pf_16_64 : 0.2729824}))
    f_20_18 = inversesqrt(((pf_7_8 * pf_7_8) + pf_16_64));
	// 0.2275276  <=>  ({pf_6_13 : 0.2275276} * {f_20_18 : 1.00})
    pf_6_14 = (pf_6_13 * f_20_18);
	// 0.2275276  <=>  (abs({pf_6_14 : 0.2275276}) + (0.f - 0.f))
    pf_16_66 = (abs(pf_6_14) + (0.f - 0.f));
	// 1.526091  <=>  (((((({pf_16_66 : 0.2275276} * -0.0187293f) + 0.074261f) * {pf_16_66 : 0.2275276}) + -0.2121144f) * {pf_16_66 : 0.2275276}) + 1.5707288f)
    pf_16_67 = ((((((pf_16_66 * -0.0187293f) + 0.074261f) * pf_16_66) + -0.2121144f) * pf_16_66) + 1.5707288f);
	// 1.341287  <=>  ({pf_16_67 : 1.526091} * sqrt(((0.f - abs({pf_6_14 : 0.2275276})) + 1.f)))
    pf_16_68 = (pf_16_67 * sqrt(((0.f - abs(pf_6_14)) + 1.f)));
	// 0.00  <=>  ({pf_16_68 : 1.341287} * {utof2((((({pf_6_14 : 0.2275276} < 0.f) && (! isnan({pf_6_14 : 0.2275276}))) && (! isnan(0.f))) ? 1065353216u : 0u)) : 0.00})
    pf_18_58 = (pf_16_68 * utof2(((((pf_6_14 < 0.f) && (!isnan(pf_6_14))) && (!isnan(0.f))) ? 1065353216u : 0u)));
	// 77706.74  <=>  (({pf_12_14 : -121.3937} * {pf_12_14 : -121.3937}) + ({pf_11_16 : 250.9389} * {pf_11_16 : 250.9389}))
    pf_17_44 = ((pf_12_14 * pf_12_14) + (pf_11_16 * pf_11_16));
	// 0.0018743  <=>  inversesqrt((({pf_14_16 : -454.9194} * {pf_14_16 : -454.9194}) + {pf_17_44 : 77706.74}))
    f_20_19 = inversesqrt(((pf_14_16 * pf_14_16) + pf_17_44));
	// 1.341287  <=>  (({utof2((((({pf_6_14 : 0.2275276} < 0.f) && (! isnan({pf_6_14 : 0.2275276}))) && (! isnan(0.f))) ? 1065353216u : 0u)) : 0.00} * 3.1415927f) + (({pf_18_58 : 0.00} * -2.f) + {pf_16_68 : 1.341287}))
    pf_16_70 = (( utof2(((((pf_6_14 < 0.f) && (!isnan(pf_6_14))) && (!isnan(0.f))) ? 1065353216u : 0u)) * 3.1415927f) + ((pf_18_58 * -2.f) + pf_16_68));
	// 0.00  <=>  ((0.f - {f4_0_0.x : 0.50}) + {f4_0_1.x : 0.50})
    pf_19_38 = ((0.f - f4_0_0.x) + f4_0_1.x);
	// 0.00  <=>  ((0.f - {f4_0_0.y : 0.50}) + {f4_0_1.y : 0.50})
    pf_20_21 = ((0.f - f4_0_0.y) + f4_0_1.y);
	// 0.50  <=>  (({pf_13_23 : 0.9050674} * ((0.f - {f_14_5 : 0.50}) + {f4_0_3.x : 0.50})) + {f_14_5 : 0.50})
    pf_21_9 = ((pf_13_23 * ((0.f - f_14_5) + f4_0_3.x)) + f_14_5);
	// 0.50  <=>  (({pf_13_23 : 0.9050674} * ((0.f - {f_15_1 : 0.50}) + {f4_0_3.y : 0.50})) + {f_15_1 : 0.50})
    pf_22_31 = ((pf_13_23 * ((0.f - f_15_1) + f4_0_3.y)) + f_15_1);
	// 0.00  <=>  ((0.f - {pf_21_9 : 0.50}) + (({pf_13_23 : 0.9050674} * {pf_19_38 : 0.00}) + {f4_0_0.x : 0.50}))
    pf_19_40 = ((0.f - pf_21_9) + ((pf_13_23 * pf_19_38) + f4_0_0.x));
	// 0.00  <=>  ((0.f - {pf_22_31 : 0.50}) + (({pf_13_23 : 0.9050674} * {pf_20_21 : 0.00}) + {f4_0_0.y : 0.50}))
    pf_20_23 = ((0.f - pf_22_31) + ((pf_13_23 * pf_20_21) + f4_0_0.y));
	// True  <=>  (! (((abs(({pf_12_14 : -121.3937} * {f_20_19 : 0.0018743})) == 1.f) && (! isnan(abs(({pf_12_14 : -121.3937} * {f_20_19 : 0.0018743}))))) && (! isnan(1.f))))
    b_1_59 = (!(((abs((pf_12_14 * f_20_19)) == 1.f) && (!isnan(abs((pf_12_14 * f_20_19))))) && (!isnan(1.f))));
	// True  <=>  ({b_1_59 : True} ? true : false)
    b_2_21 = (b_1_59 ? true : false);
	// 1056964608  <=>  {ftou2((({pf_10_10 : 0.4041748} * {pf_20_23 : 0.00}) + {pf_22_31 : 0.50})) : 1056964608}
    u_11_19 = ftou2(((pf_10_10 * pf_20_23) + pf_22_31));
	// 1056964608  <=>  {ftou2((({pf_10_10 : 0.4041748} * {pf_19_40 : 0.00}) + {pf_21_9 : 0.50})) : 1056964608}
    u_12_23 = ftou2(((pf_10_10 * pf_19_40) + pf_21_9));
    u_11_phi_133 = u_11_19;
    u_12_phi_133 = u_12_23;
	// True  <=>  if({b_2_21 : True})
    if (b_2_21)
    {
		// 0.8526533  <=>  (0.f - ({pf_14_16 : -454.9194} * {f_20_19 : 0.0018743}))
        f_8_26 = (0.f - (pf_14_16 * f_20_19));
		// 1.00  <=>  inversesqrt((({utof(vs_cbuf8_28.z) : 0.8242117} * {utof(vs_cbuf8_28.z) : 0.8242117}) + (({utof(vs_cbuf8_28.y) : 0.5585706} * {utof(vs_cbuf8_28.y) : 0.5585706}) + ({utof(vs_cbuf8_28.x) : -0.0931343} * {utof(vs_cbuf8_28.x) : -0.0931343}))))
        f_8_27 = inversesqrt((( utof(vs_cbuf8_28.z) * utof(vs_cbuf8_28.z)) + (( utof(vs_cbuf8_28.y) * utof(vs_cbuf8_28.y)) + ( utof(vs_cbuf8_28.x) * utof(vs_cbuf8_28.x)))));
		// -0.7270176  <=>  (({pf_14_16 : -454.9194} * {f_20_19 : 0.0018743}) * ((0.f * ({pf_12_14 : -121.3937} * {f_20_19 : 0.0018743})) + {f_8_26 : 0.8526533}))
        pf_21_13 = ((pf_14_16 * f_20_19) * ((0.f * (pf_12_14 * f_20_19)) + f_8_26));
		// -0.1940021  <=>  ((({pf_12_14 : -121.3937} * {f_20_19 : 0.0018743}) * ((0.f * ({pf_12_14 : -121.3937} * {f_20_19 : 0.0018743})) + {f_8_26 : 0.8526533})) + (0.f - 0.f))
        pf_23_13 = (((pf_12_14 * f_20_19) * ((0.f * (pf_12_14 * f_20_19)) + f_8_26)) + (0.f - 0.f));
		// 0.5585706  <=>  ({f_8_27 : 1.00} * {utof(vs_cbuf8_28.y) : 0.5585706})
        pf_24_31 = (f_8_27 * utof(vs_cbuf8_28.y));
		// -0.0931343  <=>  ({f_8_27 : 1.00} * {utof(vs_cbuf8_28.x) : -0.0931343})
        pf_26_23 = (f_8_27 * utof(vs_cbuf8_28.x));
		// -0.8242118  <=>  ((0.f * {pf_24_31 : 0.5585706}) + (0.f - ({f_8_27 : 1.00} * {utof(vs_cbuf8_28.z) : 0.8242117})))
        pf_27_12 = ((0.f * pf_24_31) + (0.f - (f_8_27 * utof(vs_cbuf8_28.z))));
		// -0.0931343  <=>  ((0.f - 0.f) + {pf_26_23 : -0.0931343})
        pf_28_30 = ((0.f - 0.f) + pf_26_23);
		// 0.679325  <=>  (({pf_27_12 : -0.8242118} * {pf_27_12 : -0.8242118}) + 0.f)
        pf_29_26 = ((pf_27_12 * pf_27_12) + 0.f);
		// 1.205608  <=>  inversesqrt((({pf_28_30 : -0.0931343} * {pf_28_30 : -0.0931343}) + {pf_29_26 : 0.679325}))
        f_8_30 = inversesqrt(((pf_28_30 * pf_28_30) + pf_29_26));
		// 0.4703335  <=>  ((0.f - 0.f) + ({pf_11_16 : 250.9389} * {f_20_19 : 0.0018743}))
        pf_29_28 = ((0.f - 0.f) + (pf_11_16 * f_20_19));
		// -0.9936762  <=>  ({pf_27_12 : -0.8242118} * {f_8_30 : 1.205608})
        pf_27_13 = (pf_27_12 * f_8_30);
		// 0.9482312  <=>  ((({pf_11_16 : 250.9389} * {f_20_19 : 0.0018743}) * {pf_29_28 : 0.4703335}) + (0.f - {pf_21_13 : -0.7270176}))
        pf_21_14 = (((pf_11_16 * f_20_19) * pf_29_28) + (0.f - pf_21_13));
		// 0.1070138  <=>  ((0.f * ({pf_14_16 : -454.9194} * {f_20_19 : 0.0018743})) + (0.f - (({pf_12_14 : -121.3937} * {f_20_19 : 0.0018743}) * {pf_29_28 : 0.4703335})))
        pf_29_29 = ((0.f * (pf_14_16 * f_20_19)) + (0.f - ((pf_12_14 * f_20_19) * pf_29_28)));
		// -0.0627182  <=>  ({pf_24_31 : 0.5585706} * ({pf_28_30 : -0.0931343} * {f_8_30 : 1.205608}))
        pf_31_12 = (pf_24_31 * (pf_28_30 * f_8_30));
		// 0.0627182  <=>  ((({f_8_27 : 1.00} * {utof(vs_cbuf8_28.z) : 0.8242117}) * (0.f * {f_8_30 : 1.205608})) + (0.f - {pf_31_12 : -0.0627182}))
        pf_31_13 = (((f_8_27 * utof(vs_cbuf8_28.z)) * (0.f * f_8_30)) + (0.f - pf_31_12));
		// 0.8294571  <=>  (({pf_26_23 : -0.0931343} * ({pf_28_30 : -0.0931343} * {f_8_30 : 1.205608})) + (0.f - (({f_8_27 : 1.00} * {utof(vs_cbuf8_28.z) : 0.8242117}) * {pf_27_13 : -0.9936762})))
        pf_33_12 = ((pf_26_23 * (pf_28_30 * f_8_30)) + (0.f - ((f_8_27 * utof(vs_cbuf8_28.z)) * pf_27_13)));
		// -0.5550383  <=>  (({pf_24_31 : 0.5585706} * {pf_27_13 : -0.9936762}) + (0.f - ({pf_26_23 : -0.0931343} * (0.f * {f_8_30 : 1.205608}))))
        pf_34_13 = ((pf_24_31 * pf_27_13) + (0.f - (pf_26_23 * (0.f * f_8_30))));
		// -0.4673592  <=>  (({pf_11_16 : 250.9389} * {f_20_19 : 0.0018743}) * {pf_27_13 : -0.9936762})
        pf_27_14 = ((pf_11_16 * f_20_19) * pf_27_13);
		// 0.9105943  <=>  (({pf_21_14 : 0.9482312} * {pf_21_14 : 0.9482312}) + ({pf_29_29 : 0.1070138} * {pf_29_29 : 0.1070138}))
        pf_30_17 = ((pf_21_14 * pf_21_14) + (pf_29_29 * pf_29_29));
		// 0.6919327  <=>  (({pf_33_12 : 0.8294571} * {pf_33_12 : 0.8294571}) + ({pf_31_13 : 0.0627182} * {pf_31_13 : 0.0627182}))
        pf_30_18 = ((pf_33_12 * pf_33_12) + (pf_31_13 * pf_31_13));
		// 1.026935  <=>  inversesqrt((({pf_23_13 : -0.1940021} * {pf_23_13 : -0.1940021}) + {pf_30_17 : 0.9105943}))
        f_8_36 = inversesqrt(((pf_23_13 * pf_23_13) + pf_30_17));
		// -0.3716204  <=>  ((({pf_14_16 : -454.9194} * {f_20_19 : 0.0018743}) * ({pf_28_30 : -0.0931343} * {f_8_30 : 1.205608})) + ((({pf_12_14 : -121.3937} * {f_20_19 : 0.0018743}) * (0.f * {f_8_30 : 1.205608})) + {pf_27_14 : -0.4673592}))
        pf_18_61 = (((pf_14_16 * f_20_19) * (pf_28_30 * f_8_30)) + (((pf_12_14 * f_20_19) * (0.f * f_8_30)) + pf_27_14));
		// 1.00  <=>  (({pf_34_13 : -0.5550383} * {pf_34_13 : -0.5550383}) + {pf_30_18 : 0.6919327})
        pf_22_33 = ((pf_34_13 * pf_34_13) + pf_30_18);
		// 0  <=>  (((({pf_18_61 : -0.3716204} > 0.f) && (! isnan({pf_18_61 : -0.3716204}))) && (! isnan(0.f))) ? 1065353216u : 0u)
        u_15_23 = ((((pf_18_61 > 0.f) && (!isnan(pf_18_61))) && (!isnan(0.f))) ? 1065353216u : 0u);
		// -0.1992275  <=>  ({pf_23_13 : -0.1940021} * {f_8_36 : 1.026935})
        pf_22_34 = (pf_23_13 * f_8_36);
		// 1.00  <=>  {utof2((((({pf_18_61 : -0.3716204} < 0.f) && (! isnan({pf_18_61 : -0.3716204}))) && (! isnan(0.f))) ? 1065353216u : 0u)) : 1.00}
        f_14_6 = utof2(((((pf_18_61 < 0.f) && (!isnan(pf_18_61))) && (!isnan(0.f))) ? 1065353216u : 0u));
		// 0.5336851  <=>  (({pf_24_31 : 0.5585706} * ({pf_21_14 : 0.9482312} * {f_8_36 : 1.026935})) + ({pf_26_23 : -0.0931343} * ({pf_29_29 : 0.1070138} * {f_8_36 : 1.026935})))
        pf_27_17 = ((pf_24_31 * (pf_21_14 * f_8_36)) + (pf_26_23 * (pf_29_29 * f_8_36)));
		// -0.0058412  <=>  ({pf_26_23 : -0.0931343} * ({pf_31_13 : 0.0627182} * inversesqrt({pf_22_33 : 1.00})))
        pf_31_14 = (pf_26_23 * (pf_31_13 * inversesqrt(pf_22_33)));
		// 0.1443074  <=>  (({pf_26_23 : -0.0931343} * (0.f - ((({f_8_27 : 1.00} * {utof(vs_cbuf8_28.z) : 0.8242117}) * {pf_22_34 : -0.1992275}) + {pf_27_17 : 0.5336851}))) + ({pf_29_29 : 0.1070138} * {f_8_36 : 1.026935}))
        pf_18_63 = ((pf_26_23 * (0.f - (((f_8_27 * utof(vs_cbuf8_28.z)) * pf_22_34) + pf_27_17))) + (pf_29_29 * f_8_36));
		// 0.7673913  <=>  (({pf_24_31 : 0.5585706} * (0.f - ((({f_8_27 : 1.00} * {utof(vs_cbuf8_28.z) : 0.8242117}) * {pf_22_34 : -0.1992275}) + {pf_27_17 : 0.5336851}))) + ({pf_21_14 : 0.9482312} * {f_8_36 : 1.026935}))
        pf_21_16 = ((pf_24_31 * (0.f - (((f_8_27 * utof(vs_cbuf8_28.z)) * pf_22_34) + pf_27_17))) + (pf_21_14 * f_8_36));
		// -0.00  <=>  ((({f_8_27 : 1.00} * {utof(vs_cbuf8_28.z) : 0.8242117}) * ({pf_34_13 : -0.5550383} * inversesqrt({pf_22_33 : 1.00}))) + (({pf_24_31 : 0.5585706} * ({pf_33_12 : 0.8294571} * inversesqrt({pf_22_33 : 1.00}))) + {pf_31_14 : -0.0058412}))
        pf_31_16 = (((f_8_27 * utof(vs_cbuf8_28.z)) * (pf_34_13 * inversesqrt(pf_22_33))) + ((pf_24_31 * (pf_33_12 * inversesqrt(pf_22_33))) + pf_31_14));
		// -0.3694794  <=>  (0.f - ((({f_8_27 : 1.00} * {utof(vs_cbuf8_28.z) : 0.8242117}) * {pf_22_34 : -0.1992275}) + {pf_27_17 : 0.5336851}))
        f_8_40 = (0.f - (((f_8_27 * utof(vs_cbuf8_28.z)) * pf_22_34) + pf_27_17));
		// -0.5037569  <=>  ((({f_8_27 : 1.00} * {utof(vs_cbuf8_28.z) : 0.8242117}) * {f_8_40 : -0.3694794}) + {pf_22_34 : -0.1992275})
        pf_22_35 = (((f_8_27 * utof(vs_cbuf8_28.z)) * f_8_40) + pf_22_34);
		// 0.0627182  <=>  (({pf_26_23 : -0.0931343} * (0.f - {pf_31_16 : -0.00})) + ({pf_31_13 : 0.0627182} * inversesqrt({pf_22_33 : 1.00})))
        pf_26_24 = ((pf_26_23 * (0.f - pf_31_16)) + (pf_31_13 * inversesqrt(pf_22_33)));
		// 0.829457  <=>  (({pf_24_31 : 0.5585706} * (0.f - {pf_31_16 : -0.00})) + ({pf_33_12 : 0.8294571} * inversesqrt({pf_22_33 : 1.00})))
        pf_24_32 = ((pf_24_31 * (0.f - pf_31_16)) + (pf_33_12 * inversesqrt(pf_22_33)));
		// -0.5550383  <=>  ((({f_8_27 : 1.00} * {utof(vs_cbuf8_28.z) : 0.8242117}) * (0.f - {pf_31_16 : -0.00})) + ({pf_34_13 : -0.5550383} * inversesqrt({pf_22_33 : 1.00})))
        pf_25_26 = (((f_8_27 * utof(vs_cbuf8_28.z)) * (0.f - pf_31_16)) + (pf_34_13 * inversesqrt(pf_22_33)));
		// 0.863485  <=>  (({pf_22_35 : -0.5037569} * {pf_22_35 : -0.5037569}) + (({pf_21_16 : 0.7673913} * {pf_21_16 : 0.7673913}) + ({pf_18_63 : 0.1443074} * {pf_18_63 : 0.1443074})))
        pf_27_21 = ((pf_22_35 * pf_22_35) + ((pf_21_16 * pf_21_16) + (pf_18_63 * pf_18_63)));
		// 0.9999999  <=>  (({pf_25_26 : -0.5550383} * {pf_25_26 : -0.5550383}) + (({pf_24_32 : 0.829457} * {pf_24_32 : 0.829457}) + ({pf_26_24 : 0.0627182} * {pf_26_24 : 0.0627182})))
        pf_27_22 = ((pf_25_26 * pf_25_26) + ((pf_24_32 * pf_24_32) + (pf_26_24 * pf_26_24)));
		// 0.0627182  <=>  ({pf_26_24 : 0.0627182} * inversesqrt({pf_27_22 : 0.9999999}))
        pf_26_25 = (pf_26_24 * inversesqrt(pf_27_22));
		// 0.6947286  <=>  ((({pf_24_32 : 0.829457} * inversesqrt({pf_27_22 : 0.9999999})) * ({pf_21_16 : 0.7673913} * inversesqrt({pf_27_21 : 0.863485}))) + ({pf_26_25 : 0.0627182} * ({pf_18_63 : 0.1443074} * inversesqrt({pf_27_21 : 0.863485}))))
        pf_18_66 = (((pf_24_32 * inversesqrt(pf_27_22)) * (pf_21_16 * inversesqrt(pf_27_21))) + (pf_26_25 * (pf_18_63 * inversesqrt(pf_27_21))));
		// 0.9956247  <=>  ((({pf_25_26 : -0.5550383} * inversesqrt({pf_27_22 : 0.9999999})) * ({pf_22_35 : -0.5037569} * inversesqrt({pf_27_21 : 0.863485}))) + {pf_18_66 : 0.6947286})
        pf_18_67 = (((pf_25_26 * inversesqrt(pf_27_22)) * (pf_22_35 * inversesqrt(pf_27_21))) + pf_18_66);
		// -0.0934427  <=>  (0.f - sqrt(max(0.f, (({pf_18_67 : 0.9956247} * (0.f - {pf_18_67 : 0.9956247})) + 1.f))))
        f_8_48 = (0.f - sqrt(max(0.f, ((pf_18_67 * (0.f - pf_18_67)) + 1.f))));
		// 0.451091  <=>  (((({pf_10_10 : 0.4041748} * {pf_19_40 : 0.00}) + {pf_21_9 : 0.50}) * (0.f - (((0.f - {f_14_6 : 1.00}) + {utof2(u_15_23) : 0.00}) * {f_8_48 : -0.0934427}))) + ((({pf_10_10 : 0.4041748} * {pf_20_23 : 0.00}) + {pf_22_31 : 0.50}) * {pf_18_67 : 0.9956247}))
        pf_21_20 = ((((pf_10_10 * pf_19_40) + pf_21_9) * (0.f - (((0.f - f_14_6) + utof2(u_15_23)) * f_8_48))) + (((pf_10_10 * pf_20_23) + pf_22_31) * pf_18_67));
		// 0.5445337  <=>  (((({pf_10_10 : 0.4041748} * {pf_19_40 : 0.00}) + {pf_21_9 : 0.50}) * {pf_18_67 : 0.9956247}) + ((({pf_10_10 : 0.4041748} * {pf_20_23 : 0.00}) + {pf_22_31 : 0.50}) * (((0.f - {f_14_6 : 1.00}) + {utof2(u_15_23) : 0.00}) * {f_8_48 : -0.0934427})))
        pf_18_68 = ((((pf_10_10 * pf_19_40) + pf_21_9) * pf_18_67) + (((pf_10_10 * pf_20_23) + pf_22_31) * (((0.f - f_14_6) + utof2(u_15_23)) * f_8_48)));
		// 1055323494  <=>  {ftou2(pf_21_20) : 1055323494}
        u_11_20 = ftou2(pf_21_20);
		// 1057711759  <=>  {ftou2(pf_18_68) : 1057711759}
        u_12_24 = ftou2(pf_18_68);
        u_11_phi_133 = u_11_20;
        u_12_phi_133 = u_12_24;
    }
	// 0.50  <=>  (({pf_13_23 : 0.9050674} * ((0.f - {f_16_38 : 0.50}) + {f4_0_3.z : 0.50})) + {f_16_38 : 0.50})
    pf_13_24 = ((pf_13_23 * ((0.f - f_16_38) + f4_0_3.z)) + f_16_38);
	// True  <=>  (((({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) != 0.f) || isnan(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}))) || isnan(0.f))
    b_1_62 = ((((pf_3_19 * f_20_18) != 0.f) || isnan((pf_3_19 * f_20_18))) || isnan(0.f));
	// -0.50  <=>  (0.f - {pf_13_24 : 0.50})
    f_0_8 = (0.f - pf_13_24);
	// 2.195791  <=>  ((((({utof2(u_12_phi_133) : 0.5445337} * 2.f) * 0.5f) + 0.5f) + {uni_attr6.z : 0.33751}) + {utof(vs_cbuf15_54.x) : 0.8137476})
    pf_22_39 = ((((( utof2(u_12_phi_133) * 2.f) * 0.5f) + 0.5f) + uni_attr6.z) + utof(vs_cbuf15_54.x));
	// 2.309921  <=>  ((((({utof2(u_11_phi_133) : 0.451091} * -2.f) * 0.5f) + 0.5f) + {uni_attr6.w : 0.57114}) + {utof(vs_cbuf15_54.y) : 1.689872})
    pf_23_16 = ((((( utof2(u_11_phi_133) * -2.f) * 0.5f) + 0.5f) + uni_attr6.w) + utof(vs_cbuf15_54.y));
	// 0.50  <=>  (({pf_10_10 : 0.4041748} * ({f_0_8 : -0.50} + (({pf_13_23 : 0.9050674} * ((0.f - {f_9_40 : 0.50}) + {f4_0_1.z : 0.50})) + {f_9_40 : 0.50}))) + {pf_13_24 : 0.50})
    pf_10_11 = ((pf_10_10 * (f_0_8 + ((pf_13_23 * ((0.f - f_9_40) + f4_0_1.z)) + f_9_40))) + pf_13_24);
	// 1056964608  <=>  {ftou2(f_16_38) : 1056964608}
    u_9_22 = ftou2(f_16_38);
    u_9_phi_134 = u_9_22;
	// True  <=>  if(({b_1_62 : True} ? true : false))
    if ((b_1_62 ? true : false))
    {
		// 0  <=>  ((((abs(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00})) == 0.f) && (! isnan(abs(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}))))) && (! isnan(0.f))) ? 4294967295u : 0u)
        u_10_31 = ((((abs((pf_3_19 * f_20_18)) == 0.f) && (!isnan(abs((pf_3_19 * f_20_18))))) && (!isnan(0.f))) ? 4294967295u : 0u);
		// False  <=>  ((((abs(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00})) == 0.f) && (! isnan(abs(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}))))) && (! isnan(0.f))) && (((abs(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00})) == 0.f) && (! isnan(abs(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}))))) && (! isnan(0.f))))
        b_6_11 = ((((abs((pf_3_19 * f_20_18)) == 0.f) && (!isnan(abs((pf_3_19 * f_20_18))))) && (!isnan(0.f))) && (((abs((pf_7_8 * f_20_18)) == 0.f) && (!isnan(abs((pf_7_8 * f_20_18))))) && (!isnan(0.f))));
		// False  <=>  ({b_6_11 : False} ? true : false)
        b_7_4 = (b_6_11 ? true : false);
		// False  <=>  ({b_3_phi_121 : False} ? true : false)
        b_8_0 = (b_3_phi_121 ? true : false);
        b_8_phi_135 = b_8_0;
		// False  <=>  if({b_7_4 : False})
        if (b_7_4)
        {
			// True  <=>  ((((({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) < 0.f) && (! isnan(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00})))) && (! isnan(0.f))) ? true : false)
            b_8_1 = (((((pf_3_19 * f_20_18) < 0.f) && (!isnan((pf_3_19 * f_20_18)))) && (!isnan(0.f))) ? true : false);
            b_8_phi_135 = b_8_1;
        }
		// 1056964608  <=>  {ftou2(f_16_38) : 1056964608}
        u_10_32 = ftou2(f_16_38);
        u_10_phi_136 = u_10_32;
		// False  <=>  if(({b_6_11 : False} ? true : false))
        if ((b_6_11 ? true : false))
        {
			// 0  <=>  ({b_8_phi_135 : False} ? 1078530011u : 0u)
            u_10_33 = (b_8_phi_135 ? 1078530011u : 0u);
            u_10_phi_136 = u_10_33;
        }
		// 1068216142  <=>  {ftou2(pf_16_70) : 1068216142}
        u_14_37 = ftou2(pf_16_70);
        u_14_phi_137 = u_14_37;
		// False  <=>  if(({b_6_11 : False} ? true : false))
        if ((b_6_11 ? true : false))
        {
			// 3204448256  <=>  {ftou2(((0.f - {utof2(u_10_phi_136) : 0.50}) + (0.f - 0.f))) : 3204448256}
            u_14_38 = ftou2(((0.f - utof2(u_10_phi_136)) + (0.f - 0.f)));
            u_14_phi_137 = u_14_38;
        }
		// False  <=>  (((((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) < 0.f) && (! isnan(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00})))) && (! isnan(0.f))) && {b_6_11 : False}) ? true : false)
        b_7_8 = ((((((pf_7_8 * f_20_18) < 0.f) && (!isnan((pf_7_8 * f_20_18)))) && (!isnan(0.f))) && b_6_11) ? true : false);
		// 1056964608  <=>  {u_10_phi_136 : 1056964608}
        u_1_36 = u_10_phi_136;
        u_1_phi_138 = u_1_36;
		// False  <=>  if({b_7_8 : False})
        if (b_7_8)
        {
			// 1068216142  <=>  {u_14_phi_137 : 1068216142}
            u_1_37 = u_14_phi_137;
            u_1_phi_138 = u_1_37;
        }
		// False  <=>  ((((abs(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00})) == 0.f) && (! isnan(abs(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}))))) && (! isnan(0.f))) && ((! ({u_10_31 : 0} == 0u)) || (! ({u_10_31 : 0} == 0u))))
        b_1_64 = ((((abs((pf_7_8 * f_20_18)) == 0.f) && (!isnan(abs((pf_7_8 * f_20_18))))) && (!isnan(0.f))) && ((!(u_10_31 == 0u)) || (!(u_10_31 == 0u))));
		// 1056964608  <=>  {u_1_phi_138 : 1056964608}
        u_10_34 = u_1_phi_138;
        u_10_phi_139 = u_10_34;
		// True  <=>  if(((! {b_1_64 : False}) ? true : false))
        if (((!b_1_64) ? true : false))
        {
			// 0  <=>  ((((abs(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00})) == {utof2(0x7f800000) : ∞}) && (! isnan(abs(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}))))) && (! isnan({utof2(0x7f800000) : ∞}))) ? 4294967295u : 0u)
            u_15_26 = ((((abs((pf_3_19 * f_20_18)) == utof2(0x7f800000)) && (!isnan(abs((pf_3_19 * f_20_18))))) && (!isnan( utof2(0x7f800000)))) ? 4294967295u : 0u);
			// False  <=>  ((((abs(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00})) == {utof2(0x7f800000) : ∞}) && (! isnan(abs(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}))))) && (! isnan({utof2(0x7f800000) : ∞}))) && (((abs(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00})) == {utof2(0x7f800000) : ∞}) && (! isnan(abs(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}))))) && (! isnan({utof2(0x7f800000) : ∞}))))
            b_5_10 = ((((abs((pf_3_19 * f_20_18)) == utof2(0x7f800000)) && (!isnan(abs((pf_3_19 * f_20_18))))) && (!isnan( utof2(0x7f800000)))) && (((abs((pf_7_8 * f_20_18)) == utof2(0x7f800000)) && (!isnan(abs((pf_7_8 * f_20_18))))) && (!isnan( utof2(0x7f800000)))));
			// False  <=>  ({b_6_11 : False} ? true : false)
            b_8_2 = (b_6_11 ? true : false);
            b_8_phi_140 = b_8_2;
			// False  <=>  if(({b_5_10 : False} ? true : false))
            if ((b_5_10 ? true : false))
            {
				// True  <=>  ((((({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) < 0.f) && (! isnan(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00})))) && (! isnan(0.f))) ? true : false)
                b_8_3 = (((((pf_3_19 * f_20_18) < 0.f) && (!isnan((pf_3_19 * f_20_18)))) && (!isnan(0.f))) ? true : false);
                b_8_phi_140 = b_8_3;
            }
			// 1056964608  <=>  {u_1_phi_138 : 1056964608}
            u_15_27 = u_1_phi_138;
            u_15_phi_141 = u_15_27;
			// False  <=>  if(({b_5_10 : False} ? true : false))
            if ((b_5_10 ? true : false))
            {
				// 1061752795  <=>  1061752795u
                u_15_28 = 1061752795u;
                u_15_phi_141 = u_15_28;
            }
			// 1056964608  <=>  {u_15_phi_141 : 1056964608}
            u_16_25 = u_15_phi_141;
            u_16_phi_142 = u_16_25;
			// False  <=>  if(({b_5_10 : False} ? true : false))
            if ((b_5_10 ? true : false))
            {
				// 1056964608  <=>  ({b_8_phi_140 : False} ? 1075235812u : {u_15_phi_141 : 1056964608})
                u_16_26 = (b_8_phi_140 ? 1075235812u : u_15_phi_141);
                u_16_phi_142 = u_16_26;
            }
			// 1068216142  <=>  {u_14_phi_137 : 1068216142}
            u_15_29 = u_14_phi_137;
            u_15_phi_143 = u_15_29;
			// False  <=>  if(({b_5_10 : False} ? true : false))
            if ((b_5_10 ? true : false))
            {
				// 3204448256  <=>  {ftou2(((0.f - {utof2(u_16_phi_142) : 0.50}) + (0.f - 0.f))) : 3204448256}
                u_15_30 = ftou2(((0.f - utof2(u_16_phi_142)) + (0.f - 0.f)));
                u_15_phi_143 = u_15_30;
            }
			// False  <=>  (((((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) < 0.f) && (! isnan(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00})))) && (! isnan(0.f))) && {b_5_10 : False}) ? true : false)
            b_5_11 = ((((((pf_7_8 * f_20_18) < 0.f) && (!isnan((pf_7_8 * f_20_18)))) && (!isnan(0.f))) && b_5_10) ? true : false);
			// 1056964608  <=>  {u_16_phi_142 : 1056964608}
            u_14_39 = u_16_phi_142;
            u_14_phi_144 = u_14_39;
			// False  <=>  if({b_5_11 : False})
            if (b_5_11)
            {
				// 1068216142  <=>  {u_15_phi_143 : 1068216142}
                u_14_40 = u_15_phi_143;
                u_14_phi_144 = u_14_40;
            }
			// False  <=>  ((((abs(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00})) == {utof2(0x7f800000) : ∞}) && (! isnan(abs(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}))))) && (! isnan({utof2(0x7f800000) : ∞}))) && ((! ({u_15_26 : 0} == 0u)) || (! ({u_15_26 : 0} == 0u))))
            b_1_67 = ((((abs((pf_7_8 * f_20_18)) == utof2(0x7f800000)) && (!isnan(abs((pf_7_8 * f_20_18))))) && (!isnan( utof2(0x7f800000)))) && ((!(u_15_26 == 0u)) || (!(u_15_26 == 0u))));
			// 1056964608  <=>  {u_14_phi_144 : 1056964608}
            u_15_31 = u_14_phi_144;
            u_15_phi_145 = u_15_31;
			// True  <=>  if(((! {b_1_67 : False}) ? true : false))
            if (((!b_1_67) ? true : false))
            {
				// 0.8526533  <=>  max(abs(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00})), abs(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00})))
                f_0_22 = max(abs((pf_3_19 * f_20_18)), abs((pf_7_8 * f_20_18)));
				// False  <=>  ((({f_0_22 : 0.8526533} >= 16.f) && (! isnan({f_0_22 : 0.8526533}))) && (! isnan(16.f)))
                b_3_88 = (((f_0_22 >= 16.f) && (!isnan(f_0_22))) && (!isnan(16.f)));
				// 1062881148  <=>  {ftou2(f_0_22) : 1062881148}
                u_18_3 = ftou2(f_0_22);
                u_18_phi_146 = u_18_3;
				// False  <=>  if(({b_3_88 : False} ? true : false))
                if ((b_3_88 ? true : false))
                {
					// 1029326716  <=>  {ftou2(({f_0_22 : 0.8526533} * 0.0625f)) : 1029326716}
                    u_19_9 = ftou2((f_0_22 * 0.0625f));
					// 1029326716  <=>  {u_19_9 : 1029326716}
                    u_18_4 = u_19_9;
                    u_18_phi_146 = u_18_4;
                }
				// 1055969165  <=>  {ftou2(min(abs(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00})), abs(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00})))) : 1055969165}
                u_16_28 = ftou2(min(abs((pf_3_19 * f_20_18)), abs((pf_7_8 * f_20_18))));
                u_16_phi_147 = u_16_28;
				// False  <=>  if(({b_3_88 : False} ? true : false))
                if ((b_3_88 ? true : false))
                {
					// 1022414733  <=>  {ftou2((min(abs(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00})), abs(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}))) * 0.0625f)) : 1022414733}
                    u_19_10 = ftou2((min(abs((pf_3_19 * f_20_18)), abs((pf_7_8 * f_20_18))) * 0.0625f));
					// 1022414733  <=>  {u_19_10 : 1022414733}
                    u_16_29 = u_19_10;
                    u_16_phi_147 = u_16_29;
                }
				// 0.4703335  <=>  abs(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}))
                f_7_87 = abs((pf_3_19 * f_20_18));
				// 0.5516117  <=>  ((1.0f / {utof2(u_18_phi_146) : 0.8526533}) * {utof2(u_16_phi_147) : 0.4703335})
                pf_21_27 = ((1.0f / utof2(u_18_phi_146)) * utof2(u_16_phi_147));
				// 11.63966  <=>  (({pf_21_27 : 0.5516117} * {pf_21_27 : 0.5516117}) + 11.335388f)
                pf_23_17 = ((pf_21_27 * pf_21_27) + 11.335388f);
				// -5.925396  <=>  ((({pf_21_27 : 0.5516117} * {pf_21_27 : 0.5516117}) * -0.82336295f) + (0.f - 5.674867f))
                pf_24_35 = (((pf_21_27 * pf_21_27) * -0.82336295f) + (0.f - 5.674867f));
				// 32.38413  <=>  ((({pf_21_27 : 0.5516117} * {pf_21_27 : 0.5516117}) * {pf_23_17 : 11.63966}) + 28.842468f)
                pf_23_18 = (((pf_21_27 * pf_21_27) * pf_23_17) + 28.842468f);
				// -8.368507  <=>  ((({pf_21_27 : 0.5516117} * {pf_21_27 : 0.5516117}) * {pf_24_35 : -5.925396}) + -6.565555f)
                pf_24_36 = (((pf_21_27 * pf_21_27) * pf_24_35) + -6.565555f);
				// 29.55037  <=>  ((({pf_21_27 : 0.5516117} * {pf_21_27 : 0.5516117}) * {pf_23_18 : 32.38413}) + 19.69667f)
                pf_23_19 = (((pf_21_27 * pf_21_27) * pf_23_18) + 19.69667f);
				// -2.546331  <=>  (({pf_21_27 : 0.5516117} * {pf_21_27 : 0.5516117}) * {pf_24_36 : -8.368507})
                pf_22_41 = ((pf_21_27 * pf_21_27) * pf_24_36);
				// 0.5040797  <=>  ((({pf_21_27 : 0.5516117} * {pf_22_41 : -2.546331}) * (1.0f / {pf_23_19 : 29.55037})) + {pf_21_27 : 0.5516117})
                pf_21_28 = (((pf_21_27 * pf_22_41) * (1.0f / pf_23_19)) + pf_21_27);
				// True  <=>  ((((abs(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00})) > {f_7_87 : 0.4703335}) && (! isnan(abs(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}))))) && (! isnan({f_7_87 : 0.4703335}))) ? true : false)
                b_4_41 = ((((abs((pf_7_8 * f_20_18)) > f_7_87) && (!isnan(abs((pf_7_8 * f_20_18))))) && (!isnan(f_7_87))) ? true : false);
				// 1057033054  <=>  {ftou2(pf_21_28) : 1057033054}
                u_17_13 = ftou2(pf_21_28);
                u_17_phi_148 = u_17_13;
				// True  <=>  if({b_4_41 : True})
                if (b_4_41)
                {
					// 1065912876  <=>  {ftou2(((0.f - {pf_21_28 : 0.5040797}) + 1.5707964f)) : 1065912876}
                    u_17_14 = ftou2(((0.f - pf_21_28) + 1.5707964f));
                    u_17_phi_148 = u_17_14;
                }
				// 1065912876  <=>  {u_17_phi_148 : 1065912876}
                u_16_31 = u_17_phi_148;
                u_16_phi_149 = u_16_31;
				// True  <=>  if(((((({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) < 0.f) && (! isnan(({pf_3_19 : -0.4703335} * {f_20_18 : 1.00})))) && (! isnan(0.f))) ? true : false))
                if ((((((pf_3_19 * f_20_18) < 0.f) && (!isnan((pf_3_19 * f_20_18)))) && (!isnan(0.f))) ? true : false))
                {
					// 1074055877  <=>  {ftou2(((0.f - {utof2(u_17_phi_148) : 1.066717}) + 3.1415927f)) : 1074055877}
                    u_16_32 = ftou2(((0.f - utof2(u_17_phi_148)) + 3.1415927f));
                    u_16_phi_149 = u_16_32;
                }
				// 1074055877  <=>  {u_16_phi_149 : 1074055877}
                u_17_15 = u_16_phi_149;
                u_17_phi_150 = u_17_15;
				// False  <=>  if(((((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) < 0.f) && (! isnan(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00})))) && (! isnan(0.f))) ? true : false))
                if ((((((pf_7_8 * f_20_18) < 0.f) && (!isnan((pf_7_8 * f_20_18)))) && (!isnan(0.f))) ? true : false))
                {
					// 3221539525  <=>  {ftou2(((0.f - {utof2(u_16_phi_149) : 2.074876}) + (0.f - 0.f))) : 3221539525}
                    u_17_16 = ftou2(((0.f - utof2(u_16_phi_149)) + (0.f - 0.f)));
                    u_17_phi_150 = u_17_16;
                }
				// 1074055877  <=>  {u_17_phi_150 : 1074055877}
                u_15_32 = u_17_phi_150;
                u_15_phi_145 = u_15_32;
            }
			// 1074055877  <=>  {u_15_phi_145 : 1074055877}
            u_10_35 = u_15_phi_145;
            u_10_phi_139 = u_10_35;
        }
		// 1059656572  <=>  {ftou2(({utof2(u_10_phi_139) : 2.074876} * 0.31830987f)) : 1059656572}
        u_9_23 = ftou2(( utof2(u_10_phi_139) * 0.31830987f));
        u_9_phi_134 = u_9_23;
    }
	// 1059656572  <=>  {u_9_phi_134 : 1059656572}
    u_0_30 = u_9_phi_134;
    u_0_phi_151 = u_0_30;
	// False  <=>  if(((! {b_1_62 : True}) ? true : false))
    if (((!b_1_62) ? true : false))
    {
		// 1056964608  <=>  ((((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) <= 0.f) || isnan(({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}))) || isnan(0.f)) ? 3204448256u : 1056964608u)
        u_0_31 = (((((pf_7_8 * f_20_18) <= 0.f) || isnan((pf_7_8 * f_20_18))) || isnan(0.f)) ? 3204448256u : 1056964608u);
        u_0_phi_151 = u_0_31;
    }
	// 0.3302268  <=>  ((({utof2(u_0_phi_151) : 0.6604536} * 0.5f) + 1.f) + (0.f - floor((({utof2(u_0_phi_151) : 0.6604536} * 0.5f) + 1.f))))
    pf_21_34 = ((( utof2(u_0_phi_151) * 0.5f) + 1.f) + (0.f - floor((( utof2(u_0_phi_151) * 0.5f) + 1.f))));
	// 6.905067  <=>  (float(int({u_2_19 : 16})) * (({pf_9_10 : 1.10134} + {pf_21_34 : 0.3302268}) + (0.f - floor(({pf_9_10 : 1.10134} + {pf_21_34 : 0.3302268})))))
    pf_21_37 = (float(int(u_2_19)) * ((pf_9_10 + pf_21_34) + (0.f - floor((pf_9_10 + pf_21_34)))));
	// 21  <=>  (({u_2_19 : 16} + 4294967295u) + (isnan({pf_21_37 : 6.905067}) ? 0u : uint(clamp(floor({pf_21_37 : 6.905067}), float(-2147483600.f), float(2147483600.f)))))
    u_9_25 = ((u_2_19 + 4294967295u) + (isnan(pf_21_37) ? 0u : uint(clamp(floor(pf_21_37), float(-2147483600.f), float(2147483600.f)))));
	// 0.0625  <=>  {utof2(({ftou2((1.0f / float({u_2_19 : 16}))) : 1031798784} + 4294967294u)) : 0.0625}
    f_1_25 = utof2(( ftou2((1.0f / float(u_2_19))) + 4294967294u));
	// 1  <=>  uint(clamp(trunc(({f_1_25 : 0.0625} * float({u_9_25 : 21}))), float(0.f), float(4294967300.f)))
    u_10_36 = uint(clamp(trunc((f_1_25 * float(u_9_25))), float(0.f), float(4294967300.f)));
	// 65536  <=>  bitfieldInsert(uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(16u))) * uint(bitfieldExtract(uint({u_10_36 : 1}), int(16u), int(16u))))), uint(bitfieldExtract(uint({u_10_36 : 1}), int(0u), int(16u))), int(16u), int(16u))
    u_15_36 = bitfieldInsert(uint((uint(bitfieldExtract(uint(u_2_19), int(0u), int(16u))) * uint(bitfieldExtract(uint(u_10_36), int(16u), int(16u))))), uint(bitfieldExtract(uint(u_10_36), int(0u), int(16u))), int(16u), int(16u));
	// 1  <=>  uint(bitfieldExtract(uint({u_15_36 : 65536}), int(16u), int(16u)))
    u_17_17 = uint(bitfieldExtract(uint(u_15_36), int(16u), int(16u)));
	// 16  <=>  ((uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(16u), int(16u))) * {u_17_17 : 1})) << 16u) + (({u_15_36 : 65536} << 16u) + uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(16u))) * uint(bitfieldExtract(uint({u_10_36 : 1}), int(0u), int(16u)))))))
    u_14_44 = ((uint((uint(bitfieldExtract(uint(u_2_19), int(16u), int(16u))) * u_17_17)) << 16u) + ((u_15_36 << 16u) + uint((uint(bitfieldExtract(uint(u_2_19), int(0u), int(16u))) * uint(bitfieldExtract(uint(u_10_36), int(0u), int(16u)))))));
	// 0.0625  <=>  {utof2(({ftou2((1.0f / float({u_2_19 : 16}))) : 1031798784} + 4294967294u)) : 0.0625}
    f_1_26 = utof2(( ftou2((1.0f / float(u_2_19))) + 4294967294u));
	// 0.00  <=>  trunc(({f_1_26 : 0.0625} * float(({u_9_25 : 21} + uint((int(0) - int({u_14_44 : 16})))))))
    f_0_46 = trunc((f_1_26 * float((u_9_25 + uint((int(0) - int(u_14_44)))))));
	// 1  <=>  uint(bitfieldExtract(uint(({u_10_36 : 1} + uint(clamp({f_0_46 : 0.00}, float(0.f), float(4294967300.f))))), int(0u), int(16u)))
    u_14_47 = uint(bitfieldExtract(uint((u_10_36 + uint(clamp(f_0_46, float(0.f), float(4294967300.f))))), int(0u), int(16u)));
	// 0  <=>  uint(bitfieldExtract(uint(({u_10_36 : 1} + uint(clamp({f_0_46 : 0.00}, float(0.f), float(4294967300.f))))), int(16u), int(16u)))
    u_15_38 = uint(bitfieldExtract(uint((u_10_36 + uint(clamp(f_0_46, float(0.f), float(4294967300.f))))), int(16u), int(16u)));
	// 1  <=>  uint(bitfieldExtract(uint(({u_10_36 : 1} + uint(clamp({f_0_46 : 0.00}, float(0.f), float(4294967300.f))))), int(0u), int(16u)))
    u_15_39 = uint(bitfieldExtract(uint((u_10_36 + uint(clamp(f_0_46, float(0.f), float(4294967300.f))))), int(0u), int(16u)));
	// 65536  <=>  bitfieldInsert(uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(16u))) * {u_15_38 : 0})), {u_15_39 : 1}, int(16u), int(16u))
    u_14_50 = bitfieldInsert(uint((uint(bitfieldExtract(uint(u_2_19), int(0u), int(16u))) * u_15_38)), u_15_39, int(16u), int(16u));
	// 1  <=>  uint(bitfieldExtract(uint({u_14_50 : 65536}), int(16u), int(16u)))
    u_16_38 = uint(bitfieldExtract(uint(u_14_50), int(16u), int(16u)));
	// 16  <=>  ((uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(16u), int(16u))) * {u_16_38 : 1})) << 16u) + (({u_14_50 : 65536} << 16u) + uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(16u))) * {u_14_47 : 1}))))
    u_10_40 = ((uint((uint(bitfieldExtract(uint(u_2_19), int(16u), int(16u))) * u_16_38)) << 16u) + ((u_14_50 << 16u) + uint((uint(bitfieldExtract(uint(u_2_19), int(0u), int(16u))) * u_14_47))));
	// 0  <=>  ((uint(({u_9_25 : 21} + uint((int(0) - int({u_10_40 : 16}))))) >= uint({u_2_19 : 16})) ? 4294967295u : 0u)
    u_10_43 = ((uint((u_9_25 + uint((int(0) - int(u_10_40))))) >= uint(u_2_19)) ? 4294967295u : 0u);
	// 4294967295  <=>  uint((int(0) - int(({u_10_36 : 1} + uint(clamp({f_0_46 : 0.00}, float(0.f), float(4294967300.f)))))))
    u_8_18 = uint((int(0) - int((u_10_36 + uint(clamp(f_0_46, float(0.f), float(4294967300.f)))))));
	// 1048560  <=>  uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(16u))) * uint(bitfieldExtract(uint(({u_8_18 : 4294967295} + {u_10_43 : 0})), int(16u), int(16u)))))
    u_14_54 = uint((uint(bitfieldExtract(uint(u_2_19), int(0u), int(16u))) * uint(bitfieldExtract(uint((u_8_18 + u_10_43)), int(16u), int(16u)))));
	// 65535  <=>  uint(bitfieldExtract(uint(({u_8_18 : 4294967295} + {u_10_43 : 0})), int(0u), int(16u)))
    u_8_20 = uint(bitfieldExtract(uint((u_8_18 + u_10_43)), int(0u), int(16u)));
	// 0  <=>  (uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(16u), int(16u))) * uint(bitfieldExtract(uint(bitfieldInsert({u_14_54 : 1048560}, {u_8_20 : 65535}, int(16u), int(16u))), int(16u), int(16u))))) << 16u)
    u_2_22 = (uint((uint(bitfieldExtract(uint(u_2_19), int(16u), int(16u))) * uint(bitfieldExtract(uint(bitfieldInsert(u_14_54, u_8_20, int(16u), int(16u))), int(16u), int(16u))))) << 16u);
	// 4294967280  <=>  ((bitfieldInsert({u_14_54 : 1048560}, {u_8_20 : 65535}, int(16u), int(16u)) << 16u) + uint((uint(bitfieldExtract(uint({u_2_19 : 16}), int(0u), int(16u))) * uint(bitfieldExtract(uint(({u_8_18 : 4294967295} + {u_10_43 : 0})), int(0u), int(16u))))))
    u_8_23 = ((bitfieldInsert(u_14_54, u_8_20, int(16u), int(16u)) << 16u) + uint((uint(bitfieldExtract(uint(u_2_19), int(0u), int(16u))) * uint(bitfieldExtract(uint((u_8_18 + u_10_43)), int(0u), int(16u))))));
	// 4294967280  <=>  ({u_2_22 : 0} + {u_8_23 : 4294967280})
    u_2_23 = (u_2_22 + u_8_23);
	// -0.8335257  <=>  ((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * (0.f - {utof(view_proj[1].y) : 0.829457})) + (0.f - ({pf_6_14 : 0.2275276} * (0.f - {utof(view_proj[1].z) : -0.5550383}))))
    pf_23_23 = (((pf_7_8 * f_20_18) * (0.f - utof(view_proj[1].y))) + (0.f - (pf_6_14 * (0.f - utof(view_proj[1].z)))));
	// 6  <=>  int(clamp(floor(({f_5_49 : 15.00} * ({pf_16_70 : 1.341287} * 0.31830987f))), float(-2147483600.f), float(2147483600.f)))
    u_10_46 = int(clamp(floor((f_5_49 * (pf_16_70 * 0.31830987f))), float(-2147483600.f), float(2147483600.f)));
	// 6.00  <=>  float(int((isnan(({f_5_49 : 15.00} * ({pf_16_70 : 1.341287} * 0.31830987f))) ? 0u : {u_10_46 : 6})))
    f_0_54 = float(int((isnan((f_5_49 * (pf_16_70 * 0.31830987f))) ? 0u : u_10_46)));
	// False  <=>  ((isnan(({f_5_49 : 15.00} * ({pf_16_70 : 1.341287} * 0.31830987f))) ? 0u : {u_10_46 : 6}) == 0u)
    b_0_31 = ((isnan((f_5_49 * (pf_16_70 * 0.31830987f))) ? 0u : u_10_46) == 0u);
	// -1.10134  <=>  (((0.f - {pf_9_10 : 1.10134}) + {f_2_65 : 0.0625}) + ({f_2_65 : 0.0625} * float(int(({b_0_30 : False} ? ({u_9_25 : 21} + {u_2_23 : 4294967280}) : 4294967295u)))))
    pf_27_23 = (((0.f - pf_9_10) + f_2_65) + (f_2_65 * float(int((b_0_30 ? (u_9_25 + u_2_23) : 4294967295u)))));
	// 0.3090169  <=>  cos((({f_0_54 : 6.00} * (1.0f / {f_5_49 : 15.00})) * 3.1415927f))
    f_5_50 = cos(((f_0_54 * (1.0f / f_5_49)) * 3.1415927f));
	// 0.8986601  <=>  ({pf_27_23 : -1.10134} + (0.f - floor({pf_27_23 : -1.10134})))
    pf_26_27 = (pf_27_23 + (0.f - floor(pf_27_23)));
	// -0.3090169  <=>  (0.f - {f_5_50 : 0.3090169})
    f_1_31 = (0.f - f_5_50);
	// 0.9045086  <=>  (({f_5_50 : 0.3090169} * {f_1_31 : -0.3090169}) + 1.f)
    pf_27_24 = ((f_5_50 * f_1_31) + 1.f);
	// 0.8040398  <=>  cos(({pf_26_27 : 0.8986601} * 6.2831855f))
    f_7_88 = cos((pf_26_27 * 6.2831855f));
	// -0.5945755  <=>  sin(({pf_26_27 : 0.8986601} * 6.2831855f))
    f_8_54 = sin((pf_26_27 * 6.2831855f));
	// -0.2075762  <=>  ((({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * (0.f - {utof(view_proj[1].z) : -0.5550383})) + (0.f - (({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * (0.f - {utof(view_proj[1].x) : 0.0627182}))))
    pf_22_44 = (((pf_3_19 * f_20_18) * (0.f - utof(view_proj[1].z))) + (0.f - ((pf_7_8 * f_20_18) * (0.f - utof(view_proj[1].x)))));
	// 0.6947652  <=>  ({pf_23_23 : -0.8335257} * {pf_23_23 : -0.8335257})
    pf_27_25 = (pf_23_23 * pf_23_23);
	// 0.7646873  <=>  ({f_7_88 : 0.8040398} * sqrt({pf_27_24 : 0.9045086}))
    pf_28_36 = (f_7_88 * sqrt(pf_27_24));
	// -0.5654749  <=>  ({f_8_54 : -0.5945755} * sqrt({pf_27_24 : 0.9045086}))
    pf_29_31 = (f_8_54 * sqrt(pf_27_24));
	// 0.6802381  <=>  (({f_5_50 : 0.3090169} * {f_5_50 : 0.3090169}) + ({pf_28_36 : 0.7646873} * {pf_28_36 : 0.7646873}))
    pf_30_21 = ((f_5_50 * f_5_50) + (pf_28_36 * pf_28_36));
	// 1.00  <=>  inversesqrt((({pf_29_31 : -0.5654749} * {pf_29_31 : -0.5654749}) + {pf_30_21 : 0.6802381}))
    f_1_33 = inversesqrt(((pf_29_31 * pf_29_31) + pf_30_21));
	// 0.3090169  <=>  ({f_5_50 : 0.3090169} * {f_1_33 : 1.00})
    pf_31_17 = (f_5_50 * f_1_33);
	// 0.5847468  <=>  (({pf_28_36 : 0.7646873} * {f_1_33 : 1.00}) * ({pf_28_36 : 0.7646873} * {f_1_33 : 1.00}))
    pf_32_11 = ((pf_28_36 * f_1_33) * (pf_28_36 * f_1_33));
	// 0.6802382  <=>  (({pf_31_17 : 0.3090169} * {pf_31_17 : 0.3090169}) + {pf_32_11 : 0.5847468})
    pf_32_12 = ((pf_31_17 * pf_31_17) + pf_32_11);
	// 1.00  <=>  ((({pf_29_31 : -0.5654749} * {f_1_33 : 1.00}) * ({pf_29_31 : -0.5654749} * {f_1_33 : 1.00})) + {pf_32_12 : 0.6802382})
    pf_32_13 = (((pf_29_31 * f_1_33) * (pf_29_31 * f_1_33)) + pf_32_12);
	// -0.4043915  <=>  (({pf_6_14 : 0.2275276} * (0.f - {utof(view_proj[1].x) : 0.0627182})) + (0.f - (({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * (0.f - {utof(view_proj[1].y) : 0.829457}))))
    pf_30_24 = ((pf_6_14 * (0.f - utof(view_proj[1].x))) + (0.f - ((pf_3_19 * f_20_18) * (0.f - utof(view_proj[1].y)))));
	// -0.5654749  <=>  (({pf_29_31 : -0.5654749} * {f_1_33 : 1.00}) * inversesqrt({pf_32_13 : 1.00}))
    pf_33_13 = ((pf_29_31 * f_1_33) * inversesqrt(pf_32_13));
	// 0.7646873  <=>  (({pf_28_36 : 0.7646873} * {f_1_33 : 1.00}) * inversesqrt({pf_32_13 : 1.00}))
    pf_34_14 = ((pf_28_36 * f_1_33) * inversesqrt(pf_32_13));
	// 1.053282  <=>  inversesqrt((({pf_30_24 : -0.4043915} * {pf_30_24 : -0.4043915}) + (({pf_22_44 : -0.2075762} * {pf_22_44 : -0.2075762}) + {pf_27_25 : 0.6947652})))
    f_1_35 = inversesqrt(((pf_30_24 * pf_30_24) + ((pf_22_44 * pf_22_44) + pf_27_25)));
	// 0.5654749  <=>  ((0.f * ({pf_31_17 : 0.3090169} * inversesqrt({pf_32_13 : 1.00}))) + (0.f - {pf_33_13 : -0.5654749}))
    pf_35_19 = ((0.f * (pf_31_17 * inversesqrt(pf_32_13))) + (0.f - pf_33_13));
	// 0.7646873  <=>  ((0.f - 0.f) + {pf_34_14 : 0.7646873})
    pf_36_19 = ((0.f - 0.f) + pf_34_14);
	// 0.9045086  <=>  (({pf_36_19 : 0.7646873} * {pf_36_19 : 0.7646873}) + (({pf_35_19 : 0.5654749} * {pf_35_19 : 0.5654749}) + 0.f))
    pf_37_14 = ((pf_36_19 * pf_36_19) + ((pf_35_19 * pf_35_19) + 0.f));
	// 1.051462  <=>  inversesqrt({pf_37_14 : 0.9045086})
    f_5_55 = inversesqrt(pf_37_14);
	// 0.2186363  <=>  (0.f - ({pf_22_44 : -0.2075762} * {f_1_35 : 1.053282}))
    f_1_36 = (0.f - (pf_22_44 * f_1_35));
	// 0.4259384  <=>  (0.f - ({pf_30_24 : -0.4043915} * {f_1_35 : 1.053282}))
    f_1_37 = (0.f - (pf_30_24 * f_1_35));
	// -0.2003331  <=>  (({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {f_1_37 : 0.4259384})
    pf_41_3 = ((pf_3_19 * f_20_18) * f_1_37);
	// 0.8779377  <=>  (0.f - ({pf_23_23 : -0.8335257} * {f_1_35 : 1.053282}))
    f_1_38 = (0.f - (pf_23_23 * f_1_35));
	// 0.4259384  <=>  (0.f - ({pf_30_24 : -0.4043915} * {f_1_35 : 1.053282}))
    f_1_39 = (0.f - (pf_30_24 * f_1_35));
	// -0.0895083  <=>  (({pf_6_14 : 0.2275276} * {f_1_39 : 0.4259384}) + (0.f - (({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {f_1_36 : 0.2186363})))
    pf_40_4 = ((pf_6_14 * f_1_39) + (0.f - ((pf_7_8 * f_20_18) * f_1_36)));
	// 0.8779377  <=>  (0.f - ({pf_23_23 : -0.8335257} * {f_1_35 : 1.053282}))
    f_1_40 = (0.f - (pf_23_23 * f_1_35));
	// 0.9489095  <=>  ((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {f_1_40 : 0.8779377}) + (0.f - {pf_41_3 : -0.2003331}))
    pf_41_4 = (((pf_7_8 * f_20_18) * f_1_40) + (0.f - pf_41_3));
	// 3206034970  <=>  {ftou2(({pf_35_19 : 0.5654749} * (0.f - {f_5_55 : 1.051462}))) : 3206034970}
    u_15_44 = ftou2((pf_35_19 * (0.f - f_5_55)));
	// 0.0080117  <=>  ({pf_40_4 : -0.0895083} * {pf_40_4 : -0.0895083})
    pf_44_0 = (pf_40_4 * pf_40_4);
	// 0.2186363  <=>  (0.f - ({pf_22_44 : -0.2075762} * {f_1_35 : 1.053282}))
    f_1_44 = (0.f - (pf_22_44 * f_1_35));
	// -0.302587  <=>  ((({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {f_1_44 : 0.2186363}) + (0.f - ({pf_6_14 : 0.2275276} * {f_1_38 : 0.8779377})))
    pf_42_4 = (((pf_3_19 * f_20_18) * f_1_44) + (0.f - (pf_6_14 * f_1_38)));
	// 7  <=>  ((isnan(({f_5_49 : 15.00} * ({pf_16_70 : 1.341287} * 0.31830987f))) ? 0u : {u_10_46 : 6}) + 1u)
    u_16_39 = ((isnan((f_5_49 * (pf_16_70 * 0.31830987f))) ? 0u : u_10_46) + 1u);
	// -0.1837339  <=>  (({pf_31_17 : 0.3090169} * inversesqrt({pf_32_13 : 1.00})) * ({pf_35_19 : 0.5654749} * (0.f - {f_5_55 : 1.051462})))
    pf_47_0 = ((pf_31_17 * inversesqrt(pf_32_13)) * (pf_35_19 * (0.f - f_5_55)));
	// -0.2484618  <=>  ((({pf_31_17 : 0.3090169} * inversesqrt({pf_32_13 : 1.00})) * ({pf_36_19 : 0.7646873} * (0.f - {f_5_55 : 1.051462}))) + (0.f - ({pf_33_13 : -0.5654749} * (0.f * (0.f - {f_5_55 : 1.051462})))))
    pf_36_21 = (((pf_31_17 * inversesqrt(pf_32_13)) * (pf_36_19 * (0.f - f_5_55))) + (0.f - (pf_33_13 * (0.f * (0.f - f_5_55)))));
	// 0.614839  <=>  (0.f - ({pf_34_14 : 0.7646873} * ({pf_36_19 : 0.7646873} * (0.f - {f_5_55 : 1.051462}))))
    f_5_58 = (0.f - (pf_34_14 * (pf_36_19 * (0.f - f_5_55))));
	// 0.9510565  <=>  (({pf_33_13 : -0.5654749} * ({pf_35_19 : 0.5654749} * (0.f - {f_5_55 : 1.051462}))) + {f_5_58 : 0.614839})
    pf_35_21 = ((pf_33_13 * (pf_35_19 * (0.f - f_5_55))) + f_5_58);
	// 0.1837339  <=>  (({pf_34_14 : 0.7646873} * (0.f * (0.f - {f_5_55 : 1.051462}))) + (0.f - {pf_47_0 : -0.1837339}))
    pf_43_4 = ((pf_34_14 * (0.f * (0.f - f_5_55))) + (0.f - pf_47_0));
	// 2147483648  <=>  {ftou2((0.f * (0.f - {f_5_55 : 1.051462}))) : 2147483648}
    u_17_18 = ftou2((0.f * (0.f - f_5_55)));
    u_17_phi_152 = u_17_18;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 0  <=>  0u
        u_17_19 = 0u;
        u_17_phi_152 = u_17_19;
    }
	// 1088222800  <=>  {ftou2(pf_21_37) : 1088222800}
    u_18_8 = ftou2(pf_21_37);
    u_18_phi_153 = u_18_8;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 7  <=>  {u_4_14 : 7}
        u_18_9 = u_4_14;
        u_18_phi_153 = u_18_9;
    }
	// 1088222800  <=>  {u_18_phi_153 : 1088222800}
    u_0_33 = u_18_phi_153;
    u_0_phi_154 = u_0_33;
	// True  <=>  if(((! {b_0_31 : False}) ? true : false))
    if (((!b_0_31) ? true : false))
    {
		// 4294967295  <=>  ({b_0_30 : False} ? ({u_9_25 : 21} + {u_2_23 : 4294967280}) : 4294967295u)
        u_0_34 = (b_0_30 ? (u_9_25 + u_2_23) : 4294967295u);
        u_0_phi_154 = u_0_34;
    }
	// 1.00  <=>  inversesqrt((({pf_42_4 : -0.302587} * {pf_42_4 : -0.302587}) + (({pf_41_4 : 0.9489095} * {pf_41_4 : 0.9489095}) + {pf_44_0 : 0.0080117})))
    f_1_47 = inversesqrt(((pf_42_4 * pf_42_4) + ((pf_41_4 * pf_41_4) + pf_44_0)));
	// 1031592971  <=>  {ftou2(({pf_36_21 : -0.2484618} * {pf_36_21 : -0.2484618})) : 1031592971}
    u_18_10 = ftou2((pf_36_21 * pf_36_21));
    u_18_phi_155 = u_18_10;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
        u_18_11 = ftou2((pf_9_10 * 6.2831855f));
        u_18_phi_155 = u_18_11;
    }
	// 0.4041748  <=>  (({f_5_49 : 15.00} * ({pf_16_70 : 1.341287} * 0.31830987f)) + (0.f - floor(({f_5_49 : 15.00} * ({pf_16_70 : 1.341287} * 0.31830987f)))))
    pf_13_27 = ((f_5_49 * (pf_16_70 * 0.31830987f)) + (0.f - floor((f_5_49 * (pf_16_70 * 0.31830987f)))));
	// 1087172352  <=>  {ftou2(({f_5_49 : 15.00} * ({pf_16_70 : 1.341287} * 0.31830987f))) : 1087172352}
    u_9_28 = ftou2((f_5_49 * (pf_16_70 * 0.31830987f)));
    u_9_phi_156 = u_9_28;
	// True  <=>  if(((! ({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u))) ? true : false))
    if (((!(u_16_39 == (u_1_20 + 4294967295u))) ? true : false))
    {
		// 4294967295  <=>  ({b_0_30 : False} ? ({u_9_25 : 21} + {u_2_23 : 4294967280}) : 4294967295u)
        u_9_29 = (b_0_30 ? (u_9_25 + u_2_23) : 4294967295u);
        u_9_phi_156 = u_9_29;
    }
	// 1031592971  <=>  {u_18_phi_155 : 1031592971}
    u_8_25 = u_18_phi_155;
    u_8_phi_157 = u_8_25;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 1031592971  <=>  {u_18_phi_155 : 1031592971}
        u_8_26 = u_18_phi_155;
        u_8_phi_157 = u_8_26;
    }
	// 1.00  <=>  inversesqrt((({pf_43_4 : 0.1837339} * {pf_43_4 : 0.1837339}) + (({pf_35_21 : 0.9510565} * {pf_35_21 : 0.9510565}) + ({pf_36_21 : -0.2484618} * {pf_36_21 : -0.2484618}))))
    f_5_62 = inversesqrt(((pf_43_4 * pf_43_4) + ((pf_35_21 * pf_35_21) + (pf_36_21 * pf_36_21))));
	// 4294967295  <=>  ({b_0_30 : False} ? ({u_9_25 : 21} + {u_2_23 : 4294967280}) : 4294967295u)
    u_18_12 = (b_0_30 ? (u_9_25 + u_2_23) : 4294967295u);
    u_18_phi_158 = u_18_12;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 7  <=>  {u_4_14 : 7}
        u_18_13 = u_4_14;
        u_18_phi_158 = u_18_13;
    }
	// 3206034970  <=>  {u_15_44 : 3206034970}
    u_2_26 = u_15_44;
    u_2_phi_159 = u_2_26;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 1031582447  <=>  {ftou2(sin({utof2(u_8_phi_157) : 0.0617333})) : 1031582447}
        u_2_27 = ftou2(sin( utof2(u_8_phi_157)));
        u_2_phi_159 = u_2_27;
    }
	// 4294967295  <=>  {u_9_phi_156 : 4294967295}
    u_15_45 = u_9_phi_156;
    u_15_phi_160 = u_15_45;
	// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
    if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
    {
		// 7  <=>  {u_4_14 : 7}
        u_15_46 = u_4_14;
        u_15_phi_160 = u_15_46;
    }
	// -0.0895083  <=>  ({pf_40_4 : -0.0895083} * {f_1_47 : 1.00})
    pf_40_5 = (pf_40_4 * f_1_47);
	// 0.048909  <=>  (float(int({u_1_20 : 16})) * (((({utof2(u_11_phi_133) : 0.451091} * -2.f) * 0.5f) + 0.5f) * 0.0625f))
    pf_44_5 = (float(int(u_1_20)) * (((( utof2(u_11_phi_133) * -2.f) * 0.5f) + 0.5f) * 0.0625f));
	// 1.044534  <=>  (float(int({u_2_19 : 16})) * (((({utof2(u_12_phi_133) : 0.5445337} * 2.f) * 0.5f) + 0.5f) * 0.0625f))
    pf_45_3 = (float(int(u_2_19)) * (((( utof2(u_12_phi_133) * 2.f) * 0.5f) + 0.5f) * 0.0625f));
	// 4294967295  <=>  {u_18_phi_158 : 4294967295}
    u_9_30 = u_18_phi_158;
    u_9_phi_161 = u_9_30;
	// True  <=>  if(((! {b_0_31 : False}) ? true : false))
    if (((!b_0_31) ? true : false))
    {
		// 6  <=>  (isnan({pf_21_37 : 6.905067}) ? 0u : uint(clamp(floor({pf_21_37 : 6.905067}), float(-2147483600.f), float(2147483600.f))))
        u_9_31 = (isnan(pf_21_37) ? 0u : uint(clamp(floor(pf_21_37), float(-2147483600.f), float(2147483600.f))));
        u_9_phi_161 = u_9_31;
    }
	// 7  <=>  {u_4_14 : 7}
    u_18_14 = u_4_14;
    u_18_phi_162 = u_18_14;
	// True  <=>  if(((! ({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u))) ? true : false))
    if (((!(u_16_39 == (u_1_20 + 4294967295u))) ? true : false))
    {
		// 6  <=>  (isnan({pf_21_37 : 6.905067}) ? 0u : uint(clamp(floor({pf_21_37 : 6.905067}), float(-2147483600.f), float(2147483600.f))))
        u_18_15 = (isnan(pf_21_37) ? 0u : uint(clamp(floor(pf_21_37), float(-2147483600.f), float(2147483600.f))));
        u_18_phi_162 = u_18_15;
    }
	// 3195956426  <=>  {ftou2(({pf_36_21 : -0.2484618} * {f_5_62 : 1.00})) : 3195956426}
    u_19_13 = ftou2((pf_36_21 * f_5_62));
    u_19_phi_163 = u_19_13;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 1065321257  <=>  {ftou2(cos({utof2(u_8_phi_157) : 0.0617333})) : 1065321257}
        u_19_14 = ftou2(cos( utof2(u_8_phi_157)));
        u_19_phi_163 = u_19_14;
    }
	// 1044128955  <=>  {ftou2(({pf_43_4 : 0.1837339} * {f_5_62 : 1.00})) : 1044128955}
    u_8_28 = ftou2((pf_43_4 * f_5_62));
	// 1064532083  <=>  {ftou2(({pf_35_21 : 0.9510565} * {f_5_62 : 1.00})) : 1064532083}
    u_20_16 = ftou2((pf_35_21 * f_5_62));
    u_20_phi_164 = u_20_16;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 0  <=>  0u
        u_20_17 = 0u;
        u_20_phi_164 = u_20_17;
    }
	// 1044128955  <=>  {u_8_28 : 1044128955}
    u_4_17 = u_8_28;
    u_4_phi_165 = u_4_17;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 1058551322  <=>  {ftou2(((0.f - {utof2(u_2_phi_159) : -0.5945755}) + (0.f - 0.f))) : 1058551322}
        u_4_18 = ftou2(((0.f - utof2(u_2_phi_159)) + (0.f - 0.f)));
        u_4_phi_165 = u_4_18;
    }
	// 3209549197  <=>  {ftou2(({pf_36_19 : 0.7646873} * (0.f - {f_5_55 : 1.051462}))) : 3209549197}
    u_8_29 = ftou2((pf_36_19 * (0.f - f_5_55)));
    u_8_phi_166 = u_8_29;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 3195956426  <=>  {u_19_phi_163 : 3195956426}
        u_8_30 = u_19_phi_163;
        u_8_phi_166 = u_8_30;
    }
	// 1044128955  <=>  {u_4_phi_165 : 1044128955}
    u_14_57 = u_4_phi_165;
	// 3209549197  <=>  {u_8_phi_166 : 3209549197}
    u_21_10 = u_8_phi_166;
	// 3195956426  <=>  {u_19_phi_163 : 3195956426}
    u_22_8 = u_19_phi_163;
	// 3206034970  <=>  {u_2_phi_159 : 3206034970}
    u_23_9 = u_2_phi_159;
	// 1064532083  <=>  {u_20_phi_164 : 1064532083}
    u_24_8 = u_20_phi_164;
	// 2147483648  <=>  {u_17_phi_152 : 2147483648}
    u_25_12 = u_17_phi_152;
    u_14_phi_167 = u_14_57;
    u_21_phi_167 = u_21_10;
    u_22_phi_167 = u_22_8;
    u_23_phi_167 = u_23_9;
    u_24_phi_167 = u_24_8;
    u_25_phi_167 = u_25_12;
	// True  <=>  if(((! {b_0_31 : False}) ? true : false))
    if (((!b_0_31) ? true : false))
    {
		// False  <=>  ((isnan(({f_5_49 : 15.00} * ({pf_16_70 : 1.341287} * 0.31830987f))) ? 0u : {u_10_46 : 6}) == ({u_1_20 : 16} + 4294967295u))
        b_2_39 = ((isnan((f_5_49 * (pf_16_70 * 0.31830987f))) ? 0u : u_10_46) == (u_1_20 + 4294967295u));
		// 1098907648  <=>  {ftou2(float(int({u_2_19 : 16}))) : 1098907648}
        u_26_12 = ftou2(float(int(u_2_19)));
        u_26_phi_168 = u_26_12;
		// False  <=>  if(({b_2_39 : False} ? true : false))
        if ((b_2_39 ? true : false))
        {
			// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
            u_26_13 = ftou2((pf_9_10 * 6.2831855f));
            u_26_phi_168 = u_26_13;
        }
		// 2147483648  <=>  {u_17_phi_152 : 2147483648}
        u_5_14 = u_17_phi_152;
        u_5_phi_169 = u_5_14;
		// False  <=>  if(({b_2_39 : False} ? true : false))
        if ((b_2_39 ? true : false))
        {
			// 0  <=>  0u
            u_5_15 = 0u;
            u_5_phi_169 = u_5_15;
        }
		// 1064532083  <=>  {u_20_phi_164 : 1064532083}
        u_27_16 = u_20_phi_164;
        u_27_phi_170 = u_27_16;
		// False  <=>  if(({b_2_39 : False} ? true : false))
        if ((b_2_39 ? true : false))
        {
			// 0  <=>  0u
            u_27_17 = 0u;
            u_27_phi_170 = u_27_17;
        }
		// 1098907648  <=>  {u_26_phi_168 : 1098907648}
        u_28_15 = u_26_phi_168;
        u_28_phi_171 = u_28_15;
		// False  <=>  if(({b_2_39 : False} ? true : false))
        if ((b_2_39 ? true : false))
        {
			// 1098907648  <=>  {u_26_phi_168 : 1098907648}
            u_28_16 = u_26_phi_168;
            u_28_phi_171 = u_28_16;
        }
		// 3209549197  <=>  {u_8_phi_166 : 3209549197}
        u_26_14 = u_8_phi_166;
        u_26_phi_172 = u_26_14;
		// False  <=>  if(({b_2_39 : False} ? true : false))
        if ((b_2_39 ? true : false))
        {
			// 3212126508  <=>  {ftou2(cos({utof2(u_28_phi_171) : 16.00})) : 3212126508}
            u_26_15 = ftou2(cos( utof2(u_28_phi_171)));
            u_26_phi_172 = u_26_15;
        }
		// 3206034970  <=>  {u_2_phi_159 : 3206034970}
        u_29_13 = u_2_phi_159;
        u_29_phi_173 = u_29_13;
		// False  <=>  if(({b_2_39 : False} ? true : false))
        if ((b_2_39 ? true : false))
        {
			// 3197331472  <=>  {ftou2(sin({utof2(u_28_phi_171) : 16.00})) : 3197331472}
            u_29_14 = ftou2(sin( utof2(u_28_phi_171)));
            u_29_phi_173 = u_29_14;
        }
		// 3195956426  <=>  {u_19_phi_163 : 3195956426}
        u_28_18 = u_19_phi_163;
        u_28_phi_174 = u_28_18;
		// False  <=>  if(({b_2_39 : False} ? true : false))
        if ((b_2_39 ? true : false))
        {
			// 1062065549  <=>  {ftou2(((0.f - {utof2(u_26_phi_172) : -0.8040398}) + (0.f - 0.f))) : 1062065549}
            u_28_19 = ftou2(((0.f - utof2(u_26_phi_172)) + (0.f - 0.f)));
            u_28_phi_174 = u_28_19;
        }
		// 1044128955  <=>  {u_4_phi_165 : 1044128955}
        u_30_13 = u_4_phi_165;
        u_30_phi_175 = u_30_13;
		// False  <=>  if(({b_2_39 : False} ? true : false))
        if ((b_2_39 ? true : false))
        {
			// 3206034970  <=>  {u_29_phi_173 : 3206034970}
            u_30_14 = u_29_phi_173;
            u_30_phi_175 = u_30_14;
        }
		// 1044128955  <=>  {u_30_phi_175 : 1044128955}
        u_31_9 = u_30_phi_175;
		// 3209549197  <=>  {u_26_phi_172 : 3209549197}
        u_32_9 = u_26_phi_172;
		// 3195956426  <=>  {u_28_phi_174 : 3195956426}
        u_33_8 = u_28_phi_174;
		// 3206034970  <=>  {u_29_phi_173 : 3206034970}
        u_34_8 = u_29_phi_173;
		// 1064532083  <=>  {u_27_phi_170 : 1064532083}
        u_35_8 = u_27_phi_170;
		// 2147483648  <=>  {u_5_phi_169 : 2147483648}
        u_36_8 = u_5_phi_169;
        u_31_phi_176 = u_31_9;
        u_32_phi_176 = u_32_9;
        u_33_phi_176 = u_33_8;
        u_34_phi_176 = u_34_8;
        u_35_phi_176 = u_35_8;
        u_36_phi_176 = u_36_8;
		// True  <=>  if(((! {b_2_39 : False}) ? true : false))
        if (((!b_2_39) ? true : false))
        {
			// 0.60  <=>  ((0.f - ({f_0_54 : 6.00} * (1.0f / {f_5_49 : 15.00}))) + 1.f)
            pf_35_27 = ((0.f - (f_0_54 * (1.0f / f_5_49))) + 1.f);
			// False  <=>  ((({pf_35_27 : 0.60} < float(1e-05)) && (! isnan({pf_35_27 : 0.60}))) && (! isnan(float(1e-05))))
            b_3_105 = (((pf_35_27 < float(1e-05)) && (!isnan(pf_35_27))) && (!isnan(float(1e-05))));
			// False  <=>  ((((({f_0_54 : 6.00} * (1.0f / {f_5_49 : 15.00})) < float(1e-05)) && (! isnan(({f_0_54 : 6.00} * (1.0f / {f_5_49 : 15.00}))))) && (! isnan(float(1e-05)))) ? true : false)
            b_4_43 = (((((f_0_54 * (1.0f / f_5_49)) < float(1e-05)) && (!isnan((f_0_54 * (1.0f / f_5_49))))) && (!isnan(float(1e-05)))) ? true : false);
			// 1044128955  <=>  {u_30_phi_175 : 1044128955}
            u_37_8 = u_30_phi_175;
			// 3209549197  <=>  {u_26_phi_172 : 3209549197}
            u_38_8 = u_26_phi_172;
			// 3195956426  <=>  {u_28_phi_174 : 3195956426}
            u_39_8 = u_28_phi_174;
			// 3206034970  <=>  {u_29_phi_173 : 3206034970}
            u_40_8 = u_29_phi_173;
			// 1064532083  <=>  {u_27_phi_170 : 1064532083}
            u_41_8 = u_27_phi_170;
			// 2147483648  <=>  {u_5_phi_169 : 2147483648}
            u_42_10 = u_5_phi_169;
            u_37_phi_177 = u_37_8;
            u_38_phi_177 = u_38_8;
            u_39_phi_177 = u_39_8;
            u_40_phi_177 = u_40_8;
            u_41_phi_177 = u_41_8;
            u_42_phi_177 = u_42_10;
			// False  <=>  if({b_4_43 : False})
            if (b_4_43)
            {
				// -0.8040397  <=>  cos((({pf_26_27 : 0.8986601} * 6.2831855f) + 3.1415927f))
                f_1_59 = cos(((pf_26_27 * 6.2831855f) + 3.1415927f));
				// 0.5945756  <=>  sin((({pf_26_27 : 0.8986601} * 6.2831855f) + 3.1415927f))
                f_3_83 = sin(((pf_26_27 * 6.2831855f) + 3.1415927f));
				// 1.00  <=>  inversesqrt((({f_3_83 : 0.5945756} * {f_3_83 : 0.5945756}) + (({f_1_59 : -0.8040397} * {f_1_59 : -0.8040397}) + 0.f)))
                f_4_36 = inversesqrt(((f_3_83 * f_3_83) + ((f_1_59 * f_1_59) + 0.f)));
				// -0.1837339  <=>  (0.f - (({pf_31_17 : 0.3090169} * inversesqrt({pf_32_13 : 1.00})) * ({f_3_83 : 0.5945756} * {f_4_36 : 1.00})))
                f_1_60 = (0.f - ((pf_31_17 * inversesqrt(pf_32_13)) * (f_3_83 * f_4_36)));
				// -0.1837339  <=>  (({pf_33_13 : -0.5654749} * (0.f * {f_4_36 : 1.00})) + {f_1_60 : -0.1837339})
                pf_36_24 = ((pf_33_13 * (0.f * f_4_36)) + f_1_60);
				// -0.4546643  <=>  (0.f - ({pf_33_13 : -0.5654749} * ({f_1_59 : -0.8040397} * {f_4_36 : 1.00})))
                f_1_61 = (0.f - (pf_33_13 * (f_1_59 * f_4_36)));
				// 0.0000002  <=>  (({pf_34_14 : 0.7646873} * ({f_3_83 : 0.5945756} * {f_4_36 : 1.00})) + {f_1_61 : -0.4546643})
                pf_26_32 = ((pf_34_14 * (f_3_83 * f_4_36)) + f_1_61);
				// -0.2484618  <=>  ((({pf_31_17 : 0.3090169} * inversesqrt({pf_32_13 : 1.00})) * ({f_1_59 : -0.8040397} * {f_4_36 : 1.00})) + (0.f - ({pf_34_14 : 0.7646873} * (0.f * {f_4_36 : 1.00}))))
                pf_35_29 = (((pf_31_17 * inversesqrt(pf_32_13)) * (f_1_59 * f_4_36)) + (0.f - (pf_34_14 * (0.f * f_4_36))));
				// 0.0337581  <=>  (({pf_26_32 : 0.0000002} * {pf_26_32 : 0.0000002}) + ({pf_36_24 : -0.1837339} * {pf_36_24 : -0.1837339}))
                pf_43_7 = ((pf_26_32 * pf_26_32) + (pf_36_24 * pf_36_24));
				// 0.0954914  <=>  (({pf_35_29 : -0.2484618} * {pf_35_29 : -0.2484618}) + {pf_43_7 : 0.0337581})
                pf_43_8 = ((pf_35_29 * pf_35_29) + pf_43_7);
				// 0.0000006  <=>  ({pf_26_32 : 0.0000002} * inversesqrt({pf_43_8 : 0.0954914}))
                pf_26_33 = (pf_26_32 * inversesqrt(pf_43_8));
				// -0.8040397  <=>  ({pf_35_29 : -0.2484618} * inversesqrt({pf_43_8 : 0.0954914}))
                pf_26_34 = (pf_35_29 * inversesqrt(pf_43_8));
				// 1058551324  <=>  {ftou2(({f_3_83 : 0.5945756} * {f_4_36 : 1.00})) : 1058551324}
                u_37_9 = ftou2((f_3_83 * f_4_36));
				// 3209549195  <=>  {ftou2(pf_26_34) : 3209549195}
                u_38_9 = ftou2(pf_26_34);
				// 3209549195  <=>  {ftou2(({f_1_59 : -0.8040397} * {f_4_36 : 1.00})) : 3209549195}
                u_39_9 = ftou2((f_1_59 * f_4_36));
				// 3206034972  <=>  {ftou2(({pf_36_24 : -0.1837339} * inversesqrt({pf_43_8 : 0.0954914}))) : 3206034972}
                u_40_9 = ftou2((pf_36_24 * inversesqrt(pf_43_8)));
				// 0  <=>  {ftou2((0.f * {f_4_36 : 1.00})) : 0}
                u_41_9 = ftou2((0.f * f_4_36));
				// 891232957  <=>  {ftou2(pf_26_33) : 891232957}
                u_42_11 = ftou2(pf_26_33);
                u_37_phi_177 = u_37_9;
                u_38_phi_177 = u_38_9;
                u_39_phi_177 = u_39_9;
                u_40_phi_177 = u_40_9;
                u_41_phi_177 = u_41_9;
                u_42_phi_177 = u_42_11;
            }
			// 1044128955  <=>  {u_37_phi_177 : 1044128955}
            u_43_12 = u_37_phi_177;
			// 3209549197  <=>  {u_38_phi_177 : 3209549197}
            u_44_12 = u_38_phi_177;
			// 3195956426  <=>  {u_39_phi_177 : 3195956426}
            u_45_13 = u_39_phi_177;
			// 3206034970  <=>  {u_40_phi_177 : 3206034970}
            u_46_13 = u_40_phi_177;
			// 1064532083  <=>  {u_41_phi_177 : 1064532083}
            u_47_13 = u_41_phi_177;
			// 2147483648  <=>  {u_42_phi_177 : 2147483648}
            u_48_9 = u_42_phi_177;
            u_43_phi_178 = u_43_12;
            u_44_phi_178 = u_44_12;
            u_45_phi_178 = u_45_13;
            u_46_phi_178 = u_46_13;
            u_47_phi_178 = u_47_13;
            u_48_phi_178 = u_48_9;
			// False  <=>  if(({b_3_105 : False} ? true : false))
            if ((b_3_105 ? true : false))
            {
				// 1.00  <=>  inversesqrt((({f_8_54 : -0.5945755} * {f_8_54 : -0.5945755}) + (({f_7_88 : 0.8040398} * {f_7_88 : 0.8040398}) + 0.f)))
                f_1_64 = inversesqrt(((f_8_54 * f_8_54) + ((f_7_88 * f_7_88) + 0.f)));
				// 0.1837339  <=>  (0.f - (({pf_31_17 : 0.3090169} * inversesqrt({pf_32_13 : 1.00})) * ({f_8_54 : -0.5945755} * {f_1_64 : 1.00})))
                f_1_65 = (0.f - ((pf_31_17 * inversesqrt(pf_32_13)) * (f_8_54 * f_1_64)));
				// 0.1837339  <=>  (({pf_33_13 : -0.5654749} * (0.f * {f_1_64 : 1.00})) + {f_1_65 : 0.1837339})
                pf_33_14 = ((pf_33_13 * (0.f * f_1_64)) + f_1_65);
				// 0.4546643  <=>  (0.f - ({pf_33_13 : -0.5654749} * ({f_7_88 : 0.8040398} * {f_1_64 : 1.00})))
                f_1_66 = (0.f - (pf_33_13 * (f_7_88 * f_1_64)));
				// -0.00  <=>  (({pf_34_14 : 0.7646873} * ({f_8_54 : -0.5945755} * {f_1_64 : 1.00})) + {f_1_66 : 0.4546643})
                pf_26_38 = ((pf_34_14 * (f_8_54 * f_1_64)) + f_1_66);
				// 0.2484618  <=>  ((({pf_31_17 : 0.3090169} * inversesqrt({pf_32_13 : 1.00})) * ({f_7_88 : 0.8040398} * {f_1_64 : 1.00})) + (0.f - ({pf_34_14 : 0.7646873} * (0.f * {f_1_64 : 1.00}))))
                pf_32_15 = (((pf_31_17 * inversesqrt(pf_32_13)) * (f_7_88 * f_1_64)) + (0.f - (pf_34_14 * (0.f * f_1_64))));
				// 0.0337581  <=>  (({pf_26_38 : -0.00} * {pf_26_38 : -0.00}) + ({pf_33_14 : 0.1837339} * {pf_33_14 : 0.1837339}))
                pf_34_16 = ((pf_26_38 * pf_26_38) + (pf_33_14 * pf_33_14));
				// 0.0954914  <=>  (({pf_32_15 : 0.2484618} * {pf_32_15 : 0.2484618}) + {pf_34_16 : 0.0337581})
                pf_34_17 = ((pf_32_15 * pf_32_15) + pf_34_16);
				// -0.0000001  <=>  ({pf_26_38 : -0.00} * inversesqrt({pf_34_17 : 0.0954914}))
                pf_26_39 = (pf_26_38 * inversesqrt(pf_34_17));
				// 0.8040398  <=>  ({pf_32_15 : 0.2484618} * inversesqrt({pf_34_17 : 0.0954914}))
                pf_26_40 = (pf_32_15 * inversesqrt(pf_34_17));
				// 3206034970  <=>  {ftou2(({f_8_54 : -0.5945755} * {f_1_64 : 1.00})) : 3206034970}
                u_43_13 = ftou2((f_8_54 * f_1_64));
				// 1062065549  <=>  {ftou2(pf_26_40) : 1062065549}
                u_44_13 = ftou2(pf_26_40);
				// 1062065549  <=>  {ftou2(({f_7_88 : 0.8040398} * {f_1_64 : 1.00})) : 1062065549}
                u_45_14 = ftou2((f_7_88 * f_1_64));
				// 1058551322  <=>  {ftou2(({pf_33_14 : 0.1837339} * inversesqrt({pf_34_17 : 0.0954914}))) : 1058551322}
                u_46_14 = ftou2((pf_33_14 * inversesqrt(pf_34_17)));
				// 0  <=>  {ftou2((0.f * {f_1_64 : 1.00})) : 0}
                u_47_14 = ftou2((0.f * f_1_64));
				// 3017891900  <=>  {ftou2(pf_26_39) : 3017891900}
                u_48_10 = ftou2(pf_26_39);
                u_43_phi_178 = u_43_13;
                u_44_phi_178 = u_44_13;
                u_45_phi_178 = u_45_14;
                u_46_phi_178 = u_46_14;
                u_47_phi_178 = u_47_14;
                u_48_phi_178 = u_48_10;
            }
			// 1044128955  <=>  {u_43_phi_178 : 1044128955}
            u_31_10 = u_43_phi_178;
			// 3209549197  <=>  {u_44_phi_178 : 3209549197}
            u_32_10 = u_44_phi_178;
			// 3195956426  <=>  {u_45_phi_178 : 3195956426}
            u_33_9 = u_45_phi_178;
			// 3206034970  <=>  {u_46_phi_178 : 3206034970}
            u_34_9 = u_46_phi_178;
			// 1064532083  <=>  {u_47_phi_178 : 1064532083}
            u_35_9 = u_47_phi_178;
			// 2147483648  <=>  {u_48_phi_178 : 2147483648}
            u_36_9 = u_48_phi_178;
            u_31_phi_176 = u_31_10;
            u_32_phi_176 = u_32_10;
            u_33_phi_176 = u_33_9;
            u_34_phi_176 = u_34_9;
            u_35_phi_176 = u_35_9;
            u_36_phi_176 = u_36_9;
        }
		// 1044128955  <=>  {u_31_phi_176 : 1044128955}
        u_14_58 = u_31_phi_176;
		// 3209549197  <=>  {u_32_phi_176 : 3209549197}
        u_21_11 = u_32_phi_176;
		// 3195956426  <=>  {u_33_phi_176 : 3195956426}
        u_22_9 = u_33_phi_176;
		// 3206034970  <=>  {u_34_phi_176 : 3206034970}
        u_23_10 = u_34_phi_176;
		// 1064532083  <=>  {u_35_phi_176 : 1064532083}
        u_24_9 = u_35_phi_176;
		// 2147483648  <=>  {u_36_phi_176 : 2147483648}
        u_25_13 = u_36_phi_176;
        u_14_phi_167 = u_14_58;
        u_21_phi_167 = u_21_11;
        u_22_phi_167 = u_22_9;
        u_23_phi_167 = u_23_10;
        u_24_phi_167 = u_24_9;
        u_25_phi_167 = u_25_13;
    }
	// 6.00  <=>  float(int((isnan({pf_21_37 : 6.905067}) ? 0u : uint(clamp(floor({pf_21_37 : 6.905067}), float(-2147483600.f), float(2147483600.f))))))
    f_1_69 = float(int((isnan(pf_21_37) ? 0u : uint(clamp(floor(pf_21_37), float(-2147483600.f), float(2147483600.f))))));
	// 0.3090169  <=>  cos((({f_0_54 : 6.00} * (1.0f / {f_5_49 : 15.00})) * 3.1415927f))
    f_3_84 = cos(((f_0_54 * (1.0f / f_5_49)) * 3.1415927f));
	// 0.1364943  <=>  (({pf_42_4 : -0.302587} * {f_1_47 : 1.00}) * ({pf_44_5 : 0.048909} + -0.5f))
    pf_32_17 = ((pf_42_4 * f_1_47) * (pf_44_5 + -0.5f));
	// -0.7646874  <=>  (0.f - ({pf_28_36 : 0.7646873} * {f_1_33 : 1.00}))
    f_4_37 = (0.f - (pf_28_36 * f_1_33));
	// 0.3596581  <=>  (({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {f_4_37 : -0.7646874})
    pf_34_18 = ((pf_3_19 * f_20_18) * f_4_37);
	// -1.00  <=>  floor((((0.f - {pf_9_10 : 1.10134}) + {f_2_65 : 0.0625}) + ({f_2_65 : 0.0625} * {f_1_69 : 6.00})))
    f_1_71 = floor((((0.f - pf_9_10) + f_2_65) + (f_2_65 * f_1_69)));
	// -0.3090169  <=>  (0.f - {f_3_84 : 0.3090169})
    f_4_38 = (0.f - f_3_84);
	// 0.9045086  <=>  (({f_3_84 : 0.3090169} * {f_4_38 : -0.3090169}) + 1.f)
    pf_40_6 = ((f_3_84 * f_4_38) + 1.f);
	// 0.565475  <=>  (0.f - ({pf_29_31 : -0.5654749} * {f_1_33 : 1.00}))
    f_4_39 = (0.f - (pf_29_31 * f_1_33));
	// 0.3361601  <=>  ((((0.f - {pf_9_10 : 1.10134}) + {f_2_65 : 0.0625}) + ({f_2_65 : 0.0625} * {f_1_69 : 6.00})) + (0.f - {f_1_71 : -1.00}))
    pf_36_28 = ((((0.f - pf_9_10) + f_2_65) + (f_2_65 * f_1_69)) + (0.f - f_1_71));
	// -0.5153016  <=>  cos(({pf_36_28 : 0.3361601} * 6.2831855f))
    f_5_63 = cos((pf_36_28 * 6.2831855f));
	// 0.8570089  <=>  sin(({pf_36_28 : 0.3361601} * 6.2831855f))
    f_7_89 = sin((pf_36_28 * 6.2831855f));
	// -0.490081  <=>  ({f_5_63 : -0.5153016} * sqrt({pf_40_6 : 0.9045086}))
    pf_34_22 = (f_5_63 * sqrt(pf_40_6));
	// 0.8150639  <=>  ({f_7_89 : 0.8570089} * sqrt({pf_40_6 : 0.9045086}))
    pf_40_7 = (f_7_89 * sqrt(pf_40_6));
	// 0.3356708  <=>  (({f_3_84 : 0.3090169} * {f_3_84 : 0.3090169}) + ({pf_34_22 : -0.490081} * {pf_34_22 : -0.490081}))
    pf_41_7 = ((f_3_84 * f_3_84) + (pf_34_22 * pf_34_22));
	// 1.00  <=>  inversesqrt((({pf_40_7 : 0.8150639} * {pf_40_7 : 0.8150639}) + {pf_41_7 : 0.3356708}))
    f_4_41 = inversesqrt(((pf_40_7 * pf_40_7) + pf_41_7));
	// 0.3090169  <=>  ({f_3_84 : 0.3090169} * {f_4_41 : 1.00})
    pf_41_9 = (f_3_84 * f_4_41);
	// 0.2401794  <=>  (({pf_34_22 : -0.490081} * {f_4_41 : 1.00}) * ({pf_34_22 : -0.490081} * {f_4_41 : 1.00}))
    pf_42_6 = ((pf_34_22 * f_4_41) * (pf_34_22 * f_4_41));
	// 0.3356708  <=>  (({pf_41_9 : 0.3090169} * {pf_41_9 : 0.3090169}) + {pf_42_6 : 0.2401794})
    pf_42_7 = ((pf_41_9 * pf_41_9) + pf_42_6);
	// 1.00  <=>  ((({pf_40_7 : 0.8150639} * {f_4_41 : 1.00}) * ({pf_40_7 : 0.8150639} * {f_4_41 : 1.00})) + {pf_42_7 : 0.3356708})
    pf_42_8 = (((pf_40_7 * f_4_41) * (pf_40_7 * f_4_41)) + pf_42_7);
	// 0.8150639  <=>  (({pf_40_7 : 0.8150639} * {f_4_41 : 1.00}) * inversesqrt({pf_42_8 : 1.00}))
    pf_43_10 = ((pf_40_7 * f_4_41) * inversesqrt(pf_42_8));
	// -0.490081  <=>  (({pf_34_22 : -0.490081} * {f_4_41 : 1.00}) * inversesqrt({pf_42_8 : 1.00}))
    pf_46_3 = ((pf_34_22 * f_4_41) * inversesqrt(pf_42_8));
	// -0.8150639  <=>  ((0.f * ({pf_41_9 : 0.3090169} * inversesqrt({pf_42_8 : 1.00}))) + (0.f - {pf_43_10 : 0.8150639}))
    pf_48_0 = ((0.f * (pf_41_9 * inversesqrt(pf_42_8))) + (0.f - pf_43_10));
	// -0.490081  <=>  ((0.f - 0.f) + {pf_46_3 : -0.490081})
    pf_49_0 = ((0.f - 0.f) + pf_46_3);
	// -0.4376903  <=>  ((({pf_23_23 : -0.8335257} * {f_1_35 : 1.053282}) * ({pf_45_3 : 1.044534} + -0.5f)) + ({pf_40_5 : -0.0895083} * ({pf_44_5 : 0.048909} + -0.5f)))
    pf_33_17 = (((pf_23_23 * f_1_35) * (pf_45_3 + -0.5f)) + (pf_40_5 * (pf_44_5 + -0.5f)));
	// -0.5470995  <=>  ((({pf_22_44 : -0.2075762} * {f_1_35 : 1.053282}) * ({pf_45_3 : 1.044534} + -0.5f)) + (({pf_41_4 : 0.9489095} * {f_1_47 : 1.00}) * ({pf_44_5 : 0.048909} + -0.5f)))
    pf_26_43 = (((pf_22_44 * f_1_35) * (pf_45_3 + -0.5f)) + ((pf_41_4 * f_1_47) * (pf_44_5 + -0.5f)));
	// -0.0954435  <=>  ((({pf_30_24 : -0.4043915} * {f_1_35 : 1.053282}) * ({pf_45_3 : 1.044534} + -0.5f)) + {pf_32_17 : 0.1364943})
    pf_32_18 = (((pf_30_24 * f_1_35) * (pf_45_3 + -0.5f)) + pf_32_17);
	// 1.053282  <=>  inversesqrt((({pf_30_24 : -0.4043915} * {pf_30_24 : -0.4043915}) + (({pf_22_44 : -0.2075762} * {pf_22_44 : -0.2075762}) + {pf_27_25 : 0.6947652})))
    f_3_88 = inversesqrt(((pf_30_24 * pf_30_24) + ((pf_22_44 * pf_22_44) + pf_27_25)));
	// 0.9045086  <=>  (({pf_49_0 : -0.490081} * {pf_49_0 : -0.490081}) + (({pf_48_0 : -0.8150639} * {pf_48_0 : -0.8150639}) + 0.f))
    pf_27_29 = ((pf_49_0 * pf_49_0) + ((pf_48_0 * pf_48_0) + 0.f));
	// 1.051462  <=>  inversesqrt({pf_27_29 : 0.9045086})
    f_4_42 = inversesqrt(pf_27_29);
	// -0.5470995  <=>  (0.f + {pf_26_43 : -0.5470995})
    pf_26_44 = (0.f + pf_26_43);
	// -0.3346963  <=>  (({pf_28_36 : 0.7646873} * {f_1_33 : 1.00}) * (0.f + {pf_33_17 : -0.4376903}))
    pf_27_30 = ((pf_28_36 * f_1_33) * (0.f + pf_33_17));
	// -0.0954435  <=>  (0.f + {pf_32_18 : -0.0954435})
    pf_32_19 = (0.f + pf_32_18);
	// 0.2186363  <=>  (0.f - ({pf_22_44 : -0.2075762} * {f_3_88 : 1.053282}))
    f_8_57 = (0.f - (pf_22_44 * f_3_88));
	// -0.4497883  <=>  ((({pf_29_31 : -0.5654749} * {f_1_33 : 1.00}) * {pf_32_19 : -0.0954435}) + (({pf_31_17 : 0.3090169} * {pf_26_44 : -0.5470995}) + {pf_27_30 : -0.3346963}))
    pf_27_32 = (((pf_29_31 * f_1_33) * pf_32_19) + ((pf_31_17 * pf_26_44) + pf_27_30));
	// 1062954223  <=>  {ftou2(({pf_48_0 : -0.8150639} * (0.f - {f_4_42 : 1.051462}))) : 1062954223}
    u_4_19 = ftou2((pf_48_0 * (0.f - f_4_42)));
	// 0.1592369  <=>  ((({pf_41_9 : 0.3090169} * inversesqrt({pf_42_8 : 1.00})) * ({pf_49_0 : -0.490081} * (0.f - {f_4_42 : 1.051462}))) + (0.f - ({pf_43_10 : 0.8150639} * (0.f * (0.f - {f_4_42 : 1.051462})))))
    pf_37_17 = (((pf_41_9 * inversesqrt(pf_42_8)) * (pf_49_0 * (0.f - f_4_42))) + (0.f - (pf_43_10 * (0.f * (0.f - f_4_42)))));
	// -0.5830032  <=>  ({pf_27_32 : -0.4497883} * (1.0f / ((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {f_4_39 : 0.565475}) + (({pf_6_14 : 0.2275276} * (0.f - {pf_31_17 : 0.3090169})) + {pf_34_18 : 0.3596581}))))
    pf_27_33 = (pf_27_32 * (1.0f / (((pf_7_8 * f_20_18) * f_4_39) + ((pf_6_14 * (0.f - pf_31_17)) + pf_34_18))));
	// 0.2648302  <=>  (({pf_41_9 : 0.3090169} * inversesqrt({pf_42_8 : 1.00})) * ({pf_48_0 : -0.8150639} * (0.f - {f_4_42 : 1.051462})))
    pf_39_5 = ((pf_41_9 * inversesqrt(pf_42_8)) * (pf_48_0 * (0.f - f_4_42)));
	// 0.2525395  <=>  (0.f - ({pf_46_3 : -0.490081} * ({pf_49_0 : -0.490081} * (0.f - {f_4_42 : 1.051462}))))
    f_1_74 = (0.f - (pf_46_3 * (pf_49_0 * (0.f - f_4_42))));
	// 0.9510565  <=>  (({pf_43_10 : 0.8150639} * ({pf_48_0 : -0.8150639} * (0.f - {f_4_42 : 1.051462}))) + {f_1_74 : 0.2525395})
    pf_29_34 = ((pf_43_10 * (pf_48_0 * (0.f - f_4_42))) + f_1_74);
	// 0.4259384  <=>  (0.f - ({pf_30_24 : -0.4043915} * {f_3_88 : 1.053282}))
    f_1_75 = (0.f - (pf_30_24 * f_3_88));
	// 0.4259384  <=>  (0.f - ({pf_30_24 : -0.4043915} * {f_3_88 : 1.053282}))
    f_1_76 = (0.f - (pf_30_24 * f_3_88));
	// -0.186421  <=>  (0.f - (({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {f_8_57 : 0.2186363}))
    f_4_45 = (0.f - ((pf_7_8 * f_20_18) * f_8_57));
	// 0.8779377  <=>  (0.f - ({pf_23_23 : -0.8335257} * {f_3_88 : 1.053282}))
    f_1_77 = (0.f - (pf_23_23 * f_3_88));
	// 0.199755  <=>  ({pf_6_14 : 0.2275276} * {f_1_77 : 0.8779377})
    pf_51_0 = (pf_6_14 * f_1_77);
	// -0.2648302  <=>  (({pf_46_3 : -0.490081} * (0.f * (0.f - {f_4_42 : 1.051462}))) + (0.f - {pf_39_5 : 0.2648302}))
    pf_31_19 = ((pf_46_3 * (0.f * (0.f - f_4_42))) + (0.f - pf_39_5));
	// 0.8779377  <=>  (0.f - ({pf_23_23 : -0.8335257} * {f_3_88 : 1.053282}))
    f_1_79 = (0.f - (pf_23_23 * f_3_88));
	// 0.9489095  <=>  ((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {f_1_79 : 0.8779377}) + (0.f - (({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {f_1_75 : 0.4259384})))
    pf_39_6 = (((pf_7_8 * f_20_18) * f_1_79) + (0.f - ((pf_3_19 * f_20_18) * f_1_75)));
	// 0.2186363  <=>  (0.f - ({pf_22_44 : -0.2075762} * {f_3_88 : 1.053282}))
    f_1_80 = (0.f - (pf_22_44 * f_3_88));
	// -0.302587  <=>  ((({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {f_1_80 : 0.2186363}) + (0.f - {pf_51_0 : 0.199755}))
    pf_51_1 = (((pf_3_19 * f_20_18) * f_1_80) + (0.f - pf_51_0));
	// 1045204118  <=>  {ftou2(pf_51_0) : 1045204118}
    u_8_31 = ftou2(pf_51_0);
    u_8_phi_179 = u_8_31;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
        u_8_32 = ftou2((pf_9_10 * 6.2831855f));
        u_8_phi_179 = u_8_32;
    }
	// -0.1634844  <=>  ((({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {pf_27_33 : -0.5830032}) + (0.f + {pf_33_17 : -0.4376903}))
    pf_33_19 = (((pf_3_19 * f_20_18) * pf_27_33) + (0.f + pf_33_17));
	// 0.908441  <=>  (({pf_39_6 : 0.9489095} * {pf_39_6 : 0.9489095}) + ((({pf_6_14 : 0.2275276} * {f_1_76 : 0.4259384}) + {f_4_45 : -0.186421}) * (({pf_6_14 : 0.2275276} * {f_1_76 : 0.4259384}) + {f_4_45 : -0.186421})))
    pf_47_7 = ((pf_39_6 * pf_39_6) + (((pf_6_14 * f_1_76) + f_4_45) * ((pf_6_14 * f_1_76) + f_4_45)));
	// 1.00  <=>  inversesqrt((({pf_31_19 : -0.2648302} * {pf_31_19 : -0.2648302}) + (({pf_29_34 : 0.9510565} * {pf_29_34 : 0.9510565}) + ({pf_37_17 : 0.1592369} * {pf_37_17 : 0.1592369}))))
    f_1_83 = inversesqrt(((pf_31_19 * pf_31_19) + ((pf_29_34 * pf_29_34) + (pf_37_17 * pf_37_17))));
	// 1045204118  <=>  {u_8_phi_179 : 1045204118}
    u_5_17 = u_8_phi_179;
    u_5_phi_180 = u_5_17;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 1045204118  <=>  {u_8_phi_179 : 1045204118}
        u_5_18 = u_8_phi_179;
        u_5_phi_180 = u_5_18;
    }
	// 1062954223  <=>  {u_4_19 : 1062954223}
    u_8_33 = u_4_19;
    u_8_phi_181 = u_8_33;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 1045115146  <=>  {ftou2(sin({utof2(u_5_phi_180) : 0.199755})) : 1045115146}
        u_8_34 = ftou2(sin( utof2(u_5_phi_180)));
        u_8_phi_181 = u_8_34;
    }
	// 1.00  <=>  inversesqrt((({pf_51_1 : -0.302587} * {pf_51_1 : -0.302587}) + {pf_47_7 : 0.908441}))
    f_4_51 = inversesqrt(((pf_51_1 * pf_51_1) + pf_47_7));
	// 2147483648  <=>  {ftou2((0.f * (0.f - {f_4_42 : 1.051462}))) : 2147483648}
    u_4_20 = ftou2((0.f * (0.f - f_4_42)));
    u_4_phi_182 = u_4_20;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 0  <=>  0u
        u_4_21 = 0u;
        u_4_phi_182 = u_4_21;
    }
	// 1042484992  <=>  {ftou2(({pf_37_17 : 0.1592369} * {f_1_83 : 1.00})) : 1042484992}
    u_17_22 = ftou2((pf_37_17 * f_1_83));
    u_17_phi_183 = u_17_22;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 1065019605  <=>  {ftou2(cos({utof2(u_5_phi_180) : 0.199755})) : 1065019605}
        u_17_23 = ftou2(cos( utof2(u_5_phi_180)));
        u_17_phi_183 = u_17_23;
    }
	// 3196557267  <=>  {ftou2(({pf_31_19 : -0.2648302} * {f_1_83 : 1.00})) : 3196557267}
    u_5_20 = ftou2((pf_31_19 * f_1_83));
	// 1064532083  <=>  {ftou2(({pf_29_34 : 0.9510565} * {f_1_83 : 1.00})) : 1064532083}
    u_14_59 = ftou2((pf_29_34 * f_1_83));
    u_14_phi_184 = u_14_59;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 0  <=>  0u
        u_14_60 = 0u;
        u_14_phi_184 = u_14_60;
    }
	// 3196557267  <=>  {u_5_20 : 3196557267}
    u_1_45 = u_5_20;
    u_1_phi_185 = u_1_45;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 3210437871  <=>  {ftou2(((0.f - {utof2(u_8_phi_181) : 0.8570089}) + (0.f - 0.f))) : 3210437871}
        u_1_46 = ftou2(((0.f - utof2(u_8_phi_181)) + (0.f - 0.f)));
        u_1_phi_185 = u_1_46;
    }
	// 0.9489096  <=>  ({pf_39_6 : 0.9489095} * {f_4_51 : 1.00})
    pf_31_20 = (pf_39_6 * f_4_51);
	// 1.073632  <=>  (((((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {pf_27_33 : -0.5830032}) + {pf_32_19 : -0.0954435}) * {utof2(u_21_phi_167) : -0.8040398}) + (({pf_33_19 : -0.1634844} * {utof2(u_23_phi_167) : -0.5945755}) + ((({pf_6_14 : 0.2275276} * {pf_27_33 : -0.5830032}) + {pf_26_44 : -0.5470995}) * {utof2(u_25_phi_167) : -0.00}))) + 0.5f)
    pf_32_22 = ((((((pf_7_8 * f_20_18) * pf_27_33) + pf_32_19) * utof2(u_21_phi_167)) + ((pf_33_19 * utof2(u_23_phi_167)) + (((pf_6_14 * pf_27_33) + pf_26_44) * utof2(u_25_phi_167)))) + 0.5f);
	// 1.00  <=>  clamp({pf_32_22 : 1.073632}, 0.0, 1.0)
    f_1_86 = clamp(pf_32_22, 0.0, 1.0);
	// -0.2147302  <=>  (((((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {pf_27_33 : -0.5830032}) + {pf_32_19 : -0.0954435}) * {utof2(u_14_phi_167) : 0.1837339}) + (({pf_33_19 : -0.1634844} * {utof2(u_22_phi_167) : -0.2484619}) + ((({pf_6_14 : 0.2275276} * {pf_27_33 : -0.5830032}) + {pf_26_44 : -0.5470995}) * {utof2(u_24_phi_167) : 0.9510567}))) + 0.5f)
    pf_26_49 = ((((((pf_7_8 * f_20_18) * pf_27_33) + pf_32_19) * utof2(u_14_phi_167)) + ((pf_33_19 * utof2(u_22_phi_167)) + (((pf_6_14 * pf_27_33) + pf_26_44) * utof2(u_24_phi_167)))) + 0.5f);
	// 0.00  <=>  clamp({pf_26_49 : -0.2147302}, 0.0, 1.0)
    f_4_52 = clamp(pf_26_49, 0.0, 1.0);
	// 1057221327  <=>  {ftou2(({pf_49_0 : -0.490081} * (0.f - {f_4_42 : 1.051462}))) : 1057221327}
    u_5_21 = ftou2((pf_49_0 * (0.f - f_4_42)));
    u_5_phi_186 = u_5_21;
	// False  <=>  if(({b_0_31 : False} ? true : false))
    if ((b_0_31 ? true : false))
    {
		// 1042484992  <=>  {u_17_phi_183 : 1042484992}
        u_5_22 = u_17_phi_183;
        u_5_phi_186 = u_5_22;
    }
	// 1057221327  <=>  {u_5_phi_186 : 1057221327}
    u_2_29 = u_5_phi_186;
	// 3196557267  <=>  {u_1_phi_185 : 3196557267}
    u_19_16 = u_1_phi_185;
	// 1042484992  <=>  {u_17_phi_183 : 1042484992}
    u_20_18 = u_17_phi_183;
	// 1062954223  <=>  {u_8_phi_181 : 1062954223}
    u_21_12 = u_8_phi_181;
	// 2147483648  <=>  {u_4_phi_182 : 2147483648}
    u_22_10 = u_4_phi_182;
	// 1064532083  <=>  {u_14_phi_184 : 1064532083}
    u_23_11 = u_14_phi_184;
    u_2_phi_187 = u_2_29;
    u_19_phi_187 = u_19_16;
    u_20_phi_187 = u_20_18;
    u_21_phi_187 = u_21_12;
    u_22_phi_187 = u_22_10;
    u_23_phi_187 = u_23_11;
	// True  <=>  if(((! {b_0_31 : False}) ? true : false))
    if (((!b_0_31) ? true : false))
    {
		// False  <=>  ((isnan(({f_5_49 : 15.00} * ({pf_16_70 : 1.341287} * 0.31830987f))) ? 0u : {u_10_46 : 6}) == ({u_1_20 : 16} + 4294967295u))
        b_0_33 = ((isnan((f_5_49 * (pf_16_70 * 0.31830987f))) ? 0u : u_10_46) == (u_1_20 + 4294967295u));
		// 15  <=>  ({u_1_20 : 16} + 4294967295u)
        u_10_48 = (u_1_20 + 4294967295u);
        u_10_phi_188 = u_10_48;
		// False  <=>  if(({b_0_33 : False} ? true : false))
        if ((b_0_33 ? true : false))
        {
			// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
            u_10_49 = ftou2((pf_9_10 * 6.2831855f));
            u_10_phi_188 = u_10_49;
        }
		// 2147483648  <=>  {u_4_phi_182 : 2147483648}
        u_13_16 = u_4_phi_182;
        u_13_phi_189 = u_13_16;
		// False  <=>  if(({b_0_33 : False} ? true : false))
        if ((b_0_33 ? true : false))
        {
			// 0  <=>  0u
            u_13_17 = 0u;
            u_13_phi_189 = u_13_17;
        }
		// 1064532083  <=>  {u_14_phi_184 : 1064532083}
        u_24_11 = u_14_phi_184;
        u_24_phi_190 = u_24_11;
		// False  <=>  if(({b_0_33 : False} ? true : false))
        if ((b_0_33 ? true : false))
        {
			// 0  <=>  0u
            u_24_12 = 0u;
            u_24_phi_190 = u_24_12;
        }
		// 15  <=>  {u_10_phi_188 : 15}
        u_25_14 = u_10_phi_188;
        u_25_phi_191 = u_25_14;
		// False  <=>  if(({b_0_33 : False} ? true : false))
        if ((b_0_33 ? true : false))
        {
			// 15  <=>  {u_10_phi_188 : 15}
            u_25_15 = u_10_phi_188;
            u_25_phi_191 = u_25_15;
        }
		// 1057221327  <=>  {u_5_phi_186 : 1057221327}
        u_10_50 = u_5_phi_186;
        u_10_phi_192 = u_10_50;
		// False  <=>  if(({b_0_33 : False} ? true : false))
        if ((b_0_33 ? true : false))
        {
			// 1065353216  <=>  {ftou2(cos({utof2(u_25_phi_191) : 0.00})) : 1065353216}
            u_10_51 = ftou2(cos( utof2(u_25_phi_191)));
            u_10_phi_192 = u_10_51;
        }
		// 1062954223  <=>  {u_8_phi_181 : 1062954223}
        u_26_17 = u_8_phi_181;
        u_26_phi_193 = u_26_17;
		// False  <=>  if(({b_0_33 : False} ? true : false))
        if ((b_0_33 ? true : false))
        {
			// 15  <=>  {ftou2(sin({utof2(u_25_phi_191) : 0.00})) : 15}
            u_26_18 = ftou2(sin( utof2(u_25_phi_191)));
            u_26_phi_193 = u_26_18;
        }
		// 1042484992  <=>  {u_17_phi_183 : 1042484992}
        u_25_17 = u_17_phi_183;
        u_25_phi_194 = u_25_17;
		// False  <=>  if(({b_0_33 : False} ? true : false))
        if ((b_0_33 ? true : false))
        {
			// 3204704975  <=>  {ftou2(((0.f - {utof2(u_10_phi_192) : 0.5153016}) + (0.f - 0.f))) : 3204704975}
            u_25_18 = ftou2(((0.f - utof2(u_10_phi_192)) + (0.f - 0.f)));
            u_25_phi_194 = u_25_18;
        }
		// 3196557267  <=>  {u_1_phi_185 : 3196557267}
        u_27_19 = u_1_phi_185;
        u_27_phi_195 = u_27_19;
		// False  <=>  if(({b_0_33 : False} ? true : false))
        if ((b_0_33 ? true : false))
        {
			// 1062954223  <=>  {u_26_phi_193 : 1062954223}
            u_27_20 = u_26_phi_193;
            u_27_phi_195 = u_27_20;
        }
		// 1057221327  <=>  {u_10_phi_192 : 1057221327}
        u_28_20 = u_10_phi_192;
		// 3196557267  <=>  {u_27_phi_195 : 3196557267}
        u_29_15 = u_27_phi_195;
		// 1042484992  <=>  {u_25_phi_194 : 1042484992}
        u_30_15 = u_25_phi_194;
		// 1062954223  <=>  {u_26_phi_193 : 1062954223}
        u_31_11 = u_26_phi_193;
		// 2147483648  <=>  {u_13_phi_189 : 2147483648}
        u_32_11 = u_13_phi_189;
		// 1064532083  <=>  {u_24_phi_190 : 1064532083}
        u_33_10 = u_24_phi_190;
        u_28_phi_196 = u_28_20;
        u_29_phi_196 = u_29_15;
        u_30_phi_196 = u_30_15;
        u_31_phi_196 = u_31_11;
        u_32_phi_196 = u_32_11;
        u_33_phi_196 = u_33_10;
		// True  <=>  if(((! {b_0_33 : False}) ? true : false))
        if (((!b_0_33) ? true : false))
        {
			// 0.60  <=>  ((0.f - ({f_0_54 : 6.00} * (1.0f / {f_5_49 : 15.00}))) + 1.f)
            pf_26_52 = ((0.f - (f_0_54 * (1.0f / f_5_49))) + 1.f);
			// False  <=>  ((({pf_26_52 : 0.60} < float(1e-05)) && (! isnan({pf_26_52 : 0.60}))) && (! isnan(float(1e-05))))
            b_2_61 = (((pf_26_52 < float(1e-05)) && (!isnan(pf_26_52))) && (!isnan(float(1e-05))));
			// False  <=>  ((((({f_0_54 : 6.00} * (1.0f / {f_5_49 : 15.00})) < float(1e-05)) && (! isnan(({f_0_54 : 6.00} * (1.0f / {f_5_49 : 15.00}))))) && (! isnan(float(1e-05)))) ? true : false)
            b_3_106 = (((((f_0_54 * (1.0f / f_5_49)) < float(1e-05)) && (!isnan((f_0_54 * (1.0f / f_5_49))))) && (!isnan(float(1e-05)))) ? true : false);
			// 1057221327  <=>  {u_10_phi_192 : 1057221327}
            u_34_10 = u_10_phi_192;
			// 3196557267  <=>  {u_27_phi_195 : 3196557267}
            u_35_10 = u_27_phi_195;
			// 1042484992  <=>  {u_25_phi_194 : 1042484992}
            u_36_10 = u_25_phi_194;
			// 1062954223  <=>  {u_26_phi_193 : 1062954223}
            u_37_10 = u_26_phi_193;
			// 2147483648  <=>  {u_13_phi_189 : 2147483648}
            u_38_10 = u_13_phi_189;
			// 1064532083  <=>  {u_24_phi_190 : 1064532083}
            u_39_10 = u_24_phi_190;
            u_34_phi_197 = u_34_10;
            u_35_phi_197 = u_35_10;
            u_36_phi_197 = u_36_10;
            u_37_phi_197 = u_37_10;
            u_38_phi_197 = u_38_10;
            u_39_phi_197 = u_39_10;
			// False  <=>  if({b_3_106 : False})
            if (b_3_106)
            {
				// 0.5153019  <=>  cos((({pf_36_28 : 0.3361601} * 6.2831855f) + 3.1415927f))
                f_8_71 = cos(((pf_36_28 * 6.2831855f) + 3.1415927f));
				// -0.8570087  <=>  sin((({pf_36_28 : 0.3361601} * 6.2831855f) + 3.1415927f))
                f_9_51 = sin(((pf_36_28 * 6.2831855f) + 3.1415927f));
				// 1.00  <=>  inversesqrt((({f_9_51 : -0.8570087} * {f_9_51 : -0.8570087}) + (({f_8_71 : 0.5153019} * {f_8_71 : 0.5153019}) + 0.f)))
                f_10_98 = inversesqrt(((f_9_51 * f_9_51) + ((f_8_71 * f_8_71) + 0.f)));
				// 0.2648301  <=>  (0.f - (({pf_41_9 : 0.3090169} * inversesqrt({pf_42_8 : 1.00})) * ({f_9_51 : -0.8570087} * {f_10_98 : 1.00})))
                f_8_72 = (0.f - ((pf_41_9 * inversesqrt(pf_42_8)) * (f_9_51 * f_10_98)));
				// 0.2648301  <=>  (({pf_43_10 : 0.8150639} * (0.f * {f_10_98 : 1.00})) + {f_8_72 : 0.2648301})
                pf_32_24 = ((pf_43_10 * (0.f * f_10_98)) + f_8_72);
				// -0.420004  <=>  (0.f - ({pf_43_10 : 0.8150639} * ({f_8_71 : 0.5153019} * {f_10_98 : 1.00})))
                f_8_73 = (0.f - (pf_43_10 * (f_8_71 * f_10_98)));
				// -0.0000003  <=>  (({pf_46_3 : -0.490081} * ({f_9_51 : -0.8570087} * {f_10_98 : 1.00})) + {f_8_73 : -0.420004})
                pf_24_42 = ((pf_46_3 * (f_9_51 * f_10_98)) + f_8_73);
				// 0.159237  <=>  ((({pf_41_9 : 0.3090169} * inversesqrt({pf_42_8 : 1.00})) * ({f_8_71 : 0.5153019} * {f_10_98 : 1.00})) + (0.f - ({pf_46_3 : -0.490081} * (0.f * {f_10_98 : 1.00}))))
                pf_26_54 = (((pf_41_9 * inversesqrt(pf_42_8)) * (f_8_71 * f_10_98)) + (0.f - (pf_46_3 * (0.f * f_10_98))));
				// 0.070135  <=>  (({pf_24_42 : -0.0000003} * {pf_24_42 : -0.0000003}) + ({pf_32_24 : 0.2648301} * {pf_32_24 : 0.2648301}))
                pf_33_23 = ((pf_24_42 * pf_24_42) + (pf_32_24 * pf_32_24));
				// 0.0954914  <=>  (({pf_26_54 : 0.159237} * {pf_26_54 : 0.159237}) + {pf_33_23 : 0.070135})
                pf_33_24 = ((pf_26_54 * pf_26_54) + pf_33_23);
				// -0.000001  <=>  ({pf_24_42 : -0.0000003} * inversesqrt({pf_33_24 : 0.0954914}))
                pf_24_43 = (pf_24_42 * inversesqrt(pf_33_24));
				// 0.5153019  <=>  ({pf_26_54 : 0.159237} * inversesqrt({pf_33_24 : 0.0954914}))
                pf_24_44 = (pf_26_54 * inversesqrt(pf_33_24));
				// 1057221332  <=>  {ftou2(pf_24_44) : 1057221332}
                u_34_11 = ftou2(pf_24_44);
				// 3210437868  <=>  {ftou2(({f_9_51 : -0.8570087} * {f_10_98 : 1.00})) : 3210437868}
                u_35_11 = ftou2((f_9_51 * f_10_98));
				// 1057221332  <=>  {ftou2(({f_8_71 : 0.5153019} * {f_10_98 : 1.00})) : 1057221332}
                u_36_11 = ftou2((f_8_71 * f_10_98));
				// 1062954221  <=>  {ftou2(({pf_32_24 : 0.2648301} * inversesqrt({pf_33_24 : 0.0954914}))) : 1062954221}
                u_37_11 = ftou2((pf_32_24 * inversesqrt(pf_33_24)));
				// 3045817656  <=>  {ftou2(pf_24_43) : 3045817656}
                u_38_11 = ftou2(pf_24_43);
				// 0  <=>  {ftou2((0.f * {f_10_98 : 1.00})) : 0}
                u_39_11 = ftou2((0.f * f_10_98));
                u_34_phi_197 = u_34_11;
                u_35_phi_197 = u_35_11;
                u_36_phi_197 = u_36_11;
                u_37_phi_197 = u_37_11;
                u_38_phi_197 = u_38_11;
                u_39_phi_197 = u_39_11;
            }
			// 1057221327  <=>  {u_34_phi_197 : 1057221327}
            u_40_11 = u_34_phi_197;
			// 3196557267  <=>  {u_35_phi_197 : 3196557267}
            u_41_11 = u_35_phi_197;
			// 1042484992  <=>  {u_36_phi_197 : 1042484992}
            u_42_13 = u_36_phi_197;
			// 1062954223  <=>  {u_37_phi_197 : 1062954223}
            u_43_15 = u_37_phi_197;
			// 2147483648  <=>  {u_38_phi_197 : 2147483648}
            u_44_15 = u_38_phi_197;
			// 1064532083  <=>  {u_39_phi_197 : 1064532083}
            u_45_16 = u_39_phi_197;
            u_40_phi_198 = u_40_11;
            u_41_phi_198 = u_41_11;
            u_42_phi_198 = u_42_13;
            u_43_phi_198 = u_43_15;
            u_44_phi_198 = u_44_15;
            u_45_phi_198 = u_45_16;
			// False  <=>  if(({b_2_61 : False} ? true : false))
            if ((b_2_61 ? true : false))
            {
				// 1.00  <=>  inversesqrt((({f_7_89 : 0.8570089} * {f_7_89 : 0.8570089}) + (({f_5_63 : -0.5153016} * {f_5_63 : -0.5153016}) + 0.f)))
                f_8_76 = inversesqrt(((f_7_89 * f_7_89) + ((f_5_63 * f_5_63) + 0.f)));
				// -0.2648302  <=>  (0.f - (({pf_41_9 : 0.3090169} * inversesqrt({pf_42_8 : 1.00})) * ({f_7_89 : 0.8570089} * {f_8_76 : 1.00})))
                f_5_64 = (0.f - ((pf_41_9 * inversesqrt(pf_42_8)) * (f_7_89 * f_8_76)));
				// -0.2648302  <=>  (({pf_43_10 : 0.8150639} * (0.f * {f_8_76 : 1.00})) + {f_5_64 : -0.2648302})
                pf_32_27 = ((pf_43_10 * (0.f * f_8_76)) + f_5_64);
				// 0.4200038  <=>  (0.f - ({pf_43_10 : 0.8150639} * ({f_5_63 : -0.5153016} * {f_8_76 : 1.00})))
                f_5_65 = (0.f - (pf_43_10 * (f_5_63 * f_8_76)));
				// -0.00  <=>  (({pf_46_3 : -0.490081} * ({f_7_89 : 0.8570089} * {f_8_76 : 1.00})) + {f_5_65 : 0.4200038})
                pf_24_48 = ((pf_46_3 * (f_7_89 * f_8_76)) + f_5_65);
				// -0.1592369  <=>  ((({pf_41_9 : 0.3090169} * inversesqrt({pf_42_8 : 1.00})) * ({f_5_63 : -0.5153016} * {f_8_76 : 1.00})) + (0.f - ({pf_46_3 : -0.490081} * (0.f * {f_8_76 : 1.00}))))
                pf_26_56 = (((pf_41_9 * inversesqrt(pf_42_8)) * (f_5_63 * f_8_76)) + (0.f - (pf_46_3 * (0.f * f_8_76))));
				// 0.070135  <=>  (({pf_24_48 : -0.00} * {pf_24_48 : -0.00}) + ({pf_32_27 : -0.2648302} * {pf_32_27 : -0.2648302}))
                pf_33_27 = ((pf_24_48 * pf_24_48) + (pf_32_27 * pf_32_27));
				// 0.0954914  <=>  (({pf_26_56 : -0.1592369} * {pf_26_56 : -0.1592369}) + {pf_33_27 : 0.070135})
                pf_33_28 = ((pf_26_56 * pf_26_56) + pf_33_27);
				// -0.00  <=>  ({pf_24_48 : -0.00} * inversesqrt({pf_33_28 : 0.0954914}))
                pf_24_49 = (pf_24_48 * inversesqrt(pf_33_28));
				// -0.5153016  <=>  ({pf_26_56 : -0.1592369} * inversesqrt({pf_33_28 : 0.0954914}))
                pf_24_50 = (pf_26_56 * inversesqrt(pf_33_28));
				// 3204704975  <=>  {ftou2(pf_24_50) : 3204704975}
                u_40_12 = ftou2(pf_24_50);
				// 1062954223  <=>  {ftou2(({f_7_89 : 0.8570089} * {f_8_76 : 1.00})) : 1062954223}
                u_41_12 = ftou2((f_7_89 * f_8_76));
				// 3204704975  <=>  {ftou2(({f_5_63 : -0.5153016} * {f_8_76 : 1.00})) : 3204704975}
                u_42_14 = ftou2((f_5_63 * f_8_76));
				// 3210437870  <=>  {ftou2(({pf_32_27 : -0.2648302} * inversesqrt({pf_33_28 : 0.0954914}))) : 3210437870}
                u_43_16 = ftou2((pf_32_27 * inversesqrt(pf_33_28)));
				// 2995268110  <=>  {ftou2(pf_24_49) : 2995268110}
                u_44_16 = ftou2(pf_24_49);
				// 0  <=>  {ftou2((0.f * {f_8_76 : 1.00})) : 0}
                u_45_17 = ftou2((0.f * f_8_76));
                u_40_phi_198 = u_40_12;
                u_41_phi_198 = u_41_12;
                u_42_phi_198 = u_42_14;
                u_43_phi_198 = u_43_16;
                u_44_phi_198 = u_44_16;
                u_45_phi_198 = u_45_17;
            }
			// 1057221327  <=>  {u_40_phi_198 : 1057221327}
            u_28_21 = u_40_phi_198;
			// 3196557267  <=>  {u_41_phi_198 : 3196557267}
            u_29_16 = u_41_phi_198;
			// 1042484992  <=>  {u_42_phi_198 : 1042484992}
            u_30_16 = u_42_phi_198;
			// 1062954223  <=>  {u_43_phi_198 : 1062954223}
            u_31_12 = u_43_phi_198;
			// 2147483648  <=>  {u_44_phi_198 : 2147483648}
            u_32_12 = u_44_phi_198;
			// 1064532083  <=>  {u_45_phi_198 : 1064532083}
            u_33_11 = u_45_phi_198;
            u_28_phi_196 = u_28_21;
            u_29_phi_196 = u_29_16;
            u_30_phi_196 = u_30_16;
            u_31_phi_196 = u_31_12;
            u_32_phi_196 = u_32_12;
            u_33_phi_196 = u_33_11;
        }
		// 1057221327  <=>  {u_28_phi_196 : 1057221327}
        u_2_30 = u_28_phi_196;
		// 3196557267  <=>  {u_29_phi_196 : 3196557267}
        u_19_17 = u_29_phi_196;
		// 1042484992  <=>  {u_30_phi_196 : 1042484992}
        u_20_19 = u_30_phi_196;
		// 1062954223  <=>  {u_31_phi_196 : 1062954223}
        u_21_13 = u_31_phi_196;
		// 2147483648  <=>  {u_32_phi_196 : 2147483648}
        u_22_11 = u_32_phi_196;
		// 1064532083  <=>  {u_33_phi_196 : 1064532083}
        u_23_12 = u_33_phi_196;
        u_2_phi_187 = u_2_30;
        u_19_phi_187 = u_19_17;
        u_20_phi_187 = u_20_19;
        u_21_phi_187 = u_21_13;
        u_22_phi_187 = u_22_11;
        u_23_phi_187 = u_23_12;
    }
	// -1.10134  <=>  (((0.f - {pf_9_10 : 1.10134}) + {f_2_65 : 0.0625}) + ({f_2_65 : 0.0625} * float(int(({b_0_30 : False} ? ({u_9_25 : 21} + {u_2_23 : 4294967280}) : 4294967295u)))))
    pf_24_51 = (((0.f - pf_9_10) + f_2_65) + (f_2_65 * float(int((b_0_30 ? (u_9_25 + u_2_23) : 4294967295u)))));
	// 0.490081  <=>  (0.f - ({pf_34_22 : -0.490081} * {f_4_41 : 1.00}))
    f_8_77 = (0.f - (pf_34_22 * f_4_41));
	// -0.2305015  <=>  (({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {f_8_77 : 0.490081})
    pf_32_29 = ((pf_3_19 * f_20_18) * f_8_77);
	// 0.4666667  <=>  (float(int({u_16_39 : 7})) * (1.0f / {f_5_49 : 15.00}))
    pf_33_29 = (float(int(u_16_39)) * (1.0f / f_5_49));
	// -0.4376903  <=>  ((({pf_23_23 : -0.8335257} * {f_3_88 : 1.053282}) * ({pf_45_3 : 1.044534} + -0.5f)) + (((({pf_6_14 : 0.2275276} * {f_1_76 : 0.4259384}) + {f_4_45 : -0.186421}) * {f_4_51 : 1.00}) * ({pf_44_5 : 0.048909} + -0.5f)))
    pf_29_37 = (((pf_23_23 * f_3_88) * (pf_45_3 + -0.5f)) + ((((pf_6_14 * f_1_76) + f_4_45) * f_4_51) * (pf_44_5 + -0.5f)));
	// 0.8986601  <=>  ({pf_24_51 : -1.10134} + (0.f - floor({pf_24_51 : -1.10134})))
    pf_24_52 = (pf_24_51 + (0.f - floor(pf_24_51)));
	// -0.0954435  <=>  ((({pf_30_24 : -0.4043915} * {f_3_88 : 1.053282}) * ({pf_45_3 : 1.044534} + -0.5f)) + (({pf_51_1 : -0.302587} * {f_4_51 : 1.00}) * ({pf_44_5 : 0.048909} + -0.5f)))
    pf_27_40 = (((pf_30_24 * f_3_88) * (pf_45_3 + -0.5f)) + ((pf_51_1 * f_4_51) * (pf_44_5 + -0.5f)));
	// -0.8150639  <=>  (0.f - ({pf_40_7 : 0.8150639} * {f_4_41 : 1.00}))
    f_3_90 = (0.f - (pf_40_7 * f_4_41));
	// 0.4259384  <=>  (0.f - ({pf_30_24 : -0.4043915} * {f_3_88 : 1.053282}))
    f_3_91 = (0.f - (pf_30_24 * f_3_88));
	// -0.0954435  <=>  (0.f + {pf_27_40 : -0.0954435})
    pf_27_41 = (0.f + pf_27_40);
	// 0.8779377  <=>  (0.f - ({pf_23_23 : -0.8335257} * {f_3_88 : 1.053282}))
    f_6_44 = (0.f - (pf_23_23 * f_3_88));
	// 0.199755  <=>  ({pf_6_14 : 0.2275276} * {f_6_44 : 0.8779377})
    pf_37_20 = (pf_6_14 * f_6_44);
	// 0.1045283  <=>  cos(({pf_33_29 : 0.4666667} * 3.1415927f))
    f_6_45 = cos((pf_33_29 * 3.1415927f));
	// 0.2186363  <=>  (0.f - ({pf_22_44 : -0.2075762} * {f_3_88 : 1.053282}))
    f_7_91 = (0.f - (pf_22_44 * f_3_88));
	// -0.302587  <=>  ((({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {f_7_91 : 0.2186363}) + (0.f - {pf_37_20 : 0.199755}))
    pf_32_33 = (((pf_3_19 * f_20_18) * f_7_91) + (0.f - pf_37_20));
	// 0.8040398  <=>  cos(({pf_24_52 : 0.8986601} * 6.2831855f))
    f_7_92 = cos((pf_24_52 * 6.2831855f));
	// -0.5945755  <=>  sin(({pf_24_52 : 0.8986601} * 6.2831855f))
    f_8_80 = sin((pf_24_52 * 6.2831855f));
	// -0.1045283  <=>  (0.f - {f_6_45 : 0.1045283})
    f_9_52 = (0.f - f_6_45);
	// 0.9890738  <=>  (({f_6_45 : 0.1045283} * {f_9_52 : -0.1045283}) + 1.f)
    pf_37_21 = ((f_6_45 * f_9_52) + 1.f);
	// 0.7996352  <=>  ({f_7_92 : 0.8040398} * sqrt({pf_37_21 : 0.9890738}))
    pf_37_22 = (f_7_92 * sqrt(pf_37_21));
	// -0.5913184  <=>  ({f_8_80 : -0.5945755} * sqrt({pf_37_21 : 0.9890738}))
    pf_38_14 = (f_8_80 * sqrt(pf_37_21));
	// 0.6503426  <=>  (({f_6_45 : 0.1045283} * {f_6_45 : 0.1045283}) + ({pf_37_22 : 0.7996352} * {pf_37_22 : 0.7996352}))
    pf_39_8 = ((f_6_45 * f_6_45) + (pf_37_22 * pf_37_22));
	// 1.00  <=>  inversesqrt((({pf_38_14 : -0.5913184} * {pf_38_14 : -0.5913184}) + {pf_39_8 : 0.6503426}))
    f_9_54 = inversesqrt(((pf_38_14 * pf_38_14) + pf_39_8));
	// 0.1045283  <=>  ({f_6_45 : 0.1045283} * {f_9_54 : 1.00})
    pf_39_10 = (f_6_45 * f_9_54);
	// 0.6394164  <=>  (({pf_37_22 : 0.7996352} * {f_9_54 : 1.00}) * ({pf_37_22 : 0.7996352} * {f_9_54 : 1.00}))
    pf_42_10 = ((pf_37_22 * f_9_54) * (pf_37_22 * f_9_54));
	// 0.6503426  <=>  (({pf_39_10 : 0.1045283} * {pf_39_10 : 0.1045283}) + {pf_42_10 : 0.6394164})
    pf_42_11 = ((pf_39_10 * pf_39_10) + pf_42_10);
	// 1.00  <=>  ((({pf_38_14 : -0.5913184} * {f_9_54 : 1.00}) * ({pf_38_14 : -0.5913184} * {f_9_54 : 1.00})) + {pf_42_11 : 0.6503426})
    pf_42_12 = (((pf_38_14 * f_9_54) * (pf_38_14 * f_9_54)) + pf_42_11);
	// -0.5913184  <=>  (({pf_38_14 : -0.5913184} * {f_9_54 : 1.00}) * inversesqrt({pf_42_12 : 1.00}))
    pf_43_11 = ((pf_38_14 * f_9_54) * inversesqrt(pf_42_12));
	// 0.7996352  <=>  (({pf_37_22 : 0.7996352} * {f_9_54 : 1.00}) * inversesqrt({pf_42_12 : 1.00}))
    pf_44_6 = ((pf_37_22 * f_9_54) * inversesqrt(pf_42_12));
	// 0.5913184  <=>  ((0.f * ({pf_39_10 : 0.1045283} * inversesqrt({pf_42_12 : 1.00}))) + (0.f - {pf_43_11 : -0.5913184}))
    pf_45_4 = ((0.f * (pf_39_10 * inversesqrt(pf_42_12))) + (0.f - pf_43_11));
	// 0.7996352  <=>  ((0.f - 0.f) + {pf_44_6 : 0.7996352})
    pf_46_4 = ((0.f - 0.f) + pf_44_6);
	// 0.9890738  <=>  (({pf_46_4 : 0.7996352} * {pf_46_4 : 0.7996352}) + (({pf_45_4 : 0.5913184} * {pf_45_4 : 0.5913184}) + 0.f))
    pf_47_10 = ((pf_46_4 * pf_46_4) + ((pf_45_4 * pf_45_4) + 0.f));
	// -0.5470995  <=>  ((({pf_22_44 : -0.2075762} * {f_3_88 : 1.053282}) * ({pf_45_3 : 1.044534} + -0.5f)) + ({pf_31_20 : 0.9489096} * ({pf_44_5 : 0.048909} + -0.5f)))
    pf_28_39 = (((pf_22_44 * f_3_88) * (pf_45_3 + -0.5f)) + (pf_31_20 * (pf_44_5 + -0.5f)));
	// 1.005508  <=>  inversesqrt({pf_47_10 : 0.9890738})
    f_6_49 = inversesqrt(pf_47_10);
	// -0.5470995  <=>  (0.f + {pf_28_39 : -0.5470995})
    pf_28_40 = (0.f + pf_28_39);
	// 0.2145037  <=>  (({pf_34_22 : -0.490081} * {f_4_41 : 1.00}) * (0.f + {pf_29_37 : -0.4376903}))
    pf_31_22 = ((pf_34_22 * f_4_41) * (0.f + pf_29_37));
	// 3206034970  <=>  {ftou2(({pf_45_4 : 0.5913184} * (0.f - {f_6_49 : 1.005508}))) : 3206034970}
    u_8_35 = ftou2((pf_45_4 * (0.f - f_6_49)));
	// 0.2186363  <=>  (0.f - ({pf_22_44 : -0.2075762} * {f_3_88 : 1.053282}))
    f_6_51 = (0.f - (pf_22_44 * f_3_88));
	// -0.0323518  <=>  ((({pf_40_7 : 0.8150639} * {f_4_41 : 1.00}) * {pf_27_41 : -0.0954435}) + (({pf_41_9 : 0.3090169} * {pf_28_40 : -0.5470995}) + {pf_31_22 : 0.2145037}))
    pf_31_24 = (((pf_40_7 * f_4_41) * pf_27_41) + ((pf_41_9 * pf_28_40) + pf_31_22));
	// -0.06215  <=>  (({pf_39_10 : 0.1045283} * inversesqrt({pf_42_12 : 1.00})) * ({pf_45_4 : 0.5913184} * (0.f - {f_6_49 : 1.005508})))
    pf_48_2 = ((pf_39_10 * inversesqrt(pf_42_12)) * (pf_45_4 * (0.f - f_6_49)));
	// 0.4259384  <=>  (0.f - ({pf_30_24 : -0.4043915} * {f_3_88 : 1.053282}))
    f_6_52 = (0.f - (pf_30_24 * f_3_88));
	// -0.186421  <=>  (0.f - (({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {f_6_51 : 0.2186363}))
    f_9_57 = (0.f - ((pf_7_8 * f_20_18) * f_6_51));
	// 0.8779377  <=>  (0.f - ({pf_23_23 : -0.8335257} * {f_3_88 : 1.053282}))
    f_6_53 = (0.f - (pf_23_23 * f_3_88));
	// 0.9489095  <=>  ((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {f_6_53 : 0.8779377}) + (0.f - (({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {f_3_91 : 0.4259384})))
    pf_36_32 = (((pf_7_8 * f_20_18) * f_6_53) + (0.f - ((pf_3_19 * f_20_18) * f_3_91)));
	// -0.0840449  <=>  ((({pf_39_10 : 0.1045283} * inversesqrt({pf_42_12 : 1.00})) * ({pf_46_4 : 0.7996352} * (0.f - {f_6_49 : 1.005508}))) + (0.f - ({pf_43_11 : -0.5913184} * (0.f * (0.f - {f_6_49 : 1.005508})))))
    pf_41_11 = (((pf_39_10 * inversesqrt(pf_42_12)) * (pf_46_4 * (0.f - f_6_49))) + (0.f - (pf_43_11 * (0.f * (0.f - f_6_49)))));
	// 0.032489  <=>  ({pf_31_24 : -0.0323518} * (1.0f / ((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {f_3_90 : -0.8150639}) + (({pf_6_14 : 0.2275276} * (0.f - {pf_41_9 : 0.3090169})) + {pf_32_29 : -0.2305015}))))
    pf_31_25 = (pf_31_24 * (1.0f / (((pf_7_8 * f_20_18) * f_3_90) + ((pf_6_14 * (0.f - pf_41_9)) + pf_32_29))));
	// 0.6429385  <=>  (0.f - ({pf_44_6 : 0.7996352} * ({pf_46_4 : 0.7996352} * (0.f - {f_6_49 : 1.005508}))))
    f_3_93 = (0.f - (pf_44_6 * (pf_46_4 * (0.f - f_6_49))));
	// 0.9945219  <=>  (({pf_43_11 : -0.5913184} * ({pf_45_4 : 0.5913184} * (0.f - {f_6_49 : 1.005508}))) + {f_3_93 : 0.6429385})
    pf_40_10 = ((pf_43_11 * (pf_45_4 * (0.f - f_6_49))) + f_3_93);
	// 0.06215  <=>  (({pf_44_6 : 0.7996352} * (0.f * (0.f - {f_6_49 : 1.005508}))) + (0.f - {pf_48_2 : -0.06215}))
    pf_34_25 = ((pf_44_6 * (0.f * (0.f - f_6_49))) + (0.f - pf_48_2));
	// 2147483648  <=>  {ftou2((0.f * (0.f - {f_6_49 : 1.005508}))) : 2147483648}
    u_13_18 = ftou2((0.f * (0.f - f_6_49)));
    u_13_phi_199 = u_13_18;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 0  <=>  0u
        u_13_19 = 0u;
        u_13_phi_199 = u_13_19;
    }
	// 0.908441  <=>  (({pf_36_32 : 0.9489095} * {pf_36_32 : 0.9489095}) + ((({pf_6_14 : 0.2275276} * {f_6_52 : 0.4259384}) + {f_9_57 : -0.186421}) * (({pf_6_14 : 0.2275276} * {f_6_52 : 0.4259384}) + {f_9_57 : -0.186421})))
    pf_45_7 = ((pf_36_32 * pf_36_32) + (((pf_6_14 * f_6_52) + f_9_57) * ((pf_6_14 * f_6_52) + f_9_57)));
	// -0.452971  <=>  ((({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {pf_31_25 : 0.032489}) + (0.f + {pf_29_37 : -0.4376903}))
    pf_29_39 = (((pf_3_19 * f_20_18) * pf_31_25) + (0.f + pf_29_37));
	// 3202357491  <=>  {ftou2((0.f + {pf_29_37 : -0.4376903})) : 3202357491}
    u_4_23 = ftou2((0.f + pf_29_37));
    u_4_phi_200 = u_4_23;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
        u_4_24 = ftou2((pf_9_10 * 6.2831855f));
        u_4_phi_200 = u_4_24;
    }
	// 1.00  <=>  inversesqrt((({pf_32_33 : -0.302587} * {pf_32_33 : -0.302587}) + {pf_45_7 : 0.908441}))
    f_3_97 = inversesqrt(((pf_32_33 * pf_32_33) + pf_45_7));
	// 1.00  <=>  inversesqrt((({pf_34_25 : 0.06215} * {pf_34_25 : 0.06215}) + (({pf_40_10 : 0.9945219} * {pf_40_10 : 0.9945219}) + ({pf_41_11 : -0.0840449} * {pf_41_11 : -0.0840449}))))
    f_6_56 = inversesqrt(((pf_34_25 * pf_34_25) + ((pf_40_10 * pf_40_10) + (pf_41_11 * pf_41_11))));
	// 3202357491  <=>  {u_4_phi_200 : 3202357491}
    u_1_48 = u_4_phi_200;
    u_1_phi_201 = u_1_48;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 3202357491  <=>  {u_4_phi_200 : 3202357491}
        u_1_49 = u_4_phi_200;
        u_1_phi_201 = u_1_49;
    }
	// 3206034970  <=>  {u_8_35 : 3206034970}
    u_4_25 = u_8_35;
    u_4_phi_202 = u_4_25;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 3201893041  <=>  {ftou2(sin({utof2(u_1_phi_201) : -0.4376903})) : 3201893041}
        u_4_26 = ftou2(sin( utof2(u_1_phi_201)));
        u_4_phi_202 = u_4_26;
    }
	// 0.9489096  <=>  ({pf_36_32 : 0.9489095} * {f_3_97 : 1.00})
    pf_28_44 = (pf_36_32 * f_3_97);
	// 3182174141  <=>  {ftou2(({pf_41_11 : -0.0840449} * {f_6_56 : 1.00})) : 3182174141}
    u_8_36 = ftou2((pf_41_11 * f_6_56));
    u_8_phi_203 = u_8_36;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 1063771679  <=>  {ftou2(cos({utof2(u_1_phi_201) : -0.4376903})) : 1063771679}
        u_8_37 = ftou2(cos( utof2(u_1_phi_201)));
        u_8_phi_203 = u_8_37;
    }
	// 1031704823  <=>  {ftou2(({pf_34_25 : 0.06215} * {f_6_56 : 1.00})) : 1031704823}
    u_2_32 = ftou2((pf_34_25 * f_6_56));
	// 0.0768924  <=>  (((((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {pf_31_25 : 0.032489}) + {pf_27_41 : -0.0954435}) * {utof2(u_2_phi_187) : 0.5153016}) + (({pf_29_39 : -0.452971} * {utof2(u_21_phi_187) : 0.8570089}) + ((({pf_6_14 : 0.2275276} * {pf_31_25 : 0.032489}) + {pf_28_40 : -0.5470995}) * {utof2(u_22_phi_187) : -0.00}))) + 0.5f)
    pf_29_41 = ((((((pf_7_8 * f_20_18) * pf_31_25) + pf_27_41) * utof2(u_2_phi_187)) + ((pf_29_39 * utof2(u_21_phi_187)) + (((pf_6_14 * pf_31_25) + pf_28_40) * utof2(u_22_phi_187)))) + 0.5f);
	// 0.0768924  <=>  clamp({pf_29_41 : 0.0768924}, 0.0, 1.0)
    f_3_98 = clamp(pf_29_41, 0.0, 1.0);
	// -0.0674819  <=>  (((((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {pf_31_25 : 0.032489}) + {pf_27_41 : -0.0954435}) * {utof2(u_19_phi_187) : -0.2648302}) + (({pf_29_39 : -0.452971} * {utof2(u_20_phi_187) : 0.1592369}) + ((({pf_6_14 : 0.2275276} * {pf_31_25 : 0.032489}) + {pf_28_40 : -0.5470995}) * {utof2(u_23_phi_187) : 0.9510567}))) + 0.5f)
    pf_27_44 = ((((((pf_7_8 * f_20_18) * pf_31_25) + pf_27_41) * utof2(u_19_phi_187)) + ((pf_29_39 * utof2(u_20_phi_187)) + (((pf_6_14 * pf_31_25) + pf_28_40) * utof2(u_23_phi_187)))) + 0.5f);
	// 0.00  <=>  clamp({pf_27_44 : -0.0674819}, 0.0, 1.0)
    f_6_57 = clamp(pf_27_44, 0.0, 1.0);
	// 1065261309  <=>  {ftou2(({pf_40_10 : 0.9945219} * {f_6_56 : 1.00})) : 1065261309}
    u_14_63 = ftou2((pf_40_10 * f_6_56));
    u_14_phi_204 = u_14_63;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 0  <=>  0u
        u_14_64 = 0u;
        u_14_phi_204 = u_14_64;
    }
	// 1031704823  <=>  {u_2_32 : 1031704823}
    u_1_52 = u_2_32;
    u_1_phi_205 = u_1_52;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 1058551322  <=>  {ftou2(((0.f - {utof2(u_4_phi_202) : -0.5945755}) + (0.f - 0.f))) : 1058551322}
        u_1_53 = ftou2(((0.f - utof2(u_4_phi_202)) + (0.f - 0.f)));
        u_1_phi_205 = u_1_53;
    }
	// 3209549197  <=>  {ftou2(({pf_46_4 : 0.7996352} * (0.f - {f_6_49 : 1.005508}))) : 3209549197}
    u_2_33 = ftou2((pf_46_4 * (0.f - f_6_49)));
    u_2_phi_206 = u_2_33;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 3182174141  <=>  {u_8_phi_203 : 3182174141}
        u_2_34 = u_8_phi_203;
        u_2_phi_206 = u_2_34;
    }
	// 3209549197  <=>  {u_2_phi_206 : 3209549197}
    u_5_24 = u_2_phi_206;
	// 1031704823  <=>  {u_1_phi_205 : 1031704823}
    u_16_41 = u_1_phi_205;
	// 3182174141  <=>  {u_8_phi_203 : 3182174141}
    u_17_24 = u_8_phi_203;
	// 3206034970  <=>  {u_4_phi_202 : 3206034970}
    u_19_18 = u_4_phi_202;
	// 1065261309  <=>  {u_14_phi_204 : 1065261309}
    u_20_20 = u_14_phi_204;
	// 2147483648  <=>  {u_13_phi_199 : 2147483648}
    u_21_14 = u_13_phi_199;
    u_5_phi_207 = u_5_24;
    u_16_phi_207 = u_16_41;
    u_17_phi_207 = u_17_24;
    u_19_phi_207 = u_19_18;
    u_20_phi_207 = u_20_20;
    u_21_phi_207 = u_21_14;
	// True  <=>  if(((! ({u_16_39 : 7} == 0u)) ? true : false))
    if (((!(u_16_39 == 0u)) ? true : false))
    {
		// 3182907418  <=>  {ftou2((({pf_6_14 : 0.2275276} * {f_6_52 : 0.4259384}) + {f_9_57 : -0.186421})) : 3182907418}
        u_22_12 = ftou2(((pf_6_14 * f_6_52) + f_9_57));
        u_22_phi_208 = u_22_12;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
            u_22_13 = ftou2((pf_9_10 * 6.2831855f));
            u_22_phi_208 = u_22_13;
        }
		// 1065261309  <=>  {u_14_phi_204 : 1065261309}
        u_10_53 = u_14_phi_204;
        u_10_phi_209 = u_10_53;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 0  <=>  0u
            u_10_54 = 0u;
            u_10_phi_209 = u_10_54;
        }
		// 2147483648  <=>  {u_13_phi_199 : 2147483648}
        u_23_14 = u_13_phi_199;
        u_23_phi_210 = u_23_14;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 0  <=>  0u
            u_23_15 = 0u;
            u_23_phi_210 = u_23_15;
        }
		// 3182907418  <=>  {u_22_phi_208 : 3182907418}
        u_24_13 = u_22_phi_208;
        u_24_phi_211 = u_24_13;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 3182907418  <=>  {u_22_phi_208 : 3182907418}
            u_24_14 = u_22_phi_208;
            u_24_phi_211 = u_24_14;
        }
		// 3209549197  <=>  {u_2_phi_206 : 3209549197}
        u_22_14 = u_2_phi_206;
        u_22_phi_212 = u_22_14;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1065286054  <=>  {ftou2(cos({utof2(u_24_phi_211) : -0.0895083})) : 1065286054}
            u_22_15 = ftou2(cos( utof2(u_24_phi_211)));
            u_22_phi_212 = u_22_15;
        }
		// 3206034970  <=>  {u_4_phi_202 : 3206034970}
        u_25_20 = u_4_phi_202;
        u_25_phi_213 = u_25_20;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 3182891383  <=>  {ftou2(sin({utof2(u_24_phi_211) : -0.0895083})) : 3182891383}
            u_25_21 = ftou2(sin( utof2(u_24_phi_211)));
            u_25_phi_213 = u_25_21;
        }
		// 3182174141  <=>  {u_8_phi_203 : 3182174141}
        u_24_16 = u_8_phi_203;
        u_24_phi_214 = u_24_16;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1062065549  <=>  {ftou2(((0.f - {utof2(u_22_phi_212) : -0.8040398}) + (0.f - 0.f))) : 1062065549}
            u_24_17 = ftou2(((0.f - utof2(u_22_phi_212)) + (0.f - 0.f)));
            u_24_phi_214 = u_24_17;
        }
		// 1031704823  <=>  {u_1_phi_205 : 1031704823}
        u_26_20 = u_1_phi_205;
        u_26_phi_215 = u_26_20;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 3206034970  <=>  {u_25_phi_213 : 3206034970}
            u_26_21 = u_25_phi_213;
            u_26_phi_215 = u_26_21;
        }
		// 3209549197  <=>  {u_22_phi_212 : 3209549197}
        u_27_21 = u_22_phi_212;
		// 1031704823  <=>  {u_26_phi_215 : 1031704823}
        u_28_22 = u_26_phi_215;
		// 3182174141  <=>  {u_24_phi_214 : 3182174141}
        u_29_17 = u_24_phi_214;
		// 3206034970  <=>  {u_25_phi_213 : 3206034970}
        u_30_17 = u_25_phi_213;
		// 1065261309  <=>  {u_10_phi_209 : 1065261309}
        u_31_13 = u_10_phi_209;
		// 2147483648  <=>  {u_23_phi_210 : 2147483648}
        u_32_13 = u_23_phi_210;
        u_27_phi_216 = u_27_21;
        u_28_phi_216 = u_28_22;
        u_29_phi_216 = u_29_17;
        u_30_phi_216 = u_30_17;
        u_31_phi_216 = u_31_13;
        u_32_phi_216 = u_32_13;
		// True  <=>  if(((! ({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u))) ? true : false))
        if (((!(u_16_39 == (u_1_20 + 4294967295u))) ? true : false))
        {
			// 0.5333333  <=>  ((0.f - {pf_33_29 : 0.4666667}) + 1.f)
            pf_27_48 = ((0.f - pf_33_29) + 1.f);
			// False  <=>  ((({pf_27_48 : 0.5333333} < float(1e-05)) && (! isnan({pf_27_48 : 0.5333333}))) && (! isnan(float(1e-05))))
            b_3_109 = (((pf_27_48 < float(1e-05)) && (!isnan(pf_27_48))) && (!isnan(float(1e-05))));
			// False  <=>  (((({pf_33_29 : 0.4666667} < float(1e-05)) && (! isnan({pf_33_29 : 0.4666667}))) && (! isnan(float(1e-05)))) ? true : false)
            b_4_44 = ((((pf_33_29 < float(1e-05)) && (!isnan(pf_33_29))) && (!isnan(float(1e-05)))) ? true : false);
			// 3209549197  <=>  {u_22_phi_212 : 3209549197}
            u_33_12 = u_22_phi_212;
			// 1031704823  <=>  {u_26_phi_215 : 1031704823}
            u_34_12 = u_26_phi_215;
			// 3182174141  <=>  {u_24_phi_214 : 3182174141}
            u_35_12 = u_24_phi_214;
			// 3206034970  <=>  {u_25_phi_213 : 3206034970}
            u_36_12 = u_25_phi_213;
			// 1065261309  <=>  {u_10_phi_209 : 1065261309}
            u_37_12 = u_10_phi_209;
			// 2147483648  <=>  {u_23_phi_210 : 2147483648}
            u_38_12 = u_23_phi_210;
            u_33_phi_217 = u_33_12;
            u_34_phi_217 = u_34_12;
            u_35_phi_217 = u_35_12;
            u_36_phi_217 = u_36_12;
            u_37_phi_217 = u_37_12;
            u_38_phi_217 = u_38_12;
			// False  <=>  if({b_4_44 : False})
            if (b_4_44)
            {
				// -0.8040397  <=>  cos((({pf_24_52 : 0.8986601} * 6.2831855f) + 3.1415927f))
                f_9_75 = cos(((pf_24_52 * 6.2831855f) + 3.1415927f));
				// 0.5945756  <=>  sin((({pf_24_52 : 0.8986601} * 6.2831855f) + 3.1415927f))
                f_10_101 = sin(((pf_24_52 * 6.2831855f) + 3.1415927f));
				// 1.00  <=>  inversesqrt((({f_10_101 : 0.5945756} * {f_10_101 : 0.5945756}) + (({f_9_75 : -0.8040397} * {f_9_75 : -0.8040397}) + 0.f)))
                f_11_64 = inversesqrt(((f_10_101 * f_10_101) + ((f_9_75 * f_9_75) + 0.f)));
				// -0.06215  <=>  (0.f - (({pf_39_10 : 0.1045283} * inversesqrt({pf_42_12 : 1.00})) * ({f_10_101 : 0.5945756} * {f_11_64 : 1.00})))
                f_9_76 = (0.f - ((pf_39_10 * inversesqrt(pf_42_12)) * (f_10_101 * f_11_64)));
				// -0.06215  <=>  (({pf_43_11 : -0.5913184} * (0.f * {f_11_64 : 1.00})) + {f_9_76 : -0.06215})
                pf_29_43 = ((pf_43_11 * (0.f * f_11_64)) + f_9_76);
				// -0.4754434  <=>  (0.f - ({pf_43_11 : -0.5913184} * ({f_9_75 : -0.8040397} * {f_11_64 : 1.00})))
                f_9_77 = (0.f - (pf_43_11 * (f_9_75 * f_11_64)));
				// 0.0000002  <=>  (({pf_44_6 : 0.7996352} * ({f_10_101 : 0.5945756} * {f_11_64 : 1.00})) + {f_9_77 : -0.4754434})
                pf_24_57 = ((pf_44_6 * (f_10_101 * f_11_64)) + f_9_77);
				// -0.0840449  <=>  ((({pf_39_10 : 0.1045283} * inversesqrt({pf_42_12 : 1.00})) * ({f_9_75 : -0.8040397} * {f_11_64 : 1.00})) + (0.f - ({pf_44_6 : 0.7996352} * (0.f * {f_11_64 : 1.00}))))
                pf_27_50 = (((pf_39_10 * inversesqrt(pf_42_12)) * (f_9_75 * f_11_64)) + (0.f - (pf_44_6 * (0.f * f_11_64))));
				// 0.0038626  <=>  (({pf_24_57 : 0.0000002} * {pf_24_57 : 0.0000002}) + ({pf_29_43 : -0.06215} * {pf_29_43 : -0.06215}))
                pf_34_29 = ((pf_24_57 * pf_24_57) + (pf_29_43 * pf_29_43));
				// 0.0109262  <=>  (({pf_27_50 : -0.0840449} * {pf_27_50 : -0.0840449}) + {pf_34_29 : 0.0038626})
                pf_34_30 = ((pf_27_50 * pf_27_50) + pf_34_29);
				// 0.0000017  <=>  ({pf_24_57 : 0.0000002} * inversesqrt({pf_34_30 : 0.0109262}))
                pf_24_58 = (pf_24_57 * inversesqrt(pf_34_30));
				// -0.8040397  <=>  ({pf_27_50 : -0.0840449} * inversesqrt({pf_34_30 : 0.0109262}))
                pf_24_59 = (pf_27_50 * inversesqrt(pf_34_30));
				// 3209549195  <=>  {ftou2(pf_24_59) : 3209549195}
                u_33_13 = ftou2(pf_24_59);
				// 1058551324  <=>  {ftou2(({f_10_101 : 0.5945756} * {f_11_64 : 1.00})) : 1058551324}
                u_34_13 = ftou2((f_10_101 * f_11_64));
				// 3209549195  <=>  {ftou2(({f_9_75 : -0.8040397} * {f_11_64 : 1.00})) : 3209549195}
                u_35_13 = ftou2((f_9_75 * f_11_64));
				// 3206034973  <=>  {ftou2(({pf_29_43 : -0.06215} * inversesqrt({pf_34_30 : 0.0109262}))) : 3206034973}
                u_36_13 = ftou2((pf_29_43 * inversesqrt(pf_34_30)));
				// 0  <=>  {ftou2((0.f * {f_11_64 : 1.00})) : 0}
                u_37_13 = ftou2((0.f * f_11_64));
				// 903845471  <=>  {ftou2(pf_24_58) : 903845471}
                u_38_13 = ftou2(pf_24_58);
                u_33_phi_217 = u_33_13;
                u_34_phi_217 = u_34_13;
                u_35_phi_217 = u_35_13;
                u_36_phi_217 = u_36_13;
                u_37_phi_217 = u_37_13;
                u_38_phi_217 = u_38_13;
            }
			// 3209549197  <=>  {u_33_phi_217 : 3209549197}
            u_39_13 = u_33_phi_217;
			// 1031704823  <=>  {u_34_phi_217 : 1031704823}
            u_40_14 = u_34_phi_217;
			// 3182174141  <=>  {u_35_phi_217 : 3182174141}
            u_41_14 = u_35_phi_217;
			// 3206034970  <=>  {u_36_phi_217 : 3206034970}
            u_42_16 = u_36_phi_217;
			// 1065261309  <=>  {u_37_phi_217 : 1065261309}
            u_43_18 = u_37_phi_217;
			// 2147483648  <=>  {u_38_phi_217 : 2147483648}
            u_44_18 = u_38_phi_217;
            u_39_phi_218 = u_39_13;
            u_40_phi_218 = u_40_14;
            u_41_phi_218 = u_41_14;
            u_42_phi_218 = u_42_16;
            u_43_phi_218 = u_43_18;
            u_44_phi_218 = u_44_18;
			// False  <=>  if(({b_3_109 : False} ? true : false))
            if ((b_3_109 ? true : false))
            {
				// 1.00  <=>  inversesqrt((({f_8_80 : -0.5945755} * {f_8_80 : -0.5945755}) + (({f_7_92 : 0.8040398} * {f_7_92 : 0.8040398}) + 0.f)))
                f_9_80 = inversesqrt(((f_8_80 * f_8_80) + ((f_7_92 * f_7_92) + 0.f)));
				// 0.06215  <=>  (0.f - (({pf_39_10 : 0.1045283} * inversesqrt({pf_42_12 : 1.00})) * ({f_8_80 : -0.5945755} * {f_9_80 : 1.00})))
                f_7_93 = (0.f - ((pf_39_10 * inversesqrt(pf_42_12)) * (f_8_80 * f_9_80)));
				// 0.06215  <=>  (({pf_43_11 : -0.5913184} * (0.f * {f_9_80 : 1.00})) + {f_7_93 : 0.06215})
                pf_34_32 = ((pf_43_11 * (0.f * f_9_80)) + f_7_93);
				// 0.4754435  <=>  (0.f - ({pf_43_11 : -0.5913184} * ({f_7_92 : 0.8040398} * {f_9_80 : 1.00})))
                f_7_94 = (0.f - (pf_43_11 * (f_7_92 * f_9_80)));
				// -0.00  <=>  (({pf_44_6 : 0.7996352} * ({f_8_80 : -0.5945755} * {f_9_80 : 1.00})) + {f_7_94 : 0.4754435})
                pf_24_63 = ((pf_44_6 * (f_8_80 * f_9_80)) + f_7_94);
				// 0.0840449  <=>  ((({pf_39_10 : 0.1045283} * inversesqrt({pf_42_12 : 1.00})) * ({f_7_92 : 0.8040398} * {f_9_80 : 1.00})) + (0.f - ({pf_44_6 : 0.7996352} * (0.f * {f_9_80 : 1.00}))))
                pf_27_52 = (((pf_39_10 * inversesqrt(pf_42_12)) * (f_7_92 * f_9_80)) + (0.f - (pf_44_6 * (0.f * f_9_80))));
				// 0.0038626  <=>  (({pf_24_63 : -0.00} * {pf_24_63 : -0.00}) + ({pf_34_32 : 0.06215} * {pf_34_32 : 0.06215}))
                pf_29_47 = ((pf_24_63 * pf_24_63) + (pf_34_32 * pf_34_32));
				// 0.0109262  <=>  (({pf_27_52 : 0.0840449} * {pf_27_52 : 0.0840449}) + {pf_29_47 : 0.0038626})
                pf_29_48 = ((pf_27_52 * pf_27_52) + pf_29_47);
				// -0.0000002  <=>  ({pf_24_63 : -0.00} * inversesqrt({pf_29_48 : 0.0109262}))
                pf_24_64 = (pf_24_63 * inversesqrt(pf_29_48));
				// 0.8040397  <=>  ({pf_27_52 : 0.0840449} * inversesqrt({pf_29_48 : 0.0109262}))
                pf_24_65 = (pf_27_52 * inversesqrt(pf_29_48));
				// 1062065548  <=>  {ftou2(pf_24_65) : 1062065548}
                u_39_14 = ftou2(pf_24_65);
				// 3206034970  <=>  {ftou2(({f_8_80 : -0.5945755} * {f_9_80 : 1.00})) : 3206034970}
                u_40_15 = ftou2((f_8_80 * f_9_80));
				// 1062065549  <=>  {ftou2(({f_7_92 : 0.8040398} * {f_9_80 : 1.00})) : 1062065549}
                u_41_15 = ftou2((f_7_92 * f_9_80));
				// 1058551321  <=>  {ftou2(({pf_34_32 : 0.06215} * inversesqrt({pf_29_48 : 0.0109262}))) : 1058551321}
                u_42_17 = ftou2((pf_34_32 * inversesqrt(pf_29_48)));
				// 0  <=>  {ftou2((0.f * {f_9_80 : 1.00})) : 0}
                u_43_19 = ftou2((0.f * f_9_80));
				// 3024436092  <=>  {ftou2(pf_24_64) : 3024436092}
                u_44_19 = ftou2(pf_24_64);
                u_39_phi_218 = u_39_14;
                u_40_phi_218 = u_40_15;
                u_41_phi_218 = u_41_15;
                u_42_phi_218 = u_42_17;
                u_43_phi_218 = u_43_19;
                u_44_phi_218 = u_44_19;
            }
			// 3209549197  <=>  {u_39_phi_218 : 3209549197}
            u_27_22 = u_39_phi_218;
			// 1031704823  <=>  {u_40_phi_218 : 1031704823}
            u_28_23 = u_40_phi_218;
			// 3182174141  <=>  {u_41_phi_218 : 3182174141}
            u_29_18 = u_41_phi_218;
			// 3206034970  <=>  {u_42_phi_218 : 3206034970}
            u_30_18 = u_42_phi_218;
			// 1065261309  <=>  {u_43_phi_218 : 1065261309}
            u_31_14 = u_43_phi_218;
			// 2147483648  <=>  {u_44_phi_218 : 2147483648}
            u_32_14 = u_44_phi_218;
            u_27_phi_216 = u_27_22;
            u_28_phi_216 = u_28_23;
            u_29_phi_216 = u_29_18;
            u_30_phi_216 = u_30_18;
            u_31_phi_216 = u_31_14;
            u_32_phi_216 = u_32_14;
        }
		// 3209549197  <=>  {u_27_phi_216 : 3209549197}
        u_5_25 = u_27_phi_216;
		// 1031704823  <=>  {u_28_phi_216 : 1031704823}
        u_16_42 = u_28_phi_216;
		// 3182174141  <=>  {u_29_phi_216 : 3182174141}
        u_17_25 = u_29_phi_216;
		// 3206034970  <=>  {u_30_phi_216 : 3206034970}
        u_19_19 = u_30_phi_216;
		// 1065261309  <=>  {u_31_phi_216 : 1065261309}
        u_20_21 = u_31_phi_216;
		// 2147483648  <=>  {u_32_phi_216 : 2147483648}
        u_21_15 = u_32_phi_216;
        u_5_phi_207 = u_5_25;
        u_16_phi_207 = u_16_42;
        u_17_phi_207 = u_17_25;
        u_19_phi_207 = u_19_19;
        u_20_phi_207 = u_20_21;
        u_21_phi_207 = u_21_15;
    }
	// -1.00  <=>  floor((((0.f - {pf_9_10 : 1.10134}) + {f_2_65 : 0.0625}) + ({f_2_65 : 0.0625} * {f_1_69 : 6.00})))
    f_7_97 = floor((((0.f - pf_9_10) + f_2_65) + (f_2_65 * f_1_69)));
	// -0.7996352  <=>  (0.f - ({pf_37_22 : 0.7996352} * {f_9_54 : 1.00}))
    f_8_81 = (0.f - (pf_37_22 * f_9_54));
	// 0.3760952  <=>  (({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {f_8_81 : -0.7996352})
    pf_28_45 = ((pf_3_19 * f_20_18) * f_8_81);
	// -0.5470995  <=>  ((({pf_45_3 : 1.044534} + -0.5f) * ({pf_22_44 : -0.2075762} * {f_3_88 : 1.053282})) + (({pf_44_5 : 0.048909} + -0.5f) * {pf_28_44 : 0.9489096}))
    pf_27_54 = (((pf_45_3 + -0.5f) * (pf_22_44 * f_3_88)) + ((pf_44_5 + -0.5f) * pf_28_44));
	// 0.1045283  <=>  cos(({pf_33_29 : 0.4666667} * 3.1415927f))
    f_8_82 = cos((pf_33_29 * 3.1415927f));
	// 0.3361601  <=>  ((((0.f - {pf_9_10 : 1.10134}) + {f_2_65 : 0.0625}) + ({f_2_65 : 0.0625} * {f_1_69 : 6.00})) + (0.f - {f_7_97 : -1.00}))
    pf_15_12 = ((((0.f - pf_9_10) + f_2_65) + (f_2_65 * f_1_69)) + (0.f - f_7_97));
	// 0.5913184  <=>  (0.f - ({pf_38_14 : -0.5913184} * {f_9_54 : 1.00}))
    f_7_99 = (0.f - (pf_38_14 * f_9_54));
	// -0.1045283  <=>  (0.f - {f_8_82 : 0.1045283})
    f_9_82 = (0.f - f_8_82);
	// 0.9890738  <=>  (({f_8_82 : 0.1045283} * {f_9_82 : -0.1045283}) + 1.f)
    pf_28_46 = ((f_8_82 * f_9_82) + 1.f);
	// -0.5153016  <=>  cos(({pf_15_12 : 0.3361601} * 6.2831855f))
    f_10_102 = cos((pf_15_12 * 6.2831855f));
	// 0.8570089  <=>  sin(({pf_15_12 : 0.3361601} * 6.2831855f))
    f_11_65 = sin((pf_15_12 * 6.2831855f));
	// -0.5124788  <=>  ({f_10_102 : -0.5153016} * sqrt({pf_28_46 : 0.9890738}))
    pf_24_70 = (f_10_102 * sqrt(pf_28_46));
	// 0.8523141  <=>  ({f_11_65 : 0.8570089} * sqrt({pf_28_46 : 0.9890738}))
    pf_28_47 = (f_11_65 * sqrt(pf_28_46));
	// 0.2735606  <=>  (({f_8_82 : 0.1045283} * {f_8_82 : 0.1045283}) + ({pf_24_70 : -0.5124788} * {pf_24_70 : -0.5124788}))
    pf_29_51 = ((f_8_82 * f_8_82) + (pf_24_70 * pf_24_70));
	// 1.00  <=>  inversesqrt((({pf_28_47 : 0.8523141} * {pf_28_47 : 0.8523141}) + {pf_29_51 : 0.2735606}))
    f_9_84 = inversesqrt(((pf_28_47 * pf_28_47) + pf_29_51));
	// 0.1045283  <=>  ({f_8_82 : 0.1045283} * {f_9_84 : 1.00})
    pf_29_53 = (f_8_82 * f_9_84);
	// 0.2626345  <=>  (({pf_24_70 : -0.5124788} * {f_9_84 : 1.00}) * ({pf_24_70 : -0.5124788} * {f_9_84 : 1.00}))
    pf_34_33 = ((pf_24_70 * f_9_84) * (pf_24_70 * f_9_84));
	// 0.2735606  <=>  (({pf_29_53 : 0.1045283} * {pf_29_53 : 0.1045283}) + {pf_34_33 : 0.2626345})
    pf_34_34 = ((pf_29_53 * pf_29_53) + pf_34_33);
	// 1.00  <=>  ((({pf_28_47 : 0.8523141} * {f_9_84 : 1.00}) * ({pf_28_47 : 0.8523141} * {f_9_84 : 1.00})) + {pf_34_34 : 0.2735606})
    pf_34_35 = (((pf_28_47 * f_9_84) * (pf_28_47 * f_9_84)) + pf_34_34);
	// -0.4376903  <=>  ((({pf_45_3 : 1.044534} + -0.5f) * ({pf_23_23 : -0.8335257} * {f_3_88 : 1.053282})) + (({pf_44_5 : 0.048909} + -0.5f) * ((({pf_6_14 : 0.2275276} * {f_6_52 : 0.4259384}) + {f_9_57 : -0.186421}) * {f_3_97 : 1.00})))
    pf_31_31 = (((pf_45_3 + -0.5f) * (pf_23_23 * f_3_88)) + ((pf_44_5 + -0.5f) * (((pf_6_14 * f_6_52) + f_9_57) * f_3_97)));
	// 0.8523141  <=>  (({pf_28_47 : 0.8523141} * {f_9_84 : 1.00}) * inversesqrt({pf_34_35 : 1.00}))
    pf_35_32 = ((pf_28_47 * f_9_84) * inversesqrt(pf_34_35));
	// -0.5124788  <=>  (({pf_24_70 : -0.5124788} * {f_9_84 : 1.00}) * inversesqrt({pf_34_35 : 1.00}))
    pf_36_38 = ((pf_24_70 * f_9_84) * inversesqrt(pf_34_35));
	// -0.5470995  <=>  (0.f + {pf_27_54 : -0.5470995})
    pf_27_55 = (0.f + pf_27_54);
	// -0.8523141  <=>  ((0.f * ({pf_29_53 : 0.1045283} * inversesqrt({pf_34_35 : 1.00}))) + (0.f - {pf_35_32 : 0.8523141}))
    pf_40_12 = ((0.f * (pf_29_53 * inversesqrt(pf_34_35))) + (0.f - pf_35_32));
	// -0.5124788  <=>  ((0.f - 0.f) + {pf_36_38 : -0.5124788})
    pf_41_12 = ((0.f - 0.f) + pf_36_38);
	// 0.9890739  <=>  (({pf_41_12 : -0.5124788} * {pf_41_12 : -0.5124788}) + (({pf_40_12 : -0.8523141} * {pf_40_12 : -0.8523141}) + 0.f))
    pf_42_15 = ((pf_41_12 * pf_41_12) + ((pf_40_12 * pf_40_12) + 0.f));
	// 1.005508  <=>  inversesqrt({pf_42_15 : 0.9890739})
    f_8_86 = inversesqrt(pf_42_15);
	// 0.4259384  <=>  (0.f - ({pf_30_24 : -0.4043915} * {f_3_88 : 1.053282}))
    f_9_85 = (0.f - (pf_30_24 * f_3_88));
	// -0.3499926  <=>  (({pf_37_22 : 0.7996352} * {f_9_54 : 1.00}) * (0.f + {pf_31_31 : -0.4376903}))
    pf_37_24 = ((pf_37_22 * f_9_54) * (0.f + pf_31_31));
	// -0.0954435  <=>  ((({pf_45_3 : 1.044534} + -0.5f) * ({pf_30_24 : -0.4043915} * {f_3_88 : 1.053282})) + (({pf_44_5 : 0.048909} + -0.5f) * ({pf_32_33 : -0.302587} * {f_3_97 : 1.00})))
    pf_32_36 = (((pf_45_3 + -0.5f) * (pf_30_24 * f_3_88)) + ((pf_44_5 + -0.5f) * (pf_32_33 * f_3_97)));
	// 0.8779377  <=>  (0.f - ({pf_23_23 : -0.8335257} * {f_3_88 : 1.053282}))
    f_9_86 = (0.f - (pf_23_23 * f_3_88));
	// 0.9489095  <=>  ((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {f_9_86 : 0.8779377}) + (0.f - (({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {f_9_85 : 0.4259384})))
    pf_42_17 = (((pf_7_8 * f_20_18) * f_9_86) + (0.f - ((pf_3_19 * f_20_18) * f_9_85)));
	// -0.0954435  <=>  (0.f + {pf_32_36 : -0.0954435})
    pf_32_37 = (0.f + pf_32_36);
	// 1062954224  <=>  {ftou2(({pf_40_12 : -0.8523141} * (0.f - {f_8_86 : 1.005508}))) : 1062954224}
    u_8_38 = ftou2((pf_40_12 * (0.f - f_8_86)));
	// -0.3507425  <=>  ((({pf_38_14 : -0.5913184} * {f_9_54 : 1.00}) * {pf_32_37 : -0.0954435}) + (({pf_39_10 : 0.1045283} * {pf_27_55 : -0.5470995}) + {pf_37_24 : -0.3499926}))
    pf_37_26 = (((pf_38_14 * f_9_54) * pf_32_37) + ((pf_39_10 * pf_27_55) + pf_37_24));
	// 0.0895817  <=>  (({pf_29_53 : 0.1045283} * inversesqrt({pf_34_35 : 1.00})) * ({pf_40_12 : -0.8523141} * (0.f - {f_8_86 : 1.005508})))
    pf_38_16 = ((pf_29_53 * inversesqrt(pf_34_35)) * (pf_40_12 * (0.f - f_8_86)));
	// 0.0538636  <=>  ((({pf_29_53 : 0.1045283} * inversesqrt({pf_34_35 : 1.00})) * ({pf_41_12 : -0.5124788} * (0.f - {f_8_86 : 1.005508}))) + (0.f - ({pf_35_32 : 0.8523141} * (0.f * (0.f - {f_8_86 : 1.005508})))))
    pf_41_14 = (((pf_29_53 * inversesqrt(pf_34_35)) * (pf_41_12 * (0.f - f_8_86))) + (0.f - (pf_35_32 * (0.f * (0.f - f_8_86)))));
	// 0.2186363  <=>  (0.f - ({pf_22_44 : -0.2075762} * {f_3_88 : 1.053282}))
    f_8_89 = (0.f - (pf_22_44 * f_3_88));
	// 0.2640812  <=>  (0.f - ({pf_36_38 : -0.5124788} * ({pf_41_12 : -0.5124788} * (0.f - {f_8_86 : 1.005508}))))
    f_8_90 = (0.f - (pf_36_38 * (pf_41_12 * (0.f - f_8_86))));
	// 0.994522  <=>  (({pf_35_32 : 0.8523141} * ({pf_40_12 : -0.8523141} * (0.f - {f_8_86 : 1.005508}))) + {f_8_90 : 0.2640812})
    pf_40_14 = ((pf_35_32 * (pf_40_12 * (0.f - f_8_86))) + f_8_90);
	// -0.4095059  <=>  ({pf_37_26 : -0.3507425} * (1.0f / ((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {f_7_99 : 0.5913184}) + (({pf_6_14 : 0.2275276} * (0.f - {pf_39_10 : 0.1045283})) + {pf_28_45 : 0.3760952}))))
    pf_37_27 = (pf_37_26 * (1.0f / (((pf_7_8 * f_20_18) * f_7_99) + ((pf_6_14 * (0.f - pf_39_10)) + pf_28_45))));
	// -0.0895817  <=>  (({pf_36_38 : -0.5124788} * (0.f * (0.f - {f_8_86 : 1.005508}))) + (0.f - {pf_38_16 : 0.0895817}))
    pf_38_17 = ((pf_36_38 * (0.f * (0.f - f_8_86))) + (0.f - pf_38_16));
	// 0.8779377  <=>  (0.f - ({pf_23_23 : -0.8335257} * {f_3_88 : 1.053282}))
    f_7_102 = (0.f - (pf_23_23 * f_3_88));
	// 0.199755  <=>  ({pf_6_14 : 0.2275276} * {f_7_102 : 0.8779377})
    pf_39_12 = (pf_6_14 * f_7_102);
	// 0.4259384  <=>  (0.f - ({pf_30_24 : -0.4043915} * {f_3_88 : 1.053282}))
    f_7_103 = (0.f - (pf_30_24 * f_3_88));
	// -0.186421  <=>  (0.f - (({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {f_8_89 : 0.2186363}))
    f_8_91 = (0.f - ((pf_7_8 * f_20_18) * f_8_89));
	// 2147483648  <=>  {ftou2((0.f * (0.f - {f_8_86 : 1.005508}))) : 2147483648}
    u_10_55 = ftou2((0.f * (0.f - f_8_86)));
    u_10_phi_219 = u_10_55;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 0  <=>  0u
        u_10_56 = 0u;
        u_10_phi_219 = u_10_56;
    }
	// -0.245086  <=>  ((({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {pf_37_27 : -0.4095059}) + (0.f + {pf_31_31 : -0.4376903}))
    pf_31_33 = (((pf_3_19 * f_20_18) * pf_37_27) + (0.f + pf_31_31));
	// 0.2186363  <=>  (0.f - ({pf_22_44 : -0.2075762} * {f_3_88 : 1.053282}))
    f_7_104 = (0.f - (pf_22_44 * f_3_88));
	// -0.302587  <=>  ((({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {f_7_104 : 0.2186363}) + (0.f - {pf_39_12 : 0.199755}))
    pf_39_13 = (((pf_3_19 * f_20_18) * f_7_104) + (0.f - pf_39_12));
	// 2147483648  <=>  {u_21_phi_207 : 2147483648}
    u_1_55 = u_21_phi_207;
    u_1_phi_220 = u_1_55;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
        u_1_56 = ftou2((pf_9_10 * 6.2831855f));
        u_1_phi_220 = u_1_56;
    }
	// 0.908441  <=>  (({pf_42_17 : 0.9489095} * {pf_42_17 : 0.9489095}) + ((({pf_6_14 : 0.2275276} * {f_7_103 : 0.4259384}) + {f_8_91 : -0.186421}) * (({pf_6_14 : 0.2275276} * {f_7_103 : 0.4259384}) + {f_8_91 : -0.186421})))
    pf_45_10 = ((pf_42_17 * pf_42_17) + (((pf_6_14 * f_7_103) + f_8_91) * ((pf_6_14 * f_7_103) + f_8_91)));
	// 1.00  <=>  inversesqrt((({pf_38_17 : -0.0895817} * {pf_38_17 : -0.0895817}) + (({pf_40_14 : 0.994522} * {pf_40_14 : 0.994522}) + ({pf_41_14 : 0.0538636} * {pf_41_14 : 0.0538636}))))
    f_7_107 = inversesqrt(((pf_38_17 * pf_38_17) + ((pf_40_14 * pf_40_14) + (pf_41_14 * pf_41_14))));
	// 3183704036  <=>  {ftou2(pf_32_37) : 3183704036}
    u_13_21 = ftou2(pf_32_37);
    u_13_phi_221 = u_13_21;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 2147483648  <=>  {u_1_phi_220 : 2147483648}
        u_13_22 = u_1_phi_220;
        u_13_phi_221 = u_13_22;
    }
	// 1062954224  <=>  {u_8_38 : 1062954224}
    u_1_57 = u_8_38;
    u_1_phi_222 = u_1_57;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 3183684596  <=>  {ftou2(sin({utof2(u_13_phi_221) : -0.0954435})) : 3183684596}
        u_1_58 = ftou2(sin( utof2(u_13_phi_221)));
        u_1_phi_222 = u_1_58;
    }
	// 1.00  <=>  inversesqrt((({pf_39_13 : -0.302587} * {pf_39_13 : -0.302587}) + {pf_45_10 : 0.908441}))
    f_8_98 = inversesqrt(((pf_39_13 * pf_39_13) + pf_45_10));
	// 1029480469  <=>  {ftou2(({pf_41_14 : 0.0538636} * {f_7_107 : 1.00})) : 1029480469}
    u_5_26 = ftou2((pf_41_14 * f_7_107));
    u_5_phi_223 = u_5_26;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 1065276858  <=>  {ftou2(cos({utof2(u_13_phi_221) : -0.0954435})) : 1065276858}
        u_5_27 = ftou2(cos( utof2(u_13_phi_221)));
        u_5_phi_223 = u_5_27;
    }
	// 3182917275  <=>  {ftou2(({pf_38_17 : -0.0895817} * {f_7_107 : 1.00})) : 3182917275}
    u_8_40 = ftou2((pf_38_17 * f_7_107));
	// 1.003206  <=>  (((((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {pf_37_27 : -0.4095059}) + {pf_32_37 : -0.0954435}) * {utof2(u_5_phi_207) : -0.8040398}) + (({pf_31_33 : -0.245086} * {utof2(u_19_phi_207) : -0.5945755}) + ((({pf_6_14 : 0.2275276} * {pf_37_27 : -0.4095059}) + {pf_27_55 : -0.5470995}) * {utof2(u_21_phi_207) : -0.00}))) + 0.5f)
    pf_31_38 = ((((((pf_7_8 * f_20_18) * pf_37_27) + pf_32_37) * utof2(u_5_phi_207)) + ((pf_31_33 * utof2(u_19_phi_207)) + (((pf_6_14 * pf_37_27) + pf_27_55) * utof2(u_21_phi_207)))) + 0.5f);
	// 1.00  <=>  clamp({pf_31_38 : 1.003206}, 0.0, 1.0)
    f_7_108 = clamp(pf_31_38, 0.0, 1.0);
	// -0.1438001  <=>  (((((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {pf_37_27 : -0.4095059}) + {pf_32_37 : -0.0954435}) * {utof2(u_16_phi_207) : 0.06215}) + (({pf_31_33 : -0.245086} * {utof2(u_17_phi_207) : -0.0840449}) + ((({pf_6_14 : 0.2275276} * {pf_37_27 : -0.4095059}) + {pf_27_55 : -0.5470995}) * {utof2(u_20_phi_207) : 0.9945219}))) + 0.5f)
    pf_27_60 = ((((((pf_7_8 * f_20_18) * pf_37_27) + pf_32_37) * utof2(u_16_phi_207)) + ((pf_31_33 * utof2(u_17_phi_207)) + (((pf_6_14 * pf_37_27) + pf_27_55) * utof2(u_20_phi_207)))) + 0.5f);
	// 0.00  <=>  clamp({pf_27_60 : -0.1438001}, 0.0, 1.0)
    f_9_92 = clamp(pf_27_60, 0.0, 1.0);
	// 1065261310  <=>  {ftou2(({pf_40_14 : 0.994522} * {f_7_107 : 1.00})) : 1065261310}
    u_13_23 = ftou2((pf_40_14 * f_7_107));
    u_13_phi_224 = u_13_23;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 0  <=>  0u
        u_13_24 = 0u;
        u_13_phi_224 = u_13_24;
    }
	// 3182917275  <=>  {u_8_40 : 3182917275}
    u_4_31 = u_8_40;
    u_4_phi_225 = u_4_31;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 3210437872  <=>  {ftou2(((0.f - {utof2(u_1_phi_222) : 0.8570089}) + (0.f - 0.f))) : 3210437872}
        u_4_32 = ftou2(((0.f - utof2(u_1_phi_222)) + (0.f - 0.f)));
        u_4_phi_225 = u_4_32;
    }
	// 0.9489096  <=>  ({pf_42_17 : 0.9489095} * {f_8_98 : 1.00})
    pf_31_39 = (pf_42_17 * f_8_98);
	// 1057221327  <=>  {ftou2(({pf_41_12 : -0.5124788} * (0.f - {f_8_86 : 1.005508}))) : 1057221327}
    u_8_41 = ftou2((pf_41_12 * (0.f - f_8_86)));
    u_8_phi_226 = u_8_41;
	// False  <=>  if((({u_16_39 : 7} == 0u) ? true : false))
    if (((u_16_39 == 0u) ? true : false))
    {
		// 1029480469  <=>  {u_5_phi_223 : 1029480469}
        u_8_42 = u_5_phi_223;
        u_8_phi_226 = u_8_42;
    }
	// 3182917275  <=>  {u_4_phi_225 : 3182917275}
    u_2_36 = u_4_phi_225;
	// 1057221327  <=>  {u_8_phi_226 : 1057221327}
    u_14_66 = u_8_phi_226;
	// 1029480469  <=>  {u_5_phi_223 : 1029480469}
    u_16_43 = u_5_phi_223;
	// 1062954224  <=>  {u_1_phi_222 : 1062954224}
    u_17_26 = u_1_phi_222;
	// 1065261310  <=>  {u_13_phi_224 : 1065261310}
    u_19_20 = u_13_phi_224;
	// 2147483648  <=>  {u_10_phi_219 : 2147483648}
    u_20_22 = u_10_phi_219;
    u_2_phi_227 = u_2_36;
    u_14_phi_227 = u_14_66;
    u_16_phi_227 = u_16_43;
    u_17_phi_227 = u_17_26;
    u_19_phi_227 = u_19_20;
    u_20_phi_227 = u_20_22;
	// True  <=>  if(((! ({u_16_39 : 7} == 0u)) ? true : false))
    if (((!(u_16_39 == 0u)) ? true : false))
    {
		// 1066203317  <=>  {ftou2(pf_9_10) : 1066203317}
        u_21_16 = ftou2(pf_9_10);
        u_21_phi_228 = u_21_16;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1088253955  <=>  {ftou2(({pf_9_10 : 1.10134} * 6.2831855f)) : 1088253955}
            u_21_17 = ftou2((pf_9_10 * 6.2831855f));
            u_21_phi_228 = u_21_17;
        }
		// 2147483648  <=>  {u_10_phi_219 : 2147483648}
        u_3_11 = u_10_phi_219;
        u_3_phi_229 = u_3_11;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 0  <=>  0u
            u_3_12 = 0u;
            u_3_phi_229 = u_3_12;
        }
		// 1065261310  <=>  {u_13_phi_224 : 1065261310}
        u_22_17 = u_13_phi_224;
        u_22_phi_230 = u_22_17;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 0  <=>  0u
            u_22_18 = 0u;
            u_22_phi_230 = u_22_18;
        }
		// 1066203317  <=>  {u_21_phi_228 : 1066203317}
        u_23_16 = u_21_phi_228;
        u_23_phi_231 = u_23_16;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1066203317  <=>  {u_21_phi_228 : 1066203317}
            u_23_17 = u_21_phi_228;
            u_23_phi_231 = u_23_17;
        }
		// 1057221327  <=>  {u_8_phi_226 : 1057221327}
        u_21_18 = u_8_phi_226;
        u_21_phi_232 = u_21_18;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1055367469  <=>  {ftou2(cos({utof2(u_23_phi_231) : 1.10134})) : 1055367469}
            u_21_19 = ftou2(cos( utof2(u_23_phi_231)));
            u_21_phi_232 = u_21_19;
        }
		// 1062954224  <=>  {u_1_phi_222 : 1062954224}
        u_24_19 = u_1_phi_222;
        u_24_phi_233 = u_24_19;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1063538162  <=>  {ftou2(sin({utof2(u_23_phi_231) : 1.10134})) : 1063538162}
            u_24_20 = ftou2(sin( utof2(u_23_phi_231)));
            u_24_phi_233 = u_24_20;
        }
		// 1029480469  <=>  {u_5_phi_223 : 1029480469}
        u_23_19 = u_5_phi_223;
        u_23_phi_234 = u_23_19;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 3204704975  <=>  {ftou2(((0.f - {utof2(u_21_phi_232) : 0.5153016}) + (0.f - 0.f))) : 3204704975}
            u_23_20 = ftou2(((0.f - utof2(u_21_phi_232)) + (0.f - 0.f)));
            u_23_phi_234 = u_23_20;
        }
		// 3182917275  <=>  {u_4_phi_225 : 3182917275}
        u_25_23 = u_4_phi_225;
        u_25_phi_235 = u_25_23;
		// False  <=>  if((({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u)) ? true : false))
        if (((u_16_39 == (u_1_20 + 4294967295u)) ? true : false))
        {
			// 1062954224  <=>  {u_24_phi_233 : 1062954224}
            u_25_24 = u_24_phi_233;
            u_25_phi_235 = u_25_24;
        }
		// 3182917275  <=>  {u_25_phi_235 : 3182917275}
        u_26_22 = u_25_phi_235;
		// 1065261310  <=>  {u_22_phi_230 : 1065261310}
        u_27_23 = u_22_phi_230;
		// 1062954224  <=>  {u_24_phi_233 : 1062954224}
        u_28_24 = u_24_phi_233;
		// 1057221327  <=>  {u_21_phi_232 : 1057221327}
        u_29_19 = u_21_phi_232;
		// 2147483648  <=>  {u_3_phi_229 : 2147483648}
        u_30_19 = u_3_phi_229;
		// 1029480469  <=>  {u_23_phi_234 : 1029480469}
        u_31_15 = u_23_phi_234;
        u_26_phi_236 = u_26_22;
        u_27_phi_236 = u_27_23;
        u_28_phi_236 = u_28_24;
        u_29_phi_236 = u_29_19;
        u_30_phi_236 = u_30_19;
        u_31_phi_236 = u_31_15;
		// True  <=>  if(((! ({u_16_39 : 7} == ({u_1_20 : 16} + 4294967295u))) ? true : false))
        if (((!(u_16_39 == (u_1_20 + 4294967295u))) ? true : false))
        {
			// False  <=>  (((((0.f - {pf_33_29 : 0.4666667}) + 1.f) < float(1e-05)) && (! isnan(((0.f - {pf_33_29 : 0.4666667}) + 1.f)))) && (! isnan(float(1e-05))))
            b_1_78 = (((((0.f - pf_33_29) + 1.f) < float(1e-05)) && (!isnan(((0.f - pf_33_29) + 1.f)))) && (!isnan(float(1e-05))));
			// False  <=>  (((({pf_33_29 : 0.4666667} < float(1e-05)) && (! isnan({pf_33_29 : 0.4666667}))) && (! isnan(float(1e-05)))) ? true : false)
            b_2_91 = ((((pf_33_29 < float(1e-05)) && (!isnan(pf_33_29))) && (!isnan(float(1e-05)))) ? true : false);
			// 3182917275  <=>  {u_25_phi_235 : 3182917275}
            u_32_15 = u_25_phi_235;
			// 1065261310  <=>  {u_22_phi_230 : 1065261310}
            u_33_14 = u_22_phi_230;
			// 1062954224  <=>  {u_24_phi_233 : 1062954224}
            u_34_14 = u_24_phi_233;
			// 1057221327  <=>  {u_21_phi_232 : 1057221327}
            u_35_14 = u_21_phi_232;
			// 2147483648  <=>  {u_3_phi_229 : 2147483648}
            u_36_14 = u_3_phi_229;
			// 1029480469  <=>  {u_23_phi_234 : 1029480469}
            u_37_14 = u_23_phi_234;
            u_32_phi_237 = u_32_15;
            u_33_phi_237 = u_33_14;
            u_34_phi_237 = u_34_14;
            u_35_phi_237 = u_35_14;
            u_36_phi_237 = u_36_14;
            u_37_phi_237 = u_37_14;
			// False  <=>  if({b_2_91 : False})
            if (b_2_91)
            {
				// 0.5153019  <=>  cos((({pf_15_12 : 0.3361601} * 6.2831855f) + 3.1415927f))
                f_8_106 = cos(((pf_15_12 * 6.2831855f) + 3.1415927f));
				// -0.8570087  <=>  sin((({pf_15_12 : 0.3361601} * 6.2831855f) + 3.1415927f))
                f_13_29 = sin(((pf_15_12 * 6.2831855f) + 3.1415927f));
				// 1.00  <=>  inversesqrt((({f_13_29 : -0.8570087} * {f_13_29 : -0.8570087}) + (({f_8_106 : 0.5153019} * {f_8_106 : 0.5153019}) + 0.f)))
                f_14_9 = inversesqrt(((f_13_29 * f_13_29) + ((f_8_106 * f_8_106) + 0.f)));
				// 0.0895817  <=>  (0.f - (({pf_29_53 : 0.1045283} * inversesqrt({pf_34_35 : 1.00})) * ({f_13_29 : -0.8570087} * {f_14_9 : 1.00})))
                f_8_107 = (0.f - ((pf_29_53 * inversesqrt(pf_34_35)) * (f_13_29 * f_14_9)));
				// 0.0895817  <=>  (({pf_35_32 : 0.8523141} * (0.f * {f_14_9 : 1.00})) + {f_8_107 : 0.0895817})
                pf_37_32 = ((pf_35_32 * (0.f * f_14_9)) + f_8_107);
				// -0.4391991  <=>  (0.f - ({pf_35_32 : 0.8523141} * ({f_8_106 : 0.5153019} * {f_14_9 : 1.00})))
                f_8_108 = (0.f - (pf_35_32 * (f_8_106 * f_14_9)));
				// -0.0000004  <=>  (({pf_36_38 : -0.5124788} * ({f_13_29 : -0.8570087} * {f_14_9 : 1.00})) + {f_8_108 : -0.4391991})
                pf_9_18 = ((pf_36_38 * (f_13_29 * f_14_9)) + f_8_108);
				// 0.0538636  <=>  ((({pf_29_53 : 0.1045283} * inversesqrt({pf_34_35 : 1.00})) * ({f_8_106 : 0.5153019} * {f_14_9 : 1.00})) + (0.f - ({pf_36_38 : -0.5124788} * (0.f * {f_14_9 : 1.00}))))
                pf_15_14 = (((pf_29_53 * inversesqrt(pf_34_35)) * (f_8_106 * f_14_9)) + (0.f - (pf_36_38 * (0.f * f_14_9))));
				// 0.0080249  <=>  (({pf_9_18 : -0.0000004} * {pf_9_18 : -0.0000004}) + ({pf_37_32 : 0.0895817} * {pf_37_32 : 0.0895817}))
                pf_33_32 = ((pf_9_18 * pf_9_18) + (pf_37_32 * pf_37_32));
				// 0.0109262  <=>  (({pf_15_14 : 0.0538636} * {pf_15_14 : 0.0538636}) + {pf_33_32 : 0.0080249})
                pf_33_33 = ((pf_15_14 * pf_15_14) + pf_33_32);
				// -0.0000034  <=>  ({pf_9_18 : -0.0000004} * inversesqrt({pf_33_33 : 0.0109262}))
                pf_9_19 = (pf_9_18 * inversesqrt(pf_33_33));
				// 0.5153019  <=>  ({pf_15_14 : 0.0538636} * inversesqrt({pf_33_33 : 0.0109262}))
                pf_9_21 = (pf_15_14 * inversesqrt(pf_33_33));
				// 3210437868  <=>  {ftou2(({f_13_29 : -0.8570087} * {f_14_9 : 1.00})) : 3210437868}
                u_32_16 = ftou2((f_13_29 * f_14_9));
				// 0  <=>  {ftou2((0.f * {f_14_9 : 1.00})) : 0}
                u_33_15 = ftou2((0.f * f_14_9));
				// 1062954219  <=>  {ftou2(({pf_37_32 : 0.0895817} * inversesqrt({pf_33_33 : 0.0109262}))) : 1062954219}
                u_34_15 = ftou2((pf_37_32 * inversesqrt(pf_33_33)));
				// 1057221332  <=>  {ftou2(pf_9_21) : 1057221332}
                u_35_15 = ftou2(pf_9_21);
				// 3060153332  <=>  {ftou2(pf_9_19) : 3060153332}
                u_36_15 = ftou2(pf_9_19);
				// 1057221332  <=>  {ftou2(({f_8_106 : 0.5153019} * {f_14_9 : 1.00})) : 1057221332}
                u_37_15 = ftou2((f_8_106 * f_14_9));
                u_32_phi_237 = u_32_16;
                u_33_phi_237 = u_33_15;
                u_34_phi_237 = u_34_15;
                u_35_phi_237 = u_35_15;
                u_36_phi_237 = u_36_15;
                u_37_phi_237 = u_37_15;
            }
			// 3182917275  <=>  {u_32_phi_237 : 3182917275}
            u_38_15 = u_32_phi_237;
			// 1065261310  <=>  {u_33_phi_237 : 1065261310}
            u_39_16 = u_33_phi_237;
			// 1062954224  <=>  {u_34_phi_237 : 1062954224}
            u_40_17 = u_34_phi_237;
			// 1057221327  <=>  {u_35_phi_237 : 1057221327}
            u_41_17 = u_35_phi_237;
			// 2147483648  <=>  {u_36_phi_237 : 2147483648}
            u_42_19 = u_36_phi_237;
			// 1029480469  <=>  {u_37_phi_237 : 1029480469}
            u_43_21 = u_37_phi_237;
            u_38_phi_238 = u_38_15;
            u_39_phi_238 = u_39_16;
            u_40_phi_238 = u_40_17;
            u_41_phi_238 = u_41_17;
            u_42_phi_238 = u_42_19;
            u_43_phi_238 = u_43_21;
			// False  <=>  if(({b_1_78 : False} ? true : false))
            if ((b_1_78 ? true : false))
            {
				// 1.00  <=>  inversesqrt((({f_11_65 : 0.8570089} * {f_11_65 : 0.8570089}) + (({f_10_102 : -0.5153016} * {f_10_102 : -0.5153016}) + 0.f)))
                f_8_111 = inversesqrt(((f_11_65 * f_11_65) + ((f_10_102 * f_10_102) + 0.f)));
				// -0.0895817  <=>  (0.f - (({pf_29_53 : 0.1045283} * inversesqrt({pf_34_35 : 1.00})) * ({f_11_65 : 0.8570089} * {f_8_111 : 1.00})))
                f_8_112 = (0.f - ((pf_29_53 * inversesqrt(pf_34_35)) * (f_11_65 * f_8_111)));
				// -0.0895817  <=>  (({pf_35_32 : 0.8523141} * (0.f * {f_8_111 : 1.00})) + {f_8_112 : -0.0895817})
                pf_35_33 = ((pf_35_32 * (0.f * f_8_111)) + f_8_112);
				// 0.4391989  <=>  (0.f - ({pf_35_32 : 0.8523141} * ({f_10_102 : -0.5153016} * {f_8_111 : 1.00})))
                f_8_113 = (0.f - (pf_35_32 * (f_10_102 * f_8_111)));
				// -0.00  <=>  (({pf_36_38 : -0.5124788} * ({f_11_65 : 0.8570089} * {f_8_111 : 1.00})) + {f_8_113 : 0.4391989})
                pf_9_25 = ((pf_36_38 * (f_11_65 * f_8_111)) + f_8_113);
				// -0.0538636  <=>  ((({pf_29_53 : 0.1045283} * inversesqrt({pf_34_35 : 1.00})) * ({f_10_102 : -0.5153016} * {f_8_111 : 1.00})) + (0.f - ({pf_36_38 : -0.5124788} * (0.f * {f_8_111 : 1.00}))))
                pf_15_16 = (((pf_29_53 * inversesqrt(pf_34_35)) * (f_10_102 * f_8_111)) + (0.f - (pf_36_38 * (0.f * f_8_111))));
				// 0.0080249  <=>  (({pf_9_25 : -0.00} * {pf_9_25 : -0.00}) + ({pf_35_33 : -0.0895817} * {pf_35_33 : -0.0895817}))
                pf_33_36 = ((pf_9_25 * pf_9_25) + (pf_35_33 * pf_35_33));
				// 0.0109262  <=>  (({pf_15_16 : -0.0538636} * {pf_15_16 : -0.0538636}) + {pf_33_36 : 0.0080249})
                pf_33_37 = ((pf_15_16 * pf_15_16) + pf_33_36);
				// -0.00  <=>  ({pf_9_25 : -0.00} * inversesqrt({pf_33_37 : 0.0109262}))
                pf_9_26 = (pf_9_25 * inversesqrt(pf_33_37));
				// -0.5153016  <=>  ({pf_15_16 : -0.0538636} * inversesqrt({pf_33_37 : 0.0109262}))
                pf_9_27 = (pf_15_16 * inversesqrt(pf_33_37));
				// 1062954223  <=>  {ftou2(({f_11_65 : 0.8570089} * {f_8_111 : 1.00})) : 1062954223}
                u_38_16 = ftou2((f_11_65 * f_8_111));
				// 0  <=>  {ftou2((0.f * {f_8_111 : 1.00})) : 0}
                u_39_17 = ftou2((0.f * f_8_111));
				// 3210437871  <=>  {ftou2(({pf_35_33 : -0.0895817} * inversesqrt({pf_33_37 : 0.0109262}))) : 3210437871}
                u_40_18 = ftou2((pf_35_33 * inversesqrt(pf_33_37)));
				// 3204704974  <=>  {ftou2(pf_9_27) : 3204704974}
                u_41_18 = ftou2(pf_9_27);
				// 2991398974  <=>  {ftou2(pf_9_26) : 2991398974}
                u_42_20 = ftou2(pf_9_26);
				// 3204704975  <=>  {ftou2(({f_10_102 : -0.5153016} * {f_8_111 : 1.00})) : 3204704975}
                u_43_22 = ftou2((f_10_102 * f_8_111));
                u_38_phi_238 = u_38_16;
                u_39_phi_238 = u_39_17;
                u_40_phi_238 = u_40_18;
                u_41_phi_238 = u_41_18;
                u_42_phi_238 = u_42_20;
                u_43_phi_238 = u_43_22;
            }
			// 3182917275  <=>  {u_38_phi_238 : 3182917275}
            u_26_23 = u_38_phi_238;
			// 1065261310  <=>  {u_39_phi_238 : 1065261310}
            u_27_24 = u_39_phi_238;
			// 1062954224  <=>  {u_40_phi_238 : 1062954224}
            u_28_25 = u_40_phi_238;
			// 1057221327  <=>  {u_41_phi_238 : 1057221327}
            u_29_20 = u_41_phi_238;
			// 2147483648  <=>  {u_42_phi_238 : 2147483648}
            u_30_20 = u_42_phi_238;
			// 1029480469  <=>  {u_43_phi_238 : 1029480469}
            u_31_16 = u_43_phi_238;
            u_26_phi_236 = u_26_23;
            u_27_phi_236 = u_27_24;
            u_28_phi_236 = u_28_25;
            u_29_phi_236 = u_29_20;
            u_30_phi_236 = u_30_20;
            u_31_phi_236 = u_31_16;
        }
		// 3182917275  <=>  {u_26_phi_236 : 3182917275}
        u_2_37 = u_26_phi_236;
		// 1057221327  <=>  {u_29_phi_236 : 1057221327}
        u_14_67 = u_29_phi_236;
		// 1029480469  <=>  {u_31_phi_236 : 1029480469}
        u_16_44 = u_31_phi_236;
		// 1062954224  <=>  {u_28_phi_236 : 1062954224}
        u_17_27 = u_28_phi_236;
		// 1065261310  <=>  {u_27_phi_236 : 1065261310}
        u_19_21 = u_27_phi_236;
		// 2147483648  <=>  {u_30_phi_236 : 2147483648}
        u_20_23 = u_30_phi_236;
        u_2_phi_227 = u_2_37;
        u_14_phi_227 = u_14_67;
        u_16_phi_227 = u_16_44;
        u_17_phi_227 = u_17_27;
        u_19_phi_227 = u_19_21;
        u_20_phi_227 = u_20_23;
    }
	// 533.5339  <=>  sqrt((({pf_14_16 : -454.9194} * {pf_14_16 : -454.9194}) + {pf_17_44 : 77706.74}))
    f_8_117 = sqrt(((pf_14_16 * pf_14_16) + pf_17_44));
	// 38.77517  <=>  ((((({f_6_39 : 0.00} * {utof(vs_cbuf9_147.y) : 1.00}) + {pf_8_9 : 1.007226}) * {uni_attr5.y : 106.6129}) * {utof(vs_cbuf10_3.z) : 0.9027278}) * 0.4f)
    pf_34_37 = (((((f_6_39 * utof(vs_cbuf9_147.y)) + pf_8_9) * uni_attr5.y) * utof(vs_cbuf10_3.z)) * 0.4f);
	// 99.80455  <=>  (((({f_6_40 : 0.00} * {utof(vs_cbuf9_147.z) : 1.00}) + {pf_9_8 : 1.037012}) * {uni_attr5.z : 106.6129}) * {utof(vs_cbuf10_3.w) : 0.9027278})
    pf_8_12 = ((((f_6_40 * utof(vs_cbuf9_147.z)) + pf_9_8) * uni_attr5.z) * utof(vs_cbuf10_3.w));
	// 0.50  <=>  ((0.5f * {utof(vs_cbuf9_16.z) : 0.00}) + {pf_10_11 : 0.50})
    pf_10_12 = ((0.5f * utof(vs_cbuf9_16.z)) + pf_10_11);
	// 232.7016  <=>  ((({pf_11_16 : 250.9389} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_11_16 : 250.9389})
    pf_11_17 = (((pf_11_16 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_11_16);
	// -112.5713  <=>  ((({pf_12_14 : -121.3937} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_12_14 : -121.3937})
    pf_12_15 = (((pf_12_14 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_12_14);
	// -421.8577  <=>  ((({pf_14_16 : -454.9194} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_14_16 : -454.9194})
    pf_14_17 = (((pf_14_16 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_14_16);
	// 66822.33  <=>  (({pf_12_15 : -112.5713} * {pf_12_15 : -112.5713}) + ({pf_11_17 : 232.7016} * {pf_11_17 : 232.7016}))
    pf_11_19 = ((pf_12_15 * pf_12_15) + (pf_11_17 * pf_11_17));
	// 520.0128  <=>  ((({pf_11_16 : 250.9389} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_0_9 : 538.25})
    pf_12_16 = (((pf_11_16 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_0_9);
	// 0.9273239  <=>  ({f_20_19 : 0.0018743} * sqrt((({pf_14_17 : -421.8577} * {pf_14_17 : -421.8577}) + {pf_11_19 : 66822.33})))
    pf_14_18 = (f_20_19 * sqrt(((pf_14_17 * pf_14_17) + pf_11_19)));
	// 105.1718  <=>  ((({pf_4_0 : 121.1511} * {pf_5_16 : 1.037012}) * {utof(vs_cbuf10_3.y) : 0.9027278}) * {pf_14_18 : 0.9273239})
    pf_4_3 = (((pf_4_0 * pf_5_16) * utof(vs_cbuf10_3.y)) * pf_14_18);
	// 89.89285  <=>  ((((({f_6_39 : 0.00} * {utof(vs_cbuf9_147.y) : 1.00}) + {pf_8_9 : 1.007226}) * {uni_attr5.y : 106.6129}) * {utof(vs_cbuf10_3.z) : 0.9027278}) * {pf_14_18 : 0.9273239})
    pf_5_19 = (((((f_6_39 * utof(vs_cbuf9_147.y)) + pf_8_9) * uni_attr5.y) * utof(vs_cbuf10_3.z)) * pf_14_18);
	// 57.26957  <=>  ({pf_4_3 : 105.1718} * ((0.5f * {utof(vs_cbuf9_16.x) : 0.00}) + {utof2(u_12_phi_133) : 0.5445337}))
    pf_4_4 = (pf_4_3 * ((0.5f * utof(vs_cbuf9_16.x)) + utof2(u_12_phi_133)));
	// 112.5713  <=>  ((0.f - ((({pf_12_14 : -121.3937} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_2_18 : 1550.75})) + {utof(camera_wpos.y) : 1672.144})
    pf_10_13 = ((0.f - (((pf_12_14 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_2_18)) + utof(camera_wpos.y));
	// 55.14078  <=>  (((({pf_8_12 : 99.80455} * {pf_14_18 : 0.9273239}) * {pf_10_12 : 0.50}) * {utof(vs_cbuf8_24.z) : -0.0931343}) + ((({pf_5_19 : 89.89285} * ((0.5f * {utof(vs_cbuf9_16.y) : 0.00}) + {utof2(u_11_phi_133) : 0.451091})) * {utof(vs_cbuf8_24.y) : 0.0627182}) + ({pf_4_4 : 57.26957} * {utof(vs_cbuf8_24.x) : 0.9936762})))
    pf_14_20 = ((((pf_8_12 * pf_14_18) * pf_10_12) * utof(vs_cbuf8_24.z)) + (((pf_5_19 * ((0.5f * utof(vs_cbuf9_16.y)) + utof2(u_11_phi_133))) * utof(vs_cbuf8_24.y)) + (pf_4_4 * utof(vs_cbuf8_24.x))));
	// 59.48253  <=>  (((({pf_8_12 : 99.80455} * {pf_14_18 : 0.9273239}) * {pf_10_12 : 0.50}) * {utof(vs_cbuf8_25.z) : 0.5585706}) + ((({pf_5_19 : 89.89285} * ((0.5f * {utof(vs_cbuf9_16.y) : 0.00}) + {utof2(u_11_phi_133) : 0.451091})) * {utof(vs_cbuf8_25.y) : 0.829457}) + ({pf_4_4 : 57.26957} * {utof(vs_cbuf8_25.x) : 0.00})))
    pf_33_42 = ((((pf_8_12 * pf_14_18) * pf_10_12) * utof(vs_cbuf8_25.z)) + (((pf_5_19 * ((0.5f * utof(vs_cbuf9_16.y)) + utof2(u_11_phi_133))) * utof(vs_cbuf8_25.y)) + (pf_4_4 * utof(vs_cbuf8_25.x))));
	// 22.06456  <=>  (((({pf_8_12 : 99.80455} * {pf_14_18 : 0.9273239}) * {pf_10_12 : 0.50}) * {utof(vs_cbuf8_26.z) : 0.8242117}) + ((({pf_5_19 : 89.89285} * ((0.5f * {utof(vs_cbuf9_16.y) : 0.00}) + {utof2(u_11_phi_133) : 0.451091})) * {utof(vs_cbuf8_26.y) : -0.5550383}) + ({pf_4_4 : 57.26957} * {utof(vs_cbuf8_26.x) : 0.1122834})))
    pf_4_7 = ((((pf_8_12 * pf_14_18) * pf_10_12) * utof(vs_cbuf8_26.z)) + (((pf_5_19 * ((0.5f * utof(vs_cbuf9_16.y)) + utof2(u_11_phi_133))) * utof(vs_cbuf8_26.y)) + (pf_4_4 * utof(vs_cbuf8_26.x))));
	// 593.3907  <=>  ({pf_0_9 : 538.25} + ({pf_14_20 : 55.14078} + {utof(vs_cbuf8_24.w) : 0.00}))
    pf_0_10 = (pf_0_9 + (pf_14_20 + utof(vs_cbuf8_24.w)));
	// 1610.233  <=>  ({pf_2_18 : 1550.75} + ({pf_33_42 : 59.48253} + {utof(vs_cbuf8_25.w) : 0.00}))
    pf_2_19 = (pf_2_18 + (pf_33_42 + utof(vs_cbuf8_25.w)));
	// 575.1535  <=>  ((({pf_11_16 : 250.9389} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_0_10 : 593.3907})
    pf_0_11 = (((pf_11_16 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_0_10);
	// 996.8763  <=>  ((({pf_14_16 : -454.9194} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + (({pf_1_8 : 0.00} + {utof(vs_cbuf10_6.w) : 941.75}) + ({pf_4_7 : 22.06456} + {utof(vs_cbuf8_26.w) : 0.00})))
    pf_4_10 = (((pf_14_16 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + ((pf_1_8 + utof(vs_cbuf10_6.w)) + (pf_4_7 + utof(vs_cbuf8_26.w))));
	// 974.8118  <=>  ((({pf_14_16 : -454.9194} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + ({pf_1_8 : 0.00} + {utof(vs_cbuf10_6.w) : 941.75}))
    pf_1_10 = (((pf_14_16 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + (pf_1_8 + utof(vs_cbuf10_6.w)));
	// 683.4491  <=>  (({pf_4_10 : 996.8763} * {utof(view_proj[0].z) : 0.1122834}) + ((((({pf_12_14 : -121.3937} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_2_19 : 1610.233}) * {utof(view_proj[0].y) : 0.00}) + ({pf_0_11 : 575.1535} * {utof(view_proj[0].x) : 0.9936762})))
    pf_8_18 = ((pf_4_10 * utof(view_proj[0].z)) + (((((pf_12_14 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_2_19) * utof(view_proj[0].y)) + (pf_0_11 * utof(view_proj[0].x))));
	// 825.7045  <=>  (({pf_4_10 : 996.8763} * {utof(view_proj[1].z) : -0.5550383}) + ((((({pf_12_14 : -121.3937} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_2_19 : 1610.233}) * {utof(view_proj[1].y) : 0.829457}) + ({pf_0_11 : 575.1535} * {utof(view_proj[1].x) : 0.0627182})))
    pf_9_31 = ((pf_4_10 * utof(view_proj[1].z)) + (((((pf_12_14 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_2_19) * utof(view_proj[1].y)) + (pf_0_11 * utof(view_proj[1].x))));
	// 241.132  <=>  ({pf_8_18 : 683.4491} + {utof(view_proj[0].w) : -442.3171})
    pf_8_19 = (pf_8_18 + utof(view_proj[0].w));
	// 1672.427  <=>  (({pf_4_10 : 996.8763} * {utof(view_proj[2].z) : 0.8242117}) + ((((({pf_12_14 : -121.3937} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_2_19 : 1610.233}) * {utof(view_proj[2].y) : 0.5585706}) + ({pf_0_11 : 575.1535} * {utof(view_proj[2].x) : -0.0931343})))
    pf_14_24 = ((pf_4_10 * utof(view_proj[2].z)) + (((((pf_12_14 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_2_19) * utof(view_proj[2].y)) + (pf_0_11 * utof(view_proj[2].x))));
	// 0.00  <=>  (({pf_4_10 : 996.8763} * {utof(view_proj[3].z) : 0.00}) + ((((({pf_12_14 : -121.3937} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_2_19 : 1610.233}) * {utof(view_proj[3].y) : 0.00}) + ({pf_0_11 : 575.1535} * {utof(view_proj[3].x) : 0.00})))
    pf_15_20 = ((pf_4_10 * utof(view_proj[3].z)) + (((((pf_12_14 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_2_19) * utof(view_proj[3].y)) + (pf_0_11 * utof(view_proj[3].x))));
	// -232.7016  <=>  ((0.f - {pf_12_16 : 520.0128}) + {utof(camera_wpos.x) : 287.3111})
    pf_17_47 = ((0.f - pf_12_16) + utof(camera_wpos.x));
	// 421.8577  <=>  ((0.f - {pf_1_10 : 974.8118}) + {utof(camera_wpos.z) : 1396.669})
    pf_37_34 = ((0.f - pf_1_10) + utof(camera_wpos.z));
	// 53.08875  <=>  ((0.f - ((({pf_12_14 : -121.3937} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_2_19 : 1610.233})) + {utof(vs_cbuf15_60.w) : 1672.144})
    pf_36_41 = ((0.f - (((pf_12_14 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_2_19)) + utof(vs_cbuf15_60.w));
	// 420.149  <=>  ((({pf_15_20 : 0.00} + {utof(view_proj[3].w) : 1.00}) * {utof(view_proj[5].w) : 0.00}) + ((({pf_14_24 : 1672.427} + {utof(view_proj[2].w) : -2058.403}) * {utof(view_proj[5].z) : 0.00}) + ((({pf_9_31 : 825.7045} + {utof(view_proj[1].w) : -629.7858}) * {utof(view_proj[5].y) : 2.144507}) + ({pf_8_19 : 241.132} * {utof(view_proj[5].x) : 0.00}))))
    pf_9_34 = (((pf_15_20 + utof(view_proj[3].w)) * utof(view_proj[5].w)) + (((pf_14_24 + utof(view_proj[2].w)) * utof(view_proj[5].z)) + (((pf_9_31 + utof(view_proj[1].w)) * utof(view_proj[5].y)) + (pf_8_19 * utof(view_proj[5].x)))));
	// 290.8739  <=>  ((({pf_15_20 : 0.00} + {utof(view_proj[3].w) : 1.00}) * {utof(view_proj[4].w) : 0.00}) + ((({pf_14_24 : 1672.427} + {utof(view_proj[2].w) : -2058.403}) * {utof(view_proj[4].z) : 0.00}) + ((({pf_9_31 : 825.7045} + {utof(view_proj[1].w) : -629.7858}) * {utof(view_proj[4].y) : 0.00}) + ({pf_8_19 : 241.132} * {utof(view_proj[4].x) : 1.206285}))))
    pf_34_44 = (((pf_15_20 + utof(view_proj[3].w)) * utof(view_proj[4].w)) + (((pf_14_24 + utof(view_proj[2].w)) * utof(view_proj[4].z)) + (((pf_9_31 + utof(view_proj[1].w)) * utof(view_proj[4].y)) + (pf_8_19 * utof(view_proj[4].x)))));
	// 244786.20  <=>  (({pf_37_34 : 421.8577} * {pf_37_34 : 421.8577}) + (({pf_10_13 : 112.5713} * {pf_10_13 : 112.5713}) + ({pf_17_47 : -232.7016} * {pf_17_47 : -232.7016})))
    pf_33_46 = ((pf_37_34 * pf_37_34) + ((pf_10_13 * pf_10_13) + (pf_17_47 * pf_17_47)));
	// 385.9761  <=>  ((({pf_15_20 : 0.00} + {utof(view_proj[3].w) : 1.00}) * {utof(view_proj[7].w) : 0.00}) + ((({pf_14_24 : 1672.427} + {utof(view_proj[2].w) : -2058.403}) * {utof(view_proj[7].z) : -1.00}) + ((({pf_9_31 : 825.7045} + {utof(view_proj[1].w) : -629.7858}) * {utof(view_proj[7].y) : 0.00}) + ({pf_8_19 : 241.132} * {utof(view_proj[7].x) : 0.00}))))
    pf_8_23 = (((pf_15_20 + utof(view_proj[3].w)) * utof(view_proj[7].w)) + (((pf_14_24 + utof(view_proj[2].w)) * utof(view_proj[7].z)) + (((pf_9_31 + utof(view_proj[1].w)) * utof(view_proj[7].y)) + (pf_8_19 * utof(view_proj[7].x)))));
	// 384.0069  <=>  ((({pf_15_20 : 0.00} + {utof(view_proj[3].w) : 1.00}) * {utof(view_proj[6].w) : -2.00008}) + ((({pf_14_24 : 1672.427} + {utof(view_proj[2].w) : -2058.403}) * {utof(view_proj[6].z) : -1.00008}) + ((({pf_9_31 : 825.7045} + {utof(view_proj[1].w) : -629.7858}) * {utof(view_proj[6].y) : 0.00}) + ({pf_8_19 : 241.132} * {utof(view_proj[6].x) : 0.00}))))
    pf_14_27 = (((pf_15_20 + utof(view_proj[3].w)) * utof(view_proj[6].w)) + (((pf_14_24 + utof(view_proj[2].w)) * utof(view_proj[6].z)) + (((pf_9_31 + utof(view_proj[1].w)) * utof(view_proj[6].y)) + (pf_8_19 * utof(view_proj[6].x)))));
	// -287.8424  <=>  ((0.f - {pf_0_11 : 575.1535}) + {utof(camera_wpos.x) : 287.3111})
    pf_15_22 = ((0.f - pf_0_11) + utof(camera_wpos.x));
	// 399.7931  <=>  ((0.f - {pf_4_10 : 996.8763}) + {utof(camera_wpos.z) : 1396.669})
    pf_35_37 = ((0.f - pf_4_10) + utof(camera_wpos.z));
	// 53.08875  <=>  ((0.f - ((({pf_12_14 : -121.3937} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_2_19 : 1610.233})) + {utof(camera_wpos.y) : 1672.144})
    pf_39_14 = ((0.f - (((pf_12_14 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_2_19)) + utof(camera_wpos.y));
	// 0.0025908  <=>  (1.0f / ({pf_8_23 : 385.9761} + ((0.f * {pf_14_27 : 384.0069}) + ((0.f * {pf_34_44 : 290.8739}) + (0.f * {pf_9_34 : 420.149})))))
    f_13_33 = (1.0f / (pf_8_23 + ((0.f * pf_14_27) + ((0.f * pf_34_44) + (0.f * pf_9_34)))));
	// 245506.20  <=>  (({pf_35_37 : 399.7931} * {pf_35_37 : 399.7931}) + (({pf_36_41 : 53.08875} * {pf_36_41 : 53.08875}) + ({pf_15_22 : -287.8424} * {pf_15_22 : -287.8424})))
    pf_42_19 = ((pf_35_37 * pf_35_37) + ((pf_36_41 * pf_36_41) + (pf_15_22 * pf_15_22)));
	// 245506.20  <=>  (({pf_35_37 : 399.7931} * {pf_35_37 : 399.7931}) + (({pf_39_14 : 53.08875} * {pf_39_14 : 53.08875}) + ({pf_15_22 : -287.8424} * {pf_15_22 : -287.8424})))
    pf_40_17 = ((pf_35_37 * pf_35_37) + ((pf_39_14 * pf_39_14) + (pf_15_22 * pf_15_22)));
	// 0.997449  <=>  ((({pf_8_23 : 385.9761} * 0.5f) + (({pf_14_27 : 384.0069} * 0.5f) + ((0.f * {pf_34_44 : 290.8739}) + (0.f * {pf_9_34 : 420.149})))) * {f_13_33 : 0.0025908})
    pf_40_18 = (((pf_8_23 * 0.5f) + ((pf_14_27 * 0.5f) + ((0.f * pf_34_44) + (0.f * pf_9_34)))) * f_13_33);
	// 0.2275276  <=>  ({pf_10_13 : 112.5713} * (1.0f / (sqrt({pf_33_46 : 244786.20}) + float(1e-05))))
    pf_42_20 = (pf_10_13 * (1.0f / (sqrt(pf_33_46) + float(1e-05))));
	// -0.2458242  <=>  (({pf_17_47 : -232.7016} * (1.0f / (sqrt({pf_33_46 : 244786.20}) + float(1e-05)))) * {utof(vs_cbuf15_28.x) : 0.5226594})
    pf_17_49 = ((pf_17_47 * (1.0f / (sqrt(pf_33_46) + float(1e-05)))) * utof(vs_cbuf15_28.x));
	// -0.3111362  <=>  ((({pf_42_20 : 0.2275276} * 0.5f) * {utof(vs_cbuf15_28.y) : -0.5741013}) + {pf_17_49 : -0.2458242})
    pf_17_50 = (((pf_42_20 * 0.5f) * utof(vs_cbuf15_28.y)) + pf_17_49);
	// -0.3651403  <=>  ((({pf_36_41 : 53.08875} * inversesqrt({pf_42_19 : 245506.20})) * {utof(vs_cbuf15_28.y) : -0.5741013}) + (({pf_15_22 : -287.8424} * inversesqrt({pf_42_19 : 245506.20})) * {utof(vs_cbuf15_28.x) : 0.5226594}))
    pf_43_18 = (((pf_36_41 * inversesqrt(pf_42_19)) * utof(vs_cbuf15_28.y)) + ((pf_15_22 * inversesqrt(pf_42_19)) * utof(vs_cbuf15_28.x)));
	// 385.9726  <=>  ((1.0f / (({pf_40_18 : 0.997449} * {utof(vs_cbuf8_30.w) : 24999.00}) + (0.f - {utof(vs_cbuf8_30.y) : 25000.00}))) * (0.f - {utof(vs_cbuf8_30.z) : 25000.00}))
    pf_46_8 = ((1.0f / ((pf_40_18 * utof(vs_cbuf8_30.w)) + (0.f - utof(vs_cbuf8_30.y)))) * (0.f - utof(vs_cbuf8_30.z)));
	// -0.8485343  <=>  ((({pf_37_34 : 421.8577} * (1.0f / (sqrt({pf_33_46 : 244786.20}) + float(1e-05)))) * {utof(vs_cbuf15_28.z) : -0.6302658}) + {pf_17_50 : -0.3111362})
    pf_17_51 = (((pf_37_34 * (1.0f / (sqrt(pf_33_46) + float(1e-05)))) * utof(vs_cbuf15_28.z)) + pf_17_50);
	// -0.3651403  <=>  ((({pf_39_14 : 53.08875} * inversesqrt({pf_40_17 : 245506.20})) * {utof(vs_cbuf15_28.y) : -0.5741013}) + (({pf_15_22 : -287.8424} * inversesqrt({pf_40_17 : 245506.20})) * {utof(vs_cbuf15_28.x) : 0.5226594}))
    pf_15_25 = (((pf_39_14 * inversesqrt(pf_40_17)) * utof(vs_cbuf15_28.y)) + ((pf_15_22 * inversesqrt(pf_40_17)) * utof(vs_cbuf15_28.x)));
	// -0.8736835  <=>  ((({pf_35_37 : 399.7931} * inversesqrt({pf_40_17 : 245506.20})) * {utof(vs_cbuf15_28.z) : -0.6302658}) + {pf_15_25 : -0.3651403})
    pf_15_26 = (((pf_35_37 * inversesqrt(pf_40_17)) * utof(vs_cbuf15_28.z)) + pf_15_25);
	// 0.0631582  <=>  ((((({pf_35_37 : 399.7931} * inversesqrt({pf_42_19 : 245506.20})) * {utof(vs_cbuf15_28.z) : -0.6302658}) + {pf_43_18 : -0.3651403}) * 0.5f) + 0.5f)
    pf_35_39 = (((((pf_35_37 * inversesqrt(pf_42_19)) * utof(vs_cbuf15_28.z)) + pf_43_18) * 0.5f) + 0.5f);
	// -0.013204  <=>  (0.f - clamp((({pf_46_8 : 385.9726} * {utof(vs_cbuf15_22.x) : 0.0000418}) + (0.f - {utof(vs_cbuf15_22.y) : 0.0029252})), 0.0, 1.0))
    f_13_46 = (0.f - clamp(((pf_46_8 * utof(vs_cbuf15_22.x)) + (0.f - utof(vs_cbuf15_22.y))), 0.0, 1.0));
	// 0.9673161  <=>  exp2((log2(({f_13_46 : -0.013204} + 1.f)) * {utof(vs_cbuf15_23.y) : 2.50}))
    f_17_5 = exp2((log2((f_13_46 + 1.f)) * utof(vs_cbuf15_23.y)));
	// -0.9613882  <=>  (0.f - sqrt(((0.f - (({pf_17_51 : -0.8485343} * 0.5f) + 0.5f)) + 1.f)))
    f_14_15 = (0.f - sqrt(((0.f - ((pf_17_51 * 0.5f) + 0.5f)) + 1.f)));
	// -1.495038  <=>  ((((({pf_17_51 : -0.8485343} * 0.5f) + 0.5f) * (((({pf_17_51 : -0.8485343} * 0.5f) + 0.5f) * (((({pf_17_51 : -0.8485343} * 0.5f) + 0.5f) * -0.0187293f) + 0.074260995f)) + -0.2121144f)) + 1.5707288f) * {f_14_15 : -0.9613882})
    pf_17_54 = (((((pf_17_51 * 0.5f) + 0.5f) * ((((pf_17_51 * 0.5f) + 0.5f) * ((((pf_17_51 * 0.5f) + 0.5f) * -0.0187293f) + 0.074260995f)) + -0.2121144f)) + 1.5707288f) * f_14_15);
	// -1.507633  <=>  ((({pf_35_39 : 0.0631582} * (({pf_35_39 : 0.0631582} * (({pf_35_39 : 0.0631582} * -0.0187293f) + 0.074260995f)) + -0.2121144f)) + 1.5707288f) * (0.f - sqrt(((0.f - {pf_35_39 : 0.0631582}) + 1.f))))
    pf_35_41 = (((pf_35_39 * ((pf_35_39 * ((pf_35_39 * -0.0187293f) + 0.074260995f)) + -0.2121144f)) + 1.5707288f) * (0.f - sqrt(((0.f - pf_35_39) + 1.f))));
	// float4(0.50,0.50,0.50,1.00)  <=>  textureLod({tex2 : tex2}, float2(0.5f, ((clamp(max(({pf_42_20 : 0.2275276} * 3.3333333f), 0.0), 0.5f, 1.0) * -0.1f) + 0.68f)), 0.0)
    f4_0_4 = textureLod(tex2, float2(0.5f, ((clamp(max((pf_42_20 * 3.3333333f), 0.0), 0.5f, 1.0) * -0.1f) + 0.68f)), 0.0);
	// float2(0.0482293,0.5568819)  <=>  float2((({pf_17_54 : -1.495038} * 0.63661975f) + 1.f), ((({pf_42_20 : 0.2275276} * 0.5f) * 0.5f) + 0.5f))
    f2_0_1 = float2(((pf_17_54 * 0.63661975f) + 1.f), (((pf_42_20 * 0.5f) * 0.5f) + 0.5f));
	// float4(0.50,0.50,0.50,1.00)  <=>  textureLod({tex2 : tex2}, {f2_0_1 : float2(0.0482293,0.5568819)}, 0.0)
    f4_0_5 = textureLod(tex2, f2_0_1, 0.0);
	// 0.50  <=>  {f4_0_5.x : 0.50}
    f_19_4 = f4_0_5.x;
	// -0.9679058  <=>  (0.f - sqrt(((0.f - (({pf_15_26 : -0.8736835} * 0.5f) + 0.5f)) + 1.f)))
    f_16_42 = (0.f - sqrt(((0.f - ((pf_15_26 * 0.5f) + 0.5f)) + 1.f)));
	// -1.507633  <=>  ((((({pf_15_26 : -0.8736835} * 0.5f) + 0.5f) * (((({pf_15_26 : -0.8736835} * 0.5f) + 0.5f) * (((({pf_15_26 : -0.8736835} * 0.5f) + 0.5f) * -0.0187293f) + 0.074260995f)) + -0.2121144f)) + 1.5707288f) * {f_16_42 : -0.9679058})
    pf_17_56 = (((((pf_15_26 * 0.5f) + 0.5f) * ((((pf_15_26 * 0.5f) + 0.5f) * ((((pf_15_26 * 0.5f) + 0.5f) * -0.0187293f) + 0.074260995f)) + -0.2121144f)) + 1.5707288f) * f_16_42);
	// float2(0.0402112,0.4464276)  <=>  float2((({pf_35_41 : -1.507633} * 0.63661975f) + 1.f), ((({pf_36_41 : 53.08875} * inversesqrt({pf_42_19 : 245506.20})) * -0.5f) + 0.5f))
    f2_0_2 = float2(((pf_35_41 * 0.63661975f) + 1.f), (((pf_36_41 * inversesqrt(pf_42_19)) * -0.5f) + 0.5f));
	// float4(0.50,0.50,0.50,1.00)  <=>  textureLod({tex2 : tex2}, {f2_0_2 : float2(0.0402112,0.4464276)}, 0.0)
    f4_0_6 = textureLod(tex2, f2_0_2, 0.0);
	// float4(0.50,0.50,0.50,1.00)  <=>  textureLod({tex1 : tex1}, float2((({pf_17_56 : -1.507633} * 0.63661975f) + 1.f), (({f_17_5 : 0.9673161} * 0.5f) + 0.5f)), 0.0)
    f4_0_7 = textureLod(tex1, float2(((pf_17_56 * 0.63661975f) + 1.f), ((f_17_5 * 0.5f) + 0.5f)), 0.0);
	// 89.89285  <=>  {pf_5_19 : 89.89285}
    o.fs_attr8.y = pf_5_19;
	// 0.5124788  <=>  (0.f - ({pf_24_70 : -0.5124788} * {f_9_84 : 1.00}))
    f_27_0 = (0.f - (pf_24_70 * f_9_84));
	// -0.2410359  <=>  (({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {f_27_0 : 0.5124788})
    pf_27_63 = ((pf_3_19 * f_20_18) * f_27_0);
	// -1.373683  <=>  (((({pf_35_37 : 399.7931} * inversesqrt({pf_42_19 : 245506.20})) * {utof(vs_cbuf15_28.z) : -0.6302658}) + {pf_43_18 : -0.3651403}) + (0.f - {utof(vs_cbuf15_60.y) : 0.50}))
    pf_31_40 = ((((pf_35_37 * inversesqrt(pf_42_19)) * utof(vs_cbuf15_28.z)) + pf_43_18) + (0.f - utof(vs_cbuf15_60.y)));
	// -0.0052412  <=>  ((sqrt({pf_33_46 : 244786.20}) * 0.001f) + (0.f - 0.5f))
    pf_35_43 = ((sqrt(pf_33_46) * 0.001f) + (0.f - 0.5f));
	// 0.0652834  <=>  (((({utof2(u_12_phi_133) : 0.5445337} * 2.f) * 0.5f) + 0.5f) * 0.0625f)
    o.fs_attr2.x = (((( utof2(u_12_phi_133) * 2.f) * 0.5f) + 0.5f) * 0.0625f);
	// 38.77517  <=>  min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})
    o.fs_attr13.x = min((f_8_117 * 0.5f), pf_34_37);
	// -0.4376903  <=>  ((({pf_45_3 : 1.044534} + -0.5f) * ({pf_23_23 : -0.8335257} * {f_3_88 : 1.053282})) + (({pf_44_5 : 0.048909} + -0.5f) * ((({pf_6_14 : 0.2275276} * {f_7_103 : 0.4259384}) + {f_8_91 : -0.186421}) * {f_8_98 : 1.00})))
    pf_17_59 = (((pf_45_3 + -0.5f) * (pf_23_23 * f_3_88)) + ((pf_44_5 + -0.5f) * (((pf_6_14 * f_7_103) + f_8_91) * f_8_98)));
	// -0.5470995  <=>  ((({pf_45_3 : 1.044534} + -0.5f) * ({pf_22_44 : -0.2075762} * {f_3_88 : 1.053282})) + (({pf_44_5 : 0.048909} + -0.5f) * {pf_31_39 : 0.9489096}))
    pf_5_21 = (((pf_45_3 + -0.5f) * (pf_22_44 * f_3_88)) + ((pf_44_5 + -0.5f) * pf_31_39));
	// 0.0030568  <=>  (((({utof2(u_11_phi_133) : 0.451091} * -2.f) * 0.5f) + 0.5f) * 0.0625f)
    o.fs_attr2.y = (((( utof2(u_11_phi_133) * -2.f) * 0.5f) + 0.5f) * 0.0625f);
	// 0.9050674  <=>  ({pf_21_37 : 6.905067} + (0.f - floor({pf_21_37 : 6.905067})))
    o.fs_attr18.x = (pf_21_37 + (0.f - floor(pf_21_37)));
	// 2.308798  <=>  ({pf_22_39 : 2.195791} * (({uni_attr6.x : 0.17155} * 0.3f) + 1.f))
    o.fs_attr2.z = (pf_22_39 * ((uni_attr6.x * 0.3f) + 1.f));
	// 2.338573  <=>  ({pf_23_16 : 2.309921} * (({uni_attr6.y : 0.40601} * 0.4f) + 0.85f))
    o.fs_attr2.w = (pf_23_16 * ((uni_attr6.y * 0.4f) + 0.85f));
	// -0.5470995  <=>  (0.f + {pf_5_21 : -0.5470995})
    pf_5_22 = (0.f + pf_5_21);
	// 0.4041748  <=>  {pf_13_27 : 0.4041748}
    o.fs_attr19.x = pf_13_27;
	// 0.224307  <=>  (({pf_24_70 : -0.5124788} * {f_9_84 : 1.00}) * (0.f + {pf_17_59 : -0.4376903}))
    pf_13_28 = ((pf_24_70 * f_9_84) * (0.f + pf_17_59));
	// 520.0128  <=>  {pf_12_16 : 520.0128}
    o.fs_attr9.x = pf_12_16;
	// -0.0954435  <=>  ((({pf_45_3 : 1.044534} + -0.5f) * ({pf_30_24 : -0.4043915} * {f_3_88 : 1.053282})) + (({pf_44_5 : 0.048909} + -0.5f) * ({pf_39_13 : -0.302587} * {f_8_98 : 1.00})))
    pf_12_17 = (((pf_45_3 + -0.5f) * (pf_30_24 * f_3_88)) + ((pf_44_5 + -0.5f) * (pf_39_13 * f_8_98)));
	// 974.8118  <=>  {pf_1_10 : 974.8118}
    o.fs_attr9.z = pf_1_10;
	// -0.8523141  <=>  (0.f - ({pf_28_47 : 0.8523141} * {f_9_84 : 1.00}))
    f_30_2 = (0.f - (pf_28_47 * f_9_84));
	// 575.1535  <=>  {pf_0_11 : 575.1535}
    o.fs_attr7.x = pf_0_11;
	// -0.0954435  <=>  (0.f + {pf_12_17 : -0.0954435})
    pf_1_12 = (0.f + pf_12_17);
	// 1619.055  <=>  ((({pf_12_14 : -121.3937} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_2_19 : 1610.233})
    o.fs_attr7.y = (((pf_12_14 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_2_19);
	// 996.8763  <=>  {pf_4_10 : 996.8763}
    o.fs_attr7.z = pf_4_10;
	// 420.149  <=>  {pf_9_34 : 420.149}
    o.vertex.y = pf_9_34;
	// 0.0857718  <=>  ((({pf_28_47 : 0.8523141} * {f_9_84 : 1.00}) * {pf_1_12 : -0.0954435}) + (({pf_29_53 : 0.1045283} * {pf_5_22 : -0.5470995}) + {pf_13_28 : 0.224307}))
    pf_0_13 = (((pf_28_47 * f_9_84) * pf_1_12) + ((pf_29_53 * pf_5_22) + pf_13_28));
	// 290.8739  <=>  {pf_34_44 : 290.8739}
    o.vertex.x = pf_34_44;
	// 384.0069  <=>  {pf_14_27 : 384.0069}
    o.vertex.z = pf_14_27;
	// -0.086503  <=>  ({pf_0_13 : 0.0857718} * (1.0f / ((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {f_30_2 : -0.8523141}) + (({pf_6_14 : 0.2275276} * (0.f - {pf_29_53 : 0.1045283})) + {pf_27_63 : -0.2410359}))))
    pf_0_14 = (pf_0_13 * (1.0f / (((pf_7_8 * f_20_18) * f_30_2) + ((pf_6_14 * (0.f - pf_29_53)) + pf_27_63))));
	// 385.9761  <=>  {pf_8_23 : 385.9761}
    o.vertex.w = pf_8_23;
	// -0.0177501  <=>  (0.f - clamp((({utof(vs_cbuf15_22.x) : 0.0000418} * sqrt({pf_33_46 : 244786.20})) + (0.f - {utof(vs_cbuf15_22.y) : 0.0029252})), 0.0, 1.0))
    f_28_4 = (0.f - clamp((( utof(vs_cbuf15_22.x) * sqrt(pf_33_46)) + (0.f - utof(vs_cbuf15_22.y))), 0.0, 1.0));
	// 384.9915  <=>  (({pf_8_23 : 385.9761} * 0.5f) + (({pf_14_27 : 384.0069} * 0.5f) + ((0.f * {pf_34_44 : 290.8739}) + (0.f * {pf_9_34 : 420.149}))))
    o.fs_attr3.z = ((pf_8_23 * 0.5f) + ((pf_14_27 * 0.5f) + ((0.f * pf_34_44) + (0.f * pf_9_34))));
	// 385.9761  <=>  ({pf_8_23 : 385.9761} + ((0.f * {pf_14_27 : 384.0069}) + ((0.f * {pf_34_44 : 290.8739}) + (0.f * {pf_9_34 : 420.149}))))
    o.fs_attr3.w = (pf_8_23 + ((0.f * pf_14_27) + ((0.f * pf_34_44) + (0.f * pf_9_34))));
	// -0.3970051  <=>  ((({pf_3_19 : -0.4703335} * {f_20_18 : 1.00}) * {pf_0_14 : -0.086503}) + (0.f + {pf_17_59 : -0.4376903}))
    pf_3_21 = (((pf_3_19 * f_20_18) * pf_0_14) + (0.f + pf_17_59));
	// 1559.572  <=>  ((({pf_12_14 : -121.3937} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_2_18 : 1550.75})
    o.fs_attr9.y = (((pf_12_14 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_2_18);
	// 0.00  <=>  ({f_2_65 : 0.0625} * ({f_1_86 : 1.00} + float(int({u_0_phi_154 : 4294967295}))))
    o.fs_attr20.x = (f_2_65 * (f_1_86 + float(int(u_0_phi_154))));
	// 0.5684116  <=>  exp2((log2(({f_13_46 : -0.013204} + 1.f)) * {utof(vs_cbuf15_23.x) : 42.50}))
    f_0_55 = exp2((log2((f_13_46 + 1.f)) * utof(vs_cbuf15_23.x)));
	// -11.25713  <=>  ((((({pf_12_14 : -121.3937} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_2_18 : 1550.75}) + (0.f - {utof(vs_cbuf15_60.w) : 1672.144})) * 0.1f)
    pf_3_23 = (((((pf_12_14 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_2_18) + (0.f - utof(vs_cbuf15_60.w))) * 0.1f);
	// 0.0725738  <=>  (((((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {pf_0_14 : -0.086503}) + {pf_1_12 : -0.0954435}) * {utof2(u_14_phi_227) : 0.5153016}) + (({pf_3_21 : -0.3970051} * {utof2(u_17_phi_227) : 0.8570089}) + ((({pf_6_14 : 0.2275276} * {pf_0_14 : -0.086503}) + {pf_5_22 : -0.5470995}) * {utof2(u_20_phi_227) : -0.00}))) + 0.5f)
    pf_2_25 = ((((((pf_7_8 * f_20_18) * pf_0_14) + pf_1_12) * utof2(u_14_phi_227)) + ((pf_3_21 * utof2(u_17_phi_227)) + (((pf_6_14 * pf_0_14) + pf_5_22) * utof2(u_20_phi_227)))) + 0.5f);
	// 0.0725738  <=>  clamp({pf_2_25 : 0.0725738}, 0.0, 1.0)
    f_9_93 = clamp(pf_2_25, 0.0, 1.0);
	// 0.375  <=>  ((1.0f / float(int({u_1_20 : 16}))) * ({f_0_54 : 6.00} + {f_4_52 : 0.00}))
    o.fs_attr20.y = ((1.0f / float(int(u_1_20))) * (f_0_54 + f_4_52));
	// -0.0699033  <=>  (((((({pf_7_8 : 0.8526533} * {f_20_18 : 1.00}) * {pf_0_14 : -0.086503}) + {pf_1_12 : -0.0954435}) * {utof2(u_2_phi_227) : -0.0895817}) + (({pf_3_21 : -0.3970051} * {utof2(u_16_phi_227) : 0.0538636}) + ((({pf_6_14 : 0.2275276} * {pf_0_14 : -0.086503}) + {pf_5_22 : -0.5470995}) * {utof2(u_19_phi_227) : 0.994522}))) + 0.5f)
    pf_0_17 = ((((((pf_7_8 * f_20_18) * pf_0_14) + pf_1_12) * utof2(u_2_phi_227)) + ((pf_3_21 * utof2(u_16_phi_227)) + (((pf_6_14 * pf_0_14) + pf_5_22) * utof2(u_19_phi_227)))) + 0.5f);
	// 0.00  <=>  clamp({pf_0_17 : -0.0699033}, 0.0, 1.0)
    f_13_51 = clamp(pf_0_17, 0.0, 1.0);
	// 0.00  <=>  ((clamp(({pf_31_40 : -1.373683} * {utof(vs_cbuf15_60.z) : 4.00}), 0.0, 1.0) * clamp({pf_35_43 : -0.0052412}, 0.0, 1.0)) * clamp({pf_3_23 : -11.25713}, 0.0, 1.0))
    pf_0_18 = ((clamp((pf_31_40 * utof(vs_cbuf15_60.z)), 0.0, 1.0) * clamp(pf_35_43, 0.0, 1.0)) * clamp(pf_3_23, 0.0, 1.0));
	// 1.00  <=>  clamp((({utof(vs_cbuf15_24.x) : 0.0033333} * sqrt({pf_33_46 : 244786.20})) + (0.f - {utof(vs_cbuf15_24.y) : 0.00})), 0.0, 1.0)
    f_4_64 = clamp((( utof(vs_cbuf15_24.x) * sqrt(pf_33_46)) + (0.f - utof(vs_cbuf15_24.y))), 0.0, 1.0);
	// 0.375  <=>  ((1.0f / float(int({u_1_20 : 16}))) * ({f_0_54 : 6.00} + {f_6_57 : 0.00}))
    o.fs_attr21.y = ((1.0f / float(int(u_1_20))) * (f_0_54 + f_6_57));
	// 0.4375  <=>  ((1.0f / float(int({u_1_20 : 16}))) * (float(int({u_16_39 : 7})) + {f_9_92 : 0.00}))
    o.fs_attr22.y = ((1.0f / float(int(u_1_20))) * (float(int(u_16_39)) + f_9_92));
	// 0.4375  <=>  ((1.0f / float(int({u_1_20 : 16}))) * (float(int({u_16_39 : 7})) + {f_13_51 : 0.00}))
    o.fs_attr23.y = ((1.0f / float(int(u_1_20))) * (float(int(u_16_39)) + f_13_51));
	// 0.00  <=>  clamp((({pf_15_26 : -0.8736835} + (0.f - {utof(vs_cbuf15_60.y) : 0.50})) * {utof(vs_cbuf15_60.z) : 4.00}), 0.0, 1.0)
    f_1_89 = clamp(((pf_15_26 + (0.f - utof(vs_cbuf15_60.y))) * utof(vs_cbuf15_60.z)), 0.0, 1.0);
	// -1505.241  <=>  (sqrt({pf_33_46 : 244786.20}) + (0.f - {utof(vs_cbuf15_54.w) : 2000.00}))
    pf_6_19 = (sqrt(pf_33_46) + (0.f - utof(vs_cbuf15_54.w)));
	// 0.3798058  <=>  ({f_2_65 : 0.0625} * ({f_3_98 : 0.0768924} + float(int({u_9_phi_161 : 6}))))
    o.fs_attr21.x = (f_2_65 * (f_3_98 + float(int(u_9_phi_161))));
	// 0.00  <=>  ({f_2_65 : 0.0625} * ({f_7_108 : 1.00} + float(int({u_15_phi_160 : 4294967295}))))
    o.fs_attr22.x = (f_2_65 * (f_7_108 + float(int(u_15_phi_160))));
	// 0.3795359  <=>  ({f_2_65 : 0.0625} * ({f_9_93 : 0.0725738} + float(int({u_18_phi_162 : 6}))))
    o.fs_attr23.x = (f_2_65 * (f_9_93 + float(int(u_18_phi_162))));
	// 0.00  <=>  ({f_1_89 : 0.00} * clamp((({f_0_55 : 0.5684116} * (0.f - {utof(vs_cbuf15_23.z) : 0.85})) + {utof(vs_cbuf15_23.z) : 0.85}), 0.0, 1.0))
    pf_2_30 = (f_1_89 * clamp(((f_0_55 * (0.f - utof(vs_cbuf15_23.z))) + utof(vs_cbuf15_23.z)), 0.0, 1.0));
	// 0.4671282  <=>  exp2((log2(({f_28_4 : -0.0177501} + 1.f)) * {utof(vs_cbuf15_23.x) : 42.50}))
    f_0_57 = exp2((log2((f_28_4 + 1.f)) * utof(vs_cbuf15_23.x)));
	// 0.00  <=>  ({pf_0_18 : 0.00} * {utof(vs_cbuf15_60.x) : 0.75})
    pf_0_19 = (pf_0_18 * utof(vs_cbuf15_60.x));
	// 0.00  <=>  exp2((log2(((0.f - {f_4_64 : 1.00}) + 1.f)) * {utof(vs_cbuf15_24.w) : 4.00}))
    f_3_101 = exp2((log2(((0.f - f_4_64) + 1.f)) * utof(vs_cbuf15_24.w)));
	// -17.08647  <=>  (({pf_8_23 : 385.9761} * 0.5f) + ((0.f * {pf_14_27 : 384.0069}) + ((0.f * {pf_34_44 : 290.8739}) + ({pf_9_34 : 420.149} * -0.5f))))
    o.fs_attr3.y = ((pf_8_23 * 0.5f) + ((0.f * pf_14_27) + ((0.f * pf_34_44) + (pf_9_34 * -0.5f))));
	// 0.00  <=>  (({pf_0_19 : 0.00} * (0.f - {utof(vs_cbuf15_1.x) : 0.00})) + {pf_0_19 : 0.00})
    o.fs_attr16.w = ((pf_0_19 * (0.f - utof(vs_cbuf15_1.x))) + pf_0_19);
	// 0.00  <=>  (clamp(({pf_42_20 : 0.2275276} * 2.f), 0.0, 1.0) * clamp(({pf_6_19 : -1505.241} * (1.0f / {utof(vs_cbuf15_57.z) : 3000.00})), 0.0, 1.0))
    pf_1_23 = (clamp((pf_42_20 * 2.f), 0.0, 1.0) * clamp((pf_6_19 * (1.0f / utof(vs_cbuf15_57.z))), 0.0, 1.0));
	// 0.12  <=>  (({f_3_101 : 0.00} * (0.f - {utof(vs_cbuf15_25.w) : 0.12})) + {utof(vs_cbuf15_25.w) : 0.12})
    o.fs_attr10.x = ((f_3_101 * (0.f - utof(vs_cbuf15_25.w))) + utof(vs_cbuf15_25.w));
	// 0.2098794  <=>  min(((sqrt({pf_33_46 : 244786.20}) + (0.f - {utof(vs_cbuf15_54.z) : 75.00})) * (1.0f / {utof(vs_cbuf15_54.w) : 2000.00})), {utof(vs_cbuf15_55.w) : 0.70})
    f_1_96 = min(((sqrt(pf_33_46) + (0.f - utof(vs_cbuf15_54.z))) * (1.0f / utof(vs_cbuf15_54.w))), utof(vs_cbuf15_55.w));
	// 0.00  <=>  ((({pf_2_30 : 0.00} * (0.f - {utof(vs_cbuf15_1.x) : 0.00})) + {pf_2_30 : 0.00}) * {utof(vs_cbuf15_61.x) : 1.00})
    o.fs_attr17.w = (((pf_2_30 * (0.f - utof(vs_cbuf15_1.x))) + pf_2_30) * utof(vs_cbuf15_61.x));
	// 0.2098794  <=>  max(0.f, {f_1_96 : 0.2098794})
    f_1_97 = max(0.f, f_1_96);
	// -1309.572  <=>  ((0.f - ((({pf_12_14 : -121.3937} * (0.f - {f_20_19 : 0.0018743})) * min(({f_8_117 : 533.5339} * 0.5f), {pf_34_37 : 38.77517})) + {pf_2_18 : 1550.75})) + min({utof(camera_wpos.y) : 1672.144}, {utof(vs_cbuf15_27.z) : 250.00}))
    pf_2_33 = ((0.f - (((pf_12_14 * (0.f - f_20_19)) * min((f_8_117 * 0.5f), pf_34_37)) + pf_2_18)) + min( utof(camera_wpos.y), utof(vs_cbuf15_27.z)));
	// 338.425  <=>  (({pf_8_23 : 385.9761} * 0.5f) + ((0.f * {pf_14_27 : 384.0069}) + (({pf_34_44 : 290.8739} * 0.5f) + (0.f * {pf_9_34 : 420.149}))))
    o.fs_attr3.x = ((pf_8_23 * 0.5f) + ((0.f * pf_14_27) + ((pf_34_44 * 0.5f) + (0.f * pf_9_34))));
	// 0.00  <=>  (clamp((({pf_2_33 : -1309.572} * {utof(vs_cbuf15_27.y) : 0.0045455}) + {utof(vs_cbuf15_27.x) : -0.0909091}), 0.0, 1.0) * {utof(vs_cbuf15_26.w) : 0.4519901})
    o.fs_attr10.y = (clamp(((pf_2_33 * utof(vs_cbuf15_27.y)) + utof(vs_cbuf15_27.x)), 0.0, 1.0) * utof(vs_cbuf15_26.w));
	// 603.271  <=>  (({pf_46_8 : 385.9726} + {utof(vs_cbuf15_28.y) : -0.5741013}) * (1.0f / clamp((({utof(vs_cbuf15_28.y) : -0.5741013} * 1.5f) + 1.5f), 0.0, 1.0)))
    pf_0_28 = ((pf_46_8 + utof(vs_cbuf15_28.y)) * (1.0f / clamp((( utof(vs_cbuf15_28.y) * 1.5f) + 1.5f), 0.0, 1.0)));
	// 1.00  <=>  {v.uv.w : 1.00}
    o.fs_attr6.w = v.uv.w;
	// 0.50  <=>  {f4_0_6.x : 0.50}
    o.fs_attr16.x = f4_0_6.x;
	// 0.50  <=>  {f4_0_6.y : 0.50}
    o.fs_attr16.y = f4_0_6.y;
	// 0.50  <=>  {f4_0_6.z : 0.50}
    o.fs_attr16.z = f4_0_6.z;
	// 1.00  <=>  max((({f4_0_4.z : 0.50} * 0.06f) + (({f4_0_4.x : 0.50} * 0.22f) + ({f4_0_4.y : 0.50} * 0.72f))), 1.f)
    f_2_88 = max(((f4_0_4.z * 0.06f) + ((f4_0_4.x * 0.22f) + (f4_0_4.y * 0.72f))), 1.f);
	// 1.00  <=>  abs({f_2_88 : 1.00})
    f_3_107 = abs(f_2_88);
	// 1.00  <=>  exp2((log2({f_3_107 : 1.00}) * 0.7f))
    f_3_109 = exp2((log2(f_3_107) * 0.7f));
	// 0.50  <=>  ({f4_0_4.y : 0.50} * (1.0f / {f_3_109 : 1.00}))
    pf_2_38 = (f4_0_4.y * (1.0f / f_3_109));
	// 0.50  <=>  ({f4_0_4.z : 0.50} * (1.0f / {f_3_109 : 1.00}))
    pf_5_30 = (f4_0_4.z * (1.0f / f_3_109));
	// 0.50  <=>  ({f4_0_4.x : 0.50} * (1.0f / {f_3_109 : 1.00}))
    pf_6_20 = (f4_0_4.x * (1.0f / f_3_109));
	// 0.095063  <=>  (clamp((({f_0_57 : 0.4671282} * (0.f - {utof(vs_cbuf15_23.z) : 0.85})) + {utof(vs_cbuf15_23.z) : 0.85}), 0.0, 1.0) * {f_1_97 : 0.2098794})
    pf_7_11 = (clamp(((f_0_57 * (0.f - utof(vs_cbuf15_23.z))) + utof(vs_cbuf15_23.z)), 0.0, 1.0) * f_1_97);
	// 0.50  <=>  max({pf_6_20 : 0.50}, max({pf_2_38 : 0.50}, {pf_5_30 : 0.50}))
    f_0_61 = max(pf_6_20, max(pf_2_38, pf_5_30));
	// 1.00  <=>  {utof(vs_cbuf10_3.x) : 1.00}
    o.fs_attr5.x = utof(vs_cbuf10_3.x);
	// -0.0507015  <=>  (0.f - (((clamp(max(({pf_42_20 : 0.2275276} * 3.3333333f), 0.0), 0.5f, 1.0) * (0.f - {f_1_97 : 0.2098794})) + {f_1_97 : 0.2098794}) * (1.0f / {f_2_88 : 1.00})))
    f_4_71 = (0.f - (((clamp(max((pf_42_20 * 3.3333333f), 0.0), 0.5f, 1.0) * (0.f - f_1_97)) + f_1_97) * (1.0f / f_2_88)));
	// -0.1457645  <=>  ((0.f - clamp(clamp(({pf_42_20 : 0.2275276} * 3.3333333f), 0.0, 1.0), 0.5f, {pf_7_11 : 0.095063})) + {f_4_71 : -0.0507015})
    pf_9_35 = ((0.f - clamp(clamp((pf_42_20 * 3.3333333f), 0.0, 1.0), 0.5f, pf_7_11)) + f_4_71);
	// 0.0809084  <=>  (((({f_19_4 : 0.50} + (0.f - {utof(vs_cbuf15_55.x) : 0.8511029})) * {pf_1_23 : 0.00}) + {utof(vs_cbuf15_55.x) : 0.8511029}) * clamp(clamp(({pf_42_20 : 0.2275276} * 3.3333333f), 0.0, 1.0), 0.5f, {pf_7_11 : 0.095063}))
    pf_3_33 = ((((f_19_4 + (0.f - utof(vs_cbuf15_55.x))) * pf_1_23) + utof(vs_cbuf15_55.x)) * clamp(clamp((pf_42_20 * 3.3333333f), 0.0, 1.0), 0.5f, pf_7_11));
	// 0.1008413  <=>  (((({f4_0_5.z : 0.50} + (0.f - {utof(vs_cbuf15_55.z) : 1.060784})) * {pf_1_23 : 0.00}) + {utof(vs_cbuf15_55.z) : 1.060784}) * clamp(clamp(({pf_42_20 : 0.2275276} * 3.3333333f), 0.0, 1.0), 0.5f, {pf_7_11 : 0.095063}))
    pf_1_25 = ((((f4_0_5.z + (0.f - utof(vs_cbuf15_55.z))) * pf_1_23) + utof(vs_cbuf15_55.z)) * clamp(clamp((pf_42_20 * 3.3333333f), 0.0, 1.0), 0.5f, pf_7_11));
	// 0.1062592  <=>  (({pf_6_20 : 0.50} * (((clamp(max(({pf_42_20 : 0.2275276} * 3.3333333f), 0.0), 0.5f, 1.0) * (0.f - {f_1_97 : 0.2098794})) + {f_1_97 : 0.2098794}) * (1.0f / {f_2_88 : 1.00}))) + {pf_3_33 : 0.0809084})
    pf_3_34 = ((pf_6_20 * (((clamp(max((pf_42_20 * 3.3333333f), 0.0), 0.5f, 1.0) * (0.f - f_1_97)) + f_1_97) * (1.0f / f_2_88))) + pf_3_33);
	// 0.8542355  <=>  ({pf_9_35 : -0.1457645} + 1.f)
    o.fs_attr14.w = (pf_9_35 + 1.f);
	// 0.1261921  <=>  (({pf_5_30 : 0.50} * (((clamp(max(({pf_42_20 : 0.2275276} * 3.3333333f), 0.0), 0.5f, 1.0) * (0.f - {f_1_97 : 0.2098794})) + {f_1_97 : 0.2098794}) * (1.0f / {f_2_88 : 1.00}))) + {pf_1_25 : 0.1008413})
    pf_1_26 = ((pf_5_30 * (((clamp(max((pf_42_20 * 3.3333333f), 0.0), 0.5f, 1.0) * (0.f - f_1_97)) + f_1_97) * (1.0f / f_2_88))) + pf_1_25);
	// 0.1062592  <=>  {pf_3_34 : 0.1062592}
    o.fs_attr14.x = pf_3_34;
	// 1.00  <=>  (min({pf_6_20 : 0.50}, min({pf_2_38 : 0.50}, {pf_5_30 : 0.50})) * (1.0f / ({f_0_61 : 0.50} + float(1e-10))))
    pf_3_35 = (min(pf_6_20, min(pf_2_38, pf_5_30)) * (1.0f / (f_0_61 + float(1e-10))));
	// 0.1261921  <=>  {pf_1_26 : 0.1261921}
    o.fs_attr14.z = pf_1_26;
	// 0.078427  <=>  (((({f4_0_5.y : 0.50} + (0.f - {utof(vs_cbuf15_55.y) : 0.825})) * {pf_1_23 : 0.00}) + {utof(vs_cbuf15_55.y) : 0.825}) * clamp(clamp(({pf_42_20 : 0.2275276} * 3.3333333f), 0.0, 1.0), 0.5f, {pf_7_11 : 0.095063}))
    pf_1_27 = ((((f4_0_5.y + (0.f - utof(vs_cbuf15_55.y))) * pf_1_23) + utof(vs_cbuf15_55.y)) * clamp(clamp((pf_42_20 * 3.3333333f), 0.0, 1.0), 0.5f, pf_7_11));
	// 1036169313  <=>  {ftou2(clamp(clamp(({pf_42_20 : 0.2275276} * 3.3333333f), 0.0, 1.0), 0.5f, {pf_7_11 : 0.095063})) : 1036169313}
    u_1_59 = ftou2(clamp(clamp((pf_42_20 * 3.3333333f), 0.0, 1.0), 0.5f, pf_7_11));
    u_1_phi_239 = u_1_59;
	// True  <=>  if((({u_6_3 : 0} == 0u) ? true : false))
    if (((u_6_3 == 0u) ? true : false))
    {
		// 1065353216  <=>  {vs_cbuf16[8].x : 1065353216}
        u_1_60 = ftou2(vs_cbuf16[8].x);
        u_1_phi_239 = u_1_60;
    }
	// 0.1037777  <=>  (({pf_2_38 : 0.50} * (((clamp(max(({pf_42_20 : 0.2275276} * 3.3333333f), 0.0), 0.5f, 1.0) * (0.f - {f_1_97 : 0.2098794})) + {f_1_97 : 0.2098794}) * (1.0f / {f_2_88 : 1.00}))) + {pf_1_27 : 0.078427})
    pf_1_28 = ((pf_2_38 * (((clamp(max((pf_42_20 * 3.3333333f), 0.0), 0.5f, 1.0) * (0.f - f_1_97)) + f_1_97) * (1.0f / f_2_88))) + pf_1_27);
	// 0.1037777  <=>  {pf_1_28 : 0.1037777}
    o.fs_attr14.y = pf_1_28;
	// 0.50  <=>  ((({pf_6_20 : 0.50} + (0.f - {f_0_61 : 0.50})) * (({pf_3_35 : 1.00} * -0.9f) + 0.9f)) + {f_0_61 : 0.50})
    pf_2_39 = (((pf_6_20 + (0.f - f_0_61)) * ((pf_3_35 * -0.9f) + 0.9f)) + f_0_61);
	// 0.50  <=>  ((({pf_2_38 : 0.50} + (0.f - {f_0_61 : 0.50})) * (({pf_3_35 : 1.00} * -0.9f) + 0.9f)) + {f_0_61 : 0.50})
    pf_1_30 = (((pf_2_38 + (0.f - f_0_61)) * ((pf_3_35 * -0.9f) + 0.9f)) + f_0_61);
	// 0.50  <=>  {pf_2_39 : 0.50}
    o.fs_attr11.x = pf_2_39;
	// 0.50  <=>  ((({pf_5_30 : 0.50} + (0.f - {f_0_61 : 0.50})) * (({pf_3_35 : 1.00} * -0.9f) + 0.9f)) + {f_0_61 : 0.50})
    pf_2_40 = (((pf_5_30 + (0.f - f_0_61)) * ((pf_3_35 * -0.9f) + 0.9f)) + f_0_61);
	// 0.50  <=>  {pf_1_30 : 0.50}
    o.fs_attr11.y = pf_1_30;
	// 0.50  <=>  {pf_2_40 : 0.50}
    o.fs_attr11.z = pf_2_40;
	// 0.50  <=>  ({f4_0_7.x : 0.50} * clamp((max(({pf_0_28 : 603.271} * 0.06666667f), 0.2f) + (0.f - 0.f)), 0.0, 1.0))
    pf_0_32 = (f4_0_7.x * clamp((max((pf_0_28 * 0.06666667f), 0.2f) + (0.f - 0.f)), 0.0, 1.0));
	// 0.50  <=>  ({f4_0_7.y : 0.50} * clamp((max(({pf_0_28 : 603.271} * 0.06666667f), 0.2f) + (0.f - 0.f)), 0.0, 1.0))
    pf_1_31 = (f4_0_7.y * clamp((max((pf_0_28 * 0.06666667f), 0.2f) + (0.f - 0.f)), 0.0, 1.0));
	// 0.50  <=>  {pf_0_32 : 0.50}
    o.fs_attr17.x = pf_0_32;
	// 0.50  <=>  ({f4_0_7.z : 0.50} * clamp((max(({pf_0_28 : 603.271} * 0.06666667f), 0.2f) + (0.f - 0.f)), 0.0, 1.0))
    pf_0_33 = (f4_0_7.z * clamp((max((pf_0_28 * 0.06666667f), 0.2f) + (0.f - 0.f)), 0.0, 1.0));
	// 0.50  <=>  {pf_1_31 : 0.50}
    o.fs_attr17.y = pf_1_31;
	// 0.50  <=>  {pf_0_33 : 0.50}
    o.fs_attr17.z = pf_0_33;
	// 1065353216  <=>  {u_1_phi_239 : 1065353216}
    u_0_36 = u_1_phi_239;
    u_0_phi_240 = u_0_36;
	// False  <=>  if(((! ({u_6_3 : 0} == 0u)) ? true : false))
    if (((!(u_6_3 == 0u)) ? true : false))
    {
		// 8  <=>  (min(uint(({u_6_3 : 0} + 4294967295u)), uint(2u)) << 2u)
        u_2_41 = (min(uint((u_6_3 + 4294967295u)), uint(2u)) << 2u);
		// 26704  <=>  {vs_cbuf1[({u_2_41 : 8} >> 4)][(({u_2_41 : 8} >> 2) % 4)] : 26704}
        u_3_13 = ftou2(vs_cbuf1[(u_2_41 >> 4)][((u_2_41 >> 2) % 4)]);
		// False  <=>  (false ? true : false)
        b_1_82 = (false ? true : false);
        b_1_phi_241 = b_1_82;
		// True  <=>  if(((! (({u_3_13 : 26704} + 56999552u) == 57026208u)) ? true : false))
        if (((!((u_3_13 + 56999552u) == 57026208u)) ? true : false))
        {
			// False  <=>  ((({u_3_13 : 26704} + 56999552u) == 57026232u) ? true : false)
            b_1_83 = (((u_3_13 + 56999552u) == 57026232u) ? true : false);
            b_1_phi_241 = b_1_83;
        }
		// 1065353216  <=>  {u_1_phi_239 : 1065353216}
        u_3_14 = u_1_phi_239;
		// False  <=>  (false ? true : false)
        b_2_96 = (false ? true : false);
        u_3_phi_242 = u_3_14;
        b_2_phi_242 = b_2_96;
		// True  <=>  if((((({u_3_13 : 26704} + 56999552u) == 57026208u) || (! {b_1_phi_241 : False})) ? true : false))
        if (((((u_3_13 + 56999552u) == 57026208u) || (!b_1_phi_241)) ? true : false))
        {
			// False  <=>  (false ? true : false)
            b_3_112 = (false ? true : false);
            b_3_phi_243 = b_3_112;
			// True  <=>  if(((! (({u_3_13 : 26704} + 56999552u) == 57026208u)) ? true : false))
            if (((!((u_3_13 + 56999552u) == 57026208u)) ? true : false))
            {
				// True  <=>  ((({u_3_13 : 26704} + 56999552u) == 57026256u) ? true : false)
                b_3_113 = (((u_3_13 + 56999552u) == 57026256u) ? true : false);
                b_3_phi_243 = b_3_113;
            }
			// 1065353216  <=>  {u_1_phi_239 : 1065353216}
            u_2_43 = u_1_phi_239;
            u_2_phi_244 = u_2_43;
			// False  <=>  if((((({u_3_13 : 26704} + 56999552u) == 57026208u) || (! {b_3_phi_243 : True})) ? true : false))
            if (((((u_3_13 + 56999552u) == 57026208u) || (!b_3_phi_243)) ? true : false))
            {
				// True  <=>  if(((! (({u_3_13 : 26704} + 56999552u) == 57026208u)) ? true : false))
                if (((!((u_3_13 + 56999552u) == 57026208u)) ? true : false))
                {
                    return o;
                }
				// 1065353216  <=>  {vs_cbuf16[8].y : 1065353216}
                u_2_44 = ftou2(vs_cbuf16[8].y);
                u_2_phi_244 = u_2_44;
            }
			// 1065353216  <=>  {u_2_phi_244 : 1065353216}
            u_3_15 = u_2_phi_244;
			// True  <=>  ({b_3_phi_243 : True} ? true : false)
            b_2_97 = (b_3_phi_243 ? true : false);
            u_3_phi_242 = u_3_15;
            b_2_phi_242 = b_2_97;
        }
		// 1065353216  <=>  {u_3_phi_242 : 1065353216}
        u_2_45 = u_3_phi_242;
        u_2_phi_246 = u_2_45;
		// True  <=>  if((({b_1_phi_241 : False} || {b_2_phi_242 : True}) ? true : false))
        if (((b_1_phi_241 || b_2_phi_242) ? true : false))
        {
			// True  <=>  if(((! {b_1_phi_241 : False}) ? true : false))
            if (((!b_1_phi_241) ? true : false))
            {
            }
			// 1065353216  <=>  {u_3_phi_242 : 1065353216}
            u_4_34 = u_3_phi_242;
            u_4_phi_248 = u_4_34;
			// False  <=>  if((({b_1_phi_241 : False} || (! {b_2_phi_242 : True})) ? true : false))
            if (((b_1_phi_241 || (!b_2_phi_242)) ? true : false))
            {
				// 1063302270  <=>  {vs_cbuf16[8].z : 1063302270}
                u_4_35 = ftou2(vs_cbuf16[8].z);
                u_4_phi_248 = u_4_35;
            }
			// 1065353216  <=>  {u_4_phi_248 : 1065353216}
            u_5_29 = u_4_phi_248;
            u_5_phi_249 = u_5_29;
			// True  <=>  if(({b_2_phi_242 : True} ? true : false))
            if ((b_2_phi_242 ? true : false))
            {
				// 0  <=>  {vs_cbuf16[8].w : 0}
                u_5_30 = ftou2(vs_cbuf16[8].w);
                u_5_phi_249 = u_5_30;
            }
			// 0  <=>  {u_5_phi_249 : 0}
            u_2_46 = u_5_phi_249;
            u_2_phi_246 = u_2_46;
        }
		// 0  <=>  {u_2_phi_246 : 0}
        u_0_37 = u_2_phi_246;
        u_0_phi_240 = u_0_37;
    }
	// 0.7584254  <=>  clamp(max(({pf_42_20 : 0.2275276} * 3.3333333f), 0.0), 0.5f, 1.0)
    o.fs_attr12.x = clamp(max((pf_42_20 * 3.3333333f), 0.0), 0.5f, 1.0);
	// 0.2251426  <=>  clamp(({pf_10_13 : 112.5713} * 0.002f), 0.0, 1.0)
    o.fs_attr12.y = clamp((pf_10_13 * 0.002f), 0.0, 1.0);
	// 0.6315516  <=>  clamp(((sqrt({pf_33_46 : 244786.20}) * -0.00125f) + 1.25f), 0.0, 1.0)
    o.fs_attr15.z = clamp(((sqrt(pf_33_46) * -0.00125f) + 1.25f), 0.0, 1.0);
	// 0.8931441  <=>  (((clamp((({pf_10_13 : 112.5713} * 0.01f) + (0.f - 1.f)), 0.0, 1.0) * clamp((({pf_39_14 : 53.08875} + -0.5f) * 2.f), 0.0, 1.0)) * -0.85f) + 1.f)
    pf_0_37 = (((clamp(((pf_10_13 * 0.01f) + (0.f - 1.f)), 0.0, 1.0) * clamp(((pf_39_14 + -0.5f) * 2.f), 0.0, 1.0)) * -0.85f) + 1.f);
	// 0.7895176  <=>  max(0.f, min(((sqrt({pf_33_46 : 244786.20}) * 0.002f) + (0.f - 0.2f)), 2.f))
    o.fs_attr12.w = max(0.f, min(((sqrt(pf_33_46) * 0.002f) + (0.f - 0.2f)), 2.f));
	// 0.2631447  <=>  clamp((min(((sqrt({pf_33_46 : 244786.20}) * -0.0006f) + 0.56f), 0.5f) + (0.f - 0.f)), 0.0, 1.0)
    f_0_69 = clamp((min(((sqrt(pf_33_46) * -0.0006f) + 0.56f), 0.5f) + (0.f - 0.f)), 0.0, 1.0);
	// 0.9394758  <=>  clamp(((sqrt({pf_33_46 : 244786.20}) * 0.0001f) + 0.89f), 0.9f, 0.98f)
    o.fs_attr15.y = clamp(((sqrt(pf_33_46) * 0.0001f) + 0.89f), 0.9f, 0.98f);
	// 0.2631447  <=>  {f_0_69 : 0.2631447}
    o.fs_attr15.x = f_0_69;
	// 0.8931441  <=>  ((clamp((({pf_10_13 : 112.5713} * -0.00083333335f) + 1.25f), 0.0, 1.0) * {utof2(u_0_phi_240) : 1.00}) * {pf_0_37 : 0.8931441})
    o.fs_attr12.z = ((clamp(((pf_10_13 * -0.00083333335f) + 1.25f), 0.0, 1.0) * utof2(u_0_phi_240)) * pf_0_37);
    return o;
}

float4 frag(v2f i) : COLOR
{
	// fs_cbuf8_1 = float4(0.0627182, 0.829457, -0.5550383, -629.7858);
	// fs_cbuf8_2 = float4(-0.0931343, 0.5585706, 0.8242117, -2058.403);
	// camera_wpos = float4(287.3111, 1672.144, 1396.669, 0.00);
	// fs_cbuf8_30 = float4(1.00, 25000.00, 25000.00, 24999.00);
	// fs_cbuf9_78 = float4(1.00, 1.00, 16.00, 16.00);
	// fs_cbuf9_139 = float4(1.00, 0.00, 0.00, 0.00);
	// fs_cbuf9_140 = float4(0.00, 10.00, 0.00, 0.00);
	// fs_cbuf9_189 = float4(0.0001, 2.50, 0.30, 0.00);
	// fs_cbuf9_190 = float4(30.00, 2.50, 0.95, 6.00);
	// fs_cbuf9_191 = float4(7.50, 0.50, 0.90, 0.01);
	// fs_cbuf9_192 = float4(0.20, -0.10, 0.80, 0.00);
	// fs_cbuf10_9 = float4(0.00, 1.00, 0.00, 1550.75);
	// fs_cbuf10_139 = float4(0.00, 0.00, 0.00, 0.00);
	// fs_cbuf10_140 = float4(0.00, 0.00, 0.00, 0.00);
	// fs_cbuf10_189 = float4(0.00, 0.00, 0.00, 0.00);
	// fs_cbuf10_190 = float4(0.00, 0.00, 0.00, 0.00);
	// fs_cbuf15_1 = float4(0.00, 1.00, 1.895482, 1.00);
	// fs_cbuf15_25 = float4(0.682, 0.99055, 0.63965, 0.12);
	// fs_cbuf15_26 = float4(1.12035, 1.3145, 0.66605, 0.4519901);
	// fs_cbuf15_28 = float4(0.5226594, -0.5741013, -0.6302658, 0.00);
	// fs_cbuf15_42 = float4(4.40, 3.459608, 2.637844, 0.65);
	// fs_cbuf15_43 = float4(1.00, 0.885, 0.65, 1.00);
	// fs_cbuf15_44 = float4(0.90, 0.775, 0.575, 1.00);
	// fs_cbuf15_57 = float4(-4731.44, 907.7282, 3000.00, 1.00);
	// fs_cbuf16_7 = float4(0.00, 0.00, 0.00, 39.37191);
	// fs_cbuf16_10 = float4(538.25, 1550.75, 941.75, 0.9297899);

    bool b_0_0;
    bool b_0_10;
    bool b_0_17;
    bool b_0_5;
    bool b_0_9;
    bool b_1_1;
    bool b_1_5;
    bool b_2_2;
    bool b_2_5;
    bool b_3_2;
    float f_0_2;
    float f_0_29;
    float f_0_32;
    float f_0_7;
    float f_1_21;
    float f_1_27;
    float f_1_35;
    float f_1_39;
    float f_1_4;
    float f_1_5;
    float f_1_6;
    float f_10_2;
    float f_11_1;
    float f_11_9;
    float f_12_11;
    float f_12_12;
    float f_12_13;
    float f_12_4;
    float f_12_9;
    float f_13_10;
    float f_13_20;
    float f_13_24;
    float f_13_7;
    float f_13_8;
    float f_14_11;
    float f_14_13;
    float f_15_5;
    float f_16_4;
    float f_17_12;
    float f_17_13;
    float f_17_15;
    float f_17_6;
    float f_18_1;
    float f_19_3;
    float f_2_14;
    float f_2_3;
    float f_2_4;
    float f_2_7;
    float f_2_9;
    float f_3_15;
    float f_3_26;
    float f_3_31;
    float f_3_32;
    float f_3_33;
    float f_4_14;
    float f_4_3;
    float f_4_8;
    float f_5_0;
    float f_5_5;
    float f_5_7;
    float f_6_0;
    float f_6_7;
    float f_7_10;
    float f_7_11;
    float f_7_12;
    float f_7_13;
    float f_7_21;
    float f_7_24;
    float f_7_3;
    float f_7_43;
    float f_7_52;
    float f_7_65;
    float f_7_8;
    float f_8_0;
    float f_9_13;
    float f_9_23;
    float f_9_29;
    float f_9_3;
    float f_9_43;
    float f_9_5;
    float f_9_7;
    float2 f2_0_0;
    float2 f2_0_2;
    float2 f2_0_3;
    float4 f4_0_0;
    float4 f4_0_10;
    float4 f4_0_11;
    float4 f4_0_12;
    float4 f4_0_3;
    float4 f4_0_4;
    float4 f4_0_5;
    float4 f4_0_6;
    float4 f4_0_7;
    float4 f4_0_9;
    precise float pf_0_0;
    precise float pf_0_14;
    precise float pf_0_15;
    precise float pf_0_17;
    precise float pf_0_18;
    precise float pf_0_20;
    precise float pf_0_24;
    precise float pf_0_3;
    precise float pf_0_7;
    precise float pf_1_0;
    precise float pf_1_1;
    precise float pf_1_10;
    precise float pf_1_12;
    precise float pf_1_13;
    precise float pf_1_15;
    precise float pf_1_17;
    precise float pf_1_2;
    precise float pf_1_21;
    precise float pf_1_4;
    precise float pf_1_7;
    precise float pf_10_0;
    precise float pf_10_13;
    precise float pf_10_14;
    precise float pf_10_23;
    precise float pf_10_26;
    precise float pf_10_3;
    precise float pf_10_8;
    precise float pf_11_12;
    precise float pf_11_14;
    precise float pf_11_15;
    precise float pf_11_18;
    precise float pf_11_25;
    precise float pf_11_26;
    precise float pf_11_27;
    precise float pf_11_28;
    precise float pf_11_30;
    precise float pf_11_5;
    precise float pf_11_6;
    precise float pf_11_9;
    precise float pf_12_0;
    precise float pf_12_1;
    precise float pf_12_11;
    precise float pf_12_13;
    precise float pf_12_14;
    precise float pf_12_15;
    precise float pf_12_2;
    precise float pf_12_9;
    precise float pf_13_0;
    precise float pf_13_1;
    precise float pf_13_11;
    precise float pf_13_15;
    precise float pf_13_3;
    precise float pf_13_7;
    precise float pf_14_1;
    precise float pf_14_2;
    precise float pf_15_1;
    precise float pf_16_0;
    precise float pf_17_1;
    precise float pf_17_3;
    precise float pf_17_4;
    precise float pf_17_5;
    precise float pf_2_0;
    precise float pf_2_11;
    precise float pf_2_13;
    precise float pf_2_15;
    precise float pf_2_17;
    precise float pf_2_2;
    precise float pf_2_22;
    precise float pf_2_27;
    precise float pf_2_3;
    precise float pf_2_31;
    precise float pf_2_8;
    precise float pf_3_0;
    precise float pf_3_11;
    precise float pf_3_15;
    precise float pf_3_3;
    precise float pf_3_6;
    precise float pf_3_8;
    precise float pf_4_0;
    precise float pf_4_10;
    precise float pf_4_12;
    precise float pf_4_14;
    precise float pf_4_19;
    precise float pf_4_4;
    precise float pf_4_6;
    precise float pf_5_10;
    precise float pf_5_13;
    precise float pf_5_14;
    precise float pf_5_17;
    precise float pf_5_19;
    precise float pf_5_2;
    precise float pf_5_22;
    precise float pf_5_25;
    precise float pf_5_26;
    precise float pf_5_30;
    precise float pf_5_34;
    precise float pf_5_38;
    precise float pf_5_4;
    precise float pf_5_5;
    precise float pf_6_10;
    precise float pf_6_12;
    precise float pf_6_14;
    precise float pf_6_19;
    precise float pf_6_22;
    precise float pf_6_4;
    precise float pf_6_6;
    precise float pf_6_8;
    precise float pf_7_10;
    precise float pf_7_14;
    precise float pf_7_17;
    precise float pf_7_19;
    precise float pf_7_20;
    precise float pf_7_6;
    precise float pf_7_8;
    precise float pf_8_11;
    precise float pf_8_13;
    precise float pf_8_17;
    precise float pf_8_18;
    precise float pf_8_20;
    precise float pf_8_3;
    precise float pf_8_6;
    precise float pf_8_8;
    precise float pf_9_1;
    precise float pf_9_11;
    precise float pf_9_14;
    precise float pf_9_17;
    precise float pf_9_18;
    precise float pf_9_24;
    precise float pf_9_5;
    precise float pf_9_6;
    uint u_0_1;
    uint u_0_3;
    uint u_0_5;
    uint u_0_6;
    uint u_0_7;
    uint u_0_phi_13;
    uint u_1_2;
    uint u_1_3;
    uint u_1_5;
    uint u_1_phi_2;
    uint u_2_2;
    uint u_2_3;
    uint u_2_5;
    uint u_2_phi_7;
    uint u_3_1;
    uint u_3_2;
    uint u_3_3;
    uint u_3_5;
    uint u_3_phi_4;
    uint u_4_1;
    uint u_4_2;
    uint u_4_phi_5;
    uint u_5_0;
    uint u_5_1;
    uint u_5_2;
    uint u_5_3;
    uint u_5_5;
    uint u_5_6;
    uint u_5_phi_11;
    uint u_5_phi_3;
    uint u_5_phi_5;
    uint u_6_3;
    uint u_6_4;
    uint u_6_5;
    uint u_6_6;
    uint u_6_7;
    uint u_6_8;
    uint u_6_phi_10;
    uint u_6_phi_12;
    uint u_6_phi_9;
    uint u_7_0;
    uint u_7_1;
    uint u_7_phi_6;
    uint u_8_1;
    uint u_8_2;
    uint u_8_phi_8;
    uint u_9_0;
    uint u_9_1;
	// 0.0023135  <=>  (1.0f / ({i.fs_attr3.w : 432.2517} * {gl_FragCoord.w : 1.00}))
    f_0_2 = (1.0f / i.fs_attr3.w);
	// float2(0.7565525,0.1145888)  <=>  float2((({i.fs_attr3.x : 327.0211} * {gl_FragCoord.w : 1.00}) * {f_0_2 : 0.0023135}), (({i.fs_attr3.y : 49.53122} * {gl_FragCoord.w : 1.00}) * {f_0_2 : 0.0023135}))
    f2_0_0 = float2((i.fs_attr3.x * f_0_2), (i.fs_attr3.y * f_0_2));
	// float4(0.50,0.50,0.50,0.75)  <=>  textureSample({_CameraDepthTexture : _CameraDepthTexture}, {f2_0_0 : float2(0.7565525,0.1145888)})
    f4_0_0 = textureSample(_CameraDepthTexture, f2_0_0);
	// 520.0128  <=>  {i.fs_attr9.x : 520.0128}
    f_1_4 = i.fs_attr9.x;
	// 1559.572  <=>  {i.fs_attr9.y : 1559.572}
    f_2_3 = i.fs_attr9.y;
	// 520.0128  <=>  {i.fs_attr7.x : 520.0128}
    f_5_0 = i.fs_attr7.x;
	// 1559.572  <=>  {i.fs_attr7.y : 1559.572}
    f_6_0 = i.fs_attr7.y;
	// 974.8118  <=>  {i.fs_attr7.z : 974.8118}
    f_8_0 = i.fs_attr7.z;
	// 0.00  <=>  ((0.f - {f_1_4 : 520.0128}) + {f_5_0 : 520.0128})
    pf_0_0 = ((0.f - f_1_4) + f_5_0);
	// 0.10  <=>  {i.fs_attr1.w : 0.10}
    f_11_1 = i.fs_attr1.w;
	// 0.00  <=>  ((0.f - {f_2_3 : 1559.572}) + {f_6_0 : 1559.572})
    pf_1_0 = ((0.f - f_2_3) + f_6_0);
	// -232.7016  <=>  ((0.f - {f_5_0 : 520.0128}) + {utof(camera_wpos.x) : 287.3111})
    pf_2_0 = ((0.f - f_5_0) + utof(camera_wpos.x));
	// 112.5713  <=>  ((0.f - {f_6_0 : 1559.572}) + {utof(camera_wpos.y) : 1672.144})
    pf_3_0 = ((0.f - f_6_0) + utof(camera_wpos.y));
	// 421.8577  <=>  ((0.f - {f_8_0 : 974.8118}) + {utof(camera_wpos.z) : 1396.669})
    pf_4_0 = ((0.f - f_8_0) + utof(camera_wpos.z));
	// 0.00  <=>  ((0.f - {i.fs_attr9.z : 974.8118}) + {f_8_0 : 974.8118})
    pf_1_1 = ((0.f - i.fs_attr9.z) + f_8_0);
	// 0.00  <=>  (({pf_1_1 : 0.00} * {pf_1_1 : 0.00}) + (({pf_1_0 : 0.00} * {pf_1_0 : 0.00}) + ({pf_0_0 : 0.00} * {pf_0_0 : 0.00})))
    pf_0_3 = ((pf_1_1 * pf_1_1) + ((pf_1_0 * pf_1_0) + (pf_0_0 * pf_0_0)));
	// 35.95715  <=>  ({i.fs_attr8.y : 89.89288} * 0.4f)
    pf_1_2 = (i.fs_attr8.y * 0.4f);
	// -0.0172896  <=>  (1.0f / ((({i.fs_attr3.z : 431.269} * (1.0f / {i.fs_attr3.w : 432.2517})) * {utof(fs_cbuf8_30.w) : 24999.00}) + (0.f - {utof(fs_cbuf8_30.y) : 25000.00})))
    f_9_3 = (1.0f / (((i.fs_attr3.z * (1.0f / i.fs_attr3.w)) * utof(fs_cbuf8_30.w)) + (0.f - utof(fs_cbuf8_30.y))));
	// 35.95715  <=>  sqrt(max(0.f, (({pf_1_2 : 35.95715} * {pf_1_2 : 35.95715}) + (0.f - {pf_0_3 : 0.00}))))
    f_13_7 = sqrt(max(0.f, ((pf_1_2 * pf_1_2) + (0.f - pf_0_3))));
	// 12104.22  <=>  ((({f_9_3 : -0.0172896} * {utof(fs_cbuf8_30.z) : 25000.00}) + (({f4_0_0.x : 0.50} * {utof(fs_cbuf8_30.w) : 24999.00}) + {utof(fs_cbuf8_30.x) : 1.00})) + {f_13_7 : 35.95715})
    pf_5_2 = (((f_9_3 * utof(fs_cbuf8_30.z)) + ((f4_0_0.x * utof(fs_cbuf8_30.w)) + utof(fs_cbuf8_30.x))) + f_13_7);
	// 66822.34  <=>  (({pf_3_0 : 112.5713} * {pf_3_0 : 112.5713}) + ({pf_2_0 : -232.7016} * {pf_2_0 : -232.7016}))
    pf_1_4 = ((pf_3_0 * pf_3_0) + (pf_2_0 * pf_2_0));
	// 12068.26  <=>  ((({f_9_3 : -0.0172896} * {utof(fs_cbuf8_30.z) : 25000.00}) + (({f4_0_0.x : 0.50} * {utof(fs_cbuf8_30.w) : 24999.00}) + {utof(fs_cbuf8_30.x) : 1.00})) + (0.f - 0.f))
    pf_0_7 = (((f_9_3 * utof(fs_cbuf8_30.z)) + ((f4_0_0.x * utof(fs_cbuf8_30.w)) + utof(fs_cbuf8_30.x))) + (0.f - 0.f));
	// 1.00  <=>  clamp({pf_0_7 : 12068.26}, 0.0, 1.0)
    f_9_5 = clamp(pf_0_7, 0.0, 1.0);
	// 494.7588  <=>  sqrt((({pf_4_0 : 421.8577} * {pf_4_0 : 421.8577}) + {pf_1_4 : 66822.34}))
    f_10_2 = sqrt(((pf_4_0 * pf_4_0) + pf_1_4));
	// 0.00  <=>  exp2((({pf_5_2 : 12104.22} + (0.f - {i.fs_attr13.x : 38.77518})) * -0.04328085f))
    f_13_8 = exp2(((pf_5_2 + (0.f - i.fs_attr13.x)) * -0.04328085f));
	// 1.00  <=>  clamp(((0.f - {f_13_8 : 0.00}) + 1.f), 0.0, 1.0)
    f_13_10 = clamp(((0.f - f_13_8) + 1.f), 0.0, 1.0);
	// 0.89314  <=>  (clamp((({f_10_2 : 494.7588} * 0.1f) + (0.f - 1.f)), 0.0, 1.0) * (({f_13_10 : 1.00} * {f_9_5 : 1.00}) * {i.fs_attr12.z : 0.89314}))
    pf_0_14 = (clamp(((f_10_2 * 0.1f) + (0.f - 1.f)), 0.0, 1.0) * ((f_13_10 * f_9_5) * i.fs_attr12.z));
	// False  <=>  ((({pf_0_14 : 0.89314} <= 0.f) && (! isnan({pf_0_14 : 0.89314}))) && (! isnan(0.f)))
    b_0_0 = (((pf_0_14 <= 0.f) && (!isnan(pf_0_14))) && (!isnan(0.f)));
	// False  <=>  if(({b_0_0 : False} ? true : false))
    if ((b_0_0 ? true : false))
    {
        discard;
    }
	// 1.00  <=>  {float4(textureQueryLod({tex4 : tex4}, float2((({f_11_1 : 0.10} * -0.3f) + {i.fs_attr2.z : 1.73624}), (({f_11_1 : 0.10} * -0.3f) + {i.fs_attr2.w : 2.79527}))), 0.0, 0.0).y : 1.00}
    f_7_3 = float4(textureQueryLod(tex4, float2(((f_11_1 * -0.3f) + i.fs_attr2.z), ((f_11_1 * -0.3f) + i.fs_attr2.w))), 0.0, 0.0).y;
	// 256  <=>  (uint({f_7_3 : 1.00}) << 8u)
    u_0_1 = (uint(f_7_3) << 8u);
	// 1.00  <=>  {utof2(((((0.f < {utof(fs_cbuf8_1.y) : 0.829457}) && (! isnan(0.f))) && (! isnan({utof(fs_cbuf8_1.y) : 0.829457}))) ? 1065353216u : 0u)) : 1.00}
    f_7_8 = utof2(((((0.f < utof(fs_cbuf8_1.y)) && (!isnan(0.f))) && (!isnan( utof(fs_cbuf8_1.y)))) ? 1065353216u : 0u));
	// 0.00  <=>  {utof2(((((0.f > {utof(fs_cbuf8_1.y) : 0.829457}) && (! isnan(0.f))) && (! isnan({utof(fs_cbuf8_1.y) : 0.829457}))) ? 1065353216u : 0u)) : 0.00}
    f_9_7 = utof2(((((0.f > utof(fs_cbuf8_1.y)) && (!isnan(0.f))) && (!isnan( utof(fs_cbuf8_1.y)))) ? 1065353216u : 0u));
	// 1.205608  <=>  inversesqrt((({utof(fs_cbuf8_2.z) : 0.8242117} * {utof(fs_cbuf8_2.z) : 0.8242117}) + ({utof(fs_cbuf8_2.x) : -0.0931343} * {utof(fs_cbuf8_2.x) : -0.0931343})))
    f_7_10 = inversesqrt((( utof(fs_cbuf8_2.z) * utof(fs_cbuf8_2.z)) + ( utof(fs_cbuf8_2.x) * utof(fs_cbuf8_2.x))));
	// 0.9936762  <=>  ({f_7_10 : 1.205608} * {utof(fs_cbuf8_2.z) : 0.8242117})
    pf_9_1 = (f_7_10 * utof(fs_cbuf8_2.z));
	// -0.1122834  <=>  ({f_7_10 : 1.205608} * {utof(fs_cbuf8_2.x) : -0.0931343})
    pf_10_0 = (f_7_10 * utof(fs_cbuf8_2.x));
	// 1.00  <=>  {utof2(((((0.f < {utof(fs_cbuf8_2.y) : 0.5585706}) && (! isnan(0.f))) && (! isnan({utof(fs_cbuf8_2.y) : 0.5585706}))) ? 1065353216u : 0u)) : 1.00}
    f_7_11 = utof2(((((0.f < utof(fs_cbuf8_2.y)) && (!isnan(0.f))) && (!isnan( utof(fs_cbuf8_2.y)))) ? 1065353216u : 0u));
	// 0.00  <=>  {utof2(((((0.f > {utof(fs_cbuf8_2.y) : 0.5585706}) && (! isnan(0.f))) && (! isnan({utof(fs_cbuf8_2.y) : 0.5585706}))) ? 1065353216u : 0u)) : 0.00}
    f_9_13 = utof2(((((0.f > utof(fs_cbuf8_2.y)) && (!isnan(0.f))) && (!isnan( utof(fs_cbuf8_2.y)))) ? 1065353216u : 0u));
	// 0.9936762  <=>  abs({pf_9_1 : 0.9936762})
    f_7_12 = abs(pf_9_1);
	// False  <=>  ((({f_7_12 : 0.9936762} == 0.f) && (! isnan({f_7_12 : 0.9936762}))) && (! isnan(0.f)))
    b_0_5 = (((f_7_12 == 0.f) && (!isnan(f_7_12))) && (!isnan(0.f)));
	// 0.1122834  <=>  abs({pf_10_0 : -0.1122834})
    f_7_13 = abs(pf_10_0);
	// False  <=>  ((({f_7_13 : 0.1122834} == 0.f) && (! isnan({f_7_13 : 0.1122834}))) && (! isnan(0.f)))
    b_1_1 = (((f_7_13 == 0.f) && (!isnan(f_7_13))) && (!isnan(0.f)));
	// 3185964252  <=>  {ftou2(pf_10_0) : 3185964252}
    u_1_2 = ftou2(pf_10_0);
    u_1_phi_2 = u_1_2;
	// False  <=>  if((({b_1_1 : False} && {b_0_5 : False}) ? true : false))
    if (((b_1_1 && b_0_5) ? true : false))
    {
		// 1078530011  <=>  (((({pf_10_0 : -0.1122834} >= 0.f) || isnan({pf_10_0 : -0.1122834})) || isnan(0.f)) ? 0u : 1078530011u)
        u_3_1 = ((((pf_10_0 >= 0.f) || isnan(pf_10_0)) || isnan(0.f)) ? 0u : 1078530011u);
		// False  <=>  (((({pf_9_1 : 0.9936762} < 0.f) && (! isnan({pf_9_1 : 0.9936762}))) && (! isnan(0.f))) ? true : false)
        b_2_2 = ((((pf_9_1 < 0.f) && (!isnan(pf_9_1))) && (!isnan(0.f))) ? true : false);
		// 1078530011  <=>  {u_3_1 : 1078530011}
        u_5_0 = u_3_1;
        u_5_phi_3 = u_5_0;
		// False  <=>  if({b_2_2 : False})
        if (b_2_2)
        {
			// 3226013659  <=>  {ftou2(((0.f - {utof2(u_3_1) : 3.141593}) + (0.f - 0.f))) : 3226013659}
            u_5_1 = ftou2(((0.f - utof2(u_3_1)) + (0.f - 0.f)));
            u_5_phi_3 = u_5_1;
        }
		// 1078530011  <=>  {u_5_phi_3 : 1078530011}
        u_1_3 = u_5_phi_3;
        u_1_phi_2 = u_1_3;
    }
	// 3185964252  <=>  {u_1_phi_2 : 3185964252}
    u_3_2 = u_1_phi_2;
    u_3_phi_4 = u_3_2;
	// True  <=>  if(((! ({b_1_1 : False} && {b_0_5 : False})) ? true : false))
    if (((!(b_1_1 && b_0_5)) ? true : false))
    {
		// False  <=>  (((abs({pf_9_1 : 0.9936762}) == {utof2(0x7f800000) : ∞}) && (! isnan(abs({pf_9_1 : 0.9936762})))) && (! isnan({utof2(0x7f800000) : ∞})))
        b_0_9 = (((abs(pf_9_1) == utof2(0x7f800000)) && (!isnan(abs(pf_9_1)))) && (!isnan( utof2(0x7f800000))));
		// False  <=>  ((((abs({utof2(u_1_phi_2) : -0.1122834}) == {utof2(0x7f800000) : ∞}) && (! isnan(abs({utof2(u_1_phi_2) : -0.1122834})))) && (! isnan({utof2(0x7f800000) : ∞}))) && {b_0_9 : False})
        b_0_10 = ((((abs( utof2(u_1_phi_2)) == utof2(0x7f800000)) && (!isnan(abs( utof2(u_1_phi_2))))) && (!isnan( utof2(0x7f800000)))) && b_0_9);
		// 3185964252  <=>  {u_1_phi_2 : 3185964252}
        u_4_1 = u_1_phi_2;
		// 1065247121  <=>  {ftou2(pf_9_1) : 1065247121}
        u_5_2 = ftou2(pf_9_1);
        u_4_phi_5 = u_4_1;
        u_5_phi_5 = u_5_2;
		// False  <=>  if(({b_0_10 : False} ? true : false))
        if ((b_0_10 ? true : false))
        {
			// False  <=>  (((({pf_9_1 : 0.9936762} < 0.f) && (! isnan({pf_9_1 : 0.9936762}))) && (! isnan(0.f))) ? true : false)
            b_2_5 = ((((pf_9_1 < 0.f) && (!isnan(pf_9_1))) && (!isnan(0.f))) ? true : false);
			// 1075235812  <=>  (((({utof2(u_1_phi_2) : -0.1122834} >= 0.f) || isnan({utof2(u_1_phi_2) : -0.1122834})) || isnan(0.f)) ? 1061752795u : 1075235812u)
            u_7_0 = (((( utof2(u_1_phi_2) >= 0.f) || isnan( utof2(u_1_phi_2))) || isnan(0.f)) ? 1061752795u : 1075235812u);
            u_7_phi_6 = u_7_0;
			// False  <=>  if({b_2_5 : False})
            if (b_2_5)
            {
				// -2.356194  <=>  (0.f - {utof2((((({utof2(u_1_phi_2) : -0.1122834} >= 0.f) || isnan({utof2(u_1_phi_2) : -0.1122834})) || isnan(0.f)) ? 1061752795u : 1075235812u)) : 2.356194})
                f_7_21 = (0.f - utof2((((( utof2(u_1_phi_2) >= 0.f) || isnan( utof2(u_1_phi_2))) || isnan(0.f)) ? 1061752795u : 1075235812u)));
				// 3222719460  <=>  {ftou2(({f_7_21 : -2.356194} + (0.f - 0.f))) : 3222719460}
                u_7_1 = ftou2((f_7_21 + (0.f - 0.f)));
                u_7_phi_6 = u_7_1;
            }
			// 1075235812  <=>  {u_7_phi_6 : 1075235812}
            u_4_2 = u_7_phi_6;
			// 1061752795  <=>  1061752795u
            u_5_3 = 1061752795u;
            u_4_phi_5 = u_4_2;
            u_5_phi_5 = u_5_3;
        }
		// 3185964252  <=>  {u_4_phi_5 : 3185964252}
        u_2_2 = u_4_phi_5;
        u_2_phi_7 = u_2_2;
		// True  <=>  if(((! {b_0_10 : False}) ? true : false))
        if (((!b_0_10) ? true : false))
        {
			// 0.9936762  <=>  max(abs({utof2(u_4_phi_5) : -0.1122834}), abs({utof2(u_5_phi_5) : 0.9936762}))
            f_7_24 = max(abs( utof2(u_4_phi_5)), abs( utof2(u_5_phi_5)));
			// False  <=>  ((({f_7_24 : 0.9936762} >= 16.f) && (! isnan({f_7_24 : 0.9936762}))) && (! isnan(16.f)))
            b_1_5 = (((f_7_24 >= 16.f) && (!isnan(f_7_24))) && (!isnan(16.f)));
			// 1065247121  <=>  {ftou2(f_7_24) : 1065247121}
            u_8_1 = ftou2(f_7_24);
            u_8_phi_8 = u_8_1;
			// False  <=>  if(({b_1_5 : False} ? true : false))
            if ((b_1_5 ? true : false))
            {
				// 1031692689  <=>  {ftou2(({f_7_24 : 0.9936762} * 0.0625f)) : 1031692689}
                u_9_0 = ftou2((f_7_24 * 0.0625f));
				// 1031692689  <=>  {u_9_0 : 1031692689}
                u_8_2 = u_9_0;
                u_8_phi_8 = u_8_2;
            }
			// 1038480604  <=>  {ftou2(min(abs({utof2(u_4_phi_5) : -0.1122834}), abs({utof2(u_5_phi_5) : 0.9936762}))) : 1038480604}
            u_6_3 = ftou2(min(abs( utof2(u_4_phi_5)), abs( utof2(u_5_phi_5))));
            u_6_phi_9 = u_6_3;
			// False  <=>  if(({b_1_5 : False} ? true : false))
            if ((b_1_5 ? true : false))
            {
				// 1004926172  <=>  {ftou2((min(abs({utof2(u_4_phi_5) : -0.1122834}), abs({utof2(u_5_phi_5) : 0.9936762})) * 0.0625f)) : 1004926172}
                u_9_1 = ftou2((min(abs( utof2(u_4_phi_5)), abs( utof2(u_5_phi_5))) * 0.0625f));
				// 1004926172  <=>  {u_9_1 : 1004926172}
                u_6_4 = u_9_1;
                u_6_phi_9 = u_6_4;
            }
			// 0.1122834  <=>  abs({utof2(u_4_phi_5) : -0.1122834})
            f_9_23 = abs( utof2(u_4_phi_5));
			// 0.112998  <=>  ((1.0f / {utof2(u_8_phi_8) : 0.9936762}) * {utof2(u_6_phi_9) : 0.1122834})
            pf_9_5 = ((1.0f / utof2(u_8_phi_8)) * utof2(u_6_phi_9));
			// 11.34816  <=>  (({pf_9_5 : 0.112998} * {pf_9_5 : 0.112998}) + 11.335388f)
            pf_12_0 = ((pf_9_5 * pf_9_5) + 11.335388f);
			// -5.68538  <=>  ((({pf_9_5 : 0.112998} * {pf_9_5 : 0.112998}) * -0.82336295f) + (0.f - 5.674867f))
            pf_13_0 = (((pf_9_5 * pf_9_5) * -0.82336295f) + (0.f - 5.674867f));
			// 28.98737  <=>  ((({pf_9_5 : 0.112998} * {pf_9_5 : 0.112998}) * {pf_12_0 : 11.34816}) + 28.842468f)
            pf_12_1 = (((pf_9_5 * pf_9_5) * pf_12_0) + 28.842468f);
			// -6.638149  <=>  ((({pf_9_5 : 0.112998} * {pf_9_5 : 0.112998}) * {pf_13_0 : -5.68538}) + -6.565555f)
            pf_13_1 = (((pf_9_5 * pf_9_5) * pf_13_0) + -6.565555f);
			// 20.0668  <=>  ((({pf_9_5 : 0.112998} * {pf_9_5 : 0.112998}) * {pf_12_1 : 28.98737}) + 19.69667f)
            pf_12_2 = (((pf_9_5 * pf_9_5) * pf_12_1) + 19.69667f);
			// -0.0847595  <=>  (({pf_9_5 : 0.112998} * {pf_9_5 : 0.112998}) * {pf_13_1 : -6.638149})
            pf_10_3 = ((pf_9_5 * pf_9_5) * pf_13_1);
			// 0.1125207  <=>  ((({pf_9_5 : 0.112998} * {pf_10_3 : -0.0847595}) * (1.0f / {pf_12_2 : 20.0668})) + {pf_9_5 : 0.112998})
            pf_9_6 = (((pf_9_5 * pf_10_3) * (1.0f / pf_12_2)) + pf_9_5);
			// True  <=>  ((((abs({utof2(u_5_phi_5) : 0.9936762}) > {f_9_23 : 0.1122834}) && (! isnan(abs({utof2(u_5_phi_5) : 0.9936762})))) && (! isnan({f_9_23 : 0.1122834}))) ? true : false)
            b_3_2 = ((((abs( utof2(u_5_phi_5)) > f_9_23) && (!isnan(abs( utof2(u_5_phi_5))))) && (!isnan(f_9_23))) ? true : false);
			// 1038512451  <=>  {ftou2(pf_9_6) : 1038512451}
            u_6_5 = ftou2(pf_9_6);
            u_6_phi_10 = u_6_5;
			// True  <=>  if({b_3_2 : True})
            if (b_3_2)
            {
				// 1069197511  <=>  {ftou2(((0.f - {pf_9_6 : 0.1125207}) + 1.5707964f)) : 1069197511}
                u_6_6 = ftou2(((0.f - pf_9_6) + 1.5707964f));
                u_6_phi_10 = u_6_6;
            }
			// 1069197511  <=>  {u_6_phi_10 : 1069197511}
            u_5_5 = u_6_phi_10;
            u_5_phi_11 = u_5_5;
			// True  <=>  if((((({utof2(u_4_phi_5) : -0.1122834} < 0.f) && (! isnan({utof2(u_4_phi_5) : -0.1122834}))) && (! isnan(0.f))) ? true : false))
            if ((((( utof2(u_4_phi_5) < 0.f) && (!isnan( utof2(u_4_phi_5)))) && (!isnan(0.f))) ? true : false))
            {
				// 1071085295  <=>  {ftou2(((0.f - {utof2(u_6_phi_10) : 1.458276}) + 3.1415927f)) : 1071085295}
                u_5_6 = ftou2(((0.f - utof2(u_6_phi_10)) + 3.1415927f));
                u_5_phi_11 = u_5_6;
            }
			// 1071085295  <=>  {u_5_phi_11 : 1071085295}
            u_6_7 = u_5_phi_11;
            u_6_phi_12 = u_6_7;
			// False  <=>  if((((({utof2(u_5_phi_5) : 0.9936762} < 0.f) && (! isnan({utof2(u_5_phi_5) : 0.9936762}))) && (! isnan(0.f))) ? true : false))
            if ((((( utof2(u_5_phi_5) < 0.f) && (!isnan( utof2(u_5_phi_5)))) && (!isnan(0.f))) ? true : false))
            {
				// 3218568943  <=>  {ftou2(((0.f - {utof2(u_5_phi_11) : 1.683317}) + (0.f - 0.f))) : 3218568943}
                u_6_8 = ftou2(((0.f - utof2(u_5_phi_11)) + (0.f - 0.f)));
                u_6_phi_12 = u_6_8;
            }
			// 1071085295  <=>  {u_6_phi_12 : 1071085295}
            u_2_3 = u_6_phi_12;
            u_2_phi_7 = u_2_3;
        }
		// 1071085295  <=>  {u_2_phi_7 : 1071085295}
        u_3_3 = u_2_phi_7;
        u_3_phi_4 = u_3_3;
    }
	// 1.683317  <=>  ((((((0.f - {f_9_13 : 0.00}) + {f_7_11 : 1.00}) * {utof2(u_3_phi_4) : 1.683317}) * 57.295776f) + ((((0.f - {f_9_7 : 0.00}) + {f_7_8 : 1.00}) * -90.f) + 90.f)) * 0.017453292f)
    pf_8_3 = ((((((0.f - f_9_13) + f_7_11) * utof2(u_3_phi_4)) * 57.295776f) + ((((0.f - f_9_7) + f_7_8) * -90.f) + 90.f)) * 0.017453292f);
	// -1.23624  <=>  ((0.f - {i.fs_attr2.z : 1.73624}) + 0.5f)
    pf_9_11 = ((0.f - i.fs_attr2.z) + 0.5f);
	// 0.00  <=>  (((({i.fs_attr2.x : 0.03125} * 16.f) + (0.f - 0.5f)) * cos({pf_8_3 : 1.683317})) + (0.f - ((({i.fs_attr2.y : 0.03125} * 16.f) + (0.f - 0.5f)) * sin({pf_8_3 : 1.683317}))))
    pf_13_3 = ((((i.fs_attr2.x * 16.f) + (0.f - 0.5f)) * cos(pf_8_3)) + (0.f - (((i.fs_attr2.y * 16.f) + (0.f - 0.5f)) * sin(pf_8_3))));
	// 0.50  <=>  ((((({i.fs_attr2.x : 0.03125} * 16.f) + (0.f - 0.5f)) * sin({pf_8_3 : 1.683317})) + ((({i.fs_attr2.y : 0.03125} * 16.f) + (0.f - 0.5f)) * cos({pf_8_3 : 1.683317}))) + 0.5f)
    pf_10_8 = (((((i.fs_attr2.x * 16.f) + (0.f - 0.5f)) * sin(pf_8_3)) + (((i.fs_attr2.y * 16.f) + (0.f - 0.5f)) * cos(pf_8_3))) + 0.5f);
	// float2(-0.43286,0.976932)  <=>  float2(((({pf_13_3 : 0.00} + 0.5f) * 1.5f) + (0.00025f * {utof(fs_cbuf15_57.x) : -4731.44})), (({pf_10_8 : 0.50} * 1.5f) + (((0.f - {f_9_13 : 0.00}) + {f_7_11 : 1.00}) * (0.00025f * {utof(fs_cbuf15_57.y) : 907.7282}))))
    f2_0_2 = float2((((pf_13_3 + 0.5f) * 1.5f) + (0.00025f * utof(fs_cbuf15_57.x))), ((pf_10_8 * 1.5f) + (((0.f - f_9_13) + f_7_11) * (0.00025f * utof(fs_cbuf15_57.y)))));
	// 256  <=>  (uint({float4(textureQueryLod({tex4 : tex4}, {f2_0_2 : float2(-0.43286,0.976932)}), 0.0, 0.0).y : 1.00}) << 8u)
    u_1_5 = (uint(float4(textureQueryLod(tex4, f2_0_2), 0.0, 0.0).y) << 8u);
	// float2(-0.43286,0.976932)  <=>  float2(((({pf_13_3 : 0.00} + 0.5f) * 1.5f) + (0.00025f * {utof(fs_cbuf15_57.x) : -4731.44})), (({pf_10_8 : 0.50} * 1.5f) + (((0.f - {f_9_13 : 0.00}) + {f_7_11 : 1.00}) * (0.00025f * {utof(fs_cbuf15_57.y) : 907.7282}))))
    f2_0_3 = float2((((pf_13_3 + 0.5f) * 1.5f) + (0.00025f * utof(fs_cbuf15_57.x))), ((pf_10_8 * 1.5f) + (((0.f - f_9_13) + f_7_11) * (0.00025f * utof(fs_cbuf15_57.y)))));
	// float4(0.50,0.50,0.50,0.75)  <=>  textureLod({tex4 : tex4}, {f2_0_3 : float2(-0.43286,0.976932)}, min((float({u_1_5 : 256}) * 0.00390625f), 2.f))
    f4_0_3 = textureLod(tex4, f2_0_3, min((float(u_1_5) * 0.00390625f), 2.f));
	// 0.50  <=>  {f4_0_3.x : 0.50}
    f_9_29 = f4_0_3.x;
	// 0.50  <=>  {f4_0_3.y : 0.50}
    f_12_4 = f4_0_3.y;
	// float4(0.50,0.50,0.50,0.75)  <=>  textureLod({tex4 : tex4}, float2((({f_11_1 : 0.10} * -0.3f) + {i.fs_attr2.z : 1.73624}), (({f_11_1 : 0.10} * -0.3f) + {i.fs_attr2.w : 2.79527})), min((float({u_0_1 : 256}) * 0.00390625f), 2.f))
    f4_0_4 = textureLod(tex4, float2(((f_11_1 * -0.3f) + i.fs_attr2.z), ((f_11_1 * -0.3f) + i.fs_attr2.w)), min((float(u_0_1) * 0.00390625f), 2.f));
	// 0.50  <=>  {f4_0_4.x : 0.50}
    f_7_43 = f4_0_4.x;
	// 0.50  <=>  {f4_0_4.y : 0.50}
    f_13_20 = f4_0_4.y;
	// -2.29527  <=>  ((0.f - {i.fs_attr2.w : 2.79527}) + 0.5f)
    pf_5_4 = ((0.f - i.fs_attr2.w) + 0.5f);
	// 1.00  <=>  inversesqrt((({utof(fs_cbuf8_2.z) : 0.8242117} * {utof(fs_cbuf8_2.z) : 0.8242117}) + (({utof(fs_cbuf8_2.y) : 0.5585706} * {utof(fs_cbuf8_2.y) : 0.5585706}) + ({utof(fs_cbuf8_2.x) : -0.0931343} * {utof(fs_cbuf8_2.x) : -0.0931343}))))
    f_0_7 = inversesqrt((( utof(fs_cbuf8_2.z) * utof(fs_cbuf8_2.z)) + (( utof(fs_cbuf8_2.y) * utof(fs_cbuf8_2.y)) + ( utof(fs_cbuf8_2.x) * utof(fs_cbuf8_2.x)))));
	// 6.796554  <=>  (({pf_5_4 : -2.29527} * {pf_5_4 : -2.29527}) + ({pf_9_11 : -1.23624} * {pf_9_11 : -1.23624}))
    pf_5_5 = ((pf_5_4 * pf_5_4) + (pf_9_11 * pf_9_11));
	// 2.60702  <=>  sqrt({pf_5_5 : 6.796554})
    f_14_11 = sqrt(pf_5_5);
	// 0.00  <=>  (0.f - clamp(((({f_14_11 : 2.60702} * (0.f - {f_14_11 : 2.60702})) + {utof(fs_cbuf9_192.y) : -0.10}) + 1.f), 0.0, 1.0))
    f_14_13 = (0.f - clamp((((f_14_11 * (0.f - f_14_11)) + utof(fs_cbuf9_192.y)) + 1.f), 0.0, 1.0));
	// 0.509523  <=>  ((({f_0_7 : 1.00} * ((0.f - 0.f) + abs({utof(fs_cbuf8_2.y) : 0.5585706}))) + -0.1f) * 1.1111112f)
    pf_5_10 = (((f_0_7 * ((0.f - 0.f) + abs( utof(fs_cbuf8_2.y)))) + -0.1f) * 1.1111112f);
	// -0.9936762  <=>  sin((0.f - {pf_8_3 : 1.683317}))
    f_18_1 = sin((0.f - pf_8_3));
	// -0.1122833  <=>  cos((0.f - {pf_8_3 : 1.683317}))
    f_16_4 = cos((0.f - pf_8_3));
	// 1.00  <=>  ((clamp(({f_14_13 : 0.00} + 1.f), {utof(fs_cbuf9_191.w) : 0.01}, {utof(fs_cbuf9_192.x) : 0.20}) + (0.f - {utof(fs_cbuf9_191.w) : 0.01})) * (1.0f / ((0.f - {utof(fs_cbuf9_191.w) : 0.01}) + {utof(fs_cbuf9_192.x) : 0.20})))
    pf_6_4 = ((clamp((f_14_13 + 1.f), utof(fs_cbuf9_191.w), utof(fs_cbuf9_192.x)) + (0.f - utof(fs_cbuf9_191.w))) * (1.0f / ((0.f - utof(fs_cbuf9_191.w)) + utof(fs_cbuf9_192.x))));
	// 0.00  <=>  (((({f_16_4 : -0.1122833} * {f_9_29 : 0.50}) * 2.f) + (0.f - {f_16_4 : -0.1122833})) + ((({f_18_1 : -0.9936762} * (0.f - {f_12_4 : 0.50})) * 2.f) + {f_18_1 : -0.9936762}))
    pf_9_14 = ((((f_16_4 * f_9_29) * 2.f) + (0.f - f_16_4)) + (((f_18_1 * (0.f - f_12_4)) * 2.f) + f_18_1));
	// 0.00  <=>  (((({f_18_1 : -0.9936762} * {f_9_29 : 0.50}) * 2.f) + (0.f - {f_18_1 : -0.9936762})) + ((({f_16_4 : -0.1122833} * {f_12_4 : 0.50}) * 2.f) + (0.f - {f_16_4 : -0.1122833})))
    pf_8_6 = ((((f_18_1 * f_9_29) * 2.f) + (0.f - f_18_1)) + (((f_16_4 * f_12_4) * 2.f) + (0.f - f_16_4)));
	// 0.00  <=>  ((0.f - {pf_9_14 : 0.00}) + (({f_7_43 : 0.50} * 2.f) + (0.f - 1.f)))
    pf_11_5 = ((0.f - pf_9_14) + ((f_7_43 * 2.f) + (0.f - 1.f)));
	// 0.00  <=>  ((0.f - {pf_8_6 : 0.00}) + (({f_13_20 : 0.50} * 2.f) + (0.f - 1.f)))
    pf_12_9 = ((0.f - pf_8_6) + ((f_13_20 * 2.f) + (0.f - 1.f)));
	// 0.00  <=>  (({pf_11_5 : 0.00} * (0.f - ((clamp({pf_5_10 : 0.509523}, 0.0, 1.0) * clamp({pf_5_10 : 0.509523}, 0.0, 1.0)) * ((clamp({pf_5_10 : 0.509523}, 0.0, 1.0) * -2.f) + 3.f)))) + {pf_11_5 : 0.00})
    pf_11_6 = ((pf_11_5 * (0.f - ((clamp(pf_5_10, 0.0, 1.0) * clamp(pf_5_10, 0.0, 1.0)) * ((clamp(pf_5_10, 0.0, 1.0) * -2.f) + 3.f)))) + pf_11_5);
	// 0.00  <=>  (({pf_12_9 : 0.00} * (0.f - ((clamp({pf_5_10 : 0.509523}, 0.0, 1.0) * clamp({pf_5_10 : 0.509523}, 0.0, 1.0)) * ((clamp({pf_5_10 : 0.509523}, 0.0, 1.0) * -2.f) + 3.f)))) + {pf_12_9 : 0.00})
    pf_5_13 = ((pf_12_9 * (0.f - ((clamp(pf_5_10, 0.0, 1.0) * clamp(pf_5_10, 0.0, 1.0)) * ((clamp(pf_5_10, 0.0, 1.0) * -2.f) + 3.f)))) + pf_12_9);
	// 0.00  <=>  ({pf_8_6 : 0.00} + {pf_5_13 : 0.00})
    pf_5_14 = (pf_8_6 + pf_5_13);
	// 0.50  <=>  (({i.fs_attr21.x : 0.40625} * {utof(fs_cbuf9_78.z) : 16.00}) + (0.f - floor(({i.fs_attr21.x : 0.40625} * {utof(fs_cbuf9_78.z) : 16.00}))))
    pf_7_6 = ((i.fs_attr21.x * utof(fs_cbuf9_78.z)) + (0.f - floor((i.fs_attr21.x * utof(fs_cbuf9_78.z)))));
	// 0.50  <=>  (({i.fs_attr23.x : 0.40625} * {utof(fs_cbuf9_78.z) : 16.00}) + (0.f - floor(({i.fs_attr23.x : 0.40625} * {utof(fs_cbuf9_78.z) : 16.00}))))
    pf_6_6 = ((i.fs_attr23.x * utof(fs_cbuf9_78.z)) + (0.f - floor((i.fs_attr23.x * utof(fs_cbuf9_78.z)))));
	// 0.50  <=>  (({i.fs_attr20.x : 0.34375} * {utof(fs_cbuf9_78.z) : 16.00}) + (0.f - floor(({i.fs_attr20.x : 0.34375} * {utof(fs_cbuf9_78.z) : 16.00}))))
    pf_8_8 = ((i.fs_attr20.x * utof(fs_cbuf9_78.z)) + (0.f - floor((i.fs_attr20.x * utof(fs_cbuf9_78.z)))));
	// 0.50  <=>  (({i.fs_attr22.x : 0.34375} * {utof(fs_cbuf9_78.z) : 16.00}) + (0.f - floor(({i.fs_attr22.x : 0.34375} * {utof(fs_cbuf9_78.z) : 16.00}))))
    pf_10_13 = ((i.fs_attr22.x * utof(fs_cbuf9_78.z)) + (0.f - floor((i.fs_attr22.x * utof(fs_cbuf9_78.z)))));
	// 0.50  <=>  (((({pf_9_14 : 0.00} + {pf_11_6 : 0.00}) * ({f_11_1 : 0.10} * {pf_6_4 : 1.00})) * 0.5f) + {pf_8_8 : 0.50})
    pf_6_8 = ((((pf_9_14 + pf_11_6) * (f_11_1 * pf_6_4)) * 0.5f) + pf_8_8);
	// 6.50  <=>  (floor(({i.fs_attr23.x : 0.40625} * {utof(fs_cbuf9_78.z) : 16.00})) + clamp((((({pf_9_14 : 0.00} + {pf_11_6 : 0.00}) * ({f_11_1 : 0.10} * {pf_6_4 : 1.00})) * 0.5f) + {pf_6_6 : 0.50}), 0.0, 1.0))
    pf_7_8 = (floor((i.fs_attr23.x * utof(fs_cbuf9_78.z))) + clamp(((((pf_9_14 + pf_11_6) * (f_11_1 * pf_6_4)) * 0.5f) + pf_6_6), 0.0, 1.0));
	// 5.50  <=>  (floor(({i.fs_attr22.x : 0.34375} * {utof(fs_cbuf9_78.z) : 16.00})) + clamp((((({pf_9_14 : 0.00} + {pf_11_6 : 0.00}) * ({f_11_1 : 0.10} * {pf_6_4 : 1.00})) * 0.5f) + {pf_10_13 : 0.50}), 0.0, 1.0))
    pf_9_17 = (floor((i.fs_attr22.x * utof(fs_cbuf9_78.z))) + clamp(((((pf_9_14 + pf_11_6) * (f_11_1 * pf_6_4)) * 0.5f) + pf_10_13), 0.0, 1.0));
	// 6.50  <=>  (floor(({i.fs_attr21.x : 0.40625} * {utof(fs_cbuf9_78.z) : 16.00})) + clamp((((({pf_9_14 : 0.00} + {pf_11_6 : 0.00}) * ({f_11_1 : 0.10} * {pf_6_4 : 1.00})) * 0.5f) + {pf_7_6 : 0.50}), 0.0, 1.0))
    pf_10_14 = (floor((i.fs_attr21.x * utof(fs_cbuf9_78.z))) + clamp(((((pf_9_14 + pf_11_6) * (f_11_1 * pf_6_4)) * 0.5f) + pf_7_6), 0.0, 1.0));
	// 0.50  <=>  (({i.fs_attr23.y : 0.46875} * {utof(fs_cbuf9_78.w) : 16.00}) + (0.f - floor(({i.fs_attr23.y : 0.46875} * {utof(fs_cbuf9_78.w) : 16.00}))))
    pf_6_10 = ((i.fs_attr23.y * utof(fs_cbuf9_78.w)) + (0.f - floor((i.fs_attr23.y * utof(fs_cbuf9_78.w)))));
	// 7.50  <=>  (floor(({i.fs_attr23.y : 0.46875} * {utof(fs_cbuf9_78.w) : 16.00})) + clamp(((({pf_5_14 : 0.00} * ({f_11_1 : 0.10} * {pf_6_4 : 1.00})) * 0.5f) + {pf_6_10 : 0.50}), 0.0, 1.0))
    pf_6_12 = (floor((i.fs_attr23.y * utof(fs_cbuf9_78.w))) + clamp((((pf_5_14 * (f_11_1 * pf_6_4)) * 0.5f) + pf_6_10), 0.0, 1.0));
	// 0.50  <=>  (({i.fs_attr22.y : 0.46875} * {utof(fs_cbuf9_78.w) : 16.00}) + (0.f - floor(({i.fs_attr22.y : 0.46875} * {utof(fs_cbuf9_78.w) : 16.00}))))
    pf_11_9 = ((i.fs_attr22.y * utof(fs_cbuf9_78.w)) + (0.f - floor((i.fs_attr22.y * utof(fs_cbuf9_78.w)))));
	// 0.50  <=>  (({i.fs_attr21.y : 0.40625} * {utof(fs_cbuf9_78.w) : 16.00}) + (0.f - floor(({i.fs_attr21.y : 0.40625} * {utof(fs_cbuf9_78.w) : 16.00}))))
    pf_12_11 = ((i.fs_attr21.y * utof(fs_cbuf9_78.w)) + (0.f - floor((i.fs_attr21.y * utof(fs_cbuf9_78.w)))));
	// 0.50  <=>  (({i.fs_attr20.y : 0.40625} * {utof(fs_cbuf9_78.w) : 16.00}) + (0.f - floor(({i.fs_attr20.y : 0.40625} * {utof(fs_cbuf9_78.w) : 16.00}))))
    pf_13_7 = ((i.fs_attr20.y * utof(fs_cbuf9_78.w)) + (0.f - floor((i.fs_attr20.y * utof(fs_cbuf9_78.w)))));
	// 0.50  <=>  clamp(((({pf_5_14 : 0.00} * ({f_11_1 : 0.10} * {pf_6_4 : 1.00})) * 0.5f) + {pf_13_7 : 0.50}), 0.0, 1.0)
    f_13_24 = clamp((((pf_5_14 * (f_11_1 * pf_6_4)) * 0.5f) + pf_13_7), 0.0, 1.0);
	// 7.50  <=>  (floor(({i.fs_attr22.y : 0.46875} * {utof(fs_cbuf9_78.w) : 16.00})) + clamp(((({pf_5_14 : 0.00} * ({f_11_1 : 0.10} * {pf_6_4 : 1.00})) * 0.5f) + {pf_11_9 : 0.50}), 0.0, 1.0))
    pf_5_17 = (floor((i.fs_attr22.y * utof(fs_cbuf9_78.w))) + clamp((((pf_5_14 * (f_11_1 * pf_6_4)) * 0.5f) + pf_11_9), 0.0, 1.0));
	// 6.50  <=>  (floor(({i.fs_attr21.y : 0.40625} * {utof(fs_cbuf9_78.w) : 16.00})) + clamp(((({pf_5_14 : 0.00} * ({f_11_1 : 0.10} * {pf_6_4 : 1.00})) * 0.5f) + {pf_12_11 : 0.50}), 0.0, 1.0))
    pf_11_12 = (floor((i.fs_attr21.y * utof(fs_cbuf9_78.w))) + clamp((((pf_5_14 * (f_11_1 * pf_6_4)) * 0.5f) + pf_12_11), 0.0, 1.0));
	// 0.34375  <=>  ((1.0f / {utof(fs_cbuf9_78.z) : 16.00}) * {pf_9_17 : 5.50})
    pf_9_18 = ((1.0f / utof(fs_cbuf9_78.z)) * pf_9_17);
	// float4(4.00,1.00,0.00,0.00)  <=>  float4(textureQueryLod({tex3 : tex3}, float2(((1.0f / {utof(fs_cbuf9_78.z) : 16.00}) * {pf_7_8 : 6.50}), ((1.0f / {utof(fs_cbuf9_78.w) : 16.00}) * {pf_6_12 : 7.50}))), 0.0, 0.0)
    f4_0_5 = float4(textureQueryLod(tex3, float2(((1.0f / utof(fs_cbuf9_78.z)) * pf_7_8), ((1.0f / utof(fs_cbuf9_78.w)) * pf_6_12))), 0.0, 0.0);
	// 256  <=>  (uint({f4_0_5.y : 1.00}) << 8u)
    u_0_3 = (uint(f4_0_5.y) << 8u);
	// 0.40625  <=>  ((1.0f / {utof(fs_cbuf9_78.w) : 16.00}) * (floor(({i.fs_attr20.y : 0.40625} * {utof(fs_cbuf9_78.w) : 16.00})) + {f_13_24 : 0.50}))
    pf_12_13 = ((1.0f / utof(fs_cbuf9_78.w)) * (floor((i.fs_attr20.y * utof(fs_cbuf9_78.w))) + f_13_24));
	// float4(4.00,1.00,0.00,0.00)  <=>  float4(textureQueryLod({tex3 : tex3}, float2({pf_9_18 : 0.34375}, ((1.0f / {utof(fs_cbuf9_78.w) : 16.00}) * {pf_5_17 : 7.50}))), 0.0, 0.0)
    f4_0_6 = float4(textureQueryLod(tex3, float2(pf_9_18, ((1.0f / utof(fs_cbuf9_78.w)) * pf_5_17))), 0.0, 0.0);
	// 1.00  <=>  {f4_0_6.y : 1.00}
    f_7_52 = f4_0_6.y;
	// 0.34375  <=>  ((1.0f / {utof(fs_cbuf9_78.z) : 16.00}) * (floor(({i.fs_attr20.x : 0.34375} * {utof(fs_cbuf9_78.z) : 16.00})) + clamp({pf_6_8 : 0.50}, 0.0, 1.0)))
    pf_8_11 = ((1.0f / utof(fs_cbuf9_78.z)) * (floor((i.fs_attr20.x * utof(fs_cbuf9_78.z))) + clamp(pf_6_8, 0.0, 1.0)));
	// float4(4.00,1.00,0.00,0.00)  <=>  float4(textureQueryLod({tex3 : tex3}, float2(((1.0f / {utof(fs_cbuf9_78.z) : 16.00}) * {pf_10_14 : 6.50}), ((1.0f / {utof(fs_cbuf9_78.w) : 16.00}) * {pf_11_12 : 6.50}))), 0.0, 0.0)
    f4_0_7 = float4(textureQueryLod(tex3, float2(((1.0f / utof(fs_cbuf9_78.z)) * pf_10_14), ((1.0f / utof(fs_cbuf9_78.w)) * pf_11_12))), 0.0, 0.0);
	// 256  <=>  (uint({f4_0_7.y : 1.00}) << 8u)
    u_2_5 = (uint(f4_0_7.y) << 8u);
	// 256  <=>  (uint({float4(textureQueryLod({tex3 : tex3}, float2({pf_8_11 : 0.34375}, {pf_12_13 : 0.40625})), 0.0, 0.0).y : 1.00}) << 8u)
    u_3_5 = (uint(float4(textureQueryLod(tex3, float2(pf_8_11, pf_12_13)), 0.0, 0.0).y) << 8u);
	// float4(0.50,0.50,0.50,0.75)  <=>  textureLod({tex3 : tex3}, float2(((1.0f / {utof(fs_cbuf9_78.z) : 16.00}) * {pf_7_8 : 6.50}), ((1.0f / {utof(fs_cbuf9_78.w) : 16.00}) * {pf_6_12 : 7.50})), max((float({u_0_3 : 256}) * 0.00390625f), {i.fs_attr12.w : 0.78952}))
    f4_0_9 = textureLod(tex3, float2(((1.0f / utof(fs_cbuf9_78.z)) * pf_7_8), ((1.0f / utof(fs_cbuf9_78.w)) * pf_6_12)), max((float(u_0_3) * 0.00390625f), i.fs_attr12.w));
	// 1.00  <=>  max({i.fs_attr12.w : 0.78952}, (float((uint({f_7_52 : 1.00}) << 8u)) * 0.00390625f))
    f_11_9 = max(i.fs_attr12.w, (float((uint(f_7_52) << 8u)) * 0.00390625f));
	// float4(0.50,0.50,0.50,0.75)  <=>  textureLod({tex3 : tex3}, float2({pf_9_18 : 0.34375}, ((1.0f / {utof(fs_cbuf9_78.w) : 16.00}) * {pf_5_17 : 7.50})), {f_11_9 : 1.00})
    f4_0_10 = textureLod(tex3, float2(pf_9_18, ((1.0f / utof(fs_cbuf9_78.w)) * pf_5_17)), f_11_9);
	// 0.75  <=>  {f4_0_10.w : 0.75}
    f_12_9 = f4_0_10.w;
	// float4(0.50,0.50,0.50,0.75)  <=>  textureLod({tex3 : tex3}, float2(((1.0f / {utof(fs_cbuf9_78.z) : 16.00}) * {pf_10_14 : 6.50}), ((1.0f / {utof(fs_cbuf9_78.w) : 16.00}) * {pf_11_12 : 6.50})), max({i.fs_attr12.w : 0.78952}, (float({u_2_5 : 256}) * 0.00390625f)))
    f4_0_11 = textureLod(tex3, float2(((1.0f / utof(fs_cbuf9_78.z)) * pf_10_14), ((1.0f / utof(fs_cbuf9_78.w)) * pf_11_12)), max(i.fs_attr12.w, (float(u_2_5) * 0.00390625f)));
	// float4(0.50,0.50,0.50,0.75)  <=>  textureLod({tex3 : tex3}, float2({pf_8_11 : 0.34375}, {pf_12_13 : 0.40625}), max({i.fs_attr12.w : 0.78952}, (float({u_3_5 : 256}) * 0.00390625f)))
    f4_0_12 = textureLod(tex3, float2(pf_8_11, pf_12_13), max(i.fs_attr12.w, (float(u_3_5) * 0.00390625f)));
	// 0.50  <=>  {f4_0_12.x : 0.50}
    f_0_29 = f4_0_12.x;
	// 0.75  <=>  {f4_0_12.w : 0.75}
    f_15_5 = f4_0_12.w;
	// -232.7016  <=>  ((0.f - {f_1_4 : 520.0128}) + {utof(camera_wpos.x) : 287.3111})
    pf_5_19 = ((0.f - f_1_4) + utof(camera_wpos.x));
	// 112.5713  <=>  ((0.f - {f_2_3 : 1559.572}) + {utof(camera_wpos.y) : 1672.144})
    pf_6_14 = ((0.f - f_2_3) + utof(camera_wpos.y));
	// 0.0020212  <=>  inversesqrt((({pf_4_0 : 421.8577} * {pf_4_0 : 421.8577}) + {pf_1_4 : 66822.34}))
    f_17_6 = inversesqrt(((pf_4_0 * pf_4_0) + pf_1_4));
	// 66822.34  <=>  (({pf_6_14 : 112.5713} * {pf_6_14 : 112.5713}) + ({pf_5_19 : -232.7016} * {pf_5_19 : -232.7016}))
    pf_1_7 = ((pf_6_14 * pf_6_14) + (pf_5_19 * pf_5_19));
	// 421.8577  <=>  ((0.f - {i.fs_attr9.z : 974.8118}) + {utof(camera_wpos.z) : 1396.669})
    pf_7_10 = ((0.f - i.fs_attr9.z) + utof(camera_wpos.z));
	// -0.2458242  <=>  (({pf_2_0 : -232.7016} * {f_17_6 : 0.0020212}) * {utof(fs_cbuf15_28.x) : 0.5226594})
    pf_2_2 = ((pf_2_0 * f_17_6) * utof(fs_cbuf15_28.x));
	// 0.0020212  <=>  inversesqrt((({pf_7_10 : 421.8577} * {pf_7_10 : 421.8577}) + {pf_1_7 : 66822.34}))
    f_19_3 = inversesqrt(((pf_7_10 * pf_7_10) + pf_1_7));
	// -0.3764481  <=>  ((({pf_3_0 : 112.5713} * {f_17_6 : 0.0020212}) * {utof(fs_cbuf15_28.y) : -0.5741013}) + {pf_2_2 : -0.2458242})
    pf_2_3 = (((pf_3_0 * f_17_6) * utof(fs_cbuf15_28.y)) + pf_2_2);
	// -0.9138463  <=>  ((({pf_4_0 : 421.8577} * {f_17_6 : 0.0020212}) * {utof(fs_cbuf15_28.z) : -0.6302658}) + {pf_2_3 : -0.3764481})
    pf_1_10 = (((pf_4_0 * f_17_6) * utof(fs_cbuf15_28.z)) + pf_2_3);
	// 1.00  <=>  max(0.f, ({i.fs_attr6.w : 1.00} * ((0.f - {i.fs_attr6.w : 1.00}) + 2.f)))
    f_17_12 = max(0.f, (i.fs_attr6.w * ((0.f - i.fs_attr6.w) + 2.f)));
	// 1.00  <=>  sqrt({f_17_12 : 1.00})
    f_17_13 = sqrt(f_17_12);
	// 0.00  <=>  ((((0.f - {f_2_3 : 1559.572}) + {f_6_0 : 1559.572}) * ({pf_6_14 : 112.5713} * {f_19_3 : 0.0020212})) + (((0.f - {f_1_4 : 520.0128}) + {f_5_0 : 520.0128}) * ({pf_5_19 : -232.7016} * {f_19_3 : 0.0020212})))
    pf_5_22 = ((((0.f - f_2_3) + f_6_0) * (pf_6_14 * f_19_3)) + (((0.f - f_1_4) + f_5_0) * (pf_5_19 * f_19_3)));
	// 0.00  <=>  ((((0.f - {i.fs_attr9.z : 974.8118}) + {f_8_0 : 974.8118}) * ({pf_7_10 : 421.8577} * {f_19_3 : 0.0020212})) + {pf_5_22 : 0.00})
    pf_4_4 = ((((0.f - i.fs_attr9.z) + f_8_0) * (pf_7_10 * f_19_3)) + pf_5_22);
	// 35.95715  <=>  ({i.fs_attr8.y : 89.89288} * 0.4f)
    pf_8_13 = (i.fs_attr8.y * 0.4f);
	// 1005.471  <=>  ((({pf_7_10 : 421.8577} * {f_19_3 : 0.0020212}) * (({pf_8_13 : 35.95715} * {f_17_13 : 1.00}) + (0.f - {pf_4_4 : 0.00}))) + {f_8_0 : 974.8118})
    pf_4_6 = (((pf_7_10 * f_19_3) * ((pf_8_13 * f_17_13) + (0.f - pf_4_4))) + f_8_0);
	// -503.1009  <=>  (0.f - ((({pf_5_19 : -232.7016} * {f_19_3 : 0.0020212}) * (({pf_8_13 : 35.95715} * {f_17_13 : 1.00}) + (0.f - {pf_4_4 : 0.00}))) + {f_5_0 : 520.0128}))
    f_17_15 = (0.f - (((pf_5_19 * f_19_3) * ((pf_8_13 * f_17_13) + (0.f - pf_4_4))) + f_5_0));
	// -1567.754  <=>  (0.f - ((({pf_6_14 : 112.5713} * {f_19_3 : 0.0020212}) * (({pf_8_13 : 35.95715} * {f_17_13 : 1.00}) + (0.f - {pf_4_4 : 0.00}))) + {f_6_0 : 1559.572}))
    f_1_5 = (0.f - (((pf_6_14 * f_19_3) * ((pf_8_13 * f_17_13) + (0.f - pf_4_4))) + f_6_0));
	// -1005.471  <=>  (0.f - {pf_4_6 : 1005.471})
    f_1_6 = (0.f - pf_4_6);
	// -1567.754  <=>  (0.f - ((({pf_6_14 : 112.5713} * {f_19_3 : 0.0020212}) * (({pf_8_13 : 35.95715} * {f_17_13 : 1.00}) + (0.f - {pf_4_4 : 0.00}))) + {f_6_0 : 1559.572}))
    f_2_4 = (0.f - (((pf_6_14 * f_19_3) * ((pf_8_13 * f_17_13) + (0.f - pf_4_4))) + f_6_0));
	// 13.53603  <=>  ((({f_2_3 : 1559.572} + {f_1_5 : -1567.754}) * {utof(fs_cbuf15_28.y) : -0.5741013}) + (({f_1_4 : 520.0128} + {f_17_15 : -503.1009}) * {utof(fs_cbuf15_28.x) : 0.5226594}))
    pf_2_8 = (((f_2_3 + f_1_5) * utof(fs_cbuf15_28.y)) + ((f_1_4 + f_17_15) * utof(fs_cbuf15_28.x)));
	// 0  <=>  (isnan({i.fs_attr4.w : 0.00}) ? 0u : uint(clamp(trunc({i.fs_attr4.w : 0.00}), float(-2147483600.f), float(2147483600.f))))
    u_0_5 = (isnan(i.fs_attr4.w) ? 0u : uint(clamp(trunc(i.fs_attr4.w), float(-2147483600.f), float(2147483600.f))));
	// -1.843657  <=>  (((((({i.fs_attr9.z : 974.8118} + {f_1_6 : -1005.471}) * {utof(fs_cbuf15_28.z) : -0.6302658}) + {pf_2_8 : 13.53603}) * -1.5f) + ({f_2_4 : -1567.754} + {utof(fs_cbuf10_9.w) : 1550.75})) * (1.0f / {pf_8_13 : 35.95715}))
    pf_6_19 = ((((((i.fs_attr9.z + f_1_6) * utof(fs_cbuf15_28.z)) + pf_2_8) * -1.5f) + (f_2_4 + utof(fs_cbuf10_9.w))) * (1.0f / pf_8_13));
	// 0  <=>  0u
    u_0_6 = 0u;
    u_0_phi_13 = u_0_6;
	// False  <=>  if((({u_0_5 : 0} != 0u) ? true : false))
    if (((u_0_5 != 0u) ? true : false))
    {
		// 18.23724  <=>  ((0.f - {f_5_0 : 520.0128}) + {utof(fs_cbuf16_10.x) : 538.25})
        pf_11_14 = ((0.f - f_5_0) + utof(fs_cbuf16_10.x));
		// -8.822388  <=>  ((0.f - {f_6_0 : 1559.572}) + {utof(fs_cbuf16_10.y) : 1550.75})
        pf_12_14 = ((0.f - f_6_0) + utof(fs_cbuf16_10.y));
		// 250.9389  <=>  ({utof(fs_cbuf16_10.x) : 538.25} + (0.f - {utof(camera_wpos.x) : 287.3111}))
        pf_14_1 = ( utof(fs_cbuf16_10.x) + (0.f - utof(camera_wpos.x)));
		// -121.3937  <=>  ({utof(fs_cbuf16_10.y) : 1550.75} + (0.f - {utof(camera_wpos.y) : 1672.144}))
        pf_15_1 = ( utof(fs_cbuf16_10.y) + (0.f - utof(camera_wpos.y)));
		// -454.9194  <=>  ({utof(fs_cbuf16_10.z) : 941.75} + (0.f - {utof(camera_wpos.z) : 1396.669}))
        pf_16_0 = ( utof(fs_cbuf16_10.z) + (0.f - utof(camera_wpos.z)));
		// 77706.74  <=>  (({pf_15_1 : -121.3937} * {pf_15_1 : -121.3937}) + ({pf_14_1 : 250.9389} * {pf_14_1 : 250.9389}))
        pf_17_1 = ((pf_15_1 * pf_15_1) + (pf_14_1 * pf_14_1));
		// 0.0018743  <=>  inversesqrt((({pf_16_0 : -454.9194} * {pf_16_0 : -454.9194}) + {pf_17_1 : 77706.74}))
        f_1_21 = inversesqrt(((pf_16_0 * pf_16_0) + pf_17_1));
		// 0.4703335  <=>  ({pf_14_1 : 250.9389} * {f_1_21 : 0.0018743})
        pf_14_2 = (pf_14_1 * f_1_21);
		// 8.577586  <=>  ({pf_14_2 : 0.4703335} * {pf_11_14 : 18.23724})
        pf_17_3 = (pf_14_2 * pf_11_14);
		// 10.58492  <=>  ((({pf_15_1 : -121.3937} * {f_1_21 : 0.0018743}) * {pf_12_14 : -8.822388}) + {pf_17_3 : 8.577586})
        pf_17_4 = (((pf_15_1 * f_1_21) * pf_12_14) + pf_17_3);
		// 38.77515  <=>  ((({pf_16_0 : -454.9194} * {f_1_21 : 0.0018743}) * ((0.f - {f_8_0 : 974.8118}) + {utof(fs_cbuf16_10.z) : 941.75})) + {pf_17_4 : 10.58492})
        pf_17_5 = (((pf_16_0 * f_1_21) * ((0.f - f_8_0) + utof(fs_cbuf16_10.z))) + pf_17_4);
		// -0.0000062  <=>  (({pf_14_2 : 0.4703335} * (0.f - {pf_17_5 : 38.77515})) + {pf_11_14 : 18.23724})
        pf_11_15 = ((pf_14_2 * (0.f - pf_17_5)) + pf_11_14);
		// 0.0000273  <=>  ((({pf_15_1 : -121.3937} * {f_1_21 : 0.0018743}) * (0.f - {pf_17_5 : 38.77515})) + {pf_12_14 : -8.822388})
        pf_12_15 = (((pf_15_1 * f_1_21) * (0.f - pf_17_5)) + pf_12_14);
		// -0.0000123  <=>  ((({pf_16_0 : -454.9194} * {f_1_21 : 0.0018743}) * (0.f - {pf_17_5 : 38.77515})) + ((0.f - {f_8_0 : 974.8118}) + {utof(fs_cbuf16_10.z) : 941.75}))
        pf_13_11 = (((pf_16_0 * f_1_21) * (0.f - pf_17_5)) + ((0.f - f_8_0) + utof(fs_cbuf16_10.z)));
		// 0.00  <=>  (({pf_13_11 : -0.0000123} * {pf_13_11 : -0.0000123}) + (({pf_12_15 : 0.0000273} * {pf_12_15 : 0.0000273}) + ({pf_11_15 : -0.0000062} * {pf_11_15 : -0.0000062})))
        pf_11_18 = ((pf_13_11 * pf_13_11) + ((pf_12_15 * pf_12_15) + (pf_11_15 * pf_11_15)));
		// 0.0000306  <=>  sqrt({pf_11_18 : 0.00})
        f_3_15 = sqrt(pf_11_18);
		// 1.00  <=>  clamp(((((1.0f / {utof(fs_cbuf16_7.w) : 39.37191}) * {f_3_15 : 0.0000306}) * -1.4285715f) + 1.4285715f), 0.0, 1.0)
        f_1_27 = clamp(((((1.0f / utof(fs_cbuf16_7.w)) * f_3_15) * -1.4285715f) + 1.4285715f), 0.0, 1.0);
		// 1065353216  <=>  {ftou2(((({f_1_27 : 1.00} * -2.f) + 3.f) * ({f_1_27 : 1.00} * {f_1_27 : 1.00}))) : 1065353216}
        u_0_7 = ftou2((((f_1_27 * -2.f) + 3.f) * (f_1_27 * f_1_27)));
        u_0_phi_13 = u_0_7;
    }
	// 0.00  <=>  (((({f4_0_9.w : 0.75} + (0.f - {f_12_9 : 0.75})) * {i.fs_attr18.x : 0.90504}) + {f_12_9 : 0.75}) + (0.f - (({i.fs_attr18.x : 0.90504} * ((0.f - {f_15_5 : 0.75}) + {f4_0_11.w : 0.75})) + {f_15_5 : 0.75})))
    pf_5_25 = ((((f4_0_9.w + (0.f - f_12_9)) * i.fs_attr18.x) + f_12_9) + (0.f - ((i.fs_attr18.x * ((0.f - f_15_5) + f4_0_11.w)) + f_15_5)));
	// 0.75  <=>  (({pf_5_25 : 0.00} * {i.fs_attr19.x : 0.40417}) + (({i.fs_attr18.x : 0.90504} * ((0.f - {f_15_5 : 0.75}) + {f4_0_11.w : 0.75})) + {f_15_5 : 0.75}))
    pf_5_26 = ((pf_5_25 * i.fs_attr19.x) + ((i.fs_attr18.x * ((0.f - f_15_5) + f4_0_11.w)) + f_15_5));
	// 0.00  <=>  ({f4_0_9.x : 0.50} + (0.f - {f4_0_10.x : 0.50}))
    pf_7_14 = (f4_0_9.x + (0.f - f4_0_10.x));
	// 0.7198451  <=>  (((0.f - {i.fs_attr15.x : 0.26314}) + clamp({pf_5_26 : 0.75}, {i.fs_attr15.x : 0.26314}, {i.fs_attr15.y : 0.93948})) * (1.0f / ({i.fs_attr15.y : 0.93948} + (0.f - {i.fs_attr15.x : 0.26314}))))
    pf_11_25 = (((0.f - i.fs_attr15.x) + clamp(pf_5_26, i.fs_attr15.x, i.fs_attr15.y)) * (1.0f / (i.fs_attr15.y + (0.f - i.fs_attr15.x))));
	// 0.7198451  <=>  ({pf_11_25 : 0.7198451} * {i.fs_attr0.w : 1.00})
    pf_11_26 = (pf_11_25 * i.fs_attr0.w);
	// 0.6429225  <=>  ({pf_0_14 : 0.89314} * {pf_11_26 : 0.7198451})
    pf_11_27 = (pf_0_14 * pf_11_26);
	// 0.0321461  <=>  (clamp((min({i.fs_attr6.w : 1.00}, 0.05f) + (0.f - 0.f)), 0.0, 1.0) * {pf_11_27 : 0.6429225})
    pf_11_28 = (clamp((min(i.fs_attr6.w, 0.05f) + (0.f - 0.f)), 0.0, 1.0) * pf_11_27);
	// 0.6429225  <=>  (clamp(({pf_11_28 : 0.0321461} * 20.f), 0.0, 1.0) * {i.fs_attr5.x : 1.00})
    pf_11_30 = (clamp((pf_11_28 * 20.f), 0.0, 1.0) * i.fs_attr5.x);
	// False  <=>  ((({pf_11_30 : 0.6429225} <= {utof(fs_cbuf9_139.z) : 0.00}) && (! isnan({pf_11_30 : 0.6429225}))) && (! isnan({utof(fs_cbuf9_139.z) : 0.00})))
    b_0_17 = (((pf_11_30 <= utof(fs_cbuf9_139.z)) && (!isnan(pf_11_30))) && (!isnan( utof(fs_cbuf9_139.z))));
	// 0.3731479  <=>  exp2((((({i.fs_attr9.z : 974.8118} + {f_1_6 : -1005.471}) * {utof(fs_cbuf15_28.z) : -0.6302658}) + {pf_2_8 : 13.53603}) * -0.04328085f))
    f_1_35 = exp2(((((i.fs_attr9.z + f_1_6) * utof(fs_cbuf15_28.z)) + pf_2_8) * -0.04328085f));
	// False  <=>  if(({b_0_17 : False} ? true : false))
    if ((b_0_17 ? true : false))
    {
        discard;
    }
	// 0.00  <=>  ((0.f - {f_0_29 : 0.50}) + {f4_0_11.x : 0.50})
    pf_2_11 = ((0.f - f_0_29) + f4_0_11.x);
	// 0.50  <=>  (({i.fs_attr18.x : 0.90504} * {pf_2_11 : 0.00}) + {f_0_29 : 0.50})
    pf_1_12 = ((i.fs_attr18.x * pf_2_11) + f_0_29);
	// 0.6429225  <=>  clamp(({pf_11_30 : 0.6429225} + (0.f - 0.f)), 0.0, 1.0)
    f_0_32 = clamp((pf_11_30 + (0.f - 0.f)), 0.0, 1.0);
	// 0.00  <=>  max(0.f, ((0.f - {i.fs_attr6.w : 1.00}) + 0.9f))
    f_2_7 = max(0.f, ((0.f - i.fs_attr6.w) + 0.9f));
	// 0.00  <=>  (({i.fs_attr8.y : 89.89288} * clamp((({pf_1_10 : -0.9138463} * 3.3333333f) + (0.f - 2.3333333f)), 0.0, 1.0)) * 0.005f)
    pf_2_13 = ((i.fs_attr8.y * clamp(((pf_1_10 * 3.3333333f) + (0.f - 2.3333333f)), 0.0, 1.0)) * 0.005f);
	// 0.50  <=>  ((((({pf_7_14 : 0.00} * {i.fs_attr18.x : 0.90504}) + {f4_0_10.x : 0.50}) + (0.f - {pf_1_12 : 0.50})) * {i.fs_attr19.x : 0.40417}) + {pf_1_12 : 0.50})
    pf_1_13 = (((((pf_7_14 * i.fs_attr18.x) + f4_0_10.x) + (0.f - pf_1_12)) * i.fs_attr19.x) + pf_1_12);
	// 0.626852  <=>  max(0.f, min((((0.f - {f_1_35 : 0.3731479}) + {utof(fs_cbuf9_189.w) : 0.00}) + 1.f), 0.8f))
    f_4_3 = max(0.f, min((((0.f - f_1_35) + utof(fs_cbuf9_189.w)) + 1.f), 0.8f));
	// 1.00  <=>  ((0.f - clamp((({pf_1_10 : -0.9138463} * 3.3333333f) + (0.f - 2.3333333f)), 0.0, 1.0)) + 1.f)
    pf_7_17 = ((0.f - clamp(((pf_1_10 * 3.3333333f) + (0.f - 2.3333333f)), 0.0, 1.0)) + 1.f);
	// NaN  <=>  (((1.0f / {pf_2_13 : 0.00}) * ({pf_5_26 : 0.75} + {pf_2_13 : 0.00})) + (0.f - (1.0f / {pf_2_13 : 0.00})))
    pf_2_15 = (((1.0f / pf_2_13) * (pf_5_26 + pf_2_13)) + (0.f - (1.0f / pf_2_13)));
	// 0.3034236  <=>  ((1.f + (0.f - {utof(fs_cbuf15_1.x) : 0.00})) * ((((0.f - {utof(fs_cbuf9_189.z) : 0.30}) + 0.6f) * ({i.fs_attr12.y : 0.22514} * ({i.fs_attr12.y : 0.22514} * {i.fs_attr12.y : 0.22514}))) + {utof(fs_cbuf9_189.z) : 0.30}))
    pf_4_10 = ((1.f + (0.f - utof(fs_cbuf15_1.x))) * ((((0.f - utof(fs_cbuf9_189.z)) + 0.6f) * (i.fs_attr12.y * (i.fs_attr12.y * i.fs_attr12.y))) + utof(fs_cbuf9_189.z)));
	// 0.2282125  <=>  exp2((((({utof(fs_cbuf9_189.y) : 2.50} + -1.5f) * {i.fs_attr15.z : 0.63155}) + 1.5f) * log2(abs({pf_1_13 : 0.50}))))
    f_4_8 = exp2((((( utof(fs_cbuf9_189.y) + -1.5f) * i.fs_attr15.z) + 1.5f) * log2(abs(pf_1_13))));
	// 1.00  <=>  (clamp({pf_2_15 : NaN}, 0.0, 1.0) + ((clamp({pf_2_15 : NaN}, 0.0, 1.0) * (0.f - {pf_7_17 : 1.00})) + {pf_7_17 : 1.00}))
    pf_7_19 = (clamp(pf_2_15, 0.0, 1.0) + ((clamp(pf_2_15, 0.0, 1.0) * (0.f - pf_7_17)) + pf_7_17));
	// -1.00  <=>  (0.f - {utof2((((({f_4_3 : 0.626852} >= 0.5f) && (! isnan({f_4_3 : 0.626852}))) && (! isnan(0.5f))) ? 1065353216u : 0u)) : 1.00})
    f_5_5 = (0.f - utof2(((((f_4_3 >= 0.5f) && (!isnan(f_4_3))) && (!isnan(0.5f))) ? 1065353216u : 0u)));
	// 0.00  <=>  (((((({pf_1_13 : 0.50} * (0.f - {f_4_3 : 0.626852})) + ({pf_1_13 : 0.50} + {f_4_3 : 0.626852})) * 2.f) + (0.f - (({pf_1_13 : 0.50} * 2.f) * {f_4_3 : 0.626852}))) * {utof2((((({f_4_3 : 0.626852} >= 0.5f) && (! isnan({f_4_3 : 0.626852}))) && (! isnan(0.5f))) ? 1065353216u : 0u)) : 1.00}) + {f_5_5 : -1.00})
    pf_5_30 = ((((((pf_1_13 * (0.f - f_4_3)) + (pf_1_13 + f_4_3)) * 2.f) + (0.f - ((pf_1_13 * 2.f) * f_4_3))) * utof2(((((f_4_3 >= 0.5f) && (!isnan(f_4_3))) && (!isnan(0.5f))) ? 1065353216u : 0u))) + f_5_5);
	// 0.626852  <=>  ((({pf_1_13 : 0.50} * 2.f) * {f_4_3 : 0.626852}) + {pf_5_30 : 0.00})
    pf_2_17 = (((pf_1_13 * 2.f) * f_4_3) + pf_5_30);
	// 1.05  <=>  ((0.f - clamp((({pf_1_10 : -0.9138463} * 3.3333333f) + (0.f - 2.3333333f)), 0.0, 1.0)) + 1.05f)
    pf_7_20 = ((0.f - clamp(((pf_1_10 * 3.3333333f) + (0.f - 2.3333333f)), 0.0, 1.0)) + 1.05f);
	// -1.518002  <=>  log2(abs((({pf_4_10 : 0.3034236} * ({pf_2_17 : 0.626852} + (0.f - {f_4_8 : 0.2282125}))) + {f_4_8 : 0.2282125})))
    f_5_7 = log2(abs(((pf_4_10 * (pf_2_17 + (0.f - f_4_8))) + f_4_8)));
	// 0.1137638  <=>  max(0.f, (({pf_3_0 : 112.5713} * {f_17_6 : 0.0020212}) * 0.5f))
    f_3_26 = max(0.f, ((pf_3_0 * f_17_6) * 0.5f));
	// 0.00  <=>  ((clamp((({pf_1_10 : -0.9138463} * 3.3333333f) + (0.f - 2.3333333f)), 0.0, 1.0) * {pf_7_19 : 1.00}) * max(0.f, (exp2(({pf_7_19 : 1.00} * -5.f)) + -0.03125f)))
    pf_3_3 = ((clamp(((pf_1_10 * 3.3333333f) + (0.f - 2.3333333f)), 0.0, 1.0) * pf_7_19) * max(0.f, (exp2((pf_7_19 * -5.f)) + -0.03125f)));
	// 0.0874529  <=>  exp2(((({i.fs_attr15.z : 0.63155} * ({utof(fs_cbuf9_190.y) : 2.50} + -2.f)) + 2.f) * {f_5_7 : -1.518002}))
    f_6_7 = exp2((((i.fs_attr15.z * ( utof(fs_cbuf9_190.y) + -2.f)) + 2.f) * f_5_7));
	// 0.20  <=>  (clamp({pf_1_13 : 0.50}, 0.1f, 0.3f) + -0.1f)
    pf_2_22 = (clamp(pf_1_13, 0.1f, 0.3f) + -0.1f);
	// 1.00  <=>  ({pf_2_22 : 0.20} * 4.9999995f)
    pf_4_12 = (pf_2_22 * 4.9999995f);
	// 1.818035  <=>  (clamp({f_6_7 : 0.0874529}, 0.0, 1.0) * (({i.fs_attr15.z : 0.63155} * ({utof(fs_cbuf9_190.x) : 30.00} + -5.f)) + 5.f))
    pf_8_17 = (clamp(f_6_7, 0.0, 1.0) * ((i.fs_attr15.z * ( utof(fs_cbuf9_190.x) + -5.f)) + 5.f));
	// 0.00  <=>  ({f_2_7 : 0.00} * {f_2_7 : 0.00})
    pf_10_23 = (f_2_7 * f_2_7);
	// 1.00  <=>  clamp((clamp(max((({f_10_2 : 494.7588} * 0.1f) + (0.f - 1.f)), 0.0), 0.3f, 1.0) + (0.f - 0.f)), 0.0, 1.0)
    f_1_39 = clamp((clamp(max(((f_10_2 * 0.1f) + (0.f - 1.f)), 0.0), 0.3f, 1.0) + (0.f - 0.f)), 0.0, 1.0);
	// 0.7149534  <=>  (({pf_8_17 : 1.818035} * (0.f - ({i.fs_attr12.x : 0.75843} * {utof(fs_cbuf9_192.z) : 0.80}))) + {pf_8_17 : 1.818035})
    pf_8_18 = ((pf_8_17 * (0.f - (i.fs_attr12.x * utof(fs_cbuf9_192.z)))) + pf_8_17);
	// 0.00  <=>  ((min(({pf_7_20 : 1.05} * (1.0f / ({pf_3_3 : 0.00} + 1.f))), 1.f) * (0.f - {utof(fs_cbuf15_57.w) : 1.00})) + {utof(fs_cbuf15_57.w) : 1.00})
    pf_9_24 = ((min((pf_7_20 * (1.0f / (pf_3_3 + 1.f))), 1.f) * (0.f - utof(fs_cbuf15_57.w))) + utof(fs_cbuf15_57.w));
	// 0.89314  <=>  max({pf_0_14 : 0.89314}, 0.3f)
    f_7_65 = max(pf_0_14, 0.3f);
	// 0.00  <=>  (0.f - {pf_10_23 : 0.00})
    f_9_43 = (0.f - pf_10_23);
	// 0.00  <=>  ((min(({pf_7_20 : 1.05} * (1.0f / ({pf_3_3 : 0.00} + 1.f))), 1.f) * {f_9_43 : 0.00}) + {pf_10_23 : 0.00})
    pf_0_15 = ((min((pf_7_20 * (1.0f / (pf_3_3 + 1.f))), 1.f) * f_9_43) + pf_10_23);
	// 0.07  <=>  clamp((max((({pf_6_19 : -1.843657} * 0.4f) + 0.4f), 0.07f) + (0.f - 0.f)), 0.0, 1.0)
    f_2_9 = clamp((max(((pf_6_19 * 0.4f) + 0.4f), 0.07f) + (0.f - 0.f)), 0.0, 1.0);
	// 0.89314  <=>  clamp(({f_7_65 : 0.89314} + (0.f - 0.f)), 0.0, 1.0)
    f_4_14 = clamp((f_7_65 + (0.f - 0.f)), 0.0, 1.0);
	// 0.0049  <=>  ({f_2_9 : 0.07} * {f_2_9 : 0.07})
    pf_3_6 = (f_2_9 * f_2_9);
	// 1.00  <=>  (({f_1_39 : 1.00} + -0.3f) * 1.4285715f)
    pf_10_26 = ((f_1_39 + -0.3f) * 1.4285715f);
	// -0.9951  <=>  (0.f - (((1.f + (0.f - {utof(fs_cbuf15_1.x) : 0.00})) * (0.f - {pf_3_6 : 0.0049})) + 1.f))
    f_2_14 = (0.f - (((1.f + (0.f - utof(fs_cbuf15_1.x))) * (0.f - pf_3_6)) + 1.f));
	// -0.0519819  <=>  ((({f_3_26 : 0.1137638} * ({pf_1_13 : 0.50} + (0.f - {pf_4_12 : 1.00}))) + {pf_4_12 : 1.00}) + {f_2_14 : -0.9951})
    pf_4_14 = (((f_3_26 * (pf_1_13 + (0.f - pf_4_12))) + pf_4_12) + f_2_14);
	// 0.8473429  <=>  (({f_4_14 : 0.89314} + -0.3f) * 1.4285715f)
    pf_13_15 = ((f_4_14 + -0.3f) * 1.4285715f);
	// 0.7149534  <=>  ((({pf_8_18 : 0.7149534} * (0.f - ({i.fs_attr12.y : 0.22514} * {utof(fs_cbuf9_192.w) : 0.00}))) + {pf_8_18 : 0.7149534}) * ({pf_10_26 : 1.00} * {pf_10_26 : 1.00}))
    pf_8_20 = (((pf_8_18 * (0.f - (i.fs_attr12.y * utof(fs_cbuf9_192.w)))) + pf_8_18) * (pf_10_26 * pf_10_26));
	// 0.00  <=>  ((min(({pf_3_3 : 0.00} * 10.f), 1.f) + {pf_0_15 : 0.00}) * clamp(((0.f - {utof2(u_0_phi_13) : 0.00}) + 1.f), 0.0, 1.0))
    pf_0_17 = ((min((pf_3_3 * 10.f), 1.f) + pf_0_15) * clamp(((0.f - utof2(u_0_phi_13)) + 1.f), 0.0, 1.0));
	// 0.97879  <=>  (({pf_4_14 : -0.0519819} * ({f_3_26 : 0.1137638} + 0.2f)) + (((1.f + (0.f - {utof(fs_cbuf15_1.x) : 0.00})) * (0.f - {pf_3_6 : 0.0049})) + 1.f))
    pf_3_8 = ((pf_4_14 * (f_3_26 + 0.2f)) + (((1.f + (0.f - utof(fs_cbuf15_1.x))) * (0.f - pf_3_6)) + 1.f));
	// -0.09062  <=>  ((((({pf_2_22 : 0.20} * 1.2499999f) + 0.75f) * {utof(fs_cbuf15_44.w) : 1.00}) * (0.f - {i.fs_attr11.x : 1.04062})) + (({pf_1_13 : 0.50} * (((({pf_2_22 : 0.20} * 3.3499994f) + 0.33f) * (0.f - {utof(fs_cbuf15_44.x) : 0.90})) + {utof(fs_cbuf15_43.x) : 1.00})) + ((({pf_2_22 : 0.20} * 3.3499994f) + 0.33f) * {utof(fs_cbuf15_44.x) : 0.90})))
    pf_5_34 = (((((pf_2_22 * 1.2499999f) + 0.75f) * utof(fs_cbuf15_44.w)) * (0.f - i.fs_attr11.x)) + ((pf_1_13 * ((((pf_2_22 * 3.3499994f) + 0.33f) * (0.f - utof(fs_cbuf15_44.x))) + utof(fs_cbuf15_43.x))) + (((pf_2_22 * 3.3499994f) + 0.33f) * utof(fs_cbuf15_44.x))));
	// -0.4581901  <=>  ((((({pf_2_22 : 0.20} * 1.2499999f) + 0.75f) * {utof(fs_cbuf15_44.w) : 1.00}) * (0.f - {i.fs_attr11.y : 1.28819})) + (({pf_1_13 : 0.50} * (((({pf_2_22 : 0.20} * 3.3499994f) + 0.33f) * (0.f - {utof(fs_cbuf15_44.y) : 0.775})) + {utof(fs_cbuf15_43.y) : 0.885})) + ((({pf_2_22 : 0.20} * 3.3499994f) + 0.33f) * {utof(fs_cbuf15_44.y) : 0.775})))
    pf_6_22 = (((((pf_2_22 * 1.2499999f) + 0.75f) * utof(fs_cbuf15_44.w)) * (0.f - i.fs_attr11.y)) + ((pf_1_13 * ((((pf_2_22 * 3.3499994f) + 0.33f) * (0.f - utof(fs_cbuf15_44.y))) + utof(fs_cbuf15_43.y))) + (((pf_2_22 * 3.3499994f) + 0.33f) * utof(fs_cbuf15_44.y))));
	// -0.8717301  <=>  ((((({pf_2_22 : 0.20} * 1.2499999f) + 0.75f) * {utof(fs_cbuf15_44.w) : 1.00}) * (0.f - {i.fs_attr11.z : 1.48423})) + (({pf_1_13 : 0.50} * (((({pf_2_22 : 0.20} * 3.3499994f) + 0.33f) * (0.f - {utof(fs_cbuf15_44.z) : 0.575})) + {utof(fs_cbuf15_43.z) : 0.65})) + ((({pf_2_22 : 0.20} * 3.3499994f) + 0.33f) * {utof(fs_cbuf15_44.z) : 0.575})))
    pf_1_15 = (((((pf_2_22 * 1.2499999f) + 0.75f) * utof(fs_cbuf15_44.w)) * (0.f - i.fs_attr11.z)) + ((pf_1_13 * ((((pf_2_22 * 3.3499994f) + 0.33f) * (0.f - utof(fs_cbuf15_44.z))) + utof(fs_cbuf15_43.z))) + (((pf_2_22 * 3.3499994f) + 0.33f) * utof(fs_cbuf15_44.z))));
	// 0.7149534  <=>  ((({pf_13_15 : 0.8473429} * {pf_13_15 : 0.8473429}) * {pf_0_17 : 0.00}) + ((({pf_9_24 : 0.00} * -0.39999998f) + 1.f) * {pf_8_20 : 0.7149534}))
    pf_0_18 = (((pf_13_15 * pf_13_15) * pf_0_17) + (((pf_9_24 * -0.39999998f) + 1.f) * pf_8_20));
	// 0.951922  <=>  ((({pf_9_24 : 0.00} * -0.39999998f) + 1.f) * (({pf_5_34 : -0.09062} * clamp({pf_3_8 : 0.97879}, 0.0, 1.0)) + (((({pf_2_22 : 0.20} * 1.2499999f) + 0.75f) * {utof(fs_cbuf15_44.w) : 1.00}) * {i.fs_attr11.x : 1.04062})))
    pf_3_11 = (((pf_9_24 * -0.39999998f) + 1.f) * ((pf_5_34 * clamp(pf_3_8, 0.0, 1.0)) + ((((pf_2_22 * 1.2499999f) + 0.75f) * utof(fs_cbuf15_44.w)) * i.fs_attr11.x)));
	// 0.8397182  <=>  ((({pf_9_24 : 0.00} * -0.39999998f) + 1.f) * (({pf_6_22 : -0.4581901} * clamp({pf_3_8 : 0.97879}, 0.0, 1.0)) + (((({pf_2_22 : 0.20} * 1.2499999f) + 0.75f) * {utof(fs_cbuf15_44.w) : 1.00}) * {i.fs_attr11.y : 1.28819})))
    pf_2_27 = (((pf_9_24 * -0.39999998f) + 1.f) * ((pf_6_22 * clamp(pf_3_8, 0.0, 1.0)) + ((((pf_2_22 * 1.2499999f) + 0.75f) * utof(fs_cbuf15_44.w)) * i.fs_attr11.y)));
	// 0.4647197  <=>  ((1.f + (0.f - {utof(fs_cbuf15_1.x) : 0.00})) * ({pf_0_18 : 0.7149534} * {utof(fs_cbuf15_42.w) : 0.65}))
    pf_0_20 = ((1.f + (0.f - utof(fs_cbuf15_1.x))) * (pf_0_18 * utof(fs_cbuf15_42.w)));
	// 0.6309894  <=>  ((({pf_9_24 : 0.00} * -0.39999998f) + 1.f) * (({pf_1_15 : -0.8717301} * clamp({pf_3_8 : 0.97879}, 0.0, 1.0)) + (((({pf_2_22 : 0.20} * 1.2499999f) + 0.75f) * {utof(fs_cbuf15_44.w) : 1.00}) * {i.fs_attr11.z : 1.48423})))
    pf_1_17 = (((pf_9_24 * -0.39999998f) + 1.f) * ((pf_1_15 * clamp(pf_3_8, 0.0, 1.0)) + ((((pf_2_22 * 1.2499999f) + 0.75f) * utof(fs_cbuf15_44.w)) * i.fs_attr11.z)));
	// -2.996689  <=>  (0.f - (({pf_0_20 : 0.4647197} * {utof(fs_cbuf15_42.x) : 4.40}) + {pf_3_11 : 0.951922}))
    f_12_11 = (0.f - ((pf_0_20 * utof(fs_cbuf15_42.x)) + pf_3_11));
	// -2.447466  <=>  (0.f - (({pf_0_20 : 0.4647197} * {utof(fs_cbuf15_42.y) : 3.459608}) + {pf_2_27 : 0.8397182}))
    f_12_12 = (0.f - ((pf_0_20 * utof(fs_cbuf15_42.y)) + pf_2_27));
	// -1.856847  <=>  (0.f - (({pf_0_20 : 0.4647197} * {utof(fs_cbuf15_42.z) : 2.637844}) + {pf_1_17 : 0.6309894}))
    f_12_13 = (0.f - ((pf_0_20 * utof(fs_cbuf15_42.z)) + pf_1_17));
	// -2.681779  <=>  (0.f - ((((({f_12_11 : -2.996689} + {utof(fs_cbuf15_26.x) : 1.12035}) * {i.fs_attr10.y : 0.00}) + (({pf_0_20 : 0.4647197} * {utof(fs_cbuf15_42.x) : 4.40}) + {pf_3_11 : 0.951922})) * {i.fs_attr14.w : 0.85808}) + {i.fs_attr14.x : 0.11038}))
    f_3_31 = (0.f - (((((f_12_11 + utof(fs_cbuf15_26.x)) * i.fs_attr10.y) + ((pf_0_20 * utof(fs_cbuf15_42.x)) + pf_3_11)) * i.fs_attr14.w) + i.fs_attr14.x));
	// -2.230392  <=>  (0.f - ((((({f_12_12 : -2.447466} + {utof(fs_cbuf15_26.y) : 1.3145}) * {i.fs_attr10.y : 0.00}) + (({pf_0_20 : 0.4647197} * {utof(fs_cbuf15_42.y) : 3.459608}) + {pf_2_27 : 0.8397182})) * {i.fs_attr14.w : 0.85808}) + {i.fs_attr14.y : 0.13027}))
    f_3_32 = (0.f - (((((f_12_12 + utof(fs_cbuf15_26.y)) * i.fs_attr10.y) + ((pf_0_20 * utof(fs_cbuf15_42.y)) + pf_2_27)) * i.fs_attr14.w) + i.fs_attr14.y));
	// -1.763714  <=>  (0.f - ((((({f_12_13 : -1.856847} + {utof(fs_cbuf15_26.z) : 0.66605}) * {i.fs_attr10.y : 0.00}) + (({pf_0_20 : 0.4647197} * {utof(fs_cbuf15_42.z) : 2.637844}) + {pf_1_17 : 0.6309894})) * {i.fs_attr14.w : 0.85808}) + {i.fs_attr14.z : 0.17039}))
    f_3_33 = (0.f - (((((f_12_13 + utof(fs_cbuf15_26.z)) * i.fs_attr10.y) + ((pf_0_20 * utof(fs_cbuf15_42.z)) + pf_1_17)) * i.fs_attr14.w) + i.fs_attr14.z));
	// 2.681779  <=>  ((({f_3_31 : -2.681779} + {i.fs_attr17.x : 0.20862}) * {i.fs_attr17.w : 0.00}) + ((((({f_12_11 : -2.996689} + {utof(fs_cbuf15_26.x) : 1.12035}) * {i.fs_attr10.y : 0.00}) + (({pf_0_20 : 0.4647197} * {utof(fs_cbuf15_42.x) : 4.40}) + {pf_3_11 : 0.951922})) * {i.fs_attr14.w : 0.85808}) + {i.fs_attr14.x : 0.11038}))
    pf_1_21 = (((f_3_31 + i.fs_attr17.x) * i.fs_attr17.w) + (((((f_12_11 + utof(fs_cbuf15_26.x)) * i.fs_attr10.y) + ((pf_0_20 * utof(fs_cbuf15_42.x)) + pf_3_11)) * i.fs_attr14.w) + i.fs_attr14.x));
	// 2.230392  <=>  ((({f_3_32 : -2.230392} + {i.fs_attr17.y : 0.45313}) * {i.fs_attr17.w : 0.00}) + ((((({f_12_12 : -2.447466} + {utof(fs_cbuf15_26.y) : 1.3145}) * {i.fs_attr10.y : 0.00}) + (({pf_0_20 : 0.4647197} * {utof(fs_cbuf15_42.y) : 3.459608}) + {pf_2_27 : 0.8397182})) * {i.fs_attr14.w : 0.85808}) + {i.fs_attr14.y : 0.13027}))
    pf_2_31 = (((f_3_32 + i.fs_attr17.y) * i.fs_attr17.w) + (((((f_12_12 + utof(fs_cbuf15_26.y)) * i.fs_attr10.y) + ((pf_0_20 * utof(fs_cbuf15_42.y)) + pf_2_27)) * i.fs_attr14.w) + i.fs_attr14.y));
	// 1.763714  <=>  ((({f_3_33 : -1.763714} + {i.fs_attr17.z : 0.84766}) * {i.fs_attr17.w : 0.00}) + ((((({f_12_13 : -1.856847} + {utof(fs_cbuf15_26.z) : 0.66605}) * {i.fs_attr10.y : 0.00}) + (({pf_0_20 : 0.4647197} * {utof(fs_cbuf15_42.z) : 2.637844}) + {pf_1_17 : 0.6309894})) * {i.fs_attr14.w : 0.85808}) + {i.fs_attr14.z : 0.17039}))
    pf_0_24 = (((f_3_33 + i.fs_attr17.z) * i.fs_attr17.w) + (((((f_12_13 + utof(fs_cbuf15_26.z)) * i.fs_attr10.y) + ((pf_0_20 * utof(fs_cbuf15_42.z)) + pf_1_17)) * i.fs_attr14.w) + i.fs_attr14.z));
	// 2.026945  <=>  ((0.f - ((((0.f - {pf_1_21 : 2.681779}) + {utof(fs_cbuf15_25.x) : 0.682}) * {i.fs_attr10.x : 0.12}) + {pf_1_21 : 2.681779})) + {i.fs_attr16.x : 4.46875})
    pf_3_15 = ((0.f - ((((0.f - pf_1_21) + utof(fs_cbuf15_25.x)) * i.fs_attr10.x) + pf_1_21)) + i.fs_attr16.x);
	// 0.9476893  <=>  ((0.f - ((((0.f - {pf_2_31 : 2.230392}) + {utof(fs_cbuf15_25.y) : 0.99055}) * {i.fs_attr10.x : 0.12}) + {pf_2_31 : 2.230392})) + {i.fs_attr16.y : 3.0293})
    pf_4_19 = ((0.f - ((((0.f - pf_2_31) + utof(fs_cbuf15_25.y)) * i.fs_attr10.x) + pf_2_31)) + i.fs_attr16.y);
	// 0.1182439  <=>  ((0.f - ((((0.f - {pf_0_24 : 1.763714}) + {utof(fs_cbuf15_25.z) : 0.63965}) * {i.fs_attr10.x : 0.12}) + {pf_0_24 : 1.763714})) + {i.fs_attr16.z : 1.74707})
    pf_5_38 = ((0.f - ((((0.f - pf_0_24) + utof(fs_cbuf15_25.z)) * i.fs_attr10.x) + pf_0_24)) + i.fs_attr16.z);
    float4 frag_color0;
	// 2.441805  <=>  (({pf_3_15 : 2.026945} * {i.fs_attr16.w : 0.00}) + ((((0.f - {pf_1_21 : 2.681779}) + {utof(fs_cbuf15_25.x) : 0.682}) * {i.fs_attr10.x : 0.12}) + {pf_1_21 : 2.681779}))
    frag_color0.x = ((pf_3_15 * i.fs_attr16.w) + ((((0.f - pf_1_21) + utof(fs_cbuf15_25.x)) * i.fs_attr10.x) + pf_1_21));
	// 2.081611  <=>  (({pf_4_19 : 0.9476893} * {i.fs_attr16.w : 0.00}) + ((((0.f - {pf_2_31 : 2.230392}) + {utof(fs_cbuf15_25.y) : 0.99055}) * {i.fs_attr10.x : 0.12}) + {pf_2_31 : 2.230392}))
    frag_color0.y = ((pf_4_19 * i.fs_attr16.w) + ((((0.f - pf_2_31) + utof(fs_cbuf15_25.y)) * i.fs_attr10.x) + pf_2_31));
	// 1.628826  <=>  (({pf_5_38 : 0.1182439} * {i.fs_attr16.w : 0.00}) + ((((0.f - {pf_0_24 : 1.763714}) + {utof(fs_cbuf15_25.z) : 0.63965}) * {i.fs_attr10.x : 0.12}) + {pf_0_24 : 1.763714}))
    frag_color0.z = ((pf_5_38 * i.fs_attr16.w) + ((((0.f - pf_0_24) + utof(fs_cbuf15_25.z)) * i.fs_attr10.x) + pf_0_24));
	// 0.6429225  <=>  {f_0_32 : 0.6429225}
    frag_color0.w = f_0_32;
    return frag_color0;
}