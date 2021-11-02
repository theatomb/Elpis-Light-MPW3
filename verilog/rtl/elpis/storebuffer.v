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

module storebuffer(
	input clk,
	input reset,
	input[31:0] addr_in,
	input[31:0] data_in,
	input is_byte,
	input sb_we,  // Add a new entry into SB
	input sb_re,  // Read request (bypass) from an entry of SB
	input stall_dcache,
	input hit_dtlb,
	output reg sb_hit,
	output full_out,
	output empty_out,
	output reg[31:0] addr_out,
	output reg[31:0] data_out,
	output reg is_byte_out,
	output reg drain_out,
	output reg is_data_to_cache
);
	reg useless_bit, hold_value_to_cache;
	reg[31:0] sb_addr[0:`SB_NUM_ENTRIES-1];
	reg[31:0] sb_data[0:`SB_NUM_ENTRIES-1];
	reg sb_size[0:`SB_NUM_ENTRIES-1]; // 0 - word, 1 - byte
	reg sb_valid[0:`SB_NUM_ENTRIES-1];
  
	reg[$clog2(`SB_NUM_ENTRIES)-1:0] head;
	reg[$clog2(`SB_NUM_ENTRIES)-1:0] tail;
	reg[$clog2(`SB_NUM_ENTRIES)-1:0] tail_last;
	reg[$clog2(`SB_NUM_ENTRIES):0] entry_count;

	wire[31:0] ld_first_byte, ld_last_byte;
	wire[1:0] offset;
  
	assign ld_first_byte = addr_in;
	assign ld_last_byte = (is_byte) ? addr_in : (addr_in+3);
	assign offset = addr_in[1:0];
  
	assign empty_out = (entry_count == 0);
	assign full_out = (entry_count == `SB_NUM_ENTRIES);

	reg[1:0] hit_pos;
    integer i;
	always@(*) begin
		sb_hit = 1'b0;
		hit_pos = 2'b0;
		for (i = 0; (i < `SB_NUM_ENTRIES); i=i+1) begin
			if (sb_valid[i] && (sb_addr[i] <= ld_first_byte) && ( (sb_addr[i] + (sb_size[i] ? 0 : 3'b11) ) >= ld_last_byte) ) begin
				sb_hit = 1'b1;
				hit_pos = i[1:0];
			end
		end
	end

	always@(posedge clk) begin
		if (reset) begin
			head <= 2'b0;
			tail <= 2'b0;
			entry_count <= 3'b0;
			for(i = 0; i < `SB_NUM_ENTRIES; i=i+1) begin
				sb_valid[i] <= 1'b0;
			end
		end else begin
			if (sb_re && sb_hit) begin
				data_out <= (is_byte && sb_size[hit_pos]) ? {24'b0, sb_data[hit_pos][offset*'d8]} : sb_data[hit_pos];
			end

			if(sb_we && sb_hit) begin
				if (is_byte && !sb_size[hit_pos]) begin
					// We have a word and want to write a byte
					sb_data[hit_pos][offset*8+:8] <= data_in[7:0]; 
				end else if (is_byte && sb_size[hit_pos]) begin
					// We have a byte and want to write a byte
					sb_data[hit_pos] <= {24'b0, data_in[7:0]};
				end else begin
					// We have (byte or word) and we want to write a word
					sb_data[hit_pos] <= data_in;
					sb_size[hit_pos] <= 1'b0;
				end
			end

			if ((full_out && !stall_dcache) || (!sb_we && !sb_re && !empty_out && !stall_dcache)) begin
				drain_out <= 1'b1;
				tail_last <= tail; 
				is_data_to_cache <= 1'b1;
				addr_out <= sb_addr[tail];
				data_out <= sb_data[tail];
				is_byte_out <= sb_size[tail];
				entry_count <= entry_count - 1'b1;
				sb_valid[tail] <= 1'b0;
				{useless_bit, tail} <= (tail+1'b1)%`SB_NUM_ENTRIES;
				hold_value_to_cache <= 1'b1;
			end else if(stall_dcache && hold_value_to_cache) begin 
				drain_out <= 1'b1;
				is_data_to_cache <= 1'b1;
				addr_out <= sb_addr[tail_last];
				data_out <= sb_data[tail_last];
				is_byte_out <= sb_size[tail_last];
				hold_value_to_cache <= 1'b1;
			end else begin
				drain_out <= 1'b0;
				is_data_to_cache <= 1'b0;
				hold_value_to_cache <= 1'b0;
				tail_last <= 'b0;
			end

			if (sb_we && !full_out && !sb_hit && hit_dtlb) begin
				sb_addr[head] <= addr_in;
				sb_data[head] <= data_in;
				sb_size[head] <= is_byte;
				sb_valid[head] <= 1'b1;
				entry_count <= entry_count + 1'b1;
				{useless_bit, head} <= (head + 1'b1)%`SB_NUM_ENTRIES;
			end
		end
  	end
  
endmodule
