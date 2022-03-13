// Title: Booth 32-bit Multiplier V 1.0 (No Changelog)
// Created: Janurary 10, 2022
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a Modified Booth  radix-4 Multiplication
// final two partial product rows are added using a 64-bit adder comprising a
// cascaded chain of CLA 4-bit adders.
//---------------------------------------------------------------------------
`default_nettype none

module multiplication (
    input wire  [15:0]  in_a, in_b,
    output wire [31:0]  prod
);

    wire [31:0] p0, p1;
    wire    discard_booth_carry;
    // Addition
    adder #(.WIDTH(32), .CWIDTH(9)) add32 (.in_a(p0), .in_b(p1), .c_in(1'b0), .c_out(discard_booth_carry), .s(prod));

    // Multiplier
    multiplier16Booth #(.WIDTH(16)) mul16 (.multiplicand(in_a), .multiplier(in_b), .p0(p0), .p1(p1));
    
endmodule

`default_nettype wire