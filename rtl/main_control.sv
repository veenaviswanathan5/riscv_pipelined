module main_control #( parameter width= 32,
                        parameter opwidth=7) 
  (input logic [opwidth-1 :0] opcode,
   output logic Branch,
   output logic[1:0] ResultSrc, 
   output logic MemWrite, 
   output logic ALUSrc, 
   output logic RegWrite,
  output logic [1:0]ImmSrc, 
   output logic [1:0]ALUOp, 
  output logic Jump
  );
  
  //Opcode Definitions
typedef enum logic [6:0] {
  OP_LW   = 7'b0000011,
  OP_SW   = 7'b0100011,
  OP_R    = 7'b0110011,
  OP_BEQ  = 7'b1100011,
  OP_ADDI = 7'b0010011, 
  OP_JALR = 7'b1100111,
  OP_JAL  = 7'b1101111
} opcode_e;
  
  always_comb
    begin 
      case(opcode)
        
        OP_LW : //lw 
          begin 
            Branch    = 1'b0;  //  not branching
            ResultSrc = 2'b01;  // Take result from Data Memory, not the alu 
            MemWrite  = 1'b0;  // We are reading memory, not writing to it
            ALUSrc    = 1'b1;  // ALU needs the immediate value to calculate the address
            ImmSrc    = 2'b00; // I-type immediate format
            RegWrite  = 1'b1;  // need to write the loaded data back to a reg
            ALUOp     = 2'b00; //Tell the ALU to perform an ADD, base ad +off
            Jump	  = 1'b0; 
          end 
        
            
        OP_SW : //sw
          begin 
            Branch    = 1'b0;  
            ResultSrc = 2'b00;   
            MemWrite  = 1'b1; 
            ALUSrc    = 1'b1;  
            ImmSrc    = 2'b01;// s type instr  
            RegWrite  = 1'b0;  
            ALUOp     = 2'b00;
            Jump	  = 1'b0;
          end
        
        OP_R: //r type
          begin 
            Branch    = 1'b0;  
            ResultSrc = 2'b00;// take res from alu    
            MemWrite  = 1'b0; 
            ALUSrc    = 1'b0;// not calculating address   
            ImmSrc    = 2'b00;  
            RegWrite  = 1'b1; 
            ALUOp     = 2'b10; //check func3,4 
            Jump	  = 1'b0;
          end
        
        OP_BEQ: // beq 
           begin 
            Branch    = 1'b1;  
            ResultSrc = 2'b00; //doesnt matter, but keep 0 so u avaoid any X state in cpu     
            MemWrite  = 1'b0; 
            ALUSrc    = 1'b0;  // 2nd arg is a reg not imm value
            ImmSrc    = 2'b10; // b type instr
            RegWrite  = 1'b0;  
            ALUOp     = 2'b01; // alu shd sub here and check the Zero flag.
             Jump	  = 1'b0;
          end
        
        
        
        OP_ADDI: //addi
           begin 
            Branch    = 1'b0;  
            ResultSrc = 2'b00;   
            MemWrite  = 1'b0; 
            ALUSrc    = 1'b1;  
            ImmSrc    = 2'b00; 
            RegWrite  = 1'b1;  
            ALUOp     = 2'b10;
             Jump	  = 1'b0;
          end
        
        OP_JALR: 
          begin
            Branch    = 1'b0;  
            ResultSrc = 2'b10;   //pc+4	
            MemWrite  = 1'b0; 
            ALUSrc    = 1'b1;  
            ImmSrc    = 2'b00; 
            RegWrite  = 1'b1;  
            ALUOp     = 2'b00;
             Jump	  = 1'b1;//jump
          end
       
        OP_JAL:
          begin
            Branch    = 1'b0;  
            ResultSrc = 2'b10;   //pc+4	
            MemWrite  = 1'b0; 
            ALUSrc    = 1'b0;// calculates sum in branch adder not alu
            ImmSrc    = 2'b11; 
            RegWrite  = 1'b1;  
            ALUOp     = 2'b00;
            Jump	  = 1'b1;//jump
          end
          
        
        
        default: 
           begin 
            Branch    = 1'b0;  
            ResultSrc = 2'b00;   
            MemWrite  = 1'b0; 
            ALUSrc    = 1'b0;  
            ImmSrc    = 2'b00; 
            RegWrite  = 1'b0;  
            ALUOp     = 2'b00;
            Jump = 1'b0;
          end
      endcase 
    end 
endmodule 

      
        
        
   
   