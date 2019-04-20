`include "opcodes.v"

module IF_ID(clk, reset_n, flush_signal, IF_ID_Write, PC_in, Instruction_in, PC_out, Instruction_out);
    input clk, reset_n;
    input flush_signal;
    input IF_ID_Write;
    
    input [`WORD_SIZE-1:0] PC_in, Instruction_in;

    output [`WORD_SIZE-1:0] PC_out, Instruction_out;

    reg [`WORD_SIZE-1:0] PC_out, Instruction_out;


    initial begin
        PC_out = `WORD_SIZE'bz;
        Instruction_out = `WORD_SIZE'bz;

    end

    always @(negedge reset_n) begin
        PC_out = `WORD_SIZE'bz;
        Instruction_out = `WORD_SIZE'bz;
    end

    always @(posedge clk) begin
        if(reset_n)begin
            PC_out = IF_ID_Write ? PC_in : `WORD_SIZE'bz;
            Instruction_out = IF_ID_Write ? Instruction_in : `WORD_SIZE'bz;
        end
    end

    always @(*) begin
        if(flush_signal) begin
            PC_out = `WORD_SIZE'bz;
            Instruction_out = `WORD_SIZE'bz;
        end
    end 

endmodule