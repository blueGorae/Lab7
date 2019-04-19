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


module	Datapath (clk, reset_n, readM1, address1, data1, readM2, writeM2, address2, data2, num_inst, output_port, is_halted);
    wire is_WB;
    reg is_WB_reg;
    wire RegWrite;
	wire ALUSrcB;
	wire MemWrite;
	wire [2:0]ALUOp;
	wire MemtoReg;
	wire MemRead;
	wire readM1;
	wire B_OP;
	wire R_type, I_type, J_type, S_type, L_type;
	wire is_wwd;
    wire halted_op;

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

    wire [`WORD_SIZE-1:0] instruction; //instruction
    wire [`WORD_SIZE-1:0] MemData; // Data read from the memory
    reg [`WORD_SIZE-1:0] num_inst_reg;
    wire [1:0] rs;
    wire [1:0] rt;
    wire [1:0] rd;
    wire [5:0] func;
    wire [`WORD_SIZE-1:0] imm;
    wire [3:0] opcode;
 

    wire [`WORD_SIZE-1:0] target_address;

    wire [`WORD_SIZE-1:0] w_data;
    wire [`WORD_SIZE-1:0] r_data1; // register file from rs
    wire [`WORD_SIZE-1:0] r_data2; // register file from rt

    wire [`WORD_SIZE-1:0] ALU_Result; // result of ALU operation
    wire [`WORD_SIZE-1:0] ALUIn_A; // ALU operand A
    wire [`WORD_SIZE-1:0] ALUIn_B; // ALU operand B

    wire B_cond; // Branch condition

    reg [`WORD_SIZE-1:0] PC;
    wire [`WORD_SIZE-1:0] PC_wire;
    wire [`WORD_SIZE-1:0] PC_next;
    
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
    assign PC_wire = PC;
    Adder add1(clk, reset_n, PC_wire, `WORD_SIZE'b1, opcode, PC_next);

    IF_ID if_id(clk, reset_n, PC_wire, data1);
    assign instruction = data1;

    assign rs = instruction[11:10];
    assign rt = instruction[9:8];
    assign rd = J_type ? 2 : ( R_type ? instruction[7:6] : (( I_type || S_type ) ? instruction[9:8]: 2'bz)) ; 
    assign opcode = instruction[`WORD_SIZE-1:12];
    assign func = instruction[5:0];
    immGenerator immG(clk, reset_n, instruction, imm);
    register registers(clk, reset_n, rs, rt, rd, w_data, RegWrite, r_data1, r_data2);

    //ControlUnit ~~
    ControlUnit controlUnit(clk, reset_n, instruction, RegWrite, ALUSrcB, MemWrite, ALUOp, MemtoReg, MemRead, readM1, B_OP, is_wwd, halted_op, R_type, I_type, J_type, S_type, L_type);
    ID_EX id_ex(clk, reset_n, PC_wire, r_data1, r_data2, imm, opcode, rd, ALUOp, ALUSrcB, MemRead, MemWrite, B_OP, RegWrite, MemtoReg);
    assign ALUIn_A = r_data1;
    assign ALUIn_B = ALUSrcB ? imm : r_data2;

    Adder targetAddressAdder(clk, reset_n, PC, imm, opcode, target_address);
    ALU alu(clk, reset_n, ALUIn_A, ALUIn_B, B_OP, ALUOp, opcode, ALU_Result, B_cond);

    EX_MEM ex_mem( clk, reset_n, target_address, B_cond, ALU_Result, r_data2, rd, MemRead, MemWrite, B_OP, RegWrite, MemtoReg);
    //assign readM1 = 1; // TODO : stall implementation
    assign readM2 = MemRead ;
    assign writeM2 = MemWrite;
    assign address1 = (B_cond && B_OP) ? target_address : PC_next;
    assign address2 = (MemRead || MemWrite) ? ALU_Result : `WORD_SIZE'bz;
    assign MemData = data2;

    MEM_WB mem_wb( clk, reset_n, MemData, ALU_Result, rd, MemtoReg, RegWrite, is_WB);

    assign w_data =  MemtoReg ? MemData : ALU_Result;
    assign output_port = r_data1;
    assign num_inst = num_inst_reg;
    

endmodule