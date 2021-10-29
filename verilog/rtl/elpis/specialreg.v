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

module specialreg(
	input clk,
	input reset,
	input[31:0] in_rm0,
	input[31:0] in_rm1,
	input[31:0] in_rm2,
	input[31:0] in_other_rm,
	input[2:0] sel,
	input we,
	output reg[31:0] out_rm0,
	output reg[31:0] out_rm1,
	output reg[31:0] out_rm2,
	output reg[31:0] out_rm,
	output reg[31:0] out_rm4
);

	reg[31:0] rm[4:0];
	integer i;
	
	/* rm0 : holds PC the OS should return to on exceptions
	   rm1 : holds an @ for certain exceptions
	   rm2 : holds info on the type of exception
	   rm3 : Privilege Status Word - Holds the current privilege of the machine. --> PSW/RM3 in datapath
	   rm4 : Holds the input/output information
	*/

	always@(negedge clk) begin
		if (reset) begin
			for (i=1; i < 5; i = i+1) begin
				rm[i] <= 0;
			end
			rm[0] <= `PC_INITIAL;
		end else if (in_rm2) begin
			rm[0] <= in_rm0;
			rm[1] <= in_rm1;
			rm[2] <= in_rm2;
		end else begin
			if (we) begin
				rm[4] <= in_other_rm;
			end
		end
	end

	always@(*) begin
		out_rm <= rm[sel];
		out_rm0 <= rm[0];
		out_rm1 <= rm[1];
		out_rm2 <= rm[2];
		out_rm4 <= rm[4];
	end

endmodule
