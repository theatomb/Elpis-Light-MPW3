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

module hazardDetectionUnit(input[4:0] ex_reg_dest_addr_in, input ex_mem_read_in, input[4:0] id_reg_a_addr_in, input[4:0] id_reg_b_addr_in, output reg stall_out);

	always@(*) begin
		if (ex_mem_read_in & ((ex_reg_dest_addr_in == id_reg_a_addr_in) | (ex_reg_dest_addr_in == id_reg_b_addr_in))) // Load stalls
			stall_out <= 1'b1;
		else
			stall_out <= 1'b0;
	end

endmodule