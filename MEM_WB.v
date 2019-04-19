`include "opcodes.v"

module MEM_WB( clk, reset_n, MemData, ALU_Result, rd, MemtoReg, RegWrite, is_WB);

    input clk, reset_n;
    inout [`WORD_SIZE-1 : 0] MemData;
    inout [`WORD_SIZE-1 : 0] ALU_Result;
    inout [1:0] rd;
    inout MemtoReg;
    inout RegWrite;

    output is_WB;

    reg is_WB;
    reg [`WORD_SIZE-1 : 0] MemData_reg;
    reg [`WORD_SIZE-1 : 0] ALU_Result_reg;
    reg [1:0] rd_reg;
    reg MemtoReg_reg;
    reg RegWrite_reg;

    assign MemData = MemData_reg;
    assign ALU_Result = ALU_Result_reg;
    assign rd = rd_reg;
    assign MemtoReg = MemtoReg_reg;
    assign RegWrite = RegWrite_reg;

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
        MemData_reg <= MemData;
        ALU_Result_reg <= ALU_Result;
        rd_reg <= rd;
        MemtoReg_reg <= MemtoReg;
        RegWrite_reg <= RegWrite;
        is_WB <= 1;
    end
    
endmodule // 