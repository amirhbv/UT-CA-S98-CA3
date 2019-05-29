`timescale 1ns/1ns

module Memory(
	input clk,
	input write_enable,
	input [4:0] address,
	input [7:0] write_data,
	output[7:0] read_data
);
	reg [7:0] mem[0:31] ;
	always @(negedge clk) begin
		if (write_enable)
			mem[address] <= write_data ;
	end
	assign read_data = mem[address] ;

	initial begin
		for (integer i = 0; i < 32; i = i + 1)
			mem[i] <= 8'd0 ;
		#200
		// mem[0] = 8'b10011001;
		// mem[1] = 8'b10011010;
		// mem[2] = 8'b10011011;
		// mem[3] = 8'b10011100;
		// mem[4] = 8'b10011101;
		// mem[5] = 8'b00000000;
		// mem[6] = 8'b00000000;
		// mem[7] = 8'b00000000;
		// mem[8] = 8'b00000000;
		// mem[9] = 8'b10111110;

		// mem[25] = 8'b00001001; //9
		// mem[26] = 8'b00000111; //7
		// mem[27] = 8'b00000101; //5
		// mem[28] = 8'b00000011; //3
		// mem[29] = 8'b00000001; //1

		mem[0] = 8'b10011101;  // push 8 in St
		mem[1] = 8'b10011101;  // push 8 in St
		mem[2] = 8'b00000000;  // add 8 + 8 and stoers 16 in St
		mem[3] = 8'b11000111;  // jump to instruction 7
		mem[7] = 8'b11101100;  // does not jumpz to 12
		mem[8] = 8'b10011110;  // push 16 on St
		mem[9] = 8'b00100000;  // sub 16 - 16 and store 0 on St
		mem[10] = 8'b11101111;  // jumpz 15
		mem[15] = 8'b10011100;  // push 10101010 on St
		mem[16] = 8'b10011011;  // push 01100110 on St
		mem[17] = 8'b01000000;  // and 10101010 & 01100110 and store 00100010 on St
		mem[18] = 8'b01100000;  // not 00100010 and store 11011101 on St
		mem[19] = 8'b10111111;  // pop 10111011 from st and store it on mem[31]
		mem[20] = 8'b10111110;  // pop 0 from st and store it on mem[30]

		mem[27] = 8'b01100110;
		mem[28] = 8'b10101010;
		mem[29] = 8'b00001000;
		mem[30] = 8'b00010000;
	end
endmodule
