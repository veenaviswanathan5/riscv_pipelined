module control_unit
  ( input logic [6:0]opcode,
   input logic [2:0]funct3, 
   input logic funct7b5,
   output logic Branch,
   output logic [1:0] ResultSrc, 
   output logic MemWrite, 
   output logic ALUSrc, 
   output logic RegWrite,
   output logic [1:0]ImmSrc,
   output logic [3-1:0]alu_ctrl,
   output logic Jump
  );
  logic [1:0] alu_op_wire;
  
  //instantiating main control 
  // module_name   instance_name ( port_mapping );
  
  main_control	main_control_inst(
    .opcode		(opcode),
    .Branch		(Branch),
    .ResultSrc	(ResultSrc),
    .MemWrite	(MemWrite),
    .ALUSrc		(ALUSrc),
    .RegWrite	(RegWrite),
    .ImmSrc		(ImmSrc),
    .ALUOp		(alu_op_wire), //Soldering output pin to internal wire
    .Jump		 (Jump)
  ); 
  
  //instantiating alu decoder 
  alu_decoder 	alu_decoder_inst 
  (
  .ALUOp		(alu_op_wire),
  .func3		(funct3),
  .opb5			(funct7b5),
  .op5			(opcode[5]),
  .alu_ctrl 	(alu_ctrl)
  );
  
endmodule 