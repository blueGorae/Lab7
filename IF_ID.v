`include "opcodes.v"

module IF_ID(clk, reset_n, PC_in, Instruction_in, PC_out, Instruction_out);
    input clk, reset_n;
    input [`WORD_SIZE-1:0] PC_in, Instruction_in;

    output [`WORD_SIZE-1:0] PC_out, Instruction_out;

    reg [`WORD_SIZE-1:0] PC_out, Instruction_out;

    // reg [`WORD_SIZE-1:0] PC_reg;
    // reg [`WORD_SIZE-1:0] Instruction_reg;


    initial begin
        PC_out = `WORD_SIZE'bz;
        Instruction_out = `WORD_SIZE'bz;

        // PC_out = PC_reg;
        // Instruction_out = Instruction_reg;
    end

    always @(negedge reset_n) begin
        PC_out = `WORD_SIZE'bz;
        Instruction_out = `WORD_SIZE'bz;
        
        // PC_out = PC_reg;
        // Instruction_out = Instruction_reg;
    end

    always @(posedge clk) begin
        if(reset_n)begin
            PC_out = PC_in;
            Instruction_out = Instruction_in;

            // PC_reg = PC_in;
            // Instruction_reg = Instruction_in;
        end
    end

endmodule