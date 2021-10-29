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

module branchComparer(input[2:0] branch_code_in, input[31:0] reg_a_content_in, input[31:0] reg_b_content_in, output reg is_branch_taken_out);

	always@(*)begin
		case(branch_code_in)
			`FUNCT3_BRANCH_BEQ : is_branch_taken_out = (reg_a_content_in == reg_b_content_in);
			`FUNCT3_BRANCH_BNE : is_branch_taken_out = (reg_a_content_in != reg_b_content_in);
			`FUNCT3_BRANCH_BLT : is_branch_taken_out = (reg_a_content_in < reg_b_content_in);
			`FUNCT3_BRANCH_BGE : is_branch_taken_out = (reg_a_content_in >= reg_b_content_in);
			default : is_branch_taken_out = 0;
		endcase
	end

endmodule 
