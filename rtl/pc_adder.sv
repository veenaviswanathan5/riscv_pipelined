module pc_adder #(parameter WIDTH =32)
  (input logic [WIDTH-1:0] pc,
   output logic [WIDTH-1:0] pc_next
  );
  
  
   assign pc_next = pc+4; 
  
  
endmodule