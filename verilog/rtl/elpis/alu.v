/*
*
* This file is part of the Elpis processor project.
*
* Copyright © 2020-present. All rights reserved.
* Authors: Aurora Tomas and Rodrigo Huerta.
*
* This file is licensed under both the BSD-3 license for individual/non-commercial
* use. Full text of both licenses can be found in LICENSE file.
*/

`default_nettype none

`ifdef TESTS
	`include "elpis/definitions.v"
`else
    `include "/project/openlane/user_proj_example/../../verilog/rtl/elpis/definitions.v"
`endif

module alu(
	input[31:0] x,
	input[31:0] y,
	input[3:0] op,
	output reg[31:0] w,
	output z,
	output reg[31:0] exception_code
);

	wire[32:0] w_add = x + y;
	wire[32:0] w_sub = x - y;
	wire[31:0] w_and = x & y;
	wire[31:0] w_or = x | y;
	wire[31:0] w_xor = x ^ y;
	wire[31:0] w_sll = x << y;
	wire[31:0] w_srl = x >> y;
	//wire[31:0] w_sra = $signed(x) >>> y;
	wire[31:0] w_sra = 32'b0;

	//wire[31:0] excp = (op == `ALU_OP_ADD) ? ((w_add[32] && (x[31] == y[31])) ? `EXC_OVERFLOW : 0) : ( (op == `ALU_OP_SUB) ? ( (w_sub[32]) ? `EXC_UNDERFLOW : 0) : 32'b0);
	
	assign z = (x==y) ? 1'b1 : 1'b0;
	wire is_add = op == `ALU_OP_ADD;
	wire is_sub = op == `ALU_OP_SUB;
	wire is_and = op == `ALU_OP_AND;
	wire is_or = op == `ALU_OP_OR;
	wire is_xor = op == `ALU_OP_XOR;
	wire is_branch = op == `ALU_OP_BRANCH;
	wire is_sll = op == `ALU_OP_SLL;
	wire is_slr = op == `ALU_OP_SRL;
	wire is_sra = op == `ALU_OP_SRA;
	(* parallel_case, full_case *)
	always@(*) begin
		case(1'b1)
			is_add: begin
				w = w_add[31:0];
			end
			is_sub: begin
				w = w_sub[31:0];
			end
			is_and: begin
				w = w_and;
			end
			is_or: begin
				w = w_or;
			end
			is_xor: begin
				w = w_xor;
			end
			is_branch: begin
				w = w_add[31:0];
			end
			is_sll: begin
				w = w_sll;
			end
			is_slr: begin
				w = w_srl;
			end
			is_sra: begin
				w = w_sra;
			end
			default: begin
				w = 32'b0;
			end
		endcase
	end
	// always@(*) begin
	// 	case(op)
	// 		`ALU_OP_ADD: begin
	// 		   {carry, w} = x + y;
	// 		   exception_code = (carry && (x[31] == y[31])) ? `EXC_OVERFLOW : 0;
	// 		 end
	// 		`ALU_OP_SUB: begin
	// 			 {carry, w} = x - y;
	// 			 exception_code = (carry) ? `EXC_UNDERFLOW : 0;
	// 		 end
	// 		 `ALU_OP_AND: begin
	// 			 w = x & y;
	// 			 exception_code = 32'b0;
	// 			 carry = 0;
	// 		 end
	// 		 `ALU_OP_OR: begin
	// 			 w = x | y;
	// 			 exception_code = 32'b0;
	// 			 carry = 0;
	// 		 end
	// 		 `ALU_OP_XOR: begin
	// 			 w = x ^ y;
	// 			 exception_code = 32'b0;
	// 			 carry = 0;
	// 		 end
	// 		 `ALU_OP_BRANCH: begin
	// 			 w = x + y;
	// 			 exception_code = 32'b0;
	// 			 carry = 0;
	// 		 end
	// 		 `ALU_OP_SLL: begin
	// 			 w = x << y;
	// 			 exception_code = 32'b0;
	// 			 carry = 0;
	// 		 end
	// 		 `ALU_OP_SRL: begin
	// 			 w = x >> y;
	// 			 exception_code = 32'b0;
	// 			 carry = 0;
	// 		 end
	// 		 `ALU_OP_SRA: begin
	// 			 w = $signed(x) >>> y;
	// 			 exception_code = 32'b0;
	// 			 carry = 0;
	// 		 end
	// 		 default: begin
	// 			 w = 32'b0;
	// 			 exception_code = 32'b0;
	// 			 carry = 0;
	// 		 end
	// 	endcase

	// 	z = (x==y) ? 1'b1 : 1'b0;
		
	// end

endmodule
