#version 460
#pragma optionNV(fastmath off)
#extension GL_ARB_separate_shader_objects : enable

out gl_PerVertex {
    vec4 gl_Position;
};
layout(location = 0) in vec4 in_attr0; //顶点坐标（位于xy平面，z始终为0，w为1）
layout(location = 1) in vec4 in_attr1; //UV（xy是UV，z是从6点开始逆时针方向的顶点序号，中心点为12，w为1）
layout(location = 4) in vec4 in_attr4; //固定值 277.38879	-253.98657	-1225.84583	1000 （xyzw全用）
layout(location = 5) in vec4 in_attr5; //固定值 0	0	0	1060.5 （只用w）
layout(location = 6) in vec4 in_attr6; //固定值 256.74911	175.44524	175.44524	1 (用xyz)
layout(location = 7) in vec4 in_attr7; //固定值 0.33394	0.62269	0.01691	0.7787 （xyzw全用）
layout(location = 9) in vec4 in_attr9; //固定值 1	0	0	287.3111 （xyzw全用）
layout(location = 10) in vec4 in_attr10; //固定值 0	1	0	1522.14368 （xyzw全用）
layout(location = 11) in vec4 in_attr11; //固定值 0	0	1	1396.66956 （xyzw全用）

layout(location = 0) out vec4 out_attr0; //只写w，用作系数，参与输出颜色与alpha的计算
layout(location = 1) out vec4 out_attr1; //xyzw全写，zw是大的云纹理采样坐标，xy是小的纹理数组的采样坐标
layout(location = 2) out vec4 out_attr2; //xyzw全写，xy/w是深度纹理的采样坐标，z/w参与输出alpha的计算
layout(location = 3) out vec4 out_attr3; //只写x，用作最终alpha值的乘数
layout(location = 4) out vec4 out_attr4; //写xyz，是一个坐标，用于与一个固定点计算单位向量
layout(location = 5) out vec4 out_attr5; //只写y，参与计算输出颜色一部分的系数的指数
layout(location = 6) out vec4 out_attr6; //只写x，用作小的纹理数组的下标
layout(location = 7) out vec4 out_attr7; //写xy，x与y分别用作系数
layout(location = 8) out vec4 out_attr8; //写xz，x参与颜色分量的计算，z参与颜色分量与alpha的计算
layout(location = 9) out vec4 out_attr9; //xyzw全写，xyz是颜色，w用作混合系数
layout(location = 10) out vec4 out_attr10; //xyzw全写，xyz是颜色，w用作混合系数
layout(location = 11) out vec4 out_attr11; //xyzw全写，xyz是颜色，w用作混合系数

layout(std140, binding = 0) uniform vs_cbuf_8 {
    uvec4 vs_cbuf8[4096];
};
layout(std140, binding = 1) uniform vs_cbuf_9 {
    uvec4 vs_cbuf9[4096];
};
layout(std140, binding = 2) uniform vs_cbuf_10 {
    uvec4 vs_cbuf10[4096];
};
layout(std140, binding = 3) uniform vs_cbuf_13 {
    uvec4 vs_cbuf13[4096];
};
layout(std140, binding = 4) uniform vs_cbuf_15 {
    uvec4 vs_cbuf15[4096];
};

layout(binding = 0) uniform sampler2D tex0; //8*13
layout(binding = 1) uniform sampler2D tex1; //256*256
layout(binding = 2) uniform sampler2D tex2; //256*256

#define ftoi floatBitsToInt
#define ftou floatBitsToUint
#define itof intBitsToFloat
#define utof uintBitsToFloat


void main()
{
	// 1065353216 = 1.00f;
	// vs_cbuf8[0] = vec4(0.9936762, 0.00, 0.1122834, -442.3171);
	// vs_cbuf8[1] = vec4(0.0627182, 0.829457, -0.5550383, -629.7858);
	// vs_cbuf8[2] = vec4(-0.0931343, 0.5585706, 0.8242117, -2058.403);
	// vs_cbuf8[3] = vec4(0.00, 0.00, 0.00, 1.00);
	// vs_cbuf8[4] = vec4(1.206285, 0.00, 0.00, 0.00);
	// vs_cbuf8[5] = vec4(0.00, 2.144507, 0.00, 0.00);
	// vs_cbuf8[6] = vec4(0.00, 0.00, -1.00008, -2.00008);
	// vs_cbuf8[7] = vec4(0.00, 0.00, -1.00, 0.00);
	// vs_cbuf8[29] = vec4(287.3111, 1672.144, 1396.669, 0.00);
	// vs_cbuf8[30] = vec4(1.00, 25000.00, 25000.00, 24999.00);
	// vs_cbuf9[11] = vec4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf9[12] = vec4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf9[16] = vec4(0.00, 0.00, 0.00, 1.00);
	// vs_cbuf9[113] = vec4(0.00, 0.00, 0.00, 0.00);
	// vs_cbuf9[114] = vec4(1.00, 1.00, 1.00, 0.10);
	// vs_cbuf9[115] = vec4(1.00, 1.00, 1.00, 0.90);
	// vs_cbuf9[116] = vec4(0.00, 0.00, 0.00, 1.00);
	// vs_cbuf9[141] = vec4(1.00, 1.00, 1.00, 0.00);
	// vs_cbuf10[0] = vec4(1.00, 1.00, 1.00, 1.00);
	// vs_cbuf10[2] = vec4(1638.50, 159.00, 1.00, 1.00);
	// vs_cbuf10[3] = vec4(0.999997, 1.00, 1.00, 1.00);
	// vs_cbuf13[6] = vec4(1.00, 1.00, 10.00, 0.00);
	// vs_cbuf15[1] = vec4(0.00, 1.00, 1.895482, 1.00);
	// vs_cbuf15[22] = vec4(0.0000418, 0.0029252, 0.00, 0.00);
	// vs_cbuf15[23] = vec4(42.50, 2.50, 0.85, -0.0229271);
	// vs_cbuf15[24] = vec4(0.0033333, 0.00, 0.576, 4.00);
	// vs_cbuf15[25] = vec4(0.682, 0.99055, 0.63965, 0.12);
	// vs_cbuf15[26] = vec4(1.12035, 1.3145, 0.66605, 0.4519901);
	// vs_cbuf15[27] = vec4(-0.0909091, 0.0045455, 250.00, 0.00);
	// vs_cbuf15[28] = vec4(0.5226594, -0.5741013, -0.6302658, 0.00);
	// vs_cbuf15[54] = vec4(0.8137476, 1.689872, 75.00, 2000.00);
	// vs_cbuf15[55] = vec4(0.8511029, 0.825, 1.060784, 0.70);
	// vs_cbuf15[57] = vec4(-4731.44, 907.7282, 3000.00, 1.00);
	// vs_cbuf15[60] = vec4(0.75, 0.50, 4.00, 1672.144);
	// vs_cbuf15[61] = vec4(1.00, 0.00, 0.00, 0.00);

	bool b_0_2;
	bool b_0_5;
	bool b_1_10;
	bool b_1_11;
	bool b_1_12;
	bool b_1_13;
	bool b_1_14;
	bool b_1_8;
	bool b_1_9;
	float f_0_12;
	float f_1_10;
	float f_1_18;
	float f_1_51;
	float f_1_56;
	float f_1_65;
	float f_1_70;
	float f_11_3;
	float f_11_4;
	float f_15_12;
	float f_15_15;
	float f_15_17;
	float f_16_12;
	float f_16_6;
	float f_16_8;
	float f_17_0;
	float f_17_10;
	float f_2_42;
	float f_2_50;
	float f_2_63;
	float f_2_64;
	float f_3_32;
	float f_3_42;
	float f_3_44;
	float f_3_49;
	float f_3_57;
	float f_3_61;
	float f_4_28;
	float f_4_43;
	float f_4_45;
	float f_4_46;
	float f_4_52;
	float f_4_57;
	float f_4_58;
	float f_4_70;
	float f_4_79;
	float f_4_8;
	float f_4_81;
	float f_5_13;
	float f_5_18;
	float f_5_21;
	float f_5_25;
	float f_5_28;
	float f_5_29;
	float f_6_12;
	float f_6_7;
	float f_8_1;
	float f_9_2;
	vec2 f2_0_1;
	vec2 f2_0_2;
	vec4 f4_0_0;
	vec4 f4_0_1;
	vec4 f4_0_2;
	vec4 f4_0_3;
	vec4 f4_0_4;
	vec4 f4_0_5;
	precise float pf_0_1;
	precise float pf_0_11;
	precise float pf_0_12;
	precise float pf_0_25;
	precise float pf_0_29;
	precise float pf_0_3;
	precise float pf_0_31;
	precise float pf_0_33;
	precise float pf_0_34;
	precise float pf_0_4;
	precise float pf_1_11;
	precise float pf_1_15;
	precise float pf_1_16;
	precise float pf_1_24;
	precise float pf_1_25;
	precise float pf_1_26;
	precise float pf_1_4;
	precise float pf_1_5;
	precise float pf_1_6;
	precise float pf_1_8;
	precise float pf_1_9;
	precise float pf_10_1;
	precise float pf_10_10;
	precise float pf_10_14;
	precise float pf_10_17;
	precise float pf_10_18;
	precise float pf_10_4;
	precise float pf_10_6;
	precise float pf_10_7;
	precise float pf_10_9;
	precise float pf_11_10;
	precise float pf_11_13;
	precise float pf_11_15;
	precise float pf_11_3;
	precise float pf_11_4;
	precise float pf_11_5;
	precise float pf_11_8;
	precise float pf_11_9;
	precise float pf_12_2;
	precise float pf_12_6;
	precise float pf_12_8;
	precise float pf_13_1;
	precise float pf_13_10;
	precise float pf_13_11;
	precise float pf_13_15;
	precise float pf_13_5;
	precise float pf_13_6;
	precise float pf_13_7;
	precise float pf_14_13;
	precise float pf_14_2;
	precise float pf_14_4;
	precise float pf_14_6;
	precise float pf_14_7;
	precise float pf_14_9;
	precise float pf_15_11;
	precise float pf_15_14;
	precise float pf_15_2;
	precise float pf_15_20;
	precise float pf_15_6;
	precise float pf_15_8;
	precise float pf_16_10;
	precise float pf_16_2;
	precise float pf_16_3;
	precise float pf_16_4;
	precise float pf_17_3;
	precise float pf_17_5;
	precise float pf_17_6;
	precise float pf_17_9;
	precise float pf_18_1;
	precise float pf_18_10;
	precise float pf_18_2;
	precise float pf_18_6;
	precise float pf_18_9;
	precise float pf_19_3;
	precise float pf_19_6;
	precise float pf_19_7;
	precise float pf_2_0;
	precise float pf_2_3;
	precise float pf_2_4;
	precise float pf_2_5;
	precise float pf_20_0;
	precise float pf_20_11;
	precise float pf_20_17;
	precise float pf_20_19;
	precise float pf_20_5;
	precise float pf_20_6;
	precise float pf_20_9;
	precise float pf_21_7;
	precise float pf_22_0;
	precise float pf_23_0;
	precise float pf_23_6;
	precise float pf_24_1;
	precise float pf_25_0;
	precise float pf_25_1;
	precise float pf_25_3;
	precise float pf_26_1;
	precise float pf_3_11;
	precise float pf_3_12;
	precise float pf_3_2;
	precise float pf_3_4;
	precise float pf_4_10;
	precise float pf_4_11;
	precise float pf_4_13;
	precise float pf_4_2;
	precise float pf_4_21;
	precise float pf_4_4;
	precise float pf_4_6;
	precise float pf_5_3;
	precise float pf_5_5;
	precise float pf_5_6;
	precise float pf_6_11;
	precise float pf_6_19;
	precise float pf_6_4;
	precise float pf_6_6;
	precise float pf_6_7;
	precise float pf_6_8;
	precise float pf_7_0;
	precise float pf_7_11;
	precise float pf_7_12;
	precise float pf_7_13;
	precise float pf_7_15;
	precise float pf_7_17;
	precise float pf_7_19;
	precise float pf_7_27;
	precise float pf_7_5;
	precise float pf_7_6;
	precise float pf_7_7;
	precise float pf_8_0;
	precise float pf_8_10;
	precise float pf_8_2;
	precise float pf_8_4;
	precise float pf_8_5;
	precise float pf_8_6;
	precise float pf_8_8;
	precise float pf_9_11;
	precise float pf_9_13;
	precise float pf_9_14;
	precise float pf_9_15;
	precise float pf_9_17;
	precise float pf_9_2;
	precise float pf_9_21;
	precise float pf_9_3;
	precise float pf_9_4;
	precise float pf_9_5;
	precise float pf_9_9;
	uint u_0_1;
	uint u_0_11;
	uint u_0_12;
	uint u_0_13;
	uint u_0_2;
	uint u_0_4;
	uint u_0_5;
	uint u_0_6;
	uint u_0_7;
	uint u_0_phi_11;
	uint u_0_phi_15;
	uint u_0_phi_4;
	uint u_1_1;
	uint u_1_3;
	uint u_1_4;
	uint u_1_phi_16;
	uint u_2_0;
	uint u_2_1;
	uint u_2_5;
	uint u_2_6;
	uint u_2_phi_2;
	uint u_3_2;
	uint u_3_3;
	uint u_3_4;
	uint u_3_5;
	uint u_3_7;
	uint u_3_phi_15;
	uint u_3_phi_9;
	uint u_4_2;
	uvec2 u2_0_0;
	// 166.4582  <=>  float(166.45822)
	gl_Position.x = float(166.45822);
	// 777.8109  <=>  float(777.81085)
	gl_Position.y = float(777.81085);
	// 1259.947  <=>  float(1259.94666)
	gl_Position.z = float(1259.94666);
	// 1261.846  <=>  float(1261.84583)
	gl_Position.w = float(1261.84583);
	// 0.00  <=>  float(0.00)
	out_attr0.x = float(0.00);
	// 0.00  <=>  float(0.00)
	out_attr0.y = float(0.00);
	// 0.00  <=>  float(0.00)
	out_attr0.z = float(0.00);
	// 1.00  <=>  float(1.00)
	out_attr0.w = float(1.00);
	// 0.50  <=>  float(0.50)
	out_attr1.x = float(0.50);
	// 0.50  <=>  float(0.50)
	out_attr1.y = float(0.50);
	// 1.46396  <=>  float(1.46396)
	out_attr1.z = float(1.46396);
	// 3.26268  <=>  float(3.26268)
	out_attr1.w = float(3.26268);
	// 714.152  <=>  float(714.15204)
	out_attr2.x = float(714.15204);
	// 242.0175  <=>  float(242.01749)
	out_attr2.y = float(242.01749);
	// 1260.896  <=>  float(1260.89624)
	out_attr2.z = float(1260.89624);
	// 1261.846  <=>  float(1261.84583)
	out_attr2.w = float(1261.84583);
	// 1.00  <=>  float(1.00)
	out_attr3.x = float(1.00);
	// 0.00  <=>  float(0.00)
	out_attr3.y = float(0.00);
	// 0.00  <=>  float(0.00)
	out_attr3.z = float(0.00);
	// 1.00  <=>  float(1.00)
	out_attr3.w = float(1.00);
	// 564.6999  <=>  float(564.69989)
	out_attr4.x = float(564.69989);
	// 1268.157  <=>  float(1268.1571)
	out_attr4.y = float(1268.1571);
	// 170.8237  <=>  float(170.82373)
	out_attr4.z = float(170.82373);
	// 1.00  <=>  float(1.00)
	out_attr4.w = float(1.00);
	// 0.00  <=>  float(0.00)
	out_attr5.x = float(0.00);
	// 175.4452  <=>  float(175.44524)
	out_attr5.y = float(175.44524);
	// 0.00  <=>  float(0.00)
	out_attr5.z = float(0.00);
	// 1.00  <=>  float(1.00)
	out_attr5.w = float(1.00);
	// 2.00  <=>  float(2.00)
	out_attr6.x = float(2.00);
	// 0.00  <=>  float(0.00)
	out_attr6.y = float(0.00);
	// 0.00  <=>  float(0.00)
	out_attr6.z = float(0.00);
	// 1.00  <=>  float(1.00)
	out_attr6.w = float(1.00);
	// 0.12  <=>  float(0.12)
	out_attr7.x = float(0.12);
	// 0.00  <=>  float(0.00)
	out_attr7.y = float(0.00);
	// 0.00  <=>  float(0.00)
	out_attr7.z = float(0.00);
	// 1.00  <=>  float(1.00)
	out_attr7.w = float(1.00);
	// 1.00  <=>  float(1.00)
	out_attr8.x = float(1.00);
	// 0.00  <=>  float(0.00)
	out_attr8.y = float(0.00);
	// 1.00  <=>  float(1.00)
	out_attr8.z = float(1.00);
	// 1.00  <=>  float(1.00)
	out_attr8.w = float(1.00);
	// 0.40435  <=>  float(0.40435)
	out_attr9.x = float(0.40435);
	// 0.39195  <=>  float(0.39195)
	out_attr9.y = float(0.39195);
	// 0.50397  <=>  float(0.50397)
	out_attr9.z = float(0.50397);
	// 0.52491  <=>  float(0.52491)
	out_attr9.w = float(0.52491);
	// 4.77344  <=>  float(4.77344)
	out_attr10.x = float(4.77344);
	// 3.10352  <=>  float(3.10352)
	out_attr10.y = float(3.10352);
	// 1.75391  <=>  float(1.75391)
	out_attr10.z = float(1.75391);
	// 0.00  <=>  float(0.00)
	out_attr10.w = float(0.00);
	// 0.20251  <=>  float(0.20251)
	out_attr11.x = float(0.20251);
	// 0.44214  <=>  float(0.44214)
	out_attr11.y = float(0.44214);
	// 0.8335  <=>  float(0.8335)
	out_attr11.z = float(0.8335);
	// 0.00  <=>  float(0.00)
	out_attr11.w = float(0.00);
	// 1000  <=>  (isnan({in_attr4.w : 1000.00}) ? 0u : int(clamp(trunc({in_attr4.w : 1000.00}), float(-2147483600.), float(2147483600.))))
	u_1_1 = (isnan(in_attr4.w) ? 0u : int(clamp(trunc(in_attr4.w), float(-2147483600.), float(2147483600.))));
	// False  <=>  if(((int({u_1_1 : 1000}) <= int(0u)) ? true : false))
	if(((int(u_1_1) <= int(0u)) ? true : false))
	{
		// 0.00  <=>  0.
		gl_Position.x = 0.;
	}
	// 0  <=>  0u
	u_2_0 = 0u;
	u_2_phi_2 = u_2_0;
	// False  <=>  if(((int({u_1_1 : 1000}) <= int(0u)) ? true : false))
	if(((int(u_1_1) <= int(0u)) ? true : false))
	{
		// 1187205120  <=>  {vs_cbuf8[30].y : 1187205120}
		u_2_1 = vs_cbuf8[30].y;
		u_2_phi_2 = u_2_1;
	}
	// False  <=>  if(((int({u_1_1 : 1000}) <= int(0u)) ? true : false))
	if(((int(u_1_1) <= int(0u)) ? true : false))
	{
		// 0.00  <=>  0.
		gl_Position.y = 0.;
	}
	// 0  <=>  {u_2_phi_2 : 0}
	u_0_1 = u_2_phi_2;
	u_0_phi_4 = u_0_1;
	// False  <=>  if(((int({u_1_1 : 1000}) <= int(0u)) ? true : false))
	if(((int(u_1_1) <= int(0u)) ? true : false))
	{
		// 0  <=>  {ftou(({utof(u_2_phi_2) : 0.00} * 5.)) : 0}
		u_0_2 = ftou((utof(u_2_phi_2) * 5.));
		u_0_phi_4 = u_0_2;
	}
	// False  <=>  if(((int({u_1_1 : 1000}) <= int(0u)) ? true : false))
	if(((int(u_1_1) <= int(0u)) ? true : false))
	{
		// 0.00  <=>  0.
		out_attr3.x = 0.;
	}
	// False  <=>  if(((int({u_1_1 : 1000}) <= int(0u)) ? true : false))
	if(((int(u_1_1) <= int(0u)) ? true : false))
	{
		// 0.00  <=>  {utof(u_0_phi_4) : 0.00}
		gl_Position.z = utof(u_0_phi_4);
	}
	// False  <=>  if(((int({u_1_1 : 1000}) <= int(0u)) ? true : false))
	if(((int(u_1_1) <= int(0u)) ? true : false))
	{
		return;
	}
	// 578.00  <=>  ((0. - {in_attr5.w : 1060.50}) + {utof(vs_cbuf10[2].x) : 1638.50})
	pf_0_1 = ((0. - in_attr5.w) + utof(vs_cbuf10[2].x));
	// False  <=>  ((({pf_0_1 : 578.00} >= float(int({u_1_1 : 1000}))) && (! isnan({pf_0_1 : 578.00}))) && (! isnan(float(int({u_1_1 : 1000})))))
	b_0_2 = (((pf_0_1 >= float(int(u_1_1))) && (! isnan(pf_0_1))) && (! isnan(float(int(u_1_1)))));
	// False  <=>  ((((({in_attr5.w : 1060.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 1060.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_8 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// False  <=>  if({b_1_8 : False})
	if(b_1_8)
	{
		// 0.00  <=>  0.
		gl_Position.x = 0.;
	}
	// False  <=>  ((((({in_attr5.w : 1060.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 1060.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_9 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// 1149538304  <=>  {ftou(in_attr5.w) : 1149538304}
	u_3_2 = ftou(in_attr5.w);
	u_3_phi_9 = u_3_2;
	// False  <=>  if({b_1_9 : False})
	if(b_1_9)
	{
		// 1187205120  <=>  {vs_cbuf8[30].y : 1187205120}
		u_3_3 = vs_cbuf8[30].y;
		u_3_phi_9 = u_3_3;
	}
	// False  <=>  ((((({in_attr5.w : 1060.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 1060.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_10 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// False  <=>  if({b_1_10 : False})
	if(b_1_10)
	{
		// 0.00  <=>  0.
		gl_Position.y = 0.;
	}
	// False  <=>  ((((({in_attr5.w : 1060.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 1060.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_11 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// 1149538304  <=>  {u_3_phi_9 : 1149538304}
	u_0_4 = u_3_phi_9;
	u_0_phi_11 = u_0_4;
	// False  <=>  if({b_1_11 : False})
	if(b_1_11)
	{
		// 1168487424  <=>  {ftou(({utof(u_3_phi_9) : 1060.50} * 5.)) : 1168487424}
		u_0_5 = ftou((utof(u_3_phi_9) * 5.));
		u_0_phi_11 = u_0_5;
	}
	// False  <=>  ((((({in_attr5.w : 1060.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 1060.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_12 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// False  <=>  if({b_1_12 : False})
	if(b_1_12)
	{
		// 0.00  <=>  0.
		out_attr3.x = 0.;
	}
	// False  <=>  ((((({in_attr5.w : 1060.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 1060.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_13 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// False  <=>  if({b_1_13 : False})
	if(b_1_13)
	{
		// 1060.50  <=>  {utof(u_0_phi_11) : 1060.50}
		gl_Position.z = utof(u_0_phi_11);
	}
	// False  <=>  ((((({in_attr5.w : 1060.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 1060.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_14 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// False  <=>  if({b_1_14 : False})
	if(b_1_14)
	{
		return;
	}
	// 256.7491  <=>  (clamp((min(0., {in_attr7.x : 0.33394}) + (0. - 0.)), 0.0, 1.0) + {in_attr6.x : 256.7491})
	pf_2_0 = (clamp((min(0., in_attr7.x) + (0. - 0.)), 0.0, 1.0) + in_attr6.x);
	// 1141932032  <=>  {ftou(pf_0_1) : 1141932032}
	u_0_6 = ftou(pf_0_1);
	// 1148846080  <=>  {ftou(float(int({u_1_1 : 1000}))) : 1148846080}
	u_3_4 = ftou(float(int(u_1_1)));
	u_0_phi_15 = u_0_6;
	u_3_phi_15 = u_3_4;
	// False  <=>  if(((((0. < {utof(vs_cbuf9[11].y) : 0.00}) && (! isnan(0.))) && (! isnan({utof(vs_cbuf9[11].y) : 0.00}))) ? true : false))
	if(((((0. < utof(vs_cbuf9[11].y)) && (! isnan(0.))) && (! isnan(utof(vs_cbuf9[11].y)))) ? true : false))
	{
		// ∞  <=>  (((({in_attr7.x : 0.33394} * {utof(vs_cbuf9[12].z) : 0.00}) * {utof(vs_cbuf9[11].y) : 0.00}) + {pf_0_1 : 578.00}) * (1.0 / {utof(vs_cbuf9[11].y) : 0.00}))
		pf_0_3 = ((((in_attr7.x * utof(vs_cbuf9[12].z)) * utof(vs_cbuf9[11].y)) + pf_0_1) * (1.0 / utof(vs_cbuf9[11].y)));
		// 2139095040  <=>  {ftou(pf_0_3) : 2139095040}
		u_4_2 = ftou(pf_0_3);
		// ∞  <=>  floor({pf_0_3 : ∞})
		f_1_10 = floor(pf_0_3);
		// NaN  <=>  ({pf_0_3 : ∞} + (0. - {f_1_10 : ∞}))
		pf_0_4 = (pf_0_3 + (0. - f_1_10));
		// 4290772992  <=>  {ftou(pf_0_4) : 4290772992}
		u_0_7 = ftou(pf_0_4);
		// 2139095040  <=>  {u_4_2 : 2139095040}
		u_3_5 = u_4_2;
		u_0_phi_15 = u_0_7;
		u_3_phi_15 = u_3_5;
	}
	// True  <=>  ((! (((0. < {utof(vs_cbuf9[11].y) : 0.00}) && (! isnan(0.))) && (! isnan({utof(vs_cbuf9[11].y) : 0.00})))) ? true : false)
	b_0_5 = ((! (((0. < utof(vs_cbuf9[11].y)) && (! isnan(0.))) && (! isnan(utof(vs_cbuf9[11].y))))) ? true : false);
	// 1141932032  <=>  {u_0_phi_15 : 1141932032}
	u_1_3 = u_0_phi_15;
	u_1_phi_16 = u_1_3;
	// True  <=>  if({b_0_5 : True})
	if(b_0_5)
	{
		// 1058273231  <=>  {ftou(({utof(u_0_phi_15) : 578.00} * (1.0 / {utof(u_3_phi_15) : 1000.00}))) : 1058273231}
		u_1_4 = ftou((utof(u_0_phi_15) * (1.0 / utof(u_3_phi_15))));
		u_1_phi_16 = u_1_4;
	}
	// 10.00  <=>  (({utof(vs_cbuf9[114].x) : 1.00} + (0. - {utof(vs_cbuf9[113].x) : 0.00})) * (1.0 / ((0. - {utof(vs_cbuf9[113].w) : 0.00}) + {utof(vs_cbuf9[114].w) : 0.10})))
	pf_4_2 = ((utof(vs_cbuf9[114].x) + (0. - utof(vs_cbuf9[113].x))) * (1.0 / ((0. - utof(vs_cbuf9[113].w)) + utof(vs_cbuf9[114].w))));
	// 0.2858  <=>  clamp((floor(({in_attr7.x : 0.33394} * 8.)) * 0.1429), 0.0, 1.0)
	f_8_1 = clamp((floor((in_attr7.x * 8.)) * 0.1429), 0.0, 1.0);
	// 12  <=>  (isnan({in_attr1.z : 12.00}) ? 0u : int(clamp(trunc({in_attr1.z : 12.00}), float(-2147483600.), float(2147483600.))))
	u_2_5 = (isnan(in_attr1.z) ? 0u : int(clamp(trunc(in_attr1.z), float(-2147483600.), float(2147483600.))));
	// 7.00  <=>  (float(int({uvec4(uvec2(textureSize({tex0 : tex0}, int(0u))), 0u, 0u).x : 8})) + -1.)
	pf_7_0 = (float(int(uvec4(uvec2(textureSize(tex0, int(0u))), 0u, 0u).x)) + -1.);
	// 2.0006  <=>  ({pf_7_0 : 7.00} * {f_8_1 : 0.2858})
	pf_8_0 = (pf_7_0 * f_8_1);
	// 2  <=>  (isnan({pf_8_0 : 2.0006}) ? 0u : int(clamp(trunc({pf_8_0 : 2.0006}), float(-2147483600.), float(2147483600.))))
	u_3_7 = (isnan(pf_8_0) ? 0u : int(clamp(trunc(pf_8_0), float(-2147483600.), float(2147483600.))));
	// 3  <=>  min(int((isnan({pf_7_0 : 7.00}) ? 0u : int(clamp(trunc({pf_7_0 : 7.00}), float(-2147483600.), float(2147483600.))))), int(({u_3_7 : 2} + 1u)))
	u_0_11 = min(int((isnan(pf_7_0) ? 0u : int(clamp(trunc(pf_7_0), float(-2147483600.), float(2147483600.))))), int((u_3_7 + 1u)));
	// uvec2(2,12)  <=>  uvec2({u_3_7 : 2}, {u_2_5 : 12})
	u2_0_0 = uvec2(u_3_7, u_2_5);
	// vec4(0.50,0.50,0.50,1.00)  <=>  texelFetch({tex0 : tex0}, ivec2({u2_0_0 : uvec2(2,12)}), int(0u))
	f4_0_0 = texelFetch(tex0, ivec2(u2_0_0), int(0u));
	// 0.50  <=>  {f4_0_0.x : 0.50}
	f_1_18 = f4_0_0.x;
	// vec4(0.50,0.50,0.50,1.00)  <=>  texelFetch({tex0 : tex0}, ivec2(uvec2({u_0_11 : 3}, {u_2_5 : 12})), int(0u))
	f4_0_1 = texelFetch(tex0, ivec2(uvec2(u_0_11, u_2_5)), int(0u));
	// 0.50  <=>  {f4_0_1.y : 0.50}
	f_9_2 = f4_0_1.y;
	// 1065353216  <=>  (((({utof(u_1_phi_16) : 0.578} >= {utof(vs_cbuf9[113].w) : 0.00}) && (! isnan({utof(u_1_phi_16) : 0.578}))) && (! isnan({utof(vs_cbuf9[113].w) : 0.00}))) ? 1065353216u : 0u)
	u_0_12 = ((((utof(u_1_phi_16) >= utof(vs_cbuf9[113].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[113].w)))) ? 1065353216u : 0u);
	// 2.00  <=>  floor(({in_attr7.x : 0.33394} * 8.))
	out_attr6.x = floor((in_attr7.x * 8.));
	// 1065353216  <=>  (((({utof(u_1_phi_16) : 0.578} >= {utof(vs_cbuf9[114].w) : 0.10}) && (! isnan({utof(u_1_phi_16) : 0.578}))) && (! isnan({utof(vs_cbuf9[114].w) : 0.10}))) ? 1065353216u : 0u)
	u_2_6 = ((((utof(u_1_phi_16) >= utof(vs_cbuf9[114].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[114].w)))) ? 1065353216u : 0u);
	// 1.00  <=>  {utof(u_0_12) : 1.00}
	f_4_8 = utof(u_0_12);
	// -9.999998  <=>  (({utof(vs_cbuf9[116].x) : 0.00} + (0. - {utof(vs_cbuf9[115].x) : 1.00})) * (1.0 / ((0. - {utof(vs_cbuf9[115].w) : 0.90}) + {utof(vs_cbuf9[116].w) : 1.00})))
	pf_10_1 = ((utof(vs_cbuf9[116].x) + (0. - utof(vs_cbuf9[115].x))) * (1.0 / ((0. - utof(vs_cbuf9[115].w)) + utof(vs_cbuf9[116].w))));
	// 0.00  <=>  (((0. - {utof(vs_cbuf9[114].x) : 1.00}) + {utof(vs_cbuf9[115].x) : 1.00}) * (1.0 / ({utof(vs_cbuf9[115].w) : 0.90} + (0. - {utof(vs_cbuf9[114].w) : 0.10}))))
	pf_9_2 = (((0. - utof(vs_cbuf9[114].x)) + utof(vs_cbuf9[115].x)) * (1.0 / (utof(vs_cbuf9[115].w) + (0. - utof(vs_cbuf9[114].w)))));
	// 0.00  <=>  (((({pf_4_2 : 10.00} * ({utof(u_1_phi_16) : 0.578} + (0. - {utof(vs_cbuf9[113].w) : 0.00}))) + {utof(vs_cbuf9[113].x) : 0.00}) * (({utof(u_2_6) : 1.00} * (0. - {f_4_8 : 1.00})) + {utof(u_0_12) : 1.00})) + (({utof(u_0_12) : 1.00} * (0. - {utof(vs_cbuf9[113].x) : 0.00})) + {utof(vs_cbuf9[113].x) : 0.00}))
	pf_4_4 = ((((pf_4_2 * (utof(u_1_phi_16) + (0. - utof(vs_cbuf9[113].w)))) + utof(vs_cbuf9[113].x)) * ((utof(u_2_6) * (0. - f_4_8)) + utof(u_0_12))) + ((utof(u_0_12) * (0. - utof(vs_cbuf9[113].x))) + utof(vs_cbuf9[113].x)));
	// 0.8242117  <=>  (({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].w) : 1.00}) + (0. - ({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].z) : 0.00})))
	pf_7_5 = ((utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].w)) + (0. - (utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].z))));
	// 0.00  <=>  (({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].z) : 0.00}) + (0. - ({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].x) : 0.00})))
	pf_13_1 = ((utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].z)) + (0. - (utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].x))));
	// 564.6999  <=>  ((({in_attr4.z : -1225.846} * {in_attr9.z : 0.00}) + (({in_attr4.y : -253.9866} * {in_attr9.y : 0.00}) + ({in_attr4.x : 277.3888} * {in_attr9.x : 1.00}))) + {in_attr9.w : 287.3111})
	pf_6_4 = (((in_attr4.z * in_attr9.z) + ((in_attr4.y * in_attr9.y) + (in_attr4.x * in_attr9.x))) + in_attr9.w);
	// 0.00  <=>  (({utof(vs_cbuf8[2].y) : 0.5585706} * {utof(vs_cbuf8[3].z) : 0.00}) + (0. - ({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].y) : 0.00})))
	pf_20_0 = ((utof(vs_cbuf8[2].y) * utof(vs_cbuf8[3].z)) + (0. - (utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].y))));
	// 0  <=>  (((({utof(u_1_phi_16) : 0.578} >= {utof(vs_cbuf9[115].w) : 0.90}) && (! isnan({utof(u_1_phi_16) : 0.578}))) && (! isnan({utof(vs_cbuf9[115].w) : 0.90}))) ? 1065353216u : 0u)
	u_0_13 = ((((utof(u_1_phi_16) >= utof(vs_cbuf9[115].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[115].w)))) ? 1065353216u : 0u);
	// 0.00  <=>  ((({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].x) : 0.00}) + (0. - ({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].z) : 0.00}))) * {utof(vs_cbuf8[1].y) : 0.829457})
	pf_11_3 = (((utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].x)) + (0. - (utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].z)))) * utof(vs_cbuf8[1].y));
	// 1268.157  <=>  ((({in_attr4.z : -1225.846} * {in_attr10.z : 0.00}) + (({in_attr4.y : -253.9866} * {in_attr10.y : 1.00}) + ({in_attr4.x : 277.3888} * {in_attr10.x : 0.00}))) + {in_attr10.w : 1522.144})
	pf_5_3 = (((in_attr4.z * in_attr10.z) + ((in_attr4.y * in_attr10.y) + (in_attr4.x * in_attr10.x))) + in_attr10.w);
	// -277.3888  <=>  ((0. - {pf_6_4 : 564.6999}) + {utof(vs_cbuf8[29].x) : 287.3111})
	pf_22_0 = ((0. - pf_6_4) + utof(vs_cbuf8[29].x));
	// 1.00  <=>  (({pf_9_2 : 0.00} * ({utof(u_1_phi_16) : 0.578} + (0. - {utof(vs_cbuf9[114].w) : 0.10}))) + {utof(vs_cbuf9[114].x) : 1.00})
	pf_9_3 = ((pf_9_2 * (utof(u_1_phi_16) + (0. - utof(vs_cbuf9[114].w)))) + utof(vs_cbuf9[114].x));
	// 0.00  <=>  {utof(u_0_13) : 0.00}
	f_3_32 = utof(u_0_13);
	// 1.00  <=>  {utof(u_2_6) : 1.00}
	f_4_28 = utof(u_2_6);
	// 0.0931343  <=>  (({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].x) : 0.00}) + (0. - ({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].w) : 1.00})))
	pf_18_1 = ((utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].x)) + (0. - (utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].w))));
	// 403.9866  <=>  ((0. - {pf_5_3 : 1268.157}) + {utof(vs_cbuf8[29].y) : 1672.144})
	pf_23_0 = ((0. - pf_5_3) + utof(vs_cbuf8[29].y));
	// 170.8237  <=>  ((({in_attr4.z : -1225.846} * {in_attr11.z : 1.00}) + (({in_attr4.y : -253.9866} * {in_attr11.y : 0.00}) + ({in_attr4.x : 277.3888} * {in_attr11.x : 0.00}))) + {in_attr11.w : 1396.67})
	pf_0_11 = (((in_attr4.z * in_attr11.z) + ((in_attr4.y * in_attr11.y) + (in_attr4.x * in_attr11.x))) + in_attr11.w);
	// 0.0350325  <=>  ((({utof(vs_cbuf8[2].y) : 0.5585706} * {utof(vs_cbuf8[3].w) : 1.00}) + (0. - ({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].y) : 0.00}))) * {utof(vs_cbuf8[1].x) : 0.0627182})
	pf_9_4 = (((utof(vs_cbuf8[2].y) * utof(vs_cbuf8[3].w)) + (0. - (utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].y)))) * utof(vs_cbuf8[1].x));
	// 0.00  <=>  (((({utof(vs_cbuf8[3].z) : 0.00} * {utof(vs_cbuf8[2].y) : 0.5585706}) + (0. - ({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].y) : 0.00}))) * {utof(vs_cbuf8[1].x) : 0.0627182}) + {pf_11_3 : 0.00})
	pf_11_4 = ((((utof(vs_cbuf8[3].z) * utof(vs_cbuf8[2].y)) + (0. - (utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].y)))) * utof(vs_cbuf8[1].x)) + pf_11_3);
	// 1225.846  <=>  ((0. - {pf_0_11 : 170.8237}) + {utof(vs_cbuf8[29].z) : 1396.669})
	pf_24_1 = ((0. - pf_0_11) + utof(vs_cbuf8[29].z));
	// -0.00  <=>  ({pf_13_1 : 0.00} * {utof(vs_cbuf8[1].w) : -629.7858})
	pf_25_0 = (pf_13_1 * utof(vs_cbuf8[1].w));
	// 0.0350325  <=>  (((({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].y) : 0.00}) + (0. - ({utof(vs_cbuf8[3].x) : 0.00} * {utof(vs_cbuf8[2].y) : 0.5585706}))) * {utof(vs_cbuf8[1].w) : -629.7858}) + {pf_9_4 : 0.0350325})
	pf_9_5 = ((((utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].y)) + (0. - (utof(vs_cbuf8[3].x) * utof(vs_cbuf8[2].y)))) * utof(vs_cbuf8[1].w)) + pf_9_4);
	// -0.0627182  <=>  (((({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].y) : 0.00}) + (0. - ({utof(vs_cbuf8[2].y) : 0.5585706} * {utof(vs_cbuf8[3].w) : 1.00}))) * {utof(vs_cbuf8[0].z) : 0.1122834}) + ({pf_7_5 : 0.8242117} * {utof(vs_cbuf8[0].y) : 0.00}))
	pf_12_2 = ((((utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].y)) + (0. - (utof(vs_cbuf8[2].y) * utof(vs_cbuf8[3].w)))) * utof(vs_cbuf8[0].z)) + (pf_7_5 * utof(vs_cbuf8[0].y)));
	// 0.310028  <=>  ((({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].y) : 0.00}) + (0. - ({utof(vs_cbuf8[3].w) : 1.00} * {utof(vs_cbuf8[2].y) : 0.5585706}))) * {utof(vs_cbuf8[1].z) : -0.5550383})
	pf_15_2 = (((utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].y)) + (0. - (utof(vs_cbuf8[3].w) * utof(vs_cbuf8[2].y)))) * utof(vs_cbuf8[1].z));
	// 1742847.00  <=>  (({pf_24_1 : 1225.846} * {pf_24_1 : 1225.846}) + (({pf_23_0 : 403.9866} * {pf_23_0 : 403.9866}) + ({pf_22_0 : -277.3888} * {pf_22_0 : -277.3888})))
	pf_17_3 = ((pf_24_1 * pf_24_1) + ((pf_23_0 * pf_23_0) + (pf_22_0 * pf_22_0)));
	// 0.5550383  <=>  ((({utof(vs_cbuf8[2].y) : 0.5585706} * {utof(vs_cbuf8[3].w) : 1.00}) + (0. - ({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].y) : 0.00}))) * {utof(vs_cbuf8[0].x) : 0.9936762})
	pf_16_2 = (((utof(vs_cbuf8[2].y) * utof(vs_cbuf8[3].w)) + (0. - (utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].y)))) * utof(vs_cbuf8[0].x));
	// 0.00  <=>  (((({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].y) : 0.00}) + (0. - ({utof(vs_cbuf8[2].y) : 0.5585706} * {utof(vs_cbuf8[3].x) : 0.00}))) * {utof(vs_cbuf8[1].z) : -0.5550383}) + {pf_11_4 : 0.00})
	pf_11_5 = ((((utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].y)) + (0. - (utof(vs_cbuf8[2].y) * utof(vs_cbuf8[3].x)))) * utof(vs_cbuf8[1].z)) + pf_11_4);
	// -0.00  <=>  (({pf_7_5 : 0.8242117} * {utof(vs_cbuf8[1].x) : 0.0627182}) + (({pf_18_1 : 0.0931343} * {utof(vs_cbuf8[1].z) : -0.5550383}) + {pf_25_0 : -0.00}))
	pf_7_6 = ((pf_7_5 * utof(vs_cbuf8[1].x)) + ((pf_18_1 * utof(vs_cbuf8[1].z)) + pf_25_0));
	// 0.5550383  <=>  (({pf_18_1 : 0.0931343} * {utof(vs_cbuf8[0].y) : 0.00}) + {pf_16_2 : 0.5550383})
	pf_16_3 = ((pf_18_1 * utof(vs_cbuf8[0].y)) + pf_16_2);
	// 0.3060111  <=>  ({pf_23_0 : 403.9866} * inversesqrt({pf_17_3 : 1742847.00}))
	pf_17_5 = (pf_23_0 * inversesqrt(pf_17_3));
	// 175.4452  <=>  (({in_attr6.y : 175.4452} * {utof(vs_cbuf9[141].y) : 1.00}) * {utof(vs_cbuf10[3].z) : 1.00})
	out_attr5.y = ((in_attr6.y * utof(vs_cbuf9[141].y)) * utof(vs_cbuf10[3].z));
	// 0.9285518  <=>  ({pf_24_1 : 1225.846} * inversesqrt({pf_17_3 : 1742847.00}))
	pf_18_2 = (pf_24_1 * inversesqrt(pf_17_3));
	// -0.210116  <=>  ({pf_22_0 : -277.3888} * inversesqrt({pf_17_3 : 1742847.00}))
	pf_19_3 = (pf_22_0 * inversesqrt(pf_17_3));
	// 0.5550383  <=>  (((({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].y) : 0.00}) + (0. - ({utof(vs_cbuf8[2].y) : 0.5585706} * {utof(vs_cbuf8[3].x) : 0.00}))) * {utof(vs_cbuf8[0].w) : -442.3171}) + {pf_16_3 : 0.5550383})
	pf_14_2 = ((((utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].y)) + (0. - (utof(vs_cbuf8[2].y) * utof(vs_cbuf8[3].x)))) * utof(vs_cbuf8[0].w)) + pf_16_3);
	// -0.9285518  <=>  ((0. * {pf_17_5 : 0.3060111}) + (0. - {pf_18_2 : 0.9285518}))
	pf_16_4 = ((0. * pf_17_5) + (0. - pf_18_2));
	// 0.9873924  <=>  (({pf_7_6 : -0.00} * (0. - {utof(vs_cbuf8[0].y) : 0.00})) + ((({pf_20_0 : 0.00} * {utof(vs_cbuf8[1].w) : -629.7858}) + (({pf_7_5 : 0.8242117} * {utof(vs_cbuf8[1].y) : 0.829457}) + {pf_15_2 : 0.310028})) * {utof(vs_cbuf8[0].x) : 0.9936762}))
	pf_7_7 = ((pf_7_6 * (0. - utof(vs_cbuf8[0].y))) + (((pf_20_0 * utof(vs_cbuf8[1].w)) + ((pf_7_5 * utof(vs_cbuf8[1].y)) + pf_15_2)) * utof(vs_cbuf8[0].x)));
	// -0.210116  <=>  ((0. - 0.) + {pf_19_3 : -0.210116})
	pf_15_6 = ((0. - 0.) + pf_19_3);
	// 1.050389  <=>  inversesqrt((({pf_15_6 : -0.210116} * {pf_15_6 : -0.210116}) + (({pf_16_4 : -0.9285518} * {pf_16_4 : -0.9285518}) + 0.)))
	f_2_42 = inversesqrt(((pf_15_6 * pf_15_6) + ((pf_16_4 * pf_16_4) + 0.)));
	// 1.00  <=>  (1.0 / (({pf_11_5 : 0.00} * (0. - {utof(vs_cbuf8[0].w) : -442.3171})) + (((({pf_18_1 : 0.0931343} * {utof(vs_cbuf8[1].y) : 0.829457}) + {pf_9_5 : 0.0350325}) * {utof(vs_cbuf8[0].z) : 0.1122834}) + {pf_7_7 : 0.9873924})))
	f_4_43 = (1.0 / ((pf_11_5 * (0. - utof(vs_cbuf8[0].w))) + ((((pf_18_1 * utof(vs_cbuf8[1].y)) + pf_9_5) * utof(vs_cbuf8[0].z)) + pf_7_7)));
	// 0.0675378  <=>  (({pf_18_2 : 0.9285518} * (0. * {f_2_42 : 1.050389})) + (0. - ({pf_17_5 : 0.3060111} * ({pf_15_6 : -0.210116} * {f_2_42 : 1.050389}))))
	pf_15_8 = ((pf_18_2 * (0. * f_2_42)) + (0. - (pf_17_5 * (pf_15_6 * f_2_42))));
	// 0.952028  <=>  (({pf_19_3 : -0.210116} * ({pf_15_6 : -0.210116} * {f_2_42 : 1.050389})) + (0. - ({pf_18_2 : 0.9285518} * ({pf_16_4 : -0.9285518} * {f_2_42 : 1.050389}))))
	pf_7_11 = ((pf_19_3 * (pf_15_6 * f_2_42)) + (0. - (pf_18_2 * (pf_16_4 * f_2_42))));
	// -0.2984652  <=>  (({pf_17_5 : 0.3060111} * ({pf_16_4 : -0.9285518} * {f_2_42 : 1.050389})) + (0. - ({pf_19_3 : -0.210116} * (0. * {f_2_42 : 1.050389}))))
	pf_9_9 = ((pf_17_5 * (pf_16_4 * f_2_42)) + (0. - (pf_19_3 * (0. * f_2_42))));
	// 0.9109186  <=>  (({pf_7_11 : 0.952028} * {pf_7_11 : 0.952028}) + ({pf_15_8 : 0.0675378} * {pf_15_8 : 0.0675378}))
	pf_11_8 = ((pf_7_11 * pf_7_11) + (pf_15_8 * pf_15_8));
	// 1.00  <=>  (({pf_9_9 : -0.2984652} * {pf_9_9 : -0.2984652}) + {pf_11_8 : 0.9109186})
	pf_11_9 = ((pf_9_9 * pf_9_9) + pf_11_8);
	// 1.00  <=>  inversesqrt({pf_11_9 : 1.00})
	f_2_50 = inversesqrt(pf_11_9);
	// 0.829457  <=>  ((({pf_13_1 : 0.00} * {utof(vs_cbuf8[0].w) : -442.3171}) + (({pf_18_1 : 0.0931343} * {utof(vs_cbuf8[0].z) : 0.1122834}) + ({pf_7_5 : 0.8242117} * {utof(vs_cbuf8[0].x) : 0.9936762}))) * {f_4_43 : 1.00})
	pf_11_10 = (((pf_13_1 * utof(vs_cbuf8[0].w)) + ((pf_18_1 * utof(vs_cbuf8[0].z)) + (pf_7_5 * utof(vs_cbuf8[0].x)))) * f_4_43);
	// 0.00  <=>  {utof(u_0_13) : 0.00}
	f_4_45 = utof(u_0_13);
	// 0.00  <=>  {utof((((({utof(u_1_phi_16) : 0.578} >= {utof(vs_cbuf9[116].w) : 1.00}) && (! isnan({utof(u_1_phi_16) : 0.578}))) && (! isnan({utof(vs_cbuf9[116].w) : 1.00}))) ? 1065353216u : 0u)) : 0.00}
	f_5_13 = utof(((((utof(u_1_phi_16) >= utof(vs_cbuf9[116].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[116].w)))) ? 1065353216u : 0u));
	// 0.00  <=>  {utof(u_0_13) : 0.00}
	f_11_3 = utof(u_0_13);
	// -0.0191925  <=>  (0. - ({pf_17_5 : 0.3060111} * ((({pf_20_0 : 0.00} * {utof(vs_cbuf8[0].w) : -442.3171}) + {pf_12_2 : -0.0627182}) * (0. - {f_4_43 : 1.00}))))
	f_4_46 = (0. - (pf_17_5 * (((pf_20_0 * utof(vs_cbuf8[0].w)) + pf_12_2) * (0. - f_4_43))));
	// 1.00  <=>  (((({pf_10_1 : -9.999998} * ({utof(u_1_phi_16) : 0.578} + (0. - {utof(vs_cbuf9[115].w) : 0.90}))) + {utof(vs_cbuf9[115].x) : 1.00}) * (({f_11_3 : 0.00} * (0. - {f_5_13 : 0.00})) + {f_4_45 : 0.00})) + (({pf_9_3 : 1.00} * (({f_4_28 : 1.00} * (0. - {f_3_32 : 0.00})) + {utof(u_2_6) : 1.00})) + {pf_4_4 : 0.00}))
	pf_4_6 = ((((pf_10_1 * (utof(u_1_phi_16) + (0. - utof(vs_cbuf9[115].w)))) + utof(vs_cbuf9[115].x)) * ((f_11_3 * (0. - f_5_13)) + f_4_45)) + ((pf_9_3 * ((f_4_28 * (0. - f_3_32)) + utof(u_2_6))) + pf_4_4));
	// 0.952028  <=>  ({pf_7_11 : 0.952028} * {f_2_50 : 1.00})
	pf_7_12 = (pf_7_11 * f_2_50);
	// -0.0583854  <=>  (({pf_18_2 : 0.9285518} * ((({pf_20_0 : 0.00} * {utof(vs_cbuf8[0].w) : -442.3171}) + {pf_12_2 : -0.0627182}) * (0. - {f_4_43 : 1.00}))) + (0. - ({pf_19_3 : -0.210116} * ({pf_14_2 : 0.5550383} * (0. - {f_4_43 : 1.00})))))
	pf_14_4 = ((pf_18_2 * (((pf_20_0 * utof(vs_cbuf8[0].w)) + pf_12_2) * (0. - f_4_43))) + (0. - (pf_19_3 * (pf_14_2 * (0. - f_4_43)))));
	// -0.9400417  <=>  (({pf_17_5 : 0.3060111} * ({pf_14_2 : 0.5550383} * (0. - {f_4_43 : 1.00}))) + (0. - ({pf_18_2 : 0.9285518} * {pf_11_10 : 0.829457})))
	pf_10_4 = ((pf_17_5 * (pf_14_2 * (0. - f_4_43))) + (0. - (pf_18_2 * pf_11_10)));
	// 0.047972  <=>  ((0. - clamp(({pf_7_12 : 0.952028} + (0. - 0.)), 0.0, 1.0)) + 1.)
	pf_20_5 = ((0. - clamp((pf_7_12 + (0. - 0.)), 0.0, 1.0)) + 1.);
	// 0.00  <=>  {utof((((({utof(u_1_phi_16) : 0.578} >= {utof(vs_cbuf9[116].w) : 1.00}) && (! isnan({utof(u_1_phi_16) : 0.578}))) && (! isnan({utof(vs_cbuf9[116].w) : 1.00}))) ? 1065353216u : 0u)) : 0.00}
	f_11_4 = utof(((((utof(u_1_phi_16) >= utof(vs_cbuf9[116].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[116].w)))) ? 1065353216u : 0u));
	// 0.8870872  <=>  (({pf_14_4 : -0.0583854} * {pf_14_4 : -0.0583854}) + ({pf_10_4 : -0.9400417} * {pf_10_4 : -0.9400417}))
	pf_20_6 = ((pf_14_4 * pf_14_4) + (pf_10_4 * pf_10_4));
	// 1.040021  <=>  inversesqrt((((({pf_19_3 : -0.210116} * {pf_11_10 : 0.829457}) + {f_4_46 : -0.0191925}) * (({pf_19_3 : -0.210116} * {pf_11_10 : 0.829457}) + {f_4_46 : -0.0191925})) + {pf_20_6 : 0.8870872}))
	f_4_52 = inversesqrt(((((pf_19_3 * pf_11_10) + f_4_46) * ((pf_19_3 * pf_11_10) + f_4_46)) + pf_20_6));
	// 0.047972  <=>  exp2((log2({pf_20_5 : 0.047972}) * {utof(vs_cbuf13[6].y) : 1.00}))
	f_5_18 = exp2((log2(pf_20_5) * utof(vs_cbuf13[6].y)));
	// 0.952028  <=>  ((0. - {f_5_18 : 0.047972}) + 1.)
	pf_25_1 = ((0. - f_5_18) + 1.);
	// -0.975341  <=>  (({pf_17_5 : 0.3060111} * ({pf_9_9 : -0.2984652} * {f_2_50 : 1.00})) + (0. - ({pf_18_2 : 0.9285518} * {pf_7_12 : 0.952028})))
	pf_20_9 = ((pf_17_5 * (pf_9_9 * f_2_50)) + (0. - (pf_18_2 * pf_7_12)));
	// -0.0469005  <=>  (({pf_10_4 : -0.9400417} * {f_4_52 : 1.040021}) * {f_5_18 : 0.047972})
	pf_10_6 = ((pf_10_4 * f_4_52) * f_5_18);
	// -0.002913  <=>  (({pf_14_4 : -0.0583854} * {f_4_52 : 1.040021}) * {f_5_18 : 0.047972})
	pf_14_6 = ((pf_14_4 * f_4_52) * f_5_18);
	// 0.00  <=>  (({pf_18_2 : 0.9285518} * ({pf_15_8 : 0.0675378} * {f_2_50 : 1.00})) + (0. - ({pf_19_3 : -0.210116} * ({pf_9_9 : -0.2984652} * {f_2_50 : 1.00}))))
	pf_21_7 = ((pf_18_2 * (pf_15_8 * f_2_50)) + (0. - (pf_19_3 * (pf_9_9 * f_2_50))));
	// 0.0673066  <=>  ((({pf_15_8 : 0.0675378} * {f_2_50 : 1.00}) * {pf_25_1 : 0.952028}) + (((({pf_20_0 : 0.00} * {utof(vs_cbuf8[0].w) : -442.3171}) + {pf_12_2 : -0.0627182}) * (0. - {f_4_43 : 1.00})) * {f_5_18 : 0.047972}))
	pf_12_6 = (((pf_15_8 * f_2_50) * pf_25_1) + ((((pf_20_0 * utof(vs_cbuf8[0].w)) + pf_12_2) * (0. - f_4_43)) * f_5_18));
	// -0.0096528  <=>  (((({pf_19_3 : -0.210116} * {pf_11_10 : 0.829457}) + {f_4_46 : -0.0191925}) * {f_4_52 : 1.040021}) * {f_5_18 : 0.047972})
	pf_16_10 = ((((pf_19_3 * pf_11_10) + f_4_46) * f_4_52) * f_5_18);
	// -0.2207036  <=>  (({pf_19_3 : -0.210116} * {pf_7_12 : 0.952028}) + (0. - ({pf_17_5 : 0.3060111} * ({pf_15_8 : 0.0675378} * {f_2_50 : 1.00}))))
	pf_15_11 = ((pf_19_3 * pf_7_12) + (0. - (pf_17_5 * (pf_15_8 * f_2_50))));
	// 0.95129  <=>  (({pf_21_7 : 0.00} * {pf_21_7 : 0.00}) + ({pf_20_9 : -0.975341} * {pf_20_9 : -0.975341}))
	pf_26_1 = ((pf_21_7 * pf_21_7) + (pf_20_9 * pf_20_9));
	// -0.3107735  <=>  ((({pf_9_9 : -0.2984652} * {f_2_50 : 1.00}) * {pf_25_1 : 0.952028}) + (({pf_14_2 : 0.5550383} * (0. - {f_4_43 : 1.00})) * {f_5_18 : 0.047972}))
	pf_9_11 = (((pf_9_9 * f_2_50) * pf_25_1) + ((pf_14_2 * (0. - f_4_43)) * f_5_18));
	// 1.00  <=>  (({pf_15_11 : -0.2207036} * {pf_15_11 : -0.2207036}) + {pf_26_1 : 0.95129})
	pf_13_5 = ((pf_15_11 * pf_15_11) + pf_26_1);
	// -0.2207036  <=>  ({pf_15_11 : -0.2207036} * inversesqrt({pf_13_5 : 1.00}))
	pf_13_6 = (pf_15_11 * inversesqrt(pf_13_5));
	// 0.946148  <=>  (({pf_7_12 : 0.952028} * {pf_25_1 : 0.952028}) + ({pf_11_10 : 0.829457} * {f_5_18 : 0.047972}))
	pf_7_13 = ((pf_7_12 * pf_25_1) + (pf_11_10 * f_5_18));
	// -0.2197689  <=>  (({pf_13_6 : -0.2207036} * {pf_25_1 : 0.952028}) + {pf_16_10 : -0.0096528})
	pf_13_7 = ((pf_13_6 * pf_25_1) + pf_16_10);
	// -0.002913  <=>  ((({pf_21_7 : 0.00} * inversesqrt({pf_13_5 : 1.00})) * {pf_25_1 : 0.952028}) + {pf_14_6 : -0.002913})
	pf_14_7 = (((pf_21_7 * inversesqrt(pf_13_5)) * pf_25_1) + pf_14_6);
	// -0.210116  <=>  (({pf_19_3 : -0.210116} * {pf_25_1 : 0.952028}) + ({pf_19_3 : -0.210116} * {f_5_18 : 0.047972}))
	pf_11_13 = ((pf_19_3 * pf_25_1) + (pf_19_3 * f_5_18));
	// 1.00  <=>  ((({f_11_4 : 0.00} * {utof(vs_cbuf9[116].x) : 0.00}) + {pf_4_6 : 1.00}) * {utof(vs_cbuf10[0].w) : 1.00})
	out_attr0.w = (((f_11_4 * utof(vs_cbuf9[116].x)) + pf_4_6) * utof(vs_cbuf10[0].w));
	// -0.9754524  <=>  ((({pf_20_9 : -0.975341} * inversesqrt({pf_13_5 : 1.00})) * {pf_25_1 : 0.952028}) + {pf_10_6 : -0.0469005})
	pf_10_7 = (((pf_20_9 * inversesqrt(pf_13_5)) * pf_25_1) + pf_10_6);
	// 0.9285518  <=>  (({pf_18_2 : 0.9285518} * {pf_25_1 : 0.952028}) + ({pf_18_2 : 0.9285518} * {f_5_18 : 0.047972}))
	pf_15_14 = ((pf_18_2 * pf_25_1) + (pf_18_2 * f_5_18));
	// 0.9963064  <=>  (({pf_9_11 : -0.3107735} * {pf_9_11 : -0.3107735}) + (({pf_7_13 : 0.946148} * {pf_7_13 : 0.946148}) + ({pf_12_6 : 0.0673066} * {pf_12_6 : 0.0673066})))
	pf_4_10 = ((pf_9_11 * pf_9_11) + ((pf_7_13 * pf_7_13) + (pf_12_6 * pf_12_6)));
	// 0.3060111  <=>  (({pf_17_5 : 0.3060111} * {pf_25_1 : 0.952028}) + ({pf_17_5 : 0.3060111} * {f_5_18 : 0.047972}))
	pf_4_11 = ((pf_17_5 * pf_25_1) + (pf_17_5 * f_5_18));
	// 0.9515158  <=>  (({pf_14_7 : -0.002913} * {pf_14_7 : -0.002913}) + ({pf_10_7 : -0.9754524} * {pf_10_7 : -0.9754524}))
	pf_17_6 = ((pf_14_7 * pf_14_7) + (pf_10_7 * pf_10_7));
	// -0.50  <=>  (0. - {f4_0_0.y : 0.50})
	f_5_21 = (0. - f4_0_0.y);
	// 0.00  <=>  ((0. - {f4_0_0.z : 0.50}) + {f4_0_1.z : 0.50})
	pf_20_11 = ((0. - f4_0_0.z) + f4_0_1.z);
	// 0.50  <=>  ((((0. - {f_1_18 : 0.50}) + {f4_0_1.x : 0.50}) * ({pf_8_0 : 2.0006} + (0. - floor({pf_8_0 : 2.0006})))) + {f_1_18 : 0.50})
	pf_17_9 = ((((0. - f_1_18) + f4_0_1.x) * (pf_8_0 + (0. - floor(pf_8_0)))) + f_1_18);
	// 0.50  <=>  ((({f_5_21 : -0.50} + {f_9_2 : 0.50}) * ({pf_8_0 : 2.0006} + (0. - floor({pf_8_0 : 2.0006})))) + {f4_0_0.y : 0.50})
	pf_19_6 = (((f_5_21 + f_9_2) * (pf_8_0 + (0. - floor(pf_8_0)))) + f4_0_0.y);
	// 1.00  <=>  (({pf_15_14 : 0.9285518} * {pf_15_14 : 0.9285518}) + (({pf_4_11 : 0.3060111} * {pf_4_11 : 0.3060111}) + ({pf_11_13 : -0.210116} * {pf_11_13 : -0.210116})))
	pf_18_6 = ((pf_15_14 * pf_15_14) + ((pf_4_11 * pf_4_11) + (pf_11_13 * pf_11_13)));
	// 0.50  <=>  (({pf_20_11 : 0.00} * ({pf_8_0 : 2.0006} + (0. - floor({pf_8_0 : 2.0006})))) + {f4_0_0.z : 0.50})
	pf_8_2 = ((pf_20_11 * (pf_8_0 + (0. - floor(pf_8_0)))) + f4_0_0.z);
	// 128.3746  <=>  ((({pf_2_0 : 256.7491} * {utof(vs_cbuf9[141].x) : 1.00}) * {utof(vs_cbuf10[3].y) : 1.00}) * ((0.5 * {utof(vs_cbuf9[16].x) : 0.00}) + {pf_17_9 : 0.50}))
	pf_2_3 = (((pf_2_0 * utof(vs_cbuf9[141].x)) * utof(vs_cbuf10[3].y)) * ((0.5 * utof(vs_cbuf9[16].x)) + pf_17_9));
	// 87.72262  <=>  ((({in_attr6.y : 175.4452} * {utof(vs_cbuf9[141].y) : 1.00}) * {utof(vs_cbuf10[3].z) : 1.00}) * ((0.5 * {utof(vs_cbuf9[16].y) : 0.00}) + {pf_19_6 : 0.50}))
	pf_1_4 = (((in_attr6.y * utof(vs_cbuf9[141].y)) * utof(vs_cbuf10[3].z)) * ((0.5 * utof(vs_cbuf9[16].y)) + pf_19_6));
	// 87.72262  <=>  ({pf_8_2 : 0.50} * (({in_attr6.z : 175.4452} * {utof(vs_cbuf9[141].z) : 1.00}) * {utof(vs_cbuf10[3].w) : 1.00}))
	pf_3_2 = (pf_8_2 * ((in_attr6.z * utof(vs_cbuf9[141].z)) * utof(vs_cbuf10[3].w)));
	// -125.2349  <=>  ({pf_2_3 : 128.3746} * (inversesqrt((({pf_13_7 : -0.2197689} * {pf_13_7 : -0.2197689}) + {pf_17_6 : 0.9515158})) * {pf_10_7 : -0.9754524}))
	pf_10_9 = (pf_2_3 * (inversesqrt(((pf_13_7 * pf_13_7) + pf_17_6)) * pf_10_7));
	// -0.3739837  <=>  ({pf_2_3 : 128.3746} * (inversesqrt((({pf_13_7 : -0.2197689} * {pf_13_7 : -0.2197689}) + {pf_17_6 : 0.9515158})) * {pf_14_7 : -0.002913}))
	pf_14_9 = (pf_2_3 * (inversesqrt(((pf_13_7 * pf_13_7) + pf_17_6)) * pf_14_7));
	// -28.21535  <=>  ({pf_2_3 : 128.3746} * (inversesqrt((({pf_13_7 : -0.2197689} * {pf_13_7 : -0.2197689}) + {pf_17_6 : 0.9515158})) * {pf_13_7 : -0.2197689}))
	pf_2_4 = (pf_2_3 * (inversesqrt(((pf_13_7 * pf_13_7) + pf_17_6)) * pf_13_7));
	// -119.3197  <=>  (({pf_1_4 : 87.72262} * (inversesqrt({pf_4_10 : 0.9963064}) * {pf_12_6 : 0.0673066})) + {pf_10_9 : -125.2349})
	pf_8_4 = ((pf_1_4 * (inversesqrt(pf_4_10) * pf_12_6)) + pf_10_9);
	// 82.77831  <=>  (({pf_1_4 : 87.72262} * (inversesqrt({pf_4_10 : 0.9963064}) * {pf_7_13 : 0.946148})) + {pf_14_9 : -0.3739837})
	pf_7_15 = ((pf_1_4 * (inversesqrt(pf_4_10) * pf_7_13)) + pf_14_9);
	// -55.52771  <=>  (({pf_1_4 : 87.72262} * (inversesqrt({pf_4_10 : 0.9963064}) * {pf_9_11 : -0.3107735})) + {pf_2_4 : -28.21535})
	pf_1_5 = ((pf_1_4 * (inversesqrt(pf_4_10) * pf_9_11)) + pf_2_4);
	// -137.7516  <=>  (({pf_3_2 : 87.72262} * (inversesqrt({pf_18_6 : 1.00}) * {pf_11_13 : -0.210116})) + {pf_8_4 : -119.3197})
	pf_2_5 = ((pf_3_2 * (inversesqrt(pf_18_6) * pf_11_13)) + pf_8_4);
	// 109.6224  <=>  (({pf_3_2 : 87.72262} * (inversesqrt({pf_18_6 : 1.00}) * {pf_4_11 : 0.3060111})) + {pf_7_15 : 82.77831})
	pf_4_13 = ((pf_3_2 * (inversesqrt(pf_18_6) * pf_4_11)) + pf_7_15);
	// 25.92729  <=>  (({pf_3_2 : 87.72262} * (inversesqrt({pf_18_6 : 1.00}) * {pf_15_14 : 0.9285518})) + {pf_1_5 : -55.52771})
	pf_1_6 = ((pf_3_2 * (inversesqrt(pf_18_6) * pf_15_14)) + pf_1_5);
	// 196.751  <=>  ({pf_0_11 : 170.8237} + ({pf_1_6 : 25.92729} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972}))))
	pf_0_12 = (pf_0_11 + (pf_1_6 + ((0. * pf_25_1) + (0. * f_5_18))));
	// 424.2484  <=>  (({pf_6_4 : 564.6999} + ({pf_2_5 : -137.7516} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972})))) * {utof(vs_cbuf8[0].x) : 0.9936762})
	pf_1_8 = ((pf_6_4 + (pf_2_5 + ((0. * pf_25_1) + (0. * f_5_18)))) * utof(vs_cbuf8[0].x));
	// 26.77742  <=>  (({pf_6_4 : 564.6999} + ({pf_2_5 : -137.7516} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972})))) * {utof(vs_cbuf8[1].x) : 0.0627182})
	pf_8_5 = ((pf_6_4 + (pf_2_5 + ((0. * pf_25_1) + (0. * f_5_18)))) * utof(vs_cbuf8[1].x));
	// -0.1098191  <=>  (({pf_22_0 : -277.3888} * (1.0 / (sqrt({pf_17_3 : 1742847.00}) + float(1e-05)))) * {utof(vs_cbuf15[28].x) : 0.5226594})
	pf_6_6 = ((pf_22_0 * (1.0 / (sqrt(pf_17_3) + float(1e-05)))) * utof(vs_cbuf15[28].x));
	// -39.76352  <=>  (({pf_6_4 : 564.6999} + ({pf_2_5 : -137.7516} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972})))) * {utof(vs_cbuf8[2].x) : -0.0931343})
	pf_9_13 = ((pf_6_4 + (pf_2_5 + ((0. * pf_25_1) + (0. * f_5_18)))) * utof(vs_cbuf8[2].x));
	// -1377.78  <=>  (0. - ({pf_5_3 : 1268.157} + ({pf_4_13 : 109.6224} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972})))))
	f_4_57 = (0. - (pf_5_3 + (pf_4_13 + ((0. * pf_25_1) + (0. * f_5_18)))));
	// 294.3641  <=>  ({f_4_57 : -1377.78} + {utof(vs_cbuf15[60].w) : 1672.144})
	pf_10_10 = (f_4_57 + utof(vs_cbuf15[60].w));
	// -1377.78  <=>  (0. - ({pf_5_3 : 1268.157} + ({pf_4_13 : 109.6224} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972})))))
	f_4_58 = (0. - (pf_5_3 + (pf_4_13 + ((0. * pf_25_1) + (0. * f_5_18)))));
	// 294.3641  <=>  ({f_4_58 : -1377.78} + {utof(vs_cbuf8[29].y) : 1672.144})
	pf_11_15 = (f_4_58 + utof(vs_cbuf8[29].y));
	// 424.2484  <=>  ((({pf_5_3 : 1268.157} + ({pf_4_13 : 109.6224} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972})))) * {utof(vs_cbuf8[0].y) : 0.00}) + {pf_1_8 : 424.2484})
	pf_1_9 = (((pf_5_3 + (pf_4_13 + ((0. * pf_25_1) + (0. * f_5_18)))) * utof(vs_cbuf8[0].y)) + pf_1_8);
	// 1169.586  <=>  ((({pf_5_3 : 1268.157} + ({pf_4_13 : 109.6224} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972})))) * {utof(vs_cbuf8[1].y) : 0.829457}) + {pf_8_5 : 26.77742})
	pf_8_6 = (((pf_5_3 + (pf_4_13 + ((0. * pf_25_1) + (0. * f_5_18)))) * utof(vs_cbuf8[1].y)) + pf_8_5);
	// 0.1530056  <=>  (({pf_23_0 : 403.9866} * (1.0 / (sqrt({pf_17_3 : 1742847.00}) + float(1e-05)))) * 0.5)
	pf_12_8 = ((pf_23_0 * (1.0 / (sqrt(pf_17_3) + float(1e-05)))) * 0.5);
	// 0.00  <=>  (({pf_6_4 : 564.6999} + ({pf_2_5 : -137.7516} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972})))) * {utof(vs_cbuf8[3].x) : 0.00})
	pf_13_10 = ((pf_6_4 + (pf_2_5 + ((0. * pf_25_1) + (0. * f_5_18)))) * utof(vs_cbuf8[3].x));
	// 729.8235  <=>  ((({pf_5_3 : 1268.157} + ({pf_4_13 : 109.6224} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972})))) * {utof(vs_cbuf8[2].y) : 0.5585706}) + {pf_9_13 : -39.76352})
	pf_9_14 = (((pf_5_3 + (pf_4_13 + ((0. * pf_25_1) + (0. * f_5_18)))) * utof(vs_cbuf8[2].y)) + pf_9_13);
	// -0.1976598  <=>  (({pf_12_8 : 0.1530056} * {utof(vs_cbuf15[28].y) : -0.5741013}) + {pf_6_6 : -0.1098191})
	pf_6_7 = ((pf_12_8 * utof(vs_cbuf15[28].y)) + pf_6_6);
	// 0.00  <=>  ((({pf_5_3 : 1268.157} + ({pf_4_13 : 109.6224} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972})))) * {utof(vs_cbuf8[3].y) : 0.00}) + {pf_13_10 : 0.00})
	pf_13_11 = (((pf_5_3 + (pf_4_13 + ((0. * pf_25_1) + (0. * f_5_18)))) * utof(vs_cbuf8[3].y)) + pf_13_10);
	// 4.023224  <=>  ((({pf_0_12 : 196.751} * {utof(vs_cbuf8[0].z) : 0.1122834}) + {pf_1_9 : 424.2484}) + {utof(vs_cbuf8[0].w) : -442.3171})
	pf_1_11 = (((pf_0_12 * utof(vs_cbuf8[0].z)) + pf_1_9) + utof(vs_cbuf8[0].w));
	// 891.988  <=>  (({pf_0_12 : 196.751} * {utof(vs_cbuf8[2].z) : 0.8242117}) + {pf_9_14 : 729.8235})
	pf_9_15 = ((pf_0_12 * utof(vs_cbuf8[2].z)) + pf_9_14);
	// 430.5961  <=>  ((({pf_0_12 : 196.751} * {utof(vs_cbuf8[1].z) : -0.5550383}) + {pf_8_6 : 1169.586}) + {utof(vs_cbuf8[1].w) : -629.7858})
	pf_8_8 = (((pf_0_12 * utof(vs_cbuf8[1].z)) + pf_8_6) + utof(vs_cbuf8[1].w));
	// -0.7828943  <=>  ((({pf_24_1 : 1225.846} * (1.0 / (sqrt({pf_17_3 : 1742847.00}) + float(1e-05)))) * {utof(vs_cbuf15[28].z) : -0.6302658}) + {pf_6_7 : -0.1976598})
	pf_6_8 = (((pf_24_1 * (1.0 / (sqrt(pf_17_3) + float(1e-05)))) * utof(vs_cbuf15[28].z)) + pf_6_7);
	// 0.00  <=>  (({pf_0_12 : 196.751} * {utof(vs_cbuf8[3].z) : 0.00}) + {pf_13_11 : 0.00})
	pf_7_17 = ((pf_0_12 * utof(vs_cbuf8[3].z)) + pf_13_11);
	// 923.4164  <=>  ((({pf_7_17 : 0.00} + {utof(vs_cbuf8[3].w) : 1.00}) * {utof(vs_cbuf8[5].w) : 0.00}) + ((({pf_9_15 : 891.988} + {utof(vs_cbuf8[2].w) : -2058.403}) * {utof(vs_cbuf8[5].z) : 0.00}) + (({pf_8_8 : 430.5961} * {utof(vs_cbuf8[5].y) : 2.144507}) + ({pf_1_11 : 4.023224} * {utof(vs_cbuf8[5].x) : 0.00}))))
	pf_13_15 = (((pf_7_17 + utof(vs_cbuf8[3].w)) * utof(vs_cbuf8[5].w)) + (((pf_9_15 + utof(vs_cbuf8[2].w)) * utof(vs_cbuf8[5].z)) + ((pf_8_8 * utof(vs_cbuf8[5].y)) + (pf_1_11 * utof(vs_cbuf8[5].x)))));
	// 4.853154  <=>  ((({pf_7_17 : 0.00} + {utof(vs_cbuf8[3].w) : 1.00}) * {utof(vs_cbuf8[4].w) : 0.00}) + ((({pf_9_15 : 891.988} + {utof(vs_cbuf8[2].w) : -2058.403}) * {utof(vs_cbuf8[4].z) : 0.00}) + (({pf_8_8 : 430.5961} * {utof(vs_cbuf8[4].y) : 0.00}) + ({pf_1_11 : 4.023224} * {utof(vs_cbuf8[4].x) : 1.206285}))))
	pf_14_13 = (((pf_7_17 + utof(vs_cbuf8[3].w)) * utof(vs_cbuf8[4].w)) + (((pf_9_15 + utof(vs_cbuf8[2].w)) * utof(vs_cbuf8[4].z)) + ((pf_8_8 * utof(vs_cbuf8[4].y)) + (pf_1_11 * utof(vs_cbuf8[4].x)))));
	// -426.9483  <=>  (0. - ({pf_6_4 : 564.6999} + ({pf_2_5 : -137.7516} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972})))))
	f_5_25 = (0. - (pf_6_4 + (pf_2_5 + ((0. * pf_25_1) + (0. * f_5_18)))));
	// -139.6372  <=>  ({f_5_25 : -426.9483} + {utof(vs_cbuf8[29].x) : 287.3111})
	pf_9_17 = (f_5_25 + utof(vs_cbuf8[29].x));
	// 1164.508  <=>  ((({pf_7_17 : 0.00} + {utof(vs_cbuf8[3].w) : 1.00}) * {utof(vs_cbuf8[6].w) : -2.00008}) + ((({pf_9_15 : 891.988} + {utof(vs_cbuf8[2].w) : -2058.403}) * {utof(vs_cbuf8[6].z) : -1.00008}) + (({pf_8_8 : 430.5961} * {utof(vs_cbuf8[6].y) : 0.00}) + ({pf_1_11 : 4.023224} * {utof(vs_cbuf8[6].x) : 0.00}))))
	pf_8_10 = (((pf_7_17 + utof(vs_cbuf8[3].w)) * utof(vs_cbuf8[6].w)) + (((pf_9_15 + utof(vs_cbuf8[2].w)) * utof(vs_cbuf8[6].z)) + ((pf_8_8 * utof(vs_cbuf8[6].y)) + (pf_1_11 * utof(vs_cbuf8[6].x)))));
	// 1166.415  <=>  ((({pf_7_17 : 0.00} + {utof(vs_cbuf8[3].w) : 1.00}) * {utof(vs_cbuf8[7].w) : 0.00}) + ((({pf_9_15 : 891.988} + {utof(vs_cbuf8[2].w) : -2058.403}) * {utof(vs_cbuf8[7].z) : -1.00}) + (({pf_8_8 : 430.5961} * {utof(vs_cbuf8[7].y) : 0.00}) + ({pf_1_11 : 4.023224} * {utof(vs_cbuf8[7].x) : 0.00}))))
	pf_1_15 = (((pf_7_17 + utof(vs_cbuf8[3].w)) * utof(vs_cbuf8[7].w)) + (((pf_9_15 + utof(vs_cbuf8[2].w)) * utof(vs_cbuf8[7].z)) + ((pf_8_8 * utof(vs_cbuf8[7].y)) + (pf_1_11 * utof(vs_cbuf8[7].x)))));
	// 19498.54  <=>  ({pf_9_17 : -139.6372} * {pf_9_17 : -139.6372})
	pf_7_19 = (pf_9_17 * pf_9_17);
	// -0.9441648  <=>  (0. - sqrt(((0. - (({pf_6_8 : -0.7828943} * 0.5) + 0.5)) + 1.)))
	f_1_51 = (0. - sqrt(((0. - ((pf_6_8 * 0.5) + 0.5)) + 1.)));
	// -1.46209  <=>  ((((({pf_6_8 : -0.7828943} * 0.5) + 0.5) * (((({pf_6_8 : -0.7828943} * 0.5) + 0.5) * (((({pf_6_8 : -0.7828943} * 0.5) + 0.5) * -0.0187293) + 0.074260995)) + -0.2121144)) + 1.5707288) * {f_1_51 : -0.9441648})
	pf_6_11 = (((((pf_6_8 * 0.5) + 0.5) * ((((pf_6_8 * 0.5) + 0.5) * ((((pf_6_8 * 0.5) + 0.5) * -0.0187293) + 0.074260995)) + -0.2121144)) + 1.5707288) * f_1_51);
	// 1199.918  <=>  ((0. - {pf_0_12 : 196.751}) + {utof(vs_cbuf8[29].z) : 1396.669})
	pf_19_7 = ((0. - pf_0_12) + utof(vs_cbuf8[29].z));
	// 0.0008043  <=>  inversesqrt((({pf_19_7 : 1199.918} * {pf_19_7 : 1199.918}) + (({pf_10_10 : 294.3641} * {pf_10_10 : 294.3641}) + {pf_7_19 : 19498.54})))
	f_5_28 = inversesqrt(((pf_19_7 * pf_19_7) + ((pf_10_10 * pf_10_10) + pf_7_19)));
	// 0.0008573  <=>  (1.0 / ({pf_1_15 : 1166.415} + ((0. * {pf_8_10 : 1164.508}) + ((0. * {pf_14_13 : 4.853154}) + (0. * {pf_13_15 : 923.4164})))))
	f_6_7 = (1.0 / (pf_1_15 + ((0. * pf_8_10) + ((0. * pf_14_13) + (0. * pf_13_15)))));
	// 0.0008043  <=>  inversesqrt((({pf_19_7 : 1199.918} * {pf_19_7 : 1199.918}) + (({pf_11_15 : 294.3641} * {pf_11_15 : 294.3641}) + {pf_7_19 : 19498.54})))
	f_4_70 = inversesqrt(((pf_19_7 * pf_19_7) + ((pf_11_15 * pf_11_15) + pf_7_19)));
	// 0.9991826  <=>  ((({pf_1_15 : 1166.415} * 0.5) + (({pf_8_10 : 1164.508} * 0.5) + ((0. * {pf_14_13 : 4.853154}) + (0. * {pf_13_15 : 923.4164})))) * {f_6_7 : 0.0008573})
	pf_15_20 = (((pf_1_15 * 0.5) + ((pf_8_10 * 0.5) + ((0. * pf_14_13) + (0. * pf_13_15)))) * f_6_7);
	// 0.00  <=>  ((0. - ({pf_19_6 : 0.50} + (0. - {in_attr0.y : 0.00}))) + {in_attr1.y : 0.50})
	pf_18_9 = ((0. - (pf_19_6 + (0. - in_attr0.y))) + in_attr1.y);
	// 0.00  <=>  {pf_18_9 : 0.00}
	out_attr1.y = pf_18_9;
	// -1.00  <=>  (0. - (({pf_17_9 : 0.50} + (0. - {in_attr0.x : 0.00})) + {in_attr1.x : 0.50}))
	f_1_56 = (0. - ((pf_17_9 + (0. - in_attr0.x)) + in_attr1.x));
	// 1166.418  <=>  ((1.0 / (({pf_15_20 : 0.9991826} * {utof(vs_cbuf8[30].w) : 24999.00}) + (0. - {utof(vs_cbuf8[30].y) : 25000.00}))) * (0. - {utof(vs_cbuf8[30].z) : 25000.00}))
	pf_18_10 = ((1.0 / ((pf_15_20 * utof(vs_cbuf8[30].w)) + (0. - utof(vs_cbuf8[30].y)))) * (0. - utof(vs_cbuf8[30].z)));
	// -0.8028585  <=>  ((({pf_19_7 : 1199.918} * {f_4_70 : 0.0008043}) * {utof(vs_cbuf15[28].z) : -0.6302658}) + ((({pf_11_15 : 294.3641} * {f_4_70 : 0.0008043}) * {utof(vs_cbuf15[28].y) : -0.5741013}) + (({pf_9_17 : -139.6372} * {f_4_70 : 0.0008043}) * {utof(vs_cbuf15[28].x) : 0.5226594})))
	pf_9_21 = (((pf_19_7 * f_4_70) * utof(vs_cbuf15[28].z)) + (((pf_11_15 * f_4_70) * utof(vs_cbuf15[28].y)) + ((pf_9_17 * f_4_70) * utof(vs_cbuf15[28].x))));
	// 0.0985707  <=>  ((((({pf_19_7 : 1199.918} * {f_5_28 : 0.0008043}) * {utof(vs_cbuf15[28].z) : -0.6302658}) + ((({pf_10_10 : 294.3641} * {f_5_28 : 0.0008043}) * {utof(vs_cbuf15[28].y) : -0.5741013}) + (({pf_9_17 : -139.6372} * {f_5_28 : 0.0008043}) * {utof(vs_cbuf15[28].x) : 0.5226594}))) * 0.5) + 0.5)
	pf_20_17 = (((((pf_19_7 * f_5_28) * utof(vs_cbuf15[28].z)) + (((pf_10_10 * f_5_28) * utof(vs_cbuf15[28].y)) + ((pf_9_17 * f_5_28) * utof(vs_cbuf15[28].x)))) * 0.5) + 0.5);
	// -0.0458177  <=>  (0. - clamp((({pf_18_10 : 1166.418} * {utof(vs_cbuf15[22].x) : 0.0000418}) + (0. - {utof(vs_cbuf15[22].y) : 0.0029252})), 0.0, 1.0))
	f_1_65 = (0. - clamp(((pf_18_10 * utof(vs_cbuf15[22].x)) + (0. - utof(vs_cbuf15[22].y))), 0.0, 1.0));
	// 1.020037  <=>  (({pf_23_0 : 403.9866} * (1.0 / (sqrt({pf_17_3 : 1742847.00}) + float(1e-05)))) * 3.3333333)
	pf_25_3 = ((pf_23_0 * (1.0 / (sqrt(pf_17_3) + float(1e-05)))) * 3.3333333);
	// -1.472124  <=>  ((({pf_20_17 : 0.0985707} * (({pf_20_17 : 0.0985707} * (({pf_20_17 : 0.0985707} * -0.0187293) + 0.074260995)) + -0.2121144)) + 1.5707288) * (0. - sqrt(((0. - {pf_20_17 : 0.0985707}) + 1.))))
	pf_20_19 = (((pf_20_17 * ((pf_20_17 * ((pf_20_17 * -0.0187293) + 0.074260995)) + -0.2121144)) + 1.5707288) * (0. - sqrt(((0. - pf_20_17) + 1.))));
	// 0.8893616  <=>  exp2((log2(({f_1_65 : -0.0458177} + 1.)) * {utof(vs_cbuf15[23].y) : 2.50}))
	f_0_12 = exp2((log2((f_1_65 + 1.)) * utof(vs_cbuf15[23].y)));
	// -0.9494363  <=>  (0. - sqrt(((0. - (({pf_9_21 : -0.8028585} * 0.5) + 0.5)) + 1.)))
	f_2_63 = (0. - sqrt(((0. - ((pf_9_21 * 0.5) + 0.5)) + 1.)));
	// -1.472124  <=>  ((((({pf_9_21 : -0.8028585} * 0.5) + 0.5) * (((({pf_9_21 : -0.8028585} * 0.5) + 0.5) * (((({pf_9_21 : -0.8028585} * 0.5) + 0.5) * -0.0187293) + 0.074260995)) + -0.2121144)) + 1.5707288) * {f_2_63 : -0.9494363})
	pf_23_6 = (((((pf_9_21 * 0.5) + 0.5) * ((((pf_9_21 * 0.5) + 0.5) * ((((pf_9_21 * 0.5) + 0.5) * -0.0187293) + 0.074260995)) + -0.2121144)) + 1.5707288) * f_2_63);
	// vec4(0.50,0.50,0.50,1.00)  <=>  textureLod({tex2 : tex2}, vec2(0.5, ((clamp(max({pf_25_3 : 1.020037}, 0.0), 0.5, 1.0) * -0.1) + 0.68)), 0.0)
	f4_0_2 = textureLod(tex2, vec2(0.5, ((clamp(max(pf_25_3, 0.0), 0.5, 1.0) * -0.1) + 0.68)), 0.0);
	// 0.50  <=>  {f4_0_2.x : 0.50}
	f_2_64 = f4_0_2.x;
	// 0.50  <=>  {f4_0_2.y : 0.50}
	f_5_29 = f4_0_2.y;
	// 0.50  <=>  {f4_0_2.z : 0.50}
	f_6_12 = f4_0_2.z;
	// vec2(0.0692044,0.5765028)  <=>  vec2((({pf_6_11 : -1.46209} * 0.63661975) + 1.), (({pf_12_8 : 0.1530056} * 0.5) + 0.5))
	f2_0_1 = vec2(((pf_6_11 * 0.63661975) + 1.), ((pf_12_8 * 0.5) + 0.5));
	// vec4(0.50,0.50,0.50,1.00)  <=>  textureLod({tex2 : tex2}, {f2_0_1 : vec2(0.0692044,0.5765028)}, 0.0)
	f4_0_3 = textureLod(tex2, f2_0_1, 0.0);
	// vec2(0.0628169,0.3816259)  <=>  vec2((({pf_20_19 : -1.472124} * 0.63661975) + 1.), ((({pf_10_10 : 294.3641} * {f_5_28 : 0.0008043}) * -0.5) + 0.5))
	f2_0_2 = vec2(((pf_20_19 * 0.63661975) + 1.), (((pf_10_10 * f_5_28) * -0.5) + 0.5));
	// vec4(0.50,0.50,0.50,1.00)  <=>  textureLod({tex2 : tex2}, {f2_0_2 : vec2(0.0628169,0.3816259)}, 0.0)
	f4_0_4 = textureLod(tex2, f2_0_2, 0.0);
	// vec4(0.50,0.50,0.50,1.00)  <=>  textureLod({tex1 : tex1}, vec2((({pf_23_6 : -1.472124} * 0.63661975) + 1.), (({f_0_12 : 0.8893616} * 0.5) + 0.5)), 0.0)
	f4_0_5 = textureLod(tex1, vec2(((pf_23_6 * 0.63661975) + 1.), ((f_0_12 * 0.5) + 0.5)), 0.0);
	// 2.713148  <=>  ((({pf_18_9 : 0.00} + {in_attr7.w : 0.7787}) + {utof(vs_cbuf15[54].y) : 1.689872}) * (({in_attr7.y : 0.62269} * 0.4) + 0.85))
	out_attr1.w = (((pf_18_9 + in_attr7.w) + utof(vs_cbuf15[54].y)) * ((in_attr7.y * 0.4) + 0.85));
	// -1.302859  <=>  (((({pf_19_7 : 1199.918} * {f_5_28 : 0.0008043}) * {utof(vs_cbuf15[28].z) : -0.6302658}) + ((({pf_10_10 : 294.3641} * {f_5_28 : 0.0008043}) * {utof(vs_cbuf15[28].y) : -0.5741013}) + (({pf_9_17 : -139.6372} * {f_5_28 : 0.0008043}) * {utof(vs_cbuf15[28].x) : 0.5226594}))) + (0. - {utof(vs_cbuf15[60].y) : 0.50}))
	pf_10_14 = ((((pf_19_7 * f_5_28) * utof(vs_cbuf15[28].z)) + (((pf_10_10 * f_5_28) * utof(vs_cbuf15[28].y)) + ((pf_9_17 * f_5_28) * utof(vs_cbuf15[28].x)))) + (0. - utof(vs_cbuf15[60].y)));
	// 196.751  <=>  {pf_0_12 : 196.751}
	out_attr4.z = pf_0_12;
	// 0.00  <=>  ({f_1_56 : -1.00} + 1.)
	out_attr1.x = (f_1_56 + 1.);
	// 426.9483  <=>  ({pf_6_4 : 564.6999} + ({pf_2_5 : -137.7516} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972}))))
	out_attr4.x = (pf_6_4 + (pf_2_5 + ((0. * pf_25_1) + (0. * f_5_18))));
	// 1256.838  <=>  sqrt((({pf_22_0 : -277.3888} * {pf_22_0 : -277.3888}) + ({pf_24_1 : 1225.846} * {pf_24_1 : 1225.846})))
	f_17_0 = sqrt(((pf_22_0 * pf_22_0) + (pf_24_1 * pf_24_1)));
	// 4.853154  <=>  {pf_14_13 : 4.853154}
	gl_Position.x = pf_14_13;
	// 1377.78  <=>  ({pf_5_3 : 1268.157} + ({pf_4_13 : 109.6224} + ((0. * {pf_25_1 : 0.952028}) + (0. * {f_5_18 : 0.047972}))))
	out_attr4.y = (pf_5_3 + (pf_4_13 + ((0. * pf_25_1) + (0. * f_5_18))));
	// -0.0522428  <=>  (0. - clamp(((sqrt({pf_17_3 : 1742847.00}) * {utof(vs_cbuf15[22].x) : 0.0000418}) + (0. - {utof(vs_cbuf15[22].y) : 0.0029252})), 0.0, 1.0))
	f_15_12 = (0. - clamp(((sqrt(pf_17_3) * utof(vs_cbuf15[22].x)) + (0. - utof(vs_cbuf15[22].y))), 0.0, 1.0));
	// 0.9138746  <=>  (((({f_1_56 : -1.00} + 1.) + {in_attr7.z : 0.01691}) + {utof(vs_cbuf15[54].x) : 0.8137476}) * (({in_attr7.x : 0.33394} * 0.3) + 1.))
	out_attr1.z = ((((f_1_56 + 1.) + in_attr7.z) + utof(vs_cbuf15[54].x)) * ((in_attr7.x * 0.3) + 1.));
	// 923.4164  <=>  {pf_13_15 : 923.4164}
	gl_Position.y = pf_13_15;
	// 1164.508  <=>  {pf_8_10 : 1164.508}
	gl_Position.z = pf_8_10;
	// 1.00  <=>  clamp((({f_17_0 : 1256.838} * 0.006666667) + (0. - 1.)), 0.0, 1.0)
	out_attr8.z = clamp(((f_17_0 * 0.006666667) + (0. - 1.)), 0.0, 1.0);
	// 1166.415  <=>  {pf_1_15 : 1166.415}
	gl_Position.w = pf_1_15;
	// 1165.462  <=>  (({pf_1_15 : 1166.415} * 0.5) + (({pf_8_10 : 1164.508} * 0.5) + ((0. * {pf_14_13 : 4.853154}) + (0. * {pf_13_15 : 923.4164}))))
	out_attr2.z = ((pf_1_15 * 0.5) + ((pf_8_10 * 0.5) + ((0. * pf_14_13) + (0. * pf_13_15))));
	// 1166.415  <=>  ({pf_1_15 : 1166.415} + ((0. * {pf_8_10 : 1164.508}) + ((0. * {pf_14_13 : 4.853154}) + (0. * {pf_13_15 : 923.4164}))))
	out_attr2.w = (pf_1_15 + ((0. * pf_8_10) + ((0. * pf_14_13) + (0. * pf_13_15))));
	// 1.00  <=>  clamp(max({pf_25_3 : 1.020037}, 0.0), 0.5, 1.0)
	out_attr8.x = clamp(max(pf_25_3, 0.0), 0.5, 1.0);
	// 0.00  <=>  clamp((({pf_5_3 : 1268.157} + (0. - {utof(vs_cbuf15[60].w) : 1672.144})) * 0.1), 0.0, 1.0)
	f_15_15 = clamp(((pf_5_3 + (0. - utof(vs_cbuf15[60].w))) * 0.1), 0.0, 1.0);
	// -1.00  <=>  (0. - clamp(((sqrt({pf_17_3 : 1742847.00}) * {utof(vs_cbuf15[24].x) : 0.0033333}) + (0. - {utof(vs_cbuf15[24].y) : 0.00})), 0.0, 1.0))
	f_16_6 = (0. - clamp(((sqrt(pf_17_3) * utof(vs_cbuf15[24].x)) + (0. - utof(vs_cbuf15[24].y))), 0.0, 1.0));
	// 0.00  <=>  ((clamp(({pf_10_14 : -1.302859} * {utof(vs_cbuf15[60].z) : 4.00}), 0.0, 1.0) * clamp(((sqrt({pf_17_3 : 1742847.00}) * 0.001) + (0. - 0.5)), 0.0, 1.0)) * {f_15_15 : 0.00})
	pf_10_17 = ((clamp((pf_10_14 * utof(vs_cbuf15[60].z)), 0.0, 1.0) * clamp(((sqrt(pf_17_3) * 0.001) + (0. - 0.5)), 0.0, 1.0)) * f_15_15);
	// 0.00  <=>  ({pf_10_17 : 0.00} * {utof(vs_cbuf15[60].x) : 0.75})
	pf_10_18 = (pf_10_17 * utof(vs_cbuf15[60].x));
	// 0.1362486  <=>  exp2((log2(({f_1_65 : -0.0458177} + 1.)) * {utof(vs_cbuf15[23].x) : 42.50}))
	f_15_17 = exp2((log2((f_1_65 + 1.)) * utof(vs_cbuf15[23].x)));
	// 0.1022415  <=>  exp2((log2(({f_15_12 : -0.0522428} + 1.)) * {utof(vs_cbuf15[23].x) : 42.50}))
	f_16_8 = exp2((log2((f_15_12 + 1.)) * utof(vs_cbuf15[23].x)));
	// 0.00  <=>  clamp(((sqrt({pf_17_3 : 1742847.00}) + (0. - {utof(vs_cbuf15[54].w) : 2000.00})) * (1.0 / {utof(vs_cbuf15[57].z) : 3000.00})), 0.0, 1.0)
	f_3_42 = clamp(((sqrt(pf_17_3) + (0. - utof(vs_cbuf15[54].w))) * (1.0 / utof(vs_cbuf15[57].z))), 0.0, 1.0);
	// 585.6341  <=>  (({pf_1_15 : 1166.415} * 0.5) + ((0. * {pf_8_10 : 1164.508}) + (({pf_14_13 : 4.853154} * 0.5) + (0. * {pf_13_15 : 923.4164}))))
	out_attr2.x = ((pf_1_15 * 0.5) + ((0. * pf_8_10) + ((pf_14_13 * 0.5) + (0. * pf_13_15))));
	// 0.6120223  <=>  (({pf_23_0 : 403.9866} * (1.0 / (sqrt({pf_17_3 : 1742847.00}) + float(1e-05)))) * 2.)
	pf_3_4 = ((pf_23_0 * (1.0 / (sqrt(pf_17_3) + float(1e-05)))) * 2.);
	// 0.00  <=>  (({pf_10_18 : 0.00} * (0. - {utof(vs_cbuf15[1].x) : 0.00})) + {pf_10_18 : 0.00})
	out_attr10.w = ((pf_10_18 * (0. - utof(vs_cbuf15[1].x))) + pf_10_18);
	// 0.00  <=>  exp2((log2(({f_16_6 : -1.00} + 1.)) * {utof(vs_cbuf15[24].w) : 4.00}))
	f_3_44 = exp2((log2((f_16_6 + 1.)) * utof(vs_cbuf15[24].w)));
	// 0.00  <=>  clamp((({pf_9_21 : -0.8028585} + (0. - {utof(vs_cbuf15[60].y) : 0.50})) * {utof(vs_cbuf15[60].z) : 4.00}), 0.0, 1.0)
	f_16_12 = clamp(((pf_9_21 + (0. - utof(vs_cbuf15[60].y))) * utof(vs_cbuf15[60].z)), 0.0, 1.0);
	// 0.6225848  <=>  min(((sqrt({pf_17_3 : 1742847.00}) + (0. - {utof(vs_cbuf15[54].z) : 75.00})) * (1.0 / {utof(vs_cbuf15[54].w) : 2000.00})), {utof(vs_cbuf15[55].w) : 0.70})
	f_17_10 = min(((sqrt(pf_17_3) + (0. - utof(vs_cbuf15[54].z))) * (1.0 / utof(vs_cbuf15[54].w))), utof(vs_cbuf15[55].w));
	// 0.00  <=>  ({f_16_12 : 0.00} * clamp((({f_15_17 : 0.1362486} * (0. - {utof(vs_cbuf15[23].z) : 0.85})) + {utof(vs_cbuf15[23].z) : 0.85}), 0.0, 1.0))
	pf_1_16 = (f_16_12 * clamp(((f_15_17 * (0. - utof(vs_cbuf15[23].z))) + utof(vs_cbuf15[23].z)), 0.0, 1.0));
	// 121.4993  <=>  (({pf_1_15 : 1166.415} * 0.5) + ((0. * {pf_8_10 : 1164.508}) + ((0. * {pf_14_13 : 4.853154}) + ({pf_13_15 : 923.4164} * -0.5))))
	out_attr2.y = ((pf_1_15 * 0.5) + ((0. * pf_8_10) + ((0. * pf_14_13) + (pf_13_15 * -0.5))));
	// 0.6225848  <=>  max(0., {f_17_10 : 0.6225848})
	f_1_70 = max(0., f_17_10);
	// 0.12  <=>  (({f_3_44 : 0.00} * (0. - {utof(vs_cbuf15[25].w) : 0.12})) + {utof(vs_cbuf15[25].w) : 0.12})
	out_attr7.x = ((f_3_44 * (0. - utof(vs_cbuf15[25].w))) + utof(vs_cbuf15[25].w));
	// 0.4750912  <=>  (clamp((({f_16_8 : 0.1022415} * (0. - {utof(vs_cbuf15[23].z) : 0.85})) + {utof(vs_cbuf15[23].z) : 0.85}), 0.0, 1.0) * {f_1_70 : 0.6225848})
	pf_0_25 = (clamp(((f_16_8 * (0. - utof(vs_cbuf15[23].z))) + utof(vs_cbuf15[23].z)), 0.0, 1.0) * f_1_70);
	// 0.00  <=>  clamp(((((0. - {pf_5_3 : 1268.157}) + min({utof(vs_cbuf8[29].y) : 1672.144}, {utof(vs_cbuf15[27].z) : 250.00})) * {utof(vs_cbuf15[27].y) : 0.0045455}) + {utof(vs_cbuf15[27].x) : -0.0909091}), 0.0, 1.0)
	f_3_49 = clamp(((((0. - pf_5_3) + min(utof(vs_cbuf8[29].y), utof(vs_cbuf15[27].z))) * utof(vs_cbuf15[27].y)) + utof(vs_cbuf15[27].x)), 0.0, 1.0);
	// 0.00  <=>  ((({pf_1_16 : 0.00} * (0. - {utof(vs_cbuf15[1].x) : 0.00})) + {pf_1_16 : 0.00}) * {utof(vs_cbuf15[61].x) : 1.00})
	out_attr11.w = (((pf_1_16 * (0. - utof(vs_cbuf15[1].x))) + pf_1_16) * utof(vs_cbuf15[61].x));
	// 0.00  <=>  ({f_3_49 : 0.00} * {utof(vs_cbuf15[26].w) : 0.4519901})
	out_attr7.y = (f_3_49 * utof(vs_cbuf15[26].w));
	// 1824.915  <=>  (({pf_18_10 : 1166.418} + {utof(vs_cbuf15[28].y) : -0.5741013}) * (1.0 / clamp((({utof(vs_cbuf15[28].y) : -0.5741013} * 1.5) + 1.5), 0.0, 1.0)))
	pf_0_29 = ((pf_18_10 + utof(vs_cbuf15[28].y)) * (1.0 / clamp(((utof(vs_cbuf15[28].y) * 1.5) + 1.5), 0.0, 1.0)));
	// 0.50  <=>  {f4_0_4.x : 0.50}
	out_attr10.x = f4_0_4.x;
	// 0.50  <=>  {f4_0_4.y : 0.50}
	out_attr10.y = f4_0_4.y;
	// 0.50  <=>  {f4_0_4.z : 0.50}
	out_attr10.z = f4_0_4.z;
	// 0.3919502  <=>  (((({f4_0_3.y : 0.50} + (0. - {utof(vs_cbuf15[55].y) : 0.825})) * (clamp({pf_3_4 : 0.6120223}, 0.0, 1.0) * {f_3_42 : 0.00})) + {utof(vs_cbuf15[55].y) : 0.825}) * clamp(clamp({pf_25_3 : 1.020037}, 0.0, 1.0), 0.5, {pf_0_25 : 0.4750912}))
	pf_3_11 = ((((f4_0_3.y + (0. - utof(vs_cbuf15[55].y))) * (clamp(pf_3_4, 0.0, 1.0) * f_3_42)) + utof(vs_cbuf15[55].y)) * clamp(clamp(pf_25_3, 0.0, 1.0), 0.5, pf_0_25));
	// 0.4043515  <=>  (((({f4_0_3.x : 0.50} + (0. - {utof(vs_cbuf15[55].x) : 0.8511029})) * (clamp({pf_3_4 : 0.6120223}, 0.0, 1.0) * {f_3_42 : 0.00})) + {utof(vs_cbuf15[55].x) : 0.8511029}) * clamp(clamp({pf_25_3 : 1.020037}, 0.0, 1.0), 0.5, {pf_0_25 : 0.4750912}))
	pf_4_21 = ((((f4_0_3.x + (0. - utof(vs_cbuf15[55].x))) * (clamp(pf_3_4, 0.0, 1.0) * f_3_42)) + utof(vs_cbuf15[55].x)) * clamp(clamp(pf_25_3, 0.0, 1.0), 0.5, pf_0_25));
	// 1.00  <=>  abs(max((({f_6_12 : 0.50} * 0.06) + (({f_2_64 : 0.50} * 0.22) + ({f_5_29 : 0.50} * 0.72))), 1.))
	f_4_79 = abs(max(((f_6_12 * 0.06) + ((f_2_64 * 0.22) + (f_5_29 * 0.72))), 1.));
	// 1.00  <=>  (1.0 / max((({f_6_12 : 0.50} * 0.06) + (({f_2_64 : 0.50} * 0.22) + ({f_5_29 : 0.50} * 0.72))), 1.))
	f_3_57 = (1.0 / max(((f_6_12 * 0.06) + ((f_2_64 * 0.22) + (f_5_29 * 0.72))), 1.));
	// 0.999997  <=>  {utof(vs_cbuf10[3].x) : 0.999997}
	out_attr3.x = utof(vs_cbuf10[3].x);
	// 0.00  <=>  (0. - (((clamp(max({pf_25_3 : 1.020037}, 0.0), 0.5, 1.0) * (0. - {f_1_70 : 0.6225848})) + {f_1_70 : 0.6225848}) * {f_3_57 : 1.00}))
	f_4_81 = (0. - (((clamp(max(pf_25_3, 0.0), 0.5, 1.0) * (0. - f_1_70)) + f_1_70) * f_3_57));
	// 1.00  <=>  exp2((log2({f_4_79 : 1.00}) * 0.7))
	f_3_61 = exp2((log2(f_4_79) * 0.7));
	// 0.5039693  <=>  (((({f4_0_3.z : 0.50} + (0. - {utof(vs_cbuf15[55].z) : 1.060784})) * (clamp({pf_3_4 : 0.6120223}, 0.0, 1.0) * {f_3_42 : 0.00})) + {utof(vs_cbuf15[55].z) : 1.060784}) * clamp(clamp({pf_25_3 : 1.020037}, 0.0, 1.0), 0.5, {pf_0_25 : 0.4750912}))
	pf_1_24 = ((((f4_0_3.z + (0. - utof(vs_cbuf15[55].z))) * (clamp(pf_3_4, 0.0, 1.0) * f_3_42)) + utof(vs_cbuf15[55].z)) * clamp(clamp(pf_25_3, 0.0, 1.0), 0.5, pf_0_25));
	// 0.5249088  <=>  (((0. - clamp(clamp({pf_25_3 : 1.020037}, 0.0, 1.0), 0.5, {pf_0_25 : 0.4750912})) + {f_4_81 : 0.00}) + 1.)
	pf_5_5 = (((0. - clamp(clamp(pf_25_3, 0.0, 1.0), 0.5, pf_0_25)) + f_4_81) + 1.);
	// 0.5249088  <=>  {pf_5_5 : 0.5249088}
	out_attr9.w = pf_5_5;
	// 0.50  <=>  ({f_5_29 : 0.50} * (1.0 / {f_3_61 : 1.00}))
	pf_5_6 = (f_5_29 * (1.0 / f_3_61));
	// 0.50  <=>  ({f_2_64 : 0.50} * (1.0 / {f_3_61 : 1.00}))
	pf_6_19 = (f_2_64 * (1.0 / f_3_61));
	// 0.50  <=>  ({f_6_12 : 0.50} * (1.0 / {f_3_61 : 1.00}))
	pf_7_27 = (f_6_12 * (1.0 / f_3_61));
	// 0.3919502  <=>  (({pf_5_6 : 0.50} * (((clamp(max({pf_25_3 : 1.020037}, 0.0), 0.5, 1.0) * (0. - {f_1_70 : 0.6225848})) + {f_1_70 : 0.6225848}) * {f_3_57 : 1.00})) + {pf_3_11 : 0.3919502})
	pf_3_12 = ((pf_5_6 * (((clamp(max(pf_25_3, 0.0), 0.5, 1.0) * (0. - f_1_70)) + f_1_70) * f_3_57)) + pf_3_11);
	// 0.3919502  <=>  {pf_3_12 : 0.3919502}
	out_attr9.y = pf_3_12;
	// 0.4043515  <=>  (({pf_6_19 : 0.50} * (((clamp(max({pf_25_3 : 1.020037}, 0.0), 0.5, 1.0) * (0. - {f_1_70 : 0.6225848})) + {f_1_70 : 0.6225848}) * {f_3_57 : 1.00})) + {pf_4_21 : 0.4043515})
	pf_0_31 = ((pf_6_19 * (((clamp(max(pf_25_3, 0.0), 0.5, 1.0) * (0. - f_1_70)) + f_1_70) * f_3_57)) + pf_4_21);
	// 0.5039693  <=>  (({pf_7_27 : 0.50} * (((clamp(max({pf_25_3 : 1.020037}, 0.0), 0.5, 1.0) * (0. - {f_1_70 : 0.6225848})) + {f_1_70 : 0.6225848}) * {f_3_57 : 1.00})) + {pf_1_24 : 0.5039693})
	pf_1_25 = ((pf_7_27 * (((clamp(max(pf_25_3, 0.0), 0.5, 1.0) * (0. - f_1_70)) + f_1_70) * f_3_57)) + pf_1_24);
	// 0.4043515  <=>  {pf_0_31 : 0.4043515}
	out_attr9.x = pf_0_31;
	// 0.5039693  <=>  {pf_1_25 : 0.5039693}
	out_attr9.z = pf_1_25;
	// 0.50  <=>  ({f4_0_5.x : 0.50} * clamp((max(({pf_0_29 : 1824.915} * 0.06666667), 0.2) + (0. - 0.)), 0.0, 1.0))
	pf_0_33 = (f4_0_5.x * clamp((max((pf_0_29 * 0.06666667), 0.2) + (0. - 0.)), 0.0, 1.0));
	// 0.50  <=>  ({f4_0_5.y : 0.50} * clamp((max(({pf_0_29 : 1824.915} * 0.06666667), 0.2) + (0. - 0.)), 0.0, 1.0))
	pf_1_26 = (f4_0_5.y * clamp((max((pf_0_29 * 0.06666667), 0.2) + (0. - 0.)), 0.0, 1.0));
	// 0.50  <=>  {pf_0_33 : 0.50}
	out_attr11.x = pf_0_33;
	// 0.50  <=>  ({f4_0_5.z : 0.50} * clamp((max(({pf_0_29 : 1824.915} * 0.06666667), 0.2) + (0. - 0.)), 0.0, 1.0))
	pf_0_34 = (f4_0_5.z * clamp((max((pf_0_29 * 0.06666667), 0.2) + (0. - 0.)), 0.0, 1.0));
	// 0.50  <=>  {pf_1_26 : 0.50}
	out_attr11.y = pf_1_26;
	// 0.50  <=>  {pf_0_34 : 0.50}
	out_attr11.z = pf_0_34;
	return;
}