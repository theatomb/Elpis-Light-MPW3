// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

    /*--------------------------------------*/
    /* User project is instantiated  here   */
    /*--------------------------------------*/

    wire print_hex_enable, req_out_core0, read_interactive_req_core0, is_ready_dataout_core0, is_ready_print_core0;
	wire[31:0] core0_data_print;	
	wire[31:0] print_output;
	wire[31:0] data_out_to_core;

	wire core0_need_reset_mem_req, need_reset_mem_req, is_mem_ready, core0_is_mem_we;
	wire[19:0] core0_to_mem_address;
	wire[127:0] read_data_from_mem, core0_to_mem_data;
	wire is_mem_req;

	wire we_to_sram, csb0_to_sram, spare_wen0_to_sram;
	wire[19:0] addr0_to_sram;
	wire[31:0] din0_to_sram, dout0_to_sram;

    wire clk, rst, reset_core,is_loading_memory_into_core;
    wire[31:0] data_to_core_mem;
    wire[19:0] addr_to_core_mem;

    //SUSPICIOUS
    wire read_enable_to_Elpis;
    wire[31:0] read_value_to_Elpis;


    chip_controller chip_controller(
`ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
`endif
        // .output_data_from_elpis_to_controller(print_output), //
        // .output_enabled_from_elpis_to_controller(print_hex_enable), //
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .la_data_in(la_data_in),
        .la_oenb(la_oenb),
        .la_data_out(la_data_out),
        .clk(clk),
        .rst(rst),
        .reset_core(reset_core),
        .is_loading_memory_into_core(is_loading_memory_into_core),
        .read_enable_to_Elpis(read_enable_to_Elpis), //
        .data_to_core_mem(data_to_core_mem),
        .read_value_to_Elpis(read_value_to_Elpis), //
        .addr_to_core_mem(addr_to_core_mem),
        .wbs_dat_o(wbs_dat_o),
        // O_arbiter
        .is_ready_print_core0(is_ready_print_core0),
        .req_out_core0(req_out_core0),
        .core0_data_print(core0_data_print),
        // I_arbiter
        .data_out_to_core(data_out_to_core),
        .is_ready_dataout_core0(is_ready_dataout_core0),
        .read_interactive_req_core0(read_interactive_req_core0),
        // SRAM Wrapper
        .we(core0_is_mem_we),
		.addr_in(core0_to_mem_address),
		.wr_data(core0_to_mem_data),
		.requested(is_mem_req),
		.reset_mem_req(core0_need_reset_mem_req),
		.rd_data_out(read_data_from_mem),
		.ready(is_mem_ready),
	 	.we_to_sram(we_to_sram),
    	.csb0_to_sram(csb0_to_sram),
    	.spare_wen0_to_sram(spare_wen0_to_sram),
    	.addr0_to_sram(addr0_to_sram),
    	.din0_to_sram(din0_to_sram), 
    	.dout0_to_sram(dout0_to_sram)
    );

	custom_sram custom_sram(
`ifdef USE_POWER_PINS
	    .vccd1(vccd1),	// User area 1 1.8V power
	    .vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk(clk),
		.q(dout0_to_sram),
		.a(addr0_to_sram),
		.d(din0_to_sram),
		.we(we_to_sram),
		.csb0_to_sram(csb0_to_sram),
		.spare_wen0_to_sram(spare_wen0_to_sram)
	);

	core #(.CORE_ID(0)) core0(
`ifdef USE_POWER_PINS
	    .vccd1(vccd1),	// User area 1 1.8V power
	    .vssd1(vssd1),	// User area 1 digital ground
`endif
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


endmodule	// user_project_wrapper

`default_nettype wire
