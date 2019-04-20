`include "opcodes.v"

module EX_MEM( clk, reset_n, target_address_in, B_cond_in, ALU_Result_in, r_data2_in, rd_in, MemRead_in, MemWrite_in, B_OP_in, RegWrite_in, MemtoReg_in, target_address_out, B_cond_out, ALU_Result_out, r_data2_out, rd_out, MemRead_out, MemWrite_out, B_OP_out, RegWrite_out, MemtoReg_out);
    input clk, reset_n;

    input [`WORD_SIZE-1 : 0] target_address_in;
    input B_cond_in;
    input [`WORD_SIZE-1 : 0] ALU_Result_in;
    input [`WORD_SIZE-1 : 0] r_data2_in;
    input [1:0] rd_in;
    input MemRead_in, MemWrite_in;
    input B_OP_in;
    input RegWrite_in;
    input MemtoReg_in;

    output [`WORD_SIZE-1 : 0] target_address_out;
    output B_cond_out;
    output [`WORD_SIZE-1 : 0] ALU_Result_out;
    output [`WORD_SIZE-1 : 0] r_data2_out;
    output [1:0] rd_out;
    output MemRead_out, MemWrite_out;
    output B_OP_out;
    output RegWrite_out;
    output MemtoReg_out;

    reg [`WORD_SIZE-1 : 0] target_address_out;
    reg B_cond_out;
    reg [`WORD_SIZE-1 : 0] ALU_Result_out;
    reg [`WORD_SIZE-1 : 0] r_data2_out;
    reg [1:0] rd_out;
    reg MemRead_out, MemWrite_out;
    reg B_OP_out;
    reg RegWrite_out;
    reg MemtoReg_out;

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

    initial begin
        target_address_reg <= `WORD_SIZE'bz;
        B_cond_reg <= 1'bz;
        ALU_Result_reg <= `WORD_SIZE'bz;
        r_data2_reg <= `WORD_SIZE'bz;
        rd_reg <= 2'bz;
        MemRead_reg <= 1'b0;
        MemWrite_reg <= 1'b0;
        B_OP_reg <= 1'b0;
        RegWrite_reg <= 1'b0;
        MemtoReg_reg <= 1'b0;
    end

    always @(negedge reset_n) begin
        target_address_reg <= `WORD_SIZE'bz;
        B_cond_reg <= 1'bz;
        ALU_Result_reg <= `WORD_SIZE'bz;
        r_data2_reg <= `WORD_SIZE'bz;
        rd_reg <= 2'bz;
        MemRead_reg <= 1'b0;
        MemWrite_reg <= 1'b0;
        B_OP_reg <= 1'b0;
        RegWrite_reg <= 1'b0;
        MemtoReg_reg <= 1'b0;
    end

    always @(posedge clk) begin

        target_address_out <= target_address_reg;
        B_cond_out <= B_cond_reg;
        ALU_Result_out <= ALU_Result_reg;
        r_data2_out <= r_data2_reg;
        rd_out <= rd_reg;
        MemRead_out <= MemRead_reg;
        MemWrite_out <= MemWrite_reg;
        B_OP_out <= B_OP_reg;
        RegWrite_out <= RegWrite_reg;
        MemtoReg_out <= MemtoReg_reg;

        target_address_reg <= target_address_in;
        B_cond_reg <= B_cond_in;
        ALU_Result_reg <= ALU_Result_in;
        r_data2_reg <= r_data2_in;
        rd_reg <= rd_in;
        MemRead_reg <= MemRead_in;
        MemWrite_reg <= MemWrite_in;
        B_OP_reg <= B_OP_in;
        RegWrite_reg <= RegWrite_in;
        MemtoReg_reg <= MemtoReg_in;
    end

endmodule // 