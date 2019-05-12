`timescale 1ns/1ns	

`define WORD_SIZE 16
`define BLOCK_SIZE 64


module DMA_controller (BR_to_cpu, BG_from_cpu, command_from_cpu, write_info_to_ED, write_done_from_mem);
	output BR_to_cpu;
	input BG_from_cpu;
	input [`WORD_SIZE*3 + 2 : 0] command_from_cpu;
	output [`WORD_SIZE*2 : 0] write_info_to_ED;
	input write_done_from_mem;

	reg BR_to_cpu;
	reg [`WORD_SIZE * 2 : 0] write_info_to_ED;

	reg [`WORD_SIZE*3 + 2 : 0] tmp_command;

	integer i;
	integer num_block;

	initial begin
		BR_to_cpu = 0;
		write_info_to_ED = `WORD_SIZE*2+1'bz;
		i = 0;
	end

	always @(posedge command_from_cpu[`WORD_SIZE*3+2]) begin // is_interrupt == 1
		BR_to_cpu = 1;
		tmp_command = command;
		num_block = command[`WORD_SIZE-1 : 0] / 4;
		i = num_block;
	end

	always @(posedge write_done_from_mem) begin // memory write done, but blocks remain..
		i = i-1;
		if(i == 0) begin
			BR_to_cpu = 0;
			write_info_to_ED = `WORD_SIZE*2+1'b0;
			tmp_command = `WORD_SIZE*3+3'b0;
		end

		else begin
			write_info_to_ED = {1'b1, tmp_command[`WORD_SIZE*3-3 : `WORD_SIZE] + 32'h00040004 * (num_block - i)};
		end	
	end

	always @(posedge BG_from_cpu) begin
		write_info_to_ED = {1'b1, tmp_command[`WORD_SIZE * 3 - 3 : `WORD_SIZE]};
	end
	
endmodule
