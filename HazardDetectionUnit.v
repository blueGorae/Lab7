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

    reg [1:0] new_rs;
    reg [1:0] new_rt;

    initial begin 
        PCWrite = 1'b1;
        IF_ID_Write = 1'b1;
        ControlNOP = 1'b0;
        new_rs = 2'bz;
        new_rt = 2'bz;
    end

    always @(negedge reset_n) begin
        PCWrite = 1'b1;
        IF_ID_Write = 1'b1;
        ControlNOP = 1'b0; 
        new_rs = 2'bz;
        new_rt = 2'bz;
    end

    always @(posedge clk) begin
        new_rs = new_instruction[11:10];
        new_rt = new_instruction[9:8];

        if(MemRead && ((LWD_rd == new_rs) || (LWD_rd == new_rt))) begin
            PCWrite = 0;
            IF_ID_Write = 0;
            ControlNOP = 1;
        end
        else begin 
            PCWrite = 1'b1;
            IF_ID_Write = 1'b1;
            ControlNOP = 1'b0;
        end
    end
endmodule


