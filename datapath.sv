`timescale 1ns/1ns

module Datapath(
	input clk, rst,
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
	output[2:0] inst
);

	reg [4:0] PC, address;
	reg [7:0] A, B, IR, MDR, ALUres;
	wire[7:0] wireA, wireB, wireReadMem, ALUout, ALUorMEM, StackOut;
	wire[4:0] PC_in;
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
	assign inst 	= IR[7:5];

	always @(negedge clk, posedge rst) begin
		if (rst) begin
			PC <= 5'b0;
			A <= 8'b0;
			B <= 8'b0;
		end
		ALUres <= ALUout ;
		MDR <= wireReadMem ;
		if (ldA) A <= StackOut ;
		if (ldB) B <= StackOut ;
		if (PCwrite) PC <= PC_in ;
		if (ld_IR) IR <= wireReadMem ;
	end
endmodule
