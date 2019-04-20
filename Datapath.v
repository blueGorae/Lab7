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


module	Datapath datapath(clk, reset_n, readM1, address1, data1, readM2, writeM2, address2, data2, num_inst, output_port, is_halted);
    reg is_WB;

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


    reg [`WORD_SIZE-1:0] PC;
    wire [`WORD_SIZE-1:0] PC_next;

    //IF_ID_in
    wire [`WORD_SIZE-1:0] PC_IF_ID_in;
    wire [`WORD_SIZE-1:0] instruction_IF_ID_in;
    //IF_ID_out
    wire [`WORD_SIZE-1:0] PC_IF_ID_out;
    wire [`WORD_SIZE-1:0] instruction_IF_ID_out;

    //ID_EX_in
    wire RegWrite_ID_EX_in;
    wire ALUSrcB_ID_EX_in;
    wire MemWrite_ID_EX_in;
    wire [2:0]ALUOp_ID_EX_in;
    wire MemtoReg_ID_EX_in;
    wire B_OP_ID_EX_in;
    wire R_type_ID_EX_in;
    wire I_type_ID_EX_in;
    wire J_type_ID_EX_in;
    wire S_type_ID_EX_in;
    wire L_type_ID_EX_in;
    wire is_wwd_ID_EX_in;
    wire halted_op_ID_EX_in;
    wire [`WORD_SIZE-1:0] PC_ID_EX_in;
    wire [`WORD_SIZE-1:0] r_data1_ID_EX_in; // register file from rs
    wire [`WORD_SIZE-1:0] r_data2_ID_EX_in; // register file from rt
    wire [`WORD_SIZE-1:0] imm_ID_EX_in; // register file from rs
    wire [3:0] opcode_ID_EX_in;
    wire [1:0] rd_ID_EX_in;
    //ID_EX_out
    wire RegWrite_ID_EX_out;
    wire ALUSrcB_ID_EX_out;
    wire MemWrite_ID_EX_out;
    wire [2:0]ALUOp_ID_EX_out;
    wire MemtoReg_ID_EX_out;
    wire RegWrite_ID_EX_out;
    wire B_OP_ID_EX_out;
    wire R_type_ID_EX_out;
    wire I_type_ID_EX_out;
    wire J_type_ID_EX_out;
    wire S_type_ID_EX_out;
    wire L_type_ID_EX_out;
    wire is_wwd_ID_EX_out;
    wire halted_op_ID_EX_out;
    wire [`WORD_SIZE-1:0] PC_ID_EX_out;
    wire [`WORD_SIZE-1:0] r_data1_ID_EX_out; // register file from rs
    wire [`WORD_SIZE-1:0] r_data2_ID_EX_out; // register file from rt
    wire [`WORD_SIZE-1:0] imm_ID_EX_out; // register file from rs
    wire [3:0] opcode_ID_EX_out;
    wire [1:0] rd_ID_EX_out;

    //EX_MEM_in
    wire RegWrite_EX_MEM_in;
    wire MemWrite_EX_MEM_in;
    wire MemtoReg_EX_MEM_in;
    wire B_OP_EX_MEM_in;
    wire is_wwd_EX_MEM_in;
    wire halted_op_EX_MEM_in;
    wire [`WORD_SIZE-1: 0] target_address_EX_MEM_in;
    wire B_cond_EX_MEM_in;
    wire [`WORD_SIZE-1:0] ALU_Result_EX_MEM_in;
    wire [`WORD_SIZE-1:0] r_data2_EX_MEM_in; // register file from rt
    wire [1:0] rd_EX_MEM_in;
    //EX_MEM_out
    wire RegWrite_EX_MEM_out;
    wire MemWrite_EX_MEM_out;
    wire MemtoReg_EX_MEM_out;
    wire B_OP_EX_MEM_out;
    wire is_wwd_EX_MEM_out;
    wire halted_op_EX_MEM_out;
    wire [`WORD_SIZE-1: 0] target_address_EX_MEM_out;
    wire B_cond_EX_MEM_out;
    wire [`WORD_SIZE-1:0] ALU_Result_EX_MEM_out;
    wire [`WORD_SIZE-1:0] r_data2_EX_MEM_out;
    wire [1:0] rd_EX_MEM_out;

    //MEM_WB_in
    wire RegWrite_MEM_WB_in;
    wire MemtoReg_MEM_WB_in;
    wire is_wwd_MEM_WB_in;
    wire halted_op_MEM_WB_in;
    wire [`WORD_SIZE-1:0] MemData_MEM_EX_in;
    wire [`WORD_SIZE-1:0] ALU_Result_MEM_WB_in;
    wire [1:0] rd_MEM_WB_in;
    //MEM_WB_out
    wire RegWrite_MEM_WB_out;
    wire MemtoReg_MEM_WB_out;
    wire is_wwd_MEM_WB_out;
    wire halted_op_MEM_WB_out;
    wire [`WORD_SIZE-1:0] MemData_MEM_EX_out;
    wire [`WORD_SIZE-1:0] ALU_Result_MEM_WB_out;
    wire [1:0] rd_MEM_WB_out;

    initial 
    begin
	    PC <= 0;
        num_inst_reg <= 0;     
        is_WB_reg <=0 ;
    end

    always @(negedge reset_n) begin
	    PC <= 0;
        num_inst_reg <= 0;     
        is_WB_reg <=0 ;
    end

    
    //this is depends on previous clock control bits. careful
    always @(*) begin
        if(is_WB) begin
            num_inst_reg = num_inst_reg + 1;
        end
    end

    assign is_WB = is_WB_reg;
    Adder add1(clk, reset_n, PC_wire, `WORD_SIZE'b1, opcode, PC_next);

    IF_ID if_id(clk, reset_n, PC_wire, data1, );
    //assign instruction = data1;

    assign rs = data1[11:10];
    assign rt = data1[9:8];
    assign rd = J_type ? 2 : ( R_type ? data1[7:6] : (( I_type || S_type ) ? data1[9:8]: 2'bz)) ; 
    assign opcode = data1[`WORD_SIZE-1:12];
    assign func = data1[5:0];
    immGenerator immG(clk, reset_n, data1, imm);
    register registers(clk, reset_n, rs, rt, rd, w_data, RegWrite, r_data1, r_data2);

    ControlUnit controlUnit(clk, reset_n, data1, RegWrite, ALUSrcB, MemWrite, ALUOp, MemtoReg, MemRead, readM1, B_OP, is_wwd, halted_op, R_type, I_type, J_type, S_type, L_type);
    
    ID_EX id_ex(clk, reset_n, PC_wire, r_data1, r_data2, imm, opcode, rd, ALUOp, ALUSrcB, MemRead, MemWrite, B_OP, RegWrite, MemtoReg);
    assign ALUIn_A = r_data1;
    assign ALUIn_B = ALUSrcB ? imm : r_data2;

    Adder targetAddressAdder(clk, reset_n, PC, imm, opcode, target_address);
    ALU alu(clk, reset_n, ALUIn_A, ALUIn_B, B_OP, ALUOp, opcode, ALU_Result, B_cond);

    EX_MEM ex_mem( clk, reset_n, target_address, B_cond, ALU_Result, r_data2, rd, MemRead, MemWrite, B_OP, RegWrite, MemtoReg);
    assign readM1 = 1; // TODO : stall implementation
    assign readM2 = MemRead ;
    assign writeM2 = MemWrite;
    assign address1 = PC;
    assign address2 = (MemRead || MemWrite) ? ALU_Result : `WORD_SIZE'b0;
    assign MemData = data2;

    MEM_WB mem_wb( clk, reset_n, MemData, ALU_Result, rd, MemtoReg, RegWrite, is_WB);

    assign w_data =  MemtoReg ? MemData : ALU_Result;
    assign output_port = r_data1;
    assign num_inst = num_inst_reg;
    

endmodule