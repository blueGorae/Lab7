`include "opcodes.v"

module ForwardUnit(clk, reset_n, rd_EX_MEM_out, rd_MEM_WB_out, rs_ID_EX_out, rt_ID_EX_out, forwardA, forwardB);
    input clk, reset_n;

    input [1:0] rd_EX_MEM_out;
    input [1:0] rd_MEM_WB_out;
    input [1:0] rs_ID_EX_out;
    input [1:0] rt_ID_EX_out;

    output [1:0] forwardA;
    output [1:0] forwardB;

    reg [1:0] forwardA;
    reg [1:0] forwardB;

    initial begin
        forwardA <= 2'b0;
        forwardB <= 2'b0;
    end

    always @(negedge reset_n) begin
        forwardA <= 2'b0;
        forwardB <= 2'b0;
    end

    always @(posdege clk)
        