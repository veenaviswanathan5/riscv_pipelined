module branch_adder #(parameter WIDTH = 32)
  (input  logic [WIDTH-1:0] pc,
   input  logic [WIDTH-1:0]  imm_ext,
   output logic [WIDTH-1:0] pc_target
  );

  assign pc_target = pc + imm_ext ;
  //general mux for all 

endmodule

