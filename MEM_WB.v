`include "opcodes.v"

module MEM_WB( Clk, Reset_N, MemData, ALU_Result, rd, MemtoReg, RegWrite);

    input Clk, Reset_N;
    inout [`WORD_SIZE-1 : 0] MemData;
    inout [`WORD_SIZE-1 : 0] ALU_Result;
    inout [1:0] rd;
    inout MemtoReg;
    inout RegWrite;

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
        MemtoReg <= 1'bz;
        RegWrite <= 1'bz;
    end

    always @(negedge Reset_N) begin
        MemData_reg <= `WORD_SIZE'bz;
        ALU_Result_reg <= `WORD_SIZE'bz;
        rd_reg <= 2'bz;
        MemtoReg_reg <= 1'bz;
        RegWrite_reg <= 1'bz;
    end

    always @(posedge Clk) begin
        MemData_reg <= MemData;
        ALU_Result_reg <= ALU_Result;
        rd_reg <= rd;
        MemtoReg_reg <= MemtoReg;
        RegWrite_reg <= RegWrite;
    end
    
endmodule // 