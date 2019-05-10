`timescale 1ns/1ns	

`define WORD_SIZE 16
`define BLOCK_SIZE 64
`define DATA_SIZE 3 * `WORD_SIZE

module DMA_controller (BR, BG, interrupt, address, data);
	input BG;
	input interrupt;
	input [`WORD_SIZE-1 : 0] address;


	output BR;
	output [`DATA_SIZE-1 : 0] data;
