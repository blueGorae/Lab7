`include "Datapath.v"
`include "ControlUnit.v"
`include "opcodes.v"
`include "Icache.v"
`include "Dcache.v"

`define BLOCK_SIZE 64

module cpu(clk, reset_n, BR, BG, readM1, address1, data1, readM2, writeM2, address2, data2_in, data2_out, num_inst, output_port, is_halted, dma_begin_interrupt, dma_end_interrupt, address2_to_DMAC);

	input dma_begin_interrupt;
	input dma_end_interrupt;

	output [`WORD_SIZE-1: 0] address2_to_DMAC;
	reg [`WORD_SIZE-1: 0] address2_to_DMAC;

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
	input [`BLOCK_SIZE-1:0] data2_in; //memory data
	output [`BLOCK_SIZE-1:0] data2_out; //memory data
	wire [`BLOCK_SIZE-1:0] data2_out;

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
	input BR;
	reg BR_reg;
	output BG;
	reg BG;
	// TODO : Implement your pipelined CPU!

	initial begin
		BG <= 0;
		BR_reg <= 0;
		address2_to_DMAC <= `WORD_SIZE'hz; 
	end

	always @(negedge reset_n) begin
		BG <= 0;
		BR_reg <= 0;
		address2_to_DMAC <= `WORD_SIZE'hz; 
	end


	always @(posedge BR) begin
		BR_reg = 1;
	end

	always@(negedge BR) begin
		BR_reg = 0;
	end

	always @(negedge BR) begin
		BR_reg = 0;
	end


	always @(posedge clk) begin
		if(BR_reg && D_mem_access_done) begin
			BG = 1;
			$display("BG => 1");
		end
	end

	always @(posedge dma_begin_interrupt) begin
		address2_to_DMAC = `WORD_SIZE'h17;
		$display ("CPU accept dma_begin_interrupt");
	end

	always @(posedge dma_end_interrupt) begin
		address2_to_DMAC = `WORD_SIZE'hz;
		$display("BG => 0");
		BG = 0;
	end
	
	assign readM1 = readM1_to_mem;
	assign address1 = address1_to_mem;
	assign data1_from_mem = data1;

	Icache icache(clk, reset_n, readM1_from_datapath, address1_from_datapath, readM1_to_mem, address1_to_mem, data1_from_mem, data1_to_datapath, I_mem_access_done);

	assign readM2 = readM2_to_mem;
	assign writeM2 = writeM2_to_mem;
	assign address2 = address2_to_mem;
	assign data2_from_mem =  readM2_to_mem ? data2_in[`WORD_SIZE-1:0] : `WORD_SIZE'bz; // load
	assign data2_out = writeM2_to_mem ? {`WORD_SIZE*3'bz,data2_to_mem} : `WORD_SIZE'bz; // store

	Dcache dcache(clk, reset_n, readM2_from_datapath, writeM2_from_datapath, data2_from_datapath, address2_from_datapath, readM2_to_mem, writeM2_to_mem, data2_to_mem, address2_to_mem, data2_from_mem, data2_to_datapath, D_mem_access_done, BG);

	assign mem_access_done = I_mem_access_done && D_mem_access_done;
	Datapath datapath(clk, reset_n, readM1_from_datapath, address1_from_datapath, data1_to_datapath, readM2_from_datapath, writeM2_from_datapath, address2_from_datapath, data2_to_datapath, data2_from_datapath, num_inst, output_port, is_halted, mem_access_done);



endmodule