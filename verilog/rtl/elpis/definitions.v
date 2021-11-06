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


// NOP defined as: add $0,$0,$0
`define NOP 32'h00000033

// PC Initial direction
`define PC_INITIAL 32'h00000000

// PC Exceptions
`define PC_EXCEPTIONS 32'h00000040

// ALU Opcodes
`define ALU_OP_ADD 			4'b0000
`define ALU_OP_SUB 			4'b0001
`define ALU_OP_BRANCH 		4'b0010
`define ALU_OP_AND 			4'b0011
`define ALU_OP_OR 			4'b0100
`define ALU_OP_XOR 			4'b0101
`define ALU_OP_SRA 			4'b0110
`define ALU_OP_SRL 			4'b0111
`define ALU_OP_SLL 			4'b1000
`define ALU_OP_MUL 			4'b1001


// Decode constants for move instructions
`define MOV_RM_TO_REGULAR	2'b01
`define MOV_REGULAR_TO_RM	2'b10

// Instruction opcode RISC-V
`define OPCODE_AL     	7'b0110011
`define OPCODE_ALI     	7'b0010011
`define OPCODE_LD     	7'b0000011
`define OPCODE_ST     	7'b0100011
`define OPCODE_JUMP   	7'b1101111	// JAL encoding of RISCV but used as jump in ppt. Ex: jump x3
`define OPCODE_BRANCH 	7'b1100011
`define OPCODE_MOV    	7'b0101111
`define OPCODE_TLBWRITE	7'b0101110
`define OPCODE_IRET		7'b1111111
`define OPCODE_IO		7'b1111101
`define OPCODE_ECALL	7'b1110011 // "ECALL" encoding. It uses inmediates for the system behavior.


// FUNCT3 for RISC-V instructions opcode
`define FUNCT3_OP_ADD_SUB	3'b000
`define FUNCT3_OP_SLL		3'b001
`define FUNCT3_OP_XOR		3'b100
`define FUNCT3_OP_SRL_SRA	3'b101
`define FUNCT3_OP_OR		3'b110
`define FUNCT3_OP_AND		3'b111

`define FUNCT3_OP_LB		3'b000
`define FUNCT3_OP_LH		3'b001
`define FUNCT3_OP_LW		3'b010
`define FUNCT3_OP_SB		3'b000
`define FUNCT3_OP_SH		3'b001
`define FUNCT3_OP_SW		3'b010

`define FUNCT3_BRANCH_BEQ	3'b000
`define FUNCT3_BRANCH_BNE	3'b001
`define FUNCT3_BRANCH_BLT	3'b100
`define FUNCT3_BRANCH_BGE	3'b101
`define FUNCT3_BRANCH_NO	3'b111

// FUNCT7 for RISC-V instructions opcode
`define FUNCT7_OP_ADD	7'b0000000
`define FUNCT7_OP_SUB	7'b0100000
`define FUNCT7_OP_MUL	7'b0000001
`define FUNCT7_OP_SRL	7'b0000000
`define FUNCT7_OP_SRA	7'b0100000

// FUNCT7 for move instructions
`define FUNCT7_MOV_RM_TO_REGULAR	7'b0000000
`define FUNCT7_MOV_REGULAR_TO_RM	7'b0000001

// FUNCT7 for IO instructions
`define FUNCT7_IO_PRINT_HEX	7'b0000001
`define FUNCT7_IO_READ_SW	7'b0000010

// Constants for memory
`define MEMORY_DELAY_CYCLES	5
`define MEMORY_SIZE			512  	// 2^20 - 2^5 = 2^15.

// Constants for cache
`define CACHE_LINE_SIZE		128
`define NUM_CACHE_LINES		4
`define CACHE_TAG_SIZE		26
`define IDLE_STATE			3'b000
`define ALLOCATE_STATE		3'b001
`define WRITE_BACK_STATE	3'b010

// Constants for arbiter
`define ARB_IDLE_STATE       	3'b000
`define ARB_DCACHE_REQUEST   	3'b001
`define ARB_ICACHE_REQUEST   	3'b010
`define ARB_DCACHE_WAIT   		3'b011
`define ARB_ICACHE_WAIT   		3'b100

// Constants for IO arbiter
`define ARB_IO_IDLE_STATE	2'b00
`define ARB_IO_CORE1_USE	2'b01

// Exception codes
`define EXC_OVERFLOW		3'b001
`define EXC_UNDERFLOW		3'b010
`define EXC_ILLEGAL_INST	3'b011
`define EXC_ITLB_MISS		3'b100
`define EXC_DTLB_MISS		3'b101

// IO codes
`define IO_PRINT_HEX		3'b110
`define IO_READ_SW			3'b111

// Constants for store buffer
`define SB_NUM_ENTRIES  3'd4

// Cache types
`define CACHE_TYPE_DCACHE 1'b0
`define CACHE_TYPE_ICACHE 1'b1

// Offset of data space at OS
`define OFFSET_OS_DATA_CORE0 8'h00

// Constants for TLB
`define ITLB_BASE_ADDRESS_SHIFT_CORE0  	16'h100	// 256 -> 64
`define DTLB_BASE_ADDRESS_SHIFT_CORE0  	16'h400	// 1024 -> 256
`define NUM_TLB_LINES           		5'd16

// Constants for History File
`define HF_NUM_ENTRIES    5'd16

// Constants for FIFO coherence response states
`define FIFO_COH_NOT_SENT		2'b00
`define FIFO_COH_FIRST_SENT		2'b01
`define FIFO_COH_COMPLETE_SENT	2'b10

// Implementation of ceiling log2 
`define CLOG2(x) \
	((x <= 0)		? -1 : \
	(x == 1)		? 0 : \
	(x <= 2) 		? 1 : \
	(x <= 4) 		? 2 : \
	(x <= 8) 		? 3 : \
	(x <= 16) 		? 4 : \
	(x <= 32)		? 5 : \
	(x <= 64)		? 6 : \
	(x <= 128)		? 7 : \
	(x <= 256)		? 8 : \
	(x <= 512)		? 9 : \
	(x <= 1024)		? 10 : \
	(x <= 2048)		? 11 : \
	(x <= 4096)		? 12 : \
	(x <= 8192)		? 13 : )
