`include "opcodes.v"

module ALU(clk, reset_n, ALUIn_A, ALUIn_B, ALUOp, opcode, ALU_Result);

	input [`WORD_SIZE-1:0] ALUIn_A;
	input [`WORD_SIZE-1:0] ALUIn_B;
	input [2:0] ALUOp;
	input [3:0] opcode;
	input reset_n;
	input clk;
	
	output [`WORD_SIZE-1:0] ALU_Result;
	
	reg [`WORD_SIZE-1:0] ALU_Result;
	// You can declare any variables as needed.
	
	initial begin
		ALU_Result <= `WORD_SIZE'bz;
	end

	always @(negedge reset_n) begin
		ALU_Result <= `WORD_SIZE'bz;
	end

	// TODO: You should implement the functionality of ALU!
	// (HINT: Use 'always @(...) begin ... end')


	always @(*) begin
		if(opcode == `ALU_OP) begin 
			case(ALUOp)
				`FUNC_ADD: ALU_Result <= $signed(ALUIn_A)  + $signed(ALUIn_B);
				`FUNC_SUB: ALU_Result <= $signed(ALUIn_A)  - $signed(ALUIn_B);
				`FUNC_AND: ALU_Result <= $signed(ALUIn_A)  & $signed(ALUIn_B);
				`FUNC_ORR: ALU_Result <= $signed(ALUIn_A)  | $signed(ALUIn_B);
				`FUNC_NOT: ALU_Result <= ~$signed(ALUIn_A) ;
				`FUNC_TCP: ALU_Result <= ~$signed(ALUIn_A)  + 1;
				`FUNC_SHL: ALU_Result <= $signed(ALUIn_A)  << 1;
				`FUNC_SHR: ALU_Result <= $signed(ALUIn_A) >>> 1;
				default : ALU_Result <= (ALUIn_A);
			endcase
		end
		else begin
			case (opcode) 
				`LHI_OP : ALU_Result <= (ALUIn_B) << 8;
				`ADI_OP : ALU_Result <= $signed(ALUIn_A)  + $signed(ALUIn_B);
				`ORI_OP : ALU_Result <= $signed(ALUIn_A)  | $signed(ALUIn_B);
				`LWD_OP : ALU_Result <= $signed(ALUIn_A)  + $signed(ALUIn_B);
				`SWD_OP : ALU_Result <= $signed(ALUIn_A)  + $signed(ALUIn_B);
				default : ALU_Result <= (ALUIn_A);
			endcase
		end
	end	
endmodule