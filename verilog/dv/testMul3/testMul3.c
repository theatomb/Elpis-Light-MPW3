/*
 * SPDX-FileCopyrightText: 2020 Efabless Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 */

// This include is relative to $CARAVEL_PATH (see Makefile)
#include "verilog/dv/caravel/defs.h"
#include "verilog/dv/caravel/stub.c"


void elpis_load_memory(uint32_t*  program_data, uint32_t*  program_addr)
{
	int i, continue_reading;
	continue_reading = 1;
	i = 0;
	reg_la3_data = 0x00000004;
	reg_la3_data = 0x00000005;
	reg_la3_data = 0x00000004;
	while (continue_reading)
	{
		if (program_data[i] == ((uint32_t) 0xFFFFFFFF))
		{
			continue_reading = 0;
		}else {
			reg_la0_data = program_addr[i];
			reg_la1_data = program_data[i];
		}
		reg_la3_data = 0x00000005;
		reg_la3_data = 0x00000004;
		i++;
	}
	reg_la3_data = 0x00000001;
	reg_la3_data = 0x00000000;
}

// --------------------------------------------------------

/*
	MPRJ Logic Analyzer Test:
		- Observes counter value through LA probes [31:0] 
		- Sets counter initial value through LA probes [63:32]
		- Flags when counter value exceeds 500 through the management SoC gpio
		- Outputs message to the UART when the test concludes successfuly
*/
void main()
{

	/* Set up the housekeeping SPI to be connected internally so	*/
	/* that external pin changes don't affect it.			*/

	reg_spimaster_config = 0xa002; // Enable, prescaler = 2,
								   // connect to housekeeping SPI

	// Connect the housekeeping SPI to the SPI master
	// so that the CSB line is not left floating.  This allows
	// all of the GPIO pins to be used for user functions.

	// The upper GPIO pins are configured to be output
	// and accessble to the management SoC.
	// Used to flad the start/end of a test
	// The lower GPIO pins are configured to be output
	// and accessible to the user project.  They show
	// the project count value, although this test is
	// designed to read the project count through the
	// logic analyzer probes.
	// I/O 6 is configured for the UART Tx line

	reg_mprj_io_31 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_30 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_29 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_28 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_27 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_26 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_25 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_24 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_23 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_22 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_21 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_20 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_19 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_18 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_17 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_16 = GPIO_MODE_USER_STD_OUTPUT;

	reg_mprj_io_15 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_14 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_13 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_12 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_11 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_10 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_9 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_8 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_7 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_5 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_4 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_3 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_2 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_1 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_0 = GPIO_MODE_USER_STD_OUTPUT;

	reg_mprj_io_6 = GPIO_MODE_MGMT_STD_OUTPUT;

	// Set UART clock to 64 kbaud (enable before I/O configuration)
	reg_uart_clkdiv = 625;
	reg_uart_enable = 1;

	/* Apply configuration */
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);

	// Configuring LA probes
	// outputs from the cpu are inputs for my project denoted for been 0
	// inputs to the cpu are outpus for my project denoted for been 1
	reg_la0_oenb = reg_la0_iena = 0x00000000; // [31:0]
	reg_la1_oenb = reg_la1_iena = 0x00000000; // [63:32]
	reg_la2_oenb = reg_la2_iena = 0x00000000; // [95:64]
	reg_la3_oenb = reg_la3_iena = 0x00000000; // [127:96]

	// Flag start of the test
	reg_mprj_datal = 0xAB400000;

	// Elpis OS information
	uint32_t OS_DATA[30];
	OS_DATA[0] = 0x00502023;
	OS_DATA[1] = 0x00602223;
	OS_DATA[2] = 0x00702423;
	OS_DATA[3] = 0x00802623;
	OS_DATA[4] = 0x00902823;
	OS_DATA[5] = 0x00400413;
	OS_DATA[6] = 0x00500493;
	OS_DATA[7] = 0x00600293;
	OS_DATA[8] = 0x00700313;
	OS_DATA[9] = 0x002003af;
	OS_DATA[10] = 0x00838c63;
	OS_DATA[11] = 0x00938a63;
	OS_DATA[12] = 0x00538c63;
	OS_DATA[13] = 0x00638e63;
	OS_DATA[14] = 0x00038e63;
	OS_DATA[15] = 0x02000863;
	OS_DATA[16] = 0x0000002e;
	OS_DATA[17] = 0x00000863;
	OS_DATA[18] = 0x0200007D;
	OS_DATA[19] = 0x00000463;
	OS_DATA[20] = 0x0400007D;
	OS_DATA[21] = 0x00002283;
	OS_DATA[22] = 0x00402303;
	OS_DATA[23] = 0x00802383;
	OS_DATA[24] = 0x00c02403;
	OS_DATA[25] = 0x01002483;
	OS_DATA[26] = 0x0000007F;
	OS_DATA[27] = 0x00000033;
	OS_DATA[28] = 0x00002050;
	OS_DATA[29] = 0xFFFFFFFF;

	uint32_t OS_ADDR[30];
	OS_ADDR[0] =  0x00000010;
	OS_ADDR[1] =  0x00000011;
	OS_ADDR[2] =  0x00000012;
	OS_ADDR[3] =  0x00000013;
	OS_ADDR[4] =  0x00000014;
	OS_ADDR[5] =  0x00000015;
	OS_ADDR[6] =  0x00000016;
	OS_ADDR[7] =  0x00000017;
	OS_ADDR[8] =  0x00000018;
	OS_ADDR[9] =  0x00000019;
	OS_ADDR[10] = 0x0000001a;
	OS_ADDR[11] = 0x0000001b;
	OS_ADDR[12] = 0x0000001c;
	OS_ADDR[13] = 0x0000001d;
	OS_ADDR[14] = 0x0000001e;
	OS_ADDR[15] = 0x0000001f;
	OS_ADDR[16] = 0x00000020;
	OS_ADDR[17] = 0x00000021;
	OS_ADDR[18] = 0x00000022;
	OS_ADDR[19] = 0x00000023;
	OS_ADDR[20] = 0x00000024;
	OS_ADDR[21] = 0x00000025;
	OS_ADDR[22] = 0x00000026;
	OS_ADDR[23] = 0x00000027;
	OS_ADDR[24] = 0x00000028;
	OS_ADDR[25] = 0x00000029;
	OS_ADDR[26] = 0x0000002a;
	OS_ADDR[27] = 0x0000002b;
	OS_ADDR[28] = 0x00000005;
	OS_ADDR[29] = 0xFFFFFFFF;

	// Elpis user program
	uint32_t USER_DATA[10];
	USER_DATA[0] = 0x00002083;
	USER_DATA[1] = 0x02108133;
	USER_DATA[2] = 0x001081B3;
	USER_DATA[3] = 0x00108233;
	USER_DATA[4] = 0x001082B3;
	USER_DATA[5] = 0x00108333;
	USER_DATA[6] = 0x001083B3;
	USER_DATA[7] = 0x00108433;
	USER_DATA[8] = 0x00000007;
	USER_DATA[9] = 0xFFFFFFFF;

	uint32_t USER_ADDR[10];
	USER_ADDR[0] = 0x00000040;
	USER_ADDR[1] = 0x00000041;
	USER_ADDR[2] = 0x00000042;
	USER_ADDR[3] = 0x00000043;
	USER_ADDR[4] = 0x00000044;
	USER_ADDR[5] = 0x00000045;
	USER_ADDR[6] = 0x00000046;
	USER_ADDR[7] = 0x00000047;
	USER_ADDR[8] = 0x00000100;
	USER_ADDR[9] = 0xFFFFFFFF;


	// Loading elpis memory
	elpis_load_memory(OS_DATA, OS_ADDR);
	elpis_load_memory(USER_DATA, USER_ADDR);
	
	reg_la3_oenb = reg_la3_iena = 0x00000001; // Recovering fast clock not controlled by the user

	// Reset of Elpis and start of computation at Elpis
	reg_la3_data = 0x00000002;
	reg_la3_data = 0x00000000;

	reg_mprj_datal = 0xAB410000;
	print("\n");
	print("Monitor: Test 1 Passed\n\n"); // Makes simulation very long!
	reg_mprj_datal = 0xAB510000;
}