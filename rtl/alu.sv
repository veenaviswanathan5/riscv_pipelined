module alu #(parameter WIDTH =32)
        (  input logic [WIDTH-1 :0] srca,
           input logic [WIDTH-1 :0] srcb,
         input logic [2:0]alu_ctrl,
         output logic zero_flag,
         output logic [WIDTH-1 :0] alu_result
        );
  
  localparam ADD=3'b000;
  localparam SUB =3'b001;
  localparam XOR =3'b010;
  localparam OR =3'b011;
  localparam AND =3'b100;
  localparam SLT= 3'b101;
  // can add sll, srl, sra later 
  
 // assign zero_flag= 1'b0; mistake  
  
  
  always_comb 
    begin 
      case (alu_ctrl)
        ADD : alu_result = srca + srcb ;
        SUB : alu_result = srca  - srcb ;
         XOR : alu_result = srca  ^ srcb;
          AND: alu_result = srca & srcb;
          OR: alu_result = srca | srcb ;
        SLT : alu_result = $signed(srca) < $signed(srcb) ;
         
        default : alu_result = '0 ;    
      endcase 
    end
        
        
  assign zero_flag = (alu_result =='0);
        
   endmodule 