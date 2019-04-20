`include "opcodes.v"

module ID_EX(clk, reset_n, PC, r_data1, r_data2, imm, opcode, rd, ALUOp, ALUSrcB, MemRead, MemWrite, B_OP, RegWrite, MemtoReg, PC, r_data1, r_data2, imm, opcode, rd, ALUOp, ALUSrcB, MemRead, MemWrite, B_OP, RegWrite, MemtoReg);
    
    input clk, reset_n;
    
    input [`WORD_SIZE-1:0] PC_in;
    input [`WORD_SIZE-1:0] r_data1_in, r_data2_in, imm_in;
    input [3:0] opcode_in;
    input [1:0] rd_in;
    input [2:0] ALUOp_in;
    input ALUSrcB_in;
    input MemRead, MemWrite_in;
    input B_OP_in;
    input RegWrite_in;
    input MemtoReg_in;

    output [`WORD_SIZE-1:0] PC_out;
    output [`WORD_SIZE-1:0] r_data1, r_data2, imm;
    output [3:0] opcode;
    output [1:0] rd;
    output [2:0] ALUOp;
    output ALUSrcB;
    output MemRead, MemWrite;
    output B_OP;
    output RegWrite;
    output MemtoReg;

    reg [`WORD_SIZE-1:0] PC_reg;
    reg [`WORD_SIZE-1:0] r_data1_reg, r_data2_reg, imm_reg;
    reg [3:0] opcode_reg;
    reg [1:0] rd_reg;
    reg [2:0] ALUOp_reg;
    reg [1:0] ALUSrcB_reg;
    reg MemRead_reg;
    reg MemWrite_reg;
    reg B_OP_reg;
    reg RegWrite_reg;
    reg MemtoReg_reg;

    assign PC = PC_reg;
    assign r_data1 = r_data1_reg;
    assign r_data2 = r_data2_reg;
    assign imm = imm_reg;
    assign opcode = opcode_reg;
    assign rd = rd_reg;
    assign ALUOp = ALUOp_reg;
    assign ALUSrcB = ALUSrcB_reg;
    assign MemRead = MemRead_reg;
    assign MemWrite = MemWrite_reg;
    assign B_OP = B_OP_reg;
    assign RegWrite = RegWrite_reg;
    assign MemtoReg = MemtoReg_reg;

    initial begin
        PC_reg <= `WORD_SIZE'bz;
        r_data1_reg <= `WORD_SIZE'bz;
        r_data2_reg <= `WORD_SIZE'bz;
        imm_reg <= `WORD_SIZE'bz;
        opcode_reg <= 4'bz;
        rd_reg <= 2'bz;
        ALUOp_reg <= 3'bz;
        ALUSrcB_reg <= 2'bz;
        MemRead_reg <= 1'bz;
        MemWrite_reg <= 1'bz;
        B_OP_reg <= 1'bz;
        RegWrite_reg <= 1'bz;
        MemtoReg_reg <= 2'bz;
    end

    always @(negedge reset_n) begin
        PC_reg <= `WORD_SIZE'bz;
        r_data1_reg <= `WORD_SIZE'bz;
        r_data2_reg <= `WORD_SIZE'bz;
        imm_reg <= `WORD_SIZE'bz;
        opcode_reg <= 4'bz;
        rd_reg <= 2'bz;
        ALUOp_reg <= 3'bz;
        ALUSrcB_reg <= 2'bz;
        MemRead_reg <= 1'bz;
        MemWrite_reg <= 1'bz;
        B_OP_reg <= 1'bz;
        RegWrite_reg <= 1'bz;
        MemtoReg_reg <= 2'bz;
    end

    always @(posedge clk) begin
        PC_reg <= PC;
        r_data1_reg <= r_data1;
        r_data2_reg <= r_data2;
        imm_reg <= imm;
        opcode_reg <= opcode;
        rd_reg <= rd;
        ALUOp_reg <= ALUOp;
        ALUSrcB_reg <= ALUSrcB;
        MemRead_reg <= MemRead;
        MemWrite_reg <= MemWrite;
        B_OP_reg <= B_OP;
        RegWrite_reg <= RegWrite;
        MemtoReg_reg <= MemtoReg;
    end
endmodule