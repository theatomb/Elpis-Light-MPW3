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

module custom_sram(
`ifdef USE_POWER_PINS
	inout vccd1,	// User area 1 1.8V supply
	inout vssd1,	// User area 1 digital ground
`endif
    input clk,
    output reg[31:0] q, 
    input[19:0] a, 
    input[31:0] d,
    input we,
    input csb0_to_sram,
    input spare_wen0_to_sram
);

    reg[31:0] mem[0:`MEMORY_SIZE-1];

    always @(posedge clk) begin
        if (!we)
            mem[a] <= d;
        q <= mem[a];
    end 

endmodule