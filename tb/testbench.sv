module riscv_tb_core();
   logic clk;
   logic reset;


riscv_core uut( 
     .clk   (clk),
  .reset (reset), 
  .clear (1'b0)
  );
always begin 
      #5 clk = ~clk; //toggle clk every 5s 
  end

initial begin 
 clk =0; 
reset=1; 
#10 reset=0; 
end 

initial begin 
  #500; 
$display("timeout error occurred"); 
$finish;
end

always @(negedge clk)  begin 
 if(uut.MemWrite_m ==1) 
begin
  if(uut.alu_result_m == 32'd100) 
begin
  if(uut.WriteData_m==42) begin
    $display ("Successs, Memory jump passed!");  
$finish; 
end
	else begin
  $display ("fatal mismatch error, Expected 42, got %0d", uut.WriteData_m); 
$finish; 
 end 
  end 
    end
end
  


endmodule 

 
  