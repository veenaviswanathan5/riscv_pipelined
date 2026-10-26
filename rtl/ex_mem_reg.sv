module ex_mem_reg (
    input  logic        clk,
    input  logic        reset,
    
    // Control inputs
    input  logic        RegWrite_e,
    input  logic [1:0]  ResultSrc_e, // UPDATED: Now 2 bits
    input  logic        MemWrite_e,
    
    // Control outputs
    output logic        RegWrite_m,
    output logic [1:0]  ResultSrc_m,
    output logic        MemWrite_m,
    
    // Data inputs
    input  logic [31:0] alu_result_e,
    input  logic [31:0] writeData_e,
    input  logic [31:0] pc_plus_4_e, // ADDED: PC+4 pipeline passthrough
    input  logic [4:0]  rd_e,
    
    // Data outputs
    output logic [31:0] alu_result_m,
    output logic [31:0] writeData_m,
    output logic [31:0] pc_plus_4_m, // ADDED
    output logic [4:0]  rd_m
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_m   <= 0;
            ResultSrc_m  <= 2'b00;
            MemWrite_m   <= 0;
            alu_result_m <= 0;
            writeData_m  <= 0;
            pc_plus_4_m  <= 0;
            rd_m         <= 0;
        end else begin
            RegWrite_m   <= RegWrite_e;
            ResultSrc_m  <= ResultSrc_e;
            MemWrite_m   <= MemWrite_e;
            alu_result_m <= alu_result_e;
            writeData_m  <= writeData_e;
            pc_plus_4_m  <= pc_plus_4_e;
            rd_m         <= rd_e;
        end
    end
endmodule