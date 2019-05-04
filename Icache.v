`define	CAPACITY 16
`define BLOCK_SIZE 16
`define NUM_BLOCKS 4
`define NUM_INDICIES 4
`define WORD_SIZE 16
`define TAG_SIZE 12


module Icache(clk, reset_n, readM1_from_datapath, address1_from_datapath, readM1_to_mem, address1_to_mem, data1_from_mem, data1_to_datapath, is_hit, is_miss);
    input clk, reset_n;
    input readM1_from_datapath;
    input [`WORD_SIZE-1 :0] address1_from_datapath;

    //hit or miss
    output [`WORD_SIZE-1 :0] data1_to_datapath;
    wire [`WORD_SIZE-1 :0] data1_to_datapath;

    //miss
    output readM1_to_mem;
    reg readM1_to_mem;

    output  [`WORD_SIZE-1 :0] address1_to_mem;
    reg [`WORD_SIZE-1 :0] address1_to_mem;

    input [`WORD_SIZE-1 :0] data1_from_mem; // fetching 4 words at once

    wire [11 : 0] tag;
    wire [1 : 0] set_index;
    wire [1 : 0] block_offset;
    //reg [`WORD_SIZE-1 : 0] virtual_address;

    output is_hit;
    output is_miss;

    reg is_hit;
    reg is_miss;

    //cache design

    reg [`WORD_SIZE + `TAG_SIZE -1 :0] Icache [0 : 3] [0 : 3];
    reg [`WORD_SIZE-1 : 0] outputData;



    //implementation
    integer i;
    integer j;

    integer num_remain_clk;
    integer num_remain_data;
    
    assign block_offset = address1_from_datapath[1 : 0];
    assign set_index = address1_from_datapath[3 : 2];
    assign tag = address1_from_datapath[`WORD_SIZE-1 : 4];
   

    initial begin
        for(i = 0; i < `NUM_INDICIES; i = i + 1) begin
            for (j = 0; j < `NUM_BLOCKS; j = j + 1) begin
                Icache[i][j] = {`TAG_SIZE'bz , `WORD_SIZE'bz};
            end
        end
        is_hit <= 0;
        is_miss <= 0;
        num_remain_clk <= 0;
        num_remain_data <= 0;    
        readM1_to_mem <=0;
        address1_to_mem <= `WORD_SIZE'bz;    
    end

    always @(negedge reset_n) begin
        for(i = 0; i < `NUM_INDICIES; i = i + 1) begin
            for (j = 0; j < `NUM_BLOCKS; j = j + 1) begin
                Icache[i][j] <= {`TAG_SIZE'bz , `WORD_SIZE'bz};
            end
        end
        is_hit <= 0;
        is_miss <= 0;
        num_remain_clk <= 0;
        num_remain_data <= 0;
        readM1_to_mem <=0;
        address1_to_mem <= `WORD_SIZE'bz;    
    end



    always @ (posedge clk) begin
        if(reset_n) begin

            if(readM1_from_datapath) begin
                is_hit = (tag == Icache[set_index][block_offset][(`TAG_SIZE + `WORD_SIZE)-1 :`WORD_SIZE]);
                is_miss = !is_hit;

                if(is_miss && num_remain_clk == 0) begin
                    readM1_to_mem = 1;
                    address1_to_mem = address1_from_datapath;
                    num_remain_data = 4;
                    num_remain_clk = 5; 
                end
                else if(is_miss && num_remain_data != 0 ) begin
                    Icache[set_index][4-num_remain_data][`WORD_SIZE-1 : 0] = data1_from_mem;
				    num_remain_data = num_remain_data-1;
                    num_remain_clk = num_remain_clk-1;
                end
                else if(is_miss) begin
                    num_remain_clk = num_remain_clk-1;
                    outputData = Icache[set_index][block_offset][`WORD_SIZE-1 : 0];
                end

                else if(is_hit) begin
                    outputData = Icache[set_index][block_offset][`WORD_SIZE-1 : 0];
                end
            end
        end
    end

    assign data1_to_datapath = outputData;


endmodule