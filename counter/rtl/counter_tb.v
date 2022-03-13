`timescale 1ns/1ps

module counter_tb;

    parameter WIDTH = 4;
    reg clk, rst_n, en, dn, load;
    reg [WIDTH-1:0] data;
    wire [WIDTH-1:0] count;

    initial begin
        forever #5 clk = ~clk;      // Clock period is 10 time units
    end
    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_tb);
        clk = 1'b0; rst_n = 1'b1; en = 1'b0; dn = 1'b0; load = 1'b0; data = 7;
        #3 rst_n = 1'b0; #5 rst_n = 1'b1;
        #5 en = 1'b1; #5;
        #30 load = 1'b1; #10 load = 1'b0;
        #20 dn = 1'b1; #20 dn = 1'b0;
        #15 en = 1'b0;
        #30 load = 1'b1; #10 load = 1'b0;
        #20 dn = 1'b1; #20 dn = 1'b0;
        #10 en = 1'b1; 
        #30 $finish();
    end

    counter # (.WIDTH(WIDTH)) dut (.clk(clk), .rst_n(rst_n), .en(en), .dn(dn), 
        .load(load), .data(data), .count(count));
    
endmodule