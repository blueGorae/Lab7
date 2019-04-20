`include "register.v"
`include "ALU.v"
`include "opcodes.v"
`include "immGenerator.v"
`include "IF_ID.v"
`include "ID_EX.v"
`include "EX_MEM.v"
`include "MEM_WB.v"
`include "Adder.v"
`include "ControlUnit.v"
`include "FlushUnit.v"
`include "PC.v"


module	Datapath(clk, reset_n, readM1, address1, data1, readM2, writeM2, address2, data2, num_inst, output_port, is_halted);
    wire is_WB;

    input reset_n;
    input clk; 

    //instruction
    input [`WORD_SIZE-1:0] data1; 
    output readM1;
    output [`WORD_SIZE-1:0] address1;	

    //Memory Data
    inout [`WORD_SIZE-1:0] data2; 
    output readM2;
    output writeM2;								
    output [`WORD_SIZE-1:0] address2; //address that we refer
    
    output [`WORD_SIZE-1:0] num_inst;		// number of instruction during execution (for debuging & testing purpose)
	output [`WORD_SIZE-1:0] output_port;	// this will be used for a "WWD" instruction
	output is_halted;


    reg [`WORD_SIZE-1:0] num_inst_reg;
    wire [1:0] rs;
    wire [1:0] rt;
    wire [1:0] rd;
    wire [5:0] func;

    wire [`WORD_SIZE-1:0] w_data;
    
    wire [`WORD_SIZE-1:0] ALUIn_A; // ALU operand A
    wire [`WORD_SIZE-1:0] ALUIn_B; // ALU operand B


    // reg [`WORD_SIZE-1:0] PC;
    //reg [`WORD_SIZE-1:0] PC_reg;
    wire [`WORD_SIZE-1:0] PC_in;
    wire [`WORD_SIZE-1:0] PC_out;
    wire [`WORD_SIZE-1:0] PC_next;

    wire flush_signal;

    //IF_ID_in
    wire [`WORD_SIZE-1:0] PC_IF_ID_in;
    wire [`WORD_SIZE-1:0] instruction_IF_ID_in;
    //IF_ID_out
    wire [`WORD_SIZE-1:0] PC_IF_ID_out;
    wire [`WORD_SIZE-1:0] instruction_IF_ID_out;

    //ID_EX_in
    wire [1:0] PCSrc_ID_EX_in;
    wire RegWrite_ID_EX_in;
    wire ALUSrcB_ID_EX_in;
    wire MemWrite_ID_EX_in;
    wire [2:0]ALUOp_ID_EX_in;
    wire MemtoReg_ID_EX_in;
    wire B_OP_ID_EX_in;
    wire R_type;
    wire I_type;
    wire J_type;
    wire S_type;
    wire L_type;
    wire is_wwd_ID_EX_in;
    wire halted_op_ID_EX_in;
    wire [`WORD_SIZE-1:0] PC_ID_EX_in;
    wire [`WORD_SIZE-1:0] r_data1_ID_EX_in; // register file from rs
    wire [`WORD_SIZE-1:0] r_data2_ID_EX_in; // register file from rt
    wire [`WORD_SIZE-1:0] imm_ID_EX_in; // register file from rs
    wire [3:0] opcode_ID_EX_in;
    wire [1:0] rd_ID_EX_in;
    //ID_EX_out
    wire [1:0] PCSrc_ID_EX_out;
    wire RegWrite_ID_EX_out;
    wire ALUSrcB_ID_EX_out;
    wire MemWrite_ID_EX_out;
    wire [2:0]ALUOp_ID_EX_out;
    wire MemtoReg_ID_EX_out;
    wire B_OP_ID_EX_out;
    wire is_wwd_ID_EX_out;
    wire halted_op_ID_EX_out;
    wire [`WORD_SIZE-1:0] PC_ID_EX_out;
    wire [`WORD_SIZE-1:0] r_data1_ID_EX_out; // register file from rs
    wire [`WORD_SIZE-1:0] r_data2_ID_EX_out; // register file from rt
    wire [`WORD_SIZE-1:0] imm_ID_EX_out; // register file from rs
    wire [3:0] opcode_ID_EX_out;
    wire [1:0] rd_ID_EX_out;

    //EX_MEM_in
    wire [1:0] PCSrc_EX_MEM_in;
    wire RegWrite_EX_MEM_in;
    wire MemWrite_EX_MEM_in;
    wire MemtoReg_EX_MEM_in;
    wire B_OP_EX_MEM_in;
    wire is_wwd_EX_MEM_in;
    wire halted_op_EX_MEM_in;
    wire [`WORD_SIZE-1: 0] target_address_EX_MEM_in;
    wire B_cond_EX_MEM_in;
    wire [`WORD_SIZE-1:0] ALU_Result_EX_MEM_in;
    wire [`WORD_SIZE-1:0] r_data1_EX_MEM_in; // register file from rs
    wire [`WORD_SIZE-1:0] r_data2_EX_MEM_in; // register file from rt
    wire [1:0] rd_EX_MEM_in;
    //EX_MEM_out
    wire [1:0] PCSrc_EX_MEM_out;
    wire RegWrite_EX_MEM_out;
    wire MemWrite_EX_MEM_out;
    wire MemtoReg_EX_MEM_out;
    wire B_OP_EX_MEM_out;
    wire is_wwd_EX_MEM_out;
    wire halted_op_EX_MEM_out;
    wire [`WORD_SIZE-1: 0] target_address_EX_MEM_out;
    wire B_cond_EX_MEM_out;
    wire [`WORD_SIZE-1:0] ALU_Result_EX_MEM_out;
    wire [`WORD_SIZE-1:0] r_data1_EX_MEM_out; // register file from rs
    wire [`WORD_SIZE-1:0] r_data2_EX_MEM_out;
    wire [1:0] rd_EX_MEM_out;

    //MEM_WB_in
    wire RegWrite_MEM_WB_in;
    wire MemtoReg_MEM_WB_in;
    wire is_wwd_MEM_WB_in;
    wire halted_op_MEM_WB_in;
    wire [`WORD_SIZE-1:0] MemData_MEM_WB_in;
    wire [`WORD_SIZE-1:0] ALU_Result_MEM_WB_in;
    wire [1:0] rd_MEM_WB_in;
    //MEM_WB_out
    wire RegWrite_MEM_WB_out;
    wire MemtoReg_MEM_WB_out;
    wire is_wwd_MEM_WB_out;
    wire halted_op_MEM_WB_out;
    wire [`WORD_SIZE-1:0] MemData_MEM_WB_out;
    wire [`WORD_SIZE-1:0] ALU_Result_MEM_WB_out;
    wire [1:0] rd_MEM_WB_out;

    initial 
    begin
        num_inst_reg <= 0;     
    end

    always @(negedge reset_n) begin
        
        num_inst_reg <= 0;     
    end

    //this is depends on previous clock control bits. careful
    always @(*) begin
        if(is_WB) begin
            num_inst_reg = num_inst_reg + 1;
        end
    end

    assign PC_in = (PCSrc_EX_MEM_out==2) ? r_data1_EX_MEM_out : (((B_cond_EX_MEM_out && B_OP_EX_MEM_out) || (PCSrc_EX_MEM_out == 1)) ? target_address_EX_MEM_out : PC_next);
    PC pc(clk, reset_n, PC_in, PC_out);


    assign instruction_IF_ID_in = data1;
    assign PC_IF_ID_in = PC_out;
    Adder add1(clk, reset_n, PC_out, `WORD_SIZE'b1, 4'b0000, PC_next);

    IF_ID if_id(clk, reset_n, flush_signal, PC_IF_ID_in, instruction_IF_ID_in, PC_IF_ID_out, instruction_IF_ID_out);
    //assign instruction = data1;

    assign rs = instruction_IF_ID_out[11:10];
    assign rt = instruction_IF_ID_out[9:8];
    assign rd = J_type ? 2 : ( R_type ? instruction_IF_ID_out[7:6] : (( I_type || S_type ) ? instruction_IF_ID_out[9:8]: 2'bz)) ; 
    assign opcode = instruction_IF_ID_out[`WORD_SIZE-1:12];
    assign func = instruction_IF_ID_out[5:0];
    immGenerator immG(clk, reset_n, instruction_IF_ID_out, imm_ID_EX_in);
    register registers(clk, reset_n, rs, rt, rd, w_data, RegWrite_MEM_WB_out, r_data1_ID_EX_in, r_data2_ID_EX_in);

    ControlUnit controlUnit(clk, reset_n, instruction_IF_ID_out, PCSrc_ID_EX_in, RegWrite_ID_EX_in, ALUSrcB_ID_EX_in, MemWrite_ID_EX_in, ALUOp_ID_EX_in, MemtoReg_ID_EX_in, MemRead_ID_EX_in, readM1, B_OP_ID_EX_in, is_wwd, halted_op, R_type, I_type, J_type, S_type, L_type);
    assign PC_ID_EX_in = PC_IF_ID_out;
    assign rd_ID_EX_in = rd;

    ID_EX id_ex(clk, reset_n, flush_signal, PC_ID_EX_in, r_data1_ID_EX_in, r_data2_ID_EX_in, imm_ID_EX_in, opcode_ID_EX_in, rd_ID_EX_in, PCSrc_ID_EX_in, ALUOp_ID_EX_in, ALUSrcB_ID_EX_in, MemRead_ID_EX_in, MemWrite_ID_EX_in, B_OP_ID_EX_in, RegWrite_ID_EX_in, MemtoReg_ID_EX_in, is_wwd_ID_EX_in, PC_ID_EX_out, r_data1_ID_EX_out, r_data2_ID_EX_out, imm_ID_EX_out, opcode_ID_EX_out, rd_ID_EX_out, PCSrc_ID_EX_out, ALUOp_ID_EX_out, ALUSrcB_ID_EX_out, MemRead_ID_EX_out, MemWrite_ID_EX_out, B_OP_ID_EX_out, RegWrite_ID_EX_out, MemtoReg_ID_EX_out, is_wwd_ID_EX_out);
    assign ALUIn_A = r_data1_ID_EX_out;
    assign ALUIn_B = ALUSrcB_ID_EX_out ? imm_ID_EX_out : r_data2_ID_EX_out;

    Adder targetAddressAdder(clk, reset_n, PC_ID_EX_out, imm_ID_EX_out, opcode_ID_EX_out, target_address_EX_MEM_in);
    ALU alu(clk, reset_n, ALUIn_A, ALUIn_B, B_OP_ID_EX_out, ALUOp_ID_EX_out, opcode_ID_EX_out, ALU_Result_EX_MEM_in, B_cond_EX_MEM_in);

    assign PCSrc_EX_MEM_in = PCSrc_ID_EX_out;
    assign r_data1_EX_MEM_in = r_data1_ID_EX_out;
    assign r_data2_EX_MEM_in = r_data2_ID_EX_out;
    assign rd_EX_MEM_in = rd_ID_EX_out;
    assign MemRead_EX_MEM_in = MemRead_ID_EX_out;
    assign MemWrite_EX_MEM_in = MemWrite_ID_EX_out;
    assign B_OP_EX_MEM_in = B_OP_ID_EX_out;
    assign RegWrite_EX_MEM_in = RegWrite_ID_EX_out;
    assign MemtoReg_EX_MEM_in = MemtoReg_ID_EX_out;
    assign is_wwd_EX_MEM_in = is_wwd_ID_EX_out;

    EX_MEM ex_mem(clk, reset_n, flush_signal, target_address_EX_MEM_in, B_cond_EX_MEM_in, ALU_Result_EX_MEM_in, r_data1_EX_MEM_in, r_data2_EX_MEM_in, rd_EX_MEM_in, PCSrc_EX_MEM_in, MemRead_EX_MEM_in, MemWrite_EX_MEM_in, B_OP_EX_MEM_in, RegWrite_EX_MEM_in, MemtoReg_EX_MEM_in, is_wwd_EX_MEM_in, target_address_EX_MEM_out, B_cond_EX_MEM_out, ALU_Result_EX_MEM_out, r_data1_EX_MEM_out, r_data2_EX_MEM_out, rd_EX_MEM_out, PCSrc_EX_MEM_out ,MemRead_EX_MEM_out, MemWrite_EX_MEM_out, B_OP_EX_MEM_out, RegWrite_EX_MEM_out, MemtoReg_EX_MEM_out, is_wwd_EX_MEM_out);
    assign readM1 = 1; // TODO : stall implementation
    assign readM2 = MemRead_EX_MEM_out;
    assign writeM2 = MemWrite_EX_MEM_out;
    assign address1 = PC_out;
    assign address2 = (MemRead_EX_MEM_out || MemWrite_EX_MEM_out) ? ALU_Result_EX_MEM_out : `WORD_SIZE'b0;
    assign MemData_MEM_WB_in = data2;

    assign ALU_Result_MEM_WB_in = ALU_Result_EX_MEM_out;
    assign rd_MEM_WB_in = rd_EX_MEM_out;
    assign MemtoReg_MEM_WB_in = MemtoReg_EX_MEM_out;
    assign RegWrite_MEM_WB_in = RegWrite_EX_MEM_out;
    assign is_wwd_MEM_WB_in = is_wwd_EX_MEM_out;

    FlushUnit flushUnit(clk, reset_n, PCSrc_EX_MEM_out, B_OP_EX_MEM_out, B_cond_EX_MEM_out, flush_signal);
    
    MEM_WB mem_wb( clk, reset_n, MemData_MEM_WB_in, ALU_Result_MEM_WB_in, rd_MEM_WB_in, MemtoReg_MEM_WB_in, RegWrite_MEM_WB_in, is_wwd_MEM_WB_in, MemData_MEM_WB_out, ALU_Result_MEM_WB_out, rd_MEM_WB_out, MemtoReg_MEM_WB_out, RegWrite_MEM_WB_out, is_wwd_MEM_WB_out, is_WB);

    assign w_data =  MemtoReg_MEM_WB_out ? MemData_MEM_WB_out : ALU_Result_MEM_WB_out;
    assign output_port = r_data1_ID_EX_in;
    assign num_inst = num_inst_reg;
    

endmodule