`include "opcodes.v"

module Adder(Clk, Reset_N, ADDIn_A, ADDIn_B, opcode, ADD_Result);
    input Clk, Reset_N;
    input [`WORD_SIZE-1 :0] ADDIn_A, ADDIn_B;
    input [3:0] opcode;

    output [`WORD_SIZE-1:0] ADD_Result;
	reg [`WORD_SIZE-1:0] ADD_Result;

    initial begin
        ADD_Result <= `WORD_SIZE'bz;
    end

    always @(negedge Reset_N) begin
        ADD_Result <= `WORD_SIZE'bz;
    end

    always @(*) begin
        case (opcode) 
			`JMP_OP : ADD_Result <= ($signed(ALUIn_A)  & (16'hf000)) | $signed(ALUIn_B);
			`JAL_OP : ADD_Result <= ($signed(ALUIn_A)  & (16'hf000)) | $signed(ALUIn_B);
            default : ADD_Result <= ALUIn_A + ALUIn_B;
        endcase
    end
    
endmodule
