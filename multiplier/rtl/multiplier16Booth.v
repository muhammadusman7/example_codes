// Title: Booth 53 Multiplier PP Reduction (No Changelog)
// Created: Septmeber 11, 2021
// Updated: Janurary 10, 2022
//---------------------------------------------------------------------------
// This is a Verilog file that define a Modified Booth Multiplication for radix-4
// partial product are compressed with Wallace tree reduction
//
//---------------------------------------------------------------------------
module multiplier16Booth #(parameter WIDTH = 16) (
    input wire  [WIDTH-1:0]     multiplicand,
    input wire  [WIDTH-1:0]     multiplier,
    output reg  [2*WIDTH-1:0]   p0, p1
);

    wire [WIDTH:0] pp_in, pp_n, pp_2, pp_2n, pp_zero;
    wire [WIDTH/2:0] comp;
    wire [WIDTH+2:0] temp_multiplier;
    wire [WIDTH:0]   pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7, pp8;

    assign temp_multiplier = {2'b0, multiplier, 1'b0};

    // Get basic partial products
    boothPP #(.WIDTH(WIDTH)) bPP (
        .in(multiplicand), .out_in(pp_in), .out_in_n(pp_n), .out_in_2(pp_2),
        .out_in_2n(pp_2n), .out_zero(pp_zero) );

    // Get partial produts for each row
    boothPPCal #(.WIDTH(WIDTH)) ppCal0 (.pp(pp_in), .pp_n(pp_n), .pp_2(pp_2), .pp_2n(pp_2n),
                .pp_zero(pp_zero), .booth(temp_multiplier[2:0]), .comp(comp[0]), .out(pp0) );
    boothPPCal #(.WIDTH(WIDTH)) ppCal1 (.pp(pp_in), .pp_n(pp_n), .pp_2(pp_2), .pp_2n(pp_2n),
                .pp_zero(pp_zero), .booth({temp_multiplier[4:2]}), .comp(comp[1]), .out(pp1) );
    boothPPCal #(.WIDTH(WIDTH)) ppCal2 (.pp(pp_in), .pp_n(pp_n), .pp_2(pp_2), .pp_2n(pp_2n),
                .pp_zero(pp_zero), .booth({temp_multiplier[6:4]}), .comp(comp[2]), .out(pp2) );
    boothPPCal #(.WIDTH(WIDTH)) ppCal3 (.pp(pp_in), .pp_n(pp_n), .pp_2(pp_2), .pp_2n(pp_2n),
                .pp_zero(pp_zero), .booth({temp_multiplier[8:6]}), .comp(comp[3]), .out(pp3) );
    boothPPCal #(.WIDTH(WIDTH)) ppCal4 (.pp(pp_in), .pp_n(pp_n), .pp_2(pp_2), .pp_2n(pp_2n),
                .pp_zero(pp_zero), .booth({temp_multiplier[10:8]}), .comp(comp[4]), .out(pp4) );
    boothPPCal #(.WIDTH(WIDTH)) ppCal5 (.pp(pp_in), .pp_n(pp_n), .pp_2(pp_2), .pp_2n(pp_2n),
                .pp_zero(pp_zero), .booth({temp_multiplier[12:10]}), .comp(comp[5]), .out(pp5) );
    boothPPCal #(.WIDTH(WIDTH)) ppCal6 (.pp(pp_in), .pp_n(pp_n), .pp_2(pp_2), .pp_2n(pp_2n),
                .pp_zero(pp_zero), .booth({temp_multiplier[14:12]}), .comp(comp[6]), .out(pp6) );
    boothPPCal #(.WIDTH(WIDTH)) ppCal7 (.pp(pp_in), .pp_n(pp_n), .pp_2(pp_2), .pp_2n(pp_2n),
                .pp_zero(pp_zero), .booth({temp_multiplier[16:14]}), .comp(comp[7]), .out(pp7) );
    boothPPCal #(.WIDTH(WIDTH)) ppCal8 (.pp(pp_in), .pp_n(pp_n), .pp_2(pp_2), .pp_2n(pp_2n),
                .pp_zero(pp_zero), .booth({temp_multiplier[18:16]}), .comp(comp[8]), .out(pp8) );
    
    wire [135:0] s, c;

    always @(*) begin
        p0 = {s[92], s[135], s[114], s[134:117], s[96:95], s[116], s[94], s[57], s[115], s[93], s[56], s[0], pp0[01], pp0[00]};
        p1 = {c[135], 1'b0, c[134:117], 1'b0, c[95], c[116], 2'b0, c[115], 5'b0, comp[0]};
    end



    // Wallace tree reduction
    // Stage 1 Reduction
    fullAdder fa1 (.a(pp0[02]), .b(pp1[00]), .c_in(comp[1]), .s(s[0]), .c_out(c[0]));
    fullAdder fa2 (.a(pp0[04]), .b(pp1[02]), .c_in(pp2[00]), .s(s[1]), .c_out(c[1]));
    fullAdder fa3 (.a(pp0[05]), .b(pp1[03]), .c_in(pp2[01]), .s(s[2]), .c_out(c[2]));
    fullAdder fa4 (.a(pp0[06]), .b(pp1[04]), .c_in(pp2[02]), .s(s[3]), .c_out(c[3]));
    halfAdder ha1 (.a(pp3[00]), .b(comp[3]), .s(s[4]), .c_out(c[4]));
    fullAdder fa5 (.a(pp0[07]), .b(pp1[05]), .c_in(pp2[03]), .s(s[5]), .c_out(c[5]));
    fullAdder fa6 (.a(pp0[08]), .b(pp1[06]), .c_in(pp2[04]), .s(s[6]), .c_out(c[6]));
    fullAdder fa7 (.a(pp3[02]), .b(pp4[00]), .c_in(comp[4]), .s(s[7]), .c_out(c[7]));
    fullAdder fa8 (.a(pp0[09]), .b(pp1[07]), .c_in(pp2[05]), .s(s[8]), .c_out(c[8]));
    halfAdder ha2 (.a(pp3[03]), .b(pp4[01]), .s(s[9]), .c_out(c[9]));
    fullAdder fa9 (.a(pp0[10]), .b(pp1[08]), .c_in(pp2[06]), .s(s[10]), .c_out(c[10]));
    fullAdder fa10 (.a(pp3[04]), .b(pp4[02]), .c_in(pp5[00]), .s(s[11]), .c_out(c[11]));
    fullAdder fa11 (.a(pp0[11]), .b(pp1[09]), .c_in(pp2[07]), .s(s[12]), .c_out(c[12]));
    fullAdder fa12 (.a(pp3[05]), .b(pp4[03]), .c_in(pp5[01]), .s(s[13]), .c_out(c[13]));
    fullAdder fa13 (.a(pp0[12]), .b(pp1[10]), .c_in(pp2[08]), .s(s[14]), .c_out(c[14]));
    fullAdder fa14 (.a(pp3[06]), .b(pp4[04]), .c_in(pp5[02]), .s(s[15]), .c_out(c[15]));
    halfAdder ha3 (.a(pp6[00]), .b(comp[6]), .s(s[16]), .c_out(c[16]));
    fullAdder fa15 (.a(pp0[13]), .b(pp1[11]), .c_in(pp2[09]), .s(s[17]), .c_out(c[17]));
    fullAdder fa16 (.a(pp3[07]), .b(pp4[05]), .c_in(pp5[03]), .s(s[18]), .c_out(c[18]));
    fullAdder fa17 (.a(pp0[14]), .b(pp1[12]), .c_in(pp2[10]), .s(s[19]), .c_out(c[19]));
    fullAdder fa18 (.a(pp3[08]), .b(pp4[06]), .c_in(pp5[04]), .s(s[20]), .c_out(c[20]));
    fullAdder fa19 (.a(pp6[02]), .b(pp7[00]), .c_in(comp[7]), .s(s[21]), .c_out(c[21]));
    fullAdder fa20 (.a(pp0[15]), .b(pp1[13]), .c_in(pp2[11]), .s(s[22]), .c_out(c[22]));
    fullAdder fa21 (.a(pp3[09]), .b(pp4[07]), .c_in(pp5[05]), .s(s[23]), .c_out(c[23]));
    halfAdder ha4 (.a(pp6[03]), .b(pp7[01]), .s(s[24]), .c_out(c[24]));
    fullAdder fa22 (.a(pp0[16]), .b(pp1[14]), .c_in(pp2[12]), .s(s[25]), .c_out(c[25]));
    fullAdder fa23 (.a(pp3[10]), .b(pp4[08]), .c_in(pp5[06]), .s(s[26]), .c_out(c[26]));
    fullAdder fa24 (.a(pp6[04]), .b(pp7[02]), .c_in(pp8[00]), .s(s[27]), .c_out(c[27]));
    fullAdder fa25 (.a(comp[0]), .b(pp1[15]), .c_in(pp2[13]), .s(s[28]), .c_out(c[28]));
    fullAdder fa26 (.a(pp3[11]), .b(pp4[09]), .c_in(pp5[07]), .s(s[29]), .c_out(c[29]));
    fullAdder fa27 (.a(pp6[05]), .b(pp7[03]), .c_in(pp8[01]), .s(s[30]), .c_out(c[30]));
    fullAdder fa28 (.a(comp[0]), .b(pp1[16]), .c_in(pp2[14]), .s(s[31]), .c_out(c[31]));
    fullAdder fa29 (.a(pp3[12]), .b(pp4[10]), .c_in(pp5[08]), .s(s[32]), .c_out(c[32]));
    fullAdder fa30 (.a(pp6[06]), .b(pp7[04]), .c_in(pp8[02]), .s(s[33]), .c_out(c[33]));
    fullAdder fa31 (.a(~comp[0]), .b(~comp[1]), .c_in(pp2[15]), .s(s[34]), .c_out(c[34]));
    fullAdder fa32 (.a(pp3[13]), .b(pp4[11]), .c_in(pp5[09]), .s(s[35]), .c_out(c[35]));
    fullAdder fa33 (.a(pp6[07]), .b(pp7[05]), .c_in(pp8[03]), .s(s[36]), .c_out(c[36]));
    fullAdder fa34 (.a(1'b1), .b(pp2[16]), .c_in(pp3[14]), .s(s[37]), .c_out(c[37]));
    fullAdder fa35 (.a(pp4[12]), .b(pp5[10]), .c_in(pp6[08]), .s(s[38]), .c_out(c[38]));
    halfAdder ha5 (.a(pp7[06]), .b(pp8[04]), .s(s[39]), .c_out(c[39]));
    fullAdder fa36 (.a(~comp[2]), .b(pp3[15]), .c_in(pp4[13]), .s(s[40]), .c_out(c[40]));
    fullAdder fa37 (.a(pp5[11]), .b(pp6[09]), .c_in(pp7[07]), .s(s[41]), .c_out(c[41]));
    fullAdder fa38 (.a(1'b1), .b(pp3[16]), .c_in(pp4[14]), .s(s[42]), .c_out(c[42]));
    fullAdder fa39 (.a(pp5[12]), .b(pp6[10]), .c_in(pp7[08]), .s(s[43]), .c_out(c[43]));
    fullAdder fa40 (.a(~comp[3]), .b(pp4[15]), .c_in(pp5[13]), .s(s[44]), .c_out(c[44]));
    fullAdder fa41 (.a(pp6[11]), .b(pp7[09]), .c_in(pp8[07]), .s(s[45]), .c_out(c[45]));
    fullAdder fa42 (.a(1'b1), .b(pp4[16]), .c_in(pp5[14]), .s(s[46]), .c_out(c[46]));
    fullAdder fa43 (.a(pp6[12]), .b(pp7[10]), .c_in(pp8[08]), .s(s[47]), .c_out(c[47]));
    fullAdder fa44 (.a(~comp[4]), .b(pp5[15]), .c_in(pp6[13]), .s(s[48]), .c_out(c[48]));
    halfAdder ha6 (.a(pp7[11]), .b(pp8[09]), .s(s[49]), .c_out(c[49]));
    fullAdder fa45 (.a(1'b1), .b(pp5[16]), .c_in(pp6[14]), .s(s[50]), .c_out(c[50]));
    halfAdder ha7 (.a(pp7[12]), .b(pp8[10]), .s(s[51]), .c_out(c[51]));
    fullAdder fa46 (.a(~comp[5]), .b(pp6[15]), .c_in(pp7[13]), .s(s[52]), .c_out(c[52]));
    fullAdder fa47 (.a(1'b1), .b(pp6[16]), .c_in(pp7[14]), .s(s[53]), .c_out(c[53]));
    fullAdder fa48 (.a(~comp[6]), .b(pp7[15]), .c_in(pp8[13]), .s(s[54]), .c_out(c[54]));
    fullAdder fa49 (.a(1'b1), .b(pp7[16]), .c_in(pp8[14]), .s(s[55]), .c_out(c[55]));
    // Stage 2 Reduction
    fullAdder fa50 (.a(pp0[03]), .b(c[0]), .c_in(pp1[01]), .s(s[56]), .c_out(c[56]));
    fullAdder fa51 (.a(s[3]), .b(c[2]), .c_in(s[4]), .s(s[57]), .c_out(c[57]));
    fullAdder fa52 (.a(s[5]), .b(c[3]), .c_in(pp3[01]), .s(s[58]), .c_out(c[58]));
    fullAdder fa53 (.a(s[6]), .b(c[5]), .c_in(s[7]), .s(s[59]), .c_out(c[59]));
    fullAdder fa54 (.a(s[8]), .b(c[6]), .c_in(s[9]), .s(s[60]), .c_out(c[60]));
    fullAdder fa55 (.a(s[10]), .b(c[8]), .c_in(s[11]), .s(s[61]), .c_out(c[61]));
    halfAdder ha8 (.a(c[9]), .b(comp[5]), .s(s[62]), .c_out(c[62]));
    fullAdder fa56 (.a(s[12]), .b(c[10]), .c_in(s[13]), .s(s[63]), .c_out(c[63]));
    fullAdder fa57 (.a(s[14]), .b(c[12]), .c_in(s[15]), .s(s[64]), .c_out(c[64]));
    halfAdder ha9 (.a(c[13]), .b(s[16]), .s(s[65]), .c_out(c[65]));
    fullAdder fa58 (.a(s[17]), .b(c[14]), .c_in(s[18]), .s(s[66]), .c_out(c[66]));
    fullAdder fa59 (.a(c[15]), .b(pp6[01]), .c_in(c[16]), .s(s[67]), .c_out(c[67]));
    fullAdder fa60 (.a(s[19]), .b(c[17]), .c_in(s[20]), .s(s[68]), .c_out(c[68]));
    halfAdder ha10 (.a(c[18]), .b(s[21]), .s(s[69]), .c_out(c[69]));
    fullAdder fa61 (.a(s[22]), .b(c[19]), .c_in(s[23]), .s(s[70]), .c_out(c[70]));
    fullAdder fa62 (.a(c[20]), .b(s[24]), .c_in(c[21]), .s(s[71]), .c_out(c[71]));
    fullAdder fa63 (.a(s[25]), .b(c[22]), .c_in(s[26]), .s(s[72]), .c_out(c[72]));
    fullAdder fa64 (.a(c[23]), .b(s[27]), .c_in(c[24]), .s(s[73]), .c_out(c[73]));
    fullAdder fa65 (.a(s[28]), .b(c[25]), .c_in(s[29]), .s(s[74]), .c_out(c[74]));
    fullAdder fa66 (.a(c[26]), .b(s[30]), .c_in(c[27]), .s(s[75]), .c_out(c[75]));
    fullAdder fa67 (.a(s[31]), .b(c[28]), .c_in(s[32]), .s(s[76]), .c_out(c[76]));
    fullAdder fa68 (.a(c[29]), .b(s[33]), .c_in(c[30]), .s(s[77]), .c_out(c[77]));
    fullAdder fa69 (.a(s[34]), .b(c[31]), .c_in(s[35]), .s(s[78]), .c_out(c[78]));
    fullAdder fa70 (.a(c[32]), .b(s[36]), .c_in(c[33]), .s(s[79]), .c_out(c[79]));
    fullAdder fa71 (.a(s[37]), .b(c[34]), .c_in(s[38]), .s(s[80]), .c_out(c[80]));
    fullAdder fa72 (.a(c[35]), .b(s[39]), .c_in(c[36]), .s(s[81]), .c_out(c[81]));
    fullAdder fa73 (.a(s[40]), .b(c[37]), .c_in(s[41]), .s(s[82]), .c_out(c[82]));
    fullAdder fa74 (.a(c[38]), .b(pp8[05]), .c_in(c[39]), .s(s[83]), .c_out(c[83]));
    fullAdder fa75 (.a(s[42]), .b(c[40]), .c_in(s[43]), .s(s[84]), .c_out(c[84]));
    halfAdder ha11 (.a(c[41]), .b(pp8[06]), .s(s[85]), .c_out(c[85]));
    fullAdder fa76 (.a(s[44]), .b(c[42]), .c_in(s[45]), .s(s[86]), .c_out(c[86]));
    fullAdder fa77 (.a(s[46]), .b(c[44]), .c_in(s[47]), .s(s[87]), .c_out(c[87]));
    fullAdder fa78 (.a(s[48]), .b(c[46]), .c_in(s[49]), .s(s[88]), .c_out(c[88]));
    fullAdder fa79 (.a(s[50]), .b(c[48]), .c_in(s[51]), .s(s[89]), .c_out(c[89]));
    fullAdder fa80 (.a(s[52]), .b(c[50]), .c_in(pp8[11]), .s(s[90]), .c_out(c[90]));
    fullAdder fa81 (.a(s[53]), .b(c[52]), .c_in(pp8[12]), .s(s[91]), .c_out(c[91]));
    fullAdder fa82 (.a(~comp[7]), .b(c[55]), .c_in(pp8[15]), .s(s[92]), .c_out(c[92]));
    // Stage 3 Reduction
    fullAdder fa83 (.a(s[1]), .b(c[56]), .c_in(comp[2]), .s(s[93]), .c_out(c[93]));
    fullAdder fa84 (.a(s[58]), .b(c[57]), .c_in(c[4]), .s(s[94]), .c_out(c[94]));
    fullAdder fa85 (.a(s[60]), .b(c[59]), .c_in(c[7]), .s(s[95]), .c_out(c[95]));
    fullAdder fa86 (.a(s[61]), .b(c[60]), .c_in(s[62]), .s(s[96]), .c_out(c[96]));
    fullAdder fa87 (.a(s[63]), .b(c[61]), .c_in(c[11]), .s(s[97]), .c_out(c[97]));
    fullAdder fa88 (.a(s[64]), .b(c[63]), .c_in(s[65]), .s(s[98]), .c_out(c[98]));
    fullAdder fa89 (.a(s[66]), .b(c[64]), .c_in(s[67]), .s(s[99]), .c_out(c[99]));
    fullAdder fa90 (.a(s[68]), .b(c[66]), .c_in(s[69]), .s(s[100]), .c_out(c[100]));
    fullAdder fa91 (.a(s[70]), .b(c[68]), .c_in(s[71]), .s(s[101]), .c_out(c[101]));
    fullAdder fa92 (.a(s[72]), .b(c[70]), .c_in(s[73]), .s(s[102]), .c_out(c[102]));
    fullAdder fa93 (.a(s[74]), .b(c[72]), .c_in(s[75]), .s(s[103]), .c_out(c[103]));
    fullAdder fa94 (.a(s[76]), .b(c[74]), .c_in(s[77]), .s(s[104]), .c_out(c[104]));
    fullAdder fa95 (.a(s[78]), .b(c[76]), .c_in(s[79]), .s(s[105]), .c_out(c[105]));
    fullAdder fa96 (.a(s[80]), .b(c[78]), .c_in(s[81]), .s(s[106]), .c_out(c[106]));
    fullAdder fa97 (.a(s[82]), .b(c[80]), .c_in(s[83]), .s(s[107]), .c_out(c[107]));
    fullAdder fa98 (.a(s[84]), .b(c[82]), .c_in(s[85]), .s(s[108]), .c_out(c[108]));
    fullAdder fa99 (.a(s[86]), .b(c[84]), .c_in(c[43]), .s(s[109]), .c_out(c[109]));
    fullAdder fa100 (.a(s[87]), .b(c[86]), .c_in(c[45]), .s(s[110]), .c_out(c[110]));
    fullAdder fa101 (.a(s[88]), .b(c[87]), .c_in(c[47]), .s(s[111]), .c_out(c[111]));
    fullAdder fa102 (.a(s[89]), .b(c[88]), .c_in(c[49]), .s(s[112]), .c_out(c[112]));
    fullAdder fa103 (.a(s[90]), .b(c[89]), .c_in(c[51]), .s(s[113]), .c_out(c[113]));
    fullAdder fa104 (.a(s[54]), .b(c[91]), .c_in(c[53]), .s(s[114]), .c_out(c[114]));
    // Stage 4 Reduction
    fullAdder fa105 (.a(s[2]), .b(c[93]), .c_in(c[1]), .s(s[115]), .c_out(c[115]));
    fullAdder fa106 (.a(s[59]), .b(c[94]), .c_in(c[58]), .s(s[116]), .c_out(c[116]));
    fullAdder fa107 (.a(s[97]), .b(c[96]), .c_in(c[62]), .s(s[117]), .c_out(c[117]));
    halfAdder ha12 (.a(s[98]), .b(c[97]), .s(s[118]), .c_out(c[118]));
    fullAdder fa108 (.a(s[99]), .b(c[98]), .c_in(c[65]), .s(s[119]), .c_out(c[119]));
    fullAdder fa109 (.a(s[100]), .b(c[99]), .c_in(c[67]), .s(s[120]), .c_out(c[120]));
    fullAdder fa110 (.a(s[101]), .b(c[100]), .c_in(c[69]), .s(s[121]), .c_out(c[121]));
    fullAdder fa111 (.a(s[102]), .b(c[101]), .c_in(c[71]), .s(s[122]), .c_out(c[122]));
    fullAdder fa112 (.a(s[103]), .b(c[102]), .c_in(c[73]), .s(s[123]), .c_out(c[123]));
    fullAdder fa113 (.a(s[104]), .b(c[103]), .c_in(c[75]), .s(s[124]), .c_out(c[124]));
    fullAdder fa114 (.a(s[105]), .b(c[104]), .c_in(c[77]), .s(s[125]), .c_out(c[125]));
    fullAdder fa115 (.a(s[106]), .b(c[105]), .c_in(c[79]), .s(s[126]), .c_out(c[126]));
    fullAdder fa116 (.a(s[107]), .b(c[106]), .c_in(c[81]), .s(s[127]), .c_out(c[127]));
    fullAdder fa117 (.a(s[108]), .b(c[107]), .c_in(c[83]), .s(s[128]), .c_out(c[128]));
    fullAdder fa118 (.a(s[109]), .b(c[108]), .c_in(c[85]), .s(s[129]), .c_out(c[129]));
    halfAdder ha13 (.a(s[110]), .b(c[109]), .s(s[130]), .c_out(c[130]));
    halfAdder ha14 (.a(s[111]), .b(c[110]), .s(s[131]), .c_out(c[131]));
    halfAdder ha15 (.a(s[112]), .b(c[111]), .s(s[132]), .c_out(c[132]));
    halfAdder ha16 (.a(s[113]), .b(c[112]), .s(s[133]), .c_out(c[133]));
    fullAdder fa119 (.a(s[91]), .b(c[113]), .c_in(c[90]), .s(s[134]), .c_out(c[134]));
    fullAdder fa120 (.a(s[55]), .b(c[114]), .c_in(c[54]), .s(s[135]), .c_out(c[135]));

endmodule