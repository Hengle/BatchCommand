out gl_PerVertex {
    vec4 gl_Position;
};
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

layout(binding = 0) uniform sampler2D tex0; 
layout(binding = 1) uniform sampler2D tex1; 
layout(binding = 2) uniform sampler2D tex2; 

void main() {
in_attr0.x = float(0.00);
in_attr0.y = float(0.00);
in_attr0.z = float(0.00);
in_attr0.w = float(1.00);
in_attr1.x = float(0.50);
in_attr1.y = float(0.50);
in_attr1.z = float(12.00);
in_attr1.w = float(1.00);
in_attr4.x = float(277.38879);
in_attr4.y = float(-253.98657);
in_attr4.z = float(-1225.84583);
in_attr4.w = float(1000.00);
in_attr5.x = float(0.00);
in_attr5.y = float(0.00);
in_attr5.z = float(0.00);
in_attr5.w = float(1060.50);
in_attr6.x = float(256.74911);
in_attr6.y = float(175.44524);
in_attr6.z = float(175.44524);
in_attr6.w = float(1.00);
in_attr7.x = float(0.33394);
in_attr7.y = float(0.62269);
in_attr7.z = float(0.01691);
in_attr7.w = float(0.7787);
in_attr9.x = float(1.00);
in_attr9.y = float(0.00);
in_attr9.z = float(0.00);
in_attr9.w = float(287.3111);
in_attr10.x = float(0.00);
in_attr10.y = float(1.00);
in_attr10.z = float(0.00);
in_attr10.w = float(1522.14368);
in_attr11.x = float(0.00);
in_attr11.y = float(0.00);
in_attr11.z = float(1.00);
in_attr11.w = float(1396.66956);
gl_Position.x = float(166.45822);
gl_Position.y = float(777.81085);
gl_Position.z = float(1259.94666);
gl_Position.w = float(1261.84583);
out_attr0.x = float(0.00);
out_attr0.y = float(0.00);
out_attr0.z = float(0.00);
out_attr0.w = float(1.00);
out_attr1.x = float(0.50);
out_attr1.y = float(0.50);
out_attr1.z = float(1.46396);
out_attr1.w = float(3.26268);
out_attr2.x = float(714.15204);
out_attr2.y = float(242.01749);
out_attr2.z = float(1260.89624);
out_attr2.w = float(1261.84583);
out_attr3.x = float(1.00);
out_attr3.y = float(0.00);
out_attr3.z = float(0.00);
out_attr3.w = float(1.00);
out_attr4.x = float(564.69989);
out_attr4.y = float(1268.1571);
out_attr4.z = float(170.82373);
out_attr4.w = float(1.00);
out_attr5.x = float(0.00);
out_attr5.y = float(175.44524);
out_attr5.z = float(0.00);
out_attr5.w = float(1.00);
out_attr6.x = float(2.00);
out_attr6.y = float(0.00);
out_attr6.z = float(0.00);
out_attr6.w = float(1.00);
out_attr7.x = float(0.12);
out_attr7.y = float(0.00);
out_attr7.z = float(0.00);
out_attr7.w = float(1.00);
out_attr8.x = float(1.00);
out_attr8.y = float(0.00);
out_attr8.z = float(1.00);
out_attr8.w = float(1.00);
out_attr9.x = float(0.40435);
out_attr9.y = float(0.39195);
out_attr9.z = float(0.50397);
out_attr9.w = float(0.52491);
out_attr10.x = float(4.77344);
out_attr10.y = float(3.10352);
out_attr10.z = float(1.75391);
out_attr10.w = float(0.00);
out_attr11.x = float(0.20251);
out_attr11.y = float(0.44214);
out_attr11.z = float(0.8335);
out_attr11.w = float(0.00);
vs_cbuf8[0] = uvec4(1065247121, 860928284, 1038480600, 3286050967);
vs_cbuf8[1] = uvec4(1031828066, 1062491979, 3205371645, 3290264139);
vs_cbuf8[2] = uvec4(3183394095, 1057947259, 1062403977, 3305154163);
vs_cbuf8[3] = uvec4(0, 0, 0, 1065353216);
vs_cbuf8[4] = uvec4(1067083659, 0, 0, 0);
vs_cbuf8[5] = uvec4(0, 1074347930, 0, 0);
vs_cbuf8[6] = uvec4(0, 0, 3212837535, 3221225807);
vs_cbuf8[7] = uvec4(0, 0, 3212836864, 0);
vs_cbuf8[29] = uvec4(1133488083, 1154548889, 1152292204, 0);
vs_cbuf8[30] = uvec4(1065353216, 1187205120, 1187205120, 1187204608);
vs_cbuf9[11] = uvec4(0, 0, 0, 0);
vs_cbuf9[12] = uvec4(0, 0, 0, 0);
vs_cbuf9[16] = uvec4(0, 0, 0, 1065353216);
vs_cbuf9[113] = uvec4(0, 0, 0, 0);
vs_cbuf9[114] = uvec4(1065353216, 1065353216, 1065353216, 1036831949);
vs_cbuf9[115] = uvec4(1065353216, 1065353216, 1065353216, 1063675494);
vs_cbuf9[116] = uvec4(0, 0, 0, 1065353216);
vs_cbuf9[141] = uvec4(1065353216, 1065353216, 1065353216, 0);
vs_cbuf10[0] = uvec4(1065353216, 1065353216, 1065353216, 1065353216);
vs_cbuf10[2] = uvec4(1154273280, 1126105088, 1065353216, 1065353216);
vs_cbuf10[3] = uvec4(1065353166, 1065353216, 1065353216, 1065353216);
vs_cbuf13[6] = uvec4(1065353216, 1065353216, 1092616192, 0);
vs_cbuf15[1] = uvec4(0, 1065353216, 1072865060, 1065353216);
vs_cbuf15[22] = uvec4(942622237, 994030768, 0, 0);
vs_cbuf15[23] = uvec4(1110048768, 1075838976, 1062836634, 3166425518);
vs_cbuf15[24] = uvec4(995783694, 0, 1058239677, 1082130432);
vs_cbuf15[25] = uvec4(1060018062, 1065194672, 1059307546, 1039516303);
vs_cbuf15[26] = uvec4(1066362785, 1067991434, 1059750465, 1055353662);
vs_cbuf15[27] = uvec4(3183095435, 999617033, 1132068864, 0);
vs_cbuf15[28] = uvec4(1057344769, 3205691469, 3206633754, 0);
vs_cbuf15[54] = uvec4(1062228420, 1071140278, 1117126656, 1157234688);
vs_cbuf15[55] = uvec4(1062855138, 1062417203, 1065863112, 1060320051);
vs_cbuf15[57] = uvec4(3314801541, 1147334299, 1161527296, 1065353216);
vs_cbuf15[60] = uvec4(1061158912, 1056964608, 1082130432, 1154548889);
vs_cbuf15[61] = uvec4(1065353216, 0, 0, 0);

    bool b_0 = bool(0);
    bool b_1 = bool(0);
    bool b_2 = bool(0);
    uint u_0 = uint(0);
    uint u_1 = uint(0);
    uint u_2 = uint(0);
    uint u_3 = uint(0);
    uint u_4 = uint(0);
    uint u_5 = uint(0);
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
    float f_16 = float(0);
    float f_17 = float(0);
    float f_18 = float(0);
    float f_19 = float(0);
    float f_20 = float(0);
    uvec2 u2_0 = uvec2(0);
    vec2 f2_0 = vec2(0);
    uvec4 tex0Size = uvec4(0);
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

    u_0 = 0u;
    gl_Position = vec4(0, 0, 0, 1);
    out_attr0 = vec4(0, 0, 0, 1);
    out_attr1 = vec4(0, 0, 0, 1);
    out_attr2 = vec4(0, 0, 0, 1);
    out_attr3 = vec4(0, 0, 0, 1);
    out_attr4 = vec4(0, 0, 0, 1);
    out_attr5 = vec4(0, 0, 0, 1);
    out_attr6 = vec4(0, 0, 0, 1);
    out_attr7 = vec4(0, 0, 0, 1);
    out_attr8 = vec4(0, 0, 0, 1);
    out_attr9 = vec4(0, 0, 0, 1);
    out_attr10 = vec4(0, 0, 0, 1);
    out_attr11 = vec4(0, 0, 0, 1);

    f_0 = in_attr4.w; 
    f_1 = trunc(f_0);
    f_1 = min(max(f_1, float(-2147483600.)), float(2147483600.));
    u_1 = int(f_1);
    b_0 = isnan(f_0);
    u_1 = b_0 ? ( 0u ) : ( u_1);
    b_0 = int(u_1) <= int(0u);
    b_1 = b_0 ? ( true ) : ( false);
    if(b_1) {
        gl_Position.x = 0.;
    }
    b_1 = b_0 ? ( true ) : ( false);
    u_2 = u_0;
    if(b_1) {
        u_3 = (vs_cbuf8[30].y); 
        u_2 = u_3;
    }
    b_1 = b_0 ? ( true ) : ( false);
    if(b_1) {
        gl_Position.y = 0.;
    }
    b_1 = b_0 ? ( true ) : ( false);
    u_0 = u_2;
    if(b_1) {
        f_0 = utof(u_2);
        pf_0 = f_0 * 5.;
        u_3 = ftou(pf_0);
        u_0 = u_3;
    }
    b_1 = b_0 ? ( true ) : ( false);
    if(b_1) {
        out_attr3.x = 0.; 
    }
    b_1 = b_0 ? ( true ) : ( false);
    if(b_1) {
        f_0 = utof(u_0);
        gl_Position.z = f_0;
    }
    b_1 = b_0 ? ( true ) : ( false);
    if(b_1) {
        return;
    }

    f_0 = in_attr5.w; 
    u_0 = ftou(f_0);
    f_1 = float(int(u_1));
    u_1 = ftou(f_1);
    f_2 = utof(vs_cbuf10[2].x); 
    f_3 = 0. - (f_0);
    pf_0 = f_3 + f_2;
    u_2 = ftou(pf_0);
    b_0 = pf_0 >= f_1 && !isnan(pf_0) && !isnan(f_1);
    f_1 = utof(vs_cbuf10[2].x); 
    b_1 = f_0 > f_1 && !isnan(f_0) && !isnan(f_1);
    b_0 = b_1 || b_0;
    b_1 = b_0 ? ( true ) : ( false);
    if(b_1) {
        gl_Position.x = 0.;
    }
    b_1 = b_0 ? ( true ) : ( false);
    u_3 = u_0;
    if(b_1) {
        u_4 = (vs_cbuf8[30].y); 
        u_3 = u_4;
    }
    b_1 = b_0 ? ( true ) : ( false);
    if(b_1) {
        gl_Position.y = 0.;
    }
    b_1 = b_0 ? ( true ) : ( false);
    u_0 = u_3;
    if(b_1) {
        f_0 = utof(u_3);
        pf_1 = f_0 * 5.;
        u_4 = ftou(pf_1);
        u_0 = u_4;
    }
    b_1 = b_0 ? ( true ) : ( false);
    if(b_1) {
        out_attr3.x = 0.; 
    }
    b_1 = b_0 ? ( true ) : ( false);
    if(b_1) {
        f_0 = utof(u_0);
        gl_Position.z = f_0;
    }
    b_1 = b_0 ? ( true ) : ( false);
    if(b_1) {
        return;
    }

    f_0 = utof(vs_cbuf9[11].y); 
    b_0 = 0. < f_0 && !isnan(0.) && !isnan(f_0); 
    f_0 = in_attr7.x; 
    f_1 = in_attr6.x; 
    f_2 = in_attr6.y; 
    f_3 = in_attr6.z; 
    f_4 = min(0., f_0);
    f_5 = 0. - (0.);
    pf_1 = f_4 + f_5;
    f_4 = min(max(pf_1, 0.0), 1.0);
    f_5 = utof(vs_cbuf9[141].y); 
    pf_1 = f_2 * f_5; 
    pf_2 = f_4 + f_1;
    f_1 = utof(vs_cbuf9[141].z); 
    pf_3 = f_3 * f_1;
    f_1 = utof(vs_cbuf9[141].x); 
    pf_2 = pf_2 * f_1;
    b_1 = !b_0;
    b_2 = b_0 ? ( true ) : ( false);
    u_0 = u_2;
    u_3 = u_1;
    if(b_2) {
        f_1 = utof(vs_cbuf9[12].z); 
        pf_4 = f_0 * f_1;
        f_1 = utof(vs_cbuf9[11].y); 
        f_1 = (1.0) / f_1;
        f_2 = utof(vs_cbuf9[11].y); 
        pf_0 = fma(pf_4, f_2, pf_0);
        pf_0 = pf_0 * f_1;
        u_4 = ftou(pf_0);
        f_1 = floor(pf_0);
        f_1 = 0. - (f_1);
        pf_0 = pf_0 + f_1;
        u_5 = ftou(pf_0);
        u_0 = u_5;
        u_3 = u_4;
    }
    b_0 = b_1 ? ( true ) : ( false);
    u_1 = u_0;
    if(b_0) {
        f_1 = utof(u_3);
        f_1 = (1.0) / f_1;
        f_2 = utof(u_0);
        pf_0 = f_2 * f_1;
        u_2 = ftou(pf_0);
        u_1 = u_2;
    }
    tex0Size = uvec4(uvec2(textureSize(tex0, int(0u))), 0u, 0u); 
    u_0 = tex0Size.x; 
    f_1 = in_attr4.x; 
    pf_0 = f_0 * 8.; 
    f_2 = in_attr11.x; 
    f_3 = floor(pf_0);
    f_4 = in_attr10.x; 
    f_5 = in_attr4.y; 
    f_6 = utof(vs_cbuf9[114].w); 
    f_7 = utof(vs_cbuf9[113].w); 
    f_7 = 0. - (f_7);
    pf_0 = f_7 + f_6;
    f_6 = in_attr11.y; 
    f_7 = utof(vs_cbuf9[113].x); 
    f_8 = utof(vs_cbuf9[114].x); 
    f_7 = 0. - (f_7);
    pf_4 = f_8 + f_7;
    f_7 = (1.0) / pf_0;
    pf_0 = f_1 * f_2;
    f_2 = in_attr10.y; 
    pf_4 = pf_4 * f_7;

    f_7 = in_attr1.z; 

    pf_5 = f_1 * f_4;
    f_4 = in_attr9.x; 
    pf_0 = fma(f_5, f_6, pf_0);
    f_6 = in_attr9.y; 
    pf_5 = fma(f_5, f_2, pf_5);
    f_2 = in_attr4.z; 
    pf_6 = f_3 * 0.1429;
    f_8 = min(max(pf_6, 0.0), 1.0);
    f_9 = trunc(f_7);
    f_9 = min(max(f_9, float(-2147483600.)), float(2147483600.));
    u_2 = int(f_9);
    b_0 = isnan(f_7);
    u_2 = b_0 ? ( 0u ) : ( u_2);
    pf_6 = f_1 * f_4;
    f_1 = in_attr11.z; 
    pf_6 = fma(f_5, f_6, pf_6);
    f_4 = in_attr10.z; 
    f_5 = in_attr9.z; 
    f_6 = float(int(u_0));
    pf_7 = f_6 + -1.;
    pf_8 = pf_7 * f_8;
    f_6 = trunc(pf_7);
    f_6 = min(max(f_6, float(-2147483600.)), float(2147483600.));
    u_0 = int(f_6);
    b_0 = isnan(pf_7);
    u_0 = b_0 ? ( 0u ) : ( u_0);
    pf_0 = fma(f_2, f_1, pf_0);
    f_1 = trunc(pf_8);
    f_1 = min(max(f_1, float(-2147483600.)), float(2147483600.));
    u_3 = int(f_1);
    b_0 = isnan(pf_8);
    u_3 = b_0 ? ( 0u ) : ( u_3);
    u_4 = u_3 + 1u;
    u_0 = min(int(u_0), int(u_4));
    u2_0 = uvec2(u_3, u_2);
    f4_0 = texelFetch(tex0, ivec2(u2_0), int(0u));
    f_1 = f4_0.x;
    f_6 = f4_0.y;
    f_7 = f4_0.z;
    u2_0 = uvec2(u_0, u_2);
    f4_0 = texelFetch(tex0, ivec2(u2_0), int(0u));
    f_8 = f4_0.x;
    f_9 = f4_0.y;
    f_10 = f4_0.z;
    f_11 = utof(vs_cbuf9[114].w); 
    f_12 = utof(vs_cbuf9[115].w); 
    f_11 = 0. - (f_11);
    pf_7 = f_12 + f_11;
    f_11 = in_attr10.w; 
    f_12 = utof(vs_cbuf9[116].w); 
    f_13 = utof(vs_cbuf9[115].w); 
    f_13 = 0. - (f_13);
    pf_9 = f_13 + f_12;
    f_12 = (1.0) / pf_7;
    f_13 = utof(vs_cbuf9[113].w); 
    f_14 = utof(u_1);
    b_0 = f_14 >= f_13 && !isnan(f_14) && !isnan(f_13);
    u_0 = b_0 ? ( 1065353216u ) : ( 0u);
    f_13 = (1.0) / pf_9;
    f_14 = in_attr11.w; 
    f_15 = utof(vs_cbuf9[113].w); 
    f_16 = utof(u_1);
    f_15 = 0. - (f_15);
    pf_7 = f_16 + f_15;

    out_attr6.x = f_3; 

    f_3 = utof(vs_cbuf9[114].w); 
    f_15 = utof(u_1);
    b_0 = f_15 >= f_3 && !isnan(f_15) && !isnan(f_3);
    u_2 = b_0 ? ( 1065353216u ) : ( 0u);
    f_3 = utof(vs_cbuf9[115].x); 
    f_15 = utof(vs_cbuf9[114].x); 
    f_15 = 0. - (f_15);
    pf_9 = f_15 + f_3;
    pf_5 = fma(f_2, f_4, pf_5);
    f_3 = utof(vs_cbuf9[115].x); 
    f_4 = utof(vs_cbuf9[116].x); 
    f_3 = 0. - (f_3);
    pf_10 = f_4 + f_3;
    f_3 = utof(vs_cbuf9[113].x); 
    f_4 = utof(vs_cbuf9[113].x); 
    f_15 = utof(u_0);
    f_4 = 0. - (f_4);
    pf_11 = fma(f_15, f_4, f_3);
    f_3 = utof(vs_cbuf9[113].x); 
    pf_4 = fma(pf_4, pf_7, f_3);
    f_3 = utof(u_0);
    f_4 = utof(u_0);
    f_15 = utof(u_2);
    f_4 = 0. - (f_4);
    pf_7 = fma(f_15, f_4, f_3);
    pf_6 = fma(f_2, f_5, pf_6);
    pf_10 = pf_10 * f_13;
    f_2 = in_attr9.w; 
    pf_9 = pf_9 * f_12;
    pf_4 = fma(pf_4, pf_7, pf_11);
    f_3 = utof(vs_cbuf8[3].z); 
    f_4 = utof(vs_cbuf8[2].w); 
    pf_7 = f_4 * f_3;
    f_3 = utof(vs_cbuf8[3].z); 
    f_4 = utof(vs_cbuf8[2].x); 
    pf_11 = f_4 * f_3;
    f_3 = utof(vs_cbuf8[2].y); 
    f_4 = utof(vs_cbuf8[3].x); 
    pf_12 = f_4 * f_3;
    f_3 = utof(vs_cbuf8[3].x); 
    f_4 = utof(vs_cbuf8[2].z); 
    pf_13 = f_4 * f_3;
    f_3 = utof(vs_cbuf8[3].x); 
    f_4 = utof(vs_cbuf8[2].y); 
    pf_14 = f_4 * f_3;
    f_3 = utof(vs_cbuf8[2].y); 
    f_4 = utof(vs_cbuf8[3].w); 
    pf_15 = f_4 * f_3;
    f_3 = utof(vs_cbuf8[3].w); 
    f_4 = utof(vs_cbuf8[2].z); 
    f_5 = 0. - (pf_7);
    pf_7 = fma(f_4, f_3, f_5);
    f_3 = utof(vs_cbuf8[3].x); 
    f_4 = utof(vs_cbuf8[2].z); 
    f_5 = 0. - (pf_11);
    pf_11 = fma(f_4, f_3, f_5);
    f_3 = utof(vs_cbuf8[3].y); 
    f_4 = utof(vs_cbuf8[2].w); 
    pf_16 = f_4 * f_3;
    f_3 = utof(vs_cbuf8[3].y); 
    f_4 = utof(vs_cbuf8[2].z); 
    pf_17 = f_4 * f_3;
    f_3 = utof(vs_cbuf8[3].z); 
    f_4 = utof(vs_cbuf8[2].x); 
    f_5 = 0. - (pf_13);
    pf_13 = fma(f_4, f_3, f_5);
    f_3 = utof(vs_cbuf8[3].y); 
    f_4 = utof(vs_cbuf8[2].x); 
    f_5 = 0. - (pf_12);
    pf_12 = fma(f_4, f_3, f_5);
    f_3 = utof(vs_cbuf8[3].y); 
    f_4 = utof(vs_cbuf8[2].x); 
    f_5 = 0. - (pf_14);
    pf_14 = fma(f_4, f_3, f_5);
    f_3 = utof(vs_cbuf8[3].w); 
    f_4 = utof(vs_cbuf8[2].x); 
    pf_18 = f_4 * f_3;
    f_3 = utof(vs_cbuf8[3].y); 
    f_4 = utof(vs_cbuf8[2].w); 
    f_5 = 0. - (pf_15);
    pf_15 = fma(f_4, f_3, f_5);
    pf_6 = pf_6 + f_2;
    f_2 = utof(vs_cbuf8[3].w); 
    f_3 = utof(vs_cbuf8[2].y); 
    pf_19 = f_3 * f_2;
    f_2 = utof(vs_cbuf8[3].w); 
    f_3 = utof(vs_cbuf8[2].y); 
    f_4 = 0. - (pf_16);
    pf_16 = fma(f_3, f_2, f_4);
    f_2 = utof(vs_cbuf8[3].z); 
    f_3 = utof(vs_cbuf8[2].y); 
    f_4 = 0. - (pf_17);
    pf_20 = fma(f_3, f_2, f_4);
    f_2 = utof(vs_cbuf9[114].w); 
    f_3 = utof(u_1);
    f_2 = 0. - (f_2);
    pf_21 = f_3 + f_2;
    f_2 = utof(vs_cbuf9[115].w); 
    f_3 = utof(u_1);
    b_0 = f_3 >= f_2 && !isnan(f_3) && !isnan(f_2);
    u_0 = b_0 ? ( 1065353216u ) : ( 0u);
    f_2 = utof(vs_cbuf8[2].y); 
    f_3 = utof(vs_cbuf8[3].z); 
    f_4 = 0. - (pf_17);
    pf_17 = fma(f_3, f_2, f_4);
    f_2 = utof(vs_cbuf8[1].y); 
    pf_11 = pf_11 * f_2;
    pf_5 = pf_5 + f_11;
    f_2 = utof(vs_cbuf8[29].x); 
    f_3 = 0. - (pf_6);
    pf_22 = f_3 + f_2;
    f_2 = utof(vs_cbuf9[114].x); 
    pf_9 = fma(pf_9, pf_21, f_2);
    f_2 = utof(u_2);
    f_3 = utof(u_0);
    f_4 = utof(u_2);
    f_3 = 0. - (f_3);
    pf_21 = fma(f_4, f_3, f_2);
    f_2 = utof(vs_cbuf8[3].x); 
    f_3 = utof(vs_cbuf8[2].w); 
    f_4 = 0. - (pf_18);
    pf_18 = fma(f_3, f_2, f_4);
    f_2 = utof(vs_cbuf8[3].y); 
    f_3 = utof(vs_cbuf8[2].w); 
    f_4 = 0. - (pf_19);
    pf_19 = fma(f_3, f_2, f_4);
    f_2 = utof(vs_cbuf8[29].y); 
    f_3 = 0. - (pf_5);
    pf_23 = f_3 + f_2;
    pf_24 = pf_22 * pf_22;
    pf_0 = pf_0 + f_14;
    pf_4 = fma(pf_9, pf_21, pf_4);
    f_2 = utof(vs_cbuf8[1].x); 
    pf_9 = pf_16 * f_2;
    f_2 = utof(vs_cbuf8[0].y); 
    pf_21 = pf_7 * f_2;
    f_2 = utof(vs_cbuf8[1].x); 
    pf_11 = fma(pf_17, f_2, pf_11);
    pf_17 = fma(pf_23, pf_23, pf_24);
    f_2 = utof(vs_cbuf8[29].z); 
    f_3 = 0. - (pf_0);
    pf_24 = f_3 + f_2;
    f_2 = utof(vs_cbuf8[1].w); 
    pf_25 = pf_13 * f_2;
    f_2 = utof(vs_cbuf8[1].w); 
    pf_9 = fma(pf_12, f_2, pf_9);
    f_2 = utof(vs_cbuf8[0].z); 
    pf_12 = fma(pf_19, f_2, pf_21);
    f_2 = utof(vs_cbuf8[1].z); 
    pf_15 = pf_15 * f_2;
    f_2 = utof(vs_cbuf8[0].x); 
    pf_19 = pf_7 * f_2;
    pf_17 = fma(pf_24, pf_24, pf_17);
    f_2 = utof(vs_cbuf8[1].z); 
    pf_21 = fma(pf_18, f_2, pf_25);
    f_2 = inversesqrt(pf_17);
    f_3 = utof(vs_cbuf8[0].x); 
    pf_16 = pf_16 * f_3;
    f_3 = sqrt(pf_17);
    f_4 = utof(vs_cbuf8[1].y); 
    pf_15 = fma(pf_7, f_4, pf_15);
    f_4 = utof(vs_cbuf8[0].z); 
    pf_17 = fma(pf_18, f_4, pf_19);
    f_4 = utof(vs_cbuf8[1].y); 
    pf_9 = fma(pf_18, f_4, pf_9);
    f_4 = utof(vs_cbuf8[1].z); 
    pf_11 = fma(pf_14, f_4, pf_11);
    f_4 = utof(vs_cbuf8[1].x); 
    pf_7 = fma(pf_7, f_4, pf_21);
    f_4 = utof(vs_cbuf8[0].y); 
    pf_16 = fma(pf_18, f_4, pf_16);
    f_4 = utof(vs_cbuf8[1].w); 
    pf_15 = fma(pf_20, f_4, pf_15);
    f_4 = utof(vs_cbuf8[0].w); 
    pf_13 = fma(pf_13, f_4, pf_17);
    f_4 = utof(vs_cbuf8[0].w); 
    pf_12 = fma(pf_20, f_4, pf_12);
    f_4 = utof(vs_cbuf10[3].y); 
    pf_2 = pf_2 * f_4;
    f_4 = utof(vs_cbuf10[3].z); 
    pf_1 = pf_1 * f_4;
    pf_17 = pf_23 * f_2;

    out_attr5.y = pf_1; 

    pf_18 = pf_24 * f_2;
    f_4 = utof(vs_cbuf8[0].x); 
    pf_15 = pf_15 * f_4;
    pf_19 = pf_22 * f_2;
    f_2 = utof(vs_cbuf8[0].w); 
    pf_14 = fma(pf_14, f_2, pf_16);
    f_2 = utof(vs_cbuf10[3].w); 
    pf_3 = pf_3 * f_2;
    f_2 = 0. - (pf_18);
    pf_16 = fma(0., pf_17, f_2);
    f_2 = utof(vs_cbuf8[0].y); 
    f_2 = 0. - (f_2);
    pf_7 = fma(pf_7, f_2, pf_15);
    f_2 = 0. - (0.);
    pf_15 = f_2 + pf_19;
    pf_20 = fma(pf_16, pf_16, 0.);
    f_2 = utof(vs_cbuf8[0].z); 
    pf_7 = fma(pf_9, f_2, pf_7);
    pf_9 = fma(pf_15, pf_15, pf_20);
    f_2 = utof(vs_cbuf8[0].w); 
    f_2 = 0. - (f_2);
    pf_7 = fma(pf_11, f_2, pf_7);
    f_2 = inversesqrt(pf_9);
    f_4 = (1.0) / pf_7;
    pf_7 = pf_15 * f_2;
    pf_9 = pf_16 * f_2;
    pf_11 = 0. * f_2;
    f_2 = 0. - (f_4);
    pf_12 = pf_12 * f_2;
    pf_15 = pf_17 * pf_7;
    pf_16 = pf_18 * pf_9;
    pf_20 = pf_17 * pf_12;
    f_2 = 0. - (pf_15);
    pf_15 = fma(pf_18, pf_11, f_2);
    f_2 = 0. - (pf_16);
    pf_7 = fma(pf_19, pf_7, f_2);
    pf_11 = pf_19 * pf_11;
    pf_16 = pf_15 * pf_15;
    f_2 = 0. - (pf_11);
    pf_9 = fma(pf_17, pf_9, f_2);
    pf_11 = fma(pf_7, pf_7, pf_16);
    f_2 = utof(vs_cbuf9[115].w); 
    f_5 = utof(u_1);
    f_2 = 0. - (f_2);
    pf_16 = f_5 + f_2;
    pf_11 = fma(pf_9, pf_9, pf_11);
    f_2 = utof(vs_cbuf9[116].w); 
    f_5 = utof(u_1);
    b_0 = f_5 >= f_2 && !isnan(f_5) && !isnan(f_2);
    u_1 = b_0 ? ( 1065353216u ) : ( 0u);
    f_2 = inversesqrt(pf_11);
    f_5 = utof(vs_cbuf9[115].x); 
    pf_10 = fma(pf_10, pf_16, f_5);
    pf_11 = pf_13 * f_4;
    f_4 = 0. - (f_4);
    pf_13 = pf_14 * f_4;
    f_4 = utof(u_0);
    f_5 = utof(u_1);
    f_11 = utof(u_0);
    f_5 = 0. - (f_5);
    pf_14 = fma(f_11, f_5, f_4);
    f_4 = 0. - (pf_20);
    pf_16 = fma(pf_19, pf_11, f_4);
    pf_20 = pf_19 * pf_13;
    pf_4 = fma(pf_10, pf_14, pf_4);
    pf_7 = pf_7 * f_2;
    pf_10 = pf_18 * pf_11;
    f_4 = 0. - (pf_20);
    pf_14 = fma(pf_18, pf_12, f_4);
    f_4 = 0. - (0.);
    pf_20 = pf_7 + f_4;
    f_4 = min(max(pf_20, 0.0), 1.0);
    f_5 = 0. - (pf_10);
    pf_10 = fma(pf_17, pf_13, f_5);
    f_4 = 0. - (f_4);
    pf_20 = f_4 + 1.;
    pf_21 = pf_10 * pf_10;
    f_4 = log2(pf_20);
    f_5 = utof(vs_cbuf9[116].x); 
    f_11 = utof(u_1);
    pf_4 = fma(f_11, f_5, pf_4);
    pf_20 = fma(pf_14, pf_14, pf_21);
    pf_20 = fma(pf_16, pf_16, pf_20);
    f_5 = utof(vs_cbuf13[6].y); 
    pf_21 = f_4 * f_5;
    f_4 = inversesqrt(pf_20);
    f_5 = exp2(pf_21);
    pf_10 = pf_10 * f_4;
    pf_14 = pf_14 * f_4;
    pf_16 = pf_16 * f_4;
    pf_9 = pf_9 * f_2;
    pf_15 = pf_15 * f_2;
    pf_20 = pf_18 * pf_7;
    pf_12 = pf_12 * f_5;
    pf_21 = pf_19 * pf_9;
    f_2 = 0. - (f_5);
    pf_25 = f_2 + 1.;
    f_2 = 0. - (pf_20);
    pf_20 = fma(pf_17, pf_9, f_2);
    pf_10 = pf_10 * f_5;
    pf_14 = pf_14 * f_5;
    f_2 = 0. - (pf_21);
    pf_21 = fma(pf_18, pf_15, f_2);
    pf_12 = fma(pf_15, pf_25, pf_12);
    pf_15 = pf_17 * pf_15;
    pf_26 = pf_20 * pf_20;
    pf_11 = pf_11 * f_5;
    pf_16 = pf_16 * f_5;
    pf_13 = pf_13 * f_5;
    f_2 = 0. - (pf_15);
    pf_15 = fma(pf_19, pf_7, f_2);
    pf_26 = fma(pf_21, pf_21, pf_26);
    pf_9 = fma(pf_9, pf_25, pf_13);
    pf_13 = fma(pf_15, pf_15, pf_26);
    f_2 = inversesqrt(pf_13);
    pf_13 = pf_15 * f_2;
    pf_15 = pf_21 * f_2;
    pf_7 = fma(pf_7, pf_25, pf_11);
    pf_11 = pf_19 * f_5;
    pf_20 = pf_20 * f_2;
    pf_13 = fma(pf_13, pf_25, pf_16);
    pf_16 = pf_12 * pf_12;
    pf_14 = fma(pf_15, pf_25, pf_14);
    pf_11 = fma(pf_19, pf_25, pf_11);
    f_2 = utof(vs_cbuf10[0].w); 
    pf_4 = pf_4 * f_2;
    pf_15 = pf_18 * f_5;

    out_attr0.w = pf_4; 

    pf_4 = fma(pf_7, pf_7, pf_16);

    f_2 = in_attr1.y;

    pf_16 = 0. * f_5;
    pf_10 = fma(pf_20, pf_25, pf_10);
    pf_15 = fma(pf_18, pf_25, pf_15);
    pf_4 = fma(pf_9, pf_9, pf_4);
    pf_18 = pf_17 * f_5;
    f_4 = floor(pf_8);
    pf_19 = pf_10 * pf_10;
    f_5 = inversesqrt(pf_4);
    pf_4 = fma(pf_17, pf_25, pf_18);
    pf_17 = fma(pf_14, pf_14, pf_19);
    pf_16 = fma(0., pf_25, pf_16);

    f_11 = in_attr0.y;
    f_4 = 0. - (f_4);
    pf_8 = pf_8 + f_4;
    pf_18 = pf_11 * pf_11;
    pf_17 = fma(pf_13, pf_13, pf_17);
    pf_12 = f_5 * pf_12;
    f_4 = inversesqrt(pf_17);
    pf_7 = f_5 * pf_7;
    pf_9 = f_5 * pf_9;
    f_5 = 0. - (f_1);
    pf_17 = f_5 + f_8;
    f_5 = 0. - (f_6);
    pf_19 = f_5 + f_9;
    pf_18 = fma(pf_4, pf_4, pf_18);
    f_5 = 0. - (f_7);
    pf_20 = f_5 + f_10;
    pf_17 = fma(pf_17, pf_8, f_1);
    pf_19 = fma(pf_19, pf_8, f_6);
    pf_18 = fma(pf_15, pf_15, pf_18);
    f_1 = inversesqrt(pf_18);
    pf_10 = f_4 * pf_10;
    f_5 = utof(vs_cbuf9[16].x); 
    pf_18 = fma(0.5, f_5, pf_17);
    f_5 = utof(vs_cbuf9[16].y); 
    pf_21 = fma(0.5, f_5, pf_19);
    pf_14 = f_4 * pf_14;
    pf_8 = fma(pf_20, pf_8, f_7);
    pf_13 = f_4 * pf_13;
    pf_2 = pf_2 * pf_18;
    pf_1 = pf_1 * pf_21;
    f_4 = 0. - (f_11);
    pf_18 = pf_19 + f_4;
    pf_3 = pf_8 * pf_3;
    pf_8 = f_3 + float(1e-05);
    pf_11 = f_1 * pf_11;
    pf_10 = pf_2 * pf_10;
    pf_14 = pf_2 * pf_14;
    pf_2 = pf_2 * pf_13;
    pf_4 = f_1 * pf_4;
    pf_13 = f_1 * pf_15;
    f_1 = (1.0) / pf_8;
    pf_8 = fma(pf_1, pf_12, pf_10);
    pf_7 = fma(pf_1, pf_7, pf_14);
    pf_1 = fma(pf_1, pf_9, pf_2);
    pf_2 = fma(pf_3, pf_11, pf_8);
    pf_4 = fma(pf_3, pf_4, pf_7);
    pf_1 = fma(pf_3, pf_13, pf_1);
    pf_3 = pf_23 * f_1;
    pf_2 = pf_2 + pf_16;
    pf_4 = pf_4 + pf_16;
    pf_1 = pf_1 + pf_16;
    pf_7 = pf_24 * f_1;
    pf_2 = pf_6 + pf_2;
    pf_4 = pf_5 + pf_4;
    pf_6 = pf_22 * f_1;
    pf_0 = pf_0 + pf_1;
    f_1 = utof(vs_cbuf8[0].x); 
    pf_1 = pf_2 * f_1;
    f_1 = utof(vs_cbuf8[1].x); 
    pf_8 = pf_2 * f_1;
    f_1 = utof(vs_cbuf15[28].x); 
    pf_6 = pf_6 * f_1;
    f_1 = utof(vs_cbuf8[2].x); 
    pf_9 = pf_2 * f_1;
    f_1 = utof(vs_cbuf15[60].w); 
    f_4 = 0. - (pf_4);
    pf_10 = f_4 + f_1;
    f_1 = utof(vs_cbuf8[29].y); 
    f_4 = 0. - (pf_4);
    pf_11 = f_4 + f_1;
    f_1 = utof(vs_cbuf8[0].y); 
    pf_1 = fma(pf_4, f_1, pf_1);
    f_1 = utof(vs_cbuf8[1].y); 
    pf_8 = fma(pf_4, f_1, pf_8);
    pf_12 = pf_3 * 0.5;
    f_1 = utof(vs_cbuf8[3].x); 
    pf_13 = pf_2 * f_1;
    f_1 = utof(vs_cbuf8[0].z); 
    pf_1 = fma(pf_0, f_1, pf_1);
    f_1 = utof(vs_cbuf8[2].y); 
    pf_9 = fma(pf_4, f_1, pf_9);
    f_1 = utof(vs_cbuf8[1].z); 
    pf_8 = fma(pf_0, f_1, pf_8);
    f_1 = utof(vs_cbuf15[28].y); 
    pf_6 = fma(pf_12, f_1, pf_6);
    f_1 = utof(vs_cbuf8[3].y); 
    pf_13 = fma(pf_4, f_1, pf_13);
    f_1 = utof(vs_cbuf8[0].w); 
    pf_1 = pf_1 + f_1;
    f_1 = utof(vs_cbuf8[2].z); 
    pf_9 = fma(pf_0, f_1, pf_9);
    f_1 = utof(vs_cbuf8[1].w); 
    pf_8 = pf_8 + f_1;
    f_1 = utof(vs_cbuf15[28].z); 
    pf_6 = fma(pf_7, f_1, pf_6);
    f_1 = utof(vs_cbuf8[3].z); 
    pf_7 = fma(pf_0, f_1, pf_13);
    f_1 = utof(vs_cbuf8[5].x); 
    pf_13 = pf_1 * f_1;
    f_1 = utof(vs_cbuf8[2].w); 
    pf_9 = pf_9 + f_1;
    f_1 = utof(vs_cbuf8[4].x); 
    pf_14 = pf_1 * f_1;
    pf_6 = fma(pf_6, 0.5, 0.5);
    f_1 = utof(vs_cbuf8[3].w); 
    pf_7 = pf_7 + f_1;
    f_1 = utof(vs_cbuf8[6].x); 
    pf_15 = pf_1 * f_1;
    f_1 = utof(vs_cbuf8[5].y); 
    pf_13 = fma(pf_8, f_1, pf_13);
    f_1 = utof(vs_cbuf8[4].y); 
    pf_14 = fma(pf_8, f_1, pf_14);
    f_1 = utof(vs_cbuf8[7].x); 
    pf_1 = pf_1 * f_1;
    f_1 = 0. - (pf_6);
    pf_16 = f_1 + 1.;
    f_1 = utof(vs_cbuf8[6].y); 
    pf_15 = fma(pf_8, f_1, pf_15);
    f_1 = sqrt(pf_16);
    f_4 = utof(vs_cbuf8[5].z); 
    pf_13 = fma(pf_9, f_4, pf_13);
    f_4 = utof(vs_cbuf8[4].z); 
    pf_14 = fma(pf_9, f_4, pf_14);
    pf_16 = fma(pf_6, -0.0187293, 0.074260995);
    f_4 = utof(vs_cbuf8[7].y); 
    pf_1 = fma(pf_8, f_4, pf_1);
    f_4 = utof(vs_cbuf8[6].z); 
    pf_8 = fma(pf_9, f_4, pf_15);
    f_4 = utof(vs_cbuf8[5].w); 
    pf_13 = fma(pf_7, f_4, pf_13);
    f_4 = utof(vs_cbuf8[4].w); 
    pf_14 = fma(pf_7, f_4, pf_14);
    pf_15 = fma(pf_6, pf_16, -0.2121144);
    f_4 = utof(vs_cbuf8[7].z); 
    pf_1 = fma(pf_9, f_4, pf_1);
    f_4 = utof(vs_cbuf8[29].x); 
    f_5 = 0. - (pf_2);
    pf_9 = f_5 + f_4;
    f_4 = utof(vs_cbuf8[6].w); 
    pf_8 = fma(pf_7, f_4, pf_8);
    f_4 = in_attr0.x;
    pf_16 = 0. * pf_13;
    pf_6 = fma(pf_6, pf_15, 1.5707288);
    f_5 = utof(vs_cbuf8[7].w); 
    pf_1 = fma(pf_7, f_5, pf_1);
    pf_7 = pf_9 * pf_9;
    pf_15 = fma(0., pf_14, pf_16);
    f_1 = 0. - (f_1);
    pf_6 = pf_6 * f_1;
    f_1 = utof(vs_cbuf8[29].z); 
    f_5 = 0. - (pf_0);
    pf_19 = f_5 + f_1;
    pf_20 = fma(pf_10, pf_10, pf_7);
    pf_7 = fma(pf_11, pf_11, pf_7);
    pf_21 = fma(0., pf_8, pf_15);
    pf_20 = fma(pf_19, pf_19, pf_20);

    f_1 = in_attr1.x;

    pf_21 = pf_1 + pf_21;
    f_5 = inversesqrt(pf_20);
    pf_15 = fma(pf_8, 0.5, pf_15);
    f_6 = (1.0) / pf_21;
    pf_7 = fma(pf_19, pf_19, pf_7);
    f_7 = in_attr7.w; 
    f_4 = 0. - (f_4);
    pf_17 = pf_17 + f_4;
    f_4 = inversesqrt(pf_7);
    pf_7 = fma(pf_1, 0.5, pf_15);
    f_8 = in_attr7.y; 
    pf_10 = pf_10 * f_5;
    pf_15 = pf_7 * f_6;
    pf_20 = pf_9 * f_5;
    pf_9 = pf_9 * f_4;
    f_6 = 0. - (pf_18);
    pf_18 = f_6 + f_2;
    pf_11 = pf_11 * f_4;

    out_attr1.y = pf_18; 

    f_2 = utof(vs_cbuf8[30].y); 
    f_6 = utof(vs_cbuf8[30].w); 
    f_2 = 0. - (f_2);
    pf_15 = fma(pf_15, f_6, f_2);
    f_2 = in_attr7.z; 
    f_6 = utof(vs_cbuf15[28].x); 
    pf_20 = pf_20 * f_6;
    f_6 = (1.0) / pf_15;
    f_9 = utof(vs_cbuf15[28].x); 
    pf_9 = pf_9 * f_9;
    pf_15 = pf_19 * f_5;
    pf_17 = pf_17 + f_1;
    pf_19 = pf_19 * f_4;
    f_1 = utof(vs_cbuf15[28].y); 
    pf_20 = fma(pf_10, f_1, pf_20);
    f_1 = utof(vs_cbuf15[28].y); 
    pf_9 = fma(pf_11, f_1, pf_9);
    pf_11 = pf_18 + f_7;
    f_1 = 0. - (pf_17);
    pf_17 = f_1 + 1.;
    f_1 = utof(vs_cbuf15[28].z); 
    pf_15 = fma(pf_15, f_1, pf_20);
    f_1 = utof(vs_cbuf8[30].z); 
    f_1 = 0. - (f_1);
    pf_18 = f_6 * f_1;
    f_1 = utof(vs_cbuf15[28].z); 
    pf_9 = fma(pf_19, f_1, pf_9);
    pf_19 = fma(f_8, 0.4, 0.85);
    f_1 = utof(vs_cbuf15[54].y); 
    pf_11 = pf_11 + f_1;
    pf_20 = fma(pf_15, 0.5, 0.5);
    f_1 = utof(vs_cbuf15[22].y); 
    f_4 = utof(vs_cbuf15[22].x); 
    f_1 = 0. - (f_1);
    pf_23 = fma(pf_18, f_4, f_1);
    f_1 = min(max(pf_23, 0.0), 1.0);
    pf_23 = pf_17 + f_2;
    pf_25 = fma(pf_9, 0.5, 0.5);
    pf_11 = pf_11 * pf_19;
    f_1 = 0. - (f_1);
    pf_19 = f_1 + 1.;
    pf_26 = fma(pf_20, -0.0187293, 0.074260995);
    f_1 = log2(pf_19);
    pf_19 = fma(f_0, 0.3, 1.);
    f_0 = utof(vs_cbuf15[54].x); 
    pf_23 = pf_23 + f_0;
    pf_27 = fma(pf_25, -0.0187293, 0.074260995);
    f_0 = 0. - (pf_20);
    pf_28 = f_0 + 1.;
    pf_6 = fma(pf_6, 0.63661975, 1.);
    f_0 = sqrt(pf_28);
    pf_26 = fma(pf_20, pf_26, -0.2121144);
    pf_19 = pf_23 * pf_19;
    pf_23 = fma(pf_25, pf_27, -0.2121144);
    f_2 = 0. - (pf_25);
    pf_27 = f_2 + 1.;
    f_2 = sqrt(pf_27);
    pf_20 = fma(pf_20, pf_26, 1.5707288);
    f_4 = utof(vs_cbuf15[23].y); 
    pf_26 = f_1 * f_4;
    pf_23 = fma(pf_25, pf_23, 1.5707288);
    pf_25 = pf_3 * 3.3333333;
    f_4 = min(max(pf_25, 0.0), 1.0);
    pf_12 = fma(pf_12, 0.5, 0.5);
    pf_10 = fma(pf_10, -0.5, 0.5);
    f_0 = 0. - (f_0);
    pf_20 = pf_20 * f_0;
    f_0 = exp2(pf_26);
    f_4 = max(f_4, 0.5);
    f_2 = 0. - (f_2);
    pf_23 = pf_23 * f_2;
    pf_20 = fma(pf_20, 0.63661975, 1.);
    pf_25 = fma(f_4, -0.1, 0.68);
    f2_0 = vec2(0.5, pf_25);
    f4_0 = textureLod(tex2, f2_0, 0.0);
    f_2 = f4_0.x;
    f_5 = f4_0.y;
    f_6 = f4_0.z;
    f2_0 = vec2(pf_6, pf_12);
    f4_0 = textureLod(tex2, f2_0, 0.0);
    f_7 = f4_0.x;
    f_8 = f4_0.y;
    f_9 = f4_0.z;
    f2_0 = vec2(pf_20, pf_10);
    f4_0 = textureLod(tex2, f2_0, 0.0);
    f_10 = f4_0.x;
    f_11 = f4_0.y;
    f_12 = f4_0.z;
    pf_6 = fma(pf_23, 0.63661975, 1.);
    pf_10 = fma(f_0, 0.5, 0.5);
    f2_0 = vec2(pf_6, pf_10);
    f4_0 = textureLod(tex1, f2_0, 0.0);
    f_0 = f4_0.x;
    f_13 = f4_0.y;
    f_14 = f4_0.z;
    pf_6 = pf_24 * pf_24;

    out_attr1.w = pf_11; 

    f_15 = utof(vs_cbuf15[60].y); 
    f_15 = 0. - (f_15);
    pf_10 = pf_15 + f_15;

    out_attr4.z = pf_0; 

    f_15 = utof(vs_cbuf15[22].y); 
    f_16 = utof(vs_cbuf15[22].x); 
    f_15 = 0. - (f_15);
    pf_0 = fma(f_3, f_16, f_15);
    f_15 = min(max(pf_0, 0.0), 1.0);

    out_attr1.x = pf_17; 

    pf_0 = fma(pf_22, pf_22, pf_6);

    out_attr4.x = pf_2; 

    f_16 = 0. - (0.5);
    pf_2 = fma(f_3, 0.001, f_16);
    f_16 = min(max(pf_2, 0.0), 1.0);
    f_17 = sqrt(pf_0);
    f_18 = utof(vs_cbuf15[60].z); 
    pf_0 = pf_10 * f_18;
    f_18 = min(max(pf_0, 0.0), 1.0);
    gl_Position.x = pf_14;

    out_attr4.y = pf_4; 

    f_15 = 0. - (f_15);
    pf_0 = f_15 + 1.;
    f_15 = utof(vs_cbuf15[54].w); 
    f_15 = (1.0) / f_15;
    f_19 = log2(pf_0);
    pf_0 = fma(pf_14, 0.5, pf_16);

    out_attr1.z = pf_19; 

    pf_2 = pf_13 * -0.5;
    gl_Position.y = pf_13;
    f_20 = 0. - (1.);
    pf_4 = fma(f_17, 0.006666667, f_20);
    f_17 = min(max(pf_4, 0.0), 1.0);
    gl_Position.z = pf_8;
    f_20 = utof(vs_cbuf15[54].z); 
    f_20 = 0. - (f_20);
    pf_4 = f_3 + f_20;

    out_attr8.z = f_17; 

    f_17 = utof(vs_cbuf15[23].x); 
    pf_6 = f_19 * f_17;
    gl_Position.w = pf_1;
    f_17 = utof(vs_cbuf15[24].y); 
    f_19 = utof(vs_cbuf15[24].x); 
    f_17 = 0. - (f_17);
    pf_10 = fma(f_3, f_19, f_17);
    f_17 = min(max(pf_10, 0.0), 1.0);

    out_attr2.z = pf_7; 

    f_19 = utof(vs_cbuf15[60].w); 
    f_19 = 0. - (f_19);
    pf_7 = pf_5 + f_19;

    out_attr2.w = pf_21; 

    pf_4 = pf_4 * f_15;

    out_attr8.x = f_4; 

    pf_10 = f_18 * f_16;
    pf_7 = pf_7 * 0.1;
    f_15 = min(max(pf_7, 0.0), 1.0);
    f_16 = utof(vs_cbuf15[54].w); 
    f_16 = 0. - (f_16);
    pf_7 = f_3 + f_16;
    f_3 = utof(vs_cbuf15[57].z); 
    f_3 = (1.0) / f_3;
    f_16 = 0. - (f_17);
    pf_11 = f_16 + 1.;
    f_16 = utof(vs_cbuf15[23].x); 
    pf_12 = f_1 * f_16;
    f_1 = log2(pf_11);
    pf_10 = pf_10 * f_15;
    pf_0 = fma(0., pf_8, pf_0);
    pf_2 = fma(0., pf_14, pf_2);
    f_15 = utof(vs_cbuf15[60].x); 
    pf_10 = pf_10 * f_15;
    f_15 = exp2(pf_12);
    pf_0 = fma(pf_1, 0.5, pf_0);
    f_16 = exp2(pf_6);
    pf_6 = pf_7 * f_3;
    f_3 = min(max(pf_6, 0.0), 1.0);

    out_attr2.x = pf_0; 

    f_17 = utof(vs_cbuf15[1].x); 
    f_17 = 0. - (f_17);
    pf_0 = fma(pf_10, f_17, pf_10);
    pf_3 = pf_3 * 2.;
    f_17 = min(max(pf_3, 0.0), 1.0);

    out_attr10.w = pf_0; 

    f_18 = utof(vs_cbuf15[24].w); 
    pf_0 = f_1 * f_18;
    f_1 = utof(vs_cbuf15[23].z); 
    f_18 = utof(vs_cbuf15[23].z); 
    f_18 = 0. - (f_18);
    pf_3 = fma(f_15, f_18, f_1);
    f_1 = min(max(pf_3, 0.0), 1.0);
    f_15 = utof(vs_cbuf15[23].z); 
    f_18 = utof(vs_cbuf15[23].z); 
    f_18 = 0. - (f_18);
    pf_3 = fma(f_16, f_18, f_15);
    f_15 = min(max(pf_3, 0.0), 1.0);
    f_16 = utof(vs_cbuf15[60].y); 
    f_16 = 0. - (f_16);
    pf_3 = pf_9 + f_16;
    pf_6 = f_17 * f_3;
    f_3 = utof(vs_cbuf15[28].y); 
    pf_7 = pf_18 + f_3;
    pf_2 = fma(0., pf_8, pf_2);
    f_3 = exp2(pf_0);
    f_16 = utof(vs_cbuf15[60].z); 
    pf_0 = pf_3 * f_16;
    f_16 = min(max(pf_0, 0.0), 1.0);
    f_17 = utof(vs_cbuf15[55].w); 
    f_17 = min(pf_4, f_17);
    pf_0 = fma(pf_1, 0.5, pf_2);
    pf_1 = f_16 * f_1;

    out_attr2.y = pf_0; 

    f_1 = max(0., f_17);
    f_16 = utof(vs_cbuf15[25].w); 
    f_17 = utof(vs_cbuf15[25].w); 
    f_17 = 0. - (f_17);
    pf_0 = fma(f_3, f_17, f_16);

    out_attr7.x = pf_0; 

    f_3 = utof(vs_cbuf15[27].z); 
    f_16 = utof(vs_cbuf8[29].y); 
    f_3 = min(f_16, f_3);
    pf_0 = f_15 * f_1;
    f_15 = 0. - (f_1);
    pf_2 = fma(f_4, f_15, f_1);
    f_1 = utof(vs_cbuf15[1].x); 
    f_1 = 0. - (f_1);
    pf_1 = fma(pf_1, f_1, pf_1);
    f_1 = 0. - (pf_5);
    pf_3 = f_1 + f_3;
    f_1 = min(f_4, pf_0);
    f_3 = utof(vs_cbuf15[61].x); 
    pf_0 = pf_1 * f_3;
    f_3 = utof(vs_cbuf15[27].x); 
    f_4 = utof(vs_cbuf15[27].y); 
    pf_1 = fma(pf_3, f_4, f_3);
    f_3 = min(max(pf_1, 0.0), 1.0);

    out_attr11.w = pf_0; 

    f_4 = utof(vs_cbuf15[28].y); 
    pf_0 = fma(f_4, 1.5, 1.5);
    f_4 = min(max(pf_0, 0.0), 1.0);
    f_4 = (1.0) / f_4;
    f_15 = utof(vs_cbuf15[26].w); 
    pf_0 = f_3 * f_15;

    out_attr7.y = pf_0; 

    pf_0 = pf_7 * f_4;
    pf_0 = pf_0 * 0.06666667;
    pf_1 = f_5 * 0.72;

    out_attr10.x = f_10; 

    f_3 = utof(vs_cbuf15[55].y); 
    f_3 = 0. - (f_3);
    pf_3 = f_8 + f_3;

    out_attr10.y = f_11; 

    f_3 = utof(vs_cbuf15[55].x); 
    f_3 = 0. - (f_3);
    pf_4 = f_7 + f_3;

    out_attr10.z = f_12; 

    pf_1 = fma(f_2, 0.22, pf_1);
    f_3 = utof(vs_cbuf15[55].y); 
    pf_3 = fma(pf_3, pf_6, f_3);
    f_3 = utof(vs_cbuf15[55].x); 
    pf_4 = fma(pf_4, pf_6, f_3);
    pf_1 = fma(f_6, 0.06, pf_1);
    pf_3 = pf_3 * f_1;
    pf_4 = pf_4 * f_1;
    f_3 = max(pf_1, 1.);
    f_4 = abs(f_3);
    f_4 = log2(f_4);
    f_3 = (1.0) / f_3;
    f_7 = utof(vs_cbuf15[55].z); 
    f_7 = 0. - (f_7);
    pf_1 = f_9 + f_7;
    pf_5 = f_4 * 0.7;
    pf_2 = pf_2 * f_3;
    f_3 = utof(vs_cbuf15[55].z); 
    pf_1 = fma(pf_1, pf_6, f_3);
    f_3 = utof(vs_cbuf10[3].x); 

    out_attr3.x = f_3; 

    f_3 = 0. - (f_1);
    f_4 = 0. - (pf_2);
    pf_6 = f_3 + f_4;
    f_3 = exp2(pf_5);
    pf_1 = pf_1 * f_1;
    pf_5 = pf_6 + 1.;
    f_1 = (1.0) / f_3;

    out_attr9.w = pf_5; 

    pf_5 = f_5 * f_1;
    pf_6 = f_2 * f_1;
    pf_7 = f_6 * f_1;
    pf_3 = fma(pf_5, pf_2, pf_3);
    f_1 = max(pf_0, 0.2);

    out_attr9.y = pf_3; 

    pf_0 = fma(pf_6, pf_2, pf_4);
    pf_1 = fma(pf_7, pf_2, pf_1);

    out_attr9.x = pf_0; 

    f_2 = 0. - (0.);
    pf_0 = f_1 + f_2;
    f_1 = min(max(pf_0, 0.0), 1.0);

    out_attr9.z = pf_1; 

    pf_0 = f_0 * f_1;
    pf_1 = f_13 * f_1;

    out_attr11.x = pf_0; 

    pf_0 = f_14 * f_1;

    out_attr11.y = pf_1; 

    out_attr11.z = pf_0; 
    return;
}