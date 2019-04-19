`include "Datapath.v"
`include "ControlUnit.v"
`include "opcodes.v"

`timescale 1ns/1ns
//`define WORD_SIZE 16    // data and address word size

module cpu(Clk, Reset_N, readM1, address1, data1, readM2, writeM2, address2, data2, num_inst, output_port, is_halted);

	input Clk;
	wire Clk;
	input Reset_N;
	wire Reset_N;
	output readM1; // instruction fetch
	wire readM1;
	output [`WORD_SIZE-1:0] address1; //instruction fetch
	wire [`WORD_SIZE-1:0] address1;
	output readM2; // load 
	wire readM2;
	output writeM2; //store
	wire writeM2;
	output [`WORD_SIZE-1:0] address2; //load or store
	wire [`WORD_SIZE-1:0] address2;

	input [`WORD_SIZE-1:0] data1; // instruction
	wire [`WORD_SIZE-1:0] data1;
	inout [`WORD_SIZE-1:0] data2; //memory data
	wire [`WORD_SIZE-1:0] data2;

	output [`WORD_SIZE-1:0] num_inst;
	wire [`WORD_SIZE-1:0] num_inst;
	output [`WORD_SIZE-1:0] output_port;
	wire [`WORD_SIZE-1:0] output_port;
	output is_halted;
	wire is_halted;



	// TODO : Implement your pipelined CPU!

	wire RegWrite;
	wire ALUSrcB;
	wire MemWrite;
	wire [2:0]ALUOp;
	wire MemtoReg;
	wire MemRead;
	//wire readM1;
	wire B_OP;
	wire R_type, I_type, J_type, S_type, L_type;
	wire is_wwd;
    wire is_halted;


	ControlUnit controlUnit (Clk, Reset_N, instruction, RegWrite, ALUSrcB, MemWrite, ALUOp, MemtoReg, MemRead, readM1, B_OP, is_wwd, is_halted, R_type, I_type, J_type, S_type, L_type);
	Datapath datapath(Clk, Reset_N, readM1, address1, data1, readM2, writeM2, address2, data2, 
	RegWrite, ALUSrcB, MemWrite, ALUOp, MemtoReg, MemRead, B_OP, is_wwd, R_type, I_type, J_type, S_type, L_type, num_inst, output_port, is_halted);



endmodule
