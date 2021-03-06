// Title: Carry Look Ahead Adder V 1.0 (No Changelog)
// Created: Septmeber 09, 2021
// Updated: Janurary 10, 2022
//---------------------------------------------------------------------------
// This is a Verilog file that define a 4-bit Carry Lookahead Adder.
// 
//
//---------------------------------------------------------------------------
`default_nettype none

module claAdder4 (
    input wire  [3:0]   in_a,
    input wire  [3:0]   in_b,
    input wire  c_in,
    output wire [3:0]   s,
    output wire c_out
);

    wire [3:0] p, g, c;
    // Level 1
    assign c[0] = c_in;
    assign p[3:0] = in_a[3:0] ^ in_b[3:0];
    assign g[3:0] = in_a[3:0] & in_b[3:0];
    // Level 2
    assign c[1] = g[0] | (p[0] & c_in);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c_in);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c_in);
    // Level 3
    assign c_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c_in);
    assign s[3:0] = p[3:0] ^ c[3:0];
    
endmodule

`default_nettype wire