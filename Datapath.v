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
`include "HazardDetectionUnit.v"
`include "PC.v"
`include "Comparator.v"
`include "EXForwardUnit.v"
`include "IDForwardUnit.v"

module	Datapath(clk, reset_n, readM1, address1, data1, readM2, writeM2, address2, data2, num_inst, output_port, is_halted);

    input reset_n;
    input clk; 

    //instruction
    input [`WORD_SIZE-1:0] data1; 
    output readM1;
    output [`WORD_SIZE-1:0] address1;	

    //Memory Data
    inout [`WORD_SIZE-1:0] data2;
    wire [`WORD_SIZE-1:0] data2_in;

    wire [`WORD_SIZE-1:0] data2_out;

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


    wire [`WORD_SIZE-1:0] PC_in;
    wire [`WORD_SIZE-1:0] PC_out;
    wire [`WORD_SIZE-1:0] PC_next;

    wire flush_signal;
    wire [1:0] EXforwardA;
    wire [1:0] EXforwardB;
    wire [1:0] IDforwardA;
    wire [1:0] IDforwardB;

    //For HazardDetection
    wire PCWrite;
    wire IF_ID_Write;
    wire ControlNOP;

    wire B_cond;
    wire B_OP;
    wire [`WORD_SIZE-1:0] target_address;
    wire [1:0] PCSrc;

    //IF_ID_in
    wire [`WORD_SIZE-1:0] PC_IF_ID_in;
    wire [`WORD_SIZE-1:0] instruction_IF_ID_in;
    //IF_ID_out
    wire [`WORD_SIZE-1:0] PC_IF_ID_out;
    wire [`WORD_SIZE-1:0] instruction_IF_ID_out;

    wire is_NOP;

    wire RegWrite;
    wire ALUSrcB;
    wire MemWrite;
    wire MemRead;
    wire [2:0]ALUOp;
    wire MemtoReg;
    wire R_type;
    wire I_type;
    wire J_type;
    wire S_type;
    wire L_type;
    wire is_wwd;
    wire halted_op;
    wire is_done;

    //ID_EX_in
    wire RegWrite_ID_EX_in;
    wire ALUSrcB_ID_EX_in;
    wire MemWrite_ID_EX_in;
    wire MemRead_ID_EX_in;
    wire [2:0]ALUOp_ID_EX_in;
    wire MemtoReg_ID_EX_in;
    wire is_wwd_ID_EX_in;
    wire halted_op_ID_EX_in;
    wire [`WORD_SIZE-1:0] PC_ID_EX_in;
    wire [`WORD_SIZE-1:0] r_data1;
    wire [`WORD_SIZE-1:0] r_data2;
    wire [`WORD_SIZE-1:0] r_data1_ID_EX_in; // register file from rs
    wire [`WORD_SIZE-1:0] r_data2_ID_EX_in; // register file from rt
    wire [`WORD_SIZE-1:0] imm_ID_EX_in; // register file from rs
    wire [3:0] opcode_ID_EX_in;
    wire [5:0] func_ID_EX_in;
    wire [1:0] rs_ID_EX_in;
    wire [1:0] rt_ID_EX_in;
    wire [1:0] rd_ID_EX_in;
    wire is_done_ID_EX_in;
    //ID_EX_out
    wire RegWrite_ID_EX_out;
    wire ALUSrcB_ID_EX_out;
    wire MemWrite_ID_EX_out;
    wire MemRead_ID_EX_out;
    wire [2:0]ALUOp_ID_EX_out;
    wire MemtoReg_ID_EX_out;
    wire is_wwd_ID_EX_out;
    wire halted_op_ID_EX_out;
    wire [`WORD_SIZE-1:0] PC_ID_EX_out;
    wire [`WORD_SIZE-1:0] r_data1_ID_EX_out; // register file from rs
    wire [`WORD_SIZE-1:0] r_data2_ID_EX_out; // register file from rt
    wire [`WORD_SIZE-1:0] imm_ID_EX_out; // register file from rs
    wire [3:0] opcode_ID_EX_out;
    wire [5:0] func_ID_EX_out;
    wire [1:0] rs_ID_EX_out;
    wire [1:0] rt_ID_EX_out;
    wire [1:0] rd_ID_EX_out;
    wire is_done_ID_EX_out;

    //EX_MEM_in
    wire [`WORD_SIZE-1:0] PC_EX_MEM_in;
    wire [3:0] opcode_EX_MEM_in;
    wire [5:0] func_EX_MEM_in;
    wire RegWrite_EX_MEM_in;
    wire MemWrite_EX_MEM_in;
    wire MemRead_EX_MEM_in;
    wire MemtoReg_EX_MEM_in;
    wire is_wwd_EX_MEM_in;
    wire halted_op_EX_MEM_in;
    wire [`WORD_SIZE-1:0] ALU_Result_EX_MEM_in;
    wire [`WORD_SIZE-1:0] r_data1_EX_MEM_in; // register file from rs
    wire [`WORD_SIZE-1:0] r_data2_EX_MEM_in; // register file from rt
    wire [1:0] rd_EX_MEM_in;
    wire is_done_EX_MEM_in;
    //EX_MEM_out
    wire [`WORD_SIZE-1:0] PC_EX_MEM_out;
    wire [3:0] opcode_EX_MEM_out;
    wire [5:0] func_EX_MEM_out;
    wire RegWrite_EX_MEM_out;
    wire MemWrite_EX_MEM_out;
    wire MemRead_EX_MEM_out;
    wire MemtoReg_EX_MEM_out;
    wire is_wwd_EX_MEM_out;
    wire halted_op_EX_MEM_out;
    wire [`WORD_SIZE-1:0] ALU_Result_EX_MEM_out;
    wire [`WORD_SIZE-1:0] r_data1_EX_MEM_out; // register file from rs
    wire [`WORD_SIZE-1:0] r_data2_EX_MEM_out;
    wire [1:0] rd_EX_MEM_out;
    wire is_done_EX_MEM_out;


    //MEM_WB_in
    wire [`WORD_SIZE-1:0] PC_MEM_WB_in;
    wire [3:0] opcode_MEM_WB_in;
    wire [5:0] func_MEM_WB_in;
    wire RegWrite_MEM_WB_in;
    wire MemtoReg_MEM_WB_in;
    wire is_wwd_MEM_WB_in;
    wire halted_op_MEM_WB_in;
    wire [`WORD_SIZE-1:0] MemData_MEM_WB_in;
    wire [`WORD_SIZE-1:0] ALU_Result_MEM_WB_in;
    wire [`WORD_SIZE-1:0] r_data1_MEM_WB_in; // register file from rs
    wire [1:0] rd_MEM_WB_in;
    wire is_done_MEM_WB_in;
    //MEM_WB_out
    wire [`WORD_SIZE-1:0] PC_MEM_WB_out;
    wire [3:0] opcode_MEM_WB_out;
    wire [5:0] func_MEM_WB_out;
    wire RegWrite_MEM_WB_out;
    wire MemtoReg_MEM_WB_out;
    wire is_wwd_MEM_WB_out;
    wire halted_op_MEM_WB_out;
    wire [`WORD_SIZE-1:0] MemData_MEM_WB_out;
    wire [`WORD_SIZE-1:0] ALU_Result_MEM_WB_out;
    wire [`WORD_SIZE-1:0] r_data1_MEM_WB_out; // register file from rs
    wire [1:0] rd_MEM_WB_out;
    wire is_done_MEM_WB_out;

    initial 
    begin
        num_inst_reg <= 0;     
    end

    always @(negedge reset_n) begin
        num_inst_reg <= 0;     
    end

    always @(negedge clk) begin
        if(is_done_MEM_WB_out) begin
            num_inst_reg <= num_inst_reg + 1;
        end
    end

    assign PC_in = (PCSrc==2) ? r_data1_ID_EX_in : (((B_cond && B_OP) || (PCSrc == 1)) ? target_address : PC_next);
    PC pc(clk, reset_n, PCWrite, PC_in, PC_out);

    assign instruction_IF_ID_in = data1;
    assign PC_IF_ID_in = PC_next;
    Adder add1(clk, reset_n, PC_out, `WORD_SIZE'b1, 4'b0000, PC_next);

    IF_ID if_id(clk, reset_n, IF_ID_Write, is_NOP, flush_signal, PC_IF_ID_in, instruction_IF_ID_in, PC_IF_ID_out, instruction_IF_ID_out);
    assign opcode_ID_EX_in = instruction_IF_ID_out[`WORD_SIZE-1:12];    
    assign func_ID_EX_in = instruction_IF_ID_out[5:0];
    assign rs = instruction_IF_ID_out[11:10];
    assign rt = instruction_IF_ID_out[9:8];
    assign rd = (opcode_ID_EX_in == `JAL_OP || (opcode_ID_EX_in == `JRL_OP && func_ID_EX_in == `INST_FUNC_JRL)) ? 2 : (R_type ? instruction_IF_ID_out[7:6] : (( I_type &&  !S_type ) ? instruction_IF_ID_out[9:8]: 2'bz)) ; 

    Adder targetAddressAdder(clk, reset_n, PC_IF_ID_out, imm_ID_EX_in, opcode_ID_EX_in, target_address);

    IDForwardUnit IDforwardUnit(clk, reset_n, RegWrite_ID_EX_out, RegWrite_EX_MEM_out, RegWrite_MEM_WB_out, rd_ID_EX_out, rd_EX_MEM_out, rd_MEM_WB_out, rs, rt, IDforwardA, IDforwardB);

    FlushUnit flushUnit(clk, reset_n, is_NOP, PCSrc, B_OP, B_cond , flush_signal);

    immGenerator immG(clk, reset_n, instruction_IF_ID_out, imm_ID_EX_in);
    register registers(clk, reset_n, rs, rt, rd_MEM_WB_out, w_data, RegWrite_MEM_WB_out, r_data1, r_data2);
    HazardDetectionUnit hazardDetectionUnit(clk, reset_n, MemRead_ID_EX_out, rd_ID_EX_out, MemRead_EX_MEM_out, rd_EX_MEM_out, instruction_IF_ID_out, PCWrite, IF_ID_Write, ControlNOP);
    ControlUnit controlUnit(clk, reset_n, instruction_IF_ID_out, PCSrc, RegWrite, ALUSrcB, MemWrite, ALUOp, MemtoReg, MemRead, readM1, B_OP, is_wwd, halted_op, R_type, I_type, J_type, S_type, L_type, is_done);
        
    assign r_data1_ID_EX_in = (IDforwardA == 2'b11) ? ALU_Result_EX_MEM_in : ((IDforwardA == 2'b10) ? ALU_Result_EX_MEM_out : ((IDforwardA == 1) ? w_data : r_data1));
    assign r_data2_ID_EX_in = (IDforwardB == 2'b11) ? ALU_Result_EX_MEM_in : ((IDforwardB == 2'b10) ? ALU_Result_EX_MEM_out : ((IDforwardB == 1) ? w_data : r_data2));
    
    Comparator comparator(clk, reset_n, r_data1_ID_EX_in, r_data2_ID_EX_in, B_OP, opcode_ID_EX_in, B_cond);

    assign RegWrite_ID_EX_in = !(ControlNOP || is_NOP) ? RegWrite : 0;
    assign ALUSrcB_ID_EX_in = !(ControlNOP || is_NOP) ? ALUSrcB : 0;
    assign MemWrite_ID_EX_in = !(ControlNOP || is_NOP) ? MemWrite : 0;
    assign MemRead_ID_EX_in = !(ControlNOP || is_NOP) ? MemRead : 0;
    assign ALUOp_ID_EX_in = !(ControlNOP || is_NOP) ? ALUOp : 0;
    assign MemtoReg_ID_EX_in = !(ControlNOP || is_NOP) ? MemtoReg : 0;
    assign is_wwd_ID_EX_in = !(ControlNOP || is_NOP) ? is_wwd : 0;
    assign halted_op_ID_EX_in = !(ControlNOP || is_NOP) ? halted_op : 0;
    assign is_done_ID_EX_in = !(ControlNOP || is_NOP) ? is_done : 0;

    assign PC_ID_EX_in = PC_IF_ID_out;
    assign rd_ID_EX_in = rd;
    assign rs_ID_EX_in = rs;
    assign rt_ID_EX_in = rt;


    ID_EX id_ex(clk, reset_n, func_ID_EX_in, PC_ID_EX_in, r_data1_ID_EX_in, r_data2_ID_EX_in, imm_ID_EX_in, opcode_ID_EX_in, rs_ID_EX_in, rt_ID_EX_in, rd_ID_EX_in, ALUOp_ID_EX_in, ALUSrcB_ID_EX_in, MemRead_ID_EX_in, MemWrite_ID_EX_in, RegWrite_ID_EX_in, MemtoReg_ID_EX_in, is_wwd_ID_EX_in, is_done_ID_EX_in, halted_op_ID_EX_in, func_ID_EX_out, PC_ID_EX_out, r_data1_ID_EX_out, r_data2_ID_EX_out, imm_ID_EX_out, opcode_ID_EX_out, rs_ID_EX_out, rt_ID_EX_out, rd_ID_EX_out, ALUOp_ID_EX_out, ALUSrcB_ID_EX_out, MemRead_ID_EX_out, MemWrite_ID_EX_out, RegWrite_ID_EX_out, MemtoReg_ID_EX_out, is_wwd_ID_EX_out, is_done_ID_EX_out, halted_op_ID_EX_out);

    EXForwardUnit EXforwardUnit(clk, reset_n, RegWrite_EX_MEM_out, RegWrite_MEM_WB_out, rd_EX_MEM_out, rd_MEM_WB_out, rs_ID_EX_out, rt_ID_EX_out, EXforwardA, EXforwardB);

    assign ALUIn_A = (opcode_ID_EX_out == `JAL_OP || (opcode_ID_EX_out == `JRL_OP && func_ID_EX_out == `INST_FUNC_JRL)) ? PC_ID_EX_out : (EXforwardA == 2'b10) ? ALU_Result_EX_MEM_out : ((EXforwardA == 1) ? w_data : r_data1_ID_EX_out);
    assign ALUIn_B = (EXforwardB == 2'b10) ? ALU_Result_EX_MEM_out : ((EXforwardB == 1) ? w_data : (ALUSrcB_ID_EX_out ? imm_ID_EX_out : r_data2_ID_EX_out));

    ALU alu(clk, reset_n, ALUIn_A, ALUIn_B, ALUOp_ID_EX_out, opcode_ID_EX_out, ALU_Result_EX_MEM_in);

    assign PC_EX_MEM_in = PC_ID_EX_out;
    assign func_EX_MEM_in = func_ID_EX_out;
    assign opcode_EX_MEM_in = opcode_ID_EX_out;
    assign r_data1_EX_MEM_in = ALUIn_A;
    assign r_data2_EX_MEM_in = r_data2_ID_EX_out;
    assign rd_EX_MEM_in = rd_ID_EX_out;
    assign MemRead_EX_MEM_in =  MemRead_ID_EX_out;
    assign MemWrite_EX_MEM_in = MemWrite_ID_EX_out;
    assign RegWrite_EX_MEM_in = RegWrite_ID_EX_out;
    assign MemtoReg_EX_MEM_in =  MemtoReg_ID_EX_out;
    assign is_wwd_EX_MEM_in =  is_wwd_ID_EX_out; 
    assign is_done_EX_MEM_in =  is_done_ID_EX_out;
    assign halted_op_EX_MEM_in = halted_op_ID_EX_out;


    EX_MEM ex_mem(clk, reset_n, PC_EX_MEM_in, func_EX_MEM_in, opcode_EX_MEM_in, ALU_Result_EX_MEM_in, r_data1_EX_MEM_in, r_data2_EX_MEM_in, rd_EX_MEM_in
    , MemRead_EX_MEM_in, MemWrite_EX_MEM_in, RegWrite_EX_MEM_in, MemtoReg_EX_MEM_in, is_wwd_EX_MEM_in, is_done_EX_MEM_in, halted_op_EX_MEM_in, PC_EX_MEM_out, func_EX_MEM_out, opcode_EX_MEM_out, ALU_Result_EX_MEM_out, r_data1_EX_MEM_out, r_data2_EX_MEM_out, rd_EX_MEM_out, MemRead_EX_MEM_out, MemWrite_EX_MEM_out, RegWrite_EX_MEM_out, MemtoReg_EX_MEM_out, is_wwd_EX_MEM_out, is_done_EX_MEM_out, halted_op_EX_MEM_out);
    
    assign PC_MEM_WB_in = PC_EX_MEM_out;
    assign func_MEM_WB_in = func_EX_MEM_out;
    assign opcode_MEM_WB_in = func_EX_MEM_out;

    assign data2_in = MemRead_EX_MEM_out ? data2 : `WORD_SIZE'bz;
    assign data2 =  MemWrite_EX_MEM_out ? data2_out : `WORD_SIZE'bz;
    assign readM2 = MemRead_EX_MEM_out;
    assign writeM2 = MemWrite_EX_MEM_out;
    assign address1 = PC_out;
    assign address2 = (MemRead_EX_MEM_out || MemWrite_EX_MEM_out) ? ALU_Result_EX_MEM_out : `WORD_SIZE'b0;
    assign MemData_MEM_WB_in = MemRead_EX_MEM_out ? data2_in : `WORD_SIZE'bz;
    assign data2_out = MemWrite_EX_MEM_out ? r_data2_EX_MEM_out : `WORD_SIZE'bz;

    assign ALU_Result_MEM_WB_in = ALU_Result_EX_MEM_out;
    assign r_data1_MEM_WB_in = r_data1_EX_MEM_out;
    assign rd_MEM_WB_in = rd_EX_MEM_out;
    assign MemtoReg_MEM_WB_in = MemtoReg_EX_MEM_out;
    assign RegWrite_MEM_WB_in = RegWrite_EX_MEM_out;
    assign is_wwd_MEM_WB_in = is_wwd_EX_MEM_out;
    assign is_done_MEM_WB_in = is_done_EX_MEM_out;
    assign halted_op_MEM_WB_in = halted_op_EX_MEM_out;

    MEM_WB mem_wb(clk, reset_n, PC_MEM_WB_in, func_MEM_WB_in, opcode_MEM_WB_in, MemData_MEM_WB_in, ALU_Result_MEM_WB_in, rd_MEM_WB_in, MemtoReg_MEM_WB_in, RegWrite_MEM_WB_in, is_wwd_MEM_WB_in, is_done_MEM_WB_in, r_data1_MEM_WB_in, halted_op_MEM_WB_in, PC_MEM_WB_out, func_MEM_WB_out, opcode_MEM_WB_out, MemData_MEM_WB_out, ALU_Result_MEM_WB_out, rd_MEM_WB_out, MemtoReg_MEM_WB_out, RegWrite_MEM_WB_out, is_wwd_MEM_WB_out, is_done_MEM_WB_out, r_data1_MEM_WB_out , halted_op_MEM_WB_out);

    assign w_data = (opcode_MEM_WB_out == `JAL_OP || (opcode_MEM_WB_out == `JRL_OP && func_MEM_WB_out == `INST_FUNC_JRL)) ? PC_MEM_WB_out : (MemtoReg_MEM_WB_out ? MemData_MEM_WB_out : ALU_Result_MEM_WB_out);
    assign output_port = is_wwd_MEM_WB_out ? r_data1_MEM_WB_out : `WORD_SIZE'bz;
    assign num_inst = num_inst_reg;
    assign is_halted = halted_op_MEM_WB_out;
    

endmodule