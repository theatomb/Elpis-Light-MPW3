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

module cache #(parameter CORE_ID = 0, parameter CACHE_TYPE = `CACHE_TYPE_ICACHE)(input clk, input reset, input[31:0] address_in, input[31:0] data_in, input write_enable_in,
	input read_enable_in, input mem_ready_in, input[127:0] mem_data_in, input is_byte, input reset_mem_req, input privilege_mode, input tlb_we, input tlb_re, 
	input[19:0] physical_addr_in, input[31:0] virtual_addr_write_tlb_in, input[19:0] physical_addr_write_tlb_in,
	output reg[31:0] read_data_out, output reg hit_out, output reg[19:0] mem_addr_out, output reg[127:0] mem_data_out, output reg req_mem, output reg mem_we_out,
	output reg hit_tlb, output reg exc_protected_page_tlb);

	wire is_hit_tlb, is_privilege_mode, is_tlb_we, is_tlb_re, is_exc_protected_page_tlb;
	wire[19:0] phys_addr_out;

	always@(*) begin
		hit_tlb <= is_hit_tlb;
		exc_protected_page_tlb <= is_exc_protected_page_tlb;
	end
	
	assign is_privilege_mode = privilege_mode;
	assign is_tlb_we = tlb_we;
	assign is_tlb_re = tlb_re;

	tlb #(.CORE_ID(CORE_ID), .CACHE_TYPE(CACHE_TYPE)) tlb(
		.clk(clk),
		.reset(reset),
		.virtual_addr(address_in),
		.virtual_addr_write_in(virtual_addr_write_tlb_in),
		.privilege_mode(is_privilege_mode),
		.tlb_we(is_tlb_we),
		.tlb_re(is_tlb_re),
		.physical_addr_in(physical_addr_in),
		.physical_addr_write_in(physical_addr_write_tlb_in),
		.physical_addr_out(phys_addr_out),
		.hit_tlb(is_hit_tlb),
		.exc_protected_page(is_exc_protected_page_tlb)
	 );
	
	reg[0:0] cacheValidBits[0:`NUM_CACHE_LINES-1];
	reg[0:0] cacheDirtyBits[0:`NUM_CACHE_LINES-1];
	reg[`CACHE_TAG_SIZE-1:0] cacheTag[0:`NUM_CACHE_LINES-1];
	reg[`CACHE_LINE_SIZE-1:0] cacheData[0:`NUM_CACHE_LINES-1];

	// SRAM cache data and tag ports
	reg[`CACHE_TAG_SIZE-1:0] 	sram_addr_in_port;
	wire[`CACHE_TAG_SIZE-1:0] 	sram_addr_out_port;
	reg[`CACHE_LINE_SIZE-1:0] 	sram_data_in_port;
	wire[`CACHE_LINE_SIZE-1:0] 	sram_data_out_port;
	wire sram_we_port, sram_we_valid, sram_we_dirty, sram_value_valid, sram_value_dirty;
	
	wire[`CACHE_TAG_SIZE-1:0] tag;
	wire[1:0] index;
	wire[3:0] offset;
	
	assign tag = phys_addr_out[19:6]; 
	assign index = address_in[5:4];
	assign offset = address_in[3:0];
	
	reg[2:0] cache_state, next_cache_state;
	
	integer i;
	
	always@(posedge clk)
	begin
		if (reset) begin
			cache_state <= `IDLE_STATE;
		end
		else cache_state <= next_cache_state;
	end

	wire[31:0] auxAL = phys_addr_out>>2;
	wire[31:0] auxWB = {sram_addr_out_port, index, 2'b0};

	wire no_need_write_back = (!hit_out & !cacheDirtyBits[index]);
	wire need_write_back = (!hit_out & cacheDirtyBits[index]);
	
	always@(cache_state or read_enable_in or write_enable_in or reset_mem_req or no_need_write_back or need_write_back or mem_ready_in or is_hit_tlb or hit_out) begin
		case(cache_state)
			`IDLE_STATE:begin
				if ((read_enable_in | write_enable_in) && is_hit_tlb) begin
					if (hit_out) begin
						next_cache_state <= `IDLE_STATE;
					end
					else if (reset_mem_req) begin
						next_cache_state <= `IDLE_STATE;
					end
					else if (no_need_write_back) begin
						next_cache_state <= `ALLOCATE_STATE;
					end
					else if (need_write_back) begin
						next_cache_state <= `WRITE_BACK_STATE;
					end else begin
						next_cache_state <= `IDLE_STATE;
					end
				end
				else begin
					next_cache_state <= `IDLE_STATE;
				end
			end
			`ALLOCATE_STATE: begin
				if (reset_mem_req) next_cache_state <= `IDLE_STATE;
				else if (!mem_ready_in) next_cache_state <= `ALLOCATE_STATE;
				else next_cache_state <= `IDLE_STATE;
			end
			`WRITE_BACK_STATE: begin
				if (reset_mem_req) next_cache_state <= `IDLE_STATE;
				else if (!mem_ready_in) next_cache_state <= `WRITE_BACK_STATE;
				// else if (mem_ready_in) next_cache_state <= `IDLE_STATE; 
				else next_cache_state <= `ALLOCATE_STATE;
			end
			default: next_cache_state <= `IDLE_STATE;
		endcase
	end

	always@(posedge clk) begin
		if (reset) begin
			for(i = 0; i < `NUM_CACHE_LINES; i=i+1) begin
				cacheValidBits[i] <= 1'b0;
				cacheDirtyBits[i] <= 1'b0;
			end
		end else begin
			if (sram_we_port || (cache_state == `ALLOCATE_STATE && mem_ready_in) ) begin
				cacheTag[index] <= (cache_state == `ALLOCATE_STATE) ? tag : sram_addr_in_port;
				cacheData[index] <= (cache_state == `ALLOCATE_STATE) ? mem_data_in : sram_data_in_port;
			end
			if (sram_we_valid || (cache_state == `ALLOCATE_STATE && mem_ready_in) ) begin
				cacheValidBits[index] <= (cache_state == `ALLOCATE_STATE) ? 1'b1 : sram_value_valid;
			end
			if (sram_we_dirty || (cache_state == `ALLOCATE_STATE && mem_ready_in)) begin
				cacheDirtyBits[index] <= (cache_state == `ALLOCATE_STATE) ? 1'b0 : sram_value_dirty;
			end

		end		
	end

	assign sram_addr_out_port = (cache_state == `ALLOCATE_STATE && mem_ready_in) ? tag : cacheTag[index];
	assign sram_data_out_port = (cache_state == `ALLOCATE_STATE && mem_ready_in) ? mem_data_in : cacheData[index];

	assign sram_we_port = ((hit_out && write_enable_in) || (cache_state == `ALLOCATE_STATE && mem_ready_in)) ? 1'b1 : 1'b0;
	assign sram_we_dirty = ((hit_out && write_enable_in) || (cache_state == `ALLOCATE_STATE && mem_ready_in)) ? 1'b1 : 1'b0;
	assign sram_we_valid = ((hit_out && write_enable_in) || (cache_state == `ALLOCATE_STATE && mem_ready_in)) ? 1'b1 : 1'b0;
	assign sram_value_valid = 1'b1;
	assign sram_value_dirty = (cacheDirtyBits[index] | write_enable_in);

	always@(*) begin
		if (reset) begin
			mem_data_out <= 128'b0;
			req_mem <= 0;
			mem_we_out <= 0;
			mem_addr_out <= 20'b0;
			sram_data_in_port <= 128'b0;
			sram_addr_in_port <= 'b0;
		end else begin
			case(cache_state)
				`IDLE_STATE: begin
					mem_data_out <= 128'b0;
					mem_addr_out <= 20'b0; 
					req_mem <= 0;
					mem_we_out <= 0;
					if (write_enable_in) begin
						sram_addr_in_port <= tag;
						if (is_byte) begin
							case(offset)
								4'b0000:sram_data_in_port <= {sram_data_out_port[127:8], data_in[7:0]};
								4'b0001:sram_data_in_port <= {sram_data_out_port[127:16], data_in[7:0], sram_data_out_port[7:0]};
								4'b0010:sram_data_in_port <= {sram_data_out_port[127:24], data_in[7:0], sram_data_out_port[15:0]};
								4'b0011:sram_data_in_port <= {sram_data_out_port[127:32], data_in[7:0], sram_data_out_port[23:0]};
								4'b0100:sram_data_in_port <= {sram_data_out_port[127:40], data_in[7:0], sram_data_out_port[31:0]};
								4'b0101:sram_data_in_port <= {sram_data_out_port[127:48], data_in[7:0], sram_data_out_port[39:0]};
								4'b0110:sram_data_in_port <= {sram_data_out_port[127:56], data_in[7:0], sram_data_out_port[47:0]};
								4'b0111:sram_data_in_port <= {sram_data_out_port[127:64], data_in[7:0], sram_data_out_port[55:0]};
								4'b1000:sram_data_in_port <= {sram_data_out_port[127:72], data_in[7:0], sram_data_out_port[63:0]};
								4'b1001:sram_data_in_port <= {sram_data_out_port[127:80], data_in[7:0], sram_data_out_port[71:0]};
								4'b1010:sram_data_in_port <= {sram_data_out_port[127:88], data_in[7:0], sram_data_out_port[79:0]};
								4'b1011:sram_data_in_port <= {sram_data_out_port[127:96], data_in[7:0], sram_data_out_port[87:0]};
								4'b1100:sram_data_in_port <= {sram_data_out_port[127:104], data_in[7:0], sram_data_out_port[95:0]};
								4'b1101:sram_data_in_port <= {sram_data_out_port[127:112], data_in[7:0], sram_data_out_port[103:0]};
								4'b1110:sram_data_in_port <= {sram_data_out_port[127:120], data_in[7:0], sram_data_out_port[111:0]};
								4'b1111:sram_data_in_port <= {data_in[7:0], sram_data_out_port[119:0]};
								default: sram_data_in_port <= 128'b0;
							endcase 
						end else begin
							case(offset)
								4'b0000:sram_data_in_port <= {sram_data_out_port[127:32], data_in};
								4'b0100:sram_data_in_port <= {sram_data_out_port[127:64], data_in, sram_data_out_port[31:0]};
								4'b1000:sram_data_in_port <= {sram_data_out_port[127:96], data_in, sram_data_out_port[63:0]};
								4'b1100:sram_data_in_port <= {data_in, sram_data_out_port[95:0]};
								default: sram_data_in_port <= 128'b0;
							endcase 
						end
					end else begin
						sram_addr_in_port <= 'b0;
						sram_data_in_port <= 128'b0;
					end
				end
				`ALLOCATE_STATE: begin
					mem_data_out <= 128'b0;
					mem_addr_out <= {auxAL[17:2],2'b00};
					mem_we_out <= 1'b0;
					if (mem_ready_in) begin
						req_mem  <= 1'b0;
						sram_data_in_port <= mem_data_in;
						sram_addr_in_port <= tag;
					end else begin
						req_mem  <= 1'b1;
						sram_data_in_port <= 128'b0;
						sram_addr_in_port <= 'b0;
					end
				end
				`WRITE_BACK_STATE: begin
					req_mem <= 1'b1;
					mem_we_out <= 1'b1;
					mem_addr_out <= auxWB[19:0];
					mem_data_out <= sram_data_out_port;
					sram_data_in_port <= 128'b0;
					sram_addr_in_port <= 'b0;
				end
				default: begin
					sram_addr_in_port <= 'b0;
					sram_data_in_port <= 128'b0;
					mem_data_out <= 128'b0;
					mem_addr_out <= 20'b0;
				end
			endcase
		end
	end

	//BIT SELECTOR
	always@(*) begin
		if (read_enable_in) begin
			if (is_byte) begin
				read_data_out <= {24'b0, sram_data_out_port[offset*8+:8]};
			end else begin
				read_data_out <= sram_data_out_port[offset*8+:32];
			end
		end else begin
			read_data_out <= 0;
		end
	end

	always@(*) begin : hit_cache_logic
   		if (read_enable_in | write_enable_in) begin
			if (cache_state != `IDLE_STATE) begin
				hit_out <= 1'b0;
			end else begin
				if(write_enable_in) begin
					hit_out <= (sram_addr_out_port == tag) && cacheValidBits[index] && is_hit_tlb;
				end else begin
					hit_out <= (sram_addr_out_port == tag) && cacheValidBits[index] && is_hit_tlb;
				end
				
			end
	  	end
		else hit_out <= 1;
	end
	
endmodule
