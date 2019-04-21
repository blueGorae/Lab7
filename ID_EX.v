`include "opcodes.v"

module ID_EX(clk, reset_n, contolNOP, PC_in, r_data1_in, r_data2_in, imm_in, opcode_in, rs_in, rt_in, rd_in, ALUOp_in, ALUSrcB_in, MemRead_in, MemWrite_in, RegWrite_in, MemtoReg_in, is_wwd_in, is_done_in, halted_op_in, PC_out, r_data1_out, r_data2_out, imm_out, opcode_out, rs_out, rt_out, rd_out, ALUOp_out, ALUSrcB_out, MemRead_out, MemWrite_out, RegWrite_out, MemtoReg_out, is_wwd_out, is_done_out, halted_op_out);
    input clk, reset_n;
    input controlNOP;

    input [`WORD_SIZE-1:0] PC_in;
    input [`WORD_SIZE-1:0] r_data1_in, r_data2_in, imm_in;
    input [3:0] opcode_in;
    input [1:0] rs_in;
    input [1:0] rt_in;
    input [1:0] rd_in;
    input [2:0] ALUOp_in;
    input ALUSrcB_in;
    input MemRead_in, MemWrite_in;
    input RegWrite_in;
    input MemtoReg_in;
    input is_wwd_in;
    input is_done_in;
    input halted_op_in;

    output [`WORD_SIZE-1:0] PC_out;
    output [`WORD_SIZE-1:0] r_data1_out, r_data2_out, imm_out;
    output [3:0] opcode_out;
    output [1:0] rs_out;
    output [1:0] rt_out;
    output [1:0] rd_out;
    output [2:0] ALUOp_out;
    output ALUSrcB_out;
    output MemRead_out, MemWrite_out;
    output RegWrite_out;
    output MemtoReg_out;
    output is_wwd_out;
    output is_done_out;
    output halted_op_out;

    reg [`WORD_SIZE-1:0] PC_out;
    reg [`WORD_SIZE-1:0] r_data1_out, r_data2_out, imm_out;
    reg [3:0] opcode_out;
    reg [1:0] rs_out;
    reg [1:0] rt_out;
    reg [1:0] rd_out;
    reg [2:0] ALUOp_out;
    reg ALUSrcB_out;
    reg MemRead_out, MemWrite_out;
    reg RegWrite_out;
    reg MemtoReg_out;
    reg is_wwd_out;
    reg is_done_out;
    reg halted_op_out;

    integer i;

    initial begin
        i = 0;
        PC_out = `WORD_SIZE'bz;
        r_data1_out = `WORD_SIZE'bz;
        r_data2_out = `WORD_SIZE'bz;
        imm_out = `WORD_SIZE'bz;
        opcode_out = 4'bz;
        rs_out = 2'bz;
        rt_out = 2'bz;
        rd_out = 2'bz;
        ALUOp_out = 3'bz;
        ALUSrcB_out = 2'b0;
        MemRead_out = 1'b0;
        MemWrite_out = 1'b0;
        RegWrite_out = 1'b0;
        MemtoReg_out = 2'b0;
        is_wwd_out = 1'b0;
        is_done_out = 1'b0;
        halted_op_out = 1'b0;

    end

    always @(negedge reset_n) begin
        i = 0;
        PC_out = `WORD_SIZE'bz;
        r_data1_out = `WORD_SIZE'bz;
        r_data2_out = `WORD_SIZE'bz;
        imm_out = `WORD_SIZE'bz;
        opcode_out = 4'bz;
        rs_out = 2'bz;
        rt_out = 2'bz;
        rd_out = 2'bz;
        ALUOp_out = 3'bz;
        ALUSrcB_out = 2'b0;
        MemRead_out = 1'b0;
        MemWrite_out = 1'b0;
        RegWrite_out = 1'b0;
        MemtoReg_out = 2'b0;
        is_wwd_out = 1'b0;
        is_done_out = 1'b0;
        halted_op_out = 1'b0;

    end

    always @(posedge clk) begin
        if(reset_n &&  i >= 1)begin
            PC_out = PC_in;
            r_data1_out = r_data1_in;
            r_data2_out = r_data2_in;
            imm_out = imm_in;
            opcode_out = opcode_in;
            rs_out = rs_in;
            rt_out = rt_in;
            rd_out = rd_in;
            
        end
        if(!controlNOP) begin
            ALUOp_out = ALUOp_in;
            ALUSrcB_out = ALUSrcB_in;
            MemRead_out = MemRead_in;
            MemWrite_out = MemWrite_in;
            RegWrite_out = RegWrite_in;
            MemtoReg_out = MemtoReg_in; 
            is_wwd_out = is_wwd_in; 
            is_done_out = is_done_in;
            halted_op_out = halted_op_in;
        end
        else if(controlNOP) begin
            ALUOp_out = 3'b0;
            ALUSrcB_out = 1'b0;
            MemRead_out = 1'b0;
            MemWrite_out = 1'b0;
            RegWrite_out = 1'b0;
            MemtoReg_out = 1'b0; 
            is_wwd_out = 1'b0; 
            is_done_out = 1'b0;
            halted_op_out = 1'b0;
            
        end
        else if(reset_n) begin
            i = i + 1;
        end
    end

endmodule