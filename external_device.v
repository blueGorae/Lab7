`timescale 1ns/1ns	

`define WORD_SIZE 16
`define BLOCK_SIZE 64


// This is a SAMPLE. You should design your own external_device.
module external_device (interrupt_to_cpu, is_write_to_mem, address_to_mem, data_to_mem, write_info_from_dma, dma_begin_interrupt);
	
	output [`WORD_SIZE*3 : 0] interrupt_to_cpu;
	output is_write_to_mem;
	output [`WORD_SIZE-1 : 0] address_to_mem;
	output [`WORD_SIZE * 12 -1 : 0] data_to_mem;

	input [`WORD_SIZE * 2 : 0] write_info_from_dma;

	reg [`WORD_SIZE * 3 : 0] interrupt_to_cpu;
	reg [`WORD_SIZE-1:0] stored_data [11:0];

	integer i;

	wire is_write_to_mem;
	wire [`WORD_SIZE-1 : 0] address_to_mem;
	wire [`WORD_SIZE * 12 -1 : 0] data_to_mem;

	wire [`WORD_SIZE-1 : 0] dst_address = write_info_from_dma[`WORD_SIZE-1 : 0];
	wire [`WORD_SIZE-1 : 0] src_address = write_info_from_dma[`WORD_SIZE * 2 -1 : `WORD_SIZE];

	assign is_write_to_mem = write_info_from_dma[`WORD_SIZE * 2];
	assign address_to_mem = is_write_to_mem ? dst_address : 16'bz;
	assign data_to_mem = is_write_to_mem ? {stored_data[src_address], stored_data[src_address + 1], stored_data[src_address + 2], stored_data[src_address + 3]} : `WORD_SIZE * 12'b0;

	// /* inout setting */	
	// inout [`BLOCK_SIZE-1:0] data;
	
	// /* input */
	// input use_bus;    
	// input [3:0] idx;  
    
	/* output */
	output reg dma_begin_interrupt;
	
	/* external device storage */
	

	
	/* Initialization */
	//assign data = ...
	initial begin
		dma_begin_interrupt <= 0;
		stored_data[0] <= 16'h0000;
		stored_data[1] <= 16'h1111;
		stored_data[2] <= 16'h2222;
		stored_data[3] <= 16'h3333;
		stored_data[4] <= 16'h4444;
		stored_data[5] <= 16'h5555;
		stored_data[6] <= 16'h6666;
		stored_data[7] <= 16'h7777;
		stored_data[8] <= 16'h8888;
		stored_data[9] <= 16'h9999;
		stored_data[10] <= 16'haaaa;
		stored_data[11] <= 16'hbbbb;
	end

	/* Interrupt CPU at some time */
	initial begin
		#100000;
		$display("LOG: Start DMA! #1");
		dma_begin_interrupt = 1;
		#20;						
		dma_begin_interrupt = 0;
		#(185000 - 100000 - 20);
		$display("LOG: Start DMA! #2");
		dma_begin_interrupt = 1;
		#20;
		dma_begin_interrupt = 0;
	end
endmodule
