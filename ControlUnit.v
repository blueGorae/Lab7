`include "opcodes.v"

module ControlUnit(clk, reset_n, instruction, RegWrite, ALUSrcB, MemWrite, ALUOp, MemtoReg, MemRead, readM1, B_OP, is_wwd, halted_op, R_type, I_type, J_type, S_type, L_type);

	inout [`WORD_SIZE-1:0] instruction;
	input reset_n, clk;
	
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

    wire [3:0]opcode;
	wire [5:0]func;
	assign opcode = instruction[`WORD_SIZE-1:12];
	assign func = instruction[5:0];

	initial begin
	    RegWrite <= 1'bz;
	    ALUSrcB <= 1'bz;
	    MemWrite <= 1'bz;
	    ALUOp <= 3'bz;
	    MemtoReg <= 1'bz;
	    MemRead <= 1'bz;
	    readM1 <= 1'bz;
	    B_OP <= 1'b0;
	    R_type <= 1'bz;
	    I_type <= 1'bz;
	    J_type <= 1'bz;
	    S_type <= 1'bz;
	    L_type <= 1'bz;
	    is_wwd <= 1'bz;
        halted_op <= 1'bz;
	end
	
	//when reset was set, initialize each value. 
	always @ (negedge reset_n) begin
	    RegWrite <= 1'bz;
	    ALUSrcB <= 1'bz;
	    MemWrite <= 1'bz;
	    ALUOp <= 3'bz;
	    MemtoReg <= 1'bz;
	    MemRead <= 1'bz;
	    readM1 <= 1'bz;
	    B_OP <= 1'b0;
	    R_type <= 1'bz;
	    I_type <= 1'bz;
	    J_type <= 1'bz;
	    S_type <= 1'bz;
	    L_type <= 1'bz;
	    is_wwd <= 1'bz;
        halted_op <= 1'bz;
	end

	always @(posedge clk) begin
	    is_wwd <= 0;
        halted_op <= 0;
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
            6'd28 :  is_wwd <= 1;
            6'd29 : halted_op <= 1;
            default : ALUOp <= 3'bz;
		endcase

		case (opcode) 
			`ALU_OP: begin // 15
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
			end
			`ADI_OP: begin
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
				
			end
			`ORI_OP: begin
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
			end
			`LHI_OP: begin
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
			end
			`LWD_OP: begin
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
			end
			`SWD_OP: begin
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
			end  
			`BNE_OP: begin
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
			end 
			`BEQ_OP: begin
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
			end 	
			`BGZ_OP: begin
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
			end
			`BLZ_OP: begin
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
			end 
			`JMP_OP: begin
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
			end 
			`JAL_OP: begin
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
			end 
			`JPR_OP: begin
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
			end 
			`JRL_OP: begin
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
			end
            
		endcase
		
	end

endmodule 