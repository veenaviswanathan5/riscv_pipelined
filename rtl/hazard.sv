module hazard_unit
    ( input logic [4:0] rs1_e,       //source reg 1 in Execute
      input logic [4:0] rs2_e,       //source reg 2 in Execute

      input logic [4:0] rd_m,        //dest reg in Memory
      input logic RegWrite_m,

      input logic [4:0] rd_w,        //dest reg in Writeback
      input logic RegWrite_w,

      output logic [1:0] ForwardAE,
     output logic [1:0] ForwardBE,
      
      input logic [4:0] rs1_d,       //source regs in Decode (load-use check)
      input logic [4:0] rs2_d,

      input logic [4:0] rd_e,        //dest reg in Execute
      input logic ResultSrc_e,       //1 = load instruction in Execute
      input logic PCSrc_e,           //1 = branch taken in Execute
     
      output logic StallF,
      output logic StallD,
      output logic FlushD,
      output logic FlushE
      
    );
  
  logic lwStall; 
  
  always_comb 
    begin 
       //ForwardAE logic (rs1_e)
    if (RegWrite_m && (rd_m != 5'b0) && (rd_m == rs1_e))
      ForwardAE = 2'b01;
      
    else if (RegWrite_w && (rd_w != 5'b0) && (rd_w == rs1_e))
      ForwardAE = 2'b10;
      
    else
      ForwardAE = 2'b00;

    //ForwardBE logic (rs2_e)
    if (RegWrite_m && (rd_m != 5'b0) && (rd_m == rs2_e))
      ForwardBE = 2'b01;
      
    else if (RegWrite_w && (rd_w != 5'b0) && (rd_w == rs2_e))
      ForwardBE = 2'b10;
      
    else
      ForwardBE = 2'b00;
  end
  
   assign lwStall = ResultSrc_e && ((rd_e == rs1_d) || (rd_e == rs2_d));
  
  assign StallF = lwStall;
  assign StallD = lwStall;
  
    //Flushes
  assign FlushD = PCSrc_e;
  assign FlushE = lwStall | PCSrc_e;
  
  

endmodule

//lwStall is a continuous assign, not inside the always_comb block — that's intentional and fine, since it's a single boolean expression with no priority/branching needed. You could equally fold it into the always_comb block as a blocking assignment, but keeping it as a separate assign (as your spec's phrasing suggests) is cleaner and avoids mixing procedural and continuous styles unnecessarily.

//No x0 check on lwStall: unlike your forwarding logic, this spec doesn't ask you to exclude rd_e == 0. That's actually correct behavior here — even though writes to x0 are discardable, RISC-V doesn't optimize away the stall; the hazard detection is typically kept simple and register-write-agnostic for the load-use case. If your course later asks you to add a RegWrite_e check here too, that'd be an easy one-line addition to lwStall, but as specified, leave it out.
//Wiring reminder: StallF/StallD will need to gate the enable (not the clear) of your PC register and IF/ID register — this is a different control path than the clear used for flushing, so make sure your top-level datapath doesn't accidentally tie stall and flush into the same signal on those registers.