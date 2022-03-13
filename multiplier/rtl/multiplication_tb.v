// Title: 32-bit Radix-4 Multiplication Test Bench V 1.0 (No Changelog)
// Created: Janurary 10, 2022
// Updated: Janurary 10, 2022
//---------------------------------------------------------------------------
// This is a Verilog file that defined for testing radix-4 32 bit
// multiplication
//
//---------------------------------------------------------------------------
`timescale 1ps/1ps
`default_nettype none

module multiplication_tb;
    reg     [15:0] in_a, in_b;
    wire    [31:0] product;

    integer i, j, passed, failed;

    // Testing
    reg [31:0] expected;

    multiplication mul(.in_a(in_a), .in_b(in_b), .prod(product));

    initial begin
        passed = 0; failed = 0;
        for(i=0; i<=65_535; i=i+1) begin // all combinations
            in_a = i;
            for (j=0; j<=65_535; j=j+1) begin
                in_b = j;
                expected = in_a*in_b;
            #10;
            end
        end
        $display("All tests were passed succesfully: %d", passed);
        $finish;
    end
    always @(expected) begin
        #1 if(product == expected)
            passed = passed + 1;
        else begin
            $display("Last test was failed.");
            failed = failed + 1;
            $finish;
        end
    end

endmodule