`timescale 1ns/1ns

module Processor(input clk, rst);
  wire ld_IR, PCorIR, push, pop, MEMorALU, ldA, ldB, PCup, PCwrite, J, JZ, write_enable;
  wire [1:0] ALUop ;
  wire [2:0] inst ;

  Controller ct( clk, rst, inst, ld_IR, PCorIR, push, pop, MEMorALU, ldA, ldB, PCup, PCwrite, J, JZ, write_enable, ALUop);
  Datapath dp( clk, rst, ld_IR, PCorIR, push, pop, MEMorALU, ldA, ldB, PCup, PCwrite, J, JZ, write_enable, ALUop, inst);
endmodule
