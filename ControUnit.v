`include "opcodes.v"

module ControlUnit(instruction, ackOutput, inputReady, RegWrite, ALUSrc, MemWrite, ALUOp, MemtoReg, DataMemRead, InstMemRead, Branch, Jump, RegDst, R_type, I_type, J_type, S_type, L_type, reset_n, clk);
	inout [`WORD_SIZE-1:0] instruction;
	input ackOutput, inputReady;
	input reset_n, clk;
	
	output RegWrite;
	output ALUSrc;
	output MemWrite;
	output[2:0] ALUOp;
	output MemtoReg;
	output DataMemRead;
	output InstMemRead;
	output Branch;
	output Jump;
	output RegDst;

	output R_type, I_type, J_type, S_type, L_type;
	
	reg RegWrite;
	reg ALUSrc;
	reg MemWrite;
	reg [2:0]ALUOp;
	reg MemtoReg;
	reg DataMemRead;
	reg InstMemRead;
	reg Branch;
	reg Jump;
	reg RegDst;
	
	reg R_type, I_type, J_type, S_type, L_type;
	wire [3:0]opcode;
	wire [5:0]func;

	initial begin
	    RegWrite <= 0;
	    ALUSrc <= 0;
	    MemWrite <= 0;
	    ALUOp <= 0;
	    MemtoReg <= 0;
	    DataMemRead <= 0;
	    InstMemRead <= 1;
	    Branch <= 0;
	    Jump <= 0;
	    RegDst <= 0;
	    R_type <=0;
	    I_type <= 0;
	    J_type <=0;
	    S_type <= 0;
	    L_type <=0;
	end
	
	

	
	assign opcode = instruction[`WORD_SIZE-1:12];
	assign func = instruction[5:0];
	 
	//when reset was set, initialize each value. 

	always @ (negedge reset_n) begin
		RegWrite <= 0;
		ALUSrc <= 0;
		MemWrite <= 0;
		ALUOp <= 0;
		MemtoReg <= 0;
		DataMemRead <= 0;
		InstMemRead <= 1;
		Branch <= 0;
		Jump <= 0;
		RegDst <= 0;
		R_type <=0;
	    I_type <= 0;
	    J_type <=0;
	    S_type <= 0;
	    L_type <=0;
	end

	always @ (posedge clk) begin
		RegWrite <= 0;
		ALUSrc <= 0;
		MemWrite <= 0;
		ALUOp <= 0;
		MemtoReg <= 0;
		DataMemRead <= 0;
		InstMemRead <= 1;
		Branch <= 0;
		Jump <= 0;
		RegDst <= 0;
		R_type <=0;
	    I_type <= 0;
	    J_type <=0;
	    S_type <= 0;
	    L_type <=0;
	end

	always @(instruction) begin
		
		case (func)
			`INST_FUNC_ADD : ALUOp <= `FUNC_ADD ;
			`INST_FUNC_SUB : ALUOp <= `FUNC_SUB ;
			`INST_FUNC_AND : ALUOp <= `FUNC_AND ;
			`INST_FUNC_ORR : ALUOp <= `FUNC_ORR ;
			`INST_FUNC_NOT : ALUOp <= `FUNC_NOT ;
			`INST_FUNC_TCP : ALUOp <= `FUNC_TCP ;
			`INST_FUNC_SHL : ALUOp <= `FUNC_SHL ;
			`INST_FUNC_SHR : ALUOp <= `FUNC_SHR ;
			`INST_FUNC_JPR : ALUOp <= `FUNC_ADD ; 
			`INST_FUNC_JRL : ALUOp <= `FUNC_ADD ; 
		endcase

		case (opcode) 
			`ALU_OP: begin
				RegWrite <= 1;
				ALUSrc <= 0;
				MemWrite <= 0;
				MemtoReg <= 0;
				DataMemRead <= 0;
				InstMemRead <= 1;
				Branch <= 0;
				Jump <= 0;
				RegDst <= 1;
				R_type <=1;
				
			end
			`ADI_OP: begin
				RegWrite <= 1;
				ALUSrc <= 1;
				ALUOp <= `FUNC_ADD;
				MemWrite <= 0;
				MemtoReg <= 0;
				DataMemRead <= 0;
				InstMemRead <= 1;
				Branch <= 0;
				Jump <= 0;
				RegDst <= 0;
				I_type <= 1;
				
			end
			`ORI_OP: begin
				RegWrite <= 1;
				ALUSrc <= 1;
				ALUOp <= `FUNC_ORR;
				MemWrite <= 0;
				MemtoReg <= 0;
				DataMemRead <= 0;
				InstMemRead <= 1;
				Branch <= 0;
				Jump <= 0;
				RegDst <= 0;
				I_type <= 1;
			end
			`LHI_OP: begin
				RegWrite <= 1;
				ALUSrc <= 1;
				ALUOp <= `FUNC_SHL;
				MemWrite <= 0;
				MemtoReg <= 0;
				DataMemRead <= 0;
				InstMemRead <= 1;
				Branch <= 0;
				Jump <= 0;
				RegDst <= 0;
				I_type <= 1;
			end
			`LWD_OP: begin
				RegWrite <= 0;
				ALUSrc <= 1;
				ALUOp <= `FUNC_ADD;
				MemWrite <= 0;
				MemtoReg <= 1;
				DataMemRead <= 1;
				InstMemRead <=1;
				Branch <= 0;
				Jump <= 0;
				RegDst <= 0;
				I_type <= 1;
				L_type <= 1;
			end
			`SWD_OP: begin
				RegWrite <= 0;
				ALUSrc <= 1;
				ALUOp <= `FUNC_ADD;
				MemWrite <= 1;
				MemtoReg <= 0;
				DataMemRead <= 0;
				InstMemRead <= 1;
				Branch <= 0;
				Jump <= 0;
				RegDst <= 0;
				I_type <= 1;
				S_type <= 1;
			end  
			`BNE_OP: begin
				RegWrite <= 0;
				ALUSrc <= 0;
				ALUOp <= `FUNC_SUB;
				MemWrite <= 0;
				MemtoReg <= 0;
				DataMemRead <= 0;
				InstMemRead <= 1;
				Branch <= 1;
				Jump <= 0;
				RegDst <= 0;
				I_type <= 1;
				
			end 
			`BEQ_OP: begin
				RegWrite <= 0;
				ALUSrc <= 0;
				ALUOp <= `FUNC_SUB;
				MemWrite <= 0;
				MemtoReg <= 0;
				DataMemRead <= 0;
				InstMemRead <= 1;
				Branch <= 1;
				Jump <= 0;
				RegDst <= 0;
				I_type <= 1;
				
			end 	
			`BGZ_OP: begin
				RegWrite <= 0;
				ALUSrc <= 0;
				ALUOp <= `FUNC_SUB;
				MemWrite <= 0;
				MemtoReg <= 0;
				DataMemRead <= 0;
				InstMemRead <= 1;
				Branch <= 1;
				Jump <= 0;
				RegDst <= 0;
				I_type <= 1;
				
			end
			`BLZ_OP: begin
				RegWrite <= 0;
				ALUSrc <= 0;
				ALUOp <= `FUNC_SUB;
				MemWrite <= 0;
				MemtoReg <= 0;
				DataMemRead <= 0;
				InstMemRead <= 1;
				Branch <= 1;
				Jump <= 0;
				RegDst <= 0;
				I_type <= 1;
				
			end 	
			`JMP_OP: begin
				RegWrite <= 0;
				ALUSrc <= 0;
				ALUOp <= `FUNC_ORR;
				MemWrite <= 0;
				MemtoReg <= 0;
				DataMemRead <= 0;
				InstMemRead <= 1;
				Branch <= 0;
				Jump <= 1;
				RegDst <= 0;
				J_type <= 1;
			end 
			`JAL_OP: begin
				RegWrite <= 1;
				ALUSrc <= 0;
				ALUOp <= `FUNC_ORR;
				MemWrite <= 0;
				MemtoReg <= 0;
				DataMemRead <= 0;
				InstMemRead <= 1;
				Branch <= 0;
				Jump <= 1;
				RegDst <= 1;
				J_type <= 1;
				
			end 
			`JPR_OP: begin
				RegWrite <= 0;
				ALUSrc <= 0;
				ALUOp <= `FUNC_ADD;
				MemWrite <= 0;
				MemtoReg <= 0;
				DataMemRead <= 0;
				InstMemRead <= 1;
				Branch <= 0;
				Jump <= 1;
				RegDst <= 0;
				R_type <=1;
			end 
			`JRL_OP: begin
				RegWrite <= 1;
				ALUSrc <= 0;
				ALUOp <= `FUNC_ADD;
				MemWrite <= 0;
				MemtoReg <= 0;
				DataMemRead <= 0;
				InstMemRead <= 1;
				Branch <= 0;
				Jump <= 1;
				RegDst <= 1;
				R_type <= 1;
				
			end 
		endcase
		
	end

endmodule 