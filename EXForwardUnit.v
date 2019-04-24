`include "opcodes.v"

module EXForwardUnit(clk, reset_n, RegWrite_EX_MEM_out, RegWrite_MEM_WB_out, rd_EX_MEM_out, rd_MEM_WB_out, rs_ID_EX_out, rt_ID_EX_out, forwardA, forwardB);
    input clk, reset_n;

    input [1:0] rd_EX_MEM_out;
    input [1:0] rd_MEM_WB_out;
    input [1:0] rs_ID_EX_out;
    input [1:0] rt_ID_EX_out;
    input RegWrite_EX_MEM_out;
    input RegWrite_MEM_WB_out;


    output [1:0] forwardA;
    output [1:0] forwardB;

    reg [1:0] forwardA;
    reg [1:0] forwardB;

    initial begin
        forwardA <= 2'b0;
        forwardB <= 2'b0;
    end

    always @(negedge reset_n) begin
        forwardA <= 2'b0;
        forwardB <= 2'b0;
    end

    always @(*) begin
        forwardA = 2'b0;
        forwardB = 2'b0;

        if(RegWrite_EX_MEM_out) begin
            if(rd_EX_MEM_out == rs_ID_EX_out) begin
                 forwardA = 2'b10;
            end
            else if(rd_EX_MEM_out == rt_ID_EX_out) begin
                 forwardB = 2'b10;
             end
        end
        
        else if(RegWrite_MEM_WB_out) begin
            if(rd_MEM_WB_out == rs_ID_EX_out)begin
                forwardA = 2'b01;
            end
            else if(rd_MEM_WB_out == rt_ID_EX_out) begin
                forwardB = 2'b01;
            end
        end

       /* if(RegWrite_MEM_WB_out & !RegWrite_EX_MEM_out)  begin 
            if((rd_MEM_WB_out == rs_ID_EX_out)) begin
                forwardA = 2'b01;
            end
            else if ( (rd_MEM_WB_out == rt_ID_EX_out)) begin
                forwardB = 2'b01;
            end
        end
        else if(!RegWrite_MEM_WB_out  && RegWrite_EX_MEM_out) begin
            if((rd_EX_MEM_out == rs_ID_EX_out)) begin
                forwardA = 2'b10;
            end
            else if ((rd_EX_MEM_out == rt_ID_EX_out)) begin
                forwardB = 2'b10;
            end
        end
        */
    end
endmodule





        