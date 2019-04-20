`include "opcodes.v"

module EX_MEM( clk, reset_n, target_address_in, B_cond_in, ALU_Result_in, r_data1_in, r_data2_in, rd_in, PCSrc_in, MemRead_in, MemWrite_in, B_OP_in, RegWrite_in, MemtoReg_in, is_wwd_in, target_address_out, B_cond_out, ALU_Result_out, r_data1_out, r_data2_out, rd_out, PCSrc_out, MemRead_out, MemWrite_out, B_OP_out, RegWrite_out, MemtoReg_out, is_wwd_out);
    input clk, reset_n;

    input [`WORD_SIZE-1 : 0] target_address_in;
    input B_cond_in;
    input [`WORD_SIZE-1 : 0] ALU_Result_in;
    input [`WORD_SIZE-1 : 0] r_data1_in;
    input [`WORD_SIZE-1 : 0] r_data2_in;
    input [1:0] rd_in;
    input [1:0] PCSrc_in;
    input MemRead_in, MemWrite_in;
    input B_OP_in;
    input RegWrite_in;
    input MemtoReg_in;
    input is_wwd_in;

    output [`WORD_SIZE-1 : 0] target_address_out;
    output B_cond_out;
    output [`WORD_SIZE-1 : 0] ALU_Result_out;
    output [`WORD_SIZE-1 : 0] r_data1_out;
    output [`WORD_SIZE-1 : 0] r_data2_out;
    output [1:0] rd_out;
    output [1:0] PCSrc_out;
    output MemRead_out, MemWrite_out;
    output B_OP_out;
    output RegWrite_out;
    output MemtoReg_out;
    output is_wwd_out;

    reg [`WORD_SIZE-1 : 0] target_address_out;
    reg B_cond_out;
    reg [`WORD_SIZE-1 : 0] ALU_Result_out;
    reg [`WORD_SIZE-1 : 0] r_data1_out;
    reg [`WORD_SIZE-1 : 0] r_data2_out;
    reg [1:0] rd_out;
    reg [1:0] PCSrc_out;
    reg MemRead_out, MemWrite_out;
    reg B_OP_out;
    reg RegWrite_out;
    reg MemtoReg_out;
    reg is_wwd_out;

    // reg [`WORD_SIZE-1 : 0] target_address_reg;
    // reg B_cond_reg;
    // reg [`WORD_SIZE-1 : 0] ALU_Result_reg;
    // reg [`WORD_SIZE-1 : 0] r_data1_reg;
    // reg [`WORD_SIZE-1 : 0] r_data2_reg;
    // reg [1:0] rd_reg;
    // reg [1:0] PCSrc_reg;
    // reg MemRead_reg;
    // reg MemWrite_reg;
    // reg B_OP_reg;
    // reg RegWrite_reg;
    // reg MemtoReg_reg;
    // reg is_wwd_reg;

    integer i;

    initial begin
        i = 0;
        target_address_out = `WORD_SIZE'bz;
        B_cond_out = 1'bz;
        ALU_Result_out = `WORD_SIZE'bz;
        r_data1_out = `WORD_SIZE'bz;
        r_data2_out = `WORD_SIZE'bz;
        rd_out = 2'bz;
        PCSrc_out = 2'b0;
        MemRead_out = 1'b0;
        MemWrite_out = 1'b0;
        B_OP_out = 1'b0;
        RegWrite_out = 1'b0;
        MemtoReg_out = 1'b0;
        is_wwd_out = 1'b0;

        // target_address_out = target_address_reg;
        // B_cond_out = B_cond_reg;
        // ALU_Result_out = ALU_Result_reg;
        // r_data1_out = r_data1_reg;
        // r_data2_out = r_data2_reg;
        // rd_out = rd_reg;
        // PCSrc_out = PCSrc_reg;
        // MemRead_out = MemRead_reg;
        // MemWrite_out = MemWrite_reg;
        // B_OP_out = B_OP_reg;
        // RegWrite_out = RegWrite_reg;
        // MemtoReg_out = MemtoReg_reg;
        // is_wwd_out = is_wwd_reg;
    end

    always @(negedge reset_n) begin
        i = 0;
        target_address_out = `WORD_SIZE'bz;
        B_cond_out = 1'bz;
        ALU_Result_out = `WORD_SIZE'bz;
        r_data1_out = `WORD_SIZE'bz;
        r_data2_out = `WORD_SIZE'bz;
        rd_out = 2'bz;
        PCSrc_out = 2'b0;
        MemRead_out = 1'b0;
        MemWrite_out = 1'b0;
        B_OP_out = 1'b0;
        RegWrite_out = 1'b0;
        MemtoReg_out = 1'b0;
        is_wwd_out = 1'b0;

        // target_address_out = target_address_reg;
        // B_cond_out = B_cond_reg;
        // ALU_Result_out = ALU_Result_reg;
        // r_data1_out = r_data1_reg;
        // r_data2_out = r_data2_reg;
        // rd_out = rd_reg;
        // PCSrc_out = PCSrc_reg;
        // MemRead_out = MemRead_reg;
        // MemWrite_out = MemWrite_reg;
        // B_OP_out = B_OP_reg;
        // RegWrite_out = RegWrite_reg;
        // MemtoReg_out = MemtoReg_reg;
        // is_wwd_out = is_wwd_reg;

    end

    always @(posedge clk) begin
        if(reset_n && i >=2)begin
            target_address_out = target_address_in;
            B_cond_out = B_cond_in;
            ALU_Result_out = ALU_Result_in;
            r_data1_out = r_data1_in;
            r_data2_out = r_data2_in;
            rd_out = rd_in;
            PCSrc_out = PCSrc_in;
            MemRead_out = MemRead_in;
            MemWrite_out = MemWrite_in;
            B_OP_out = B_OP_in;
            RegWrite_out = RegWrite_in;
            MemtoReg_out = MemtoReg_in;
            is_wwd_out = is_wwd_in;

            // target_address_reg = target_address_in;
            // B_cond_reg = B_cond_in;
            // ALU_Result_reg = ALU_Result_in;
            // r_data1_reg = r_data1_in;
            // r_data2_reg = r_data2_in;
            // rd_reg = rd_in;
            // PCSrc_reg = PCSrc_in;
            // MemRead_reg = MemRead_in;
            // MemWrite_reg = MemWrite_in;
            // B_OP_reg = B_OP_in;
            // RegWrite_reg = RegWrite_in;
            // MemtoReg_reg = MemtoReg_in;
            // is_wwd_reg = is_wwd_in;
        end
        else if(reset_n) begin
            i = i + 1;
        end
    end

endmodule // 