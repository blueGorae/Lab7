`include "opcodes.v"

module HazardDetectionUnit(clk, reset_n, MemRead_ID_EX_out, LWD_rd_ID_EX_out, MemRead_EX_MEM_out, LWD_rd_EX_MEM_out, new_instruction, PCWrite, IF_ID_Write, ControlNOP);
    input clk, reset_n;

    input MemRead_ID_EX_out;
    input [1:0] LWD_rd_ID_EX_out;
    input MemRead_EX_MEM_out;
    input [1:0] LWD_rd_EX_MEM_out;
    input [`WORD_SIZE-1:0] new_instruction;
    
    output PCWrite;
    output IF_ID_Write;
    output ControlNOP;

    reg PCWrite;
    reg IF_ID_Write;
    reg ControlNOP;


    initial begin 
        PCWrite <= 1'b1;
        IF_ID_Write <= 1'b1;
        ControlNOP <= 1'b0;
    end

    always @(negedge reset_n) begin
        PCWrite <= 1'b1;
        IF_ID_Write <= 1'b1;
        ControlNOP <= 1'b0; 
    end

    always @(*) begin

        PCWrite = 1'b1;
        IF_ID_Write = 1'b1;
        ControlNOP = 1'b0;

        // if(MemRead_EX_MEM_out && ((LWD_rd_EX_MEM_out == new_instruction[11:10]) || (LWD_rd_EX_MEM_out== new_instruction[9:8]))) begin
        //     PCWrite = 0;
        //     IF_ID_Write = 0;
        //     ControlNOP = 1;
        // end

        if(MemRead_ID_EX_out && ((LWD_rd_ID_EX_out == new_instruction[11:10]) || (LWD_rd_ID_EX_out== new_instruction[9:8]))) begin
            PCWrite = 0;
            IF_ID_Write = 0;
            ControlNOP = 1;
        end
    end
endmodule


