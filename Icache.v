`define	CAPACITY 16
`define BLOCK_SIZE 16
`define NUM_BLOCKS 4
`define NUM_INDICIES 8
`define WORD_SIZE 16

module Icache(clk, reset_n, readM1_from_cpu, address1_from_cpu, readM1_to_mem, address1_to_mem, data1_from_mem, data1_to_cpu);
    input clk, reset_n;
    input readM1_from_cpu;
    input [`WORD_SIZE-1 :0] address1_from_cpu;

    //hit or miss
    output [`WORD_SIZE-1 :0] data1_to_cpu;

    //miss
    output readM1_to_mem;
    output  [`WORD_SIZE-1 :0] address1_to_mem;
    input [`WORD_SIZE-1 :0] data1_from_mem;

    //implementation



endmodule