vec4 gl_FragCoord;
layout(location = 0) in vec4 in_attr0;
layout(location = 0) out vec4 frag_color0;
layout(location = 1) out vec4 frag_color1;
layout(location = 2) out vec4 frag_color2;
layout(location = 3) out vec4 frag_color3;
layout(location = 4) out vec4 frag_color4;
layout(location = 5) out vec4 frag_color5;
layout(location = 6) out vec4 frag_color6;
layout(location = 7) out vec4 frag_color7;
layout(std140, binding = 0) uniform fs_cbuf_4 { uvec4 fs_cbuf4[4096]; };
layout(std140, binding = 1) uniform fs_cbuf_5 { uvec4 fs_cbuf5[4096]; };
layout(binding = 0) uniform sampler2D tex0;
layout(binding = 1) uniform sampler2D tex1;
void main() {
gl_FragCoord = vec4(320,240,0.5,1.0);
in_attr0.x = float(0.00);
in_attr0.y = float(0.00);
in_attr0.z = float(0.00);
in_attr0.w = float(1.00);
fs_cbuf4[1] = uvec4(1043307133, 3207190058, 3208278950, 0);
fs_cbuf4[2] = uvec4(1043307133, 3207190058, 3208278950, 0);
fs_cbuf5[8] = uvec4(1053294592, 0, 0, 0);
fs_cbuf5[9] = uvec4(1053294592, 0, 0, 0);
fs_cbuf5[16] = uvec4(0, 0, 0, 1089785037);
fs_cbuf5[17] = uvec4(1089785037, 1088526752, 1085758511, 0);
fs_cbuf5[18] = uvec4(0, 0, 0, 1065353216);
fs_cbuf5[19] = uvec4(0, 0, 0, 1065353216);
  float f_0 = float(0);
  float f_1 = float(0);
  float f_2 = float(0);
  float f_3 = float(0);
  float f_4 = float(0);
  float f_5 = float(0);
  float f_6 = float(0);
  float f_7 = float(0);
  float f_8 = float(0);
  float f_9 = float(0);
  float f_10 = float(0);
  float f_11 = float(0);
  float f_12 = float(0);
  float f_13 = float(0);
  float f_14 = float(0);
  float f_15 = float(0);
  vec2 f2_0 = vec2(0);
  vec4 f4_0 = vec4(0);
  precise float pf_0 = float(0);
  precise float pf_1 = float(0);
  precise float pf_2 = float(0);
  precise float pf_3 = float(0);
  precise float pf_4 = float(0);
  precise float pf_5 = float(0);
  precise float pf_6 = float(0);
  precise float pf_7 = float(0);
  precise float pf_8 = float(0);
  precise float pf_9 = float(0);
  precise float pf_10 = float(0);
  precise float pf_11 = float(0);
  precise float pf_12 = float(0);
  precise float pf_13 = float(0);
  precise float pf_14 = float(0);
  precise float pf_15 = float(0);
  precise float pf_16 = float(0);
  precise float pf_17 = float(0);
  precise float pf_18 = float(0);
  precise float pf_19 = float(0);
  precise float pf_20 = float(0);
  precise float pf_21 = float(0);
  precise float pf_22 = float(0);
  precise float pf_23 = float(0);
  precise float pf_24 = float(0);
  precise float pf_25 = float(0);
  precise float pf_26 = float(0);
  precise float pf_27 = float(0);
  precise float pf_28 = float(0);
  precise float pf_29 = float(0);
  precise float pf_30 = float(0);
  f_0 = in_attr0.x;
  f_1 = in_attr0.y;
  f2_0 = vec2(f_0, f_1);
  f4_0 = texture(tex1, f2_0);
  f_0 = f4_0.x;
  f_1 = f4_0.y;
  f_2 = f4_0.z;
  f_3 = utof(fs_cbuf4[1].x);
  f_3 = 0.f - (f_3);
  pf_0 = f_0 * f_3;
  f_3 = utof(fs_cbuf4[1].x);
  pf_1 = f_0 * f_3;
  f_3 = utof(fs_cbuf4[1].x);
  f_3 = 0.f - (f_3);
  pf_2 = f_2 * f_3;
  f_3 = utof(fs_cbuf4[2].x);
  pf_3 = f_2 * f_3;
  f_3 = utof(fs_cbuf4[2].x);
  pf_4 = f_0 * f_3;
  f_3 = utof(fs_cbuf4[2].x);
  f_3 = 0.f - (f_3);
  pf_5 = f_2 * f_3;
  f_3 = utof(fs_cbuf4[1].x);
  pf_6 = f_2 * f_3;
  f_3 = utof(fs_cbuf4[2].x);
  f_3 = 0.f - (f_3);
  pf_7 = f_0 * f_3;
  f_3 = utof(fs_cbuf4[1].y);
  pf_0 = fma(f_1, f_3, pf_0);
  f_3 = utof(fs_cbuf4[1].y);
  pf_1 = fma(f_1, f_3, pf_1);
  f_3 = utof(fs_cbuf4[1].y);
  pf_8 = fma(f_0, f_3, pf_2);
  f_3 = utof(fs_cbuf4[2].y);
  pf_3 = fma(f_1, f_3, pf_3);
  f_3 = utof(fs_cbuf4[1].y);
  pf_9 = fma(f_1, f_3, pf_2);
  f_3 = utof(fs_cbuf4[2].y);
  pf_4 = fma(f_1, f_3, pf_4);
  f_3 = utof(fs_cbuf4[2].y);
  pf_10 = fma(f_0, f_3, pf_5);
  f_3 = utof(fs_cbuf4[2].y);
  f_3 = 0.f - (f_3);
  pf_11 = fma(f_0, f_3, pf_5);
  f_3 = utof(fs_cbuf4[1].y);
  f_3 = 0.f - (f_3);
  pf_2 = fma(f_0, f_3, pf_2);
  f_3 = utof(fs_cbuf4[1].y);
  pf_6 = fma(f_1, f_3, pf_6);
  f_3 = utof(fs_cbuf4[2].y);
  pf_7 = fma(f_1, f_3, pf_7);
  f_3 = utof(fs_cbuf4[2].y);
  pf_5 = fma(f_1, f_3, pf_5);
  f_3 = utof(fs_cbuf4[1].z);
  pf_0 = fma(f_2, f_3, pf_0);
  f_3 = utof(fs_cbuf4[1].z);
  pf_8 = fma(f_1, f_3, pf_8);
  f_3 = utof(fs_cbuf4[1].z);
  f_3 = 0.f - (f_3);
  pf_9 = fma(f_0, f_3, pf_9);
  f_3 = utof(fs_cbuf4[2].z);
  f_3 = 0.f - (f_3);
  pf_4 = fma(f_2, f_3, pf_4);
  f_3 = utof(fs_cbuf4[2].z);
  pf_3 = fma(f_0, f_3, pf_3);
  f_3 = utof(fs_cbuf4[1].z);
  f_3 = 0.f - (f_3);
  pf_1 = fma(f_2, f_3, pf_1);
  f_3 = utof(fs_cbuf4[1].z);
  f_3 = 0.f - (f_3);
  pf_2 = fma(f_1, f_3, pf_2);
  f_3 = utof(fs_cbuf4[1].z);
  pf_6 = fma(f_0, f_3, pf_6);
  f_3 = utof(fs_cbuf4[2].z);
  pf_7 = fma(f_2, f_3, pf_7);
  f_3 = utof(fs_cbuf4[2].z);
  pf_10 = fma(f_1, f_3, pf_10);
  f_3 = utof(fs_cbuf4[2].z);
  f_3 = 0.f - (f_3);
  pf_11 = fma(f_1, f_3, pf_11);
  f_3 = utof(fs_cbuf4[2].z);
  f_3 = 0.f - (f_3);
  pf_5 = fma(f_0, f_3, pf_5);
  pf_0 = fma(pf_0, -0.5f, 0.5f);
  pf_9 = fma(pf_9, -0.5f, 0.5f);
  pf_4 = fma(pf_4, -0.5f, 0.5f);
  pf_1 = fma(pf_1, -0.5f, 0.5f);
  pf_8 = fma(pf_8, -0.5f, 0.5f);
  pf_2 = fma(pf_2, -0.5f, 0.5f);
  pf_6 = fma(pf_6, -0.5f, 0.5f);
  pf_7 = fma(pf_7, -0.5f, 0.5f);
  pf_10 = fma(pf_10, -0.5f, 0.5f);
  pf_11 = fma(pf_11, -0.5f, 0.5f);
  pf_5 = fma(pf_5, -0.5f, 0.5f);
  pf_3 = fma(pf_3, -0.5f, 0.5f);
  f_3 = utof(fs_cbuf5[8].x);
  f2_0 = vec2(pf_1, f_3);
  f4_0 = texture(tex0, f2_0);
  f_3 = f4_0.x;
  f_4 = utof(fs_cbuf5[9].x);
  f2_0 = vec2(pf_4, f_4);
  f4_0 = texture(tex0, f2_0);
  f_4 = f4_0.x;
  f_5 = utof(fs_cbuf5[8].x);
  f2_0 = vec2(pf_0, f_5);
  f4_0 = texture(tex0, f2_0);
  f_5 = f4_0.x;
  f_6 = utof(fs_cbuf5[9].x);
  f2_0 = vec2(pf_7, f_6);
  f4_0 = texture(tex0, f2_0);
  f_6 = f4_0.x;
  f_7 = utof(fs_cbuf5[8].x);
  f2_0 = vec2(pf_8, f_7);
  f4_0 = texture(tex0, f2_0);
  f_7 = f4_0.x;
  f_8 = utof(fs_cbuf5[9].x);
  f2_0 = vec2(pf_10, f_8);
  f4_0 = texture(tex0, f2_0);
  f_8 = f4_0.x;
  f_9 = utof(fs_cbuf5[8].x);
  f2_0 = vec2(pf_2, f_9);
  f4_0 = texture(tex0, f2_0);
  f_9 = f4_0.x;
  f_10 = utof(fs_cbuf5[9].x);
  f2_0 = vec2(pf_11, f_10);
  f4_0 = texture(tex0, f2_0);
  f_10 = f4_0.x;
  f_11 = utof(fs_cbuf5[8].x);
  f2_0 = vec2(pf_9, f_11);
  f4_0 = texture(tex0, f2_0);
  f_11 = f4_0.x;
  f_12 = utof(fs_cbuf5[8].x);
  f2_0 = vec2(pf_6, f_12);
  f4_0 = texture(tex0, f2_0);
  f_12 = f4_0.x;
  f_13 = utof(fs_cbuf5[9].x);
  f2_0 = vec2(pf_5, f_13);
  f4_0 = texture(tex0, f2_0);
  f_13 = f4_0.x;
  f_14 = utof(fs_cbuf5[9].x);
  f2_0 = vec2(pf_3, f_14);
  f4_0 = texture(tex0, f2_0);
  f_14 = f4_0.x;
  f_15 = utof(fs_cbuf4[1].x);
  pf_1 = f_0 * f_15;
  f_15 = utof(fs_cbuf4[2].x);
  pf_4 = f_0 * f_15;
  f_15 = utof(fs_cbuf4[1].x);
  pf_6 = f_2 * f_15;
  f_15 = utof(fs_cbuf4[1].y);
  pf_1 = fma(f_1, f_15, pf_1);
  f_15 = utof(fs_cbuf4[2].y);
  pf_4 = fma(f_1, f_15, pf_4);
  f_15 = utof(fs_cbuf4[1].y);
  pf_6 = fma(f_1, f_15, pf_6);
  f_1 = utof(fs_cbuf5[17].y);
  f_15 = utof(fs_cbuf5[16].y);
  f_15 = 0.f - (f_15);
  pf_12 = f_15 + f_1;
  f_1 = utof(fs_cbuf4[1].z);
  f_1 = 0.f - (f_1);
  pf_1 = fma(f_2, f_1, pf_1);
  f_1 = utof(fs_cbuf4[2].z);
  f_1 = 0.f - (f_1);
  pf_4 = fma(f_2, f_1, pf_4);
  f_1 = utof(fs_cbuf4[1].z);
  pf_6 = fma(f_0, f_1, pf_6);
  f_0 = utof(fs_cbuf5[19].y);
  f_1 = utof(fs_cbuf5[18].y);
  f_1 = 0.f - (f_1);
  pf_13 = f_1 + f_0;
  f_0 = utof(fs_cbuf5[18].x);
  f_1 = utof(fs_cbuf5[19].x);
  f_0 = 0.f - (f_0);
  pf_14 = f_1 + f_0;
  f_0 = utof(fs_cbuf5[19].z);
  f_1 = utof(fs_cbuf5[18].z);
  f_1 = 0.f - (f_1);
  pf_15 = f_1 + f_0;
  pf_1 = fma(pf_1, -0.5f, 0.5f);
  pf_4 = fma(pf_4, -0.5f, 0.5f);
  pf_6 = fma(pf_6, -0.5f, 0.5f);
  pf_1 = pf_4 + pf_1;
  f_0 = utof(fs_cbuf5[16].x);
  f_1 = utof(fs_cbuf5[17].x);
  f_0 = 0.f - (f_0);
  pf_4 = f_1 + f_0;
  f_0 = utof(fs_cbuf5[17].z);
  f_1 = utof(fs_cbuf5[16].z);
  f_1 = 0.f - (f_1);
  pf_16 = f_1 + f_0;
  pf_0 = pf_7 + pf_0;
  pf_7 = pf_10 + pf_8;
  pf_2 = pf_11 + pf_2;
  pf_5 = pf_5 + pf_9;
  pf_3 = pf_3 + pf_6;
  f_0 = utof(fs_cbuf5[16].y);
  pf_6 = fma(pf_12, f_3, f_0);
  f_0 = utof(fs_cbuf5[16].x);
  pf_8 = fma(pf_4, f_3, f_0);
  f_0 = utof(fs_cbuf5[18].y);
  pf_9 = fma(pf_13, f_4, f_0);
  f_0 = utof(fs_cbuf5[18].x);
  pf_10 = fma(pf_14, f_4, f_0);
  f_0 = utof(fs_cbuf5[16].z);
  pf_11 = fma(pf_16, f_3, f_0);
  f_0 = utof(fs_cbuf5[18].z);
  pf_17 = fma(pf_15, f_4, f_0);
  f_0 = utof(fs_cbuf5[16].y);
  pf_18 = fma(pf_12, f_5, f_0);
  f_0 = utof(fs_cbuf5[16].z);
  pf_19 = fma(pf_16, f_5, f_0);
  pf_6 = pf_9 + pf_6;
  pf_8 = pf_10 + pf_8;
  f_0 = utof(fs_cbuf5[16].x);
  pf_9 = fma(pf_4, f_5, f_0);
  pf_10 = pf_17 + pf_11;
  f_0 = utof(fs_cbuf5[18].x);
  pf_11 = fma(pf_14, f_6, f_0);
  f_0 = utof(fs_cbuf5[18].z);
  pf_17 = fma(pf_15, f_6, f_0);
  f_0 = utof(fs_cbuf5[18].y);
  pf_20 = fma(pf_13, f_6, f_0);
  f_0 = utof(fs_cbuf5[16].y);
  pf_21 = fma(pf_12, f_11, f_0);
  pf_9 = pf_11 + pf_9;
  pf_11 = pf_17 + pf_19;
  pf_17 = pf_20 + pf_18;
  f_0 = utof(fs_cbuf5[16].y);
  pf_18 = fma(pf_12, f_7, f_0);
  f_0 = utof(fs_cbuf5[16].z);
  pf_19 = fma(pf_16, f_7, f_0);
  f_0 = utof(fs_cbuf5[16].x);
  pf_20 = fma(pf_4, f_7, f_0);
  f_0 = utof(fs_cbuf5[18].y);
  pf_22 = fma(pf_13, f_8, f_0);
  f_0 = utof(fs_cbuf5[18].x);
  pf_23 = fma(pf_14, f_8, f_0);
  f_0 = utof(fs_cbuf5[18].z);
  pf_24 = fma(pf_15, f_8, f_0);
  pf_18 = pf_22 + pf_18;
  pf_20 = pf_23 + pf_20;
  pf_19 = pf_24 + pf_19;
  f_0 = utof(fs_cbuf5[16].y);
  pf_22 = fma(pf_12, f_9, f_0);
  f_0 = utof(fs_cbuf5[16].z);
  pf_23 = fma(pf_16, f_9, f_0);
  f_0 = utof(fs_cbuf5[16].x);
  pf_24 = fma(pf_4, f_9, f_0);
  f_0 = utof(fs_cbuf5[18].y);
  pf_25 = fma(pf_13, f_10, f_0);
  f_0 = utof(fs_cbuf5[18].x);
  pf_26 = fma(pf_14, f_10, f_0);
  f_0 = utof(fs_cbuf5[18].z);
  pf_27 = fma(pf_15, f_10, f_0);
  pf_22 = pf_25 + pf_22;
  pf_24 = pf_26 + pf_24;
  f_0 = utof(fs_cbuf5[16].z);
  pf_25 = fma(pf_16, f_11, f_0);
  f_0 = utof(fs_cbuf5[16].x);
  pf_26 = fma(pf_4, f_11, f_0);
  f_0 = utof(fs_cbuf5[16].y);
  pf_12 = fma(pf_12, f_12, f_0);
  f_0 = utof(fs_cbuf5[18].x);
  pf_28 = fma(pf_14, f_13, f_0);
  f_0 = utof(fs_cbuf5[16].x);
  pf_4 = fma(pf_4, f_12, f_0);
  f_0 = utof(fs_cbuf5[16].z);
  pf_16 = fma(pf_16, f_12, f_0);
  f_0 = utof(fs_cbuf5[18].y);
  pf_29 = fma(pf_13, f_14, f_0);
  f_0 = utof(fs_cbuf5[18].x);
  pf_14 = fma(pf_14, f_14, f_0);
  f_0 = utof(fs_cbuf5[18].y);
  pf_13 = fma(pf_13, f_13, f_0);
  f_0 = utof(fs_cbuf5[18].z);
  pf_30 = fma(pf_15, f_13, f_0);
  f_0 = utof(fs_cbuf5[18].z);
  pf_15 = fma(pf_15, f_14, f_0);
  pf_23 = pf_27 + pf_23;
  pf_26 = pf_28 + pf_26;
  pf_12 = pf_29 + pf_12;
  pf_13 = pf_13 + pf_21;
  pf_21 = pf_30 + pf_25;
  pf_4 = pf_14 + pf_4;
  pf_14 = pf_15 + pf_16;
  frag_color0.x = pf_8;
  frag_color0.y = pf_6;
  frag_color0.z = pf_10;
  frag_color0.w = pf_1;
  frag_color1.x = pf_9;
  frag_color1.y = pf_17;
  frag_color1.z = pf_11;
  frag_color1.w = pf_0;
  frag_color2.x = pf_20;
  frag_color2.y = pf_18;
  frag_color2.z = pf_19;
  frag_color2.w = pf_7;
  frag_color3.x = pf_24;
  frag_color3.y = pf_22;
  frag_color3.z = pf_23;
  frag_color3.w = pf_2;
  frag_color4.x = pf_26;
  frag_color4.y = pf_13;
  frag_color4.z = pf_21;
  frag_color4.w = pf_5;
  frag_color5.x = pf_4;
  frag_color5.y = pf_12;
  frag_color5.z = pf_14;
  frag_color5.w = pf_3;
  return;
}