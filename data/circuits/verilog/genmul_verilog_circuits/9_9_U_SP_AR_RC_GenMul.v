//Compilation time: 2020-12-21 20:54:37
//Compilation SHA256 message digest: a3b96163f4df0c250d004b4f2251d595f41e522f2c4c62c3e7bbdda690c221f0
/*----------------------------------------------------------------------------
Copyright (c) 2019-2020 University of Bremen, Germany.
Copyright (c) 2020 Johannes Kepler University Linz, Austria.
This file has been generated with GenMul.
You can find GenMul at: http://www.sca-verification.org/genmul
Contact us at genmul@sca-verification.org

  First input length: 9
  second input length: 9
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
module U_SP_9_9(IN1, IN2 , P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16);
  input [8:0] IN1;
  input [8:0] IN2;
  output [0:0] P0;
  output [1:0] P1;
  output [2:0] P2;
  output [3:0] P3;
  output [4:0] P4;
  output [5:0] P5;
  output [6:0] P6;
  output [7:0] P7;
  output [8:0] P8;
  output [7:0] P9;
  output [6:0] P10;
  output [5:0] P11;
  output [4:0] P12;
  output [3:0] P13;
  output [2:0] P14;
  output [1:0] P15;
  output [0:0] P16;
  assign P0[0] = IN1[0]&IN2[0];
  assign P1[0] = IN1[0]&IN2[1];
  assign P2[0] = IN1[0]&IN2[2];
  assign P3[0] = IN1[0]&IN2[3];
  assign P4[0] = IN1[0]&IN2[4];
  assign P5[0] = IN1[0]&IN2[5];
  assign P6[0] = IN1[0]&IN2[6];
  assign P7[0] = IN1[0]&IN2[7];
  assign P8[0] = IN1[0]&IN2[8];
  assign P1[1] = IN1[1]&IN2[0];
  assign P2[1] = IN1[1]&IN2[1];
  assign P3[1] = IN1[1]&IN2[2];
  assign P4[1] = IN1[1]&IN2[3];
  assign P5[1] = IN1[1]&IN2[4];
  assign P6[1] = IN1[1]&IN2[5];
  assign P7[1] = IN1[1]&IN2[6];
  assign P8[1] = IN1[1]&IN2[7];
  assign P9[0] = IN1[1]&IN2[8];
  assign P2[2] = IN1[2]&IN2[0];
  assign P3[2] = IN1[2]&IN2[1];
  assign P4[2] = IN1[2]&IN2[2];
  assign P5[2] = IN1[2]&IN2[3];
  assign P6[2] = IN1[2]&IN2[4];
  assign P7[2] = IN1[2]&IN2[5];
  assign P8[2] = IN1[2]&IN2[6];
  assign P9[1] = IN1[2]&IN2[7];
  assign P10[0] = IN1[2]&IN2[8];
  assign P3[3] = IN1[3]&IN2[0];
  assign P4[3] = IN1[3]&IN2[1];
  assign P5[3] = IN1[3]&IN2[2];
  assign P6[3] = IN1[3]&IN2[3];
  assign P7[3] = IN1[3]&IN2[4];
  assign P8[3] = IN1[3]&IN2[5];
  assign P9[2] = IN1[3]&IN2[6];
  assign P10[1] = IN1[3]&IN2[7];
  assign P11[0] = IN1[3]&IN2[8];
  assign P4[4] = IN1[4]&IN2[0];
  assign P5[4] = IN1[4]&IN2[1];
  assign P6[4] = IN1[4]&IN2[2];
  assign P7[4] = IN1[4]&IN2[3];
  assign P8[4] = IN1[4]&IN2[4];
  assign P9[3] = IN1[4]&IN2[5];
  assign P10[2] = IN1[4]&IN2[6];
  assign P11[1] = IN1[4]&IN2[7];
  assign P12[0] = IN1[4]&IN2[8];
  assign P5[5] = IN1[5]&IN2[0];
  assign P6[5] = IN1[5]&IN2[1];
  assign P7[5] = IN1[5]&IN2[2];
  assign P8[5] = IN1[5]&IN2[3];
  assign P9[4] = IN1[5]&IN2[4];
  assign P10[3] = IN1[5]&IN2[5];
  assign P11[2] = IN1[5]&IN2[6];
  assign P12[1] = IN1[5]&IN2[7];
  assign P13[0] = IN1[5]&IN2[8];
  assign P6[6] = IN1[6]&IN2[0];
  assign P7[6] = IN1[6]&IN2[1];
  assign P8[6] = IN1[6]&IN2[2];
  assign P9[5] = IN1[6]&IN2[3];
  assign P10[4] = IN1[6]&IN2[4];
  assign P11[3] = IN1[6]&IN2[5];
  assign P12[2] = IN1[6]&IN2[6];
  assign P13[1] = IN1[6]&IN2[7];
  assign P14[0] = IN1[6]&IN2[8];
  assign P7[7] = IN1[7]&IN2[0];
  assign P8[7] = IN1[7]&IN2[1];
  assign P9[6] = IN1[7]&IN2[2];
  assign P10[5] = IN1[7]&IN2[3];
  assign P11[4] = IN1[7]&IN2[4];
  assign P12[3] = IN1[7]&IN2[5];
  assign P13[2] = IN1[7]&IN2[6];
  assign P14[1] = IN1[7]&IN2[7];
  assign P15[0] = IN1[7]&IN2[8];
  assign P8[8] = IN1[8]&IN2[0];
  assign P9[7] = IN1[8]&IN2[1];
  assign P10[6] = IN1[8]&IN2[2];
  assign P11[5] = IN1[8]&IN2[3];
  assign P12[4] = IN1[8]&IN2[4];
  assign P13[3] = IN1[8]&IN2[5];
  assign P14[2] = IN1[8]&IN2[6];
  assign P15[1] = IN1[8]&IN2[7];
  assign P16[0] = IN1[8]&IN2[8];

endmodule
module AR(IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15, IN16, Out1, Out2);
  input [0:0] IN0;
  input [1:0] IN1;
  input [2:0] IN2;
  input [3:0] IN3;
  input [4:0] IN4;
  input [5:0] IN5;
  input [6:0] IN6;
  input [7:0] IN7;
  input [8:0] IN8;
  input [7:0] IN9;
  input [6:0] IN10;
  input [5:0] IN11;
  input [4:0] IN12;
  input [3:0] IN13;
  input [2:0] IN14;
  input [1:0] IN15;
  input [0:0] IN16;
  output [16:0] Out1;
  output [7:0] Out2;
  wire w82;
  wire w83;
  wire w84;
  wire w85;
  wire w86;
  wire w87;
  wire w88;
  wire w89;
  wire w90;
  wire w91;
  wire w92;
  wire w93;
  wire w94;
  wire w95;
  wire w96;
  wire w98;
  wire w99;
  wire w100;
  wire w101;
  wire w102;
  wire w103;
  wire w104;
  wire w105;
  wire w106;
  wire w107;
  wire w108;
  wire w109;
  wire w110;
  wire w111;
  wire w112;
  wire w114;
  wire w115;
  wire w116;
  wire w117;
  wire w118;
  wire w119;
  wire w120;
  wire w121;
  wire w122;
  wire w123;
  wire w124;
  wire w125;
  wire w126;
  wire w127;
  wire w128;
  wire w130;
  wire w131;
  wire w132;
  wire w133;
  wire w134;
  wire w135;
  wire w136;
  wire w137;
  wire w138;
  wire w139;
  wire w140;
  wire w141;
  wire w142;
  wire w143;
  wire w144;
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
  wire w162;
  wire w163;
  wire w164;
  wire w165;
  wire w166;
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
  wire w188;
  wire w189;
  wire w190;
  wire w191;
  wire w192;
  wire w194;
  wire w196;
  wire w198;
  wire w200;
  wire w202;
  wire w204;
  wire w206;
  HalfAdder U0 (IN1[0], IN1[1], Out1[1], w82);
  FullAdder U1 (w82, IN2[0], IN2[1], w83, w84);
  FullAdder U2 (w84, IN3[0], IN3[1], w85, w86);
  FullAdder U3 (w86, IN4[0], IN4[1], w87, w88);
  FullAdder U4 (w88, IN5[0], IN5[1], w89, w90);
  FullAdder U5 (w90, IN6[0], IN6[1], w91, w92);
  FullAdder U6 (w92, IN7[0], IN7[1], w93, w94);
  FullAdder U7 (w94, IN8[0], IN8[1], w95, w96);
  HalfAdder U8 (w83, IN2[2], Out1[2], w98);
  FullAdder U9 (w98, w85, IN3[2], w99, w100);
  FullAdder U10 (w100, w87, IN4[2], w101, w102);
  FullAdder U11 (w102, w89, IN5[2], w103, w104);
  FullAdder U12 (w104, w91, IN6[2], w105, w106);
  FullAdder U13 (w106, w93, IN7[2], w107, w108);
  FullAdder U14 (w108, w95, IN8[2], w109, w110);
  FullAdder U15 (w110, w96, IN9[0], w111, w112);
  HalfAdder U16 (w99, IN3[3], Out1[3], w114);
  FullAdder U17 (w114, w101, IN4[3], w115, w116);
  FullAdder U18 (w116, w103, IN5[3], w117, w118);
  FullAdder U19 (w118, w105, IN6[3], w119, w120);
  FullAdder U20 (w120, w107, IN7[3], w121, w122);
  FullAdder U21 (w122, w109, IN8[3], w123, w124);
  FullAdder U22 (w124, w111, IN9[1], w125, w126);
  FullAdder U23 (w126, w112, IN10[0], w127, w128);
  HalfAdder U24 (w115, IN4[4], Out1[4], w130);
  FullAdder U25 (w130, w117, IN5[4], w131, w132);
  FullAdder U26 (w132, w119, IN6[4], w133, w134);
  FullAdder U27 (w134, w121, IN7[4], w135, w136);
  FullAdder U28 (w136, w123, IN8[4], w137, w138);
  FullAdder U29 (w138, w125, IN9[2], w139, w140);
  FullAdder U30 (w140, w127, IN10[1], w141, w142);
  FullAdder U31 (w142, w128, IN11[0], w143, w144);
  HalfAdder U32 (w131, IN5[5], Out1[5], w146);
  FullAdder U33 (w146, w133, IN6[5], w147, w148);
  FullAdder U34 (w148, w135, IN7[5], w149, w150);
  FullAdder U35 (w150, w137, IN8[5], w151, w152);
  FullAdder U36 (w152, w139, IN9[3], w153, w154);
  FullAdder U37 (w154, w141, IN10[2], w155, w156);
  FullAdder U38 (w156, w143, IN11[1], w157, w158);
  FullAdder U39 (w158, w144, IN12[0], w159, w160);
  HalfAdder U40 (w147, IN6[6], Out1[6], w162);
  FullAdder U41 (w162, w149, IN7[6], w163, w164);
  FullAdder U42 (w164, w151, IN8[6], w165, w166);
  FullAdder U43 (w166, w153, IN9[4], w167, w168);
  FullAdder U44 (w168, w155, IN10[3], w169, w170);
  FullAdder U45 (w170, w157, IN11[2], w171, w172);
  FullAdder U46 (w172, w159, IN12[1], w173, w174);
  FullAdder U47 (w174, w160, IN13[0], w175, w176);
  HalfAdder U48 (w163, IN7[7], Out1[7], w178);
  FullAdder U49 (w178, w165, IN8[7], w179, w180);
  FullAdder U50 (w180, w167, IN9[5], w181, w182);
  FullAdder U51 (w182, w169, IN10[4], w183, w184);
  FullAdder U52 (w184, w171, IN11[3], w185, w186);
  FullAdder U53 (w186, w173, IN12[2], w187, w188);
  FullAdder U54 (w188, w175, IN13[1], w189, w190);
  FullAdder U55 (w190, w176, IN14[0], w191, w192);
  HalfAdder U56 (w179, IN8[8], Out1[8], w194);
  FullAdder U57 (w194, w181, IN9[6], Out1[9], w196);
  FullAdder U58 (w196, w183, IN10[5], Out1[10], w198);
  FullAdder U59 (w198, w185, IN11[4], Out1[11], w200);
  FullAdder U60 (w200, w187, IN12[3], Out1[12], w202);
  FullAdder U61 (w202, w189, IN13[2], Out1[13], w204);
  FullAdder U62 (w204, w191, IN14[1], Out1[14], w206);
  FullAdder U63 (w206, w192, IN15[0], Out1[15], Out1[16]);
  assign Out1[0] = IN0[0];
  assign Out2[0] = IN9[7];
  assign Out2[1] = IN10[6];
  assign Out2[2] = IN11[5];
  assign Out2[3] = IN12[4];
  assign Out2[4] = IN13[3];
  assign Out2[5] = IN14[2];
  assign Out2[6] = IN15[1];
  assign Out2[7] = IN16[0];

endmodule
module RC_8_8(IN1, IN2, Out);
  input [7:0] IN1;
  input [7:0] IN2;
  output [8:0] Out;
  wire w17;
  wire w19;
  wire w21;
  wire w23;
  wire w25;
  wire w27;
  wire w29;
  HalfAdder U0 (IN1[0], IN2[0], Out[0], w17);
  FullAdder U1 (IN1[1], IN2[1], w17, Out[1], w19);
  FullAdder U2 (IN1[2], IN2[2], w19, Out[2], w21);
  FullAdder U3 (IN1[3], IN2[3], w21, Out[3], w23);
  FullAdder U4 (IN1[4], IN2[4], w23, Out[4], w25);
  FullAdder U5 (IN1[5], IN2[5], w25, Out[5], w27);
  FullAdder U6 (IN1[6], IN2[6], w27, Out[6], w29);
  FullAdder U7 (IN1[7], IN2[7], w29, Out[7], Out[8]);

endmodule
module Mult_9_9(IN1, IN2, Out);
  input [8:0] IN1;
  input [8:0] IN2;
  output [17:0] Out;
  wire [0:0] P0;
  wire [1:0] P1;
  wire [2:0] P2;
  wire [3:0] P3;
  wire [4:0] P4;
  wire [5:0] P5;
  wire [6:0] P6;
  wire [7:0] P7;
  wire [8:0] P8;
  wire [7:0] P9;
  wire [6:0] P10;
  wire [5:0] P11;
  wire [4:0] P12;
  wire [3:0] P13;
  wire [2:0] P14;
  wire [1:0] P15;
  wire [0:0] P16;
  wire [16:0] R1;
  wire [7:0] R2;
  wire [17:0] aOut;
  U_SP_9_9 S0 (IN1, IN2 , P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16);
  AR S1 (P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16, R1, R2);
  RC_8_8 S2 (R1[16:9], R2, aOut[17:9]);
  assign aOut[0] = R1[0];
  assign aOut[1] = R1[1];
  assign aOut[2] = R1[2];
  assign aOut[3] = R1[3];
  assign aOut[4] = R1[4];
  assign aOut[5] = R1[5];
  assign aOut[6] = R1[6];
  assign aOut[7] = R1[7];
  assign aOut[8] = R1[8];
  assign Out = aOut[17:0];
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
