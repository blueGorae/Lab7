`include "opcodes.v"

module PC(clk, reset_n, PCWrite, PC_in, PC_out);
    input clk, reset_n;
    input PCWrite;
    input [`WORD_SIZE-1 : 0] PC_in;
    output [`WORD_SIZE-1 : 0] PC_out;

    reg [`WORD_SIZE-1 : 0] PC_out;

    initial begin
        PC_out = `WORD_SIZE'b0;
    end

    always @(negedge reset_n) begin
        PC_out = `WORD_SIZE'b0;
    end

    always @(posedge clk) begin
        if(reset_n) begin 
            PC_out = PCWrite ? PC_in : PC_out;
        end
    end

endmodule


