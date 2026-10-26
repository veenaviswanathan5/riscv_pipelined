module data_mem #( parameter WIDTH =32, 
                  parameter DEPTH = 64)
  ( input logic [WIDTH-1 :0] adr,
   input logic [WIDTH-1 :0]writeData,
   input logic clk,
    input logic we,
   output logic [WIDTH-1 :0] readData
  );
  
  logic [WIDTH-1:0] ram[0:DEPTH-1];
  
  initial 
    begin 
    ram[0] = 32'h12345678;
    ram[1] = 32'h98765432;
    end 

    always_ff @(posedge clk)
      begin
      if(we)
        begin
     ram[adr[31:2]] <= writeData; //write to mem
        end //if ends
      end // always block ends

    assign readData = ram[adr[31:2]]; //read from mem

  
endmodule
  