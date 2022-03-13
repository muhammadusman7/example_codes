// Title: Single bit Full Adder V 1.0 (No Changelog)
// Created: Septmeber 09, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a Full Adder.
// 
//
//---------------------------------------------------------------------------
`default_nettype none

module fullAdder (   
    input wire  a,              // The three-bit inputs to the Full Adder
    input wire  b,
    input wire  c_in,
    output wire c_out,              // The two-bit outputs to the Full Adder
    output wire s 
);
    
        assign {c_out, s} = a + b + c_in;    
            // Actual operation is to map it to FA Std Cell

endmodule

`default_nettype wire