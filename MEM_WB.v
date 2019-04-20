`include "opcodes.v"

module MEM_WB( clk, reset_n, MemData_in, ALU_Result_in, rd_in, MemtoReg_in, RegWrite_in, MemData_out, ALU_Result_out, rd_out, MemtoReg_out, RegWrite_out, is_WB);

    input clk, reset_n;

    input [`WORD_SIZE-1 : 0] MemData_in;
    input [`WORD_SIZE-1 : 0] ALU_Result_in;
    input [1:0] rd_in;
    input MemtoReg_in;
    input RegWrite_in;

    output [`WORD_SIZE-1 : 0] MemData_out;
    output [`WORD_SIZE-1 : 0] ALU_Result_out;
    output [1:0] rd_out;
    output MemtoReg_out;
    output RegWrite_out;

    output is_WB;

    reg [`WORD_SIZE-1 : 0] MemData_out;
    reg [`WORD_SIZE-1 : 0] ALU_Result_out;
    reg [1:0] rd_out;
    reg MemtoReg_out;
    reg RegWrite_out;

    reg is_WB;

    reg [`WORD_SIZE-1 : 0] MemData_reg;
    reg [`WORD_SIZE-1 : 0] ALU_Result_reg;
    reg [1:0] rd_reg;
    reg MemtoReg_reg;
    reg RegWrite_reg;


    initial begin
        MemData_reg <= `WORD_SIZE'bz;
        ALU_Result_reg <= `WORD_SIZE'bz;
        rd_reg <= 2'bz;
        MemtoReg_reg <= 1'bz;
        RegWrite_reg <= 1'bz;
        is_WB <= 0;        
    end

    always @(negedge reset_n) begin
        MemData_reg <= `WORD_SIZE'bz;
        ALU_Result_reg <= `WORD_SIZE'bz;
        rd_reg <= 2'bz;
        MemtoReg_reg <= 1'bz;
        RegWrite_reg <= 1'bz;
        is_WB <= 0;
    end

    always @(posedge clk) begin

        MemData_out <= MemData_reg;
        ALU_Result_out <= ALU_Result_reg;
        rd_out <= rd_reg;
        MemtoReg_out <= MemtoReg_reg;
        RegWrite_out <= RegWrite_reg;

        MemData_reg <= MemData_in;
        ALU_Result_reg <= ALU_Result_in;
        rd_reg <= rd_in;
        MemtoReg_reg <= MemtoReg_in;
        RegWrite_reg <= RegWrite_in;
    end
    
endmodule // 