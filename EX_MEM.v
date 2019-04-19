`include "opcodes.v"

module EX_MEM( Clk, Reset_N, target_address, B_cond, ALU_Result, r_data2, rd, );
    input Clk, Reset_N;
    inout [`WORD_SIZE-1 : 0] target_address;
    inout B_cond;
    inout [`WORD_SIZE-1 : 0] ALU_Result;
    inout [`WORD_SIZE-1 : 0] r_data2;
    inout [1:0] rd;

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

    assign target_address = target_address_reg;
    assign B_cond = B_cond_reg;
    assign ALU_Result = ALU_Result_reg;
    assign r_data2 = r_data2_reg;
    assign rd = rd_reg;

    initial begin
        target_address_reg <= `WORD_SIZE'bz;
        B_cond_reg <= 1'bz;
        ALU_Result_reg <= `WORD_SIZE'bz;
        r_data2_reg <= `WORD_SIZE'bz;
        rd_reg <= 2'bz;
    end

    always @(negedge Reset_N) begin
        target_address_reg <= `WORD_SIZE'bz;
        B_cond_reg <= 1'bz;
        ALU_Result_reg <= `WORD_SIZE'bz;
        r_data2_reg <= `WORD_SIZE'bz;
        rd_reg <= 2'bz;
    end

    always @(posedge Clk) begin
        target_address_reg <= target_address;
        B_cond_reg <= B_cond;
        ALU_Result_reg <= ALU_Result;
        r_data2_reg <= r_data2;
        rd_reg <= rd;
    end

endmodule // 