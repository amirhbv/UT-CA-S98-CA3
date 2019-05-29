`timescale 1ns/1ns

module Stack(
	input clk,
	input  [7:0] d_in,
	input  push, pop,
	output [7:0] d_out
);
	reg [7:0] mem [0:31];
	reg [4:0] addr = 0 ;
	assign d_out = mem[addr] ;
	always @(posedge push , posedge pop) begin
		if ( push ) begin
			addr = addr + 1 ;
			mem[addr] = d_in ;
		end else if ( pop & addr > 0 )
			addr = addr - 1 ;
	end

	initial begin
		for (integer i = 0 ; i < 32 ; i = i + 1)
			mem[i] <= 8'd0 ;
	end
endmodule
