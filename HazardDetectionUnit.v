`include "opcodes.v"

module HazardDetectionUnit(clk, reset_n, MemRead, LWD_rd, new_instruction, PCWrite, IF_ID_Write, ControlNOP);
    input clk, reset_n;

    input MemRead;
    input [1:0] LWD_rd;
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

        if(MemRead && ((LWD_rd == new_instruction[11:10]) || (LWD_rd == new_instruction[9:8]))) begin
            PCWrite <= 0;
            IF_ID_Write <= 0;
            ControlNOP <= 1;
        end
        else begin 
            PCWrite <= 1'b1;
            IF_ID_Write <= 1'b1;
            ControlNOP <= 1'b0;
        end
    end
endmodule


