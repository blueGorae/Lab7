`define	CAPACITY 16
`define BLOCK_SIZE 16
`define NUM_BLOCKS 4
`define NUM_INDICIES 8
`define WORD_SIZE 16

module Dcache(clk, reset_n, readM2_from_cpu, writeM2_from_cpu , data2_from_cpu, address2_from_cpu, readM2_to_mem, writeM2_to_mem, data2_to_mem, address2_to_mem, data2_from_mem, data2_to_cpu);
    input clk, reset_n;
    input readM2_from_cpu, writeM2_from_cpu;
    input [`WORD_SIZE-1 :0] address2_from_cpu;

    // read hit or miss
    output  [`WORD_SIZE-1 :0] data2_to_cpu;

    output readM2_to_mem;
    output [`WORD_SIZE-1 :0] address2_to_mem;
    input [`WORD_SIZE-1 :0] data2_from_mem;

    //write hit or miss
    output writeM2_to_mem;
    input [`WORD_SIZE-1 :0] data2_from_cpu;
    //output [`WORD_SIZE-1 :0] address2_to_mem;
    output [`WORD_SIZE-1 :0] data2_to_mem;


    //implementation


endmodule