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

module core
#(parameter CORE_ID = 0)
(
	input clk,
	input rst,
	input[31:0] read_interactive_value,
	input read_interactive_ready,
	output[31:0] hex_out,
	output read_interactive_req,
	output hex_req,
	input is_print_done,
	// LLC ports
	output is_memory_we,
	output[19:0] mem_addr_out,
	output[127:0] mem_data_out,
	output is_mem_req_reset,
	input[127:0] data_from_mem,
	input is_mem_ready,
	output is_mem_req
);

	wire[31:0] search_addr_if, search_addr_mem;
	wire[127:0] read_data_mem, dcache_mem_data_in;
	wire[31:0] write_data;

	wire wrd_mem, is_hit_icache, is_hit_dcache;
	wire[19:0] icache_mem_addr, dcache_mem_addr;
	wire[127:0] icache_mem_data, dcache_mem_data, read_data_if;
	wire[31:0] dcache_read_data, read_instr;
	wire re_dcache, is_byte_acc, mem_we_dcache, mem_we_icache;
	wire icache_req_mem, dcache_req_mem, is_icache_ready, is_dcache_ready;
	wire need_reset_mem_req;
	wire privilege_mode, is_tlbwrite;
	wire[31:0] type_exception;
	wire[31:0] current_address_rm2_wire;
	wire[19:0] physical_addr_write;
	
	wire is_itlb_we = (is_tlbwrite && (type_exception == `EXC_ITLB_MISS)) ? 1'b1: 1'b0;
	wire is_itlb_re = (!is_itlb_we);
	wire is_dtlb_we = (is_tlbwrite && (type_exception == `EXC_DTLB_MISS)) ? 1'b1: 1'b0;
	wire is_dtlb_re = (!is_dtlb_we && (re_dcache || wrd_mem));
	wire hit_itlb, exc_protected_page_itlb, hit_dtlb, exc_protected_page_dtlb;
	
	// arbiter	
	arbiter arbiter(
		.clk(clk),
		.reset(rst),
		.mem_addr(mem_addr_out), 
		.dcache_to_mem_data_in(dcache_mem_data_in),
		.dcache_to_mem_data_out(mem_data_out),
		.mem_to_icache_data(read_data_if),
		.mem_to_dcache_data(read_data_mem),
		.data_from_mem(data_from_mem),
		.dcache_we(mem_we_dcache), 
		.mem_we(is_memory_we), 
		.icache_request(icache_req_mem),
		.dcache_request(dcache_req_mem),
		.mem_ready(is_mem_ready), 
		.is_icache_ready(is_icache_ready),
		.is_dcache_ready(is_dcache_ready),
		.reset_mem_req(need_reset_mem_req),
		.hit_itlb_in(hit_itlb),
		.hit_dtlb_in(hit_dtlb),
		.itlb_physical_addr_in(icache_mem_addr),
		.dtlb_physical_addr_in(dcache_mem_addr),
		.dcache_re(re_dcache),
		.is_mem_req(is_mem_req)
	);

	assign is_mem_req_reset = need_reset_mem_req;
	
	// instruction cache
	cache #(.CORE_ID(CORE_ID), .CACHE_TYPE(`CACHE_TYPE_ICACHE)) icache(
	   .clk(clk),
	   .reset(rst),
	   .address_in(search_addr_if),
	   .data_in('b0),
	   .write_enable_in(1'b0),
	   .read_enable_in(1'b1),
	   .reset_mem_req(need_reset_mem_req),
	   .mem_ready_in(is_icache_ready),
	   .mem_data_in(read_data_if),
	   .is_byte(1'b0),
	   .privilege_mode(privilege_mode),
	   .tlb_we(is_itlb_we),
	   .tlb_re(is_itlb_re),
	   .physical_addr_in(write_data[19:0]),
	   .read_data_out(read_instr),
	   .hit_out(is_hit_icache),
	   .mem_addr_out(icache_mem_addr),
	   .mem_data_out(icache_mem_data),
	   .req_mem(icache_req_mem),
	   .hit_tlb(hit_itlb),
	   .exc_protected_page_tlb(exc_protected_page_itlb),
	   .virtual_addr_write_tlb_in(current_address_rm2_wire),
	   .physical_addr_write_tlb_in(physical_addr_write),
	   .mem_we_out(mem_we_icache)
	);

	// data cache
	cache #(.CORE_ID(CORE_ID), .CACHE_TYPE(`CACHE_TYPE_DCACHE)) dcache(
	   .clk(clk),
	   .reset(rst),
	   .address_in(search_addr_mem),
	   .data_in(write_data),
	   .write_enable_in(wrd_mem),
	   .read_enable_in(re_dcache),
	   .reset_mem_req(need_reset_mem_req),
	   .mem_ready_in(is_dcache_ready),
	   .mem_data_in(read_data_mem),
	   .is_byte(is_byte_acc),
	   .privilege_mode(privilege_mode),
	   .tlb_we(is_dtlb_we),
	   .tlb_re(is_dtlb_re),
	   .physical_addr_in(write_data[19:0]),
	   .read_data_out(dcache_read_data),
	   .hit_out(is_hit_dcache),
	   .mem_addr_out(dcache_mem_addr),
	   .mem_data_out(dcache_mem_data_in),
	   .req_mem(dcache_req_mem),
	   .hit_tlb(hit_dtlb),
	   .exc_protected_page_tlb(exc_protected_page_dtlb),
	   .virtual_addr_write_tlb_in(current_address_rm2_wire),
	   .physical_addr_write_tlb_in(physical_addr_write),
   	   .mem_we_out(mem_we_dcache)
	);
	
	// datapath module	
	datapath #(.CORE_ID(CORE_ID)) datapath(
		.clk(clk),
		.reset(rst),
		.mem_data_rd_f(read_instr),
		.mem_data_rd_m(dcache_read_data),
		.mem_addr_f(search_addr_if),
		.mem_addr_m(search_addr_mem),
		.mem_data_wr(write_data),
		.mem_wrd(wrd_mem),
	  	.hit_icache(is_hit_icache),
		.hit_dcache(is_hit_dcache),
		.hit_itlb(hit_itlb),
		.hit_dtlb(hit_dtlb),
		.read_interactive_value(read_interactive_value),
		.is_read_interactive_enabled(read_interactive_ready),
		.dcache_re(re_dcache),
		.mem_isbyte(is_byte_acc),
		.reset_mem_req(need_reset_mem_req),
		.privilege_mode(privilege_mode),
		.is_tlbwrite(is_tlbwrite),
		.exception_type(type_exception),
		.current_address_rm2(current_address_rm2_wire),
		.mem_physical_tlb_addr_out(physical_addr_write),
		.print_output(hex_out),
		.print_hex_enable(hex_req),
		.read_interactive_req(read_interactive_req),
		.is_print_done(is_print_done)
	);

	initial begin
		$display("Hello from Elpis!");
	end

endmodule
