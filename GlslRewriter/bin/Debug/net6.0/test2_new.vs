#version 460
#pragma optionNV(fastmath off)
#extension GL_ARB_separate_shader_objects : enable
out gl_PerVertex { vec4 gl_Position; };
layout(location = 0) in vec4 in_attr0;
layout(location = 1) in vec4 in_attr1;
layout(location = 4) in vec4 in_attr4;
layout(location = 5) in vec4 in_attr5;
layout(location = 6) in vec4 in_attr6;
layout(location = 7) in vec4 in_attr7;
layout(location = 9) in vec4 in_attr9;
layout(location = 10) in vec4 in_attr10;
layout(location = 11) in vec4 in_attr11;
layout(location = 0) out vec4 out_attr0;
layout(location = 1) out vec4 out_attr1;
layout(location = 2) out vec4 out_attr2;
layout(location = 3) out vec4 out_attr3;
layout(location = 4) out vec4 out_attr4;
layout(location = 5) out vec4 out_attr5;
layout(location = 6) out vec4 out_attr6;
layout(location = 7) out vec4 out_attr7;
layout(location = 8) out vec4 out_attr8;
layout(location = 9) out vec4 out_attr9;
layout(location = 10) out vec4 out_attr10;
layout(location = 11) out vec4 out_attr11;
layout(location = 12) out vec4 out_attr12;
layout(std140, binding = 0) uniform vs_cbuf_8 { uvec4 vs_cbuf8[4096]; };
layout(std140, binding = 1) uniform vs_cbuf_9 { uvec4 vs_cbuf9[4096]; };
layout(std140, binding = 2) uniform vs_cbuf_10 { uvec4 vs_cbuf10[4096]; };
layout(std140, binding = 3) uniform vs_cbuf_13 { uvec4 vs_cbuf13[4096]; };
layout(std140, binding = 4) uniform vs_cbuf_15 { uvec4 vs_cbuf15[4096]; };
layout(binding = 0) uniform sampler2D tex0;
layout(binding = 1) uniform sampler2D tex1;
layout(binding = 2) uniform sampler2D tex2;
#define ftoi floatBitsToInt
#define ftou floatBitsToUint
#define itof intBitsToFloat
#define utof uintBitsToFloat

void main()
{
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
	// vs_cbuf10[2] = vec4(1638.50, 36.00, 1.00, 1.00);
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
	float f_0_16;
	float f_0_17;
	float f_0_19;
	float f_0_28;
	float f_0_32;
	float f_0_8;
	float f_1_24;
	float f_1_27;
	float f_1_33;
	float f_11_3;
	float f_15_5;
	float f_16_12;
	float f_16_14;
	float f_16_6;
	float f_16_8;
	float f_17_1;
	float f_17_8;
	float f_18_5;
	float f_19_8;
	float f_2_35;
	float f_2_48;
	float f_2_57;
	float f_2_59;
	float f_2_68;
	float f_2_70;
	float f_2_75;
	float f_2_80;
	float f_20_3;
	float f_3_100;
	float f_3_33;
	float f_3_52;
	float f_3_58;
	float f_3_60;
	float f_3_8;
	float f_4_16;
	float f_4_20;
	float f_4_21;
	float f_4_23;
	float f_4_24;
	float f_4_38;
	float f_4_42;
	float f_5_4;
	float f_5_6;
	float f_8_1;
	float f_9_1;
	float f_9_2;
	vec2 f2_0_1;
	vec2 f2_0_3;
	vec4 f4_0_0;
	precise float pf_0_1;
	precise float pf_0_12;
	precise float pf_0_28;
	precise float pf_0_29;
	precise float pf_0_3;
	precise float pf_0_30;
	precise float pf_0_31;
	precise float pf_1_10;
	precise float pf_1_11;
	precise float pf_1_14;
	precise float pf_1_18;
	precise float pf_1_5;
	precise float pf_1_6;
	precise float pf_10_12;
	precise float pf_10_13;
	precise float pf_10_3;
	precise float pf_10_6;
	precise float pf_10_8;
	precise float pf_10_9;
	precise float pf_11_10;
	precise float pf_11_12;
	precise float pf_11_13;
	precise float pf_11_3;
	precise float pf_11_6;
	precise float pf_12_10;
	precise float pf_12_13;
	precise float pf_12_2;
	precise float pf_12_5;
	precise float pf_12_6;
	precise float pf_12_7;
	precise float pf_12_8;
	precise float pf_13_10;
	precise float pf_13_12;
	precise float pf_13_13;
	precise float pf_13_2;
	precise float pf_13_3;
	precise float pf_13_4;
	precise float pf_13_6;
	precise float pf_13_7;
	precise float pf_13_8;
	precise float pf_14_11;
	precise float pf_14_14;
	precise float pf_14_17;
	precise float pf_14_18;
	precise float pf_14_2;
	precise float pf_14_3;
	precise float pf_14_4;
	precise float pf_14_7;
	precise float pf_14_8;
	precise float pf_15_10;
	precise float pf_15_12;
	precise float pf_15_13;
	precise float pf_15_19;
	precise float pf_15_2;
	precise float pf_15_3;
	precise float pf_15_4;
	precise float pf_15_6;
	precise float pf_15_8;
	precise float pf_16_3;
	precise float pf_17_12;
	precise float pf_17_14;
	precise float pf_17_17;
	precise float pf_17_18;
	precise float pf_17_19;
	precise float pf_17_2;
	precise float pf_17_3;
	precise float pf_17_5;
	precise float pf_17_6;
	precise float pf_17_7;
	precise float pf_18_4;
	precise float pf_18_6;
	precise float pf_18_7;
	precise float pf_19_12;
	precise float pf_19_2;
	precise float pf_19_3;
	precise float pf_19_4;
	precise float pf_19_5;
	precise float pf_19_7;
	precise float pf_2_0;
	precise float pf_2_17;
	precise float pf_2_4;
	precise float pf_2_5;
	precise float pf_2_9;
	precise float pf_20_4;
	precise float pf_20_5;
	precise float pf_21_1;
	precise float pf_21_3;
	precise float pf_21_5;
	precise float pf_21_7;
	precise float pf_22_0;
	precise float pf_23_1;
	precise float pf_24_0;
	precise float pf_24_1;
	precise float pf_24_11;
	precise float pf_24_2;
	precise float pf_24_7;
	precise float pf_24_9;
	precise float pf_25_0;
	precise float pf_25_1;
	precise float pf_25_2;
	precise float pf_25_3;
	precise float pf_25_4;
	precise float pf_25_5;
	precise float pf_25_7;
	precise float pf_25_8;
	precise float pf_26_2;
	precise float pf_27_0;
	precise float pf_27_1;
	precise float pf_3_15;
	precise float pf_3_16;
	precise float pf_3_17;
	precise float pf_4_11;
	precise float pf_4_14;
	precise float pf_4_16;
	precise float pf_4_18;
	precise float pf_4_2;
	precise float pf_4_24;
	precise float pf_4_25;
	precise float pf_4_27;
	precise float pf_4_4;
	precise float pf_4_6;
	precise float pf_4_9;
	precise float pf_5_3;
	precise float pf_5_4;
	precise float pf_5_5;
	precise float pf_5_6;
	precise float pf_6_3;
	precise float pf_6_7;
	precise float pf_7_0;
	precise float pf_7_11;
	precise float pf_7_13;
	precise float pf_7_14;
	precise float pf_7_16;
	precise float pf_7_28;
	precise float pf_7_4;
	precise float pf_7_5;
	precise float pf_7_6;
	precise float pf_7_7;
	precise float pf_7_8;
	precise float pf_8_11;
	precise float pf_8_2;
	precise float pf_8_3;
	precise float pf_8_7;
	precise float pf_8_8;
	precise float pf_9_10;
	precise float pf_9_11;
	precise float pf_9_17;
	precise float pf_9_2;
	precise float pf_9_5;
	precise float pf_9_6;
	precise float pf_9_8;
	uint u_0_1;
	uint u_0_11;
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
	uint u_2_phi_2;
	uint u_3_2;
	uint u_3_3;
	uint u_3_4;
	uint u_3_5;
	uint u_3_7;
	uint u_3_phi_15;
	uint u_3_phi_9;
	// -988.7202  <=>  float(-988.72021)
	gl_Position.x = float(-988.72021);
	// -146.7083  <=>  float(-146.70828)
	gl_Position.y = float(-146.70828);
	// 296.7034  <=>  float(296.70337)
	gl_Position.z = float(296.70337);
	// 298.6796  <=>  float(298.67957)
	gl_Position.w = float(298.67957);
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
	// 2.6301  <=>  float(2.6301)
	out_attr1.z = float(2.6301);
	// 2.46419  <=>  float(2.46419)
	out_attr1.w = float(2.46419);
	// -345.0203  <=>  float(-345.02032)
	out_attr2.x = float(-345.02032);
	// 222.6939  <=>  float(222.69392)
	out_attr2.y = float(222.69392);
	// 297.6915  <=>  float(297.69147)
	out_attr2.z = float(297.69147);
	// 298.6796  <=>  float(298.67957)
	out_attr2.w = float(298.67957);
	// 1.00  <=>  float(1.00)
	out_attr3.x = float(1.00);
	// 0.00  <=>  float(0.00)
	out_attr3.y = float(0.00);
	// 0.00  <=>  float(0.00)
	out_attr3.z = float(0.00);
	// 1.00  <=>  float(1.00)
	out_attr3.w = float(1.00);
	// -503.6197  <=>  float(-503.61969)
	out_attr4.x = float(-503.61969);
	// 1448.566  <=>  float(1448.56592)
	out_attr4.y = float(1448.56592);
	// 1096.433  <=>  float(1096.43323)
	out_attr4.z = float(1096.43323);
	// 1.00  <=>  float(1.00)
	out_attr4.w = float(1.00);
	// 0.00  <=>  float(0.00)
	out_attr5.x = float(0.00);
	// 176.3611  <=>  float(176.36111)
	out_attr5.y = float(176.36111);
	// 0.00  <=>  float(0.00)
	out_attr5.z = float(0.00);
	// 1.00  <=>  float(1.00)
	out_attr5.w = float(1.00);
	// 4.00  <=>  float(4.00)
	out_attr6.x = float(4.00);
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
	// 0.85168  <=>  float(0.85168)
	out_attr8.x = float(0.85168);
	// 0.00  <=>  float(0.00)
	out_attr8.y = float(0.00);
	// 1.00  <=>  float(1.00)
	out_attr8.z = float(1.00);
	// 1.00  <=>  float(1.00)
	out_attr8.w = float(1.00);
	// 0.25552  <=>  float(0.25552)
	out_attr9.x = float(0.25552);
	// 0.27296  <=>  float(0.27296)
	out_attr9.y = float(0.27296);
	// 0.35128  <=>  float(0.35128)
	out_attr9.z = float(0.35128);
	// 0.68802  <=>  float(0.68802)
	out_attr9.w = float(0.68802);
	// 0.03497  <=>  float(0.03497)
	out_attr10.x = float(0.03497);
	// 0.9775  <=>  float(0.9775)
	out_attr10.y = float(0.9775);
	// 0.00  <=>  float(0.00)
	out_attr10.z = float(0.00);
	// 1.00  <=>  float(1.00)
	out_attr10.w = float(1.00);
	// 4.26563  <=>  float(4.26563)
	out_attr11.x = float(4.26563);
	// 2.5918  <=>  float(2.5918)
	out_attr11.y = float(2.5918);
	// 1.48633  <=>  float(1.48633)
	out_attr11.z = float(1.48633);
	// 0.00  <=>  float(0.00)
	out_attr11.w = float(0.00);
	// 0.146  <=>  float(0.146)
	out_attr12.x = float(0.146);
	// 0.32959  <=>  float(0.32959)
	out_attr12.y = float(0.32959);
	// 0.67383  <=>  float(0.67383)
	out_attr12.z = float(0.67383);
	// 0.00  <=>  float(0.00)
	out_attr12.w = float(0.00);
	// 1000  <=>  (isnan({in_attr4.w : 1000.00}) ? 0u : int(clamp(trunc({in_attr4.w : 1000.00}), float(-2147483600.f), float(2147483600.f))))
	u_1_1 = (isnan(in_attr4.w) ? 0u : int(clamp(trunc(in_attr4.w), float(-2147483600.f), float(2147483600.f))));
	// False  <=>  if(((int({u_1_1 : 1000}) <= int(0u)) ? true : false))
	if(((int(u_1_1) <= int(0u)) ? true : false))
	{
		// 0.00  <=>  0.f
		gl_Position.x = 0.f;
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
		// 0.00  <=>  0.f
		gl_Position.y = 0.f;
	}
	// u_2_phi_2  <=>  {u_2_phi_2 : u_2_phi_2}
	u_0_1 = u_2_phi_2;
	u_0_phi_4 = u_0_1;
	// False  <=>  if(((int({u_1_1 : 1000}) <= int(0u)) ? true : false))
	if(((int(u_1_1) <= int(0u)) ? true : false))
	{
		// {ftou(({utof(u_2_phi_2) : } * 5.f)) : }
		u_0_2 = ftou((utof(u_2_phi_2) * 5.f));
		u_0_phi_4 = u_0_2;
	}
	// False  <=>  if(((int({u_1_1 : 1000}) <= int(0u)) ? true : false))
	if(((int(u_1_1) <= int(0u)) ? true : false))
	{
		// 0.00  <=>  0.f
		out_attr3.x = 0.f;
	}
	// False  <=>  if(((int({u_1_1 : 1000}) <= int(0u)) ? true : false))
	if(((int(u_1_1) <= int(0u)) ? true : false))
	{
		// {utof(u_0_phi_4) : }
		gl_Position.z = utof(u_0_phi_4);
	}
	// False  <=>  if(((int({u_1_1 : 1000}) <= int(0u)) ? true : false))
	if(((int(u_1_1) <= int(0u)) ? true : false))
	{
		return;
	}
	// 897.00  <=>  ((0.f - {in_attr5.w : 741.50}) + {utof(vs_cbuf10[2].x) : 1638.50})
	pf_0_1 = ((0.f - in_attr5.w) + utof(vs_cbuf10[2].x));
	// False  <=>  ((({pf_0_1 : 897.00} >= float(int({u_1_1 : 1000}))) && (! isnan({pf_0_1 : 897.00}))) && (! isnan(float(int({u_1_1 : 1000})))))
	b_0_2 = (((pf_0_1 >= float(int(u_1_1))) && (! isnan(pf_0_1))) && (! isnan(float(int(u_1_1)))));
	// False  <=>  ((((({in_attr5.w : 741.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 741.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_8 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// False  <=>  if({b_1_8 : False})
	if(b_1_8)
	{
		// 0.00  <=>  0.f
		gl_Position.x = 0.f;
	}
	// False  <=>  ((((({in_attr5.w : 741.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 741.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_9 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// 1144610816  <=>  {ftou(in_attr5.w) : 1144610816}
	u_3_2 = ftou(in_attr5.w);
	u_3_phi_9 = u_3_2;
	// False  <=>  if({b_1_9 : False})
	if(b_1_9)
	{
		// 1187205120  <=>  {vs_cbuf8[30].y : 1187205120}
		u_3_3 = vs_cbuf8[30].y;
		u_3_phi_9 = u_3_3;
	}
	// False  <=>  ((((({in_attr5.w : 741.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 741.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_10 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// False  <=>  if({b_1_10 : False})
	if(b_1_10)
	{
		// 0.00  <=>  0.f
		gl_Position.y = 0.f;
	}
	// False  <=>  ((((({in_attr5.w : 741.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 741.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_11 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// u_3_phi_9  <=>  {u_3_phi_9 : u_3_phi_9}
	u_0_4 = u_3_phi_9;
	u_0_phi_11 = u_0_4;
	// False  <=>  if({b_1_11 : False})
	if(b_1_11)
	{
		// {ftou(({utof(u_3_phi_9) : } * 5.f)) : }
		u_0_5 = ftou((utof(u_3_phi_9) * 5.f));
		u_0_phi_11 = u_0_5;
	}
	// False  <=>  ((((({in_attr5.w : 741.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 741.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_12 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// False  <=>  if({b_1_12 : False})
	if(b_1_12)
	{
		// 0.00  <=>  0.f
		out_attr3.x = 0.f;
	}
	// False  <=>  ((((({in_attr5.w : 741.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 741.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_13 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// False  <=>  if({b_1_13 : False})
	if(b_1_13)
	{
		// {utof(u_0_phi_11) : }
		gl_Position.z = utof(u_0_phi_11);
	}
	// False  <=>  ((((({in_attr5.w : 741.50} > {utof(vs_cbuf10[2].x) : 1638.50}) && (! isnan({in_attr5.w : 741.50}))) && (! isnan({utof(vs_cbuf10[2].x) : 1638.50}))) || {b_0_2 : False}) ? true : false)
	b_1_14 = (((((in_attr5.w > utof(vs_cbuf10[2].x)) && (! isnan(in_attr5.w))) && (! isnan(utof(vs_cbuf10[2].x)))) || b_0_2) ? true : false);
	// False  <=>  if({b_1_14 : False})
	if(b_1_14)
	{
		return;
	}
	// 258.0894  <=>  (clamp((min(0.f, {in_attr7.x : 0.61222}) + (0.f - 0.f)), 0.0, 1.0) + {in_attr6.x : 258.0894})
	pf_2_0 = (clamp((min(0.f, in_attr7.x) + (0.f - 0.f)), 0.0, 1.0) + in_attr6.x);
	// 1147158528  <=>  {ftou(pf_0_1) : 1147158528}
	u_0_6 = ftou(pf_0_1);
	// 1148846080  <=>  {ftou(float(int({u_1_1 : 1000}))) : 1148846080}
	u_3_4 = ftou(float(int(u_1_1)));
	u_0_phi_15 = u_0_6;
	u_3_phi_15 = u_3_4;
	// False  <=>  if(((((0.f < {utof(vs_cbuf9[11].y) : 0.00}) && (! isnan(0.f))) && (! isnan({utof(vs_cbuf9[11].y) : 0.00}))) ? true : false))
	if(((((0.f < utof(vs_cbuf9[11].y)) && (! isnan(0.f))) && (! isnan(utof(vs_cbuf9[11].y)))) ? true : false))
	{
		// ∞  <=>  (((({in_attr7.x : 0.61222} * {utof(vs_cbuf9[12].z) : 0.00}) * {utof(vs_cbuf9[11].y) : 0.00}) + {pf_0_1 : 897.00}) * (1.0f / {utof(vs_cbuf9[11].y) : 0.00}))
		pf_0_3 = ((((in_attr7.x * utof(vs_cbuf9[12].z)) * utof(vs_cbuf9[11].y)) + pf_0_1) * (1.0f / utof(vs_cbuf9[11].y)));
		// 4290772992  <=>  {ftou(({pf_0_3 : ∞} + (0.f - floor({pf_0_3 : ∞})))) : 4290772992}
		u_0_7 = ftou((pf_0_3 + (0.f - floor(pf_0_3))));
		// 2139095040  <=>  {ftou(pf_0_3) : 2139095040}
		u_3_5 = ftou(pf_0_3);
		u_0_phi_15 = u_0_7;
		u_3_phi_15 = u_3_5;
	}
	// True  <=>  ((! (((0.f < {utof(vs_cbuf9[11].y) : 0.00}) && (! isnan(0.f))) && (! isnan({utof(vs_cbuf9[11].y) : 0.00})))) ? true : false)
	b_0_5 = ((! (((0.f < utof(vs_cbuf9[11].y)) && (! isnan(0.f))) && (! isnan(utof(vs_cbuf9[11].y))))) ? true : false);
	// u_0_phi_15  <=>  {u_0_phi_15 : u_0_phi_15}
	u_1_3 = u_0_phi_15;
	u_1_phi_16 = u_1_3;
	// True  <=>  if({b_0_5 : True})
	if(b_0_5)
	{
		// {ftou(({utof(u_0_phi_15) : } * (1.0f / {utof(u_3_phi_15) : }))) : }
		u_1_4 = ftou((utof(u_0_phi_15) * (1.0f / utof(u_3_phi_15))));
		u_1_phi_16 = u_1_4;
	}
	// 0.5716  <=>  clamp((floor(({in_attr7.x : 0.61222} * 8.f)) * 0.1429f), 0.0, 1.0)
	f_8_1 = clamp((floor((in_attr7.x * 8.f)) * 0.1429f), 0.0, 1.0);
	// 10.00  <=>  (({utof(vs_cbuf9[114].x) : 1.00} + (0.f - {utof(vs_cbuf9[113].x) : 0.00})) * (1.0f / ((0.f - {utof(vs_cbuf9[113].w) : 0.00}) + {utof(vs_cbuf9[114].w) : 0.10})))
	pf_4_2 = ((utof(vs_cbuf9[114].x) + (0.f - utof(vs_cbuf9[113].x))) * (1.0f / ((0.f - utof(vs_cbuf9[113].w)) + utof(vs_cbuf9[114].w))));
	// 12  <=>  (isnan({in_attr1.z : 12.00}) ? 0u : int(clamp(trunc({in_attr1.z : 12.00}), float(-2147483600.f), float(2147483600.f))))
	u_2_5 = (isnan(in_attr1.z) ? 0u : int(clamp(trunc(in_attr1.z), float(-2147483600.f), float(2147483600.f))));
	// 511.00  <=>  (float(int({uvec4(uvec2(textureSize({tex0 : tex0}, int(0u))), 0u, 0u).x : 512})) + -1.f)
	pf_7_0 = (float(int(uvec4(uvec2(textureSize(tex0, int(0u))), 0u, 0u).x)) + -1.f);
	// 292  <=>  (isnan(({pf_7_0 : 511.00} * {f_8_1 : 0.5716})) ? 0u : int(clamp(trunc(({pf_7_0 : 511.00} * {f_8_1 : 0.5716})), float(-2147483600.f), float(2147483600.f))))
	u_3_7 = (isnan((pf_7_0 * f_8_1)) ? 0u : int(clamp(trunc((pf_7_0 * f_8_1)), float(-2147483600.f), float(2147483600.f))));
	// 293  <=>  min(int((isnan({pf_7_0 : 511.00}) ? 0u : int(clamp(trunc({pf_7_0 : 511.00}), float(-2147483600.f), float(2147483600.f))))), int(({u_3_7 : 292} + 1u)))
	u_0_11 = min(int((isnan(pf_7_0) ? 0u : int(clamp(trunc(pf_7_0), float(-2147483600.f), float(2147483600.f))))), int((u_3_7 + 1u)));
	// vec4(0.50,0.50,0.50,1.00)  <=>  texelFetch({tex0 : tex0}, ivec2(uvec2({u_3_7 : 292}, {u_2_5 : 12})), int(0u))
	f4_0_0 = texelFetch(tex0, ivec2(uvec2(u_3_7, u_2_5)), int(0u));
	// 0.50  <=>  {texelFetch({tex0 : tex0}, ivec2(uvec2({u_0_11 : 293}, {u_2_5 : 12})), int(0u)).y : 0.50}
	f_9_1 = texelFetch(tex0, ivec2(uvec2(u_0_11, u_2_5)), int(0u)).y;
	// 4.00  <=>  floor(({in_attr7.x : 0.61222} * 8.f))
	out_attr6.x = floor((in_attr7.x * 8.f));
	// {utof((((({utof(u_1_phi_16) : } >= {utof(vs_cbuf9[113].w) : 0.00}) && (! isnan({utof(u_1_phi_16) : }))) && (! isnan({utof(vs_cbuf9[113].w) : 0.00}))) ? 1065353216u : 0u)) : }
	f_17_1 = utof(((((utof(u_1_phi_16) >= utof(vs_cbuf9[113].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[113].w)))) ? 1065353216u : 0u));
	// {utof((((({utof(u_1_phi_16) : } >= {utof(vs_cbuf9[113].w) : 0.00}) && (! isnan({utof(u_1_phi_16) : }))) && (! isnan({utof(vs_cbuf9[113].w) : 0.00}))) ? 1065353216u : 0u)) : }
	f_3_8 = utof(((((utof(u_1_phi_16) >= utof(vs_cbuf9[113].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[113].w)))) ? 1065353216u : 0u));
	// {utof((((({utof(u_1_phi_16) : } >= {utof(vs_cbuf9[113].w) : 0.00}) && (! isnan({utof(u_1_phi_16) : }))) && (! isnan({utof(vs_cbuf9[113].w) : 0.00}))) ? 1065353216u : 0u)) : }
	f_5_4 = utof(((((utof(u_1_phi_16) >= utof(vs_cbuf9[113].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[113].w)))) ? 1065353216u : 0u));
	// {utof((((({utof(u_1_phi_16) : } >= {utof(vs_cbuf9[114].w) : 0.10}) && (! isnan({utof(u_1_phi_16) : }))) && (! isnan({utof(vs_cbuf9[114].w) : 0.10}))) ? 1065353216u : 0u)) : }
	f_16_6 = utof(((((utof(u_1_phi_16) >= utof(vs_cbuf9[114].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[114].w)))) ? 1065353216u : 0u));
	// -9.999998  <=>  (({utof(vs_cbuf9[116].x) : 0.00} + (0.f - {utof(vs_cbuf9[115].x) : 1.00})) * (1.0f / ((0.f - {utof(vs_cbuf9[115].w) : 0.90}) + {utof(vs_cbuf9[116].w) : 1.00})))
	pf_9_2 = ((utof(vs_cbuf9[116].x) + (0.f - utof(vs_cbuf9[115].x))) * (1.0f / ((0.f - utof(vs_cbuf9[115].w)) + utof(vs_cbuf9[116].w))));
	// 0.00  <=>  (((0.f - {utof(vs_cbuf9[114].x) : 1.00}) + {utof(vs_cbuf9[115].x) : 1.00}) * (1.0f / ({utof(vs_cbuf9[115].w) : 0.90} + (0.f - {utof(vs_cbuf9[114].w) : 0.10}))))
	pf_7_4 = (((0.f - utof(vs_cbuf9[114].x)) + utof(vs_cbuf9[115].x)) * (1.0f / (utof(vs_cbuf9[115].w) + (0.f - utof(vs_cbuf9[114].w)))));
	// (((({pf_4_2 : 10.00} * ({utof(u_1_phi_16) : } + (0.f - {utof(vs_cbuf9[113].w) : 0.00}))) + {utof(vs_cbuf9[113].x) : 0.00}) * (({f_16_6 : } * (0.f - {f_5_4 : })) + {f_3_8 : })) + (({f_17_1 : } * (0.f - {utof(vs_cbuf9[113].x) : 0.00})) + {utof(vs_cbuf9[113].x) : 0.00}))
	pf_4_4 = ((((pf_4_2 * (utof(u_1_phi_16) + (0.f - utof(vs_cbuf9[113].w)))) + utof(vs_cbuf9[113].x)) * ((f_16_6 * (0.f - f_5_4)) + f_3_8)) + ((f_17_1 * (0.f - utof(vs_cbuf9[113].x))) + utof(vs_cbuf9[113].x)));
	// -503.6197  <=>  ((({in_attr4.z : -300.2363} * {in_attr9.z : 0.00}) + (({in_attr4.y : -173.5778} * {in_attr9.y : 0.00}) + ({in_attr4.x : -790.9308} * {in_attr9.x : 1.00}))) + {in_attr9.w : 287.3111})
	pf_6_3 = (((in_attr4.z * in_attr9.z) + ((in_attr4.y * in_attr9.y) + (in_attr4.x * in_attr9.x))) + in_attr9.w);
	// 0.00  <=>  ((({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].x) : 0.00}) + (0.f - ({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].z) : 0.00}))) * {utof(vs_cbuf8[1].y) : 0.829457})
	pf_13_2 = (((utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].x)) + (0.f - (utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].z)))) * utof(vs_cbuf8[1].y));
	// 1448.566  <=>  ((({in_attr4.z : -300.2363} * {in_attr10.z : 0.00}) + (({in_attr4.y : -173.5778} * {in_attr10.y : 1.00}) + ({in_attr4.x : -790.9308} * {in_attr10.x : 0.00}))) + {in_attr10.w : 1622.144})
	pf_5_3 = (((in_attr4.z * in_attr10.z) + ((in_attr4.y * in_attr10.y) + (in_attr4.x * in_attr10.x))) + in_attr10.w);
	// 790.9308  <=>  ((0.f - {pf_6_3 : -503.6197}) + {utof(vs_cbuf8[29].x) : 287.3111})
	pf_22_0 = ((0.f - pf_6_3) + utof(vs_cbuf8[29].x));
	// 1096.433  <=>  ((({in_attr4.z : -300.2363} * {in_attr11.z : 1.00}) + (({in_attr4.y : -173.5778} * {in_attr11.y : 0.00}) + ({in_attr4.x : -790.9308} * {in_attr11.x : 0.00}))) + {in_attr11.w : 1396.67})
	pf_0_12 = (((in_attr4.z * in_attr11.z) + ((in_attr4.y * in_attr11.y) + (in_attr4.x * in_attr11.x))) + in_attr11.w);
	// (({pf_7_4 : 0.00} * ({utof(u_1_phi_16) : } + (0.f - {utof(vs_cbuf9[114].w) : 0.10}))) + {utof(vs_cbuf9[114].x) : 1.00})
	pf_7_5 = ((pf_7_4 * (utof(u_1_phi_16) + (0.f - utof(vs_cbuf9[114].w)))) + utof(vs_cbuf9[114].x));
	// 0.00  <=>  (((({utof(vs_cbuf8[3].z) : 0.00} * {utof(vs_cbuf8[2].y) : 0.5585706}) + (0.f - ({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].y) : 0.00}))) * {utof(vs_cbuf8[1].x) : 0.0627182}) + {pf_13_2 : 0.00})
	pf_13_3 = ((((utof(vs_cbuf8[3].z) * utof(vs_cbuf8[2].y)) + (0.f - (utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].y)))) * utof(vs_cbuf8[1].x)) + pf_13_2);
	// {utof((((({utof(u_1_phi_16) : } >= {utof(vs_cbuf9[114].w) : 0.10}) && (! isnan({utof(u_1_phi_16) : }))) && (! isnan({utof(vs_cbuf9[114].w) : 0.10}))) ? 1065353216u : 0u)) : }
	f_2_35 = utof(((((utof(u_1_phi_16) >= utof(vs_cbuf9[114].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[114].w)))) ? 1065353216u : 0u));
	// {utof((((({utof(u_1_phi_16) : } >= {utof(vs_cbuf9[115].w) : 0.90}) && (! isnan({utof(u_1_phi_16) : }))) && (! isnan({utof(vs_cbuf9[115].w) : 0.90}))) ? 1065353216u : 0u)) : }
	f_3_33 = utof(((((utof(u_1_phi_16) >= utof(vs_cbuf9[115].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[115].w)))) ? 1065353216u : 0u));
	// {utof((((({utof(u_1_phi_16) : } >= {utof(vs_cbuf9[114].w) : 0.10}) && (! isnan({utof(u_1_phi_16) : }))) && (! isnan({utof(vs_cbuf9[114].w) : 0.10}))) ? 1065353216u : 0u)) : }
	f_4_16 = utof(((((utof(u_1_phi_16) >= utof(vs_cbuf9[114].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[114].w)))) ? 1065353216u : 0u));
	// 223.5778  <=>  ((0.f - {pf_5_3 : 1448.566}) + {utof(vs_cbuf8[29].y) : 1672.144})
	pf_21_1 = ((0.f - pf_5_3) + utof(vs_cbuf8[29].y));
	// 0.0350325  <=>  ((({utof(vs_cbuf8[2].y) : 0.5585706} * {utof(vs_cbuf8[3].w) : 1.00}) + (0.f - ({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].y) : 0.00}))) * {utof(vs_cbuf8[1].x) : 0.0627182})
	pf_24_0 = (((utof(vs_cbuf8[2].y) * utof(vs_cbuf8[3].w)) + (0.f - (utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].y)))) * utof(vs_cbuf8[1].x));
	// 0.8189995  <=>  ((({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].w) : 1.00}) + (0.f - ({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].z) : 0.00}))) * {utof(vs_cbuf8[0].x) : 0.9936762})
	pf_25_0 = (((utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].w)) + (0.f - (utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].z)))) * utof(vs_cbuf8[0].x));
	// 0.5550383  <=>  ((({utof(vs_cbuf8[2].y) : 0.5585706} * {utof(vs_cbuf8[3].w) : 1.00}) + (0.f - ({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].y) : 0.00}))) * {utof(vs_cbuf8[0].x) : 0.9936762})
	pf_17_2 = (((utof(vs_cbuf8[2].y) * utof(vs_cbuf8[3].w)) + (0.f - (utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].y)))) * utof(vs_cbuf8[0].x));
	// 0.00  <=>  ((({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].w) : 1.00}) + (0.f - ({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].z) : 0.00}))) * {utof(vs_cbuf8[0].y) : 0.00})
	pf_7_6 = (((utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].w)) + (0.f - (utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].z)))) * utof(vs_cbuf8[0].y));
	// 300.2362  <=>  ((0.f - {pf_0_12 : 1096.433}) + {utof(vs_cbuf8[29].z) : 1396.669})
	pf_23_1 = ((0.f - pf_0_12) + utof(vs_cbuf8[29].z));
	// 0.0350325  <=>  (((({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].y) : 0.00}) + (0.f - ({utof(vs_cbuf8[3].x) : 0.00} * {utof(vs_cbuf8[2].y) : 0.5585706}))) * {utof(vs_cbuf8[1].w) : -629.7858}) + {pf_24_0 : 0.0350325})
	pf_14_2 = ((((utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].y)) + (0.f - (utof(vs_cbuf8[3].x) * utof(vs_cbuf8[2].y)))) * utof(vs_cbuf8[1].w)) + pf_24_0);
	// -0.00  <=>  ((({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].z) : 0.00}) + (0.f - ({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].x) : 0.00}))) * {utof(vs_cbuf8[1].w) : -629.7858})
	pf_24_1 = (((utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].z)) + (0.f - (utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].x)))) * utof(vs_cbuf8[1].w));
	// 0.829457  <=>  (((({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].x) : 0.00}) + (0.f - ({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].w) : 1.00}))) * {utof(vs_cbuf8[0].z) : 0.1122834}) + {pf_25_0 : 0.8189995})
	pf_25_1 = ((((utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].x)) + (0.f - (utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].w)))) * utof(vs_cbuf8[0].z)) + pf_25_0);
	// -0.0627182  <=>  (((({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].y) : 0.00}) + (0.f - ({utof(vs_cbuf8[2].y) : 0.5585706} * {utof(vs_cbuf8[3].w) : 1.00}))) * {utof(vs_cbuf8[0].z) : 0.1122834}) + {pf_7_6 : 0.00})
	pf_7_7 = ((((utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].y)) + (0.f - (utof(vs_cbuf8[2].y) * utof(vs_cbuf8[3].w)))) * utof(vs_cbuf8[0].z)) + pf_7_6);
	// 0.310028  <=>  ((({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].y) : 0.00}) + (0.f - ({utof(vs_cbuf8[3].w) : 1.00} * {utof(vs_cbuf8[2].y) : 0.5585706}))) * {utof(vs_cbuf8[1].z) : -0.5550383})
	pf_15_2 = (((utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].y)) + (0.f - (utof(vs_cbuf8[3].w) * utof(vs_cbuf8[2].y)))) * utof(vs_cbuf8[1].z));
	// 765700.20  <=>  (({pf_23_1 : 300.2362} * {pf_23_1 : 300.2362}) + (({pf_21_1 : 223.5778} * {pf_21_1 : 223.5778}) + ({pf_22_0 : 790.9308} * {pf_22_0 : 790.9308})))
	pf_18_4 = ((pf_23_1 * pf_23_1) + ((pf_21_1 * pf_21_1) + (pf_22_0 * pf_22_0)));
	// 0.5550383  <=>  (((({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].x) : 0.00}) + (0.f - ({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].w) : 1.00}))) * {utof(vs_cbuf8[0].y) : 0.00}) + {pf_17_2 : 0.5550383})
	pf_17_3 = ((((utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].x)) + (0.f - (utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].w)))) * utof(vs_cbuf8[0].y)) + pf_17_2);
	// 0.0011428  <=>  inversesqrt({pf_18_4 : 765700.20})
	f_2_48 = inversesqrt(pf_18_4);
	// -0.0516931  <=>  (((({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].x) : 0.00}) + (0.f - ({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].w) : 1.00}))) * {utof(vs_cbuf8[1].z) : -0.5550383}) + {pf_24_1 : -0.00})
	pf_19_2 = ((((utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].x)) + (0.f - (utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].w)))) * utof(vs_cbuf8[1].z)) + pf_24_1);
	// 0.1122834  <=>  (((({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].x) : 0.00}) + (0.f - ({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].w) : 1.00}))) * {utof(vs_cbuf8[1].y) : 0.829457}) + {pf_14_2 : 0.0350325})
	pf_14_3 = ((((utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].x)) + (0.f - (utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].w)))) * utof(vs_cbuf8[1].y)) + pf_14_2);
	// 0.9936762  <=>  (((({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].w) : 1.00}) + (0.f - ({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].z) : 0.00}))) * {utof(vs_cbuf8[1].y) : 0.829457}) + {pf_15_2 : 0.310028})
	pf_15_3 = ((((utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].w)) + (0.f - (utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].z)))) * utof(vs_cbuf8[1].y)) + pf_15_2);
	// 0.829457  <=>  (((({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].z) : 0.00}) + (0.f - ({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].x) : 0.00}))) * {utof(vs_cbuf8[0].w) : -442.3171}) + {pf_25_1 : 0.829457})
	pf_10_3 = ((((utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].z)) + (0.f - (utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].x)))) * utof(vs_cbuf8[0].w)) + pf_25_1);
	// -0.0627182  <=>  (((({utof(vs_cbuf8[2].y) : 0.5585706} * {utof(vs_cbuf8[3].z) : 0.00}) + (0.f - ({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].y) : 0.00}))) * {utof(vs_cbuf8[0].w) : -442.3171}) + {pf_7_7 : -0.0627182})
	pf_7_8 = ((((utof(vs_cbuf8[2].y) * utof(vs_cbuf8[3].z)) + (0.f - (utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].y)))) * utof(vs_cbuf8[0].w)) + pf_7_7);
	// -0.00  <=>  (((({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].w) : 1.00}) + (0.f - ({utof(vs_cbuf8[2].w) : -2058.403} * {utof(vs_cbuf8[3].z) : 0.00}))) * {utof(vs_cbuf8[1].x) : 0.0627182}) + {pf_19_2 : -0.0516931})
	pf_12_2 = ((((utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].w)) + (0.f - (utof(vs_cbuf8[2].w) * utof(vs_cbuf8[3].z)))) * utof(vs_cbuf8[1].x)) + pf_19_2);
	// 0.9936762  <=>  (((({utof(vs_cbuf8[2].y) : 0.5585706} * {utof(vs_cbuf8[3].z) : 0.00}) + (0.f - ({utof(vs_cbuf8[2].z) : 0.8242117} * {utof(vs_cbuf8[3].y) : 0.00}))) * {utof(vs_cbuf8[1].w) : -629.7858}) + {pf_15_3 : 0.9936762})
	pf_15_4 = ((((utof(vs_cbuf8[2].y) * utof(vs_cbuf8[3].z)) + (0.f - (utof(vs_cbuf8[2].z) * utof(vs_cbuf8[3].y)))) * utof(vs_cbuf8[1].w)) + pf_15_3);
	// 176.3611  <=>  (({in_attr6.y : 176.3611} * {utof(vs_cbuf9[141].y) : 1.00}) * {utof(vs_cbuf10[3].z) : 1.00})
	out_attr5.y = ((in_attr6.y * utof(vs_cbuf9[141].y)) * utof(vs_cbuf10[3].z));
	// 0.3431102  <=>  ({pf_23_1 : 300.2362} * {f_2_48 : 0.0011428})
	pf_19_3 = (pf_23_1 * f_2_48);
	// -0.3431102  <=>  ((0.f * ({pf_21_1 : 223.5778} * {f_2_48 : 0.0011428})) + (0.f - {pf_19_3 : 0.3431102}))
	pf_24_2 = ((0.f * (pf_21_1 * f_2_48)) + (0.f - pf_19_3));
	// 0.9038765  <=>  ((0.f - 0.f) + ({pf_22_0 : 790.9308} * {f_2_48 : 0.0011428}))
	pf_25_2 = ((0.f - 0.f) + (pf_22_0 * f_2_48));
	// 0.1177246  <=>  (({pf_24_2 : -0.3431102} * {pf_24_2 : -0.3431102}) + 0.f)
	pf_15_6 = ((pf_24_2 * pf_24_2) + 0.f);
	// 0.00  <=>  (((({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].y) : 0.00}) + (0.f - ({utof(vs_cbuf8[2].y) : 0.5585706} * {utof(vs_cbuf8[3].x) : 0.00}))) * {utof(vs_cbuf8[1].z) : -0.5550383}) + {pf_13_3 : 0.00})
	pf_13_4 = ((((utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].y)) + (0.f - (utof(vs_cbuf8[2].y) * utof(vs_cbuf8[3].x)))) * utof(vs_cbuf8[1].z)) + pf_13_3);
	// 0.9347174  <=>  (({pf_25_2 : 0.9038765} * {pf_25_2 : 0.9038765}) + {pf_15_6 : 0.1177246})
	pf_14_4 = ((pf_25_2 * pf_25_2) + pf_15_6);
	// 1.00  <=>  (({pf_13_4 : 0.00} * (0.f - {utof(vs_cbuf8[0].w) : -442.3171})) + (({pf_14_3 : 0.1122834} * {utof(vs_cbuf8[0].z) : 0.1122834}) + (({pf_12_2 : -0.00} * (0.f - {utof(vs_cbuf8[0].y) : 0.00})) + ({pf_15_4 : 0.9936762} * {utof(vs_cbuf8[0].x) : 0.9936762}))))
	pf_12_5 = ((pf_13_4 * (0.f - utof(vs_cbuf8[0].w))) + ((pf_14_3 * utof(vs_cbuf8[0].z)) + ((pf_12_2 * (0.f - utof(vs_cbuf8[0].y))) + (pf_15_4 * utof(vs_cbuf8[0].x)))));
	// 0.9349081  <=>  ({pf_25_2 : 0.9038765} * inversesqrt({pf_14_4 : 0.9347174}))
	pf_12_6 = (pf_25_2 * inversesqrt(pf_14_4));
	// -0.3548898  <=>  ({pf_24_2 : -0.3431102} * inversesqrt({pf_14_4 : 0.9347174}))
	pf_13_6 = (pf_24_2 * inversesqrt(pf_14_4));
	// -0.2388736  <=>  (0.f - (({pf_21_1 : 223.5778} * {f_2_48 : 0.0011428}) * {pf_12_6 : 0.9349081}))
	f_2_57 = (0.f - ((pf_21_1 * f_2_48) * pf_12_6));
	// -0.2388736  <=>  (({pf_19_3 : 0.3431102} * (0.f * inversesqrt({pf_14_4 : 0.9347174}))) + {f_2_57 : -0.2388736})
	pf_15_8 = ((pf_19_3 * (0.f * inversesqrt(pf_14_4))) + f_2_57);
	// 0.9668077  <=>  ((({pf_22_0 : 790.9308} * {f_2_48 : 0.0011428}) * {pf_12_6 : 0.9349081}) + (0.f - ({pf_19_3 : 0.3431102} * {pf_13_6 : -0.3548898})))
	pf_12_7 = (((pf_22_0 * f_2_48) * pf_12_6) + (0.f - (pf_19_3 * pf_13_6)));
	// 0.00  <=>  (0.f - (({pf_22_0 : 790.9308} * {f_2_48 : 0.0011428}) * (0.f * inversesqrt({pf_14_4 : 0.9347174}))))
	f_2_59 = (0.f - ((pf_22_0 * f_2_48) * (0.f * inversesqrt(pf_14_4))));
	// -0.0906761  <=>  ((({pf_21_1 : 223.5778} * {f_2_48 : 0.0011428}) * {pf_13_6 : -0.3548898}) + {f_2_59 : 0.00})
	pf_13_7 = (((pf_21_1 * f_2_48) * pf_13_6) + f_2_59);
	// 0.9917778  <=>  (({pf_12_7 : 0.9668077} * {pf_12_7 : 0.9668077}) + ({pf_15_8 : -0.2388736} * {pf_15_8 : -0.2388736}))
	pf_14_7 = ((pf_12_7 * pf_12_7) + (pf_15_8 * pf_15_8));
	// 0.5550383  <=>  (((({utof(vs_cbuf8[2].x) : -0.0931343} * {utof(vs_cbuf8[3].y) : 0.00}) + (0.f - ({utof(vs_cbuf8[2].y) : 0.5585706} * {utof(vs_cbuf8[3].x) : 0.00}))) * {utof(vs_cbuf8[0].w) : -442.3171}) + {pf_17_3 : 0.5550383})
	pf_11_3 = ((((utof(vs_cbuf8[2].x) * utof(vs_cbuf8[3].y)) + (0.f - (utof(vs_cbuf8[2].y) * utof(vs_cbuf8[3].x)))) * utof(vs_cbuf8[0].w)) + pf_17_3);
	// 0.9999999  <=>  (({pf_13_7 : -0.0906761} * {pf_13_7 : -0.0906761}) + {pf_14_7 : 0.9917778})
	pf_14_8 = ((pf_13_7 * pf_13_7) + pf_14_7);
	// {utof((((({utof(u_1_phi_16) : } >= {utof(vs_cbuf9[115].w) : 0.90}) && (! isnan({utof(u_1_phi_16) : }))) && (! isnan({utof(vs_cbuf9[115].w) : 0.90}))) ? 1065353216u : 0u)) : }
	f_4_20 = utof(((((utof(u_1_phi_16) >= utof(vs_cbuf9[115].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[115].w)))) ? 1065353216u : 0u));
	// {utof((((({utof(u_1_phi_16) : } >= {utof(vs_cbuf9[116].w) : 1.00}) && (! isnan({utof(u_1_phi_16) : }))) && (! isnan({utof(vs_cbuf9[116].w) : 1.00}))) ? 1065353216u : 0u)) : }
	f_5_6 = utof(((((utof(u_1_phi_16) >= utof(vs_cbuf9[116].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[116].w)))) ? 1065353216u : 0u));
	// {utof((((({utof(u_1_phi_16) : } >= {utof(vs_cbuf9[115].w) : 0.90}) && (! isnan({utof(u_1_phi_16) : }))) && (! isnan({utof(vs_cbuf9[115].w) : 0.90}))) ? 1065353216u : 0u)) : }
	f_11_3 = utof(((((utof(u_1_phi_16) >= utof(vs_cbuf9[115].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[115].w)))) ? 1065353216u : 0u));
	// (((({pf_9_2 : -9.999998} * ({utof(u_1_phi_16) : } + (0.f - {utof(vs_cbuf9[115].w) : 0.90}))) + {utof(vs_cbuf9[115].x) : 1.00}) * (({f_11_3 : } * (0.f - {f_5_6 : })) + {f_4_20 : })) + (({pf_7_5 : } * (({f_4_16 : } * (0.f - {f_3_33 : })) + {f_2_35 : })) + {pf_4_4 : }))
	pf_4_6 = ((((pf_9_2 * (utof(u_1_phi_16) + (0.f - utof(vs_cbuf9[115].w)))) + utof(vs_cbuf9[115].x)) * ((f_11_3 * (0.f - f_5_6)) + f_4_20)) + ((pf_7_5 * ((f_4_16 * (0.f - f_3_33)) + f_2_35)) + pf_4_4));
	// 0.9668078  <=>  ({pf_12_7 : 0.9668077} * inversesqrt({pf_14_8 : 0.9999999}))
	pf_12_8 = (pf_12_7 * inversesqrt(pf_14_8));
	// 0.501686  <=>  (0.f - (({pf_22_0 : 790.9308} * {f_2_48 : 0.0011428}) * ({pf_11_3 : 0.5550383} * (0.f - (1.0f / {pf_12_5 : 1.00})))))
	f_3_52 = (0.f - ((pf_22_0 * f_2_48) * (pf_11_3 * (0.f - (1.0f / pf_12_5)))));
	// 0.5232053  <=>  (({pf_19_3 : 0.3431102} * ({pf_7_8 : -0.0627182} * (0.f - (1.0f / {pf_12_5 : 1.00})))) + {f_3_52 : 0.501686})
	pf_9_5 = ((pf_19_3 * (pf_7_8 * (0.f - (1.0f / pf_12_5)))) + f_3_52);
	// {utof((((({utof(u_1_phi_16) : } >= {utof(vs_cbuf9[116].w) : 1.00}) && (! isnan({utof(u_1_phi_16) : }))) && (! isnan({utof(vs_cbuf9[116].w) : 1.00}))) ? 1065353216u : 0u)) : }
	f_4_21 = utof(((((utof(u_1_phi_16) >= utof(vs_cbuf9[116].w)) && (! isnan(utof(u_1_phi_16)))) && (! isnan(utof(vs_cbuf9[116].w)))) ? 1065353216u : 0u));
	// -0.0906761  <=>  ({pf_13_7 : -0.0906761} * inversesqrt({pf_14_8 : 0.9999999}))
	pf_13_8 = (pf_13_7 * inversesqrt(pf_14_8));
	// -0.4264102  <=>  ((({pf_21_1 : 223.5778} * {f_2_48 : 0.0011428}) * ({pf_11_3 : 0.5550383} * (0.f - (1.0f / {pf_12_5 : 1.00})))) + (0.f - ({pf_19_3 : 0.3431102} * ({pf_10_3 : 0.829457} * (1.0f / {pf_12_5 : 1.00})))))
	pf_14_11 = (((pf_21_1 * f_2_48) * (pf_11_3 * (0.f - (1.0f / pf_12_5)))) + (0.f - (pf_19_3 * (pf_10_3 * (1.0f / pf_12_5)))));
	// -0.0160248  <=>  (0.f - (({pf_21_1 : 223.5778} * {f_2_48 : 0.0011428}) * ({pf_7_8 : -0.0627182} * (0.f - (1.0f / {pf_12_5 : 1.00})))))
	f_4_23 = (0.f - ((pf_21_1 * f_2_48) * (pf_7_8 * (0.f - (1.0f / pf_12_5)))));
	// 0.7337019  <=>  ((({pf_22_0 : 790.9308} * {f_2_48 : 0.0011428}) * ({pf_10_3 : 0.829457} * (1.0f / {pf_12_5 : 1.00}))) + {f_4_23 : -0.0160248})
	pf_17_5 = (((pf_22_0 * f_2_48) * (pf_10_3 * (1.0f / pf_12_5))) + f_4_23);
	// 0.0331922  <=>  ((0.f - clamp(({pf_12_8 : 0.9668078} + (0.f - 0.f)), 0.0, 1.0)) + 1.f)
	pf_25_3 = ((0.f - clamp((pf_12_8 + (0.f - 0.f)), 0.0, 1.0)) + 1.f);
	// -0.3548898  <=>  ((({pf_21_1 : 223.5778} * {f_2_48 : 0.0011428}) * {pf_13_8 : -0.0906761}) + (0.f - ({pf_19_3 : 0.3431102} * {pf_12_8 : 0.9668078})))
	pf_24_7 = (((pf_21_1 * f_2_48) * pf_13_8) + (0.f - (pf_19_3 * pf_12_8)));
	// 0.4555694  <=>  (({pf_9_5 : 0.5232053} * {pf_9_5 : 0.5232053}) + ({pf_14_11 : -0.4264102} * {pf_14_11 : -0.4264102}))
	pf_25_4 = ((pf_9_5 * pf_9_5) + (pf_14_11 * pf_14_11));
	// 0.9938879  <=>  (({pf_17_5 : 0.7337019} * {pf_17_5 : 0.7337019}) + {pf_25_4 : 0.4555694})
	pf_25_5 = ((pf_17_5 * pf_17_5) + pf_25_4);
	// 0.0331922  <=>  exp2((log2({pf_25_3 : 0.0331922}) * {utof(vs_cbuf13[6].y) : 1.00}))
	f_3_58 = exp2((log2(pf_25_3) * utof(vs_cbuf13[6].y)));
	// 0.5248116  <=>  ({pf_9_5 : 0.5232053} * inversesqrt({pf_25_5 : 0.9938879}))
	pf_9_6 = (pf_9_5 * inversesqrt(pf_25_5));
	// 0.7359545  <=>  ({pf_17_5 : 0.7337019} * inversesqrt({pf_25_5 : 0.9938879}))
	pf_17_6 = (pf_17_5 * inversesqrt(pf_25_5));
	// 0.9668078  <=>  ((0.f - {f_3_58 : 0.0331922}) + 1.f)
	pf_26_2 = ((0.f - f_3_58) + 1.f);
	// 0.08196  <=>  (0.f - (({pf_22_0 : 790.9308} * {f_2_48 : 0.0011428}) * {pf_13_8 : -0.0906761}))
	f_2_68 = (0.f - ((pf_22_0 * f_2_48) * pf_13_8));
	// -0.00  <=>  (({pf_19_3 : 0.3431102} * ({pf_15_8 : -0.2388736} * inversesqrt({pf_14_8 : 0.9999999}))) + {f_2_68 : 0.08196})
	pf_25_7 = ((pf_19_3 * (pf_15_8 * inversesqrt(pf_14_8))) + f_2_68);
	// -0.0610334  <=>  (({pf_21_1 : 223.5778} * {f_2_48 : 0.0011428}) * ({pf_15_8 : -0.2388736} * inversesqrt({pf_14_8 : 0.9999999})))
	pf_27_0 = ((pf_21_1 * f_2_48) * (pf_15_8 * inversesqrt(pf_14_8)));
	// 0.0244279  <=>  ({pf_17_6 : 0.7359545} * {f_3_58 : 0.0331922})
	pf_17_7 = (pf_17_6 * f_3_58);
	// -0.2288631  <=>  ((({pf_15_8 : -0.2388736} * inversesqrt({pf_14_8 : 0.9999999})) * {pf_26_2 : 0.9668078}) + (({pf_7_8 : -0.0627182} * (0.f - (1.0f / {pf_12_5 : 1.00}))) * {f_3_58 : 0.0331922}))
	pf_7_11 = (((pf_15_8 * inversesqrt(pf_14_8)) * pf_26_2) + ((pf_7_8 * (0.f - (1.0f / pf_12_5))) * f_3_58));
	// 0.1259468  <=>  ({pf_24_7 : -0.3548898} * {pf_24_7 : -0.3548898})
	pf_15_10 = (pf_24_7 * pf_24_7);
	// 0.9349082  <=>  ((({pf_22_0 : 790.9308} * {f_2_48 : 0.0011428}) * {pf_12_8 : 0.9668078}) + (0.f - {pf_27_0 : -0.0610334}))
	pf_27_1 = (((pf_22_0 * f_2_48) * pf_12_8) + (0.f - pf_27_0));
	// 1.00  <=>  (({pf_27_1 : 0.9349082} * {pf_27_1 : 0.9349082}) + (({pf_25_7 : -0.00} * {pf_25_7 : -0.00}) + {pf_15_10 : 0.1259468}))
	pf_15_12 = ((pf_27_1 * pf_27_1) + ((pf_25_7 * pf_25_7) + pf_15_10));
	// 1.00  <=>  inversesqrt({pf_15_12 : 1.00})
	f_2_70 = inversesqrt(pf_15_12);
	// -0.3548898  <=>  ({pf_24_7 : -0.3548898} * {f_2_70 : 1.00})
	pf_15_13 = (pf_24_7 * f_2_70);
	// 0.9349082  <=>  ({pf_27_1 : 0.9349082} * {f_2_70 : 1.00})
	pf_25_8 = (pf_27_1 * f_2_70);
	// -0.3573072  <=>  (({pf_15_13 : -0.3548898} * {pf_26_2 : 0.9668078}) + (({pf_14_11 : -0.4264102} * inversesqrt({pf_25_5 : 0.9938879})) * {f_3_58 : 0.0331922}))
	pf_14_14 = ((pf_15_13 * pf_26_2) + ((pf_14_11 * inversesqrt(pf_25_5)) * f_3_58));
	// 0.0174196  <=>  ((({pf_25_7 : -0.00} * {f_2_70 : 1.00}) * {pf_26_2 : 0.9668078}) + ({pf_9_6 : 0.5248116} * {f_3_58 : 0.0331922}))
	pf_9_8 = (((pf_25_7 * f_2_70) * pf_26_2) + (pf_9_6 * f_3_58));
	// 0.1276684  <=>  ({pf_14_14 : -0.3573072} * {pf_14_14 : -0.3573072})
	pf_24_9 = (pf_14_14 * pf_14_14);
	// 0.9622489  <=>  (({pf_12_8 : 0.9668078} * {pf_26_2 : 0.9668078}) + (({pf_10_3 : 0.829457} * (1.0f / {pf_12_5 : 1.00})) * {f_3_58 : 0.0331922}))
	pf_10_6 = ((pf_12_8 * pf_26_2) + ((pf_10_3 * (1.0f / pf_12_5)) * f_3_58));
	// -0.1060893  <=>  (({pf_13_8 : -0.0906761} * {pf_26_2 : 0.9668078}) + (({pf_11_3 : 0.5550383} * (0.f - (1.0f / {pf_12_5 : 1.00}))) * {f_3_58 : 0.0331922}))
	pf_11_6 = ((pf_13_8 * pf_26_2) + ((pf_11_3 * (0.f - (1.0f / pf_12_5))) * f_3_58));
	// 0.9038765  <=>  ((({pf_22_0 : 790.9308} * {f_2_48 : 0.0011428}) * {pf_26_2 : 0.9668078}) + (({pf_22_0 : 790.9308} * {f_2_48 : 0.0011428}) * {f_3_58 : 0.0331922}))
	pf_12_10 = (((pf_22_0 * f_2_48) * pf_26_2) + ((pf_22_0 * f_2_48) * f_3_58));
	// ((({f_4_21 : } * {utof(vs_cbuf9[116].x) : 0.00}) + {pf_4_6 : }) * {utof(vs_cbuf10[0].w) : 1.00})
	out_attr0.w = (((f_4_21 * utof(vs_cbuf9[116].x)) + pf_4_6) * utof(vs_cbuf10[0].w));
	// 0.9895561  <=>  (({pf_11_6 : -0.1060893} * {pf_11_6 : -0.1060893}) + (({pf_10_6 : 0.9622489} * {pf_10_6 : 0.9622489}) + ({pf_7_11 : -0.2288631} * {pf_7_11 : -0.2288631})))
	pf_4_9 = ((pf_11_6 * pf_11_6) + ((pf_10_6 * pf_10_6) + (pf_7_11 * pf_7_11)));
	// 0.3431102  <=>  (({pf_19_3 : 0.3431102} * {pf_26_2 : 0.9668078}) + ({pf_19_3 : 0.3431102} * {f_3_58 : 0.0331922}))
	pf_13_10 = ((pf_19_3 * pf_26_2) + (pf_19_3 * f_3_58));
	// 0.2555049  <=>  ((({pf_21_1 : 223.5778} * {f_2_48 : 0.0011428}) * {pf_26_2 : 0.9668078}) + (({pf_21_1 : 223.5778} * {f_2_48 : 0.0011428}) * {f_3_58 : 0.0331922}))
	pf_16_3 = (((pf_21_1 * f_2_48) * pf_26_2) + ((pf_21_1 * f_2_48) * f_3_58));
	// 1.005179  <=>  inversesqrt((((({pf_25_8 : 0.9349082} * {pf_26_2 : 0.9668078}) + {pf_17_7 : 0.0244279}) * (({pf_25_8 : 0.9349082} * {pf_26_2 : 0.9668078}) + {pf_17_7 : 0.0244279})) + (({pf_9_8 : 0.0174196} * {pf_9_8 : 0.0174196}) + {pf_24_9 : 0.1276684})))
	f_4_24 = inversesqrt(((((pf_25_8 * pf_26_2) + pf_17_7) * ((pf_25_8 * pf_26_2) + pf_17_7)) + ((pf_9_8 * pf_9_8) + pf_24_9)));
	// 0.00  <=>  ((0.f * {pf_26_2 : 0.9668078}) + (0.f * {f_3_58 : 0.0331922}))
	pf_4_11 = ((0.f * pf_26_2) + (0.f * f_3_58));
	// 0.00  <=>  ((0.f - {f4_0_0.x : 0.50}) + {texelFetch({tex0 : tex0}, ivec2(uvec2({u_0_11 : 293}, {u_2_5 : 12})), int(0u)).x : 0.50})
	pf_19_4 = ((0.f - f4_0_0.x) + texelFetch(tex0, ivec2(uvec2(u_0_11, u_2_5)), int(0u)).x);
	// -0.50  <=>  (0.f - {f4_0_0.y : 0.50})
	f_2_75 = (0.f - f4_0_0.y);
	// 0.8822755  <=>  (({pf_16_3 : 0.2555049} * {pf_16_3 : 0.2555049}) + ({pf_12_10 : 0.9038765} * {pf_12_10 : 0.9038765}))
	pf_17_12 = ((pf_16_3 * pf_16_3) + (pf_12_10 * pf_12_10));
	// 0.50  <=>  (({pf_19_4 : 0.00} * (({pf_7_0 : 511.00} * {f_8_1 : 0.5716}) + (0.f - floor(({pf_7_0 : 511.00} * {f_8_1 : 0.5716}))))) + {f4_0_0.x : 0.50})
	pf_19_5 = ((pf_19_4 * ((pf_7_0 * f_8_1) + (0.f - floor((pf_7_0 * f_8_1))))) + f4_0_0.x);
	// 0.50  <=>  ((({f_2_75 : -0.50} + {f_9_1 : 0.50}) * (({pf_7_0 : 511.00} * {f_8_1 : 0.5716}) + (0.f - floor(({pf_7_0 : 511.00} * {f_8_1 : 0.5716}))))) + {f4_0_0.y : 0.50})
	pf_20_4 = (((f_2_75 + f_9_1) * ((pf_7_0 * f_8_1) + (0.f - floor((pf_7_0 * f_8_1))))) + f4_0_0.y);
	// 0.00  <=>  ((0.f - {f4_0_0.z : 0.50}) + {texelFetch({tex0 : tex0}, ivec2(uvec2({u_0_11 : 293}, {u_2_5 : 12})), int(0u)).z : 0.50})
	pf_17_14 = ((0.f - f4_0_0.z) + texelFetch(tex0, ivec2(uvec2(u_0_11, u_2_5)), int(0u)).z);
	// 875.043  <=>  sqrt({pf_18_4 : 765700.20})
	f_2_80 = sqrt(pf_18_4);
	// 0.50  <=>  (({pf_17_14 : 0.00} * (({pf_7_0 : 511.00} * {f_8_1 : 0.5716}) + (0.f - floor(({pf_7_0 : 511.00} * {f_8_1 : 0.5716}))))) + {f4_0_0.z : 0.50})
	pf_8_2 = ((pf_17_14 * ((pf_7_0 * f_8_1) + (0.f - floor((pf_7_0 * f_8_1))))) + f4_0_0.z);
	// -46.34742  <=>  (((({pf_2_0 : 258.0894} * {utof(vs_cbuf9[141].x) : 1.00}) * {utof(vs_cbuf10[3].y) : 1.00}) * ((0.5f * {utof(vs_cbuf9[16].x) : 0.00}) + {pf_19_5 : 0.50})) * ({f_4_24 : 1.005179} * {pf_14_14 : -0.3573072}))
	pf_8_3 = ((((pf_2_0 * utof(vs_cbuf9[141].x)) * utof(vs_cbuf10[3].y)) * ((0.5f * utof(vs_cbuf9[16].x)) + pf_19_5)) * (f_4_24 * pf_14_14));
	// 2.259553  <=>  (((({pf_2_0 : 258.0894} * {utof(vs_cbuf9[141].x) : 1.00}) * {utof(vs_cbuf10[3].y) : 1.00}) * ((0.5f * {utof(vs_cbuf9[16].x) : 0.00}) + {pf_19_5 : 0.50})) * ({f_4_24 : 1.005179} * {pf_9_8 : 0.0174196}))
	pf_9_10 = ((((pf_2_0 * utof(vs_cbuf9[141].x)) * utof(vs_cbuf10[3].y)) * ((0.5f * utof(vs_cbuf9[16].x)) + pf_19_5)) * (f_4_24 * pf_9_8));
	// 120.4133  <=>  (((({pf_2_0 : 258.0894} * {utof(vs_cbuf9[141].x) : 1.00}) * {utof(vs_cbuf10[3].y) : 1.00}) * ((0.5f * {utof(vs_cbuf9[16].x) : 0.00}) + {pf_19_5 : 0.50})) * ({f_4_24 : 1.005179} * (({pf_25_8 : 0.9349082} * {pf_26_2 : 0.9668078}) + {pf_17_7 : 0.0244279})))
	pf_2_4 = ((((pf_2_0 * utof(vs_cbuf9[141].x)) * utof(vs_cbuf10[3].y)) * ((0.5f * utof(vs_cbuf9[16].x)) + pf_19_5)) * (f_4_24 * ((pf_25_8 * pf_26_2) + pf_17_7)));
	// -66.63492  <=>  ((((({in_attr6.y : 176.3611} * {utof(vs_cbuf9[141].y) : 1.00}) * {utof(vs_cbuf10[3].z) : 1.00}) * ((0.5f * {utof(vs_cbuf9[16].y) : 0.00}) + {pf_20_4 : 0.50})) * (inversesqrt({pf_4_9 : 0.9895561}) * {pf_7_11 : -0.2288631})) + {pf_8_3 : -46.34742})
	pf_7_13 = (((((in_attr6.y * utof(vs_cbuf9[141].y)) * utof(vs_cbuf10[3].z)) * ((0.5f * utof(vs_cbuf9[16].y)) + pf_20_4)) * (inversesqrt(pf_4_9) * pf_7_11)) + pf_8_3);
	// 87.55779  <=>  ((((({in_attr6.y : 176.3611} * {utof(vs_cbuf9[141].y) : 1.00}) * {utof(vs_cbuf10[3].z) : 1.00}) * ((0.5f * {utof(vs_cbuf9[16].y) : 0.00}) + {pf_20_4 : 0.50})) * (inversesqrt({pf_4_9 : 0.9895561}) * {pf_10_6 : 0.9622489})) + {pf_9_10 : 2.259553})
	pf_9_11 = (((((in_attr6.y * utof(vs_cbuf9[141].y)) * utof(vs_cbuf10[3].z)) * ((0.5f * utof(vs_cbuf9[16].y)) + pf_20_4)) * (inversesqrt(pf_4_9) * pf_10_6)) + pf_9_10);
	// 111.009  <=>  ((((({in_attr6.y : 176.3611} * {utof(vs_cbuf9[141].y) : 1.00}) * {utof(vs_cbuf10[3].z) : 1.00}) * ((0.5f * {utof(vs_cbuf9[16].y) : 0.00}) + {pf_20_4 : 0.50})) * (inversesqrt({pf_4_9 : 0.9895561}) * {pf_11_6 : -0.1060893})) + {pf_2_4 : 120.4133})
	pf_1_5 = (((((in_attr6.y * utof(vs_cbuf9[141].y)) * utof(vs_cbuf10[3].z)) * ((0.5f * utof(vs_cbuf9[16].y)) + pf_20_4)) * (inversesqrt(pf_4_9) * pf_11_6)) + pf_2_4);
	// 13.06941  <=>  ((({pf_8_2 : 0.50} * (({in_attr6.z : 176.3611} * {utof(vs_cbuf9[141].z) : 1.00}) * {utof(vs_cbuf10[3].w) : 1.00})) * (inversesqrt((({pf_13_10 : 0.3431102} * {pf_13_10 : 0.3431102}) + {pf_17_12 : 0.8822755})) * {pf_12_10 : 0.9038765})) + {pf_7_13 : -66.63492})
	pf_2_5 = (((pf_8_2 * ((in_attr6.z * utof(vs_cbuf9[141].z)) * utof(vs_cbuf10[3].w))) * (inversesqrt(((pf_13_10 * pf_13_10) + pf_17_12)) * pf_12_10)) + pf_7_13);
	// 0.0011428  <=>  (1.0f / ({f_2_80 : 875.043} + float(1e-05)))
	f_3_60 = (1.0f / (f_2_80 + float(1e-05)));
	// 110.0883  <=>  ((({pf_8_2 : 0.50} * (({in_attr6.z : 176.3611} * {utof(vs_cbuf9[141].z) : 1.00}) * {utof(vs_cbuf10[3].w) : 1.00})) * (inversesqrt((({pf_13_10 : 0.3431102} * {pf_13_10 : 0.3431102}) + {pf_17_12 : 0.8822755})) * {pf_16_3 : 0.2555049})) + {pf_9_11 : 87.55779})
	pf_7_14 = (((pf_8_2 * ((in_attr6.z * utof(vs_cbuf9[141].z)) * utof(vs_cbuf10[3].w))) * (inversesqrt(((pf_13_10 * pf_13_10) + pf_17_12)) * pf_16_3)) + pf_9_11);
	// 141.2647  <=>  ((({pf_8_2 : 0.50} * (({in_attr6.z : 176.3611} * {utof(vs_cbuf9[141].z) : 1.00}) * {utof(vs_cbuf10[3].w) : 1.00})) * (inversesqrt((({pf_13_10 : 0.3431102} * {pf_13_10 : 0.3431102}) + {pf_17_12 : 0.8822755})) * {pf_13_10 : 0.3431102})) + {pf_1_5 : 111.009})
	pf_1_6 = (((pf_8_2 * ((in_attr6.z * utof(vs_cbuf9[141].z)) * utof(vs_cbuf10[3].w))) * (inversesqrt(((pf_13_10 * pf_13_10) + pf_17_12)) * pf_13_10)) + pf_1_5);
	// 777.8614  <=>  ((0.f - ({pf_6_3 : -503.6197} + ({pf_2_5 : 13.06941} + {pf_4_11 : 0.00}))) + {utof(vs_cbuf8[29].x) : 287.3111})
	pf_10_8 = ((0.f - (pf_6_3 + (pf_2_5 + pf_4_11))) + utof(vs_cbuf8[29].x));
	// 113.4894  <=>  ((0.f - ({pf_5_3 : 1448.566} + ({pf_7_14 : 110.0883} + {pf_4_11 : 0.00}))) + {utof(vs_cbuf15[60].w) : 1672.144})
	pf_13_12 = ((0.f - (pf_5_3 + (pf_7_14 + pf_4_11))) + utof(vs_cbuf15[60].w));
	// 113.4894  <=>  ((0.f - ({pf_5_3 : 1448.566} + ({pf_7_14 : 110.0883} + {pf_4_11 : 0.00}))) + {utof(vs_cbuf8[29].y) : 1672.144})
	pf_14_17 = ((0.f - (pf_5_3 + (pf_7_14 + pf_4_11))) + utof(vs_cbuf8[29].y));
	// -348.4752  <=>  ((({pf_0_12 : 1096.433} + ({pf_1_6 : 141.2647} + {pf_4_11 : 0.00})) * {utof(vs_cbuf8[0].z) : 0.1122834}) + ((({pf_5_3 : 1448.566} + ({pf_7_14 : 110.0883} + {pf_4_11 : 0.00})) * {utof(vs_cbuf8[0].y) : 0.00}) + (({pf_6_3 : -503.6197} + ({pf_2_5 : 13.06941} + {pf_4_11 : 0.00})) * {utof(vs_cbuf8[0].x) : 0.9936762})))
	pf_8_7 = (((pf_0_12 + (pf_1_6 + pf_4_11)) * utof(vs_cbuf8[0].z)) + (((pf_5_3 + (pf_7_14 + pf_4_11)) * utof(vs_cbuf8[0].y)) + ((pf_6_3 + (pf_2_5 + pf_4_11)) * utof(vs_cbuf8[0].x))));
	// 575.1006  <=>  ((({pf_0_12 : 1096.433} + ({pf_1_6 : 141.2647} + {pf_4_11 : 0.00})) * {utof(vs_cbuf8[1].z) : -0.5550383}) + ((({pf_5_3 : 1448.566} + ({pf_7_14 : 110.0883} + {pf_4_11 : 0.00})) * {utof(vs_cbuf8[1].y) : 0.829457}) + (({pf_6_3 : -503.6197} + ({pf_2_5 : 13.06941} + {pf_4_11 : 0.00})) * {utof(vs_cbuf8[1].x) : 0.0627182})))
	pf_1_10 = (((pf_0_12 + (pf_1_6 + pf_4_11)) * utof(vs_cbuf8[1].z)) + (((pf_5_3 + (pf_7_14 + pf_4_11)) * utof(vs_cbuf8[1].y)) + ((pf_6_3 + (pf_2_5 + pf_4_11)) * utof(vs_cbuf8[1].x))));
	// 0.3990767  <=>  (((({pf_21_1 : 223.5778} * {f_3_60 : 0.0011428}) * 0.5f) * {utof(vs_cbuf15[28].y) : -0.5741013}) + (({pf_22_0 : 790.9308} * {f_3_60 : 0.0011428}) * {utof(vs_cbuf15[28].x) : 0.5226594}))
	pf_4_14 = ((((pf_21_1 * f_3_60) * 0.5f) * utof(vs_cbuf15[28].y)) + ((pf_22_0 * f_3_60) * utof(vs_cbuf15[28].x)));
	// -790.7922  <=>  ({pf_8_7 : -348.4752} + {utof(vs_cbuf8[0].w) : -442.3171})
	pf_8_8 = (pf_8_7 + utof(vs_cbuf8[0].w));
	// 1936.431  <=>  ((({pf_0_12 : 1096.433} + ({pf_1_6 : 141.2647} + {pf_4_11 : 0.00})) * {utof(vs_cbuf8[2].z) : 0.8242117}) + ((({pf_5_3 : 1448.566} + ({pf_7_14 : 110.0883} + {pf_4_11 : 0.00})) * {utof(vs_cbuf8[2].y) : 0.5585706}) + (({pf_6_3 : -503.6197} + ({pf_2_5 : 13.06941} + {pf_4_11 : 0.00})) * {utof(vs_cbuf8[2].x) : -0.0931343})))
	pf_11_10 = (((pf_0_12 + (pf_1_6 + pf_4_11)) * utof(vs_cbuf8[2].z)) + (((pf_5_3 + (pf_7_14 + pf_4_11)) * utof(vs_cbuf8[2].y)) + ((pf_6_3 + (pf_2_5 + pf_4_11)) * utof(vs_cbuf8[2].x))));
	// -54.68518  <=>  ({pf_1_10 : 575.1006} + {utof(vs_cbuf8[1].w) : -629.7858})
	pf_1_11 = (pf_1_10 + utof(vs_cbuf8[1].w));
	// 0.00  <=>  ((({pf_0_12 : 1096.433} + ({pf_1_6 : 141.2647} + {pf_4_11 : 0.00})) * {utof(vs_cbuf8[3].z) : 0.00}) + ((({pf_5_3 : 1448.566} + ({pf_7_14 : 110.0883} + {pf_4_11 : 0.00})) * {utof(vs_cbuf8[3].y) : 0.00}) + (({pf_6_3 : -503.6197} + ({pf_2_5 : 13.06941} + {pf_4_11 : 0.00})) * {utof(vs_cbuf8[3].x) : 0.00})))
	pf_7_16 = (((pf_0_12 + (pf_1_6 + pf_4_11)) * utof(vs_cbuf8[3].z)) + (((pf_5_3 + (pf_7_14 + pf_4_11)) * utof(vs_cbuf8[3].y)) + ((pf_6_3 + (pf_2_5 + pf_4_11)) * utof(vs_cbuf8[3].x))));
	// 0.591413  <=>  ((((({pf_23_1 : 300.2362} * {f_3_60 : 0.0011428}) * {utof(vs_cbuf15[28].z) : -0.6302658}) + {pf_4_14 : 0.3990767}) * 0.5f) + 0.5f)
	pf_4_16 = (((((pf_23_1 * f_3_60) * utof(vs_cbuf15[28].z)) + pf_4_14) * 0.5f) + 0.5f);
	// -117.2728  <=>  ((({pf_7_16 : 0.00} + {utof(vs_cbuf8[3].w) : 1.00}) * {utof(vs_cbuf8[5].w) : 0.00}) + ((({pf_11_10 : 1936.431} + {utof(vs_cbuf8[2].w) : -2058.403}) * {utof(vs_cbuf8[5].z) : 0.00}) + (({pf_1_11 : -54.68518} * {utof(vs_cbuf8[5].y) : 2.144507}) + ({pf_8_8 : -790.7922} * {utof(vs_cbuf8[5].x) : 0.00}))))
	pf_9_17 = (((pf_7_16 + utof(vs_cbuf8[3].w)) * utof(vs_cbuf8[5].w)) + (((pf_11_10 + utof(vs_cbuf8[2].w)) * utof(vs_cbuf8[5].z)) + ((pf_1_11 * utof(vs_cbuf8[5].y)) + (pf_8_8 * utof(vs_cbuf8[5].x)))));
	// -953.9207  <=>  ((({pf_7_16 : 0.00} + {utof(vs_cbuf8[3].w) : 1.00}) * {utof(vs_cbuf8[4].w) : 0.00}) + ((({pf_11_10 : 1936.431} + {utof(vs_cbuf8[2].w) : -2058.403}) * {utof(vs_cbuf8[4].z) : 0.00}) + (({pf_1_11 : -54.68518} * {utof(vs_cbuf8[4].y) : 0.00}) + ({pf_8_8 : -790.7922} * {utof(vs_cbuf8[4].x) : 1.206285}))))
	pf_15_19 = (((pf_7_16 + utof(vs_cbuf8[3].w)) * utof(vs_cbuf8[4].w)) + (((pf_11_10 + utof(vs_cbuf8[2].w)) * utof(vs_cbuf8[4].z)) + ((pf_1_11 * utof(vs_cbuf8[4].y)) + (pf_8_8 * utof(vs_cbuf8[4].x)))));
	// 158.9716  <=>  ((0.f - ({pf_0_12 : 1096.433} + ({pf_1_6 : 141.2647} + {pf_4_11 : 0.00}))) + {utof(vs_cbuf8[29].z) : 1396.669})
	pf_11_12 = ((0.f - (pf_0_12 + (pf_1_6 + pf_4_11))) + utof(vs_cbuf8[29].z));
	// 119.9822  <=>  ((({pf_7_16 : 0.00} + {utof(vs_cbuf8[3].w) : 1.00}) * {utof(vs_cbuf8[6].w) : -2.00008}) + ((({pf_11_10 : 1936.431} + {utof(vs_cbuf8[2].w) : -2058.403}) * {utof(vs_cbuf8[6].z) : -1.00008}) + (({pf_1_11 : -54.68518} * {utof(vs_cbuf8[6].y) : 0.00}) + ({pf_8_8 : -790.7922} * {utof(vs_cbuf8[6].x) : 0.00}))))
	pf_8_11 = (((pf_7_16 + utof(vs_cbuf8[3].w)) * utof(vs_cbuf8[6].w)) + (((pf_11_10 + utof(vs_cbuf8[2].w)) * utof(vs_cbuf8[6].z)) + ((pf_1_11 * utof(vs_cbuf8[6].y)) + (pf_8_8 * utof(vs_cbuf8[6].x)))));
	// -0.9379621  <=>  ((({pf_4_16 : 0.591413} * (({pf_4_16 : 0.591413} * (({pf_4_16 : 0.591413} * -0.0187293f) + 0.074260995f)) + -0.2121144f)) + 1.5707288f) * (0.f - sqrt(((0.f - {pf_4_16 : 0.591413}) + 1.f))))
	pf_4_18 = (((pf_4_16 * ((pf_4_16 * ((pf_4_16 * -0.0187293f) + 0.074260995f)) + -0.2121144f)) + 1.5707288f) * (0.f - sqrt(((0.f - pf_4_16) + 1.f))));
	// 605068.30  <=>  ({pf_10_8 : 777.8614} * {pf_10_8 : 777.8614})
	pf_17_17 = (pf_10_8 * pf_10_8);
	// 121.9725  <=>  ((({pf_7_16 : 0.00} + {utof(vs_cbuf8[3].w) : 1.00}) * {utof(vs_cbuf8[7].w) : 0.00}) + ((({pf_11_10 : 1936.431} + {utof(vs_cbuf8[2].w) : -2058.403}) * {utof(vs_cbuf8[7].z) : -1.00}) + (({pf_1_11 : -54.68518} * {utof(vs_cbuf8[7].y) : 0.00}) + ({pf_8_8 : -790.7922} * {utof(vs_cbuf8[7].x) : 0.00}))))
	pf_1_14 = (((pf_7_16 + utof(vs_cbuf8[3].w)) * utof(vs_cbuf8[7].w)) + (((pf_11_10 + utof(vs_cbuf8[2].w)) * utof(vs_cbuf8[7].z)) + ((pf_1_11 * utof(vs_cbuf8[7].y)) + (pf_8_8 * utof(vs_cbuf8[7].x)))));
	// 617948.10  <=>  (({pf_13_12 : 113.4894} * {pf_13_12 : 113.4894}) + {pf_17_17 : 605068.30})
	pf_18_6 = ((pf_13_12 * pf_13_12) + pf_17_17);
	// 617948.10  <=>  (({pf_14_17 : 113.4894} * {pf_14_17 : 113.4894}) + {pf_17_17 : 605068.30})
	pf_17_18 = ((pf_14_17 * pf_14_17) + pf_17_17);
	// 643220.10  <=>  (({pf_11_12 : 158.9716} * {pf_11_12 : 158.9716}) + {pf_18_6 : 617948.10})
	pf_18_7 = ((pf_11_12 * pf_11_12) + pf_18_6);
	// 643220.10  <=>  (({pf_11_12 : 158.9716} * {pf_11_12 : 158.9716}) + {pf_17_18 : 617948.10})
	pf_17_19 = ((pf_11_12 * pf_11_12) + pf_17_18);
	// 0.0081986  <=>  (1.0f / ({pf_1_14 : 121.9725} + ((0.f * {pf_8_11 : 119.9822}) + ((0.f * {pf_15_19 : -953.9207}) + (0.f * {pf_9_17 : -117.2728})))))
	f_9_2 = (1.0f / (pf_1_14 + ((0.f * pf_8_11) + ((0.f * pf_15_19) + (0.f * pf_9_17)))));
	// 0.00  <=>  ((0.f - ({pf_20_4 : 0.50} + (0.f - {in_attr0.y : 0.00}))) + {in_attr1.y : 0.50})
	pf_19_7 = ((0.f - (pf_20_4 + (0.f - in_attr0.y))) + in_attr1.y);
	// 0.9698899  <=>  ({pf_10_8 : 777.8614} * inversesqrt({pf_18_7 : 643220.10}))
	pf_20_5 = (pf_10_8 * inversesqrt(pf_18_7));
	// 0.00  <=>  {pf_19_7 : 0.00}
	out_attr1.y = pf_19_7;
	// 0.9918411  <=>  ((({pf_1_14 : 121.9725} * 0.5f) + (({pf_8_11 : 119.9822} * 0.5f) + ((0.f * {pf_15_19 : -953.9207}) + (0.f * {pf_9_17 : -117.2728})))) * {f_9_2 : 0.0081986})
	pf_21_3 = (((pf_1_14 * 0.5f) + ((pf_8_11 * 0.5f) + ((0.f * pf_15_19) + (0.f * pf_9_17)))) * f_9_2);
	// 0.1415062  <=>  ({pf_13_12 : 113.4894} * inversesqrt({pf_18_7 : 643220.10}))
	pf_13_13 = (pf_13_12 * inversesqrt(pf_18_7));
	// 0.9698899  <=>  ({pf_10_8 : 777.8614} * inversesqrt({pf_17_19 : 643220.10}))
	pf_10_9 = (pf_10_8 * inversesqrt(pf_17_19));
	// 0.1415062  <=>  ({pf_14_17 : 113.4894} * inversesqrt({pf_17_19 : 643220.10}))
	pf_14_18 = (pf_14_17 * inversesqrt(pf_17_19));
	// 0.1982164  <=>  ({pf_11_12 : 158.9716} * inversesqrt({pf_18_7 : 643220.10}))
	pf_24_11 = (pf_11_12 * inversesqrt(pf_18_7));
	// 0.1982164  <=>  ({pf_11_12 : 158.9716} * inversesqrt({pf_17_19 : 643220.10}))
	pf_11_13 = (pf_11_12 * inversesqrt(pf_17_19));
	// -0.0048789  <=>  (1.0f / (({pf_21_3 : 0.9918411} * {utof(vs_cbuf8[30].w) : 24999.00}) + (0.f - {utof(vs_cbuf8[30].y) : 25000.00})))
	f_4_38 = (1.0f / ((pf_21_3 * utof(vs_cbuf8[30].w)) + (0.f - utof(vs_cbuf8[30].y))));
	// 0.3007541  <=>  (({pf_11_13 : 0.1982164} * {utof(vs_cbuf15[28].z) : -0.6302658}) + (({pf_14_18 : 0.1415062} * {utof(vs_cbuf15[28].y) : -0.5741013}) + ({pf_10_9 : 0.9698899} * {utof(vs_cbuf15[28].x) : 0.5226594})))
	pf_10_12 = ((pf_11_13 * utof(vs_cbuf15[28].z)) + ((pf_14_18 * utof(vs_cbuf15[28].y)) + (pf_10_9 * utof(vs_cbuf15[28].x))));
	// -1.00  <=>  (0.f - (({pf_19_5 : 0.50} + (0.f - {in_attr0.x : 0.00})) + {in_attr1.x : 0.50}))
	f_1_24 = (0.f - ((pf_19_5 + (0.f - in_attr0.x)) + in_attr1.x));
	// 0.650377  <=>  (((({pf_24_11 : 0.1982164} * {utof(vs_cbuf15[28].z) : -0.6302658}) + (({pf_13_13 : 0.1415062} * {utof(vs_cbuf15[28].y) : -0.5741013}) + ({pf_20_5 : 0.9698899} * {utof(vs_cbuf15[28].x) : 0.5226594}))) * 0.5f) + 0.5f)
	pf_21_5 = ((((pf_24_11 * utof(vs_cbuf15[28].z)) + ((pf_13_13 * utof(vs_cbuf15[28].y)) + (pf_20_5 * utof(vs_cbuf15[28].x)))) * 0.5f) + 0.5f);
	// 0.00  <=>  ({f_1_24 : -1.00} + 1.f)
	out_attr1.x = (f_1_24 + 1.f);
	// 0.0021718  <=>  clamp(((({f_4_38 : -0.0048789} * (0.f - {utof(vs_cbuf8[30].z) : 25000.00})) * {utof(vs_cbuf15[22].x) : 0.0000418}) + (0.f - {utof(vs_cbuf15[22].y) : 0.0029252})), 0.0, 1.0)
	f_1_27 = clamp((((f_4_38 * (0.f - utof(vs_cbuf8[30].z))) * utof(vs_cbuf15[22].x)) + (0.f - utof(vs_cbuf15[22].y))), 0.0, 1.0);
	// -0.0031367  <=>  log2(((0.f - {f_1_27 : 0.0021718}) + 1.f))
	f_0_8 = log2(((0.f - f_1_27) + 1.f));
	// 0.8516829  <=>  clamp(max((({pf_21_1 : 223.5778} * {f_3_60 : 0.0011428}) * 3.3333333f), 0.0), 0.5f, 1.0)
	f_4_42 = clamp(max(((pf_21_1 * f_3_60) * 3.3333333f), 0.0), 0.5f, 1.0);
	// -0.8627108  <=>  ((({pf_21_5 : 0.650377} * (({pf_21_5 : 0.650377} * (({pf_21_5 : 0.650377} * -0.0187293f) + 0.074260995f)) + -0.2121144f)) + 1.5707288f) * (0.f - sqrt(((0.f - {pf_21_5 : 0.650377}) + 1.f))))
	pf_21_7 = (((pf_21_5 * ((pf_21_5 * ((pf_21_5 * -0.0187293f) + 0.074260995f)) + -0.2121144f)) + 1.5707288f) * (0.f - sqrt(((0.f - pf_21_5) + 1.f))));
	// 0.9945793  <=>  exp2(({f_0_8 : -0.0031367} * {utof(vs_cbuf15[23].y) : 2.50}))
	f_1_33 = exp2((f_0_8 * utof(vs_cbuf15[23].y)));
	// -0.5912892  <=>  (0.f - sqrt(((0.f - (({pf_10_12 : 0.3007541} * 0.5f) + 0.5f)) + 1.f)))
	f_3_100 = (0.f - sqrt(((0.f - ((pf_10_12 * 0.5f) + 0.5f)) + 1.f)));
	// -0.8627108  <=>  ((((({pf_10_12 : 0.3007541} * 0.5f) + 0.5f) * (((({pf_10_12 : 0.3007541} * 0.5f) + 0.5f) * (((({pf_10_12 : 0.3007541} * 0.5f) + 0.5f) * -0.0187293f) + 0.074260995f)) + -0.2121144f)) + 1.5707288f) * {f_3_100 : -0.5912892})
	pf_19_12 = (((((pf_10_12 * 0.5f) + 0.5f) * ((((pf_10_12 * 0.5f) + 0.5f) * ((((pf_10_12 * 0.5f) + 0.5f) * -0.0187293f) + 0.074260995f)) + -0.2121144f)) + 1.5707288f) * f_3_100);
	// 0.5638762  <=>  (((({pf_21_1 : 223.5778} * {f_3_60 : 0.0011428}) * 0.5f) * 0.5f) + 0.5f)
	pf_12_13 = ((((pf_21_1 * f_3_60) * 0.5f) * 0.5f) + 0.5f);
	// vec2(0.4028748,0.5638762)  <=>  vec2((({pf_4_18 : -0.9379621} * 0.63661975f) + 1.f), {pf_12_13 : 0.5638762})
	f2_0_1 = vec2(((pf_4_18 * 0.63661975f) + 1.f), pf_12_13);
	// vec2(0.4507813,0.9972897)  <=>  vec2((({pf_19_12 : -0.8627108} * 0.63661975f) + 1.f), (({f_1_33 : 0.9945793} * 0.5f) + 0.5f))
	f2_0_3 = vec2(((pf_19_12 * 0.63661975f) + 1.f), ((f_1_33 * 0.5f) + 0.5f));
	// 2.035034  <=>  ((({pf_19_7 : 0.00} + {in_attr7.w : 0.68109}) + {utof(vs_cbuf15[54].y) : 1.689872}) * (({in_attr7.y : 0.02079} * 0.4f) + 0.85f))
	out_attr1.w = (((pf_19_7 + in_attr7.w) + utof(vs_cbuf15[54].y)) * ((in_attr7.y * 0.4f) + 0.85f));
	// 2.038258  <=>  (((({f_1_24 : -1.00} + 1.f) + {in_attr7.z : 0.90824}) + {utof(vs_cbuf15[54].x) : 0.8137476}) * (({in_attr7.x : 0.61222} * 0.3f) + 1.f))
	out_attr1.z = ((((f_1_24 + 1.f) + in_attr7.z) + utof(vs_cbuf15[54].x)) * ((in_attr7.x * 0.3f) + 1.f));
	// -490.5503  <=>  ({pf_6_3 : -503.6197} + ({pf_2_5 : 13.06941} + {pf_4_11 : 0.00}))
	out_attr4.x = (pf_6_3 + (pf_2_5 + pf_4_11));
	// 1558.654  <=>  ({pf_5_3 : 1448.566} + ({pf_7_14 : 110.0883} + {pf_4_11 : 0.00}))
	out_attr4.y = (pf_5_3 + (pf_7_14 + pf_4_11));
	// 845.9984  <=>  sqrt((({pf_22_0 : 790.9308} * {pf_22_0 : 790.9308}) + ({pf_23_1 : 300.2362} * {pf_23_1 : 300.2362})))
	f_16_8 = sqrt(((pf_22_0 * pf_22_0) + (pf_23_1 * pf_23_1)));
	// -953.9207  <=>  {pf_15_19 : -953.9207}
	gl_Position.x = pf_15_19;
	// -0.1992459  <=>  ((({pf_24_11 : 0.1982164} * {utof(vs_cbuf15[28].z) : -0.6302658}) + (({pf_13_13 : 0.1415062} * {utof(vs_cbuf15[28].y) : -0.5741013}) + ({pf_20_5 : 0.9698899} * {utof(vs_cbuf15[28].x) : 0.5226594}))) + (0.f - {utof(vs_cbuf15[60].y) : 0.50}))
	pf_2_9 = (((pf_24_11 * utof(vs_cbuf15[28].z)) + ((pf_13_13 * utof(vs_cbuf15[28].y)) + (pf_20_5 * utof(vs_cbuf15[28].x)))) + (0.f - utof(vs_cbuf15[60].y)));
	// 1237.698  <=>  ({pf_0_12 : 1096.433} + ({pf_1_6 : 141.2647} + {pf_4_11 : 0.00}))
	out_attr4.z = (pf_0_12 + (pf_1_6 + pf_4_11));
	// -117.2728  <=>  {pf_9_17 : -117.2728}
	gl_Position.y = pf_9_17;
	// -0.0336416  <=>  (0.f - clamp((({f_2_80 : 875.043} * {utof(vs_cbuf15[22].x) : 0.0000418}) + (0.f - {utof(vs_cbuf15[22].y) : 0.0029252})), 0.0, 1.0))
	f_15_5 = (0.f - clamp(((f_2_80 * utof(vs_cbuf15[22].x)) + (0.f - utof(vs_cbuf15[22].y))), 0.0, 1.0));
	// 119.9822  <=>  {pf_8_11 : 119.9822}
	gl_Position.z = pf_8_11;
	// 1.00  <=>  clamp((({f_16_8 : 845.9984} * 0.006666667f) + (0.f - 1.f)), 0.0, 1.0)
	out_attr8.z = clamp(((f_16_8 * 0.006666667f) + (0.f - 1.f)), 0.0, 1.0);
	// 121.9725  <=>  {pf_1_14 : 121.9725}
	gl_Position.w = pf_1_14;
	// 120.9774  <=>  (({pf_1_14 : 121.9725} * 0.5f) + (({pf_8_11 : 119.9822} * 0.5f) + ((0.f * {pf_15_19 : -953.9207}) + (0.f * {pf_9_17 : -117.2728}))))
	out_attr2.z = ((pf_1_14 * 0.5f) + ((pf_8_11 * 0.5f) + ((0.f * pf_15_19) + (0.f * pf_9_17))));
	// 121.9725  <=>  ({pf_1_14 : 121.9725} + ((0.f * {pf_8_11 : 119.9822}) + ((0.f * {pf_15_19 : -953.9207}) + (0.f * {pf_9_17 : -117.2728}))))
	out_attr2.w = (pf_1_14 + ((0.f * pf_8_11) + ((0.f * pf_15_19) + (0.f * pf_9_17))));
	// 0.8516829  <=>  {f_4_42 : 0.8516829}
	out_attr8.x = f_4_42;
	// -1.00  <=>  (0.f - clamp((({f_2_80 : 875.043} * {utof(vs_cbuf15[24].x) : 0.0033333}) + (0.f - {utof(vs_cbuf15[24].y) : 0.00})), 0.0, 1.0))
	f_0_12 = (0.f - clamp(((f_2_80 * utof(vs_cbuf15[24].x)) + (0.f - utof(vs_cbuf15[24].y))), 0.0, 1.0));
	// 0.9117381  <=>  exp2(({f_0_8 : -0.0031367} * {utof(vs_cbuf15[23].x) : 42.50}))
	f_18_5 = exp2((f_0_8 * utof(vs_cbuf15[23].x)));
	// 0.2335474  <=>  exp2((log2(({f_15_5 : -0.0336416} + 1.f)) * {utof(vs_cbuf15[23].x) : 42.50}))
	f_20_3 = exp2((log2((f_15_5 + 1.f)) * utof(vs_cbuf15[23].x)));
	// 0.00  <=>  clamp((({pf_5_3 : 1448.566} + (0.f - {utof(vs_cbuf15[60].w) : 1672.144})) * 0.1f), 0.0, 1.0)
	f_16_12 = clamp(((pf_5_3 + (0.f - utof(vs_cbuf15[60].w))) * 0.1f), 0.0, 1.0);
	// 0.4000215  <=>  min((({f_2_80 : 875.043} + (0.f - {utof(vs_cbuf15[54].z) : 75.00})) * (1.0f / {utof(vs_cbuf15[54].w) : 2000.00})), {utof(vs_cbuf15[55].w) : 0.70})
	f_19_8 = min(((f_2_80 + (0.f - utof(vs_cbuf15[54].z))) * (1.0f / utof(vs_cbuf15[54].w))), utof(vs_cbuf15[55].w));
	// 0.00  <=>  ((clamp(({pf_2_9 : -0.1992459} * {utof(vs_cbuf15[60].z) : 4.00}), 0.0, 1.0) * clamp((({f_2_80 : 875.043} * 0.001f) + (0.f - 0.5f)), 0.0, 1.0)) * {f_16_12 : 0.00})
	pf_4_24 = ((clamp((pf_2_9 * utof(vs_cbuf15[60].z)), 0.0, 1.0) * clamp(((f_2_80 * 0.001f) + (0.f - 0.5f)), 0.0, 1.0)) * f_16_12);
	// 121.398  <=>  (({f_4_38 : -0.0048789} * (0.f - {utof(vs_cbuf8[30].z) : 25000.00})) + {utof(vs_cbuf15[28].y) : -0.5741013})
	pf_10_13 = ((f_4_38 * (0.f - utof(vs_cbuf8[30].z))) + utof(vs_cbuf15[28].y));
	// 0.00  <=>  clamp((({pf_10_12 : 0.3007541} + (0.f - {utof(vs_cbuf15[60].y) : 0.50})) * {utof(vs_cbuf15[60].z) : 4.00}), 0.0, 1.0)
	f_0_16 = clamp(((pf_10_12 + (0.f - utof(vs_cbuf15[60].y))) * utof(vs_cbuf15[60].z)), 0.0, 1.0);
	// 0.0750226  <=>  clamp((({f_18_5 : 0.9117381} * (0.f - {utof(vs_cbuf15[23].z) : 0.85})) + {utof(vs_cbuf15[23].z) : 0.85}), 0.0, 1.0)
	f_16_14 = clamp(((f_18_5 * (0.f - utof(vs_cbuf15[23].z))) + utof(vs_cbuf15[23].z)), 0.0, 1.0);
	// 0.00  <=>  clamp((({f_2_80 : 875.043} + (0.f - {utof(vs_cbuf15[54].w) : 2000.00})) * (1.0f / {utof(vs_cbuf15[57].z) : 3000.00})), 0.0, 1.0)
	f_17_8 = clamp(((f_2_80 + (0.f - utof(vs_cbuf15[54].w))) * (1.0f / utof(vs_cbuf15[57].z))), 0.0, 1.0);
	// 0.00  <=>  ({pf_4_24 : 0.00} * {utof(vs_cbuf15[60].x) : 0.75})
	pf_4_25 = (pf_4_24 * utof(vs_cbuf15[60].x));
	// 190.0264  <=>  ({pf_10_13 : 121.398} * (1.0f / clamp((({utof(vs_cbuf15[28].y) : -0.5741013} * 1.5f) + 1.5f), 0.0, 1.0)))
	pf_7_28 = (pf_10_13 * (1.0f / clamp(((utof(vs_cbuf15[28].y) * 1.5f) + 1.5f), 0.0, 1.0)));
	// 0.5110098  <=>  clamp((({pf_21_1 : 223.5778} * {f_3_60 : 0.0011428}) * 2.f), 0.0, 1.0)
	f_0_17 = clamp(((pf_21_1 * f_3_60) * 2.f), 0.0, 1.0);
	// 0.00  <=>  (({pf_4_25 : 0.00} * (0.f - {utof(vs_cbuf15[1].x) : 0.00})) + {pf_4_25 : 0.00})
	out_attr11.w = ((pf_4_25 * (0.f - utof(vs_cbuf15[1].x))) + pf_4_25);
	// 0.2606079  <=>  (clamp((({f_20_3 : 0.2335474} * (0.f - {utof(vs_cbuf15[23].z) : 0.85})) + {utof(vs_cbuf15[23].z) : 0.85}), 0.0, 1.0) * max(0.f, {f_19_8 : 0.4000215}))
	pf_4_27 = (clamp(((f_20_3 * (0.f - utof(vs_cbuf15[23].z))) + utof(vs_cbuf15[23].z)), 0.0, 1.0) * max(0.f, f_19_8));
	// 0.00  <=>  exp2((log2(({f_0_12 : -1.00} + 1.f)) * {utof(vs_cbuf15[24].w) : 4.00}))
	f_0_19 = exp2((log2((f_0_12 + 1.f)) * utof(vs_cbuf15[24].w)));
	// -415.9741  <=>  (({pf_1_14 : 121.9725} * 0.5f) + ((0.f * {pf_8_11 : 119.9822}) + (({pf_15_19 : -953.9207} * 0.5f) + (0.f * {pf_9_17 : -117.2728}))))
	out_attr2.x = ((pf_1_14 * 0.5f) + ((0.f * pf_8_11) + ((pf_15_19 * 0.5f) + (0.f * pf_9_17))));
	// 119.6226  <=>  (({pf_1_14 : 121.9725} * 0.5f) + ((0.f * {pf_8_11 : 119.9822}) + ((0.f * {pf_15_19 : -953.9207}) + ({pf_9_17 : -117.2728} * -0.5f))))
	out_attr2.y = ((pf_1_14 * 0.5f) + ((0.f * pf_8_11) + ((0.f * pf_15_19) + (pf_9_17 * -0.5f))));
	// 0.12  <=>  (({f_0_19 : 0.00} * (0.f - {utof(vs_cbuf15[25].w) : 0.12})) + {utof(vs_cbuf15[25].w) : 0.12})
	out_attr7.x = ((f_0_19 * (0.f - utof(vs_cbuf15[25].w))) + utof(vs_cbuf15[25].w));
	// 0.00  <=>  (((({f_0_16 : 0.00} * {f_16_14 : 0.0750226}) * (0.f - {utof(vs_cbuf15[1].x) : 0.00})) + ({f_0_16 : 0.00} * {f_16_14 : 0.0750226})) * {utof(vs_cbuf15[61].x) : 1.00})
	out_attr12.w = ((((f_0_16 * f_16_14) * (0.f - utof(vs_cbuf15[1].x))) + (f_0_16 * f_16_14)) * utof(vs_cbuf15[61].x));
	// 0.9775043  <=>  clamp((({f_2_80 : 875.043} * 0.0001f) + 0.89f), 0.9f, 0.98f)
	out_attr10.y = clamp(((f_2_80 * 0.0001f) + 0.89f), 0.9f, 0.98f);
	// 0.0349742  <=>  clamp((min((({f_2_80 : 875.043} * -0.0006f) + 0.56f), 0.5f) + (0.f - 0.f)), 0.0, 1.0)
	out_attr10.x = clamp((min(((f_2_80 * -0.0006f) + 0.56f), 0.5f) + (0.f - 0.f)), 0.0, 1.0);
	// 0.00  <=>  clamp(((((0.f - {pf_5_3 : 1448.566}) + min({utof(vs_cbuf8[29].y) : 1672.144}, {utof(vs_cbuf15[27].z) : 250.00})) * {utof(vs_cbuf15[27].y) : 0.0045455}) + {utof(vs_cbuf15[27].x) : -0.0909091}), 0.0, 1.0)
	f_0_28 = clamp(((((0.f - pf_5_3) + min(utof(vs_cbuf8[29].y), utof(vs_cbuf15[27].z))) * utof(vs_cbuf15[27].y)) + utof(vs_cbuf15[27].x)), 0.0, 1.0);
	// 0.36  <=>  ({textureLod({tex2 : tex2}, vec2(0.5f, (({f_4_42 : 0.8516829} * -0.1f) + 0.68f)), 0.0).y : 0.50} * 0.72f)
	pf_0_28 = (textureLod(tex2, vec2(0.5f, ((f_4_42 * -0.1f) + 0.68f)), 0.0).y * 0.72f);
	// 0.50  <=>  {textureLod({tex2 : tex2}, vec2((({pf_21_7 : -0.8627108} * 0.63661975f) + 1.f), (({pf_13_13 : 0.1415062} * -0.5f) + 0.5f)), 0.0).x : 0.50}
	out_attr11.x = textureLod(tex2, vec2(((pf_21_7 * 0.63661975f) + 1.f), ((pf_13_13 * -0.5f) + 0.5f)), 0.0).x;
	// 0.50  <=>  {textureLod({tex2 : tex2}, vec2((({pf_21_7 : -0.8627108} * 0.63661975f) + 1.f), (({pf_13_13 : 0.1415062} * -0.5f) + 0.5f)), 0.0).y : 0.50}
	out_attr11.y = textureLod(tex2, vec2(((pf_21_7 * 0.63661975f) + 1.f), ((pf_13_13 * -0.5f) + 0.5f)), 0.0).y;
	// 0.50  <=>  {textureLod({tex2 : tex2}, vec2((({pf_21_7 : -0.8627108} * 0.63661975f) + 1.f), (({pf_13_13 : 0.1415062} * -0.5f) + 0.5f)), 0.0).z : 0.50}
	out_attr11.z = textureLod(tex2, vec2(((pf_21_7 * 0.63661975f) + 1.f), ((pf_13_13 * -0.5f) + 0.5f)), 0.0).z;
	// 0.47  <=>  (({textureLod({tex2 : tex2}, vec2(0.5f, (({f_4_42 : 0.8516829} * -0.1f) + 0.68f)), 0.0).x : 0.50} * 0.22f) + {pf_0_28 : 0.36})
	pf_0_29 = ((textureLod(tex2, vec2(0.5f, ((f_4_42 * -0.1f) + 0.68f)), 0.0).x * 0.22f) + pf_0_28);
	// 0.50  <=>  (({textureLod({tex2 : tex2}, vec2(0.5f, (({f_4_42 : 0.8516829} * -0.1f) + 0.68f)), 0.0).z : 0.50} * 0.06f) + {pf_0_29 : 0.47})
	pf_0_30 = ((textureLod(tex2, vec2(0.5f, ((f_4_42 * -0.1f) + 0.68f)), 0.0).z * 0.06f) + pf_0_29);
	// 0.2218042  <=>  (((({textureLod({tex2 : tex2}, {f2_0_1 : vec2(0.4028748,0.5638762)}, 0.0).x : 0.50} + (0.f - {utof(vs_cbuf15[55].x) : 0.8511029})) * ({f_0_17 : 0.5110098} * {f_17_8 : 0.00})) + {utof(vs_cbuf15[55].x) : 0.8511029}) * min({pf_4_27 : 0.2606079}, {f_4_42 : 0.8516829}))
	pf_1_18 = ((((textureLod(tex2, f2_0_1, 0.0).x + (0.f - utof(vs_cbuf15[55].x))) * (f_0_17 * f_17_8)) + utof(vs_cbuf15[55].x)) * min(pf_4_27, f_4_42));
	// 0.2764488  <=>  (((({textureLod({tex2 : tex2}, {f2_0_1 : vec2(0.4028748,0.5638762)}, 0.0).z : 0.50} + (0.f - {utof(vs_cbuf15[55].z) : 1.060784})) * ({f_0_17 : 0.5110098} * {f_17_8 : 0.00})) + {utof(vs_cbuf15[55].z) : 1.060784}) * min({pf_4_27 : 0.2606079}, {f_4_42 : 0.8516829}))
	pf_0_31 = ((((textureLod(tex2, f2_0_1, 0.0).z + (0.f - utof(vs_cbuf15[55].z))) * (f_0_17 * f_17_8)) + utof(vs_cbuf15[55].z)) * min(pf_4_27, f_4_42));
	// 0.00  <=>  ({f_0_28 : 0.00} * {utof(vs_cbuf15[26].w) : 0.4519901})
	out_attr7.y = (f_0_28 * utof(vs_cbuf15[26].w));
	// 0.2150015  <=>  (((({textureLod({tex2 : tex2}, {f2_0_1 : vec2(0.4028748,0.5638762)}, 0.0).y : 0.50} + (0.f - {utof(vs_cbuf15[55].y) : 0.825})) * ({f_0_17 : 0.5110098} * {f_17_8 : 0.00})) + {utof(vs_cbuf15[55].y) : 0.825}) * min({pf_4_27 : 0.2606079}, {f_4_42 : 0.8516829}))
	pf_2_17 = ((((textureLod(tex2, f2_0_1, 0.0).y + (0.f - utof(vs_cbuf15[55].y))) * (f_0_17 * f_17_8)) + utof(vs_cbuf15[55].y)) * min(pf_4_27, f_4_42));
	// 0.999997  <=>  {utof(vs_cbuf10[3].x) : 0.999997}
	out_attr3.x = utof(vs_cbuf10[3].x);
	// -0.3199379  <=>  ((0.f - min({pf_4_27 : 0.2606079}, {f_4_42 : 0.8516829})) + (0.f - (((max(0.f, {f_19_8 : 0.4000215}) * (0.f - {f_4_42 : 0.8516829})) + max(0.f, {f_19_8 : 0.4000215})) * (1.0f / max({pf_0_30 : 0.50}, 1.f)))))
	pf_5_4 = ((0.f - min(pf_4_27, f_4_42)) + (0.f - (((max(0.f, f_19_8) * (0.f - f_4_42)) + max(0.f, f_19_8)) * (1.0f / max(pf_0_30, 1.f)))));
	// 1.00  <=>  exp2((log2(abs(max({pf_0_30 : 0.50}, 1.f))) * 0.7f))
	f_0_32 = exp2((log2(abs(max(pf_0_30, 1.f))) * 0.7f));
	// 0.6800621  <=>  ({pf_5_4 : -0.3199379} + 1.f)
	out_attr9.w = (pf_5_4 + 1.f);
	// 0.50  <=>  ({textureLod({tex1 : tex1}, {f2_0_3 : vec2(0.4507813,0.9972897)}, 0.0).x : 0.50} * clamp((max(({pf_7_28 : 190.0264} * 0.06666667f), 0.2f) + (0.f - 0.f)), 0.0, 1.0))
	pf_3_15 = (textureLod(tex1, f2_0_3, 0.0).x * clamp((max((pf_7_28 * 0.06666667f), 0.2f) + (0.f - 0.f)), 0.0, 1.0));
	// 0.50  <=>  ({textureLod({tex1 : tex1}, {f2_0_3 : vec2(0.4507813,0.9972897)}, 0.0).y : 0.50} * clamp((max(({pf_7_28 : 190.0264} * 0.06666667f), 0.2f) + (0.f - 0.f)), 0.0, 1.0))
	pf_5_5 = (textureLod(tex1, f2_0_3, 0.0).y * clamp((max((pf_7_28 * 0.06666667f), 0.2f) + (0.f - 0.f)), 0.0, 1.0));
	// 0.50  <=>  {pf_3_15 : 0.50}
	out_attr12.x = pf_3_15;
	// 0.50  <=>  ({textureLod({tex1 : tex1}, {f2_0_3 : vec2(0.4507813,0.9972897)}, 0.0).z : 0.50} * clamp((max(({pf_7_28 : 190.0264} * 0.06666667f), 0.2f) + (0.f - 0.f)), 0.0, 1.0))
	pf_3_16 = (textureLod(tex1, f2_0_3, 0.0).z * clamp((max((pf_7_28 * 0.06666667f), 0.2f) + (0.f - 0.f)), 0.0, 1.0));
	// 0.50  <=>  {pf_5_5 : 0.50}
	out_attr12.y = pf_5_5;
	// 0.50  <=>  ({textureLod({tex2 : tex2}, vec2(0.5f, (({f_4_42 : 0.8516829} * -0.1f) + 0.68f)), 0.0).x : 0.50} * (1.0f / {f_0_32 : 1.00}))
	pf_5_6 = (textureLod(tex2, vec2(0.5f, ((f_4_42 * -0.1f) + 0.68f)), 0.0).x * (1.0f / f_0_32));
	// 0.50  <=>  {pf_3_16 : 0.50}
	out_attr12.z = pf_3_16;
	// 0.50  <=>  ({textureLod({tex2 : tex2}, vec2(0.5f, (({f_4_42 : 0.8516829} * -0.1f) + 0.68f)), 0.0).y : 0.50} * (1.0f / {f_0_32 : 1.00}))
	pf_3_17 = (textureLod(tex2, vec2(0.5f, ((f_4_42 * -0.1f) + 0.68f)), 0.0).y * (1.0f / f_0_32));
	// 0.50  <=>  ({textureLod({tex2 : tex2}, vec2(0.5f, (({f_4_42 : 0.8516829} * -0.1f) + 0.68f)), 0.0).z : 0.50} * (1.0f / {f_0_32 : 1.00}))
	pf_6_7 = (textureLod(tex2, vec2(0.5f, ((f_4_42 * -0.1f) + 0.68f)), 0.0).z * (1.0f / f_0_32));
	// 0.2514692  <=>  (({pf_5_6 : 0.50} * (((max(0.f, {f_19_8 : 0.4000215}) * (0.f - {f_4_42 : 0.8516829})) + max(0.f, {f_19_8 : 0.4000215})) * (1.0f / max({pf_0_30 : 0.50}, 1.f)))) + {pf_1_18 : 0.2218042})
	out_attr9.x = ((pf_5_6 * (((max(0.f, f_19_8) * (0.f - f_4_42)) + max(0.f, f_19_8)) * (1.0f / max(pf_0_30, 1.f)))) + pf_1_18);
	// 0.2446665  <=>  (({pf_3_17 : 0.50} * (((max(0.f, {f_19_8 : 0.4000215}) * (0.f - {f_4_42 : 0.8516829})) + max(0.f, {f_19_8 : 0.4000215})) * (1.0f / max({pf_0_30 : 0.50}, 1.f)))) + {pf_2_17 : 0.2150015})
	out_attr9.y = ((pf_3_17 * (((max(0.f, f_19_8) * (0.f - f_4_42)) + max(0.f, f_19_8)) * (1.0f / max(pf_0_30, 1.f)))) + pf_2_17);
	// 0.3061138  <=>  (({pf_6_7 : 0.50} * (((max(0.f, {f_19_8 : 0.4000215}) * (0.f - {f_4_42 : 0.8516829})) + max(0.f, {f_19_8 : 0.4000215})) * (1.0f / max({pf_0_30 : 0.50}, 1.f)))) + {pf_0_31 : 0.2764488})
	out_attr9.z = ((pf_6_7 * (((max(0.f, f_19_8) * (0.f - f_4_42)) + max(0.f, f_19_8)) * (1.0f / max(pf_0_30, 1.f)))) + pf_0_31);
	return;
}