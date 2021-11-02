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

module datapath #(parameter CORE_ID=0) (
	input clk,
	input reset,
	input[31:0] mem_data_rd_f,
	input[31:0] mem_data_rd_m,
	input hit_icache,
	input hit_dcache,
	input hit_itlb,
	input hit_dtlb,
	input[31:0] read_interactive_value,
	input is_read_interactive_enabled,
	output[31:0] mem_addr_f,
	output[31:0] mem_addr_m,
	output[31:0] mem_data_wr,
	output mem_wrd,
	output dcache_re,
	output mem_isbyte,
	output reset_mem_req,
	output privilege_mode, // PSW/rm3
	output is_tlbwrite,
	output[31:0] current_address_rm2,
	output[19:0] mem_physical_tlb_addr_out,
	output[31:0] exception_type,
	output[31:0] print_output,
	output print_hex_enable,
	output read_interactive_req,
	input is_print_done
);
	wire stall_icache, stall_dcache;
	wire[31:0] global_rm0; // PC of current exception (if exists)

	wire[31:0] branch_or_jump_address_wire;
	wire is_branch_or_jump_taken_wire, is_iret_wire;
	reg is_iret_ff;	

	reg flush;
	reg boot;

	wire[3:0] id_alu_op;
	wire id_reg_we;
	wire[4:0] id_reg_src1_addr, id_reg_src2_addr, id_reg_dest_addr;
	wire[31:0] id_reg_a_content, id_reg_b_content;
	wire[2:0] id_branch_code;
	wire id_is_a_jump;
	wire id_regb_immed;
	wire[31:0] id_immediate;
	wire id_mem_to_reg;
	wire id_mem_we;
	wire id_stall;
	wire id_is_byte, id_is_ecall, id_is_iret;
	wire[1:0] id_is_mov;
	wire[6:0] id_io_code;
	wire[31:0] id_is_illegal;
	wire[31:0] id_reg_rm, id_rm2, id_rm1, id_rm0, id_current_rm1, id_current_rm2, id_current_rm4;
	wire id_is_tlbwrite, is_iret, id_hit_itlb;
	wire[31:0] id_reg_dest_value;
	
	wire[31:0] ex_reg_a, ex_reg_b;
	wire[31:0] ex_res_alu, ex_res_mul;
	wire[31:0] ex_reg_opX, ex_reg_opY;
	wire[3:0] ex_alu_op;
	wire[4:0] ex_reg_addr_dest;
	wire ex_z;
	wire ex_reg_write_enable;
	wire ex_mem_to_reg;
	wire ex_mem_we;
	wire ex_is_branch_taken;
	wire[31:0] ex_immed;
 	wire ex_regb_immed;
	wire[31:0] ex_pc;
	wire[2:0] ex_branch_code;
	wire ex_is_a_jump;
	wire[4:0] ex_reg_a_addr, ex_reg_b_addr;
	wire[31:0] ex_exc_code;
	wire[31:0] ex_rm0, ex_rm1, ex_rm2;
	wire ex_is_byte, ex_pend_haz, ex_is_ecall;
	wire[1:0] ex_is_mov;
	wire[6:0] ex_io_code;
	wire[31:0] ex_reg_rm, ex_reg_rm3, ex_current_rm1, ex_current_rm2, ex_current_rm4, ex_physical_tlb_addr;
	wire ex_is_tlbwrite, ex_is_iret, ex_hit_itlb;

	wire mem_z;
	wire[31:0] mem_branch_or_jump_address;
	wire mem_is_branch_taken;
	wire mem_is_a_jump;
	wire mem_is_branch_or_jump_taken;
	wire mem_reg_write_enable;
	wire[4:0] mem_reg_addr_dest;
	wire[31:0] mem_reg_data;
	wire mem_mem_to_reg;
	wire mem_mem_we;
	wire[31:0] mem_reg_b;
	wire[31:0] mem_rm0, mem_rm1, mem_rm2, mem_rm3, mem_current_rm1, mem_current_rm2, mem_current_rm4, mem_physical_tlb_addr;
	wire mem_is_byte;
	wire[1:0] mem_is_mov;
	wire[4:0] mem_reg_b_addr;
	wire[6:0] mem_io_code;
	wire mem_is_iret, mem_hit_itlb, mem_is_ecall, mem_is_tlbwrite;
	wire[31:0] mem_pc;
	wire mem_stall_read_sw;

	wire[31:0] wb_alu_res;
	wire[31:0] wb_current_rm4;
	wire[4:0] wb_addr_d, wb_addr_d_from_mem, wb_addr_d_from_m5;
	wire wb_reg_write_enable, wb_reg_write_enable_from_mem, wb_reg_write_enable_from_m5;
	wire[31:0] wb_data_to_reg, wb_data_to_reg_from_mem, wb_data_to_reg_from_m5;
	wire[31:0] wb_rm0, wb_rm1, wb_rm2;
	wire wb_is_iret, wb_hit_dtlb, wb_hit_itlb;
	wire[1:0] wb_is_mov;
	wire[6:0] wb_io_code;
	wire[31:0] wb_pc;
	wire[31:0] wb_read_interactive_value;
	wire wb_read_interactive_enable;
	
	// SB
	wire was_stall_dcache, sb_data_to_cache_aux_in, sb_data_to_cache_aux_out, sb_hit_aux_in,sb_hit_aux_out, sb_is_byte_aux_out, sb_is_byte_aux_in;
	wire[31:0] sb_addr_out_aux_in, sb_data_out_aux_in, sb_addr_out_aux_out, sb_data_out_aux_out;
	wire sb_hit, sb_full, sb_empty, sb_is_byte, sb_continue_drain_out, sb_data_to_cache_out, sb_drain;

	wire wb_or_hf_reg_write_enable;
	wire[31:0] wb_or_hf_data_to_reg;
	wire[4:0] wb_or_hf_addr_to_reg; 
	wire[31:0] wb_or_hf_rm0, wb_or_hf_rm1, wb_or_hf_rm2;
	wire id_is_flush, ex_is_flush, mem_is_flush, wb_is_flush;

	wire is_exception, is_exception_reached;
	reg is_exception_pending;
	reg f_PSW;
	wire id_PSW, ex_PSW, mem_PSW, wb_PSW;
	wire stall_print;
	
	// DEBUG
	// Number of current cycle
	reg[31:0] cycleNumber;
	initial cycleNumber = 0;
	always@(posedge clk) cycleNumber = cycleNumber + 1'b1;


	// IF stage
	
	reg[31:0] pc;
	wire[31:0] pc_next, id_pc, id_inst, f_pc;
	
	always@(reset or is_branch_or_jump_taken_wire)
	begin
		if(reset) begin
			flush <= 1'b1;
		end
		else begin
			flush <= is_branch_or_jump_taken_wire;
		end
	end
	
	assign stall_icache = !hit_icache;
	
	// Trigger flush memory request in case of exception
	assign is_exception = is_exception_pending || is_exception_reached;
	assign reset_mem_req = is_exception;
	
	reg[31:0] branch_or_jump_address_ff;
	reg is_branch_or_jump_taken_ff;
	reg was_a_stall;
	
	assign branch_or_jump_address_wire = was_a_stall ? ((is_iret_wire) ? global_rm0 : branch_or_jump_address_ff) : ((is_iret_wire) ? global_rm0 : mem_branch_or_jump_address);
	assign is_branch_or_jump_taken_wire = was_a_stall ? is_branch_or_jump_taken_ff : mem_is_branch_or_jump_taken;
	assign is_iret_wire = was_a_stall ? is_iret_ff : mem_is_iret;

	always@(posedge clk) begin
		if (reset) begin
			pc <= `PC_INITIAL;
			was_a_stall <= 1'b0;
			is_branch_or_jump_taken_ff <= 1'b0;
			f_PSW <= 1'b1;
			is_iret_ff <= 1'b0;
			boot <= 1'b1;
			is_exception_pending <= 1'b0;
		end else if (is_exception | boot) begin
			pc <= `PC_EXCEPTIONS;
			f_PSW <= 1'b1;
			boot <= 1'b0;
			is_exception_pending <= 1'b0;
		end else if ((id_stall | stall_icache | stall_dcache | mem_stall_read_sw | stall_print)) begin
			pc <= pc;
			was_a_stall <= 1'b1;
			f_PSW <= f_PSW;
			if(mem_is_branch_or_jump_taken) begin
				branch_or_jump_address_ff <= is_branch_or_jump_taken_ff ? branch_or_jump_address_ff : mem_branch_or_jump_address;
				is_branch_or_jump_taken_ff <= mem_is_branch_or_jump_taken;
				is_iret_ff <= mem_is_iret;
			end
			is_exception_pending <= is_exception_pending || is_exception_reached;
		end else begin
			pc <= (is_branch_or_jump_taken_wire == 1'b0) ? pc_next : branch_or_jump_address_wire;
			was_a_stall <= 1'b0;
			is_branch_or_jump_taken_ff <= 1'b0;
			f_PSW <= is_iret_wire ? 1'b0 : f_PSW;
			is_iret_ff <= 1'b0;
			is_exception_pending <= is_exception_pending || is_exception_reached;
		end
	end

	assign pc_next = pc+4;
	assign mem_addr_f = pc;
	wire[31:0] f_inst = mem_data_rd_f;
	
	wire[31:0] f_exc_code_in = (!hit_itlb && !privilege_mode) ? `EXC_ITLB_MISS : 0;

	IF_ID IF_ID(.clk(clk), .stall_icache(stall_icache), .stall(id_stall | stall_dcache | (sb_drain && sb_full) | stall_print), .flush(flush | is_exception | mem_stall_read_sw), .pc_in(pc), 
	.psw_in(f_PSW), .is_flush_in(1'b0),
	.inst_in(f_inst), .is_hit_itlb_in(hit_itlb), .exc_code_in(f_exc_code_in), .pc_out(id_pc), .inst_out(id_inst), .is_hit_itlb_out(id_hit_itlb), .rm2_out(id_rm2), 
	.psw_out(id_PSW), .rm1_out(id_rm1), .rm0_out(id_rm0), .is_flush_out(id_is_flush));


	// ID stage
	
	assign id_reg_src1_addr = id_inst[19:15];
	assign id_reg_src2_addr = id_inst[24:20];

	hazardDetectionUnit hazardDetectionUnit(
		.ex_reg_dest_addr_in(ex_reg_addr_dest),
		.ex_mem_read_in(ex_mem_to_reg),
		.id_reg_a_addr_in(id_reg_src1_addr),
		.id_reg_b_addr_in(id_reg_src2_addr),
		.stall_out(id_stall)
	);

	controlunit controlunit(
		.rst(reset),
		.ir(id_inst),
		.op_alu(id_alu_op),
		.wrd_reg(id_reg_we),
		.addr_d(id_reg_dest_addr),
		.rb_immed(id_regb_immed),
		.imm(id_immediate),
		.mem_to_reg(id_mem_to_reg),
		.wrd_mem(id_mem_we),
		.branch_code(id_branch_code),
		.is_a_jump(id_is_a_jump),
		.is_byte(id_is_byte),
		.is_mov(id_is_mov),
		.is_illegal(id_is_illegal),
		.is_tlbwrite(id_is_tlbwrite),
		.is_iret(id_is_iret),
		.is_ecall(id_is_ecall),
		.io_code(id_io_code)
	);

	regfile regfile(
		.clk(clk),
		.reset(reset),
		.wrd(wb_or_hf_reg_write_enable),
		.d(wb_or_hf_data_to_reg),
		.addr_a(id_reg_src1_addr),
		.addr_b(id_reg_src2_addr),
		.addr_d(wb_or_hf_addr_to_reg),
		.a(id_reg_a_content),
		.b(id_reg_b_content)
	);
	
	specialreg specialreg(
	   .clk(clk),
	   .reset(reset),
	   .in_rm0(wb_or_hf_rm0),
	   .in_rm1(wb_or_hf_rm1),
	   .in_rm2(is_branch_or_jump_taken_wire ? 0 : wb_or_hf_rm2),
	   .in_other_rm(wb_data_to_reg),
	   .sel(id_reg_src2_addr[2:0]),
	   .we(wb_is_mov == `MOV_REGULAR_TO_RM || wb_read_interactive_enable),
	   .out_rm0(global_rm0),
	   .out_rm1(id_current_rm1),
	   .out_rm2(id_current_rm2),
	   .out_rm(id_reg_rm),
	   .out_rm4(id_current_rm4)
	);

 	
	ID_EX ID_EX(.clk(clk), .flush(flush | is_exception), .haz(id_stall | ex_pend_haz), .stall(stall_dcache | (sb_drain && sb_full) | mem_stall_read_sw | stall_print), .reg_a_in(id_reg_a_content), .reg_b_in(id_reg_b_content), .alu_op_in(id_alu_op), 
		.reg_addr_dest_in(id_reg_dest_addr), .reg_write_enable_in(id_reg_we), .rb_imm_in(id_regb_immed), .immed_in(id_immediate),  .io_code_in(id_io_code),
		.mem_to_reg_in(id_mem_to_reg), .mem_we_in(id_mem_we), .pc_in(id_pc), .branch_code_in(id_branch_code), .is_flush_in(1'b0),
		.is_a_jump_in(id_is_a_jump), .reg_a_addr_in(id_reg_src1_addr), .reg_b_addr_in(id_reg_src2_addr), .is_byte_in(id_is_byte),
		.is_mov_in(id_is_mov), .reg_rm_in(id_reg_rm), .psw_in(id_PSW), .exc_code_in(id_is_illegal), .is_tlbwrite_in(id_is_tlbwrite), .is_iret_in(id_is_iret), .is_ecall_in(id_is_ecall),
		.is_hit_itlb_in(id_hit_itlb), .rm2_in(id_rm2), .rm1_in(id_rm1), .rm0_in(id_rm0), .stored_rm1_in(id_current_rm1), .stored_rm2_in(id_current_rm2), .stored_rm4_in(id_current_rm4), .fw_reg_a_in(ex_reg_opX), .fw_reg_b_in(ex_reg_opY),
		.reg_a_out(ex_reg_a), .reg_b_out(ex_reg_b), .alu_op_out(ex_alu_op), .reg_addr_dest_out(ex_reg_addr_dest), .reg_write_enable_out(ex_reg_write_enable), 
		.rb_imm_out(ex_regb_immed), .immed_out(ex_immed), .mem_to_reg_out(ex_mem_to_reg), .mem_we_out(ex_mem_we), .pc_out(ex_pc), .io_code_out(ex_io_code),
		.branch_code_out(ex_branch_code), .is_a_jump_out(ex_is_a_jump), .reg_a_addr_out(ex_reg_a_addr), .reg_b_addr_out(ex_reg_b_addr), .is_flush_out(ex_is_flush),
		.is_byte_out(ex_is_byte), .is_mov_out(ex_is_mov), .reg_rm_out(ex_reg_rm), .psw_out(ex_PSW), .stored_rm1_out(ex_current_rm1), .stored_rm2_out(ex_current_rm2), .stored_rm4_out(ex_current_rm4),
		.is_tlbwrite_out(ex_is_tlbwrite), .is_iret_out(ex_is_iret), .is_hit_itlb_out(ex_hit_itlb), .rm2_out(ex_rm2), .rm1_out(ex_rm1), .rm0_out(ex_rm0), .pending_haz(ex_pend_haz), .is_ecall_out(ex_is_ecall));
		 
		 
	// EX stage

	wire[1:0] ex_forward_x, ex_forward_y;
	
	forwardingunit forwardingunit(
		.ex_reg_a_in(ex_reg_a_addr),
		.ex_reg_b_in(ex_reg_b_addr),
		.mem_reg_d_in(mem_reg_addr_dest),
		.wb_reg_d_in(wb_addr_d),
		.mem_reg_we_in(mem_reg_write_enable),
		.wb_reg_we_in(wb_reg_write_enable),
		.forward_x(ex_forward_x),
		.forward_y(ex_forward_y)
	);
	
	mux3_1 muxOpX(ex_forward_x, ex_reg_a, wb_data_to_reg, mem_reg_data, ex_reg_opX);
	mux3_1 muxOpY(ex_forward_y, ex_reg_b, wb_data_to_reg, mem_reg_data, ex_reg_opY);
	
	// Bypass ALU-ALU to ST
	wire[31:0] ex_reg_b_fw;
	
	wire[1:0] forwarding_reg_b;
	
	forwardingunit_st forwardingunit_st(
		.mem_we(ex_mem_we),
		.ex_reg_b_in(ex_reg_b_addr),
		.mem_reg_b_in(mem_reg_b_addr),
		.forwarding_y(ex_forward_y),
		.forwarding_regb(forwarding_reg_b)
	);
	
	mux3_1 muxRegB(forwarding_reg_b, ex_reg_b, ex_reg_opY, mem_reg_b, ex_reg_b_fw);
	
	wire[31:0] ex_opX, ex_opX_pre;
	wire[31:0] ex_opY, ex_opY_pre;
	
	assign ex_opX_pre = (ex_branch_code != `FUNCT3_BRANCH_NO) ? ex_pc : ex_reg_opX;
	assign ex_opY_pre = (ex_regb_immed > 0) ? ex_immed : ex_reg_opY;
	
	assign ex_opX = (ex_is_mov == 2'b01) ? ex_reg_rm : ( (ex_is_mov == 2'b10) ? 32'b0 : ex_opX_pre);
	assign ex_opY = (ex_is_mov == 2'b01) ? 32'b0 : ex_opY_pre;
	
	branchComparer branchComparer(
		.branch_code_in(ex_branch_code), 
		.reg_a_content_in(ex_reg_opX), 
		.reg_b_content_in(ex_reg_opY), 
		.is_branch_taken_out(ex_is_branch_taken)
	);
	
	alu alu(
		.x(ex_opX),
		.y(ex_opY),
		.op(ex_alu_op),
		.w(ex_res_alu),
		.z(ex_z),
		.exception_code(ex_exc_code)
	);
	
	TLBAddressAdder #(.CORE_ID(CORE_ID)) TLBAddressAdder(
		.address_in(ex_current_rm1),
		.exception_code_in(ex_current_rm2),
		.address_out(ex_physical_tlb_addr)
	);


	EX_MEM EX_MEM(.clk(clk), .flush(flush | is_exception), .stall(stall_dcache | (sb_drain && sb_full) | mem_stall_read_sw | stall_print), .reg_write_enable_in(ex_reg_write_enable), .reg_dest_in(ex_reg_addr_dest),
	.reg_data_in(ex_res_alu), .mem_to_reg_in(ex_mem_to_reg), .mem_we_in(ex_mem_we), .reg_b_in(ex_reg_b_fw), .pc_in(ex_pc), .is_ecall_in(ex_is_ecall), .io_code_in(ex_io_code),
	.pc_candidate_address_in(ex_res_alu), .z_in(ex_z), .is_branch_taken_in(ex_is_branch_taken), .is_a_jump_in(ex_is_a_jump), .physical_tlb_addr_in(ex_physical_tlb_addr), .is_mov_in(ex_is_mov),
	.exc_code_in(ex_exc_code), .rm0_in(ex_rm0), .rm1_in(ex_rm1), .rm2_in(ex_rm2), .psw_in(ex_PSW), .is_byte_in(ex_is_byte), .stored_rm1_in(ex_current_rm1), .stored_rm2_in(ex_current_rm2), .stored_rm4_in(ex_current_rm4),
	.reg_b_addr_in(ex_reg_b_addr), .sb_addr_out_in(sb_addr_out_aux_in), .sb_is_byte_in(sb_is_byte_aux_in), .sb_data_out_in(sb_data_out_aux_in), .sb_data_to_cache_in(sb_data_to_cache_aux_in), 
	.sb_hit_in(sb_hit_aux_in), .was_stall_dcache_in(stall_dcache), .is_tlbwrite_in(ex_is_tlbwrite), .is_iret_in(ex_is_iret), .is_hit_itlb_in(ex_hit_itlb), .is_flush_in(1'b0),
	.reg_write_enable_out(mem_reg_write_enable), .reg_dest_out(mem_reg_addr_dest), .reg_data_out(mem_reg_data), .mem_to_reg_out(mem_mem_to_reg), .is_mov_out(mem_is_mov),
	.mem_we_out(mem_mem_we), .reg_b_out(mem_reg_b), .pc_candidate_address_out(mem_branch_or_jump_address), .z_out(mem_z), .is_branch_taken_out(mem_is_branch_taken), .is_flush_out(mem_is_flush), .io_code_out(mem_io_code),
	.is_a_jump_out(mem_is_a_jump), .rm0_out(mem_rm0), .rm1_out(mem_rm1), .rm2_out(mem_rm2), .psw_out(mem_PSW), .is_byte_out(mem_is_byte), .sb_is_byte_out(sb_is_byte_aux_out), .stored_rm1_out(mem_current_rm1), .stored_rm2_out(mem_current_rm2),
	.reg_b_addr_out(mem_reg_b_addr), .sb_addr_out_out(sb_addr_out_aux_out), .sb_data_out_out(sb_data_out_aux_out), .sb_data_to_cache_out(sb_data_to_cache_aux_out), .physical_tlb_addr_out(mem_physical_tlb_addr), .stored_rm4_out(mem_current_rm4),
	.sb_hit_out(sb_hit_aux_out), .was_stall_dcache_out(was_stall_dcache), .is_tlbwrite_out(mem_is_tlbwrite), .is_iret_out(mem_is_iret), .is_hit_itlb_out(mem_hit_itlb), .pc_out(mem_pc),.is_ecall_out(mem_is_ecall));
	
	assign mem_is_branch_or_jump_taken = mem_is_branch_taken | mem_is_a_jump;
	assign stall_dcache =  (!hit_dcache & mem_mem_to_reg & sb_hit_aux_in) ? 1'b0 : !hit_dcache;


	// MEM stage
	assign dcache_re = mem_mem_to_reg;
	
	wire[31:0] sb_addr_out, sb_data_out;
	assign sb_drain = sb_continue_drain_out;
	
	assign privilege_mode = f_PSW;
	assign is_tlbwrite = mem_is_tlbwrite;
	assign exception_type = mem_current_rm2;
	assign current_address_rm2 = mem_current_rm1;
	assign mem_physical_tlb_addr_out = mem_physical_tlb_addr[19:0];
	
	storebuffer storebuffer(
		.clk(clk),
	 	.reset(reset),
	 	.addr_in(mem_reg_data),
	 	.data_in(mem_reg_b),
	 	.is_byte(mem_is_byte),
	 	.sb_we(mem_mem_we && !flush),
	 	.sb_re(mem_mem_to_reg),
	 	.stall_dcache(stall_dcache),
		.hit_dtlb(hit_dtlb),
	 	.sb_hit(sb_hit_aux_in),
	 	.full_out(sb_full),
	 	.empty_out(sb_empty),
	 	.addr_out(sb_addr_out_aux_in),
	 	.data_out(sb_data_out_aux_in),
	 	.is_byte_out(sb_is_byte_aux_in),
	 	.drain_out(sb_continue_drain_out),
	 	.is_data_to_cache(sb_data_to_cache_aux_in)
	);

	assign sb_addr_out = (was_stall_dcache) ? sb_addr_out_aux_out : sb_addr_out_aux_in;
	assign sb_data_out = (was_stall_dcache) ? sb_data_out_aux_out : sb_data_out_aux_in;
	assign sb_data_to_cache_out = (was_stall_dcache) ? sb_data_to_cache_aux_out : sb_data_to_cache_aux_in;
	assign sb_hit = (was_stall_dcache) ? sb_hit_aux_out : sb_hit_aux_in;
	assign sb_is_byte = (was_stall_dcache) ? sb_is_byte_aux_out : sb_is_byte_aux_in;
	
	assign mem_addr_m = (sb_data_to_cache_out) ? sb_addr_out : mem_reg_data;
	assign mem_data_wr = sb_data_out; // regb content
	assign mem_isbyte = mem_mem_to_reg ? mem_is_byte : sb_is_byte;
	assign mem_wrd = sb_data_to_cache_out;
	wire[31:0] data_from_mem = (sb_hit) ? sb_data_out : mem_data_rd_m;

	wire[31:0] mem_exc_code_in = ( (mem_mem_to_reg || mem_wrd || (mem_mem_we && !hit_dtlb)) && !hit_dtlb && !privilege_mode) ? `EXC_DTLB_MISS : 0;

	assign read_interactive_req = (mem_io_code == `FUNCT7_IO_READ_SW);
	assign mem_stall_read_sw = read_interactive_req && !is_read_interactive_enabled;


	// WB stage

	wire[31:0] wb_mem_data;
	wire wb_mem_to_reg;
	wire mem_flush = (stall_dcache && hit_dtlb) | is_exception;

	MEM_WB MEM_WB(.clk(clk), .flush(mem_flush), .stall(stall_print), .reg_dest_in(mem_reg_addr_dest), .reg_write_enable_in(mem_reg_write_enable), .reg_data_alu_in(mem_reg_data),  .io_code_in(mem_io_code), .read_interactive_value_in(read_interactive_value), .is_read_interactive_enabled_in(is_read_interactive_enabled),
	.mem_data_in(data_from_mem), .mem_to_reg_in(mem_mem_to_reg), .rm0_in(mem_rm0), .rm1_in(mem_rm1), .rm2_in(mem_rm2), .psw_in(mem_PSW), .is_iret_in(mem_is_iret), .is_ecall_in(mem_is_ecall), .stored_rm4_in(mem_current_rm4),
	.is_hit_dtlb_in(hit_dtlb), .is_hit_itlb_in(mem_hit_itlb), .exc_code_in(mem_exc_code_in), .mem_addr_in(mem_addr_m), .pc_in(mem_pc), .is_flush_in(1'b0), .is_mov_in(mem_is_mov),
	.reg_dest_out(wb_addr_d_from_mem), .reg_data_alu_out(wb_alu_res), .reg_write_enable_out(wb_reg_write_enable_from_mem), .mem_data_out(wb_mem_data), .io_code_out(wb_io_code),
	.mem_to_reg_out(wb_mem_to_reg), .rm0_out(wb_rm0), .rm1_out(wb_rm1), .rm2_out(wb_rm2), .is_iret_out(wb_is_iret), .is_hit_dtlb_out(wb_hit_dtlb),  .is_mov_out(wb_is_mov),
	.is_hit_itlb_out(wb_hit_itlb), .pc_out(wb_pc), .is_flush_out(wb_is_flush), .stored_rm4_out(wb_current_rm4), .read_interactive_value_out(wb_read_interactive_value), .is_read_interactive_enabled_out(wb_read_interactive_enable));

	assign wb_data_to_reg_from_mem = (wb_mem_to_reg > 0) ? wb_mem_data : wb_alu_res;

	assign wb_reg_write_enable = (wb_read_interactive_enable  ? 1'b0 : wb_reg_write_enable_from_mem );
	assign wb_data_to_reg = (wb_read_interactive_enable ? wb_read_interactive_value : wb_data_to_reg_from_mem);
	assign wb_addr_d = wb_addr_d_from_mem;

	assign print_output = wb_current_rm4;
	assign print_hex_enable = (wb_io_code == `FUNCT7_IO_PRINT_HEX);
	assign stall_print = !is_print_done;	

	assign wb_or_hf_addr_to_reg = wb_addr_d;
	assign wb_or_hf_data_to_reg = wb_data_to_reg;
	assign wb_or_hf_reg_write_enable = wb_reg_write_enable;

	assign is_exception_reached = (wb_rm2 > 0 && !is_branch_or_jump_taken_wire);

	assign wb_or_hf_rm0 = wb_rm0;
	assign wb_or_hf_rm1 = wb_rm1;
	assign wb_or_hf_rm2 = wb_rm2;

endmodule
