`timescale 1ns/1ns

module controller(
	input clk,rst,
	input[2:0] inst,
	output reg ld_IR,
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
		output reg[1:0] ALUop
);
	parameter [2:0]
		ADD = 3'b000,
		SUB = 3'b001,
		AND = 3'b010,
		NOT = 3'b011,
		PUSH = 3'b100,
		POP = 3'b101,
		JUMP = 3'b110,
		JUMPZ = 3'b111;
	reg [2:0] cnt = 0, nextCnt = 0;
	reg [2:0] ps = 0, ns = 0;
	parameter [3:0]
		IF = 0,
		IF1 = 1,
		SADD = 2,
		SSUB = 3,
		SAND = 4,
		SNOT = 5,
		SPUSH = 6,
		SPOP = 7,
		SJUMP = 8,
		SJZ = 9,
		incPC = 10 ;

	always @(posedge clk) begin
		cnt <= nextCnt ;
		ps <= ns ;
	end

	always @(cnt,ps) begin
		ld_IR = 0 ; PCorIR = 0 ; push = 0 ;pop = 0 ;
		MEMorALU = 0 ;ldA = 0 ;ldB = 0 ;PCup = 0 ;PCwrite = 0 ;J = 0 ; JZ = 0 ;

		case(ps)
			IF : begin
				ld_IR = 1 ;
				nextCnt = 0 ;
				ns = IF1 ;
			end

			IF1 : begin
				nextCnt = 0 ;
				case (inst)
				ADD : ns = SADD ;
				SUB : ns = SSUB ;
				AND : ns = SAND ;
				NOT : ns = SNOT ;
				PUSH : ns = SPUSH ;
				POP : ns = SPOP ;
				JUMP : ns = SJUMP ;
				JUMPZ : ns = SJZ ;
				endcase

			end

			//ADD
			SADD : begin
				nextCnt = cnt + 1 ;
				case (cnt)
				3'b000 : ldA = 1 ;
				3'b001 : pop = 1 ;
				3'b010 : ldB = 1 ;
				3'b011 : begin pop = 1 ; ALUop = 2'b00 ; end
				3'b100 : begin push = 1 ; ns = incPC ; MEMorALU = 1 ; end
				endcase
			end

			//SUB
			SSUB : begin
				nextCnt = cnt + 1 ;
				case (cnt)
				3'b000 : ldA = 1 ;
				3'b001 : pop = 1 ;
				3'b010 : ldB = 1 ;
				3'b011 : begin pop = 1 ; ALUop = 2'b01 ; end
				3'b100 : begin push = 1 ; ns = incPC ; MEMorALU = 1 ; end
				endcase
			end

			//AND
			SAND : begin
				nextCnt = cnt + 1 ;
				case (cnt)
				3'b000 : ldA = 1 ;
				3'b001 : pop = 1 ;
				3'b010 : ldB = 1 ;
				3'b011 : begin pop = 1 ; ALUop = 2'b10 ; end
				3'b100 : begin push = 1 ; ns = incPC ; MEMorALU = 1 ; end
				endcase
			end

			//NOT
			SNOT : begin
				nextCnt = cnt + 1 ;
				case (cnt)
				3'b000 : ldA = 1 ;
				3'b001 : begin pop = 1 ; ALUop = 2'b11 ; end
				3'b100 : begin push = 1 ; ns = incPC ; MEMorALU = 1 ; end
				endcase
			end

			//PUSH
			SPUSH : begin
				nextCnt = cnt + 1 ;
				case (cnt)
				3'b000 : PCorIR = 1 ;
				3'b001 : begin push = 1 ; ns = incPC ; end
				endcase
			end

			//POP
			SPOP : begin
				nextCnt = cnt + 1 ;
				case (cnt)
				3'b000 : ldA = 1 ;
				3'b001 : begin pop = 1 ; write_enable = 1 ; ns = incPC ; end
				endcase
			end

			//JUMP
			SJUMP : begin
				nextCnt = cnt + 1 ;
				case (cnt)
				3'b000 : begin J = 1 ; PCwrite = 1 ; ns = IF ; end
				endcase
			end

			//JZ
			SJZ : begin
				nextCnt = cnt + 1 ;
				case (cnt)
				3'b000 : begin JZ = 1 ; PCwrite = 1 ; ns = IF ; end
				endcase
			end

			//incPC
			incPC : begin
				nextCnt = cnt + 1 ;
				case (cnt)
				3'b000 : PCup = 1 ;
				3'b001 : begin PCwrite = 1 ; ns = IF ; end
				endcase
			end
		endcase
	end
endmodule


