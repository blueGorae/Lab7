`define	CAPACITY 16
`define BLOCK_SIZE 16
`define NUM_BLOCKS 4
`define NUM_INDICIES 4
`define WORD_SIZE 16
`define TAG_SIZE 12


module Icache(clk, reset_n, readM1_from_datapath, address1_from_datapath, readM1_to_mem, address1_to_mem, data1_from_mem, data1_to_datapath, is_hit, is_miss, mem_access_done);
    input clk, reset_n;
    input readM1_from_datapath;
    input [`WORD_SIZE-1 :0] address1_from_datapath;

    //hit or miss
    output [`WORD_SIZE-1 :0] data1_to_datapath;
    wire [`WORD_SIZE-1 :0] data1_to_datapath;

    //miss
    output readM1_to_mem;
    wire readM1_to_mem;

    output  [`WORD_SIZE-1 :0] address1_to_mem;
    reg [`WORD_SIZE-1 :0] address1_to_mem;

    input [`WORD_SIZE-1 :0] data1_from_mem; // fetching 4 words at once

    wire [11 : 0] tag;
    wire [1 : 0] set_index;
    wire [1 : 0] block_offset;

    output mem_access_done;
    reg mem_access_done;
 
    output is_hit;
    output is_miss;

    reg is_hit;
    reg is_miss;

    //cache design

    reg [`WORD_SIZE + `TAG_SIZE :0] Icache [0 : 3] [0 : 3];
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
                Icache[i][j] = {1'b0, `TAG_SIZE'bz , `WORD_SIZE'bz};
            end
        end
        is_hit <= 0;
        is_miss <= 0;
        num_remain_clk <= 0;
        num_remain_data <= 0;    
        //readM1_to_mem <=0;
        address1_to_mem <= `WORD_SIZE'bz;    
        mem_access_done <= 0;
    end

    always @(negedge reset_n) begin
        for(i = 0; i < `NUM_INDICIES; i = i + 1) begin
            for (j = 0; j < `NUM_BLOCKS; j = j + 1) begin
                Icache[i][j] <= {1'b0, `TAG_SIZE'bz , `WORD_SIZE'bz};
            end
        end
        is_hit <= 0;
        is_miss <= 0;
        num_remain_clk <= 0;
        num_remain_data <= 0;
        //readM1_to_mem <=0;
        address1_to_mem <= `WORD_SIZE'bz;    
        mem_access_done <= 0;
    end

    always @(negedge reset_n or address1_from_datapath) begin
        if(reset_n) begin
            is_hit = (tag == Icache[set_index][block_offset][(`TAG_SIZE + `WORD_SIZE)-1 :`WORD_SIZE]) && (Icache[set_index][block_offset][(`TAG_SIZE + `WORD_SIZE)]);
            is_miss = !is_hit;
            if(is_miss) begin
                num_remain_data = 4;
                num_remain_clk = 5; 
            end
            else begin
                num_remain_data = 0;
                num_remain_clk = 0; 
            end
        end
    end
    
    assign readM1_to_mem = is_miss ? readM1_from_datapath : 0;
    //assign address1_to_mem = is_miss ? address1_from_datapath : `WORD_SIZE'bz;

    always @(negedge clk) begin
            if(mem_access_done) begin
                outputData = Icache[set_index][block_offset][`WORD_SIZE-1 : 0];
            end

    end

    //assign mem_access_done = (num_remain_clk == 0) ? 1 : 0; 

    always @ (posedge clk) begin
        if(address1_from_datapath) begin
            is_hit = (tag == Icache[set_index][block_offset][(`TAG_SIZE + `WORD_SIZE)-1 :`WORD_SIZE]) && (Icache[set_index][block_offset][(`TAG_SIZE + `WORD_SIZE)]) && mem_access_done;
            is_miss = !is_hit;
            mem_access_done = 0;

            if(is_miss && num_remain_clk == 0) begin
                address1_to_mem = (address1_from_datapath / 4)*4;
                num_remain_data = 4;
                num_remain_clk = 5; 
                 //readM1_to_mem = 1;
                 //address1_to_mem = address1_from_datapath;
            end

            if(is_miss && num_remain_data > 0 ) begin
                address1_to_mem = address1_to_mem + 1;
                Icache[set_index][4-num_remain_data][`WORD_SIZE-1 : 0] = data1_from_mem;
                Icache[set_index][4-num_remain_data][`TAG_SIZE + `WORD_SIZE -1 : `WORD_SIZE] = tag;
                Icache[set_index][4-num_remain_data][`TAG_SIZE + `WORD_SIZE] = 1;
                num_remain_data = num_remain_data-1;
                num_remain_clk = num_remain_clk-1;

            end
            else if(is_miss) begin
                num_remain_clk = num_remain_clk-1;
                mem_access_done = 1;
            end
            else if(is_hit) begin
                //outputData = Icache[set_index][block_offset][`WORD_SIZE-1 : 0];
                mem_access_done = 1;
            end
        end
    end

    assign data1_to_datapath = outputData;


endmodule