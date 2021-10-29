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

module arbiter(
	input clk,
	input reset,
	output reg[19:0] mem_addr,
	input[127:0] dcache_to_mem_data_in,		// Input data from dCache
	output reg[127:0] dcache_to_mem_data_out,	// Output data to memory
	output [127:0] mem_to_icache_data,		// Output data to iCache
  	output [127:0] mem_to_dcache_data,		// Output data to dCache
  	input[127:0] data_from_mem,			// Input data from memory
  	input dcache_we,
  	output reg mem_we,
  	input icache_request,
  	input dcache_request,
  	input mem_ready,
 	output reg is_icache_ready,
  	output reg is_dcache_ready,
  	input reset_mem_req,
  	input hit_itlb_in,
 	input hit_dtlb_in,
  	input[19:0] itlb_physical_addr_in,
  	input[19:0] dtlb_physical_addr_in,
  	input dcache_re,
    output reg is_mem_req
);

	reg[2:0] arb_state, next_arb_state;

	assign mem_to_icache_data = data_from_mem;
	assign mem_to_dcache_data = data_from_mem;

 	always@(posedge clk) begin
		if (reset || reset_mem_req) begin
			arb_state <= `ARB_IDLE_STATE;
		end
		else arb_state <= next_arb_state;
	end

    always@(dcache_request or icache_request or hit_dtlb_in or hit_itlb_in or mem_ready or arb_state) begin
        case(arb_state)
            `ARB_IDLE_STATE: begin
                if (dcache_request && hit_dtlb_in) next_arb_state <= `ARB_DCACHE_REQUEST;
                else if (icache_request && hit_itlb_in) next_arb_state <= `ARB_ICACHE_REQUEST;
                else next_arb_state <= `ARB_IDLE_STATE;
            end
            `ARB_DCACHE_REQUEST: begin
                next_arb_state <= `ARB_DCACHE_WAIT;
            end
            `ARB_ICACHE_REQUEST: begin
                next_arb_state <= `ARB_ICACHE_WAIT;
            end
            `ARB_DCACHE_WAIT: begin
                if(mem_ready)begin
                    next_arb_state <= `ARB_IDLE_STATE;
                end else begin
                    next_arb_state <= `ARB_DCACHE_WAIT;
                end
            end
            `ARB_ICACHE_WAIT: begin
                if(mem_ready) begin
                    next_arb_state <= `ARB_IDLE_STATE;
                end else begin
                    next_arb_state <= `ARB_ICACHE_WAIT;
                end
            end
            default: next_arb_state <= `ARB_IDLE_STATE;
        endcase
    end

    always@(arb_state or mem_ready) begin
        case(arb_state)
            `ARB_IDLE_STATE: begin
                is_dcache_ready <= 0;
                is_icache_ready <= 0;
                mem_we <= 0;
                dcache_to_mem_data_out <= 0;
                mem_addr <= 0;
                is_mem_req <= 1'b0;
            end
            `ARB_DCACHE_REQUEST: begin
                is_dcache_ready <= 0;
                is_icache_ready <= 0;
                mem_we <= dcache_we;
                mem_addr <= dtlb_physical_addr_in;
                dcache_to_mem_data_out <= dcache_to_mem_data_in;
                is_mem_req <= 1'b1;
            end
            `ARB_ICACHE_REQUEST: begin
                is_dcache_ready <= 0;
                is_icache_ready <= 0;
                mem_we <= 0;
                mem_addr <= itlb_physical_addr_in;
                dcache_to_mem_data_out <= 0;
                is_mem_req <= 1'b1;
            end
            `ARB_DCACHE_WAIT: begin
                if (mem_ready) begin
                    is_dcache_ready <= mem_ready;
                    is_mem_req <= 1'b0;
                end else begin
                    is_dcache_ready <= 0;
                    is_mem_req <= 1'b1;
                end
                is_icache_ready <= 0; 
                mem_we <= dcache_we;
                dcache_to_mem_data_out <= dcache_to_mem_data_in;
                mem_addr <= dtlb_physical_addr_in;
            end
            `ARB_ICACHE_WAIT: begin
                if (mem_ready) begin
                    is_icache_ready <= mem_ready;
                    is_mem_req <= 1'b0;
                end else begin
                    is_icache_ready <= 0;
                    is_mem_req <= 1'b1;
                end
                is_dcache_ready <= 0;
                mem_we <= 0;
                dcache_to_mem_data_out <= 0;
                mem_addr <= itlb_physical_addr_in;
            end
            default: begin
                is_dcache_ready <= 0;
                is_icache_ready <= 0;
                mem_we <= 0;
                dcache_to_mem_data_out <= 0;
                mem_addr <= 0;
                is_mem_req <= 1'b0;
            end
        endcase
    end

endmodule
