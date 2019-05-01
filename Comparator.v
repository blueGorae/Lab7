`include "opcodes.v"

module Comparator(clk, reset_n, In_A, In_B, B_OP, opcode, B_cond);
    input clk, reset_n;
    input [`WORD_SIZE-1:0] In_A, In_B;
    input B_OP;
    input [3:0] opcode;
    output B_cond;
    reg B_cond;
    
  initial begin
		B_cond <= 0;
	end

	always @(negedge reset_n) begin
		B_cond <= 0;
	end


	always @(*) begin
		if(B_OP)begin
			B_cond = 0;
			case (opcode) 
					`BNE_OP : B_cond <= ($signed(In_A) != $signed(In_B));
					`BEQ_OP	: B_cond <= ($signed(In_A)  == $signed(In_B));
					`BGZ_OP	: B_cond <= ($signed(In_A)  > 0);
					`BLZ_OP : B_cond <= ($signed(In_A)  < 0);
					default : B_cond <= 0;
			endcase
		end
	end



endmodule