module reg_file #(parameter width =32,
                 parameter reg_width =5)
  
        (input logic clk, 
         input logic [reg_width-1:0] a1,
         input logic [reg_width-1:0] a2,
         input logic [reg_width-1:0] a3,
         input logic [width-1:0] wd3,
         input logic  we3,
         output logic [width-1:0] rd1,
         output logic [width-1:0] rd2 
        );
  
  logic [width-1:0] Result [0:31]; // 32bit content of the registers 
  
  
  assign rd1= (a1 !=0) ? Result[a1] : 0;
  assign rd2= (a2 !=0) ? Result[a2] : 0;
   //RISC-V ISA, x0 is not storagelocation
  
  always_ff @(posedge clk)
    if(we3  && (a3!=0))
    Result[a3] <= wd3;
  
endmodule
  
  
  
  
  