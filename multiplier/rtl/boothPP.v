// Title: Booth Partial Products V 1.0 (No Changelog)
// Created: Septmeber 10, 2021
// Updated: Janurary 10, 2022
//---------------------------------------------------------------------------
// This is a Verilog file that created potential partial products for radix-4
// booth multiplication
//
//---------------------------------------------------------------------------
`default_nettype none

module boothPP #(parameter WIDTH = 16) (
    input wire  [WIDTH-1:0] in,
    output wire [WIDTH:0] out_in,
    output wire [WIDTH:0] out_in_n,
    output wire [WIDTH:0] out_in_2,
    output wire [WIDTH:0] out_in_2n,
    output wire [WIDTH:0] out_zero
);

    wire [WIDTH:0] onesComp; // One's Comp
    // +1 needs to be compensated in PP reductions

    assign onesComp     = ~{1'b0, in};
    assign out_in       = {1'b0, in};
    assign out_in_n     = onesComp;
    assign out_in_2     = {in, 1'b0};
    assign out_in_2n    = {onesComp[WIDTH-1:0], 1'b1};
    assign out_zero     = 0;

endmodule

`default_nettype wire