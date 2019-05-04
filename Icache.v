`define	CAPACITY 16
`define BLOCK_SIZE 16
`define NUM_BLOCKS 4
`define NUM_INDICIES 8
`define WORD_SIZE 16
`define TAG_SIZE 12


module Icache(clk, reset_n, readM1_from_datapath, address1_from_datapath, readM1_to_mem, address1_to_mem, data1_from_mem, data1_to_datapath, is_hit, is_miss);
    input clk, reset_n;
    input readM1_from_datapath;
    input [`WORD_SIZE-1 :0] address1_from_datapath;

    //hit or miss
    output [`WORD_SIZE-1 :0] data1_to_datapath;

    //miss
    output readM1_to_mem;
    output  [`WORD_SIZE-1 :0] address1_to_mem;
    input [`WORD_SIZE-1 :0] data1_from_mem [0 : 3]; // fetching 4 words at once

    reg [11 : 0] tag;
    reg [1 : 0] set_index;
    reg [1 : 0] block_offset;
    //reg [`WORD_SIZE-1 : 0] virtual_address;

    output is_hit;
    output is_miss;

    reg is_hit;
    reg is_miss;

    //cache design

    //reg [`WORD_SIZE-1:0] cache_line [0 : 3] // 4words
   // reg [`WORD_SIZE + `TAG_SIZE -1 :0] cache_line;//4 words
   // reg [`WORD_SIZE-1 : 0] blocks [0:3];
    reg [`WORD_SIZE + `TAG_SIZE -1 :0] Icache [0 : 3] [0 : 3]
   // reg [(`WORD_SIZE * 4 + `TAG_SIZE) -1:0] cache [0 : 3]
    reg [`WORD_SIZE-1 : 0] outputData;



    //implementation
    integer i;
    integer j;

    always @ (*) begin
        block_offset  <= address1_from_datapath[1 : 0];
        set_index <= address1_from_datapath[3 : 2];
        tag <= address1_from_datapath[`WORD_SIZE-1 : 4];
    end
   

    initial begin
        for(i = 0; i < 4; i = i + 1)
            for (j = 0; j < 4; j = j + 1)
                Icache[i][j] = {`TAG_SIZE'bz , `WORD_SIZE'bz};
        end
        is_hit = 0;
        is_miss = 1;
        data1_to_datapath = `WORD_SIZE'bz;
        readM1_to_mem = 0;
        address1_to_mem = `WORD_SIZE'bz;
        
    end

    always @(negedge reset_n) begin
        for(i = 0; i < 4; i = i + 1)
            for (j = 0; j < 4; j = j + 1)
                Icache[i][j] = {`TAG_SIZE'bz , `WORD_SIZE'bz};
        end
        is_hit = 0;
        is_miss = 1;
        data1_to_datapath = `WORD_SIZE'bz;
        readM1_to_mem = 0;
        address1_to_mem = `WORD_SIZE'bz;
    end

    always @ (posedge clk) begin
        if(reset_n) begin
            is_hit = (tag == Icache[set_index][block_offset][(`TAG_SIZE'bz + `WORD_SIZE'bz)-1 :`WORD_SIZE]);
            is_miss = !is_hit;
            data1_to_datapath = `WORD_SIZE'bz;
            readM1_to_mem = 0;
            address1_to_mem = `WORD_SIZE'bz;

            if(readM1_from_datapath) begin
                if(is_miss) begin
                    readM1_to_mem = 1;
                    address1_to_mem = address1_from_datapath;
                    //outputData = data1_from_mem;
                    if(data1_from_mem) begin
                        for(j = 0; j < 4; j = j+1)
                            Icache[set_index][j] = {tag, data1_from_mem[j]};
                    end
                    
                end

                if(is_hit) begin
                    outputData = Icache[set_index][block_offset][`WORD_SIZE-1 : 0];

                end
            end
        end
    end

    assign data1_to_datapath = outputData;


endmodule