`timescale 1ns/1ps
`default_nettype none

module alu #(
    parameter WIDTH = 16
) (
    input   wire                clk, rst_n,     // Active low reset
    input   wire [WIDTH-1:0]    in0, in1,
    input   wire [2:0]          opcode,
    output  reg  [WIDTH-1:0]    out,
    output  reg  overflow
);
    reg     [WIDTH-1:0] reg_in0, reg_in1;  // Registers to store input
    reg     [2:0]       reg_opcode;
    reg     [WIDTH-1:0] wire_out;
    reg                 wire_overflow;
    
    // Input Registers
    always @(posedge clk) begin                 // Sync reset
        if (~rst_n) begin
            reg_in0 <= 'd0;
            reg_in1 <= 'd0;
            reg_opcode <= 3'd0;

        end else begin
            reg_in0 <= in0;
            reg_in1 <= in1;
            reg_opcode <= opcode;
        end
    end

    always @(*) begin
        case (reg_opcode)
            3'b000: {wire_overflow, wire_out} = reg_in0 + reg_in1;              // Sum
            3'b001: {wire_overflow, wire_out} = reg_in0 - reg_in1;              // Subtraction
            3'b010: {wire_overflow, wire_out} = reg_in0 * reg_in1;              // Multiplication
            3'b011: {wire_overflow, wire_out} = reg_in0 * reg_in1 + reg_in0;    // MAC operation
            3'b100: {wire_overflow, wire_out} = reg_in0 * reg_in1 - reg_in0;    // Multiply and subtract
            3'b101: wire_out = reg_in0 > reg_in1 ? 'd1 : 'd0;                   // Greater
            3'b110: wire_out = reg_in0 < reg_in1 ? 'd1 : 'd0;                   // Smaller
            3'b111: wire_out = reg_in0 == reg_in1 ? 'd1 : 'd0;                  // Equal
            
            default: wire_overflow = 1'b0;
        endcase
    end

    always @(posedge clk) begin                 // Sync reset
        if (~rst_n) begin
            overflow <= 1'b0;
            out <= 'd0;
        end else begin
            overflow <= wire_overflow;
            out <= wire_out;
        end
    end
    
endmodule
