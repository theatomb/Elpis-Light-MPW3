module chip_controller(
`ifdef USE_POWER_PINS
	inout vccd1,	// User area 1 1.8V supply
	inout vssd1,	// User area 1 digital ground
`endif
    input[31:0] output_data_from_elpis_to_controller,
    input output_enabled_from_elpis_to_controller,
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
    output[31:0] wbs_dat_o
);

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
    assign wbs_dat_o = output_data_from_elpis_to_controller;

    // Permissions from Elpis to PicoRiscV
    assign la_data_out[100] = output_enabled_from_elpis_to_controller; 

endmodule