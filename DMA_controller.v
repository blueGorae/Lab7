`timescale 1ns/1ns	

`define WORD_SIZE 16

module DMA_controller (clk, reset_n, BR_to_cpu, BG_from_cpu, dma_end_interrupt, idx_to_ED, address_from_cpu, address_to_mem, Mem_access_done);
	input clk, reset_n;

	input BG_from_cpu;

	output dma_end_interrupt;
	reg dma_end_interrupt;

	input [`WORD_SIZE-1 : 0] address_from_cpu;
	output [`WORD_SIZE-1 : 0] address_to_mem;
	wire [`WORD_SIZE-1 : 0] address_to_mem;

	input Mem_access_done;
	output [3:0] idx_to_ED;
	reg [3:0] idx_to_ED;
	output BR_to_cpu;
	reg BR_to_cpu;

	integer num_data;

	initial begin
		num_data <= 0;
		dma_end_interrupt <= 0;
		idx_to_ED <= 4'b0;
		BR_to_cpu <= 0;
	end

	always @(negedge reset_n) begin
		num_data <= 0;
		dma_end_interrupt <= 0;
		idx_to_ED <= 4'b0;
		BR_to_cpu <= 0;
	end
	
	always @(posedge BG_from_cpu) begin
		num_data <= 3;
		dma_end_interrupt <= 0;
	end


	always @(posedge clk)begin
		if(BG_from_cpu && num_data == 3) begin
			idx_to_ED = 0;
			num_data = num_data -1;
		end
		else if(BG_from_cpu && num_data > 0)begin
			num_data = num_data - 1;
			idx_to_ED = idx_to_ED + 4;
		end

		else if(BG_from_cpu &&  num_data == 0) begin
			idx_to_ED = idx_to_ED + 4;
			BR_to_cpu = 0;
			$display("BR -> 0");
			dma_end_interrupt = 1;
			$display("dma_end_interrupt raised");
			#20;
			dma_end_interrupt = 0;
			$display("dma_end_interrupt raised");
		end

	end

	always @(address_from_cpu) begin
		if(address_from_cpu !== `WORD_SIZE'bz) begin
			BR_to_cpu = 1;
			$display("BR -> 1");
		end
	end

	assign address_to_mem = BG_from_cpu ? address_from_cpu + idx_to_ED : `WORD_SIZE'bz;
	
endmodule
