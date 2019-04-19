`include "opcodes.v"

module ID_EX(Clk, Reset_N, PC, r_data1, r_data2, imm, opcode, rd, ALUOp, ALUSrcB, MemRead, MemWrite, B_OP, RegWrite, PCSource);
    input Clk, Reset_N;
    inout [`WORD_SIZE-1:0] PC;
    inout [`WORD_SIZE-1:0] r_data1, r_data2, imm;
    inout [3:0] opcode;

    inout [1:0] rd;
    
    inout [2:0] ALUOp;
    inout [1:0] ALUSrcB;
    inout MemRead, MemWrite;
    inout B_OP;
    inout RegWrite;
    inout [1:0] PCSource;
    
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
    reg [1:0] PCSource_reg;

    wire [`WORD_SIZE-1:0] PC_out;
    wire [`WORD_SIZE-1:0] r_data1_out, r_data2_out, imm_out;
    wire [3:0] opcode_out;
    wire [1:0] rd_out;
    wire [2:0] ALUOp_out;
    wire [1:0] ALUSrcB_out;
    wire MemRead_out;
    wire MemWrite_out;
    wire B_OP_out;
    wire RegWrite_out;
    wire [1:0] PCSource_out;

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
    assign PCSource = PCSource_reg;


    always @(negedge Reset_N) begin
        PC_reg = `WORD_SIZE'bz;
        r_data1_reg = `WORD_SIZE'bz';
        r_data2_reg = `WORD_SIZE'bz;
        imm_reg = `WORD_SIZE'bz';
        opcode_reg = 4'bz;
        rd_reg = 2'bz;
        ALUOp_reg = 3'bz;
        ALUSrcB_reg = 2'bz;
        MemRead_reg = 1'bz;
        MemWrite_reg = 1'bz;
        B_OP_reg = 1'bz;
        RegWrite_reg = 1'bz;
        PCSource_reg = 2'bz;

    end

    always @(posedge Clk) begin
        PC_reg = PC;
        r_data1_reg = r_data1;
        r_data2_reg = r_data2;
        imm_reg = imm;
        opcode_reg = opcode;
        rd_reg = rd;
        ALUOp_reg = ALUOp;
        ALUSrcB_reg = ALUSrcB;
        MemRead_reg = MemRead;
        MemWrite_reg = MemWrite;
        B_OP_reg = B_OP;
        RegWrite_reg = RegWrite;
        PCSource_reg = PCSource;
    end
endmodule