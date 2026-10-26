module instr_mem #( parameter WIDTH =32, 
                  parameter DEPTH = 64)
  ( input logic [WIDTH-1 :0] pc,
   output logic [WIDTH-1 :0] instr
  );
  
  logic [WIDTH-1:0] ram [0:DEPTH-1];
   
initial begin

    ram[0] = 32'h00000113; // addi x2, x0, 0    (Initialize data to 0)
    ram[1] = 32'h06400193; // addi x3, x0, 100  (Initialize address to 100)
    ram[2] = 32'h00c000ef; // jal  x1, 12       (Jump to ram[5], x1 gets PC+4)
    ram[3] = 32'h0021a023; // sw   x2, 0(x3)    (The target: write x2 to Mem[100])
    ram[4] = 32'h00000063; // beq  x0, x0, 0    (Infinite loop trap)
    ram[5] = 32'h02a00113; // addi x2, x0, 42   (Payload: change data to 42)
    ram[6] = 32'h00008067; // jalr x0, 0(x1)    (Jump back to ram[3])

end
  
  assign instr = ram[pc[7:2]];
  
endmodule 