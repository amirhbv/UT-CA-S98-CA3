`timescale 1ns/1ns

module ALU(
	input [7:0] data_i, data_j,
    input [1:0] aluOp,
    output reg [7:0] result
);
	always @(*) begin
		case(aluOp)
			2'b00 : result = data_i + data_j ;
			2'b01 : result = data_i - data_j ;
			2'b10 : result = data_i & data_j ;
			2'b11 : result = ~data_i ;
		endcase
	end
endmodule
