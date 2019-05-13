`timescale 1ns/1ns

module processor(input clk, rst);
  wire ld_IR, PCorIR, push, pop, MEMorALU, ldA, ldB, PCup, PCwrite, J, JZ, write_enable ;
  wire [1:0] ALUop ;
  wire [2:0] inst ;

  controller ct( clk, rst, inst, ld_IR, PCorIR, push, pop, MEMorALU, ldA, ldB, PCup, PCwrite, J, JZ, write_enable, ALUop);
  datapath dp( clk, ld_IR, PCorIR, push, pop, MEMorALU, ldA, ldB, PCup, PCwrite, J, JZ, write_enable, ALUop, inst);
endmodule
