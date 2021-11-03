
// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`timescale 1 ns / 1 ps

`include "uprj_netlists.v"
`include "caravel_netlists.v"
`include "spiflash.v"
`include "tbuart.v"

module testOut_tb;
	reg clock;
    reg RSTB;
	reg CSB;

	reg power1, power2;

    wire gpio;
	wire uart_tx;
    wire [37:0] mprj_io;
	wire [15:0] checkbits;

	assign checkbits  = mprj_io[31:16];
	assign uart_tx = mprj_io[6];

	always #12.5 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;

	initial begin
		$dumpfile("testOut.vcd");
		$dumpvars(0, testOut_tb);
		// TIP. Increase the first repeat number until it is needed
		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (100) begin
			repeat (1000) @(posedge clock);
			// $display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		`ifdef GL
			$display ("Monitor: Timeout, Test LA (GL) Failed");
		`else
			$display ("Monitor: Timeout, Test LA (RTL) Failed");
		`endif
		$display("%c[0m",27);
		$finish;
	end

	initial begin

		// TIP. replace to something like wait(testOut_tb.uut.mprj.core.datapath.regfile.registers[3]=='h5);
		//wait(mprj_io[24:20] == 5'b00000);
		$display("LA Test 1 started");
		//wait(mprj_io[24:20] == 5'b00010);
		//wait(mprj_io[24:20] == 5'b00001);
		wait(testOut_tb.uut.mprj.core0.datapath.regfile.registers[3] == 3);
		$display("LA Test 1 Finish correctly");
		//wait(checkbits == 16'h0002);
		#10000;
		$finish;
	end

	// TIP. Dumping of first 32 memory addresses. Do something similar with 
	integer i_mem;
	initial begin
    	for (i_mem = 0; i_mem < 512; i_mem = i_mem + 1) begin
			$dumpvars(0, testOut_tb.uut.mprj.custom_sram.mem[i_mem]);
		end
   	end

	integer i_reg;
	initial begin
    	for (i_reg = 0; i_reg < 32; i_reg = i_reg + 1) begin
			$dumpvars(0, testOut_tb.uut.mprj.core0.datapath.regfile.registers[i_reg]);
		end
   	end
	// initial begin
	// 	$dumpvars(0, testOut_tb.uut.mprj.core0.datapath.regfile.registers[3]);
	// end

	initial begin
		RSTB <= 1'b0;
		CSB  <= 1'b1;		// Force CSB high
		#2000;
		RSTB <= 1'b1;	    	// Release reset
		#170000;
		CSB = 1'b0;		// CSB can be released
	end

	initial begin		// Power-up sequence
		power1 <= 1'b0;
		power2 <= 1'b0;
		#200;
		power1 <= 1'b1;
		#200;
		power2 <= 1'b1;
	end

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	wire VDD1V8;
	wire VDD3V3;
	wire VSS;
    
	assign VDD3V3 = power1;
	assign VDD1V8 = power2;
	assign VSS = 1'b0;

	caravel uut (
		.vddio	  (VDD3V3),
		.vssio	  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (VDD3V3),
		.vdda2    (VDD3V3),
		.vssa1	  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (VDD1V8),
		.vccd2	  (VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock	  (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("testOut.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

	// Testbench UART
	tbuart tbuart (
		.ser_rx(uart_tx)
	);

endmodule
`default_nettype wire