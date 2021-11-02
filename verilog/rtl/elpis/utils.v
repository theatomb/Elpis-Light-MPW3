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

module mux3_1 #(parameter NBITS=32)(input[1:0] sel_in, input[NBITS-1:0] input1, input[NBITS-1:0] input2, input[NBITS-1:0] input3, output reg[NBITS-1:0] result);
	
	always@(*) begin
		case (sel_in)
			2'b00: result <= input1;
			2'b01: result <= input2;
			2'b10: result <= input3;
			default: result <= 32'b0;
		endcase
	end
	
endmodule


module TLBAddressAdder #(parameter CORE_ID=0)(input[31:0] address_in,input[31:0] exception_code_in, output reg[31:0] address_out);

	always@(*) begin
		if(exception_code_in==`EXC_DTLB_MISS) begin
			address_out <= address_in + `DTLB_BASE_ADDRESS_SHIFT_CORE0;
		end else begin
			address_out <= address_in + `ITLB_BASE_ADDRESS_SHIFT_CORE0;
		end
	end

endmodule
