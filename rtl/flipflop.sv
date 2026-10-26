module flipflop #(parameter WIDTH =32) 
  ( input logic  clk , 
    input logic  reset, 
   input logic  [WIDTH-1:0] d,
   output logic [WIDTH-1:0] q
  );
  
  always_ff @(posedge clk or posedge reset) 
    if(reset)
      begin
        q <= '0;
      end 
  else 
    q<=d; 
endmodule 