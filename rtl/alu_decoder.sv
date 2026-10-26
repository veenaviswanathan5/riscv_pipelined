module alu_decoder
  (input logic [1:0]ALUOp,
   input logic [2:0]func3,
   input logic opb5, 
   input logic op5,
   output logic [2:0]alu_ctrl); 
  
  always_comb
    begin 
      
      case(ALUOp)
        
        2'b00: alu_ctrl = 3'b000; // Load/Store: Force ADD
      
        2'b01: alu_ctrl = 3'b001; // Branch: Force SUB
        
        2'b10: 
          begin              // R-type or I-type Math
          case (func3)
          3'b000: begin
            // Check for the specific R-type Subtraction exception
            if (op5 == 1'b1 && opb5 == 1'b1) 
              alu_ctrl = 3'b001; // SUB
            else 
              alu_ctrl = 3'b000; // ADD
          end
          3'b010: alu_ctrl = 3'b101; // SLT       
          3'b110: alu_ctrl = 3'b011; // OR         
          3'b111: alu_ctrl = 3'b100; // AND        
          default: alu_ctrl = 3'b000; // Default math
        endcase
      end
        
        default: alu_ctrl = 3'b000; 
      endcase 
    end 
endmodule 

  
  
