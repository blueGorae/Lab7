`include "opcodes.v"

module ControlUnit(clk, reset_n, instruction, PCSrc, RegWrite, ALUSrcB, MemWrite, ALUOp, MemtoReg, MemRead, readM1, B_OP, is_wwd, halted_op, R_type, I_type, J_type, S_type, L_type, is_done);

	input [`WORD_SIZE-1:0] instruction;
	input reset_n, clk;


	output [1:0] PCSrc;
	output RegWrite;
	output ALUSrcB;
	output MemWrite;
	output [2:0]ALUOp;
	output MemtoReg;
	output MemRead;
	output readM1;
	output B_OP;
	output R_type, I_type, J_type, S_type, L_type;
	output is_wwd;
    output halted_op;
	output is_done;

	reg [1:0] PCSrc;
	reg RegWrite;
	reg ALUSrcB;
	reg MemWrite;
	reg [2:0]ALUOp;
	reg MemtoReg;
	reg MemRead;
	reg readM1;
	reg B_OP;
	reg R_type, I_type, J_type, S_type, L_type;
	reg is_wwd;
    reg halted_op;
	reg is_done;

    wire [3:0]opcode;
	wire [5:0]func;
	assign opcode = instruction[`WORD_SIZE-1:12];
	assign func = instruction[5:0];

	initial begin
		PCSrc <= 2'b0;
	    RegWrite <= 1'b0;
	    ALUSrcB <= 1'b0;
	    MemWrite <= 1'b0;
	    ALUOp <= 3'b0;
	    MemtoReg <= 1'b0;
	    MemRead <= 1'b0;
	    readM1 <= 1'b1;
	    B_OP <= 1'b0;
	    R_type <= 1'b0;
	    I_type <= 1'b0;
	    J_type <= 1'b0;
	    S_type <= 1'b0;
	    L_type <= 1'b0;
	    is_wwd <= 1'b0;
        halted_op <= 1'b0;
		is_done <= 1'b0;
	end
	
	//when reset was set, initialize each value. 
	always @ (negedge reset_n) begin
		PCSrc <= 2'b0;
	    RegWrite <= 1'b0;
	    ALUSrcB <= 1'b0;
	    MemWrite <= 1'b0;
	    ALUOp <= 3'b0;
	    MemtoReg <= 1'b0;
	    MemRead <= 1'b0;
	    readM1 <= 1'b1;
	    B_OP <= 1'b0;
	    R_type <= 1'b0;
	    I_type <= 1'b0;
	    J_type <= 1'b0;
	    S_type <= 1'b0;
	    L_type <= 1'b0;
	    is_wwd <= 1'b0;
        halted_op <= 1'b0;
		is_done <= 1'b0;
	end

	always @(*) begin
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
			default : ALUOp <= 3'bz;
		endcase
		case (opcode)
			`ALU_OP: begin // 15
				if(func != 6'd28 && func != 6'd29 && func != 6'd25 && func != 6'd26) begin 
					PCSrc <= 2'b0;
					RegWrite <= 1;
					ALUSrcB <= 0;
					MemWrite <= 0;
					MemtoReg <= 0;
					MemRead <= 0;
					readM1 <= 1;
					B_OP <= 0;
					R_type <=1;
					I_type <= 0;
					J_type <= 0;
					S_type <= 0;
					L_type <= 0;
					is_wwd <= 0;
					halted_op <= 0;
					is_done <= 1'b1;
				end
				
				else if(func == `WWD) begin //WWD
					is_wwd <= 1;
					PCSrc <= 2'b0;
					RegWrite <= 1'b0;
					ALUSrcB <= 1'b0;
					MemWrite <= 1'b0;
					ALUOp <= 3'b0;
					MemtoReg <= 1'b0;
					MemRead <= 1'b0;
					readM1 <= 1'b1;
					B_OP <= 1'b0;
					R_type <= 1'b1;
					I_type <= 1'b0;
					J_type <= 1'b0;
					S_type <= 1'b0;
					L_type <= 1'b0;
					halted_op <= 1'b0;
					is_done <= 1'b1;
				end
				else if(func == `HALT) begin //halt
					halted_op <= 1;
					PCSrc <= 2'b0;
					RegWrite <= 1'b0;
					ALUSrcB <= 1'b0;
					MemWrite <= 1'b0;
					ALUOp <= 3'b0;
					MemtoReg <= 1'b0;
					MemRead <= 1'b0;
					readM1 <= 1'b1;
					B_OP <= 1'b0;
					R_type <= 1'b1;
					I_type <= 1'b0;
					J_type <= 1'b0;
					S_type <= 1'b0;
					L_type <= 1'b0;
					is_wwd <= 0;
					is_done <= 1'b1;			
				end
				else if (func == 6'd25) begin //JPR
					PCSrc <= 2'b10;
					RegWrite <= 0;
					ALUOp <= 3'bz;
					ALUSrcB <= 1'bz;
					MemWrite <= 0;
					MemtoReg <= 0;
					MemRead <= 0;
					readM1 <= 1;
					B_OP <= 0;
					R_type <= 1;
					I_type <= 0;
					J_type <= 0;
					S_type <= 0;
					L_type <= 0;
					is_wwd <= 0;
					halted_op <= 0;
					is_done <= 1'b1;			
				end
				else if(func == 6'd26) begin //JRL
					PCSrc <= 2'b10;
					RegWrite <= 1;
					ALUOp <= 3'bz;
					ALUSrcB <= 1'bz;
					MemWrite <= 0;
					MemtoReg <= 0;
					MemRead <= 0;
					readM1 <= 1;
					B_OP <= 0;
					R_type <= 1;
					I_type <= 0;
					J_type <= 0;
					S_type <= 0;
					L_type <= 0;
					is_wwd <= 0;
					halted_op <= 0;
					is_done <= 1'b1;			
				end
			end

			`ADI_OP: begin
				PCSrc <= 2'b0;
				RegWrite <= 1;
				ALUOp <= `FUNC_ADD;
				ALUSrcB <= 1;
				MemWrite <= 0;
				MemtoReg <= 0;
				MemRead <= 0;
				readM1 <= 1;
				B_OP <= 0;
				R_type <= 0;
				I_type <= 1;
				J_type <= 0;
				S_type <= 0;
				L_type <= 0;
				is_wwd <= 0;
				halted_op <= 0;
				is_done <= 1'b1;			
			end
			`ORI_OP: begin
				PCSrc <= 2'b0;
				RegWrite <= 1;
				ALUOp <= `FUNC_ORR;
				ALUSrcB <= 1;
				MemWrite <= 0;
				MemtoReg <= 0;
				MemRead <= 0;
				readM1 <= 1;
				B_OP <= 0;
				R_type <= 0;
				I_type <= 1;
				J_type <= 0;
				S_type <= 0;
				L_type <= 0;
				is_wwd <= 0;
				halted_op <= 0;
				is_done <= 1'b1;			
			end
			`LHI_OP: begin
				PCSrc <= 2'b0;
				RegWrite <= 1;
				ALUOp <= 3'bz;
				ALUSrcB <= 1;
				MemWrite <= 0;
				MemtoReg <= 0;
				MemRead <= 0;
				readM1 <= 1;
				B_OP <= 0;
				R_type <= 0;
				I_type <= 1;
				J_type <= 0;
				S_type <= 0;
				L_type <= 0;
				is_wwd <= 0;
				halted_op <= 0;
				is_done <= 1'b1;			
			end
			`LWD_OP: begin
				PCSrc <= 2'b0;
				RegWrite <= 1;
				ALUOp <= `FUNC_ADD;
				ALUSrcB <= 1;
				MemWrite <= 0;
				MemtoReg <= 1;
				MemRead <= 1;
				readM1 <= 1;
				B_OP <= 0;
				R_type <= 0;
				I_type <= 1;
				J_type <= 0;
				S_type <= 0;
				L_type <= 1;
				is_wwd <= 0;
				halted_op <= 0;
				is_done <= 1'b1;			
			end
			`SWD_OP: begin
				PCSrc <= 2'b0;
				RegWrite <= 0;
				ALUOp <= `FUNC_ADD;
				ALUSrcB <= 1;
				MemWrite <= 1;
				MemtoReg <= 0;
				MemRead <= 0;
				readM1 <= 1;
				B_OP <= 0;
				R_type <= 0;
				I_type <= 1;
				J_type <= 0;
				S_type <= 1;
				L_type <= 0;
				is_wwd <= 0;
				halted_op <= 0;
				is_done <= 1'b1;			
			end  
			`BNE_OP: begin
				PCSrc <= 2'b0;
				RegWrite <= 0;
				ALUOp <= 3'bz;
				ALUSrcB <= 1;
				MemWrite <= 0;
				MemtoReg <= 0;
				MemRead <= 0;
				readM1 <= 1;
				B_OP <= 1;
				R_type <= 0;
				I_type <= 1;
				J_type <= 0;
				S_type <= 0;
				L_type <= 0;
				is_wwd <= 0;
				halted_op <= 0;
				is_done <= 1'b1;			
			end 
			`BEQ_OP: begin
				PCSrc <= 2'b0;
				RegWrite <= 0;
				ALUOp <= 3'bz;
				ALUSrcB <= 1;
				MemWrite <= 0;
				MemtoReg <= 0;
				MemRead <= 0;
				readM1 <= 1;
				B_OP <= 1;
				R_type <= 0;
				I_type <= 1;
				J_type <= 0;
				S_type <= 0;
				L_type <= 0;
				is_wwd <= 0;
				halted_op <= 0;
				is_done <= 1'b1;			
			end 	
			`BGZ_OP: begin
				PCSrc <= 2'b0;
				RegWrite <= 0;
				ALUOp <= 3'bz;
				ALUSrcB <= 1;
				MemWrite <= 0;
				MemtoReg <= 0;
				MemRead <= 0;
				readM1 <= 1;
				B_OP <= 1;
				R_type <= 0;
				I_type <= 1;
				J_type <= 0;
				S_type <= 0;
				L_type <= 0;
				is_wwd <= 0;
				halted_op <= 0;
				is_done <= 1'b1;			
			end
			`BLZ_OP: begin
				PCSrc <= 2'b0;
				RegWrite <= 0;
				ALUOp <= 3'bz;
				ALUSrcB <= 1;
				MemWrite <= 0;
				MemtoReg <= 0;
				MemRead <= 0;
				readM1 <= 1;
				B_OP <= 1;
				R_type <= 0;
				I_type <= 1;
				J_type <= 0;
				S_type <= 0;
				L_type <= 0;
				is_wwd <= 0;
				halted_op <= 0;
				is_done <= 1'b1;			
			end 
			`JMP_OP: begin
				PCSrc <= 2'b01;
				RegWrite <= 0;
				ALUOp <= 3'bz;
				ALUSrcB <= 1'bz;
				MemWrite <= 0;
				MemtoReg <= 0;
				MemRead <= 0;
				readM1 <= 1;
				B_OP <= 0;
				R_type <= 0;
				I_type <= 0;
				J_type <= 1;
				S_type <= 0;
				L_type <= 0;
				is_wwd <= 0;
				halted_op <= 0;
				is_done <= 1'b1;			
			end 
			`JAL_OP: begin
				PCSrc <= 2'b01;
				RegWrite <= 1;
				ALUOp <= 3'bz;
				ALUSrcB <= 1'bz;
				MemWrite <= 0;
				MemtoReg <= 0;
				MemRead <= 0;
				readM1 <= 1;
				B_OP <= 0;
				R_type <= 0;
				I_type <= 0;
				J_type <= 1;
				S_type <= 0;
				L_type <= 0;
				is_wwd <= 0;
				halted_op <= 0;
				is_done <= 1'b1;			
			end 
			// default: begin
			// 	PCSrc <= 2'b0;
			// 	RegWrite <= 1'b0;
			// 	ALUSrcB <= 1'b0;
			// 	MemWrite <= 1'b0;
			// 	ALUOp <= 3'b0;
			// 	MemtoReg <= 1'b0;
			// 	MemRead <= 1'b0;
			// 	readM1 <= 1'b1;
			// 	B_OP <= 1'b0;
			// 	R_type <= 1'b0;
			// 	I_type <= 1'b0;
			// 	J_type <= 1'b0;
			// 	S_type <= 1'b0;
			// 	L_type <= 1'b0;
			// 	is_wwd <= 1'b0;
			// 	halted_op <= 1'b0;
			// 	is_done <= 1'b0;
			// end
		endcase	
	end

endmodule 