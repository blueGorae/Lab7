`include "register.v"
`include "ALU.v"
`include "opcodes.v"
`include "immGenerator.v"
`include "IF_ID.v"
`include "ID_EX.v"
`include "EX_MEM.v"
`include "MEM_WB.v"

module Datapath (Clk, Reset_N, readM1, address1, data1, readM2, writeM2, address2, data2, num_inst, output_port, is_halted);
    
    wire ALUOp, ALUSrcB, MemRead, MemWrite, B_OP, RegWrite, MemtoReg;


    input Reset_N, Clk; 

    //instruction
    input [`WORD_SIZE-1:0] data1; 
    output readM1;
    output [`WORD_SIZE-1:0] address1;	

    //Memory Data
    inout [`WORD_SIZE-1:0] data1; 
    output readM2;
    output writeM2;								
    output [`WORD_SIZE-1:0] address2; //address that we refer
    
    output [`WORD_SIZE-1:0] num_inst;		// number of instruction during execution (for debuging & testing purpose)
	output [`WORD_SIZE-1:0] output_port;	// this will be used for a "WWD" instruction
	output is_halted;

    wire [`WORD_SIZE-1:0] data_out;
    wire readM;									
    wire writeM;								
    wire [`WORD_SIZE-1:0] address;	

    wire [`WORD_SIZE-1:0] num_inst;		// number of instruction during execution (for debuging & testing purpose)
	wire [`WORD_SIZE-1:0] output_port;	// this will be used for a "WWD" instruction
	wire is_halted;

    wire [`WORD_SIZE-1:0] instruction; //instruction
    assign instruction = data1;

    reg [`WORD_SIZE-1:0] MemData; // Data read from the memory
    reg [`WORD_SIZE-1:0] reg_num_inst;
    wire [1:0] rs;
    wire [1:0] rt;
    wire [1:0] rd;
    wire [5:0] func;
    wire [`WORD_SIZE-1:0] imm;
    wire [3:0] opcode;
    wire R_type, I_type, J_type, S_type, L_type;
    

    wire [`WORD_SIZE-1:0] w_data;
    wire [`WORD_SIZE-1:0] r_data1; // register file from rs
    wire [`WORD_SIZE-1:0] r_data2; // register file from rt

    wire [`WORD_SIZE-1:0] ALU_Result; // result of ALU operation
    wire [`WORD_SIZE-1:0] ALUIn_A; // ALU operand A
    wire [`WORD_SIZE-1:0] ALUIn_B; // ALU operand B


    wire B_cond; // Branch condition

    reg [`WORD_SIZE-1:0] PC;
    //reg [`WORD_SIZE-1:0] next_PC;
    

    reg [2:0]current_state;
    reg [2:0]next_state;

    initial 
    begin
	    PC <= 0;
        reg_num_inst <= 0;     
        instruction <= 0;
        MemData <= 0;
        ALUOut <= 0;
        current_state <= -1;
        next_state <= 0;
    end

    always @(negedge reset_n) begin
	    PC <= 0;
        reg_num_inst <= 0;     
        instruction <= 0;
        MemData <= 0;
        ALUOut <= 0;
        current_state <= -1;
        next_state <= 0;
    end

    
    //this is depends on previous clock control bits. careful
    always @(posedge clk) begin
        current_state <= next_state;
    end

    IF_ID if_id(Clk, Reset_N, PC, instruction);

    assign rs = instruction[11:10];
    assign rt = instruction[9:8];
    assign rd = J_type ? 2 : ( R_type ? instruction[7:6] : (( I_type || S_type ) ? instruction[9:8]: 2'bz)) ; 
    assign opcode = instruction[`WORD_SIZE-1:12];
    assign func = instruction[5:0];
    immGenerator immG(Clk, Reset_N, instruction, imm);
    register registers(Clk, Reset_N, rs, rt, rd, w_data, RegWrite, r_data1, r_data2);


    ID_EX id_ex(Clk, Reset_N, PC, r_data1, r_data2, imm, opcode, rd, ALUOp, ALUSrcB, MemRead, MemWrite, B_OP, RegWrite, MemtoReg);
    assign ALUIn_A = ALUSrcA ? r_data1 : PC ;
    assign ALUIn_B = ALUSrcB[1] ? (ALUSrcB[0] ? 0 : imm) : (ALUSrcB[0] ? 1 : r_data2);
    ALU alu(Clk, Reset_N, ALUIn_A, ALUIn_B, B_OP, ALUOp, opcode, ALU_Result, B_cond);

    EX_MEM ex_mem( Clk, Reset_N, target_address, B_cond, ALU_Result, r_data2, rd, MemRead, MemWrite, B_OP, RegWrite, MemtoReg);

    
    MEM_WB mem_wb( Clk, Reset_N, MemData, ALU_Result, rd, MemtoReg, RegWrite);


    assign w_data =  MemtoReg ? MemData : (J_type ? ALUOut : ALU_Result);
    assign address = IorD ? ALU_Result : PC ;
    assign data_out = S_type ? r_data2 : ALU_Result;
    assign readM = MemRead;
    assign writeM = MemWrite;
    assign output_port = r_data1;
    assign num_inst = reg_num_inst;
    

endmodule