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

module tlb #(parameter CORE_ID=0, parameter CACHE_TYPE=`CACHE_TYPE_ICACHE)(
    input clk,
    input reset,
    input[31:0] virtual_addr,
    input[31:0] virtual_addr_write_in,
    input privilege_mode,  // 0 - users, 1 - system
    input tlb_we,
    input tlb_re,
    input[19:0] physical_addr_write_in,
    input[19:0] physical_addr_in,
    output [19:0] physical_addr_out,
    output hit_tlb,
    output exc_protected_page
);

    reg[19:0] tlb_pages[0:`NUM_TLB_LINES-1];
    reg[7:0] tlb_frames[0:`NUM_TLB_LINES-1];
    reg tlbValidBits[0:`NUM_TLB_LINES-1];
    reg tlb_lru[0:`NUM_TLB_LINES-1];
    
    wire[19:0] page;
    wire[19:0] candidate_physical_addr_out;
    
    assign exc_protected_page = (tlb_we && !privilege_mode) ? 1'b1 : 1'b0;
    assign page = tlb_we ? virtual_addr_write_in[31:12] : virtual_addr[31:12];

    wire[$clog2(`NUM_TLB_LINES)-1:0] id_candidate_write;
    reg[$clog2(`NUM_TLB_LINES)-1:0] id_candidate_read, id_candidate_write_empty, id_candidate_write_no_empty, id_last_accessed;
    reg found_read, found_write_empty;

    integer i;
    always@(*) begin : get_id_read
        id_candidate_read = 4'b0;
        found_read = 1'b0;
        for (i=0; i < `NUM_TLB_LINES; i=i+1) begin
            if ((page == tlb_pages[i]) && tlbValidBits[i]) begin
                id_candidate_read = i[3:0];
                found_read = 1'b1;
            end
        end
    end

    integer j;
    always@(*) begin : get_id_write_empty
        id_candidate_write_empty = 0;
        found_write_empty = 0;
        for (j=0; j < `NUM_TLB_LINES; j=j+1) begin
            if ((tlbValidBits[j] == 0) && !found_write_empty) begin
                found_write_empty = 1'b1;
                id_candidate_write_empty = j[3:0];
            end
        end
    end

    integer k, n_1_lru;
    always@(*) begin : get_id_candidate_write_no_empty
        id_candidate_write_no_empty = 0;
        for (k=0; k < `NUM_TLB_LINES; k=k+1) begin
            if (tlb_lru[k] == 1'b0) begin
                id_candidate_write_no_empty = k[$clog2(`NUM_TLB_LINES)-1:0];
            end
        end
    end

    integer u;
    always@(posedge clk) begin : count_n_1_lru
        if (reset) begin
            n_1_lru = 0;
        end else begin
            n_1_lru = n_1_lru + (tlb_we && privilege_mode);
        end
    end

    integer c;
    always@(posedge clk) begin : plru_management
        if (reset) begin
            for (c=0; c < `NUM_TLB_LINES; c=c+1) begin
                tlb_lru[c] <= 1'b0;
            end 
        end else begin
            if(n_1_lru == `NUM_TLB_LINES) begin
                for (c=0; c < `NUM_TLB_LINES; c=c+1) begin
                    tlb_lru[c] <= id_last_accessed == c;
                end
            end
            tlb_lru[id_last_accessed] <= 1'b1;
        end
    end

    assign hit_tlb = found_read || privilege_mode; 
    assign candidate_physical_addr_out = (tlb_re && !privilege_mode && found_read) ? {tlb_frames[id_candidate_read], virtual_addr[11:0]} : (privilege_mode ? virtual_addr[19:0] : 20'b0);
    assign physical_addr_out = candidate_physical_addr_out;
    assign id_candidate_write = found_write_empty ? id_candidate_write_empty : id_candidate_write_no_empty;

    integer l;
    always@(posedge clk) begin : write_tlb_structures
        if (reset) begin
            for (l=0; l < `NUM_TLB_LINES; l=l+1) begin
                tlbValidBits[l] <= 0;
            end
        end else begin
            if (tlb_we && privilege_mode) begin // TLBwrite
                tlb_pages[id_candidate_write] <= page;
                tlb_frames[id_candidate_write] <= physical_addr_write_in[19:12];
                tlbValidBits[id_candidate_write] <= 1'b1;
                id_last_accessed <= id_candidate_write;
            end else if (tlb_re && !privilege_mode && found_read) begin // TLBRead
                id_last_accessed <= id_candidate_read;
            end
        end
    end

endmodule