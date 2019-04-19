`include "opcodes.v"

module IF_ID(Clk, Reset_N, PC, Instruction);
    input Clk, Reset_N;
    inout [`WORD_SIZE-1:0] PC, Instruction;
    
    reg [`WORD_SIZE-1:0] PC_reg;
    reg [`WORD_SIZE-1:0] Instruction_reg;

    wire [`WORD_SIZE-1:0] PC_out;
    wire [`WORD_SIZE-1:0] Instruction_out;

    assign PC = PC_reg;
    assign Instruction = Instruction_reg;

    initial begin
        PC_reg <= `WORD_SIZE'bz;
        Instruction_reg <= `WORD_SIZE'bz0;
    end

    always @(negedge Reset_N) begin
        PC_reg <= `WORD_SIZE'bz;
        Instruction_reg <= `WORD_SIZE'bz0;
    end

    always @(posedge Clk) begin
        PC_reg <= PC;
        Instruction_reg <= Instruction;
    end

endmodule