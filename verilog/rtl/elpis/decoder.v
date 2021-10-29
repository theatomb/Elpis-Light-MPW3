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

module decoder(
	input rst,
	input[31:0] instr,
	output reg[3:0] op_alu,
	output reg wrd_reg,
	output reg[4:0] addr_d,
	output reg rb_immed,		//rb (0) or immediate(1)
	output reg[31:0] imm,
	output reg mem_to_reg,
	output reg wrd_mem,
	output reg[2:0] branch_code,
	output reg is_a_jump,
	output reg is_byte,
	output reg[1:0] is_mov,
	output reg is_illegal,
	output reg is_tlbwrite,
	output reg is_iret,
	output reg is_ecall,
	output reg[6:0] io_code
);

	wire[6:0] opcode = instr[6:0];
	wire[4:0] reg_dest = instr[11:7];
	wire[2:0] funct3 = instr[14:12];
	wire[6:0] funct7 = instr[31:25];
	wire[4:0] shamt = instr[24:20];
	wire[11:0] ld_ali_immediate = instr[31:20];
	wire[11:0] st_immediate = {instr[31:25], instr[11:7]};
	wire[12:0] branch_inmediate = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
	wire[19:0] jump_inmediate = {instr[31:20], instr[14:7]};

	always@(*) begin
		wrd_reg = 0;
		wrd_mem = 0;
		rb_immed = 0;
		mem_to_reg = 0;
		branch_code = `FUNCT3_BRANCH_NO;
		is_a_jump = 0;
		is_byte = 0;
		is_mov = 0;
		is_illegal = 0;
		is_tlbwrite = 0;
		is_iret = 0;
		is_ecall = 0;
		io_code = 7'b0;
		op_alu = 0;
		imm = 32'b0;
		addr_d = 5'b0;
		case(opcode)
			`OPCODE_AL: begin
				case(funct3)
					`FUNCT3_OP_ADD_SUB: begin
						addr_d = reg_dest;
						if (instr != `NOP) begin
						  wrd_reg = 1;
						end
						case(funct7)
							`FUNCT7_OP_ADD: begin
								op_alu = `ALU_OP_ADD;
							end
							`FUNCT7_OP_SUB: begin
								op_alu = `ALU_OP_SUB;
							end
							default: begin
								is_illegal = 1;
								wrd_reg = 0;
							end
						endcase
					end
					`FUNCT3_OP_OR: begin
						addr_d = reg_dest;
						wrd_reg = 1;
						op_alu = `ALU_OP_OR;
					end
					`FUNCT3_OP_XOR: begin
						addr_d = reg_dest;
						wrd_reg = 1;
						op_alu = `ALU_OP_XOR;
					end
					`FUNCT3_OP_AND: begin
						addr_d = reg_dest;
						wrd_reg = 1;
						op_alu = `ALU_OP_AND;
					end
					`FUNCT3_OP_SLL: begin
						addr_d = reg_dest;
						wrd_reg = 1;
						op_alu = `ALU_OP_SLL;
					end
					`FUNCT3_OP_SRL_SRA: begin
						addr_d = reg_dest;
						wrd_reg = 1;
						case(funct7) 
							`FUNCT7_OP_SRL: begin
								op_alu = `ALU_OP_SRL;
							end
							`FUNCT7_OP_SRA: begin
								op_alu = `ALU_OP_SRA;
							end
							default: begin
								wrd_reg = 0;
								is_illegal = 1;
							end
						endcase
					end
					default:
						is_illegal = 1;
				endcase
			end
			`OPCODE_ALI: begin
				rb_immed = 1;
				addr_d = reg_dest;
				wrd_reg = 1;
				case(funct3)
					`FUNCT3_OP_ADD_SUB: begin
						imm = $signed(ld_ali_immediate);
						op_alu = `ALU_OP_ADD;
					end
					`FUNCT3_OP_OR: begin
						imm = $signed(ld_ali_immediate);
						op_alu = `ALU_OP_OR;
					end
					`FUNCT3_OP_XOR: begin
						imm = $signed(ld_ali_immediate);
						op_alu = `ALU_OP_XOR;
					end
					`FUNCT3_OP_AND: begin
						imm = $signed(ld_ali_immediate);
						op_alu = `ALU_OP_AND;
					end
					`FUNCT3_OP_SLL: begin
						imm = $signed(shamt);
						op_alu = `ALU_OP_SLL;
					end
					`FUNCT3_OP_SRL_SRA: begin
						imm = $signed(shamt);
						case(funct7) 
							`FUNCT7_OP_SRL: begin
								op_alu = `ALU_OP_SRL;
							end
							`FUNCT7_OP_SRA: begin
								op_alu = `ALU_OP_SRA;
							end
							default: begin
								wrd_reg = 0;
								is_illegal = 1;
							end
						endcase
					end
					default: begin
						is_illegal = 1;
						wrd_reg = 0;
					end
				endcase
			end
			`OPCODE_LD: begin
				wrd_reg = 1;
				mem_to_reg = 1;
				rb_immed = 1;
				op_alu = `ALU_OP_ADD;
				addr_d = reg_dest;
				imm = $signed(ld_ali_immediate);
				case (funct3)
				  `FUNCT3_OP_LB:
				   	is_byte = 1;
				  `FUNCT3_OP_LW: begin
					is_byte = 0;
				   end
				  default:
					is_illegal = 1;
				endcase
			end
			`OPCODE_ST: begin
				wrd_mem = 1;
				rb_immed = 1;
				op_alu = `ALU_OP_ADD;
				imm = $signed(st_immediate);
				case (funct3)
					`FUNCT3_OP_SB:
						is_byte = 1;
					`FUNCT3_OP_SW: begin

				  	end
					default:
						is_illegal = 1;
				endcase
			end
			`OPCODE_BRANCH: begin
				op_alu = `ALU_OP_BRANCH;
				rb_immed = 1;
				imm = $signed(branch_inmediate);
				branch_code = funct3;
				case(funct3)
					`FUNCT3_BRANCH_BEQ: begin

					end
					`FUNCT3_BRANCH_BNE: begin

					end
					`FUNCT3_BRANCH_BLT: begin

					end
					`FUNCT3_BRANCH_BGE: begin
						
					end
					default:
						is_illegal = 1;
				endcase
			end
			`OPCODE_JUMP: begin
				is_a_jump = 1;
				op_alu = `ALU_OP_BRANCH;
				rb_immed = 1;
				imm = $signed(jump_inmediate);
			end
			`OPCODE_MOV: begin
				op_alu = `ALU_OP_ADD;
				addr_d = reg_dest;
				case(funct7)
					`FUNCT7_MOV_RM_TO_REGULAR: begin
						wrd_reg = 1;
						is_mov = `MOV_RM_TO_REGULAR; 
					end
					`FUNCT7_MOV_REGULAR_TO_RM: begin
						is_mov = `MOV_REGULAR_TO_RM;
					end
					default:
						is_illegal = 1;
				endcase
			end
			`OPCODE_TLBWRITE: begin
				op_alu = `ALU_OP_ADD;
				is_tlbwrite = 1;
			end
			`OPCODE_IRET: begin
				is_a_jump = 1;
				is_iret = 1;
				op_alu = `ALU_OP_ADD;
			end
			`OPCODE_ECALL: begin
				imm = $signed(ld_ali_immediate);
				rb_immed = 1;
				is_ecall = 1;
				op_alu = `ALU_OP_ADD;
			end
			`OPCODE_IO: begin
				wrd_reg = 0;
				case(funct7)
					`FUNCT7_IO_PRINT_HEX: begin
						io_code = `FUNCT7_IO_PRINT_HEX;
					end
					`FUNCT7_IO_READ_SW: begin
						io_code = `FUNCT7_IO_READ_SW;
					end
					default:
						is_illegal = 1;
				endcase
			end
			default: 
				if (rst) is_illegal = 0;
				else is_illegal = 1;
		endcase
	end
	
endmodule
