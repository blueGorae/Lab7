`include "opcodes.v"

module IF_ID(clk, reset_n, IF_ID_Write, flush_signal, PC_in, Instruction_in, PC_out, Instruction_out);
    input clk, reset_n;
    input IF_ID_Write;
    input flush_signal;

    input [`WORD_SIZE-1:0] PC_in, Instruction_in;

    output [`WORD_SIZE-1:0] PC_out, Instruction_out;

    reg [`WORD_SIZE-1:0] PC_out, Instruction_out;


    initial begin
        PC_out <= `WORD_SIZE'bz;
        Instruction_out <= `WORD_SIZE'bz;

    end

    always @(negedge reset_n) begin
        PC_out <= `WORD_SIZE'bz;
        Instruction_out <= `WORD_SIZE'bz;
    end

    always @(posedge clk) begin
        if(reset_n)begin
            if(flush_signal) begin
                PC_out <= `WORD_SIZE'bz;
                Instruction_out <= `WORD_SIZE'bz;
            end
            else begin
                PC_out <= IF_ID_Write ? PC_in : PC_out;
                Instruction_out <= IF_ID_Write ? Instruction_in : Instruction_out;
            end
            //$display("%h", Instruction_in);
        end
        // else begin
        //     PC_out <= `WORD_SIZE'bz;
        //     Instruction_out <= `WORD_SIZE'bz;
        // end
    end


endmodule