`define	CAPACITY 16
`define BLOCK_SIZE 16
`define NUM_BLOCKS 4
`define NUM_INDICIES 4
`define WORD_SIZE 16
`define TAG_SIZE 12

module Dcache(clk, reset_n, readM2_from_datapath, writeM2_from_datapath , data2_from_datapath, address2_from_datapath, readM2_to_mem, writeM2_to_mem, data2_to_mem, address2_to_mem, data2_from_mem, data2_to_datapath, is_hit, is_miss, mem_access_done);
    input clk, reset_n;
    input readM2_from_datapath, writeM2_from_datapath;
    input [`WORD_SIZE-1: 0] data2_from_datapath;
    input [`WORD_SIZE-1 :0] address2_from_datapath;

    // read hit or miss
    output  [`WORD_SIZE-1 :0] data2_to_datapath;
    wire [`WORD_SIZE-1:0] data2_to_datapath;

    output readM2_to_mem;
    wire readM2_to_mem;

    output [`WORD_SIZE-1 :0] address2_to_mem;
    wire [`WORD_SIZE-1: 0] address2_to_mem;

    input [`WORD_SIZE-1 :0] data2_from_mem;

    //write hit or miss
    output writeM2_to_mem;
    wire writeM2_to_mem;

    input [`WORD_SIZE-1 :0] data2_from_datapath;
    output [`WORD_SIZE-1 :0] data2_to_mem;
    wire [`WORD_SIZE-1 :0] data2_to_mem;

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
    reg [`WORD_SIZE + `TAG_SIZE :0] Dcache [0 : 3] [0 : 3];
    reg [`WORD_SIZE-1 : 0] outputData;
    reg [`WORD_SIZE-1 : 0] address2_to_mem_reg;

    //implementation
    integer i;
    integer j;

    integer num_remain_clk;
    integer num_remain_data;

    assign block_offset = address2_from_datapath[1 : 0];
    assign set_index = address2_from_datapath[3 : 2];
    assign tag = address2_from_datapath[`WORD_SIZE-1 : 4];


    initial begin
        for(i = 0; i < `NUM_INDICIES; i = i + 1) begin
            for (j = 0; j < `NUM_BLOCKS; j = j + 1) begin
                Dcache[i][j] = {1'b0, `TAG_SIZE'bz , `WORD_SIZE'bz};
            end
        end
        is_hit <= 0;
        is_miss <= 0;
        outputData <= `WORD_SIZE'bz;
        num_remain_clk <= 0;
        num_remain_data <= 0;    
        mem_access_done <= 1;
        address2_to_mem_reg <= address2_from_datapath;
    end

    always @(negedge reset_n) begin
        for(i = 0; i < `NUM_INDICIES; i = i + 1) begin
            for (j = 0; j < `NUM_BLOCKS; j = j + 1) begin
                Dcache[i][j] = {1'b0, `TAG_SIZE'bz , `WORD_SIZE'bz};
            end
        end
        is_hit <= 0;
        is_miss <= 0;
        outputData <= `WORD_SIZE'bz;
        num_remain_clk <= 0;
        num_remain_data <= 0;    
        mem_access_done <= 1;
        address2_to_mem_reg <= address2_from_datapath;
    end

    always @(posedge reset_n or address2_from_datapath) begin
        if(reset_n) begin
            if(readM2_from_datapath) begin
                mem_access_done = 0;
                is_hit = (tag == Dcache[set_index][block_offset][(`TAG_SIZE + `WORD_SIZE)-1 :`WORD_SIZE]) && (Dcache[set_index][block_offset][(`TAG_SIZE + `WORD_SIZE)]);
                is_miss = !is_hit;
                if(is_miss) begin
                    address2_to_mem_reg = (address2_from_datapath / 4) *4;
                    num_remain_data = 4;
                    num_remain_clk = 5;
                end
                else begin
                    num_remain_data = 0;
                    num_remain_clk = 0;
                    mem_access_done = 1;
                end
            end

            if(writeM2_from_datapath) begin
                mem_access_done = 0;
                is_hit = (tag == Dcache[set_index][block_offset][(`TAG_SIZE + `WORD_SIZE)-1 :`WORD_SIZE]) && (Dcache[set_index][block_offset][(`TAG_SIZE + `WORD_SIZE)]);
                is_miss = !is_hit;
                //if miss, write only to memory
                if(is_miss) begin
                    address2_to_mem_reg = address2_from_datapath;
                    num_remain_data = 0;
                    num_remain_clk = 5;
                end
                //if hit, write directly to cache and to memory
                else begin
                    Dcache[set_index][4-num_remain_data][`WORD_SIZE-1 : 0] = data2_from_datapath;
                    address2_to_mem_reg = address2_from_datapath;
                    num_remain_data = 0;
                    num_remain_clk = 0;
                    mem_access_done = 1;
                end
            end
        end
    end

    assign readM2_to_mem = is_miss ? readM2_from_datapath : 0 ;
    assign writeM2_to_mem = writeM2_from_datapath;
    assign data2_to_mem = writeM2_to_mem ? data2_from_datapath : `WORD_SIZE'bz;
    assign address2_to_mem = readM2_from_datapath ? (is_miss ? address2_to_mem_reg : `WORD_SIZE'bz) : (writeM2_from_datapath ? address2_to_mem_reg : `WORD_SIZE'bz);

    always @(negedge clk) begin
        if(reset_n) begin
            if(readM2_from_datapath && num_remain_clk == 0) begin
                outputData = Dcache[set_index][block_offset][`WORD_SIZE-1 : 0];
            end
        end
    end


    always @(posedge clk) begin
        if(reset_n) begin
            if(readM2_from_datapath) begin
                if(is_miss && num_remain_data > 0 ) begin
                    Dcache[set_index][4-num_remain_data][`WORD_SIZE-1 : 0] = data2_from_mem;
                    Dcache[set_index][4-num_remain_data][`TAG_SIZE + `WORD_SIZE -1 : `WORD_SIZE] = tag;
                    Dcache[set_index][4-num_remain_data][`TAG_SIZE + `WORD_SIZE] = 1;
                    address2_to_mem_reg = address2_to_mem_reg + 1;
                    num_remain_data = num_remain_data-1;
                    num_remain_clk = num_remain_clk-1;
                end
                else if(is_miss && num_remain_data == 0) begin
                    num_remain_clk = num_remain_clk-1;
                    mem_access_done = 1;
                end
            end

            if(writeM2_from_datapath) begin
                if(is_miss && num_remain_clk > 0 ) begin
                    num_remain_clk = num_remain_clk-1;
                end
                else if(is_miss && num_remain_clk == 1) begin
                    num_remain_clk = num_remain_clk-1;
                    mem_access_done = 1;
                end
            end
        end
    end

    assign data2_to_datapath = readM2_from_datapath ? outputData : `WORD_SIZE'bz;


endmodule