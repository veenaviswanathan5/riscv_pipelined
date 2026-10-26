module if_id_reg (
    input  logic        clk,
    input  logic        reset,
    input  logic        clear,
    input  logic        en,
    
    // Data inputs (from Fetch stage)
    input  logic [31:0] pc_f,
    input  logic [31:0] instr_f,
    input  logic [31:0] pc_plus_4_f,
    
    // Data outputs (to Decode stage)
    output logic [31:0] pc_d,
    output logic [31:0] instr_d,
    output logic [31:0] pc_plus_4_d
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_d        <= 32'b0;
            instr_d     <= 32'b0;
            pc_plus_4_d <= 32'b0;
        end else if (clear) begin
            // Flush injects a bubble (zeros out the instruction)
            pc_d        <= 32'b0;
            instr_d     <= 32'b0;
            pc_plus_4_d <= 32'b0;
        end else if (en) begin
            // Pass the data through the wall if not stalled
            pc_d        <= pc_f;
            instr_d     <= instr_f;
            pc_plus_4_d <= pc_plus_4_f;
        end
    end

endmodule