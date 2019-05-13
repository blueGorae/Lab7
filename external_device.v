`timescale 1ns/1ns	

`define WORD_SIZE 16
`define BLOCK_SIZE 64


// This is a SAMPLE. You should design your own external_device.
module external_device (data, use_bus_from_DMA, idx_from_DMA, dma_begin_interrupt, Mem_access_done);
	/* inout setting */	
	output [`BLOCK_SIZE-1:0] data;
	
	/* input */
	input use_bus_from_DMA;
	input [3:0] idx_from_DMA; 
    
	/* output */
	output reg dma_begin_interrupt;
	output reg Mem_access_done;

	/* external device storage */
	reg [`WORD_SIZE-1:0] stored_data [11:0];
	
	/* Initialization */
	//assign data = ...

	assign data = use_bus_from_DMA ? {stored_data[idx_from_DMA + 3], stored_data[idx_from_DMA+2], stored_data[idx_from_DMA+1], stored_data[idx_from_DMA]} : `BLOCK_SIZE'bz;
	
	initial begin
		dma_begin_interrupt <= 0;
		Mem_access_done <= 1;
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
		#1000;
		$display("LOG: Start DMA! #1");
		dma_begin_interrupt = 1;
		#20;
		dma_begin_interrupt = 0;
		#(1850 - 1000 - 20);
		$display("LOG: Start DMA! #2");
		dma_begin_interrupt = 1;
		#20;
		dma_begin_interrupt = 0;
	end
endmodule
