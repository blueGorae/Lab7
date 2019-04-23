`include "opcodes.v"

module IF_ID(clk, reset_n, IF_ID_Write, is_NOP, flush_signal, PC_in, Instruction_in, PC_out, Instruction_out);
    input clk, reset_n;
    input IF_ID_Write;
    input flush_signal;

    input [`WORD_SIZE-1:0] PC_in, Instruction_in;

    output [`WORD_SIZE-1:0] PC_out, Instruction_out;
    output is_NOP;
    reg is_NOP;

    reg [`WORD_SIZE-1:0] PC_out, Instruction_out;


    initial begin
        PC_out <= `WORD_SIZE'bz;
        Instruction_out <= `WORD_SIZE'bz;
        is_NOP <= 1'b0;

    end

    always @(negedge reset_n) begin
        PC_out <= `WORD_SIZE'bz;
        Instruction_out <= `WORD_SIZE'bz;
        is_NOP <= 1'b0;
    end

    always @(posedge clk) begin
        if(reset_n)begin
                PC_out <= IF_ID_Write ? PC_in : PC_out;
                Instruction_out <= IF_ID_Write ? Instruction_in : Instruction_out;
                is_NOP <= flush_signal ? 1'b1 : 1'b0;
        end
    end


endmodule