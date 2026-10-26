module mem_wb_reg (
    input  logic        clk,
    input  logic        reset,
    
    // Control inputs
    input  logic        RegWrite_m,
    input  logic [1:0]  ResultSrc_m, // UPDATED: Now 2 bits
    
    // Control outputs
    output logic        RegWrite_w,
    output logic [1:0]  ResultSrc_w,
    
    // Data inputs
    input  logic [31:0] alu_result_m,
    input  logic [31:0] readData_m,
    input  logic [31:0] pc_plus_4_m, // ADDED
    input  logic [4:0]  rd_m,
    
    // Data outputs
    output logic [31:0] alu_result_w,
    output logic [31:0] readData_w,
    output logic [31:0] pc_plus_4_w, // ADDED
    output logic [4:0]  rd_w
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_w   <= 0;
            ResultSrc_w  <= 2'b00;
            alu_result_w <= 0;
            readData_w   <= 0;
            pc_plus_4_w  <= 0;
            rd_w         <= 0;
        end else begin
            RegWrite_w   <= RegWrite_m;
            ResultSrc_w  <= ResultSrc_m;
            alu_result_w <= alu_result_m;
            readData_w   <= readData_m;
            pc_plus_4_w  <= pc_plus_4_m;
            rd_w         <= rd_m;
        end
    end
endmodule