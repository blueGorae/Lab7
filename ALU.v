`include "opcodes.v"

    module ALU(ALUIn_A, ALUIn_B, PCUpdate, B_OP, ALUOp, opcode, ALU_Result, B_cond, reset_n, clk);

	input [`WORD_SIZE-1:0] ALUIn_A;
	input [`WORD_SIZE-1:0] ALUIn_B;
	input PCUpdate;
	input B_OP;
	input [2:0] ALUOp;
	input [3:0] opcode;
	input reset_n;
	input clk;
	
	output [`WORD_SIZE-1:0] ALU_Result;
	output	B_cond;
	
	reg [`WORD_SIZE-1:0] ALU_Result;
	reg B_cond;
	// You can declare any variables as needed.
	
	initial begin
		ALU_Result <= `WORD_SIZE'bz;
		B_cond <= 0;
	end
	always @(negedge reset_n) begin
		ALU_Result <= `WORD_SIZE'bz;
		B_cond <= 0;
	end

	// TODO: You should implement the functionality of ALU!
	// (HINT: Use 'always @(...) begin ... end')

	always @(posedge PCUpdate) begin
		ALU_Result <= $signed(ALUIn_A) + $signed(ALUIn_B);
	end

	always @(posedge clk) begin
		if(B_OP)begin
			B_cond = 0;
			case (opcode) 
					`BNE_OP : B_cond <= ($signed(ALUIn_A) != $signed(ALUIn_B));
					`BEQ_OP	: B_cond <= ($signed(ALUIn_A)  == $signed(ALUIn_B));
					`BGZ_OP	: B_cond <= ($signed(ALUIn_A)  > 0);
					`BLZ_OP : B_cond <= ($signed(ALUIn_A)  < 0);
					default : B_cond <= 0;
			endcase
		end
	end
	
	always @(*) begin
		case(ALUOp)
			`FUNC_ADD: ALU_Result <= $signed(ALUIn_A)  + $signed(ALUIn_B);
			`FUNC_SUB: ALU_Result <= $signed(ALUIn_A)  - $signed(ALUIn_B);
			`FUNC_AND: ALU_Result <= $signed(ALUIn_A)  & $signed(ALUIn_B);
			`FUNC_ORR: ALU_Result <= $signed(ALUIn_A)  | $signed(ALUIn_B);
 			`FUNC_NOT: ALU_Result <= ~$signed(ALUIn_A) ;
			`FUNC_TCP: ALU_Result <= ~$signed(ALUIn_A)  + 1;
			`FUNC_SHL: ALU_Result <= $signed(ALUIn_A)  << 1;
			`FUNC_SHR: ALU_Result <= $signed(ALUIn_A) >>> 1;
		endcase

		if(!PCUpdate) begin
			case (opcode) 
					`JMP_OP : ALU_Result <= ($signed(ALUIn_A)  & (16'hf000)) | $signed(ALUIn_B);
					`JAL_OP : ALU_Result <= ($signed(ALUIn_A)  & (16'hf000)) | $signed(ALUIn_B);
					`LHI_OP : ALU_Result <= (ALUIn_B)  << 8;
			endcase
		end


	end	

    
endmodule