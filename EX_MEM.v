`include "opcodes.v"

module EX_MEM( clk, reset_n, EX_MEM_Write, PC_in, func_in, opcode_in, ALU_Result_in, r_data1_in, r_data2_in, rd_in, MemRead_in, MemWrite_in, RegWrite_in, MemtoReg_in, is_wwd_in, is_done_in, halted_op_in, PC_out, func_out, opcode_out, ALU_Result_out, r_data1_out, r_data2_out, rd_out, MemRead_out, MemWrite_out, RegWrite_out, MemtoReg_out, is_wwd_out, is_done_out, halted_op_out);
    input clk, reset_n;
    input EX_MEM_Write;
    input [`WORD_SIZE-1 : 0] PC_in;
    input [5:0] func_in;
    input [3:0] opcode_in;
    input [`WORD_SIZE-1 : 0] ALU_Result_in;
    input [`WORD_SIZE-1 : 0] r_data1_in;
    input [`WORD_SIZE-1 : 0] r_data2_in;
    input [1:0] rd_in;
    input MemRead_in, MemWrite_in;
    input RegWrite_in;
    input MemtoReg_in;
    input is_wwd_in;
    input is_done_in;
    input halted_op_in;

    output [`WORD_SIZE-1 : 0] PC_out;
    output [5:0] func_out;
    output [3:0] opcode_out;
    output [`WORD_SIZE-1 : 0] ALU_Result_out;
    output [`WORD_SIZE-1 : 0] r_data1_out;
    output [`WORD_SIZE-1 : 0] r_data2_out;
    output [1:0] rd_out;
    output MemRead_out, MemWrite_out;
    output RegWrite_out;
    output MemtoReg_out;
    output is_wwd_out;
    output is_done_out;
    output halted_op_out;

    reg [`WORD_SIZE-1 : 0] PC_out;
    reg [5:0] func_out;
    reg [3:0] opcode_out;
    reg [`WORD_SIZE-1 : 0] ALU_Result_out;
    reg [`WORD_SIZE-1 : 0] r_data1_out;
    reg [`WORD_SIZE-1 : 0] r_data2_out;
    reg [1:0] rd_out;
    reg MemRead_out, MemWrite_out;
    reg RegWrite_out;
    reg MemtoReg_out;
    reg is_wwd_out;
    reg is_done_out;
    reg halted_op_out;

    integer i;

    initial begin
        i <= 0;
        PC_out <= `WORD_SIZE'bz;
        func_out <= 6'bz;
        opcode_out <= 4'bz;

        ALU_Result_out <= `WORD_SIZE'bz;
        r_data1_out <= `WORD_SIZE'bz;
        r_data2_out <= `WORD_SIZE'bz;
        rd_out <= 2'bz;
        MemRead_out <= 1'b0;
        MemWrite_out <= 1'b0;
        RegWrite_out <= 1'b0;
        MemtoReg_out <= 1'b0;
        is_wwd_out <= 1'b0;
        is_done_out <= 1'b0;
        halted_op_out <= 1'b0;

    end

    always @(negedge reset_n) begin
        i <= 0;
        PC_out <= `WORD_SIZE'bz;
        func_out <= 6'bz;
        opcode_out <= 4'bz;
        ALU_Result_out <= `WORD_SIZE'bz;
        r_data1_out <= `WORD_SIZE'bz;
        r_data2_out <= `WORD_SIZE'bz;
        rd_out <= 2'bz;
        MemRead_out <= 1'b0;
        MemWrite_out <= 1'b0;
        RegWrite_out <= 1'b0;
        MemtoReg_out <= 1'b0;
        is_wwd_out <= 1'b0;
        is_done_out <= 1'b0;
        halted_op_out <= 1'b0;

    end

    always @(posedge clk) begin
        if(reset_n && i >=2)begin
            PC_out <= EX_MEM_Write ? PC_in : PC_out;
            func_out <= EX_MEM_Write ? func_in : func_out;
            opcode_out <= EX_MEM_Write ? opcode_in : opcode_out;
            ALU_Result_out <= EX_MEM_Write ? ALU_Result_in : ALU_Result_out;
            r_data1_out <= EX_MEM_Write ? r_data1_in : r_data1_out;
            r_data2_out <= EX_MEM_Write ? r_data2_in : r_data2_out;
            rd_out <= EX_MEM_Write ? rd_in : rd_out;
            MemRead_out <= EX_MEM_Write ? MemRead_in : MemRead_out;
            MemWrite_out <= EX_MEM_Write ? MemWrite_in : MemWrite_out;
            RegWrite_out <= EX_MEM_Write ? RegWrite_in : RegWrite_out;
            MemtoReg_out <= EX_MEM_Write ? MemtoReg_in : MemtoReg_out;
            is_wwd_out <= EX_MEM_Write ? is_wwd_in : is_wwd_out;
            is_done_out <= EX_MEM_Write ? is_done_in : is_done_out;
            halted_op_out <= EX_MEM_Write ? halted_op_in : halted_op_out;

        end
        else if(reset_n) begin
            i <= i + 1;
        end
    end

endmodule 