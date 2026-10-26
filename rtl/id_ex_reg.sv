module id_ex_reg (
    input  logic        clk,
    input  logic        reset,
    input  logic        clear,
    input  logic        en,
    
    // Control inputs
    input  logic        RegWrite_d,
    input  logic [1:0]  ResultSrc_d,  // UPDATED: Now 2 bits
    input  logic        MemWrite_d,
    input  logic        Jump_d,       // ADDED: For jal/jalr
    input  logic        Branch_d,
    input  logic        ALUSrc_d,
    input  logic [2:0]  alu_ctrl_d,
    
    // Control outputs
    output logic        RegWrite_e,
    output logic [1:0]  ResultSrc_e,  // UPDATED: Now 2 bits
    output logic        MemWrite_e,
    output logic        Jump_e,       // ADDED
    output logic        Branch_e,
    output logic        ALUSrc_e,
    output logic [2:0]  alu_ctrl_e,
    
    // Data inputs
    input  logic [31:0] rd1_d,
    input  logic [31:0] rd2_d,
    input  logic [31:0] pc_d,
    input  logic [31:0] imm_ext_d,
    input  logic [31:0] pc_plus_4_d,
    
    // Data outputs
    output logic [31:0] rd1_e,
    output logic [31:0] rd2_e,
    output logic [31:0] pc_e,
    output logic [31:0] imm_ext_e,
    output logic [31:0] pc_plus_4_e,
    
    // Address inputs/outputs
    input  logic [4:0]  rs1_d, rs2_d, rd_d,
    output logic [4:0]  rs1_e, rs2_e, rd_e
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_e  <= 0;
            ResultSrc_e <= 2'b00;
            MemWrite_e  <= 0;
            Jump_e      <= 0;
            Branch_e    <= 0;
            ALUSrc_e    <= 0;
            alu_ctrl_e  <= 3'b000;
            rd1_e       <= 0;
            rd2_e       <= 0;
            pc_e        <= 0;
            imm_ext_e   <= 0;
            pc_plus_4_e <= 0;
            rs1_e       <= 0;
            rs2_e       <= 0;
            rd_e        <= 0;
        end else if (clear) begin
            RegWrite_e  <= 0;
            ResultSrc_e <= 2'b00;
            MemWrite_e  <= 0;
            Jump_e      <= 0;
            Branch_e    <= 0;
            ALUSrc_e    <= 0;
            alu_ctrl_e  <= 3'b000;
            rd1_e       <= 0;
            rd2_e       <= 0;
            pc_e        <= 0;
            imm_ext_e   <= 0;
            pc_plus_4_e <= 0;
            rs1_e       <= 0;
            rs2_e       <= 0;
            rd_e        <= 0;
        end else if (en) begin
            RegWrite_e  <= RegWrite_d;
            ResultSrc_e <= ResultSrc_d;
            MemWrite_e  <= MemWrite_d;
            Jump_e      <= Jump_d;
            Branch_e    <= Branch_d;
            ALUSrc_e    <= ALUSrc_d;
            alu_ctrl_e  <= alu_ctrl_d;
            rd1_e       <= rd1_d;
            rd2_e       <= rd2_d;
            pc_e        <= pc_d;
            imm_ext_e   <= imm_ext_d;
            pc_plus_4_e <= pc_plus_4_d;
            rs1_e       <= rs1_d;
            rs2_e       <= rs2_d;
            rd_e        <= rd_d;
        end
    end
endmodule