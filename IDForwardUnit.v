`include "opcodes.v"

module IDForwardUnit(clk, reset_n, RegWrite_ID_EX_out, RegWrite_EX_MEM_out, RegWrite_MEM_WB_out, rd_ID_EX_out, rd_EX_MEM_out, rd_MEM_WB_out, rs, rt, IDforwardA, IDforwardB);
    input clk, reset_n;

    input [1:0] rd_ID_EX_out;
    input [1:0] rd_EX_MEM_out;
    input [1:0] rd_MEM_WB_out;
    input [1:0] rs;
    input [1:0] rt;
    input RegWrite_ID_EX_out;
    input RegWrite_EX_MEM_out;
    input RegWrite_MEM_WB_out;


    output [1:0] IDforwardA;
    output [1:0] IDforwardB;

    reg [1:0] IDforwardA;
    reg [1:0] IDforwardB;

    initial begin
        IDforwardA <= 2'b0;
        IDforwardB <= 2'b0;
    end

    always @(negedge reset_n) begin
        IDforwardA <= 2'b0;
        IDforwardB <= 2'b0;
    end

    always @(*) begin

        IDforwardA = 2'b0;
        IDforwardB = 2'b0;

        if(RegWrite_MEM_WB_out  && !RegWrite_EX_MEM_out && !RegWrite_ID_EX_out)  begin 
            if((rd_MEM_WB_out == rs)) begin
                IDforwardA = 2'b01; //mem
            end
            else if ((rd_MEM_WB_out == rt)) begin
                IDforwardB = 2'b01;
            end
        end
        else if(RegWrite_EX_MEM_out && !RegWrite_MEM_WB_out  && !RegWrite_ID_EX_out) begin
            if((rd_EX_MEM_out == rs)) begin
                IDforwardA = 2'b10; //ex
            end
            else if ((rd_EX_MEM_out == rt)) begin
                IDforwardB = 2'b10;
            end
        end
        else if(RegWrite_ID_EX_out && !RegWrite_MEM_WB_out  && !RegWrite_EX_MEM_out) begin
            if((rd_ID_EX_out == rs)) begin
                IDforwardA = 2'b11; //id
            end
            else if ((rd_ID_EX_out == rt)) begin
                IDforwardB = 2'b11;
            end
        end
        
    end
endmodule



