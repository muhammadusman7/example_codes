// Title: Single bit Half Adder V 1.0 (No Changelog)
// Created: Septmeber 09, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a Half Adder.
// 
//
//---------------------------------------------------------------------------
`default_nettype none

module halfAdder (   
    input wire  a,              // The two-bit inputs to the Half Adder
    input wire  b,
    output wire c_out,              // The two-bit outputs to the Half Adder
    output wire s 
);
    
    assign {c_out, s} = a + b;
            // Actual operation is to map it to HA Std Cell

endmodule

`default_nettype wire