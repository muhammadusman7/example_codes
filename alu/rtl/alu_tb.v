`timescale 1ns/1ps
`default_nettype none

module alu_tb;

    parameter WIDTH = 16;
    integer i;
    reg     [WIDTH-1:0] in0, in1;
    reg     [2:0] opcode;
    reg     clk, rst_n;
    wire    [WIDTH-1:0] out;
    wire    overflow;

    initial begin
        $dumpfile(alu.vcd);
        $dumpvars(0, alu_tb);
        clk = 1'b0; rst_n = 1'b1; opcode = 3'b0;
        in0 = 'd0; in1 = 'd0;
        #2 rst_n = 1'b0; #10 rst_n = 1'b1;
        in0 = 'd4; in1 = 'd20;
        for (i = 0; i<=7; i = i+1) begin
            #10 opcode = i;
        end
        #10 $finish();
    end

    initial begin
        forever #5 clk = ~clk;
    end

    alu #(.WIDTH(WIDTH)) alu_ut (.clk(clk), .rst_n(rst_n), .in0(in0), .in1(in1), .opcode(opcode), .out(out), .overflow(overflow));

endmodule