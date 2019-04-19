`include "Datapath.v"
`include "ControlUnit.v"
`include "opcodes.v"

`timescale 1ns/1ns
//`define WORD_SIZE 16    // data and address word size

module cpu(clk, reset_n, readM1, address1, data1, readM2, writeM2, address2, data2, num_inst, output_port, is_halted);

	input clk;
	wire clk;
	input reset_n;
	wire reset_n;
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
	

	Datapath datapath(clk, reset_n, readM1, address1, data1, readM2, writeM2, address2, data2, num_inst, output_port, is_halted);



endmodule
