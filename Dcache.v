`define	CAPACITY 16
`define BLOCK_SIZE 16
`define NUM_BLOCKS 4
`define NUM_INDICIES 8
`define WORD_SIZE 16
`define TAG_SIZE 12

module Dcache(clk, reset_n, readM2_from_cpu, writeM2_from_cpu , data2_from_cpu, address2_from_cpu, readM2_to_mem, writeM2_to_mem, data2_to_mem, address2_to_mem, data2_from_mem, data2_to_cpu, is_hit, is_miss);
    input clk, reset_n;
    input readM2_from_cpu, writeM2_from_cpu;
    input [`WORD_SIZE-1 :0] address2_from_cpu;

    // read hit or miss
    output  [`WORD_SIZE-1 :0] data2_to_cpu;

    output readM2_to_mem;
    output [`WORD_SIZE-1 :0] address2_to_mem;
    input [`WORD_SIZE-1 :0] data2_from_mem [0 : 3];

    //write hit or miss
    output writeM2_to_mem;
    input [`WORD_SIZE-1 :0] data2_from_cpu;
    //output [`WORD_SIZE-1 :0] address2_to_mem;
    output [`WORD_SIZE-1 :0] data2_to_mem;


    reg [11 : 0] tag;
    reg [1 : 0] set_index;
    reg [1 : 0] block_offset;

    output is_hit;
    output is_miss;

    reg is_hit;
    reg is_miss;

    //cache design
    reg [`WORD_SIZE + `TAG_SIZE -1 :0] Dcache [0 : 3] [0 : 3];
    reg [`WORD_SIZE-1 : 0] outputData;

    //implementation
    integer i;
    integer j;

    always @ (*) begin
        block_offset  <= address2_from_cpu[1 : 0];
        set_index <= address2_from_cpu[3 : 2];
        tag <= address2_from_cpu[`WORD_SIZE-1 : 4];
    end

    initial begin
        for(i = 0; i < 4; i = i + 1)
            for (j = 0; j < 4; j = j + 1)
                Dcache[i][j] = {`TAG_SIZE'bz , `WORD_SIZE'bz};
        end
        is_hit = 0;
        is_miss = 1;
        data2_to_cpu = `WORD_SIZE'bz;
        readM2_to_mem = 0;
        writeM2_to_mem = 0;
        address2_to_mem = `WORD_SIZE'bz;
        data2_to_mem = `WORD_SIZE'bz;
    end

    always @(negedge reset_n) begin
        for(i = 0; i < 4; i = i + 1)
            for (j = 0; j < 4; j = j + 1)
                Dcache[i][j] = {`TAG_SIZE'bz , `WORD_SIZE'bz};
        end
        is_hit = 0;
        is_miss = 1;
        data2_to_cpu = `WORD_SIZE'bz;
        readM2_to_mem = 0;
        writeM2_to_mem = 0;
        address2_to_mem = `WORD_SIZE'bz;
        data2_to_mem = `WORD_SIZE'bz;
    end

    always @(posedge clk) begin
        if(reset_n) begin
            is_hit = (tag == Dcache[set_index][block_offset][`TAG_SIZE + `WORD_SIZE -1 : `WORD_SIZE]);
            is_miss = !is_hit;
            data2_to_mem = `WORD_SIZE'bz;
            data2_to_cpu = `WORD_SIZE'bz;
            readM2_to_mem = 0;
            writeM2_to_mem = 0;
            address2_to_mem = 0;

            if(readM2_from_cpu) begin
                if(is_miss) begin
                    readM2_to_mem = 1;
                    address2_to_mem = address2_from_cpu;

                    if(data2_from_mem)begin
                        for(j = 0l j < 4; j = j+1)
                            Dcache[set_index][j] = {tag, data2_from_mem[j]}
                    end
                end
                if(is_hit) begin
                    outputData = Dcache[set_index][block_offset][`WORD_SIZE-1 : 0];

                end
            end

            if(writeM2_from_cpu) begin
                if(is_miss) begin
                    writeM2_to_mem = 1;
                    data2_to_mem = data2_to_cpu;
                    address2_to_mem = address2_from_cpu;

                 //쓸 주소 값이 cache에 없는 경우 -> 메모리에다가 바로 쓰면 됨 
                end

                if(is_hit) begin
                    writeM2_to_mem = 1;
                    data2_to_mem = data2_to_cpu;
                    address2_to_mem = address2_from_cpu;
                    Dcache[set_index][block_offset][`WORD_SIZE-1 : 0] = data2_from_cpu;
                    
                end
            end
        end
    end


endmodule