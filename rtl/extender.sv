module extender #(parameter WIDTH =32)
  (input logic [WIDTH-1:0] instr,
   input logic [2-1:0] imm_sel,
   output logic [WIDTH-1:0] imm_ext
  );
  
  typedef enum logic[1:0]
  {
    imm_I =  2'b00,
    imm_S = 2'b01,
    imm_B = 2'b10,
    imm_J =2'b11
  } imm_src_e;
  
 
  // {} concatenation
  always_comb
    begin
      case(imm_sel)
        imm_I : imm_ext= { {20{instr[31]}}, instr[31:20] } ;  
       imm_S  : imm_ext= { {20{instr[31]}}, instr[31:25], instr[11:7] };
       imm_B: imm_ext= { {20{instr[31]}}, instr[7], 
                            instr[30:25], instr[11:8], 1'b0  };
        
        imm_J: imm_ext = { {12{instr[31]}}, instr[19:12], instr[20],
                          instr[30:21], 1'b0 };
        
        default: imm_ext = '0;
      endcase 
    end 
endmodule 
