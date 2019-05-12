`include "Datapath.v"
`include "ControlUnit.v"
`include "opcodes.v"
`include "Icache.v"
`include "Dcache.v"


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

	wire readM1_to_mem; //signal to memory
	wire readM1_from_datapath; // signal from datapath
	wire [`WORD_SIZE-1:0] address1_from_datapath;
	wire [`WORD_SIZE-1:0] data1_from_mem;

	wire [`WORD_SIZE-1:0] address1_to_mem;
	wire [`WORD_SIZE-1:0] data1_to_datapath;

	wire readM2_to_mem;
	wire writeM2_to_mem;
	wire readM2_from_datapath;
	wire writeM2_from_datapath;

	wire [`WORD_SIZE-1:0] data2_from_datapath;
	wire [`WORD_SIZE-1:0] data2_to_mem;
	wire [`WORD_SIZE-1:0] address2_from_datapath;
	wire [`WORD_SIZE-1:0] address2_to_mem;
	wire [`WORD_SIZE-1:0] data2_from_mem;
	wire [`WORD_SIZE-1:0] data2_to_datapath;

	wire mem_access_done;
	wire I_mem_access_done;
	wire D_mem_access_done;

	//for DMA
	input [`WORD_SIZE*3 : 0] interrupt_from_ED;
	input BR_from_DMA;
	output BG_to_DMA;
	output [`WORD_SIZE*3 + 2 : 0] command_to_DMA;

	reg BG_to_DMA;
	wire [`WORD_SIZE*3 + 2 : 0] command_to_DMA;

	// TODO : Implement your pipelined CPU!

	initial begin
		BG_to_DMA = 0;
	end

	always @(posedge BR_from_DMA) begin
		BG_to_DMA = 1;

	end

	always @(negedge BR_from_DMA) begin
		BG_to_DMA = 0;
	end

	assign command_to_DMA = interrupt_from_ED[`WORD_SIZE*3] ? {1'b1, BR_from_DMA, BG_to_DMA, interrupt_from_ED[`WORD_SIZE*3-1:0]} : `WORD_SIZE*3'b0;


	assign readM1 = readM1_to_mem;
	assign address1 = address1_to_mem;
	assign data1_from_mem = data1;

	Icache icache(clk, reset_n, readM1_from_datapath, address1_from_datapath, readM1_to_mem, address1_to_mem, data1_from_mem, data1_to_datapath, I_mem_access_done);


//for miss, do not access memory while BG == 1

	assign readM2 = !BG_to_DMA ? readM2to_to_mem : 0;
	assign writeM2 = !BG_to_DMA ? writeM2_to_mem : 0;
	assign address2 = !BG_to_DMA ? address2_to_mem : `WORD_SIZE'bz;
	assign data2_from_mem =  !BG_to_DMA ? (readM2_to_mem ? data2 : `WORD_SIZE'bz) : `WORD_SIZE'bz; // load
	assign data2 = !BG_to_DMA ? (writeM2_to_mem ? data2_to_mem : `WORD_SIZE'bz) : `WORD_SIZE'bz; // store

	Dcache dcache(clk, reset_n, readM2_from_datapath, writeM2_from_datapath, data2_from_datapath, address2_from_datapath, readM2_to_mem, writeM2_to_mem, data2_to_mem, address2_to_mem, data2_from_mem, data2_to_datapath, D_mem_access_done);

	assign mem_access_done = I_mem_access_done && D_mem_access_done;
	Datapath datapath(clk, reset_n, readM1_from_datapath, address1_from_datapath, data1_to_datapath, readM2_from_datapath, writeM2_from_datapath, address2_from_datapath, data2_to_datapath, data2_from_datapath, num_inst, output_port, is_halted, mem_access_done);



endmodule