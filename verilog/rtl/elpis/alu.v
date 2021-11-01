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
	output reg z,
	output reg[31:0] exception_code
);

  	reg carry;
  
	always@(*) begin
		case(op)
			`ALU_OP_ADD: begin
			   {carry, w} = x + y;
			   exception_code = (carry && (x[31] == y[31])) ? `EXC_OVERFLOW : 0;
			 end
			`ALU_OP_SUB: begin
				 {carry, w} = x - y;
				 exception_code = (carry) ? `EXC_UNDERFLOW : 0;
			 end
			 `ALU_OP_AND: begin
				 w = x & y;
				 exception_code = 32'b0;
				 carry = 0;
			 end
			 `ALU_OP_OR: begin
				 w = x | y;
				 exception_code = 32'b0;
				 carry = 0;
			 end
			 `ALU_OP_XOR: begin
				 w = x ^ y;
				 exception_code = 32'b0;
				 carry = 0;
			 end
			 `ALU_OP_BRANCH: begin
				 w = x + y;
				 exception_code = 32'b0;
				 carry = 0;
			 end
			 `ALU_OP_SLL: begin
				 w = x << y;
				 exception_code = 32'b0;
				 carry = 0;
			 end
			 `ALU_OP_SRL: begin
				 w = x >> y;
				 exception_code = 32'b0;
				 carry = 0;
			 end
			 `ALU_OP_SRA: begin
				 w = $signed(x) >>> y;
				 exception_code = 32'b0;
				 carry = 0;
			 end
			 default: begin
				 w = 32'b0;
				 exception_code = 32'b0;
				 carry = 0;
			 end
		endcase

		z = (x==y) ? 1'b1 : 1'b0;
		
	end

endmodule
