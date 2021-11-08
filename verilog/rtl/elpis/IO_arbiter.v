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

module io_output_arbiter(
`ifdef USE_POWER_PINS
	inout vccd1,	// User area 1 1.8V supply
	inout vssd1,	// User area 1 digital ground
`endif
	input clk,
	input reset,
	input req_core0,
	input[31:0] data_core0,
	output reg print_hex_enable,
	output reg[31:0] print_output,
	output reg is_ready_core0
);

	reg[1:0] arb_state, next_arb_state;

	always@(posedge clk) begin
		if (reset) begin
			arb_state <= `ARB_IO_IDLE_STATE;
		end
		else arb_state <= next_arb_state;
	end
	
  	always@(req_core0 or arb_state) begin
		case(arb_state)
			`ARB_IO_IDLE_STATE: begin
				if (req_core0) next_arb_state <= `ARB_IO_CORE1_USE;
				else next_arb_state <= `ARB_IO_IDLE_STATE;
			end
			`ARB_IO_CORE1_USE: begin
				next_arb_state <= `ARB_IO_IDLE_STATE;
			end
			default: next_arb_state <= `ARB_IO_IDLE_STATE;
		endcase
	end

	always@(arb_state) begin
		case(arb_state)
			`ARB_IO_IDLE_STATE: begin
				print_hex_enable <= 1'b0;
				print_output <= 24'b0;
				if (reset) begin
					is_ready_core0 <= 1'b1;
				end else begin
					is_ready_core0 <= !req_core0;
				end
			end
			`ARB_IO_CORE1_USE: begin
				print_hex_enable <= 1'b1;
				print_output <= data_core0; 
				is_ready_core0 <= 1'b1;
			end
			default: begin
				print_hex_enable <= 1'b0;
				print_output <= 24'b0;
				is_ready_core0 <= 1'b1;	
			end
		endcase
	end

endmodule


module io_input_arbiter(
`ifdef USE_POWER_PINS
	inout vccd1,	// User area 1 1.8V supply
	inout vssd1,	// User area 1 digital ground
`endif
	input clk,
	input reset,
	input req_core0,
	input[31:0] read_value,
	input read_enable,
	output reg is_ready_core0,
	output reg[31:0] data_out
);

	reg[1:0] arb_state, next_arb_state;

	always@(posedge clk) begin
		if (reset) begin
			arb_state <= `ARB_IO_IDLE_STATE;
		end
		else arb_state <= next_arb_state;
	end
	
  	always@(req_core0 or arb_state or read_enable) begin
		case(arb_state)
			`ARB_IO_IDLE_STATE: begin
				if (req_core0) next_arb_state <= `ARB_IO_CORE1_USE;
				else next_arb_state <= `ARB_IO_IDLE_STATE;
			end
			`ARB_IO_CORE1_USE: begin
				if (read_enable) next_arb_state <= `ARB_IO_IDLE_STATE;
				else next_arb_state <= `ARB_IO_CORE1_USE;
			end
			default: next_arb_state <= `ARB_IO_IDLE_STATE;
		endcase
	end

	always@(arb_state or read_enable) begin
		case(arb_state)
			`ARB_IO_IDLE_STATE: begin
				is_ready_core0 <= 1'b0;		
				data_out <= 10'b0;
			end
			`ARB_IO_CORE1_USE: begin
				if (read_enable) begin
					is_ready_core0 <= 1'b1;
					data_out <= read_value;
				end else begin
					is_ready_core0 <= 1'b0;		
					data_out <= 10'b0;
				end
			end
			default: begin
				is_ready_core0 <= 1'b0;		
				data_out <= 10'b0;
			end
		endcase
	end

endmodule
