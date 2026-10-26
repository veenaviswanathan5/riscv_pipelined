// These directives tell the compiler to pull in the blueprints.
`include "program_counter.sv"
`include "pc_adder.sv"
`include "instr_mem.sv"
`include "Reg_file.sv"
`include "alu.sv"
`include "extender.sv"
`include "data_mem.sv"
`include "mux2.sv"
`include "branch_adder.sv"
`include "main_control.sv"
`include "alu_decoder.sv"
`include "control_unit.sv"
`include "flipflop.sv"
`include "clearable_ff.sv"
`include "if_id_reg.sv"
`include "id_ex_reg.sv"
`include "ex_mem_reg.sv"
`include "mem_wb_reg.sv"
`include "mux3.sv"
`include "hazard.sv"


module riscv_core (
  input logic clk,
  input logic reset,
  input logic clear
  
);
  // Your routing wires and module instantiations go here
  logic [31:0] alu_result_e;   //ALU output, feeds ex_mem_reg  
   //FETCH stage 
  
  logic [31:0] PC_f;
  logic [31:0] PCNext_f; 
  logic [31:0] PCPlus4_f; 
  logic [31:0] Instr_f;
  logic [31:0] PCTarget_e; //branch_adder output, feeds the PC mux (PCSrcE path)
  logic [1:0]  PCSrc_e;    // UPDATED: now 2 bits to support jalr
  logic StallF; 
  logic  StallD; 
  logic  FlushD; 
  logic [31:0] PC_d;
  logic [31:0] Instr_d;
  logic [31:0] PcPlus4_d;

  
  //instantiate   
 program_counter pc_inst (
    .clk      (clk),
    .reset    (reset),
    .en       (~StallF),
   .pc ( PC_f),
   .pc_next (PCNext_f)
 ); 
  
  pc_adder pc_adder_inst(
    .pc   (PC_f),
    .pc_next (PCPlus4_f)
  );
  
  
  instr_mem instr_mem_inst(
    .pc  (PC_f),
    .instr (Instr_f)
  );
  
  // UPDATED: pc_mux is now a 3-way mux to add the jalr target path
  // 00 = PC+4
  // 01 = Branch/jal target (PCTarget_e)
  // 10 = jalr target (alu_result_e)
  mux3  pc_mux (
    .s  (PCSrc_e),
    .d0 (PCPlus4_f), 
    .d1 (PCTarget_e),
    .d2 (alu_result_e),
    .y  (PCNext_f)
  ); 
  
  if_id_reg if_id_reg_inst (
    .clk      (clk),
    .reset    (reset),
    .clear    (FlushD),
    .en 	(~StallD),
    .pc_f     (PC_f),
    .instr_f   (Instr_f),
    .pc_plus_4_f (PCPlus4_f),
    .pc_d         (PC_d),
    .instr_d     (Instr_d),
    .pc_plus_4_d  (PcPlus4_d)
  );
    
  
  //DECODE stage 
  
logic        RegWrite_d;
  logic [1:0]       ResultSrc_d;  // UPDATED: now 2 bits to support jalr
logic        MemWrite_d;
logic        Branch_d;
logic        Jump_d;   // ADDED
logic        ALUSrc_d;
logic [1:0]  ImmSrc_d;
logic [2:0]  alu_ctrl_d;
//reg_file outputs
logic [31:0] rd1_d;
logic [31:0] rd2_d;
//extender output
logic [31:0] Imm_ext_d;
//id_ex_reg outputs — control
logic        RegWrite_e;
logic[1:0]        ResultSrc_e;  // UPDATED: now 2 bits to support jalr
logic        MemWrite_e;
logic        Branch_e;
logic        Jump_e;   // ADDED
logic        ALUSrc_e;
logic [2:0]  alu_ctrl_e;
//id_ex_reg outputs — data
logic [31:0] rd1_e;
logic [31:0] rd2_e;
logic [31:0] PC_e;
logic [31:0] Imm_ext_e;
logic [31:0] PcPlus4_e;
//id_ex_reg outputs — address
logic [4:0]  rs1_e;
logic [4:0]  rs2_e;
logic [4:0]  rd_e;

  // FUTURE WIRES
logic [31:0] Result_w;
logic [4:0]  rd_w;
logic        RegWrite_w;
logic[1:0]        ResultSrc_w;  // UPDATED: now 2 bits to support jalr
logic        FlushE;

  //instances 
control_unit control_unit_inst (
    .opcode    (Instr_d[6:0]),
    .funct3    (Instr_d[14:12]),
    .funct7b5  (Instr_d[30]),
    .RegWrite  (RegWrite_d),
    .ResultSrc (ResultSrc_d),
    .MemWrite  (MemWrite_d),
    .Jump      (Jump_d),   // ADDED
    .Branch    (Branch_d),
    .ALUSrc    (ALUSrc_d),
    .ImmSrc    (ImmSrc_d),
    .alu_ctrl  (alu_ctrl_d)
  );
  
  reg_file  reg_file_inst( 
    .clk (clk),
    .a1  (Instr_d[19:15]), 
    .a2  (Instr_d[24:20]), 
    .we3 (RegWrite_w),
    .a3 (rd_w),
    .wd3  (Result_w),
    .rd1   (rd1_d), 
    .rd2    (rd2_d)
  ); 
  
  extender  extender_inst( 
    .instr (Instr_d), 
    .imm_sel (ImmSrc_d), 
    .imm_ext  (Imm_ext_d)
  ); 
  
 id_ex_reg		id_ex_reg_inst( 
    .clk          (clk),
    .reset        (reset),
    .clear        (FlushE),     // Flush is controlled by the Hazard Unit
    .en           (1'b1),       // ID/EX register never stalls, it only flushes
    
    // Control inputs (From Control Unit)
    .RegWrite_d   (RegWrite_d),
    .ResultSrc_d  (ResultSrc_d),
    .MemWrite_d   (MemWrite_d),
    .Jump_d       (Jump_d),     // ADDED
    .Branch_d     (Branch_d),
    .ALUSrc_d     (ALUSrc_d),
    .alu_ctrl_d   (alu_ctrl_d),
    
    // Control outputs
    .RegWrite_e   (RegWrite_e),
    .ResultSrc_e  (ResultSrc_e),
    .MemWrite_e   (MemWrite_e),
    .Jump_e       (Jump_e),     // ADDED
    .Branch_e     (Branch_e),
    .ALUSrc_e     (ALUSrc_e),
    .alu_ctrl_e   (alu_ctrl_e),
    //data inputs 
    .rd1_d        (rd1_d),
    .rd2_d        (rd2_d),
    .pc_d         (PC_d),
    .imm_ext_d    (Imm_ext_d),
    .pc_plus_4_d  (PcPlus4_d),

    // Data outputs
    .rd1_e        (rd1_e),
    .rd2_e        (rd2_e),
    .pc_e         (PC_e),
    .imm_ext_e    (Imm_ext_e),
    .pc_plus_4_e  (PcPlus4_e), 
    // Address Inputs (Extracted directly from the Instruction)
    .rs1_d        (Instr_d[19:15]),
    .rs2_d        (Instr_d[24:20]),
    .rd_d         (Instr_d[11:7]),   
    // Address outputs
    .rs1_e        (rs1_e),
    .rs2_e        (rs2_e),
    .rd_e         (rd_e)
  );
  
  
  // EXECUTE STAGE 
logic        RegWrite_m;
logic[1:0]       ResultSrc_m;  // UPDATED: now 2 bits to support jalr
logic        MemWrite_m;
logic [31:0] alu_result_m;
logic [31:0] WriteData_m;
logic [31:0] PcPlus4_m;   // ADDED: carries PC+4 to MEM stage for jal/jalr link value
logic [4:0]  rd_m;
//internal Execute wires
logic [31:0] SrcA_e;
logic [31:0] SrcB_e;
logic [31:0] WriteData_e; 
  
logic [1:0] ForwardAE, ForwardBE;
  
  //instances 
mux3 mux3_inst1 ( //forwardA -SrcA_e
    // UPDATED: d1/d2 priority order swapped (WB forwarding now checked before MEM forwarding)
    .s  (ForwardAE),
    .d0 (rd1_e),
    .d1 (Result_w),
    .d2 (alu_result_m),
    .y  (SrcA_e)
);

mux3 mux3_inst2 ( //forwardB - WriteData_e
    // UPDATED: d1/d2 priority order swapped (WB forwarding now checked before MEM forwarding)
    .s  (ForwardBE),
    .d0 (rd2_e),
    .d1 (Result_w),
    .d2 (alu_result_m),
    .y  (WriteData_e)
);
  
  mux2  alu_src_mux( 
    .s  (ALUSrc_e),
    .d0 (WriteData_e),
    .d1 (Imm_ext_e),
    .y  (SrcB_e)
  ); 
  
  alu alu_inst( 
    .srca		(SrcA_e),
    .srcb     (SrcB_e),
    .alu_result (alu_result_e), 
    .alu_ctrl  (alu_ctrl_e), 
    .zero_flag  ()
  ); 
  
  branch_adder branch_adder_inst( 
    .pc  (PC_e), 
    .imm_ext  (Imm_ext_e), 
    .pc_target (PCTarget_e)
  ); 
  
 ex_mem_reg ex_mem_reg_inst (
    .clk          (clk),
    .reset        (reset),
    // Control inputs (From Execute Stage)
    .RegWrite_e   (RegWrite_e),
    .ResultSrc_e  (ResultSrc_e),
    .MemWrite_e   (MemWrite_e),
    // Control outputs (To Memory Stage)
    .RegWrite_m   (RegWrite_m),
    .ResultSrc_m  (ResultSrc_m),
    .MemWrite_m   (MemWrite_m),    
    // Data/Address inputs (From Execute Stage)
    .alu_result_e (alu_result_e), // This wire comes from ALU output
   .writeData_e  (WriteData_e),  // This wire comes from ForwardBE mux output
    .pc_plus_4_e  (PcPlus4_e),    // ADDED
    .rd_e         (rd_e),    
    // Data/Address outputs (To Memory Stage)
    .alu_result_m (alu_result_m),
   .writeData_m  (WriteData_m),
    .pc_plus_4_m  (PcPlus4_m),    // ADDED
    .rd_m         (rd_m)
  );
  
  //MEMORY stage 
 // logic RegWrite_w;
 // logic ResultSrc_w; 
  logic [31:0] alu_result_w;
  logic [31:0] readData_w;
  logic [31:0] PcPlus4_w;   // ADDED: carries PC+4 to WB stage for jal/jalr link value
 // logic [4:0]  rd_w;
//  logic [31:0] Result_w; 
  logic [31:0] readData_m;
  //instances 
  data_mem	data_mem_inst(
    .adr    (alu_result_m),
    .writeData (WriteData_m),
    .clk      (clk),
    .we       (MemWrite_m),
    .readData (readData_m)
  );
  
  mem_wb_reg  mem_wb_reg_inst(
    .clk          (clk),
    .reset        (reset),  
    // Control inputs (From Memory Stage)
    .RegWrite_m   (RegWrite_m),
    .ResultSrc_m  (ResultSrc_m),  
    // Control outputs (To Writeback Stage)
    .RegWrite_w   (RegWrite_w),
    .ResultSrc_w  (ResultSrc_w),    
    // Data/Address inputs (From Memory Stage & Data Memory)
    .alu_result_m (alu_result_m),
    .readData_m   (readData_m), // This wire comes from your Data Memory output
    .pc_plus_4_m  (PcPlus4_m),  // ADDED
    .rd_m         (rd_m),    
    // Data/Address outputs (To Writeback Stage)
    .alu_result_w (alu_result_w),
    .readData_w   (readData_w),
    .pc_plus_4_w  (PcPlus4_w),  // ADDED
    .rd_w         (rd_w)
  );
  
  //WRITEBACK stage 

  //instances 
  mux3 result_mux(
    .s (ResultSrc_w),
    .d0  (alu_result_w),
    .d1  (readData_w),
    .d2	 (PcPlus4_w),
    .y   (Result_w)
  ); 
  
  //HAZARD unit 
  
  hazard_unit  hazard_inst( 
    .rs1_e (rs1_e), 
    .rs2_e (rs2_e), 
    .rd_m       (rd_m),
    .RegWrite_m (RegWrite_m),
    .rd_w       (rd_w),
    .RegWrite_w (RegWrite_w),
    .ForwardAE  (ForwardAE),
    .ForwardBE  (ForwardBE), 
    .rs1_d      (Instr_d[19:15]), 
    .rs2_d		(Instr_d[24:20]), 
    .rd_e		(rd_e), 
    .ResultSrc_e (ResultSrc_e[0]), // UPDATED: pass LSB for load-use hazard check
    .PCSrc_e    (PCSrc_e[0] | PCSrc_e[1]), // UPDATED: flush if ANY branch/jump taken
    .StallF		(StallF), 
    .StallD		(StallD), 
    .FlushD		(FlushD), 
    .FlushE		(FlushE)
  ); 

  // UPDATED: PC source is now resolved via always_comb to support jalr
  // (previously: assign PCSrc_e = Branch_e & (SrcA_e == SrcB_e);)
  logic BranchTaken_e;   // ADDED
  assign BranchTaken_e = Branch_e & (SrcA_e == SrcB_e);   // ADDED

  // 00: PC+4 (sequential)
  // 01: PCTarget_e (branch taken or jal)
  // 10: alu_result_e (jalr only - assumes Control Unit sets ResultSrc=10 for JALR)
  always_comb begin   // ADDED
    if (ResultSrc_e == 2'b10 && Jump_e) // JALR condition
      PCSrc_e = 2'b10;
    else if (BranchTaken_e || Jump_e)   // Branch taken or standard JAL
      PCSrc_e = 2'b01;
    else
      PCSrc_e = 2'b00;
  end
  
endmodule