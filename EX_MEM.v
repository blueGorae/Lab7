`include "opcodes.v"

module EX_MEM( Clk, Reset_N, target_address, B_cond, ALU_Result, r_data2, rd, MemRead, MemWrite, B_OP, RegWrite, MemtoReg);
    input Clk, Reset_N;
    inout [`WORD_SIZE-1 : 0] target_address;
    inout B_cond;
    inout [`WORD_SIZE-1 : 0] ALU_Result;
    inout [`WORD_SIZE-1 : 0] r_data2;
    inout [1:0] rd;
    inout MemRead, MemWrite;
    inout B_OP;
    inout RegWrite;
    inout MemtoReg;

    //control bits
    inout MemRead = MemRead_reg;
    inout MemWrite = MemWrite_reg;
    inout B_OP = B_OP_reg;
    inout RegWrite = RegWrite_reg;
    inout PCSource = PCSource_reg;
    

    reg [`WORD_SIZE-1 : 0] target_address_reg;
    reg B_cond_reg;
    reg [`WORD_SIZE-1 : 0] ALU_Result_reg;
    reg [`WORD_SIZE-1 : 0] r_data2_reg;
    reg [1:0] rd_reg;
    reg MemRead_reg;
    reg MemWrite_reg;
    reg B_OP_reg;
    reg RegWrite_reg;
    reg MemtoReg_reg;

    assign target_address = target_address_reg;
    assign B_cond = B_cond_reg;
    assign ALU_Result = ALU_Result_reg;
    assign r_data2 = r_data2_reg;
    assign rd = rd_reg;
    assign MemRead = MemRead_reg;
    assign MemWrite = MemWrite_reg;
    assign B_OP = B_OP_reg;
    assign RegWrite = RegWrite_reg;
    assign MemtoReg = MemtoReg_reg;

    initial begin
        target_address_reg <= `WORD_SIZE'bz;
        B_cond_reg <= 1'bz;
        ALU_Result_reg <= `WORD_SIZE'bz;
        r_data2_reg <= `WORD_SIZE'bz;
        rd_reg <= 2'bz;
        MemRead_reg <= 1'bz;
        MemWrite_reg <= 1'bz;
        B_OP_reg <= 1'bz;
        RegWrite_reg <= 1'bz;
        MemtoReg_reg <= 1'bz;
    end

    always @(negedge Reset_N) begin
        target_address_reg <= `WORD_SIZE'bz;
        B_cond_reg <= 1'bz;
        ALU_Result_reg <= `WORD_SIZE'bz;
        r_data2_reg <= `WORD_SIZE'bz;
        rd_reg <= 2'bz;
        MemRead_reg <= 1'bz;
        MemWrite_reg <= 1'bz;
        B_OP_reg <= 1'bz;
        RegWrite_reg <= 1'bz;
        MemtoReg_reg <= 1'bz;
    end

    always @(posedge Clk) begin
        target_address_reg <= target_address;
        B_cond_reg <= B_cond;
        ALU_Result_reg <= ALU_Result;
        r_data2_reg <= r_data2;
        rd_reg <= rd;
        MemRead_reg <= MemRead;
        MemWrite_reg <= MemWrite;
        B_OP_reg <= B_OP;
        RegWrite_reg <= RegWrite;
        MemtoReg_reg <= MemtoReg;
    end

endmodule // 