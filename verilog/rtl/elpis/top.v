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

module top
#(parameter MEMORY_FILE = 0)
(
	input clk,
	input reset_chip,
	input reset_core,
	input is_loading_memory_into_core,
	input[19:0] addr_to_core_mem,
	input[31:0] data_to_core_mem,
	input[31:0] read_value_to_Elpis,
	input read_enable_to_Elpis,
	output output_enabled_from_elpis_to_pico,
	output[31:0] output_data_from_elpis_to_pico
);

	wire print_hex_enable, req_out_core0, read_interactive_req_core0, is_ready_dataout_core0, is_ready_print_core0;
	wire[31:0] core0_data_print;	
	wire[31:0] print_output;
	wire[31:0] data_out_to_core;

	wire core0_need_reset_mem_req, need_reset_mem_req, is_mem_ready, core0_is_mem_we;
	wire[19:0] core0_to_mem_address;
	wire[127:0] read_data_from_mem, core0_to_mem_data;
	wire is_mem_req;

	// memory module
	memory #(.MEMORY_FILE(MEMORY_FILE)) memory(
		.clk(clk),
		.reset(reset_chip),
		.we(core0_is_mem_we),
		.addr_in(core0_to_mem_address),
		.wr_data(core0_to_mem_data), 
		.requested(is_mem_req),
		.reset_mem_req(core0_need_reset_mem_req),
		.rd_data_out(read_data_from_mem),
		.ready(is_mem_ready),
		.is_loading_memory_into_core(is_loading_memory_into_core),
		.addr_to_core_mem(addr_to_core_mem),
		.data_to_core_mem(data_to_core_mem)
	);

	// reg[19:0] dummyAddr;
	// always@(posedge clk) begin
	// 	if(reset_chip) begin
	// 		output_enabled_from_elpis_to_pico <= 1'b0;
	// 		output_data_from_elpis_to_pico <= 32'b0;
	// 		core0_to_mem_address <= 20'b0;
	// 		dummyAddr <= 20'b0;
	// 	end else begin
	// 		output_enabled_from_elpis_to_pico <= is_mem_ready;
	// 		output_data_from_elpis_to_pico <= read_data_from_mem[31:0];
	// 		core0_to_mem_address <= dummyAddr;
	// 		dummyAddr <= dummyAddr + 1'b1;
	// 	end
	// end

	core #(.CORE_ID(0)) core0(
		.clk(clk),
		.rst(reset_core),
		.read_interactive_value(data_out_to_core),
		.read_interactive_ready(is_ready_dataout_core0),
		.hex_out(core0_data_print),
		.read_interactive_req(read_interactive_req_core0),
		.hex_req(req_out_core0),
		.is_print_done(is_ready_print_core0),
		.is_memory_we(core0_is_mem_we),
		.mem_addr_out(core0_to_mem_address),
		.mem_data_out(core0_to_mem_data),
		.is_mem_req_reset(core0_need_reset_mem_req),
		.data_from_mem(read_data_from_mem),
		.is_mem_ready(is_mem_ready),
		.is_mem_req(is_mem_req)
	);

	//COre without arbiters
	// assign read_data_from_mem = data_to_core_mem;
	// assign is_mem_ready = is_loading_memory_into_core;
	// assign output_enabled_from_elpis_to_pico = is_ready_print_core0;
	// assign output_data_from_elpis_to_pico = core0_data_print;
	// assign data_out_to_core = read_value_to_Elpis;
	// assign read_enable_to_Elpis = is_ready_dataout_core0;

	assign output_data_from_elpis_to_pico = print_output;
	assign output_enabled_from_elpis_to_pico = print_hex_enable;

	io_input_arbiter io_input_arbiter(
		.clk(clk),
		.reset(reset_chip),
		.req_core0(read_interactive_req_core0),
		.read_value(read_value_to_Elpis),
		.read_enable(read_enable_to_Elpis),
		.is_ready_core0(is_ready_dataout_core0),
		.data_out(data_out_to_core)
	);

	io_output_arbiter io_output_arbiter(
		.clk(clk),
		.reset(reset_chip),
		.req_core0(req_out_core0),
		.data_core0(core0_data_print),
		.print_hex_enable(print_hex_enable),
		.print_output(print_output),
		.is_ready_core0(is_ready_print_core0)
	);

	//COre with arbiters
	// assign read_data_from_mem = data_to_core_mem;
	// assign is_mem_ready = is_loading_memory_into_core;

	// Mem with arbiters
	// reg[19:0] dummyAddr;
	// always@(posedge clk) begin
	// 	if(reset_chip) begin
	// 		req_out_core0 <= 1'b0;
	// 		core0_data_print <= 32'b0;
	// 		core0_to_mem_address <= 20'b0;
	// 		dummyAddr <= 20'b0;
	// 	end else begin
	// 		req_out_core0 <= is_mem_ready;
	// 		core0_data_print <= read_data_from_mem[31:0];
	// 		core0_to_mem_address <= dummyAddr;
	// 		dummyAddr <= dummyAddr + 1'b1;
	// 	end
	// end

	

endmodule
