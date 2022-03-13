// Title: Booth Selector V 1.0 (No Changelog)
// Created: Septmeber 10, 2021
// Updated: Janurary 10, 2022
//---------------------------------------------------------------------------
// This is a Verilog file that define a Modified Booth Selector for radix-4
// partial product generation
//
//---------------------------------------------------------------------------
`default_nettype none

module boothSel #(parameter WIDTH = 16) (
    input wire  single,                     // The single input to the Selector
    input wire  double,                     // The double input to the Selector
    input wire  neg,                        // The neg input to the Selector
    input wire  [WIDTH:0] in,             // The input to the Selector
    input wire  [WIDTH:0] in_n,           // The input to the Selector
    input wire  [WIDTH:0] in_2,           // The input to the Selector
    input wire  [WIDTH:0] in_2n,          // The input to the Selector
    input wire  [WIDTH:0] zero,           // The input to the Selector
    output  reg [WIDTH:0] out     // The output to the Selector
);

    always @(*) begin
            // This genrates the outputs to the Selector
        case ({single, double, neg})
            3'b000: out = zero;
            3'b100: out = in;
            3'b010: out = in_2;
            3'b011: out = in_2n;
            3'b101: out = in_n;
            3'b001: out = zero;
            default: out = zero;
        endcase
    end
    
endmodule

`default_nettype wire