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

`ifdef TESTS
	`include "elpis/definitions.v"
`else
    `include "/project/openlane/user_proj_example/../../verilog/rtl/elpis/definitions.v"
`endif

module sram_wrapper
	(
`ifdef USE_POWER_PINS
	inout vccd1,	// User area 1 1.8V supply
	inout vssd1,	// User area 1 digital ground
`endif
	input clk,
	input reset,
	input we,
	input[19:0] addr_in,
	input[127:0] wr_data,
	input requested,
	input reset_mem_req,
    input is_loading_memory_into_core,
	input[19:0] addr_to_core_mem,
	input[31:0] data_to_core_mem,
	output reg[127:0] rd_data_out,
	output ready,
	// SRAM Wrapper ports
	output reg we_to_sram, 
    output csb0_to_sram,
    output spare_wen0_to_sram,
    output[19:0] addr0_to_sram,
    output[31:0] din0_to_sram, 
    input[31:0] dout0_to_sram
);

	reg[19:0] addr_to_sram;
	reg[31:0] data_to_sram;

	wire[7:0] first_bit_out_current;
	reg[7:0] first_bit_out_previous;
	reg[31:0] auxiliar_mem_out;

	// Assigns to openRAM sram
    assign csb0_to_sram = 1'b0;
    assign spare_wen0_to_sram = 1'b0;
    assign addr0_to_sram = addr_to_sram;
    assign din0_to_sram = data_to_sram;

	reg[$clog2(`MEMORY_DELAY_CYCLES):0] cycles;
	
	assign ready = cycles == 0;
	assign first_bit_out_current = 6'd32 * (cycles % 3'd4);

	always@(posedge clk) begin
		if(reset) begin 
			cycles <= 0;
		end else if (reset_mem_req) begin
			cycles <= 0;
		end else if ((ready && requested))begin
			cycles <= `MEMORY_DELAY_CYCLES;
		end else if(cycles!=0) begin
			cycles <= cycles-1'b1 ;
		end

		first_bit_out_previous <= first_bit_out_current;
		rd_data_out[first_bit_out_previous +:32] <= auxiliar_mem_out;
	end

	always@(*) begin
		if (we && requested && !is_loading_memory_into_core) begin
			if(cycles == 4) begin
				data_to_sram <= wr_data[31:0];
				we_to_sram <= 1'b0;
			end else if (cycles == 3) begin
				data_to_sram <= wr_data[63:32];
				we_to_sram <= 1'b0;
			end else if (cycles == 2) begin
				data_to_sram <= wr_data[95:64];
				we_to_sram <= 1'b0;
			end else if (cycles == 1) begin
				data_to_sram <= wr_data[127:96];
				we_to_sram <= 1'b0;
			end else begin
				data_to_sram <= 32'b0;
				we_to_sram <= 1'b1;
			end 
		end else if(is_loading_memory_into_core) begin
			data_to_sram <= data_to_core_mem;
			we_to_sram <= 1'b0;
		end else begin
			data_to_sram <= 32'b0;
			we_to_sram <= 1'b1;
		end

		if(!is_loading_memory_into_core && !we) begin
			addr_to_sram <= addr_in + (cycles % 3'd4);
		end else if(we && requested && !is_loading_memory_into_core) begin
			if(cycles == 4) begin
				addr_to_sram <= addr_in;
			end else if (cycles == 3) begin
				addr_to_sram <= addr_in + 1'b1;
			end else if (cycles == 2) begin
				addr_to_sram <= addr_in + 2'd2;
			end else if (cycles == 1) begin
				addr_to_sram <= addr_in + 2'd3;
			end else begin
				addr_to_sram <= addr_in;
			end
		end else begin
			addr_to_sram <= addr_to_core_mem;
		end

		auxiliar_mem_out <= dout0_to_sram;
	end
	
endmodule
