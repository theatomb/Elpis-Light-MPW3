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

module controlunit(
	input rst,
	input[31:0] ir,
	output reg[3:0] op_alu,
	output reg wrd_reg,
	output reg[4:0] addr_d,
	output reg rb_immed,
	output reg[31:0] imm,
	output reg mem_to_reg,
	output reg wrd_mem,
	output reg[2:0] branch_code,
	output reg is_a_jump,
	output reg is_byte,
	output reg[1:0] is_mov,
	output reg[31:0] is_illegal,
	output reg is_tlbwrite,
	output reg is_iret,
	output reg is_ecall,
	output reg[6:0] io_code
);

	wire[3:0] alu_op;
	wire reg_we;
	wire[6:0] io_code_wire;
	wire[4:0] dest;
	wire rb_imm;
	wire[31:0] immed;
	wire MemToReg;
	wire mem_we;
	wire[2:0] branch_code_wire;
	wire is_a_jump_wire;
	wire is_a_byte;
	wire[1:0] is_a_mov;
	wire is_instr_illegal;
	wire is_a_tlbwrite, is_an_iret, is_a_mul, is_a_ecall;

	decoder decoder(
		.rst(rst),
		.instr(ir),
		.op_alu(alu_op),
		.wrd_reg(reg_we),
		.addr_d(dest),
		.rb_immed(rb_imm),
		.imm(immed),
		.mem_to_reg(MemToReg),
		.wrd_mem(mem_we),
		.branch_code(branch_code_wire),
		.is_a_jump(is_a_jump_wire),
		.is_byte(is_a_byte),
		.is_mov(is_a_mov),
		.is_illegal(is_instr_illegal),
		.is_tlbwrite(is_a_tlbwrite),
		.is_iret(is_an_iret),
		.is_ecall(is_a_ecall),
		.io_code(io_code_wire)
	);
	
	always@(*) begin
		op_alu = alu_op;
		wrd_reg = reg_we;
		addr_d = dest;
		rb_immed = rb_imm;
		imm = immed;
		mem_to_reg = MemToReg;
		wrd_mem = mem_we;
		branch_code = branch_code_wire;
		is_a_jump = is_a_jump_wire;
		is_byte = is_a_byte;
		is_mov = is_a_mov;
		is_illegal = (is_instr_illegal) ? `EXC_ILLEGAL_INST : 'b0;
		is_tlbwrite = is_a_tlbwrite;
		is_iret = is_an_iret;
		is_ecall = is_a_ecall;
		io_code = io_code_wire;
	end

endmodule