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

module forwardingunit(
	input[4:0] ex_reg_a_in,
	input[4:0] ex_reg_b_in,
	input[4:0] mem_reg_d_in,
	input[4:0] wb_reg_d_in,
	input mem_reg_we_in,
	input wb_reg_we_in,
	output reg[1:0] forward_x,
	output reg[1:0] forward_y
);

	always@(*) begin
		if (wb_reg_we_in & (wb_reg_d_in != 0) & 
			!(mem_reg_we_in & (mem_reg_d_in != 0) & (mem_reg_d_in == ex_reg_a_in)) & 
			(wb_reg_d_in == ex_reg_a_in)) 
				forward_x <= 2'b01;
		else if (mem_reg_we_in & (mem_reg_d_in != 0) & (mem_reg_d_in == ex_reg_a_in)) 
			forward_x <= 2'b10;
		else 
			forward_x <= 2'b00;
		
		if (wb_reg_we_in & (wb_reg_d_in != 0) & 
			!(mem_reg_we_in & (mem_reg_d_in != 0) & (mem_reg_d_in == ex_reg_b_in)) & 
			(wb_reg_d_in == ex_reg_b_in) ) 
				forward_y <= 2'b01;
		else if (mem_reg_we_in & (mem_reg_d_in != 0) & (mem_reg_d_in == ex_reg_b_in)) 
			forward_y <= 2'b10;
		else 
			forward_y <= 2'b00;
	end
	
endmodule


module forwardingunit_st(
	input mem_we,
	input[4:0] ex_reg_b_in,
	input[4:0] mem_reg_b_in,
	input[1:0] forwarding_y,
	output reg[1:0] forwarding_regb
);
  
  	always@(*) begin
		if (mem_we && forwarding_y) 
			forwarding_regb <= 2'b01;
		else if (mem_we && (ex_reg_b_in == mem_reg_b_in)) 
			forwarding_regb <= 2'b10;
		else 
			forwarding_regb <= 2'b00;
	end

endmodule
  
  