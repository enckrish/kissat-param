//Compilation time: 2020-12-21 20:54:37
//Compilation SHA256 message digest: a3b96163f4df0c250d004b4f2251d595f41e522f2c4c62c3e7bbdda690c221f0
/*----------------------------------------------------------------------------
Copyright (c) 2019-2020 University of Bremen, Germany.
Copyright (c) 2020 Johannes Kepler University Linz, Austria.
This file has been generated with GenMul.
You can find GenMul at: http://www.sca-verification.org/genmul
Contact us at genmul@sca-verification.org

  First input length: 12
  second input length: 12
  Partial product generator: Unsigned simple partial product generator [U_SP]
  Partial product accumulator: Array [AR]
  Final stage adder: Ripple carry adder [RC]
----------------------------------------------------------------------------*/
module FullAdder(X, Y, Z, S, C);
  output C;
  output S;
  input X;
  input Y;
  input Z;
  assign C = ( X & Y ) | ( Y & Z ) | ( Z & X );
  assign S = X ^ Y ^ Z;
endmodule
module FullAdderProp(X, Y, Z, S, C, P);
  output C;
  output S;
  output P;
  input X;
  input Y;
  input Z;
  assign C = ( X & Y ) | ( Y & Z ) | ( Z & X );
  assign S = X ^ Y ^ Z;
  assign P = X ^ Y;
endmodule
module HalfAdder(X, Y, S, C);
  output C;
  output S;
  input X;
  input Y;
  assign C = X & Y;
  assign S = X ^ Y;
endmodule
module ConstatntOne(O);
  output O;
  assign O = 1;
endmodule
module Counter(X1, X2, X3, X4, X5, X6, X7, S3, S2, S1);
output S1;
output S2;
output S3;
input X1;
input X2;
input X3;
input X4;
input X5;
input X6;
input X7;
wire W1;
wire W2;
wire W3;
wire W4;
wire W5;
wire W6;
assign W1 = X1 ^ X2 ^ X3;
assign W2 = X4 ^ X5 ^ ( X6 ^ X7 );
assign W3 = ~ ( ( ~ ( X1 & X2 ) ) & ( ~ ( X1 & X3 ) ) & ( ~ ( X2 & X3 ) ) );
assign W4 = ~ ( ( ~ ( ( X4 | X5 ) & ( X6 | X7 ) ) ) & ( ~ ( ( X4 & X5 ) | ( X6 & X7 ) ) ) );
assign W5 = ~ ( X4 & X5 & X6 & X7 );
assign W6 = ~ ( ( ~ ( W4 & W5 ) ) ^ W3 );
assign S3 = W1 ^ W2;
assign S2 = ~ ( W6 ^ ( ~ ( W1 & W2 ) ) );
assign S1 = ~ ( W5 & ( ~ ( W3 & W4 ) ) & ( ~ ( W1 & W2 & W6 ) ) );
endmodule
module U_SP_12_12(IN1, IN2 , P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16, P17, P18, P19, P20, P21, P22);
  input [11:0] IN1;
  input [11:0] IN2;
  output [0:0] P0;
  output [1:0] P1;
  output [2:0] P2;
  output [3:0] P3;
  output [4:0] P4;
  output [5:0] P5;
  output [6:0] P6;
  output [7:0] P7;
  output [8:0] P8;
  output [9:0] P9;
  output [10:0] P10;
  output [11:0] P11;
  output [10:0] P12;
  output [9:0] P13;
  output [8:0] P14;
  output [7:0] P15;
  output [6:0] P16;
  output [5:0] P17;
  output [4:0] P18;
  output [3:0] P19;
  output [2:0] P20;
  output [1:0] P21;
  output [0:0] P22;
  assign P0[0] = IN1[0]&IN2[0];
  assign P1[0] = IN1[0]&IN2[1];
  assign P2[0] = IN1[0]&IN2[2];
  assign P3[0] = IN1[0]&IN2[3];
  assign P4[0] = IN1[0]&IN2[4];
  assign P5[0] = IN1[0]&IN2[5];
  assign P6[0] = IN1[0]&IN2[6];
  assign P7[0] = IN1[0]&IN2[7];
  assign P8[0] = IN1[0]&IN2[8];
  assign P9[0] = IN1[0]&IN2[9];
  assign P10[0] = IN1[0]&IN2[10];
  assign P11[0] = IN1[0]&IN2[11];
  assign P1[1] = IN1[1]&IN2[0];
  assign P2[1] = IN1[1]&IN2[1];
  assign P3[1] = IN1[1]&IN2[2];
  assign P4[1] = IN1[1]&IN2[3];
  assign P5[1] = IN1[1]&IN2[4];
  assign P6[1] = IN1[1]&IN2[5];
  assign P7[1] = IN1[1]&IN2[6];
  assign P8[1] = IN1[1]&IN2[7];
  assign P9[1] = IN1[1]&IN2[8];
  assign P10[1] = IN1[1]&IN2[9];
  assign P11[1] = IN1[1]&IN2[10];
  assign P12[0] = IN1[1]&IN2[11];
  assign P2[2] = IN1[2]&IN2[0];
  assign P3[2] = IN1[2]&IN2[1];
  assign P4[2] = IN1[2]&IN2[2];
  assign P5[2] = IN1[2]&IN2[3];
  assign P6[2] = IN1[2]&IN2[4];
  assign P7[2] = IN1[2]&IN2[5];
  assign P8[2] = IN1[2]&IN2[6];
  assign P9[2] = IN1[2]&IN2[7];
  assign P10[2] = IN1[2]&IN2[8];
  assign P11[2] = IN1[2]&IN2[9];
  assign P12[1] = IN1[2]&IN2[10];
  assign P13[0] = IN1[2]&IN2[11];
  assign P3[3] = IN1[3]&IN2[0];
  assign P4[3] = IN1[3]&IN2[1];
  assign P5[3] = IN1[3]&IN2[2];
  assign P6[3] = IN1[3]&IN2[3];
  assign P7[3] = IN1[3]&IN2[4];
  assign P8[3] = IN1[3]&IN2[5];
  assign P9[3] = IN1[3]&IN2[6];
  assign P10[3] = IN1[3]&IN2[7];
  assign P11[3] = IN1[3]&IN2[8];
  assign P12[2] = IN1[3]&IN2[9];
  assign P13[1] = IN1[3]&IN2[10];
  assign P14[0] = IN1[3]&IN2[11];
  assign P4[4] = IN1[4]&IN2[0];
  assign P5[4] = IN1[4]&IN2[1];
  assign P6[4] = IN1[4]&IN2[2];
  assign P7[4] = IN1[4]&IN2[3];
  assign P8[4] = IN1[4]&IN2[4];
  assign P9[4] = IN1[4]&IN2[5];
  assign P10[4] = IN1[4]&IN2[6];
  assign P11[4] = IN1[4]&IN2[7];
  assign P12[3] = IN1[4]&IN2[8];
  assign P13[2] = IN1[4]&IN2[9];
  assign P14[1] = IN1[4]&IN2[10];
  assign P15[0] = IN1[4]&IN2[11];
  assign P5[5] = IN1[5]&IN2[0];
  assign P6[5] = IN1[5]&IN2[1];
  assign P7[5] = IN1[5]&IN2[2];
  assign P8[5] = IN1[5]&IN2[3];
  assign P9[5] = IN1[5]&IN2[4];
  assign P10[5] = IN1[5]&IN2[5];
  assign P11[5] = IN1[5]&IN2[6];
  assign P12[4] = IN1[5]&IN2[7];
  assign P13[3] = IN1[5]&IN2[8];
  assign P14[2] = IN1[5]&IN2[9];
  assign P15[1] = IN1[5]&IN2[10];
  assign P16[0] = IN1[5]&IN2[11];
  assign P6[6] = IN1[6]&IN2[0];
  assign P7[6] = IN1[6]&IN2[1];
  assign P8[6] = IN1[6]&IN2[2];
  assign P9[6] = IN1[6]&IN2[3];
  assign P10[6] = IN1[6]&IN2[4];
  assign P11[6] = IN1[6]&IN2[5];
  assign P12[5] = IN1[6]&IN2[6];
  assign P13[4] = IN1[6]&IN2[7];
  assign P14[3] = IN1[6]&IN2[8];
  assign P15[2] = IN1[6]&IN2[9];
  assign P16[1] = IN1[6]&IN2[10];
  assign P17[0] = IN1[6]&IN2[11];
  assign P7[7] = IN1[7]&IN2[0];
  assign P8[7] = IN1[7]&IN2[1];
  assign P9[7] = IN1[7]&IN2[2];
  assign P10[7] = IN1[7]&IN2[3];
  assign P11[7] = IN1[7]&IN2[4];
  assign P12[6] = IN1[7]&IN2[5];
  assign P13[5] = IN1[7]&IN2[6];
  assign P14[4] = IN1[7]&IN2[7];
  assign P15[3] = IN1[7]&IN2[8];
  assign P16[2] = IN1[7]&IN2[9];
  assign P17[1] = IN1[7]&IN2[10];
  assign P18[0] = IN1[7]&IN2[11];
  assign P8[8] = IN1[8]&IN2[0];
  assign P9[8] = IN1[8]&IN2[1];
  assign P10[8] = IN1[8]&IN2[2];
  assign P11[8] = IN1[8]&IN2[3];
  assign P12[7] = IN1[8]&IN2[4];
  assign P13[6] = IN1[8]&IN2[5];
  assign P14[5] = IN1[8]&IN2[6];
  assign P15[4] = IN1[8]&IN2[7];
  assign P16[3] = IN1[8]&IN2[8];
  assign P17[2] = IN1[8]&IN2[9];
  assign P18[1] = IN1[8]&IN2[10];
  assign P19[0] = IN1[8]&IN2[11];
  assign P9[9] = IN1[9]&IN2[0];
  assign P10[9] = IN1[9]&IN2[1];
  assign P11[9] = IN1[9]&IN2[2];
  assign P12[8] = IN1[9]&IN2[3];
  assign P13[7] = IN1[9]&IN2[4];
  assign P14[6] = IN1[9]&IN2[5];
  assign P15[5] = IN1[9]&IN2[6];
  assign P16[4] = IN1[9]&IN2[7];
  assign P17[3] = IN1[9]&IN2[8];
  assign P18[2] = IN1[9]&IN2[9];
  assign P19[1] = IN1[9]&IN2[10];
  assign P20[0] = IN1[9]&IN2[11];
  assign P10[10] = IN1[10]&IN2[0];
  assign P11[10] = IN1[10]&IN2[1];
  assign P12[9] = IN1[10]&IN2[2];
  assign P13[8] = IN1[10]&IN2[3];
  assign P14[7] = IN1[10]&IN2[4];
  assign P15[6] = IN1[10]&IN2[5];
  assign P16[5] = IN1[10]&IN2[6];
  assign P17[4] = IN1[10]&IN2[7];
  assign P18[3] = IN1[10]&IN2[8];
  assign P19[2] = IN1[10]&IN2[9];
  assign P20[1] = IN1[10]&IN2[10];
  assign P21[0] = IN1[10]&IN2[11];
  assign P11[11] = IN1[11]&IN2[0];
  assign P12[10] = IN1[11]&IN2[1];
  assign P13[9] = IN1[11]&IN2[2];
  assign P14[8] = IN1[11]&IN2[3];
  assign P15[7] = IN1[11]&IN2[4];
  assign P16[6] = IN1[11]&IN2[5];
  assign P17[5] = IN1[11]&IN2[6];
  assign P18[4] = IN1[11]&IN2[7];
  assign P19[3] = IN1[11]&IN2[8];
  assign P20[2] = IN1[11]&IN2[9];
  assign P21[1] = IN1[11]&IN2[10];
  assign P22[0] = IN1[11]&IN2[11];

endmodule
module AR(IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15, IN16, IN17, IN18, IN19, IN20, IN21, IN22, Out1, Out2);
  input [0:0] IN0;
  input [1:0] IN1;
  input [2:0] IN2;
  input [3:0] IN3;
  input [4:0] IN4;
  input [5:0] IN5;
  input [6:0] IN6;
  input [7:0] IN7;
  input [8:0] IN8;
  input [9:0] IN9;
  input [10:0] IN10;
  input [11:0] IN11;
  input [10:0] IN12;
  input [9:0] IN13;
  input [8:0] IN14;
  input [7:0] IN15;
  input [6:0] IN16;
  input [5:0] IN17;
  input [4:0] IN18;
  input [3:0] IN19;
  input [2:0] IN20;
  input [1:0] IN21;
  input [0:0] IN22;
  output [22:0] Out1;
  output [10:0] Out2;
  wire w145;
  wire w146;
  wire w147;
  wire w148;
  wire w149;
  wire w150;
  wire w151;
  wire w152;
  wire w153;
  wire w154;
  wire w155;
  wire w156;
  wire w157;
  wire w158;
  wire w159;
  wire w160;
  wire w161;
  wire w162;
  wire w163;
  wire w164;
  wire w165;
  wire w167;
  wire w168;
  wire w169;
  wire w170;
  wire w171;
  wire w172;
  wire w173;
  wire w174;
  wire w175;
  wire w176;
  wire w177;
  wire w178;
  wire w179;
  wire w180;
  wire w181;
  wire w182;
  wire w183;
  wire w184;
  wire w185;
  wire w186;
  wire w187;
  wire w189;
  wire w190;
  wire w191;
  wire w192;
  wire w193;
  wire w194;
  wire w195;
  wire w196;
  wire w197;
  wire w198;
  wire w199;
  wire w200;
  wire w201;
  wire w202;
  wire w203;
  wire w204;
  wire w205;
  wire w206;
  wire w207;
  wire w208;
  wire w209;
  wire w211;
  wire w212;
  wire w213;
  wire w214;
  wire w215;
  wire w216;
  wire w217;
  wire w218;
  wire w219;
  wire w220;
  wire w221;
  wire w222;
  wire w223;
  wire w224;
  wire w225;
  wire w226;
  wire w227;
  wire w228;
  wire w229;
  wire w230;
  wire w231;
  wire w233;
  wire w234;
  wire w235;
  wire w236;
  wire w237;
  wire w238;
  wire w239;
  wire w240;
  wire w241;
  wire w242;
  wire w243;
  wire w244;
  wire w245;
  wire w246;
  wire w247;
  wire w248;
  wire w249;
  wire w250;
  wire w251;
  wire w252;
  wire w253;
  wire w255;
  wire w256;
  wire w257;
  wire w258;
  wire w259;
  wire w260;
  wire w261;
  wire w262;
  wire w263;
  wire w264;
  wire w265;
  wire w266;
  wire w267;
  wire w268;
  wire w269;
  wire w270;
  wire w271;
  wire w272;
  wire w273;
  wire w274;
  wire w275;
  wire w277;
  wire w278;
  wire w279;
  wire w280;
  wire w281;
  wire w282;
  wire w283;
  wire w284;
  wire w285;
  wire w286;
  wire w287;
  wire w288;
  wire w289;
  wire w290;
  wire w291;
  wire w292;
  wire w293;
  wire w294;
  wire w295;
  wire w296;
  wire w297;
  wire w299;
  wire w300;
  wire w301;
  wire w302;
  wire w303;
  wire w304;
  wire w305;
  wire w306;
  wire w307;
  wire w308;
  wire w309;
  wire w310;
  wire w311;
  wire w312;
  wire w313;
  wire w314;
  wire w315;
  wire w316;
  wire w317;
  wire w318;
  wire w319;
  wire w321;
  wire w322;
  wire w323;
  wire w324;
  wire w325;
  wire w326;
  wire w327;
  wire w328;
  wire w329;
  wire w330;
  wire w331;
  wire w332;
  wire w333;
  wire w334;
  wire w335;
  wire w336;
  wire w337;
  wire w338;
  wire w339;
  wire w340;
  wire w341;
  wire w343;
  wire w344;
  wire w345;
  wire w346;
  wire w347;
  wire w348;
  wire w349;
  wire w350;
  wire w351;
  wire w352;
  wire w353;
  wire w354;
  wire w355;
  wire w356;
  wire w357;
  wire w358;
  wire w359;
  wire w360;
  wire w361;
  wire w362;
  wire w363;
  wire w365;
  wire w367;
  wire w369;
  wire w371;
  wire w373;
  wire w375;
  wire w377;
  wire w379;
  wire w381;
  wire w383;
  HalfAdder U0 (IN1[0], IN1[1], Out1[1], w145);
  FullAdder U1 (w145, IN2[0], IN2[1], w146, w147);
  FullAdder U2 (w147, IN3[0], IN3[1], w148, w149);
  FullAdder U3 (w149, IN4[0], IN4[1], w150, w151);
  FullAdder U4 (w151, IN5[0], IN5[1], w152, w153);
  FullAdder U5 (w153, IN6[0], IN6[1], w154, w155);
  FullAdder U6 (w155, IN7[0], IN7[1], w156, w157);
  FullAdder U7 (w157, IN8[0], IN8[1], w158, w159);
  FullAdder U8 (w159, IN9[0], IN9[1], w160, w161);
  FullAdder U9 (w161, IN10[0], IN10[1], w162, w163);
  FullAdder U10 (w163, IN11[0], IN11[1], w164, w165);
  HalfAdder U11 (w146, IN2[2], Out1[2], w167);
  FullAdder U12 (w167, w148, IN3[2], w168, w169);
  FullAdder U13 (w169, w150, IN4[2], w170, w171);
  FullAdder U14 (w171, w152, IN5[2], w172, w173);
  FullAdder U15 (w173, w154, IN6[2], w174, w175);
  FullAdder U16 (w175, w156, IN7[2], w176, w177);
  FullAdder U17 (w177, w158, IN8[2], w178, w179);
  FullAdder U18 (w179, w160, IN9[2], w180, w181);
  FullAdder U19 (w181, w162, IN10[2], w182, w183);
  FullAdder U20 (w183, w164, IN11[2], w184, w185);
  FullAdder U21 (w185, w165, IN12[0], w186, w187);
  HalfAdder U22 (w168, IN3[3], Out1[3], w189);
  FullAdder U23 (w189, w170, IN4[3], w190, w191);
  FullAdder U24 (w191, w172, IN5[3], w192, w193);
  FullAdder U25 (w193, w174, IN6[3], w194, w195);
  FullAdder U26 (w195, w176, IN7[3], w196, w197);
  FullAdder U27 (w197, w178, IN8[3], w198, w199);
  FullAdder U28 (w199, w180, IN9[3], w200, w201);
  FullAdder U29 (w201, w182, IN10[3], w202, w203);
  FullAdder U30 (w203, w184, IN11[3], w204, w205);
  FullAdder U31 (w205, w186, IN12[1], w206, w207);
  FullAdder U32 (w207, w187, IN13[0], w208, w209);
  HalfAdder U33 (w190, IN4[4], Out1[4], w211);
  FullAdder U34 (w211, w192, IN5[4], w212, w213);
  FullAdder U35 (w213, w194, IN6[4], w214, w215);
  FullAdder U36 (w215, w196, IN7[4], w216, w217);
  FullAdder U37 (w217, w198, IN8[4], w218, w219);
  FullAdder U38 (w219, w200, IN9[4], w220, w221);
  FullAdder U39 (w221, w202, IN10[4], w222, w223);
  FullAdder U40 (w223, w204, IN11[4], w224, w225);
  FullAdder U41 (w225, w206, IN12[2], w226, w227);
  FullAdder U42 (w227, w208, IN13[1], w228, w229);
  FullAdder U43 (w229, w209, IN14[0], w230, w231);
  HalfAdder U44 (w212, IN5[5], Out1[5], w233);
  FullAdder U45 (w233, w214, IN6[5], w234, w235);
  FullAdder U46 (w235, w216, IN7[5], w236, w237);
  FullAdder U47 (w237, w218, IN8[5], w238, w239);
  FullAdder U48 (w239, w220, IN9[5], w240, w241);
  FullAdder U49 (w241, w222, IN10[5], w242, w243);
  FullAdder U50 (w243, w224, IN11[5], w244, w245);
  FullAdder U51 (w245, w226, IN12[3], w246, w247);
  FullAdder U52 (w247, w228, IN13[2], w248, w249);
  FullAdder U53 (w249, w230, IN14[1], w250, w251);
  FullAdder U54 (w251, w231, IN15[0], w252, w253);
  HalfAdder U55 (w234, IN6[6], Out1[6], w255);
  FullAdder U56 (w255, w236, IN7[6], w256, w257);
  FullAdder U57 (w257, w238, IN8[6], w258, w259);
  FullAdder U58 (w259, w240, IN9[6], w260, w261);
  FullAdder U59 (w261, w242, IN10[6], w262, w263);
  FullAdder U60 (w263, w244, IN11[6], w264, w265);
  FullAdder U61 (w265, w246, IN12[4], w266, w267);
  FullAdder U62 (w267, w248, IN13[3], w268, w269);
  FullAdder U63 (w269, w250, IN14[2], w270, w271);
  FullAdder U64 (w271, w252, IN15[1], w272, w273);
  FullAdder U65 (w273, w253, IN16[0], w274, w275);
  HalfAdder U66 (w256, IN7[7], Out1[7], w277);
  FullAdder U67 (w277, w258, IN8[7], w278, w279);
  FullAdder U68 (w279, w260, IN9[7], w280, w281);
  FullAdder U69 (w281, w262, IN10[7], w282, w283);
  FullAdder U70 (w283, w264, IN11[7], w284, w285);
  FullAdder U71 (w285, w266, IN12[5], w286, w287);
  FullAdder U72 (w287, w268, IN13[4], w288, w289);
  FullAdder U73 (w289, w270, IN14[3], w290, w291);
  FullAdder U74 (w291, w272, IN15[2], w292, w293);
  FullAdder U75 (w293, w274, IN16[1], w294, w295);
  FullAdder U76 (w295, w275, IN17[0], w296, w297);
  HalfAdder U77 (w278, IN8[8], Out1[8], w299);
  FullAdder U78 (w299, w280, IN9[8], w300, w301);
  FullAdder U79 (w301, w282, IN10[8], w302, w303);
  FullAdder U80 (w303, w284, IN11[8], w304, w305);
  FullAdder U81 (w305, w286, IN12[6], w306, w307);
  FullAdder U82 (w307, w288, IN13[5], w308, w309);
  FullAdder U83 (w309, w290, IN14[4], w310, w311);
  FullAdder U84 (w311, w292, IN15[3], w312, w313);
  FullAdder U85 (w313, w294, IN16[2], w314, w315);
  FullAdder U86 (w315, w296, IN17[1], w316, w317);
  FullAdder U87 (w317, w297, IN18[0], w318, w319);
  HalfAdder U88 (w300, IN9[9], Out1[9], w321);
  FullAdder U89 (w321, w302, IN10[9], w322, w323);
  FullAdder U90 (w323, w304, IN11[9], w324, w325);
  FullAdder U91 (w325, w306, IN12[7], w326, w327);
  FullAdder U92 (w327, w308, IN13[6], w328, w329);
  FullAdder U93 (w329, w310, IN14[5], w330, w331);
  FullAdder U94 (w331, w312, IN15[4], w332, w333);
  FullAdder U95 (w333, w314, IN16[3], w334, w335);
  FullAdder U96 (w335, w316, IN17[2], w336, w337);
  FullAdder U97 (w337, w318, IN18[1], w338, w339);
  FullAdder U98 (w339, w319, IN19[0], w340, w341);
  HalfAdder U99 (w322, IN10[10], Out1[10], w343);
  FullAdder U100 (w343, w324, IN11[10], w344, w345);
  FullAdder U101 (w345, w326, IN12[8], w346, w347);
  FullAdder U102 (w347, w328, IN13[7], w348, w349);
  FullAdder U103 (w349, w330, IN14[6], w350, w351);
  FullAdder U104 (w351, w332, IN15[5], w352, w353);
  FullAdder U105 (w353, w334, IN16[4], w354, w355);
  FullAdder U106 (w355, w336, IN17[3], w356, w357);
  FullAdder U107 (w357, w338, IN18[2], w358, w359);
  FullAdder U108 (w359, w340, IN19[1], w360, w361);
  FullAdder U109 (w361, w341, IN20[0], w362, w363);
  HalfAdder U110 (w344, IN11[11], Out1[11], w365);
  FullAdder U111 (w365, w346, IN12[9], Out1[12], w367);
  FullAdder U112 (w367, w348, IN13[8], Out1[13], w369);
  FullAdder U113 (w369, w350, IN14[7], Out1[14], w371);
  FullAdder U114 (w371, w352, IN15[6], Out1[15], w373);
  FullAdder U115 (w373, w354, IN16[5], Out1[16], w375);
  FullAdder U116 (w375, w356, IN17[4], Out1[17], w377);
  FullAdder U117 (w377, w358, IN18[3], Out1[18], w379);
  FullAdder U118 (w379, w360, IN19[2], Out1[19], w381);
  FullAdder U119 (w381, w362, IN20[1], Out1[20], w383);
  FullAdder U120 (w383, w363, IN21[0], Out1[21], Out1[22]);
  assign Out1[0] = IN0[0];
  assign Out2[0] = IN12[10];
  assign Out2[1] = IN13[9];
  assign Out2[2] = IN14[8];
  assign Out2[3] = IN15[7];
  assign Out2[4] = IN16[6];
  assign Out2[5] = IN17[5];
  assign Out2[6] = IN18[4];
  assign Out2[7] = IN19[3];
  assign Out2[8] = IN20[2];
  assign Out2[9] = IN21[1];
  assign Out2[10] = IN22[0];

endmodule
module RC_11_11(IN1, IN2, Out);
  input [10:0] IN1;
  input [10:0] IN2;
  output [11:0] Out;
  wire w23;
  wire w25;
  wire w27;
  wire w29;
  wire w31;
  wire w33;
  wire w35;
  wire w37;
  wire w39;
  wire w41;
  HalfAdder U0 (IN1[0], IN2[0], Out[0], w23);
  FullAdder U1 (IN1[1], IN2[1], w23, Out[1], w25);
  FullAdder U2 (IN1[2], IN2[2], w25, Out[2], w27);
  FullAdder U3 (IN1[3], IN2[3], w27, Out[3], w29);
  FullAdder U4 (IN1[4], IN2[4], w29, Out[4], w31);
  FullAdder U5 (IN1[5], IN2[5], w31, Out[5], w33);
  FullAdder U6 (IN1[6], IN2[6], w33, Out[6], w35);
  FullAdder U7 (IN1[7], IN2[7], w35, Out[7], w37);
  FullAdder U8 (IN1[8], IN2[8], w37, Out[8], w39);
  FullAdder U9 (IN1[9], IN2[9], w39, Out[9], w41);
  FullAdder U10 (IN1[10], IN2[10], w41, Out[10], Out[11]);

endmodule
module Mult_12_12(IN1, IN2, Out);
  input [11:0] IN1;
  input [11:0] IN2;
  output [23:0] Out;
  wire [0:0] P0;
  wire [1:0] P1;
  wire [2:0] P2;
  wire [3:0] P3;
  wire [4:0] P4;
  wire [5:0] P5;
  wire [6:0] P6;
  wire [7:0] P7;
  wire [8:0] P8;
  wire [9:0] P9;
  wire [10:0] P10;
  wire [11:0] P11;
  wire [10:0] P12;
  wire [9:0] P13;
  wire [8:0] P14;
  wire [7:0] P15;
  wire [6:0] P16;
  wire [5:0] P17;
  wire [4:0] P18;
  wire [3:0] P19;
  wire [2:0] P20;
  wire [1:0] P21;
  wire [0:0] P22;
  wire [22:0] R1;
  wire [10:0] R2;
  wire [23:0] aOut;
  U_SP_12_12 S0 (IN1, IN2 , P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16, P17, P18, P19, P20, P21, P22);
  AR S1 (P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16, P17, P18, P19, P20, P21, P22, R1, R2);
  RC_11_11 S2 (R1[22:12], R2, aOut[23:12]);
  assign aOut[0] = R1[0];
  assign aOut[1] = R1[1];
  assign aOut[2] = R1[2];
  assign aOut[3] = R1[3];
  assign aOut[4] = R1[4];
  assign aOut[5] = R1[5];
  assign aOut[6] = R1[6];
  assign aOut[7] = R1[7];
  assign aOut[8] = R1[8];
  assign aOut[9] = R1[9];
  assign aOut[10] = R1[10];
  assign aOut[11] = R1[11];
  assign Out = aOut[23:0];
endmodule

/*---------------------------------------------------------------------------------------------------
This are SHA256 message digests computed for all source files to see the version of a file in genmul.
4164f841dcd2afb1341b584b40f40d82ef4c3d0830615503b45c13f9ff1f0b99 Array.cpp
b66c13355402b785b10523902060ea2b13495e0139581e3e1f9eb511b63091d0 Array.hpp
049f660c454752c510b8d2d7d5474b271804a3f2ef3bbd08b201b27cf5aa953c BrentKungAdder.cpp
542006e2bd9fe43a38fbd454d79c40216e2222968ee81d61ccb8b9f5f7c2cfc0 BrentKungAdder.hpp
dd0e0628729b9c228e1e3e2d8c759e3c5d548b2a7fc7a0ecf965f77c057f8982 CarryLookAhead.cpp
acab3bf6b24f0596013dfce2d21a56d16bc4565d810d7521bef6b645b6192ddf CarryLookAhead.hpp
929ba8b159d43cd1483702c39adf3f3c01a0e029393157d2dff1e576c3784ba2 CarryPredictor.cpp
c674a6131475e399d67794664958ce3992e34ad5a8a276b258f3b65179dbb0d2 CarryPredictor.hpp
7ad1df61ce6dec8970320cdbb0cd1b9d9e1b1aaed8337fad2ba9dc15bebade69 CarrySkipAdder.cpp
ce45d117e5a45c141acb0a305a0a6eaf30ccdc4b387a55bd5ab330672bf3c03a CarrySkipAdder.hpp
227583b37ff516c46466fc5c918ee7605b0476c7e79e1b63b1fc28017046b0d2 CarrySkipAdderVariable.cpp
1812c7c9c45afa80da1317afd4c2210c3583748daed3177e247887653392a938 CarrySkipAdderVariable.hpp
6cb775e3f48c2bc7fe32ff327217939a020f17c5087cc13d0faee3452517d768 component.cpp
209f908d2f1fb45ff2ab578483ac59b4daf3db09b0623e939fe467d8c408a03c component.hpp
1448c3a20470e843c0e3d8e81150aa7ae966b01c0324366ad6d09973635eae33 Dadda.cpp
b409b894cf7e5dd8b1566ad65242d8204a3b10e09218cfdba51d6798420c3db4 Dadda.hpp
e2de7008e12d31cf28e87ddcc91be289718e8c57104720d626d739224e17d237 GenMul.cpp
ca6978e216edf5aa647ec0ac3ce023db92fac8b0514ff9494e53594d0f6870ea GenMul_Emscripten.cpp
59b5e2c157f082415d42add003c3f61c2a59ddcff55d4bce8b87b7769944c265 GenMul_Emscripten.hpp
9f7728b1956d663933ee8c2e36eedbfbf99e183f597155867c1b3ea7b518cfc7 GenMul.hpp
b6c44052471006782baa14f9ee553e9dd2befb5a48caaf3ea08ada0fa333a4b7 KoggeStoneAdder.cpp
39decce3c706b8eafdd039498cb80147312dc279cf9ac722df1d7c5e44ca1eb1 KoggeStoneAdder.hpp
8cd281edd6691072195380d088347b8080c00b9bdc903f9930b6f9b66343a532 LanderFischerAdder.cpp
5a7fd4ccf6aba5d41505bf471d36050ebc082c671b174d26d2afe89d8ab1424f LanderFischerAdder.hpp
e882c7b4ccf415774af64e8554a5d95bc8652feda0a36406f200e95b0228339b main.cpp
bc20681185e8c41a7f23ff828021720d345a078c484211fe91f92bc0bffc69e2 ModuleConnector.cpp
e1e43efd032bbdf2f7cde39e51a5ca384a6f7dbe2bbb2d60b2ce379cba5c5a61 ModuleConnector.hpp
287f82e4c4496d55e1bfa8679ee9e55e472790befa8efd8632594da9f222bcc6 partial.cpp
0f936d14fa3aa23fae3171e401a240bea867f3be47b3cf7302cfabd3cb016a2a partial.hpp
8ce42bf2a0b4a30bf2a9b1371c7e59d94c8b71af34319211923ebc0acae9f0d0 PartialProductGenerator.cpp
0ec3b8793327e4b4e723a90196524386697346d2ab66595de11ae34a7ed16ae2 PartialProductGenerator.hpp
049b30b6e146bee3b19fa21ee9d78e1fba8caf3bf38b0e4a99bc6e35110f8cef PartialProductGeneratorSigned.cpp
b3fd13d4dc90c5708b5905c73a6437578e972e9929a8f5ef40d224277a72b3eb PartialProductGeneratorSigned.hpp
b4d8f357fdd48208ab4dbec18a26d3dd8091c289f388f9bfe66dfe22793c005c RippleCarryAdder.cpp
7a68cc632729d6a10a87e0d6750a3b6bc38ffea3c1adefbb6c04f5c81d6821fd RippleCarryAdder.hpp
02ad7291a8c88d72769d019fcfcb63f20595eeb7f97880174f7080c433adc827 SerialPrefixAdder.cpp
34c8850d96db902dcf9124b07b854739c311e1b984f27ae2cba2c97dac68b528 SerialPrefixAdder.hpp
ce0ae8c29d242e8eda47cc3e9ff06bb052ce1a90f3c8e0cf21ee13c63ddd30e9 VerilogGen.cpp
60865ceaeae304e64ad944fb7b83fda22058c3e042b9e5ad1e2b35effcb79918 VerilogGen.hpp
421854807ffbed49e9450453ff4d7b2fb6cbcff53c1e8cca3299cc3c49d5bb6f Wallace5.cpp
ae5f879f4f6fda292e6394ba3e8df4a50b38d2c1c8f590fbf5752c2109deb398 Wallace5.hpp
53e7bc2a228005f30c0349cd8f1e2f68498141e175ee1c140d3465823cfc44ec Wallace.cpp
f00fd621015cfcf54cda85815dce343d8526c1fee0f7e22a9d98041195b72e1a Wallace.hpp
---------------------------------------------------------------------------------------------------*/
