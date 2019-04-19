`include "opcodes.v"

module MEM_WB( Clk, Reset_N, MemData, ALU_Result, rd);

    input Clk, Reset_N;
    inout [`WORD_SIZE-1 : 0] MemData;
    inout [`WORD_SIZE-1 : 0] ALU_Result;
    inout [1:0] rd;

    reg [`WORD_SIZE-1 : 0] MemData_reg;
    reg [`WORD_SIZE-1 : 0] ALU_Result_reg;
    reg [1:0] rd_reg;

    assign MemData = MemData_reg;
    assign ALU_Result = ALU_Result_reg;
    assign rd = rd_reg;

    initial begin
        MemData_reg <= `WORD_SIZE'bz;
        ALU_Result_reg <= `WORD_SIZE'bz;
        rd_reg <= 2'bz;
    end

    always @(negedge Reset_N) begin
        MemData_reg <= `WORD_SIZE'bz;
        ALU_Result_reg <= `WORD_SIZE'bz;
        rd_reg <= 2'bz;
    end

    always @(posedge Clk) begin
        MemData_reg <= MemData;
        ALU_Result_reg <= ALU_Result;
        rd_reg <= rd;
    end
    
endmodule // 