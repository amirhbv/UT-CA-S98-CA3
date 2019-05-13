module datapath( input clk,
                 input ld_IR,
                       PCorIR,
                       push,
                       pop,
                       MEMorALU,
                       ldA,
                       ldB,
                       PCup,
                       PCwrite,
                       J,
                       JZ,
                       write_enable,
                 input [1:0] ALUop,
                 output[2:0] inst) ;
                  
                  reg [4:0] PC ;
                  reg [7:0] A, B, IR, MDR, ALUres ;
                  wire[7:0] wireA, wireB, wireReadMem, ALUout, ALUorMEM, StackOut;
                  wire[4:0] addr, PCin ;
                  wire ZERO ;
                  
                  
                  Memory memory( clk, write_enable, address, A, wireReadMem) ;
                  ALU alu( wireA, wireB, ALUop, ALUout) ;
                  Stack stack( clk, ALUorMEM, push, pop, StackOut);
                  
                  assign ALUorMEM = MEMorALU ? ALUres : MDR ;
                  assign wireA    = PCup     ? PC  : A ;
                  assign wireB    = PCup     ? 1   : B ;
                  assign ZERO     = (A == 0) ;
                  assign PC_in    = ((JZ & ZERO) | J) ? IR[4:0] : ALUres ;
                  assign address  = PCorIR ? IR[4:0] : PC ;
                 
                  always @(negedge clk) begin
                    ALUres <= ALUout ;
                    MDR <= wireReadMem ;
                    if (ldA) A <= StackOut ;
                    if (ldB) B <= StackOut ;
                    if (PCwrite) PC <= PCin ;
                    if (ld_IR) IR <= wireReadMem ;
                  end
                  
endmodule                 