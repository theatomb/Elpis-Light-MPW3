module chip_controller(
`ifdef USE_POWER_PINS
	inout vccd1,	// User area 1 1.8V supply
	inout vssd1,	// User area 1 digital ground
`endif
    //input[31:0] output_data_from_elpis_to_controller,
    // input output_enabled_from_elpis_to_controller,
    input wb_clk_i,
    input wb_rst_i,
    input[127:0] la_data_in,
    input[127:0] la_oenb,
    output[127:0] la_data_out,
    output clk,
    output rst,
    output reset_core,
    output is_loading_memory_into_core,
    output read_enable_to_Elpis,
    output[31:0] data_to_core_mem,
    output[31:0] read_value_to_Elpis,
    output[19:0] addr_to_core_mem,
    output[31:0] wbs_dat_o,
    //O_arbiter
    output is_ready_print_core0,
    input req_out_core0,
    input[31:0] core0_data_print,
    // I_arbiter
    output[31:0] data_out_to_core,
    output is_ready_dataout_core0,
    input read_interactive_req_core0,
    // Sram wrapper
	input we,
	input[19:0] addr_in,
	input[127:0] wr_data,
	input requested,
	input reset_mem_req,
	output[127:0] rd_data_out,
	output ready,
	// SRAM Wrapper ports
	output we_to_sram, 
    output csb0_to_sram,
    output spare_wen0_to_sram,
    output[19:0] addr0_to_sram,
    output[31:0] din0_to_sram, 
    input[31:0] dout0_to_sram
);

    // O_arbiter wires
    wire[31:0] print_output;
    wire print_hex_enable;

    assign clk = (~la_oenb[96]) ? la_data_in[96]: wb_clk_i;
    assign rst = (~la_oenb[97]) ? la_data_in[97]: wb_rst_i;

    // Input data wires from PicoRiscV to Elpis
    assign addr_to_core_mem = la_data_in[19:0];
    assign data_to_core_mem = la_data_in[63:32];
    assign read_value_to_Elpis = la_data_in[95:64];

    // Permissions from PicoRiscV to Elpis
    assign reset_core = la_data_in[97];
    assign is_loading_memory_into_core = la_data_in[98];
    assign read_enable_to_Elpis = la_data_in[99];
    // assign wbs_dat_o = output_data_from_elpis_to_controller;
    assign wbs_dat_o = print_output;

    // Permissions from Elpis to PicoRiscV
    // assign la_data_out[100] = output_enabled_from_elpis_to_controller;
    assign la_data_out[100] = print_hex_enable;

    	sram_wrapper sram_wrapper(
// `ifdef USE_POWER_PINS
// 	    .vccd1(vccd1),	// User area 1 1.8V power
// 	    .vssd1(vssd1),	// User area 1 digital ground
// `endif
		.clk(clk),
		.reset(rst),
		.we(we),
		.addr_in(addr_in),
		.wr_data(wr_data),
		.requested(requested),
		.reset_mem_req(reset_mem_req),
    	.is_loading_memory_into_core(is_loading_memory_into_core),
		.addr_to_core_mem(addr_to_core_mem),
		.data_to_core_mem(data_to_core_mem),
		.rd_data_out(rd_data_out),
		.ready(ready),
	 	.we_to_sram(we_to_sram),
    	.csb0_to_sram(csb0_to_sram),
    	.spare_wen0_to_sram(spare_wen0_to_sram),
    	.addr0_to_sram(addr0_to_sram),
    	.din0_to_sram(din0_to_sram), 
    	.dout0_to_sram(dout0_to_sram)
	);


    	io_input_arbiter io_input_arbiter(
// `ifdef USE_POWER_PINS
// 	    .vccd1(vccd1),	// User area 1 1.8V power
// 	    .vssd1(vssd1),	// User area 1 digital ground
// `endif
		.clk(clk),
		.reset(rst),
		.req_core0(read_interactive_req_core0),
		.read_value(read_value_to_Elpis),
		.read_enable(read_enable_to_Elpis),
		.is_ready_core0(is_ready_dataout_core0),
		.data_out(data_out_to_core)
	);

	io_output_arbiter io_output_arbiter(
// `ifdef USE_POWER_PINS
// 	    .vccd1(vccd1),	// User area 1 1.8V power
// 	    .vssd1(vssd1),	// User area 1 digital ground
// `endif
		.clk(clk),
		.reset(rst),
		.req_core0(req_out_core0),
		.data_core0(core0_data_print),
		.print_hex_enable(print_hex_enable),
		.print_output(print_output),
		.is_ready_core0(is_ready_print_core0)
	);

endmodule