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

module IF_ID(input clk, input stall_icache, input stall, input flush, input[31:0] pc_in, input[31:0] inst_in, input is_hit_itlb_in, input[31:0] exc_code_in, 
	input psw_in, input is_flush_in,
	output reg[31:0] pc_out, output reg[31:0] inst_out, output reg is_hit_itlb_out, output reg[31:0] rm2_out, output reg psw_out, output reg[31:0] rm1_out, 
	output reg[31:0] rm0_out, output reg is_flush_out);

	always@(posedge clk) begin
		if (flush) begin
			inst_out <= `NOP;
			pc_out <= `PC_INITIAL;
			is_hit_itlb_out <= 0;
			rm2_out <= 0;
			psw_out <= 0;
			rm1_out <= 0;
			rm0_out <= 0;
			is_flush_out <= 1;
		end else if (exc_code_in) begin
			inst_out <= `NOP;
			pc_out <= `PC_INITIAL;
			is_hit_itlb_out <= 0;
			rm2_out <= exc_code_in;
			psw_out <= psw_in;
			rm1_out <= pc_in;
			rm0_out <= pc_in;
			is_flush_out <= 0;
		end else if (stall) begin
			inst_out <= inst_out;
			pc_out <= pc_out;
			is_hit_itlb_out <= is_hit_itlb_out; 
			rm2_out <= rm2_out;
			psw_out <= psw_out;
			rm1_out <= rm1_out;
			rm0_out <= rm0_out;
			is_flush_out <= is_flush_out;
		end else if (stall_icache) begin
		 	inst_out <= `NOP;
			pc_out <= pc_out;
			is_hit_itlb_out <= is_hit_itlb_out;
			rm2_out <= rm2_out;
			psw_out <= psw_out;
			rm1_out <= rm1_out;
			rm0_out <= rm0_out;
			is_flush_out <= is_flush_out;
		end else begin
			inst_out <= inst_in;	
			pc_out <= pc_in;
			is_hit_itlb_out <= is_hit_itlb_in;
			rm2_out <= exc_code_in;
			psw_out <= psw_in;
			rm1_out <= 0;
			rm0_out <= 0;
			is_flush_out <= is_flush_in;
		end
	end

endmodule


module ID_EX(input clk, input flush, input haz, input stall, input[31:0] reg_a_in, input[31:0] reg_b_in, input[3:0] alu_op_in, input[4:0] reg_addr_dest_in, 
	input reg_write_enable_in, input is_flush_in, input is_ecall_in, input[6:0] io_code_in,
	input rb_imm_in, input[31:0] immed_in, input mem_to_reg_in, input mem_we_in, input[31:0] pc_in, input[2:0] branch_code_in,input is_a_jump_in, input[4:0] reg_a_addr_in,
	input[4:0] reg_b_addr_in, input is_byte_in, input[1:0] is_mov_in, input[31:0] reg_rm_in, input psw_in, input[31:0] exc_code_in, input[31:0] fw_reg_a_in, input[31:0] fw_reg_b_in,
	input is_tlbwrite_in, input is_iret_in, input is_hit_itlb_in,	input[31:0] rm2_in, input[31:0] rm1_in, input[31:0] rm0_in, input[31:0] stored_rm1_in, input[31:0] stored_rm2_in, input[31:0] stored_rm4_in,
	output reg[31:0] reg_a_out, output reg[31:0] reg_b_out, output reg[3:0] alu_op_out, output reg[4:0] reg_addr_dest_out, output reg reg_write_enable_out, output reg[6:0] io_code_out,
	output reg rb_imm_out, output reg[31:0] immed_out, output reg mem_to_reg_out, output reg mem_we_out, output reg[31:0] pc_out, output reg[2:0] branch_code_out,
	output reg is_a_jump_out, output reg[4:0] reg_a_addr_out, output reg[4:0] reg_b_addr_out, output reg is_byte_out, output reg[31:0] stored_rm1_out, output reg[31:0] stored_rm2_out, output reg[31:0] stored_rm4_out, 
	output reg[1:0] is_mov_out, output reg[31:0] reg_rm_out, output reg psw_out, output reg pending_haz, output reg is_ecall_out,
	output reg is_tlbwrite_out, output reg is_iret_out, output reg is_hit_itlb_out, output reg[31:0] rm2_out, output reg[31:0] rm1_out, output reg[31:0] rm0_out, output reg is_flush_out);
	 
		always@(posedge clk) begin
			if (flush) begin
				reg_a_out <= 0;
				reg_b_out <= 0;
				alu_op_out <= `ALU_OP_ADD;
				reg_addr_dest_out <= 0;
				reg_write_enable_out <= 0;
				rb_imm_out <= 0;
				immed_out <= 0;
				mem_to_reg_out <= 0;
				mem_we_out <= 0;
				pc_out <= `PC_INITIAL;
				branch_code_out <= `FUNCT3_BRANCH_NO;
				is_a_jump_out <= 0;
				reg_a_addr_out <= 0;
				reg_b_addr_out <= 0;
				is_byte_out <= 0;
				is_mov_out <= 0;
				is_ecall_out <= 0;
				reg_rm_out <= 0;
				psw_out <= 0;
				is_tlbwrite_out <= 0;
				is_iret_out <= 0;
				is_hit_itlb_out <= 0;
				io_code_out <= 0;
				rm2_out <= 0;
				rm1_out <= 0;
				rm0_out <= 0;
				stored_rm2_out <= 0;
				stored_rm1_out <= 0;
				stored_rm4_out <= 0;
				pending_haz <= 0;
				is_flush_out <= 1;
			end else if (exc_code_in) begin
				reg_a_out <= 0;
				reg_b_out <= 0;
				alu_op_out <= `ALU_OP_ADD;
				reg_addr_dest_out <= 0;
				reg_write_enable_out <= 0;
				rb_imm_out <= 0;
				immed_out <= 0;
				mem_to_reg_out <= 0;
				mem_we_out <= 0;
				pc_out <= `PC_INITIAL;
				branch_code_out <= `FUNCT3_BRANCH_NO;
				is_a_jump_out <= 0;
				reg_a_addr_out <= 0;
				reg_b_addr_out <= 0;
				is_byte_out <= 0;
				is_mov_out <= 0;
				is_ecall_out <= 0;
				reg_rm_out <= 0;
				psw_out <= 0;
				io_code_out <= 0;
				is_tlbwrite_out <= 0;
				is_iret_out <= 0;
				is_hit_itlb_out <= 0;
				stored_rm2_out <= 0;
				stored_rm1_out <= 0;
				stored_rm4_out <= 0;
				pending_haz <= 0;
				is_flush_out <= 0;
				if (rm2_in) begin
					rm2_out <= rm2_in;
					rm1_out <= rm1_in;
					rm0_out <= rm0_in;
				end else begin
					rm2_out <= exc_code_in;
					rm1_out <= 0;
					rm0_out <= rm0_in;
				end
			end else if (stall) begin
				reg_a_out <= fw_reg_a_in;
				reg_b_out <= fw_reg_b_in;
				alu_op_out <= alu_op_out;
				reg_addr_dest_out <= reg_addr_dest_out;
				reg_write_enable_out <= reg_write_enable_out;
				rb_imm_out <= rb_imm_out;
				immed_out <= immed_out;
				mem_to_reg_out <= mem_to_reg_out;
				mem_we_out <= mem_we_out;
				branch_code_out <= branch_code_out;
				is_a_jump_out <= is_a_jump_out;
				reg_a_addr_out <= reg_a_addr_out;
				reg_b_addr_out <= reg_b_addr_out;
				pc_out <= pc_out;
				is_byte_out <= is_byte_out;
				is_mov_out <= is_mov_out;
				is_ecall_out <= is_ecall_out;
				reg_rm_out <= reg_rm_out;
				psw_out <= psw_out;
				is_tlbwrite_out <= is_tlbwrite_out;
				is_iret_out <= is_iret_out;
				io_code_out <= io_code_out;
				is_hit_itlb_out <= is_hit_itlb_out;
				rm2_out <= rm2_out;
				rm1_out <= rm1_out;
				rm0_out <= rm0_out;
				stored_rm2_out <= stored_rm2_out;
				stored_rm1_out <= stored_rm1_out;
				stored_rm4_out <= stored_rm4_out;
				is_flush_out <= is_flush_out;
				pending_haz <= haz;
			end else if (haz) begin
				reg_a_out <= reg_a_out;
				reg_b_out <= reg_b_out;
				alu_op_out <= 0; 
				reg_addr_dest_out <= 0;
				reg_write_enable_out <= 0;
				rb_imm_out <= rb_imm_out;
				immed_out <= immed_out;
				mem_to_reg_out <= 0;
				mem_we_out <= 0;
				branch_code_out <= `FUNCT3_BRANCH_NO;
				is_a_jump_out <= 0;
				reg_a_addr_out <= reg_a_addr_out;
				reg_b_addr_out <= reg_b_addr_out;
				pc_out <= pc_out;
				is_byte_out <= 0;
				is_mov_out <= is_mov_out;
				io_code_out <= io_code_out;
				is_ecall_out <= is_ecall_out;
				reg_rm_out <= reg_rm_out;
				psw_out <= psw_out;
				is_tlbwrite_out <= is_tlbwrite_out;
				is_iret_out <= is_iret_out;
				is_hit_itlb_out <= is_hit_itlb_out;
				rm2_out <= rm2_in;
				rm1_out <= rm1_in;
				rm0_out <= rm0_in;
				stored_rm2_out <= stored_rm2_out;
				stored_rm1_out <= stored_rm1_out;
				stored_rm4_out <= stored_rm4_out;
				pending_haz <= 0;
				is_flush_out <= is_flush_out;
			end else begin
				reg_a_out <= reg_a_in;
				reg_b_out <= reg_b_in;
				alu_op_out <= alu_op_in;
				reg_addr_dest_out <= reg_addr_dest_in;
				reg_write_enable_out <= reg_write_enable_in;
				rb_imm_out <= rb_imm_in;
				immed_out <= immed_in;
				mem_to_reg_out <= mem_to_reg_in;
				mem_we_out <= mem_we_in;
				pc_out <= pc_in;
				branch_code_out <= branch_code_in;
				is_a_jump_out <= is_a_jump_in;
				reg_a_addr_out <= reg_a_addr_in;
				reg_b_addr_out <= reg_b_addr_in;
				is_byte_out <= is_byte_in;
				is_mov_out <= is_mov_in;
				io_code_out <= io_code_in;
				is_ecall_out <= is_ecall_in;
				reg_rm_out <= reg_rm_in;
				psw_out <= psw_in;
				is_tlbwrite_out <= is_tlbwrite_in;
				is_iret_out <= is_iret_in;
				is_hit_itlb_out <= is_hit_itlb_in;
				rm2_out <= rm2_in;
				rm1_out <= rm1_in;
				rm0_out <= rm0_in;
				stored_rm2_out <= stored_rm2_in;
				stored_rm1_out <= stored_rm1_in;
				stored_rm4_out <= stored_rm4_in;
				pending_haz <= 0;
				is_flush_out <= is_flush_in;
			end
	end
	
endmodule


module EX_MEM(input clk, input flush, input stall, input reg_write_enable_in, input[4:0] reg_dest_in, input [31:0] reg_data_in, input mem_to_reg_in, input[31:0] pc_in,
	input mem_we_in, input[31:0] reg_b_in, input[31:0] pc_candidate_address_in, input z_in, input is_branch_taken_in, input is_a_jump_in, input is_flush_in, input[6:0] io_code_in,
	input[31:0] exc_code_in, input[31:0] rm0_in, input[31:0] rm1_in, input[31:0] rm2_in, input psw_in, input is_byte_in, input sb_hit_in, input is_ecall_in, input[1:0] is_mov_in,
	input[4:0] reg_b_addr_in, input[31:0] sb_addr_out_in, input[31:0] sb_data_out_in, input sb_data_to_cache_in, input was_stall_dcache_in, input sb_is_byte_in,
	input is_tlbwrite_in, input is_iret_in, input is_hit_itlb_in, input[31:0] stored_rm4_in, input[31:0] stored_rm2_in, input[31:0] stored_rm1_in, input[31:0] physical_tlb_addr_in,
	output reg reg_write_enable_out, output reg[4:0] reg_dest_out, output reg [31:0] reg_data_out, output reg[31:0] stored_rm1_out, output reg[31:0] stored_rm2_out, output reg[31:0] stored_rm4_out,
	output reg mem_to_reg_out, output reg mem_we_out, output reg[31:0] reg_b_out,output reg[31:0] pc_candidate_address_out,  output reg [31:0] physical_tlb_addr_out,
	output reg z_out, output reg is_branch_taken_out, output reg is_a_jump_out,
	output reg[31:0] rm0_out, output reg[31:0] rm1_out, output reg[31:0] rm2_out, output reg psw_out, output reg is_flush_out, output reg[6:0] io_code_out,
	output reg is_byte_out, output reg sb_is_byte_out, output reg[4:0] reg_b_addr_out, output reg[31:0] sb_addr_out_out, output reg[31:0] sb_data_out_out, output reg[1:0] is_mov_out,
	output reg sb_hit_out, output reg sb_data_to_cache_out, output reg was_stall_dcache_out, output reg is_tlbwrite_out, output reg is_iret_out, output reg is_ecall_out,
	output reg is_hit_itlb_out, output reg[31:0] pc_out);
	
	always@(posedge clk) begin
		if (flush) begin
			reg_write_enable_out <= 0;
			reg_dest_out <= 0;
			reg_data_out <= 0;
			mem_to_reg_out <= 0;
			mem_we_out <= 0;
			reg_b_out <= 0;
			pc_candidate_address_out <= `PC_INITIAL;
			z_out <= 0;
			is_branch_taken_out <= 0;
			is_a_jump_out <= 0;
			is_ecall_out <= 0;
			io_code_out <= 0;
			rm0_out <= 0;
			rm1_out <= 0;
			rm2_out <= 0;
			psw_out <= 0;
			is_byte_out <= 0;
			reg_b_addr_out <= 0;
			sb_addr_out_out <= 0;
			sb_is_byte_out <= 0;
			sb_data_out_out <= 0;
			was_stall_dcache_out <= 0;
			sb_data_to_cache_out <= 0;
			sb_hit_out <= 0;
			is_tlbwrite_out <= 0;
			is_iret_out <= 0;
			is_hit_itlb_out <= 0;
			stored_rm2_out <= 0;
			stored_rm1_out <= 0;
			stored_rm4_out <= 0;
			physical_tlb_addr_out <= 0;
			is_mov_out <= 0;
			pc_out <= `PC_INITIAL;
			is_flush_out <= 1;
		end else if (exc_code_in) begin
			reg_write_enable_out <= 0;
			reg_dest_out <= 0;
			reg_data_out <= 0;
			mem_to_reg_out <= 0;
			mem_we_out <= 0;
			reg_b_out <= 0;
			pc_candidate_address_out <= `PC_INITIAL;
			z_out <= 0;
			io_code_out <= 0;
			is_ecall_out <= 0;
			is_branch_taken_out <= 0;
			is_a_jump_out <= 0;
			is_byte_out <= 0;
			reg_b_addr_out <= 0;
			sb_addr_out_out <= 0;
			sb_is_byte_out <= 0;
			sb_data_out_out <= 0;
			is_mov_out <= 0;
			// if (rm2_in) begin
			//  	rm2_out <= rm2_in;
			// 	rm0_out <= rm0_in;
			// 	rm1_out <= rm1_in;
			// end else begin
			//  	rm2_out <= exc_code_in;
			// 	rm0_out <= rm0_in;
			// 	rm1_out <= 0;
			// end
			rm2_out <= (rm2_in) ? rm2_in : exc_code_in;
			rm0_out <= (rm2_in) ? rm0_in : rm0_in;
			rm1_out <= (rm2_in) ? rm1_in : 0;
			psw_out <= psw_in;
			was_stall_dcache_out <= 0;
			sb_data_to_cache_out <= 0;
			sb_hit_out <= 0;
			is_tlbwrite_out <= 0;
			is_iret_out <= 0;
			is_hit_itlb_out <= 0;
			stored_rm2_out <= 0;
			stored_rm1_out <= 0;
			stored_rm4_out <= 0;
			physical_tlb_addr_out <= 0;
			pc_out <= `PC_INITIAL;
			is_flush_out <= 0;
		end else if (!stall) begin
			reg_write_enable_out <= reg_write_enable_in;
			reg_dest_out <= reg_dest_in;
			reg_data_out <= reg_data_in;
			mem_to_reg_out <= mem_to_reg_in;
			mem_we_out <= mem_we_in;
			reg_b_out <= reg_b_in;
			pc_candidate_address_out <= pc_candidate_address_in;
			z_out <= z_in;
			io_code_out <= io_code_in;
			is_branch_taken_out <= is_branch_taken_in;
			is_a_jump_out <= is_a_jump_in;
			is_byte_out <= is_byte_in;
			reg_b_addr_out <= reg_b_addr_in;
			rm0_out <= rm0_in;
			rm1_out <= rm1_in;
			rm2_out <= rm2_in;
			psw_out <= psw_in;
			is_ecall_out <= is_ecall_in;
			sb_addr_out_out <= sb_addr_out_in;
			sb_data_out_out <= sb_data_out_in;
			sb_is_byte_out <= sb_is_byte_in;
			was_stall_dcache_out <= 0;
			sb_data_to_cache_out <= 0;
			sb_hit_out <= 0;
			is_tlbwrite_out <= is_tlbwrite_in;
			is_iret_out <= is_iret_in;
			is_hit_itlb_out <= is_hit_itlb_in;
			stored_rm2_out <= stored_rm2_in;
			stored_rm1_out <= stored_rm1_in;
			stored_rm4_out <= stored_rm4_in;
			physical_tlb_addr_out <= physical_tlb_addr_in;
			pc_out <= pc_in;
			is_flush_out <= is_flush_in;
			is_mov_out <= is_mov_in;
		end else if (was_stall_dcache_out) begin
			was_stall_dcache_out <= was_stall_dcache_out;
			sb_addr_out_out <= sb_addr_out_out;
			sb_data_out_out <= sb_data_out_out;
			sb_is_byte_out <= sb_is_byte_out;
			sb_data_to_cache_out <= sb_data_to_cache_out;
			sb_hit_out <= sb_hit_out;
			is_iret_out <= is_iret_out;
			io_code_out <= io_code_out;
			is_mov_out <= is_mov_out;
			is_ecall_out <= is_ecall_out;
			is_branch_taken_out <= is_branch_taken_out;
			reg_data_out <= reg_data_out;
			pc_candidate_address_out <= pc_candidate_address_out;
			rm0_out <= rm0_out;
			rm1_out <= rm1_out;
			rm2_out <= rm2_out;
			psw_out <= psw_out;
			is_flush_out <= is_flush_out;
			is_hit_itlb_out <= is_hit_itlb_out;
			stored_rm2_out <= stored_rm2_out;
			stored_rm1_out <= stored_rm1_out;
			stored_rm4_out <= stored_rm4_out;
			physical_tlb_addr_out <= physical_tlb_addr_out;
			pc_out <= pc_out;
			is_tlbwrite_out <= is_tlbwrite_out;
			is_a_jump_out <= is_a_jump_out;
			is_byte_out <= is_byte_out;
			reg_b_addr_out <= reg_b_addr_out;
			z_out <= z_out;
			mem_to_reg_out <= mem_to_reg_out;
			mem_we_out <= mem_we_out;
			reg_b_out <= reg_b_out;
			reg_write_enable_out <= reg_write_enable_out;
			reg_dest_out <= reg_dest_out;
		end else if (was_stall_dcache_in) begin
			was_stall_dcache_out <= was_stall_dcache_in;
			sb_addr_out_out <= sb_addr_out_in;
			sb_data_out_out <= sb_data_out_in;
			sb_data_to_cache_out <= sb_data_to_cache_in;
			sb_is_byte_out <= sb_is_byte_in;
			sb_hit_out <= sb_hit_in;
			is_iret_out <= is_iret_in;
			io_code_out <= io_code_in;
			is_mov_out <= is_mov_in;
			is_ecall_out <= is_ecall_in;
			is_branch_taken_out <= is_branch_taken_in;
			pc_candidate_address_out <= pc_candidate_address_in;
			rm0_out <= rm0_out;
			rm1_out <= rm1_out;
			rm2_out <= rm2_out;
			psw_out <= psw_out;
			is_flush_out <= is_flush_out;
			is_hit_itlb_out <= is_hit_itlb_out;
			stored_rm2_out <= stored_rm2_out;
			stored_rm1_out <= stored_rm1_out;
			stored_rm4_out <= stored_rm4_out;
			physical_tlb_addr_out <= physical_tlb_addr_out;
			pc_out <= pc_out;
			is_tlbwrite_out <= is_tlbwrite_out;
			is_a_jump_out <= is_a_jump_out;
			is_byte_out <= is_byte_out;
			reg_b_addr_out <= reg_b_addr_out;
			z_out <= z_out;
			mem_to_reg_out <= mem_to_reg_out;
			mem_we_out <= mem_we_out;
			reg_b_out <= reg_b_out;
			reg_write_enable_out <= reg_write_enable_out;
			reg_dest_out <= reg_dest_out;
		end else begin
			was_stall_dcache_out <= was_stall_dcache_out;
			sb_addr_out_out <= sb_addr_out_out;
			sb_data_out_out <= sb_data_out_out;
			sb_is_byte_out <= sb_is_byte_out;
			sb_data_to_cache_out <= sb_data_to_cache_out;
			sb_hit_out <= sb_hit_out;
			is_iret_out <= is_iret_out;
			io_code_out <= io_code_out;
			is_mov_out <= is_mov_out;
			is_ecall_out <= is_ecall_out;
			is_branch_taken_out <= is_branch_taken_out;
			reg_data_out <= reg_data_out;
			pc_candidate_address_out <= pc_candidate_address_out;
			rm0_out <= rm0_out;
			rm1_out <= rm1_out;
			rm2_out <= rm2_out;
			psw_out <= psw_out;
			is_flush_out <= is_flush_out;
			is_hit_itlb_out <= is_hit_itlb_out;
			stored_rm2_out <= stored_rm2_out;
			stored_rm1_out <= stored_rm1_out;
			stored_rm4_out <= stored_rm4_out;
			physical_tlb_addr_out <= physical_tlb_addr_out;
			pc_out <= pc_out;
			is_tlbwrite_out <= is_tlbwrite_out;
			is_a_jump_out <= is_a_jump_out;
			is_byte_out <= is_byte_out;
			reg_b_addr_out <= reg_b_addr_out;
			z_out <= z_out;
			mem_to_reg_out <= mem_to_reg_out;
			mem_we_out <= mem_we_out;
			reg_b_out <= reg_b_out;
			reg_write_enable_out <= reg_write_enable_out;
			reg_dest_out <= reg_dest_out;
		end
	end

endmodule


module MEM_WB(input clk, input flush, input stall, input[4:0] reg_dest_in, input[31:0] reg_data_alu_in, input reg_write_enable_in, input[31:0] mem_data_in, input mem_to_reg_in,
  	input[31:0] rm0_in, input[31:0] rm1_in, input[31:0] rm2_in, input psw_in, input is_iret_in, input is_hit_dtlb_in, input is_hit_itlb_in, input[31:0] exc_code_in, input[31:0] stored_rm4_in,
  	input[31:0] mem_addr_in, input[31:0] pc_in, input is_flush_in, input is_ecall_in, input[1:0] is_mov_in, input[6:0] io_code_in, input[31:0] read_interactive_value_in, input is_read_interactive_enabled_in,
	output reg[4:0] reg_dest_out, output reg[31:0] reg_data_alu_out, output reg reg_write_enable_out, output reg[31:0] mem_data_out, output reg mem_to_reg_out, output reg[1:0] is_mov_out,
	output reg[31:0] rm0_out, output reg[31:0] rm1_out, output reg[31:0] rm2_out, output reg is_iret_out, output reg is_hit_dtlb_out, output reg[31:0] pc_out, output reg[31:0] stored_rm4_out,
	output reg is_hit_itlb_out, output reg is_flush_out, output reg[6:0] io_code_out, output reg[31:0] read_interactive_value_out, output reg is_read_interactive_enabled_out);

	always@(posedge clk) begin
		if (flush) begin
			reg_dest_out <= 0;
			reg_data_alu_out <= 0;
			reg_write_enable_out <= 1'b0;
			mem_data_out <= 1'b0;
			mem_to_reg_out <= 1'b0;
			rm0_out <= 0;
			rm1_out <= 0;
			rm2_out <= 0;
			stored_rm4_out <= 0;
			is_iret_out <= 0;
			is_hit_dtlb_out <= 0;
			is_hit_itlb_out <= 0;
			is_mov_out <= 0;
			io_code_out <= 0;
			is_read_interactive_enabled_out <= 0;
			read_interactive_value_out <= 0;
			pc_out <= `PC_INITIAL;
			is_flush_out <= 1;
		end
		else if (exc_code_in) begin
			reg_dest_out <= 0;
			reg_data_alu_out <= 0;
			reg_write_enable_out <= 1'b0;
			mem_data_out <= 1'b0;
			mem_to_reg_out <= 1'b0;
			rm0_out <= 0;
			rm1_out <= 0;
			rm2_out <= 0;
			stored_rm4_out <= 0;
			io_code_out <= 0;
			is_iret_out <= 0;
			is_mov_out <= 0;
			is_hit_dtlb_out <= 0;
			is_hit_itlb_out <= 0;
			is_read_interactive_enabled_out <= 0;
			read_interactive_value_out <= 0;
			if (rm2_in) begin
				if (rm2_in == `EXC_ITLB_MISS) begin
					rm2_out <= rm2_in;
					rm1_out <= rm1_in;
					rm0_out <= rm0_in;
				end else begin
					rm2_out <= 0;
					rm1_out <= 0;
					rm0_out <= 0;
				end
			end else begin
				if ( (exc_code_in == `EXC_ITLB_MISS) || (exc_code_in == `EXC_DTLB_MISS ) ) begin
					rm2_out <= exc_code_in;
					rm1_out <= mem_addr_in;
					rm0_out <= pc_in;
				end else begin
					rm2_out <= 0;
					rm1_out <= 0;
					rm0_out <= 0;
				end
			end
			pc_out <= `PC_INITIAL;
			is_flush_out <= 0;
		end else if (!stall) begin
			reg_dest_out <= reg_dest_in;
			reg_data_alu_out <= reg_data_alu_in;
			reg_write_enable_out <= reg_write_enable_in;
			mem_data_out <= mem_data_in;
			mem_to_reg_out <= mem_to_reg_in;
			if(is_ecall_in) begin
				rm0_out <= pc_in + 4; // PC jumps to the following instruction of the ecall
				rm1_out <= rm1_in;
				rm2_out <= reg_data_alu_in;
			end else begin
				rm0_out <= rm0_in;
				rm1_out <= rm1_in;
				rm2_out <= rm2_in;
			end
			stored_rm4_out <= stored_rm4_in;
			is_mov_out <= is_mov_in;
			io_code_out <= io_code_in;
			is_iret_out <= is_iret_in;
			is_hit_dtlb_out <= is_hit_dtlb_in;
			is_hit_itlb_out <= is_hit_itlb_in;
			pc_out <= pc_in;
			is_flush_out <= is_flush_in;
			is_read_interactive_enabled_out <= is_read_interactive_enabled_in;
			read_interactive_value_out <= read_interactive_value_in;
		end
	end

endmodule