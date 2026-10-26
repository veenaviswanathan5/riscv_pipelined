module clearable_ff #(parameter WIDTH =32)
  (input logic  clk , 
    input logic  reset, 
   input logic en, 
   input logic clear,
   input logic  [WIDTH-1:0] d,
   output logic [WIDTH-1:0] q
  );
  
  always_ff @(posedge clk or posedge reset) 
    if (reset || clear)
      begin
      q<= '0; 
      end
  
  else 
    if (en) 
    begin
    q<= d; 
    end 
 
  
endmodule 