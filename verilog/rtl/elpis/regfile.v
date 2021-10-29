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

module regfile(
	input clk,
	input reset,
	input wrd,				// write permission
	input[31:0] d,			// data
	input[4:0] addr_a,		// source register A
	input[4:0] addr_b,		// source register B
	input[4:0] addr_d,		// destination register
	output[31:0] a,		// read port A
	output[31:0] b,		// read port B	
	input[4:0] dest_read,
	output[31:0] dest_value
);

	reg[31:0] registers[31:0];
	integer i;

	always@(negedge clk) begin
		if (reset) begin
			for (i=0; i < 32; i = i+1) begin
				registers[i] <= 0;
			end
		end else if (wrd && (addr_d > 0)) begin
			registers[addr_d] <= d;
		end
	end

	assign a = registers[addr_a];
	assign b = registers[addr_b];
	assign dest_value = registers[dest_read];

endmodule

