module user_project_wrapper (user_clock2,
    vccd1,
    vccd2,
    vdda1,
    vdda2,
    vssa1,
    vssa2,
    vssd1,
    vssd2,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
    analog_io,
    io_in,
    io_oeb,
    io_out,
    la_data_in,
    la_data_out,
    la_oenb,
    user_irq,
    wbs_adr_i,
    wbs_dat_i,
    wbs_dat_o,
    wbs_sel_i);
 input user_clock2;
 input vccd1;
 input vccd2;
 input vdda1;
 input vdda2;
 input vssa1;
 input vssa2;
 input vssd1;
 input vssd2;
 input wb_clk_i;
 input wb_rst_i;
 output wbs_ack_o;
 input wbs_cyc_i;
 input wbs_stb_i;
 input wbs_we_i;
 inout [28:0] analog_io;
 input [37:0] io_in;
 output [37:0] io_oeb;
 output [37:0] io_out;
 input [127:0] la_data_in;
 output [127:0] la_data_out;
 input [127:0] la_oenb;
 output [2:0] user_irq;
 input [31:0] wbs_adr_i;
 input [31:0] wbs_dat_i;
 output [31:0] wbs_dat_o;
 input [3:0] wbs_sel_i;

 wire \addr0_to_sram[0] ;
 wire \addr0_to_sram[10] ;
 wire \addr0_to_sram[11] ;
 wire \addr0_to_sram[12] ;
 wire \addr0_to_sram[13] ;
 wire \addr0_to_sram[14] ;
 wire \addr0_to_sram[15] ;
 wire \addr0_to_sram[16] ;
 wire \addr0_to_sram[17] ;
 wire \addr0_to_sram[18] ;
 wire \addr0_to_sram[19] ;
 wire \addr0_to_sram[1] ;
 wire \addr0_to_sram[2] ;
 wire \addr0_to_sram[3] ;
 wire \addr0_to_sram[4] ;
 wire \addr0_to_sram[5] ;
 wire \addr0_to_sram[6] ;
 wire \addr0_to_sram[7] ;
 wire \addr0_to_sram[8] ;
 wire \addr0_to_sram[9] ;
 wire \addr_to_core_mem[0] ;
 wire \addr_to_core_mem[10] ;
 wire \addr_to_core_mem[11] ;
 wire \addr_to_core_mem[12] ;
 wire \addr_to_core_mem[13] ;
 wire \addr_to_core_mem[14] ;
 wire \addr_to_core_mem[15] ;
 wire \addr_to_core_mem[16] ;
 wire \addr_to_core_mem[17] ;
 wire \addr_to_core_mem[18] ;
 wire \addr_to_core_mem[19] ;
 wire \addr_to_core_mem[1] ;
 wire \addr_to_core_mem[2] ;
 wire \addr_to_core_mem[3] ;
 wire \addr_to_core_mem[4] ;
 wire \addr_to_core_mem[5] ;
 wire \addr_to_core_mem[6] ;
 wire \addr_to_core_mem[7] ;
 wire \addr_to_core_mem[8] ;
 wire \addr_to_core_mem[9] ;
 wire clk;
 wire \core0_data_print[0] ;
 wire \core0_data_print[10] ;
 wire \core0_data_print[11] ;
 wire \core0_data_print[12] ;
 wire \core0_data_print[13] ;
 wire \core0_data_print[14] ;
 wire \core0_data_print[15] ;
 wire \core0_data_print[16] ;
 wire \core0_data_print[17] ;
 wire \core0_data_print[18] ;
 wire \core0_data_print[19] ;
 wire \core0_data_print[1] ;
 wire \core0_data_print[20] ;
 wire \core0_data_print[21] ;
 wire \core0_data_print[22] ;
 wire \core0_data_print[23] ;
 wire \core0_data_print[24] ;
 wire \core0_data_print[25] ;
 wire \core0_data_print[26] ;
 wire \core0_data_print[27] ;
 wire \core0_data_print[28] ;
 wire \core0_data_print[29] ;
 wire \core0_data_print[2] ;
 wire \core0_data_print[30] ;
 wire \core0_data_print[31] ;
 wire \core0_data_print[3] ;
 wire \core0_data_print[4] ;
 wire \core0_data_print[5] ;
 wire \core0_data_print[6] ;
 wire \core0_data_print[7] ;
 wire \core0_data_print[8] ;
 wire \core0_data_print[9] ;
 wire core0_is_mem_we;
 wire core0_need_reset_mem_req;
 wire \core0_to_mem_address[0] ;
 wire \core0_to_mem_address[10] ;
 wire \core0_to_mem_address[11] ;
 wire \core0_to_mem_address[12] ;
 wire \core0_to_mem_address[13] ;
 wire \core0_to_mem_address[14] ;
 wire \core0_to_mem_address[15] ;
 wire \core0_to_mem_address[16] ;
 wire \core0_to_mem_address[17] ;
 wire \core0_to_mem_address[18] ;
 wire \core0_to_mem_address[19] ;
 wire \core0_to_mem_address[1] ;
 wire \core0_to_mem_address[2] ;
 wire \core0_to_mem_address[3] ;
 wire \core0_to_mem_address[4] ;
 wire \core0_to_mem_address[5] ;
 wire \core0_to_mem_address[6] ;
 wire \core0_to_mem_address[7] ;
 wire \core0_to_mem_address[8] ;
 wire \core0_to_mem_address[9] ;
 wire \core0_to_mem_data[0] ;
 wire \core0_to_mem_data[100] ;
 wire \core0_to_mem_data[101] ;
 wire \core0_to_mem_data[102] ;
 wire \core0_to_mem_data[103] ;
 wire \core0_to_mem_data[104] ;
 wire \core0_to_mem_data[105] ;
 wire \core0_to_mem_data[106] ;
 wire \core0_to_mem_data[107] ;
 wire \core0_to_mem_data[108] ;
 wire \core0_to_mem_data[109] ;
 wire \core0_to_mem_data[10] ;
 wire \core0_to_mem_data[110] ;
 wire \core0_to_mem_data[111] ;
 wire \core0_to_mem_data[112] ;
 wire \core0_to_mem_data[113] ;
 wire \core0_to_mem_data[114] ;
 wire \core0_to_mem_data[115] ;
 wire \core0_to_mem_data[116] ;
 wire \core0_to_mem_data[117] ;
 wire \core0_to_mem_data[118] ;
 wire \core0_to_mem_data[119] ;
 wire \core0_to_mem_data[11] ;
 wire \core0_to_mem_data[120] ;
 wire \core0_to_mem_data[121] ;
 wire \core0_to_mem_data[122] ;
 wire \core0_to_mem_data[123] ;
 wire \core0_to_mem_data[124] ;
 wire \core0_to_mem_data[125] ;
 wire \core0_to_mem_data[126] ;
 wire \core0_to_mem_data[127] ;
 wire \core0_to_mem_data[12] ;
 wire \core0_to_mem_data[13] ;
 wire \core0_to_mem_data[14] ;
 wire \core0_to_mem_data[15] ;
 wire \core0_to_mem_data[16] ;
 wire \core0_to_mem_data[17] ;
 wire \core0_to_mem_data[18] ;
 wire \core0_to_mem_data[19] ;
 wire \core0_to_mem_data[1] ;
 wire \core0_to_mem_data[20] ;
 wire \core0_to_mem_data[21] ;
 wire \core0_to_mem_data[22] ;
 wire \core0_to_mem_data[23] ;
 wire \core0_to_mem_data[24] ;
 wire \core0_to_mem_data[25] ;
 wire \core0_to_mem_data[26] ;
 wire \core0_to_mem_data[27] ;
 wire \core0_to_mem_data[28] ;
 wire \core0_to_mem_data[29] ;
 wire \core0_to_mem_data[2] ;
 wire \core0_to_mem_data[30] ;
 wire \core0_to_mem_data[31] ;
 wire \core0_to_mem_data[32] ;
 wire \core0_to_mem_data[33] ;
 wire \core0_to_mem_data[34] ;
 wire \core0_to_mem_data[35] ;
 wire \core0_to_mem_data[36] ;
 wire \core0_to_mem_data[37] ;
 wire \core0_to_mem_data[38] ;
 wire \core0_to_mem_data[39] ;
 wire \core0_to_mem_data[3] ;
 wire \core0_to_mem_data[40] ;
 wire \core0_to_mem_data[41] ;
 wire \core0_to_mem_data[42] ;
 wire \core0_to_mem_data[43] ;
 wire \core0_to_mem_data[44] ;
 wire \core0_to_mem_data[45] ;
 wire \core0_to_mem_data[46] ;
 wire \core0_to_mem_data[47] ;
 wire \core0_to_mem_data[48] ;
 wire \core0_to_mem_data[49] ;
 wire \core0_to_mem_data[4] ;
 wire \core0_to_mem_data[50] ;
 wire \core0_to_mem_data[51] ;
 wire \core0_to_mem_data[52] ;
 wire \core0_to_mem_data[53] ;
 wire \core0_to_mem_data[54] ;
 wire \core0_to_mem_data[55] ;
 wire \core0_to_mem_data[56] ;
 wire \core0_to_mem_data[57] ;
 wire \core0_to_mem_data[58] ;
 wire \core0_to_mem_data[59] ;
 wire \core0_to_mem_data[5] ;
 wire \core0_to_mem_data[60] ;
 wire \core0_to_mem_data[61] ;
 wire \core0_to_mem_data[62] ;
 wire \core0_to_mem_data[63] ;
 wire \core0_to_mem_data[64] ;
 wire \core0_to_mem_data[65] ;
 wire \core0_to_mem_data[66] ;
 wire \core0_to_mem_data[67] ;
 wire \core0_to_mem_data[68] ;
 wire \core0_to_mem_data[69] ;
 wire \core0_to_mem_data[6] ;
 wire \core0_to_mem_data[70] ;
 wire \core0_to_mem_data[71] ;
 wire \core0_to_mem_data[72] ;
 wire \core0_to_mem_data[73] ;
 wire \core0_to_mem_data[74] ;
 wire \core0_to_mem_data[75] ;
 wire \core0_to_mem_data[76] ;
 wire \core0_to_mem_data[77] ;
 wire \core0_to_mem_data[78] ;
 wire \core0_to_mem_data[79] ;
 wire \core0_to_mem_data[7] ;
 wire \core0_to_mem_data[80] ;
 wire \core0_to_mem_data[81] ;
 wire \core0_to_mem_data[82] ;
 wire \core0_to_mem_data[83] ;
 wire \core0_to_mem_data[84] ;
 wire \core0_to_mem_data[85] ;
 wire \core0_to_mem_data[86] ;
 wire \core0_to_mem_data[87] ;
 wire \core0_to_mem_data[88] ;
 wire \core0_to_mem_data[89] ;
 wire \core0_to_mem_data[8] ;
 wire \core0_to_mem_data[90] ;
 wire \core0_to_mem_data[91] ;
 wire \core0_to_mem_data[92] ;
 wire \core0_to_mem_data[93] ;
 wire \core0_to_mem_data[94] ;
 wire \core0_to_mem_data[95] ;
 wire \core0_to_mem_data[96] ;
 wire \core0_to_mem_data[97] ;
 wire \core0_to_mem_data[98] ;
 wire \core0_to_mem_data[99] ;
 wire \core0_to_mem_data[9] ;
 wire csb0_to_sram;
 wire \data_out_to_core[0] ;
 wire \data_out_to_core[10] ;
 wire \data_out_to_core[11] ;
 wire \data_out_to_core[12] ;
 wire \data_out_to_core[13] ;
 wire \data_out_to_core[14] ;
 wire \data_out_to_core[15] ;
 wire \data_out_to_core[16] ;
 wire \data_out_to_core[17] ;
 wire \data_out_to_core[18] ;
 wire \data_out_to_core[19] ;
 wire \data_out_to_core[1] ;
 wire \data_out_to_core[20] ;
 wire \data_out_to_core[21] ;
 wire \data_out_to_core[22] ;
 wire \data_out_to_core[23] ;
 wire \data_out_to_core[24] ;
 wire \data_out_to_core[25] ;
 wire \data_out_to_core[26] ;
 wire \data_out_to_core[27] ;
 wire \data_out_to_core[28] ;
 wire \data_out_to_core[29] ;
 wire \data_out_to_core[2] ;
 wire \data_out_to_core[30] ;
 wire \data_out_to_core[31] ;
 wire \data_out_to_core[3] ;
 wire \data_out_to_core[4] ;
 wire \data_out_to_core[5] ;
 wire \data_out_to_core[6] ;
 wire \data_out_to_core[7] ;
 wire \data_out_to_core[8] ;
 wire \data_out_to_core[9] ;
 wire \data_to_core_mem[0] ;
 wire \data_to_core_mem[10] ;
 wire \data_to_core_mem[11] ;
 wire \data_to_core_mem[12] ;
 wire \data_to_core_mem[13] ;
 wire \data_to_core_mem[14] ;
 wire \data_to_core_mem[15] ;
 wire \data_to_core_mem[16] ;
 wire \data_to_core_mem[17] ;
 wire \data_to_core_mem[18] ;
 wire \data_to_core_mem[19] ;
 wire \data_to_core_mem[1] ;
 wire \data_to_core_mem[20] ;
 wire \data_to_core_mem[21] ;
 wire \data_to_core_mem[22] ;
 wire \data_to_core_mem[23] ;
 wire \data_to_core_mem[24] ;
 wire \data_to_core_mem[25] ;
 wire \data_to_core_mem[26] ;
 wire \data_to_core_mem[27] ;
 wire \data_to_core_mem[28] ;
 wire \data_to_core_mem[29] ;
 wire \data_to_core_mem[2] ;
 wire \data_to_core_mem[30] ;
 wire \data_to_core_mem[31] ;
 wire \data_to_core_mem[3] ;
 wire \data_to_core_mem[4] ;
 wire \data_to_core_mem[5] ;
 wire \data_to_core_mem[6] ;
 wire \data_to_core_mem[7] ;
 wire \data_to_core_mem[8] ;
 wire \data_to_core_mem[9] ;
 wire \din0_to_sram[0] ;
 wire \din0_to_sram[10] ;
 wire \din0_to_sram[11] ;
 wire \din0_to_sram[12] ;
 wire \din0_to_sram[13] ;
 wire \din0_to_sram[14] ;
 wire \din0_to_sram[15] ;
 wire \din0_to_sram[16] ;
 wire \din0_to_sram[17] ;
 wire \din0_to_sram[18] ;
 wire \din0_to_sram[19] ;
 wire \din0_to_sram[1] ;
 wire \din0_to_sram[20] ;
 wire \din0_to_sram[21] ;
 wire \din0_to_sram[22] ;
 wire \din0_to_sram[23] ;
 wire \din0_to_sram[24] ;
 wire \din0_to_sram[25] ;
 wire \din0_to_sram[26] ;
 wire \din0_to_sram[27] ;
 wire \din0_to_sram[28] ;
 wire \din0_to_sram[29] ;
 wire \din0_to_sram[2] ;
 wire \din0_to_sram[30] ;
 wire \din0_to_sram[31] ;
 wire \din0_to_sram[3] ;
 wire \din0_to_sram[4] ;
 wire \din0_to_sram[5] ;
 wire \din0_to_sram[6] ;
 wire \din0_to_sram[7] ;
 wire \din0_to_sram[8] ;
 wire \din0_to_sram[9] ;
 wire \dout0_to_sram[0] ;
 wire \dout0_to_sram[10] ;
 wire \dout0_to_sram[11] ;
 wire \dout0_to_sram[12] ;
 wire \dout0_to_sram[13] ;
 wire \dout0_to_sram[14] ;
 wire \dout0_to_sram[15] ;
 wire \dout0_to_sram[16] ;
 wire \dout0_to_sram[17] ;
 wire \dout0_to_sram[18] ;
 wire \dout0_to_sram[19] ;
 wire \dout0_to_sram[1] ;
 wire \dout0_to_sram[20] ;
 wire \dout0_to_sram[21] ;
 wire \dout0_to_sram[22] ;
 wire \dout0_to_sram[23] ;
 wire \dout0_to_sram[24] ;
 wire \dout0_to_sram[25] ;
 wire \dout0_to_sram[26] ;
 wire \dout0_to_sram[27] ;
 wire \dout0_to_sram[28] ;
 wire \dout0_to_sram[29] ;
 wire \dout0_to_sram[2] ;
 wire \dout0_to_sram[30] ;
 wire \dout0_to_sram[31] ;
 wire \dout0_to_sram[3] ;
 wire \dout0_to_sram[4] ;
 wire \dout0_to_sram[5] ;
 wire \dout0_to_sram[6] ;
 wire \dout0_to_sram[7] ;
 wire \dout0_to_sram[8] ;
 wire \dout0_to_sram[9] ;
 wire is_loading_memory_into_core;
 wire is_mem_ready;
 wire is_mem_req;
 wire is_ready_dataout_core0;
 wire is_ready_print_core0;
 wire \read_data_from_mem[0] ;
 wire \read_data_from_mem[100] ;
 wire \read_data_from_mem[101] ;
 wire \read_data_from_mem[102] ;
 wire \read_data_from_mem[103] ;
 wire \read_data_from_mem[104] ;
 wire \read_data_from_mem[105] ;
 wire \read_data_from_mem[106] ;
 wire \read_data_from_mem[107] ;
 wire \read_data_from_mem[108] ;
 wire \read_data_from_mem[109] ;
 wire \read_data_from_mem[10] ;
 wire \read_data_from_mem[110] ;
 wire \read_data_from_mem[111] ;
 wire \read_data_from_mem[112] ;
 wire \read_data_from_mem[113] ;
 wire \read_data_from_mem[114] ;
 wire \read_data_from_mem[115] ;
 wire \read_data_from_mem[116] ;
 wire \read_data_from_mem[117] ;
 wire \read_data_from_mem[118] ;
 wire \read_data_from_mem[119] ;
 wire \read_data_from_mem[11] ;
 wire \read_data_from_mem[120] ;
 wire \read_data_from_mem[121] ;
 wire \read_data_from_mem[122] ;
 wire \read_data_from_mem[123] ;
 wire \read_data_from_mem[124] ;
 wire \read_data_from_mem[125] ;
 wire \read_data_from_mem[126] ;
 wire \read_data_from_mem[127] ;
 wire \read_data_from_mem[12] ;
 wire \read_data_from_mem[13] ;
 wire \read_data_from_mem[14] ;
 wire \read_data_from_mem[15] ;
 wire \read_data_from_mem[16] ;
 wire \read_data_from_mem[17] ;
 wire \read_data_from_mem[18] ;
 wire \read_data_from_mem[19] ;
 wire \read_data_from_mem[1] ;
 wire \read_data_from_mem[20] ;
 wire \read_data_from_mem[21] ;
 wire \read_data_from_mem[22] ;
 wire \read_data_from_mem[23] ;
 wire \read_data_from_mem[24] ;
 wire \read_data_from_mem[25] ;
 wire \read_data_from_mem[26] ;
 wire \read_data_from_mem[27] ;
 wire \read_data_from_mem[28] ;
 wire \read_data_from_mem[29] ;
 wire \read_data_from_mem[2] ;
 wire \read_data_from_mem[30] ;
 wire \read_data_from_mem[31] ;
 wire \read_data_from_mem[32] ;
 wire \read_data_from_mem[33] ;
 wire \read_data_from_mem[34] ;
 wire \read_data_from_mem[35] ;
 wire \read_data_from_mem[36] ;
 wire \read_data_from_mem[37] ;
 wire \read_data_from_mem[38] ;
 wire \read_data_from_mem[39] ;
 wire \read_data_from_mem[3] ;
 wire \read_data_from_mem[40] ;
 wire \read_data_from_mem[41] ;
 wire \read_data_from_mem[42] ;
 wire \read_data_from_mem[43] ;
 wire \read_data_from_mem[44] ;
 wire \read_data_from_mem[45] ;
 wire \read_data_from_mem[46] ;
 wire \read_data_from_mem[47] ;
 wire \read_data_from_mem[48] ;
 wire \read_data_from_mem[49] ;
 wire \read_data_from_mem[4] ;
 wire \read_data_from_mem[50] ;
 wire \read_data_from_mem[51] ;
 wire \read_data_from_mem[52] ;
 wire \read_data_from_mem[53] ;
 wire \read_data_from_mem[54] ;
 wire \read_data_from_mem[55] ;
 wire \read_data_from_mem[56] ;
 wire \read_data_from_mem[57] ;
 wire \read_data_from_mem[58] ;
 wire \read_data_from_mem[59] ;
 wire \read_data_from_mem[5] ;
 wire \read_data_from_mem[60] ;
 wire \read_data_from_mem[61] ;
 wire \read_data_from_mem[62] ;
 wire \read_data_from_mem[63] ;
 wire \read_data_from_mem[64] ;
 wire \read_data_from_mem[65] ;
 wire \read_data_from_mem[66] ;
 wire \read_data_from_mem[67] ;
 wire \read_data_from_mem[68] ;
 wire \read_data_from_mem[69] ;
 wire \read_data_from_mem[6] ;
 wire \read_data_from_mem[70] ;
 wire \read_data_from_mem[71] ;
 wire \read_data_from_mem[72] ;
 wire \read_data_from_mem[73] ;
 wire \read_data_from_mem[74] ;
 wire \read_data_from_mem[75] ;
 wire \read_data_from_mem[76] ;
 wire \read_data_from_mem[77] ;
 wire \read_data_from_mem[78] ;
 wire \read_data_from_mem[79] ;
 wire \read_data_from_mem[7] ;
 wire \read_data_from_mem[80] ;
 wire \read_data_from_mem[81] ;
 wire \read_data_from_mem[82] ;
 wire \read_data_from_mem[83] ;
 wire \read_data_from_mem[84] ;
 wire \read_data_from_mem[85] ;
 wire \read_data_from_mem[86] ;
 wire \read_data_from_mem[87] ;
 wire \read_data_from_mem[88] ;
 wire \read_data_from_mem[89] ;
 wire \read_data_from_mem[8] ;
 wire \read_data_from_mem[90] ;
 wire \read_data_from_mem[91] ;
 wire \read_data_from_mem[92] ;
 wire \read_data_from_mem[93] ;
 wire \read_data_from_mem[94] ;
 wire \read_data_from_mem[95] ;
 wire \read_data_from_mem[96] ;
 wire \read_data_from_mem[97] ;
 wire \read_data_from_mem[98] ;
 wire \read_data_from_mem[99] ;
 wire \read_data_from_mem[9] ;
 wire read_enable_to_Elpis;
 wire read_interactive_req_core0;
 wire \read_value_to_Elpis[0] ;
 wire \read_value_to_Elpis[10] ;
 wire \read_value_to_Elpis[11] ;
 wire \read_value_to_Elpis[12] ;
 wire \read_value_to_Elpis[13] ;
 wire \read_value_to_Elpis[14] ;
 wire \read_value_to_Elpis[15] ;
 wire \read_value_to_Elpis[16] ;
 wire \read_value_to_Elpis[17] ;
 wire \read_value_to_Elpis[18] ;
 wire \read_value_to_Elpis[19] ;
 wire \read_value_to_Elpis[1] ;
 wire \read_value_to_Elpis[20] ;
 wire \read_value_to_Elpis[21] ;
 wire \read_value_to_Elpis[22] ;
 wire \read_value_to_Elpis[23] ;
 wire \read_value_to_Elpis[24] ;
 wire \read_value_to_Elpis[25] ;
 wire \read_value_to_Elpis[26] ;
 wire \read_value_to_Elpis[27] ;
 wire \read_value_to_Elpis[28] ;
 wire \read_value_to_Elpis[29] ;
 wire \read_value_to_Elpis[2] ;
 wire \read_value_to_Elpis[30] ;
 wire \read_value_to_Elpis[31] ;
 wire \read_value_to_Elpis[3] ;
 wire \read_value_to_Elpis[4] ;
 wire \read_value_to_Elpis[5] ;
 wire \read_value_to_Elpis[6] ;
 wire \read_value_to_Elpis[7] ;
 wire \read_value_to_Elpis[8] ;
 wire \read_value_to_Elpis[9] ;
 wire req_out_core0;
 wire reset_core;
 wire rst;
 wire spare_wen0_to_sram;
 wire we_to_sram;

 chip_controller chip_controller (.clk(clk),
    .csb0_to_sram(csb0_to_sram),
    .is_loading_memory_into_core(is_loading_memory_into_core),
    .is_ready_dataout_core0(is_ready_dataout_core0),
    .is_ready_print_core0(is_ready_print_core0),
    .read_enable_to_Elpis(read_enable_to_Elpis),
    .read_interactive_req_core0(read_interactive_req_core0),
    .ready(is_mem_ready),
    .req_out_core0(req_out_core0),
    .requested(is_mem_req),
    .reset_core(reset_core),
    .reset_mem_req(core0_need_reset_mem_req),
    .rst(rst),
    .spare_wen0_to_sram(spare_wen0_to_sram),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .we(core0_is_mem_we),
    .we_to_sram(we_to_sram),
    .addr0_to_sram({\addr0_to_sram[19] ,
    \addr0_to_sram[18] ,
    \addr0_to_sram[17] ,
    \addr0_to_sram[16] ,
    \addr0_to_sram[15] ,
    \addr0_to_sram[14] ,
    \addr0_to_sram[13] ,
    \addr0_to_sram[12] ,
    \addr0_to_sram[11] ,
    \addr0_to_sram[10] ,
    \addr0_to_sram[9] ,
    \addr0_to_sram[8] ,
    \addr0_to_sram[7] ,
    \addr0_to_sram[6] ,
    \addr0_to_sram[5] ,
    \addr0_to_sram[4] ,
    \addr0_to_sram[3] ,
    \addr0_to_sram[2] ,
    \addr0_to_sram[1] ,
    \addr0_to_sram[0] }),
    .addr_in({\core0_to_mem_address[19] ,
    \core0_to_mem_address[18] ,
    \core0_to_mem_address[17] ,
    \core0_to_mem_address[16] ,
    \core0_to_mem_address[15] ,
    \core0_to_mem_address[14] ,
    \core0_to_mem_address[13] ,
    \core0_to_mem_address[12] ,
    \core0_to_mem_address[11] ,
    \core0_to_mem_address[10] ,
    \core0_to_mem_address[9] ,
    \core0_to_mem_address[8] ,
    \core0_to_mem_address[7] ,
    \core0_to_mem_address[6] ,
    \core0_to_mem_address[5] ,
    \core0_to_mem_address[4] ,
    \core0_to_mem_address[3] ,
    \core0_to_mem_address[2] ,
    \core0_to_mem_address[1] ,
    \core0_to_mem_address[0] }),
    .addr_to_core_mem({\addr_to_core_mem[19] ,
    \addr_to_core_mem[18] ,
    \addr_to_core_mem[17] ,
    \addr_to_core_mem[16] ,
    \addr_to_core_mem[15] ,
    \addr_to_core_mem[14] ,
    \addr_to_core_mem[13] ,
    \addr_to_core_mem[12] ,
    \addr_to_core_mem[11] ,
    \addr_to_core_mem[10] ,
    \addr_to_core_mem[9] ,
    \addr_to_core_mem[8] ,
    \addr_to_core_mem[7] ,
    \addr_to_core_mem[6] ,
    \addr_to_core_mem[5] ,
    \addr_to_core_mem[4] ,
    \addr_to_core_mem[3] ,
    \addr_to_core_mem[2] ,
    \addr_to_core_mem[1] ,
    \addr_to_core_mem[0] }),
    .core0_data_print({\core0_data_print[31] ,
    \core0_data_print[30] ,
    \core0_data_print[29] ,
    \core0_data_print[28] ,
    \core0_data_print[27] ,
    \core0_data_print[26] ,
    \core0_data_print[25] ,
    \core0_data_print[24] ,
    \core0_data_print[23] ,
    \core0_data_print[22] ,
    \core0_data_print[21] ,
    \core0_data_print[20] ,
    \core0_data_print[19] ,
    \core0_data_print[18] ,
    \core0_data_print[17] ,
    \core0_data_print[16] ,
    \core0_data_print[15] ,
    \core0_data_print[14] ,
    \core0_data_print[13] ,
    \core0_data_print[12] ,
    \core0_data_print[11] ,
    \core0_data_print[10] ,
    \core0_data_print[9] ,
    \core0_data_print[8] ,
    \core0_data_print[7] ,
    \core0_data_print[6] ,
    \core0_data_print[5] ,
    \core0_data_print[4] ,
    \core0_data_print[3] ,
    \core0_data_print[2] ,
    \core0_data_print[1] ,
    \core0_data_print[0] }),
    .data_out_to_core({\data_out_to_core[31] ,
    \data_out_to_core[30] ,
    \data_out_to_core[29] ,
    \data_out_to_core[28] ,
    \data_out_to_core[27] ,
    \data_out_to_core[26] ,
    \data_out_to_core[25] ,
    \data_out_to_core[24] ,
    \data_out_to_core[23] ,
    \data_out_to_core[22] ,
    \data_out_to_core[21] ,
    \data_out_to_core[20] ,
    \data_out_to_core[19] ,
    \data_out_to_core[18] ,
    \data_out_to_core[17] ,
    \data_out_to_core[16] ,
    \data_out_to_core[15] ,
    \data_out_to_core[14] ,
    \data_out_to_core[13] ,
    \data_out_to_core[12] ,
    \data_out_to_core[11] ,
    \data_out_to_core[10] ,
    \data_out_to_core[9] ,
    \data_out_to_core[8] ,
    \data_out_to_core[7] ,
    \data_out_to_core[6] ,
    \data_out_to_core[5] ,
    \data_out_to_core[4] ,
    \data_out_to_core[3] ,
    \data_out_to_core[2] ,
    \data_out_to_core[1] ,
    \data_out_to_core[0] }),
    .data_to_core_mem({\data_to_core_mem[31] ,
    \data_to_core_mem[30] ,
    \data_to_core_mem[29] ,
    \data_to_core_mem[28] ,
    \data_to_core_mem[27] ,
    \data_to_core_mem[26] ,
    \data_to_core_mem[25] ,
    \data_to_core_mem[24] ,
    \data_to_core_mem[23] ,
    \data_to_core_mem[22] ,
    \data_to_core_mem[21] ,
    \data_to_core_mem[20] ,
    \data_to_core_mem[19] ,
    \data_to_core_mem[18] ,
    \data_to_core_mem[17] ,
    \data_to_core_mem[16] ,
    \data_to_core_mem[15] ,
    \data_to_core_mem[14] ,
    \data_to_core_mem[13] ,
    \data_to_core_mem[12] ,
    \data_to_core_mem[11] ,
    \data_to_core_mem[10] ,
    \data_to_core_mem[9] ,
    \data_to_core_mem[8] ,
    \data_to_core_mem[7] ,
    \data_to_core_mem[6] ,
    \data_to_core_mem[5] ,
    \data_to_core_mem[4] ,
    \data_to_core_mem[3] ,
    \data_to_core_mem[2] ,
    \data_to_core_mem[1] ,
    \data_to_core_mem[0] }),
    .din0_to_sram({\din0_to_sram[31] ,
    \din0_to_sram[30] ,
    \din0_to_sram[29] ,
    \din0_to_sram[28] ,
    \din0_to_sram[27] ,
    \din0_to_sram[26] ,
    \din0_to_sram[25] ,
    \din0_to_sram[24] ,
    \din0_to_sram[23] ,
    \din0_to_sram[22] ,
    \din0_to_sram[21] ,
    \din0_to_sram[20] ,
    \din0_to_sram[19] ,
    \din0_to_sram[18] ,
    \din0_to_sram[17] ,
    \din0_to_sram[16] ,
    \din0_to_sram[15] ,
    \din0_to_sram[14] ,
    \din0_to_sram[13] ,
    \din0_to_sram[12] ,
    \din0_to_sram[11] ,
    \din0_to_sram[10] ,
    \din0_to_sram[9] ,
    \din0_to_sram[8] ,
    \din0_to_sram[7] ,
    \din0_to_sram[6] ,
    \din0_to_sram[5] ,
    \din0_to_sram[4] ,
    \din0_to_sram[3] ,
    \din0_to_sram[2] ,
    \din0_to_sram[1] ,
    \din0_to_sram[0] }),
    .dout0_to_sram({\dout0_to_sram[31] ,
    \dout0_to_sram[30] ,
    \dout0_to_sram[29] ,
    \dout0_to_sram[28] ,
    \dout0_to_sram[27] ,
    \dout0_to_sram[26] ,
    \dout0_to_sram[25] ,
    \dout0_to_sram[24] ,
    \dout0_to_sram[23] ,
    \dout0_to_sram[22] ,
    \dout0_to_sram[21] ,
    \dout0_to_sram[20] ,
    \dout0_to_sram[19] ,
    \dout0_to_sram[18] ,
    \dout0_to_sram[17] ,
    \dout0_to_sram[16] ,
    \dout0_to_sram[15] ,
    \dout0_to_sram[14] ,
    \dout0_to_sram[13] ,
    \dout0_to_sram[12] ,
    \dout0_to_sram[11] ,
    \dout0_to_sram[10] ,
    \dout0_to_sram[9] ,
    \dout0_to_sram[8] ,
    \dout0_to_sram[7] ,
    \dout0_to_sram[6] ,
    \dout0_to_sram[5] ,
    \dout0_to_sram[4] ,
    \dout0_to_sram[3] ,
    \dout0_to_sram[2] ,
    \dout0_to_sram[1] ,
    \dout0_to_sram[0] }),
    .la_data_in({la_data_in[127],
    la_data_in[126],
    la_data_in[125],
    la_data_in[124],
    la_data_in[123],
    la_data_in[122],
    la_data_in[121],
    la_data_in[120],
    la_data_in[119],
    la_data_in[118],
    la_data_in[117],
    la_data_in[116],
    la_data_in[115],
    la_data_in[114],
    la_data_in[113],
    la_data_in[112],
    la_data_in[111],
    la_data_in[110],
    la_data_in[109],
    la_data_in[108],
    la_data_in[107],
    la_data_in[106],
    la_data_in[105],
    la_data_in[104],
    la_data_in[103],
    la_data_in[102],
    la_data_in[101],
    la_data_in[100],
    la_data_in[99],
    la_data_in[98],
    la_data_in[97],
    la_data_in[96],
    la_data_in[95],
    la_data_in[94],
    la_data_in[93],
    la_data_in[92],
    la_data_in[91],
    la_data_in[90],
    la_data_in[89],
    la_data_in[88],
    la_data_in[87],
    la_data_in[86],
    la_data_in[85],
    la_data_in[84],
    la_data_in[83],
    la_data_in[82],
    la_data_in[81],
    la_data_in[80],
    la_data_in[79],
    la_data_in[78],
    la_data_in[77],
    la_data_in[76],
    la_data_in[75],
    la_data_in[74],
    la_data_in[73],
    la_data_in[72],
    la_data_in[71],
    la_data_in[70],
    la_data_in[69],
    la_data_in[68],
    la_data_in[67],
    la_data_in[66],
    la_data_in[65],
    la_data_in[64],
    la_data_in[63],
    la_data_in[62],
    la_data_in[61],
    la_data_in[60],
    la_data_in[59],
    la_data_in[58],
    la_data_in[57],
    la_data_in[56],
    la_data_in[55],
    la_data_in[54],
    la_data_in[53],
    la_data_in[52],
    la_data_in[51],
    la_data_in[50],
    la_data_in[49],
    la_data_in[48],
    la_data_in[47],
    la_data_in[46],
    la_data_in[45],
    la_data_in[44],
    la_data_in[43],
    la_data_in[42],
    la_data_in[41],
    la_data_in[40],
    la_data_in[39],
    la_data_in[38],
    la_data_in[37],
    la_data_in[36],
    la_data_in[35],
    la_data_in[34],
    la_data_in[33],
    la_data_in[32],
    la_data_in[31],
    la_data_in[30],
    la_data_in[29],
    la_data_in[28],
    la_data_in[27],
    la_data_in[26],
    la_data_in[25],
    la_data_in[24],
    la_data_in[23],
    la_data_in[22],
    la_data_in[21],
    la_data_in[20],
    la_data_in[19],
    la_data_in[18],
    la_data_in[17],
    la_data_in[16],
    la_data_in[15],
    la_data_in[14],
    la_data_in[13],
    la_data_in[12],
    la_data_in[11],
    la_data_in[10],
    la_data_in[9],
    la_data_in[8],
    la_data_in[7],
    la_data_in[6],
    la_data_in[5],
    la_data_in[4],
    la_data_in[3],
    la_data_in[2],
    la_data_in[1],
    la_data_in[0]}),
    .la_data_out({la_data_out[127],
    la_data_out[126],
    la_data_out[125],
    la_data_out[124],
    la_data_out[123],
    la_data_out[122],
    la_data_out[121],
    la_data_out[120],
    la_data_out[119],
    la_data_out[118],
    la_data_out[117],
    la_data_out[116],
    la_data_out[115],
    la_data_out[114],
    la_data_out[113],
    la_data_out[112],
    la_data_out[111],
    la_data_out[110],
    la_data_out[109],
    la_data_out[108],
    la_data_out[107],
    la_data_out[106],
    la_data_out[105],
    la_data_out[104],
    la_data_out[103],
    la_data_out[102],
    la_data_out[101],
    la_data_out[100],
    la_data_out[99],
    la_data_out[98],
    la_data_out[97],
    la_data_out[96],
    la_data_out[95],
    la_data_out[94],
    la_data_out[93],
    la_data_out[92],
    la_data_out[91],
    la_data_out[90],
    la_data_out[89],
    la_data_out[88],
    la_data_out[87],
    la_data_out[86],
    la_data_out[85],
    la_data_out[84],
    la_data_out[83],
    la_data_out[82],
    la_data_out[81],
    la_data_out[80],
    la_data_out[79],
    la_data_out[78],
    la_data_out[77],
    la_data_out[76],
    la_data_out[75],
    la_data_out[74],
    la_data_out[73],
    la_data_out[72],
    la_data_out[71],
    la_data_out[70],
    la_data_out[69],
    la_data_out[68],
    la_data_out[67],
    la_data_out[66],
    la_data_out[65],
    la_data_out[64],
    la_data_out[63],
    la_data_out[62],
    la_data_out[61],
    la_data_out[60],
    la_data_out[59],
    la_data_out[58],
    la_data_out[57],
    la_data_out[56],
    la_data_out[55],
    la_data_out[54],
    la_data_out[53],
    la_data_out[52],
    la_data_out[51],
    la_data_out[50],
    la_data_out[49],
    la_data_out[48],
    la_data_out[47],
    la_data_out[46],
    la_data_out[45],
    la_data_out[44],
    la_data_out[43],
    la_data_out[42],
    la_data_out[41],
    la_data_out[40],
    la_data_out[39],
    la_data_out[38],
    la_data_out[37],
    la_data_out[36],
    la_data_out[35],
    la_data_out[34],
    la_data_out[33],
    la_data_out[32],
    la_data_out[31],
    la_data_out[30],
    la_data_out[29],
    la_data_out[28],
    la_data_out[27],
    la_data_out[26],
    la_data_out[25],
    la_data_out[24],
    la_data_out[23],
    la_data_out[22],
    la_data_out[21],
    la_data_out[20],
    la_data_out[19],
    la_data_out[18],
    la_data_out[17],
    la_data_out[16],
    la_data_out[15],
    la_data_out[14],
    la_data_out[13],
    la_data_out[12],
    la_data_out[11],
    la_data_out[10],
    la_data_out[9],
    la_data_out[8],
    la_data_out[7],
    la_data_out[6],
    la_data_out[5],
    la_data_out[4],
    la_data_out[3],
    la_data_out[2],
    la_data_out[1],
    la_data_out[0]}),
    .la_oenb({la_oenb[127],
    la_oenb[126],
    la_oenb[125],
    la_oenb[124],
    la_oenb[123],
    la_oenb[122],
    la_oenb[121],
    la_oenb[120],
    la_oenb[119],
    la_oenb[118],
    la_oenb[117],
    la_oenb[116],
    la_oenb[115],
    la_oenb[114],
    la_oenb[113],
    la_oenb[112],
    la_oenb[111],
    la_oenb[110],
    la_oenb[109],
    la_oenb[108],
    la_oenb[107],
    la_oenb[106],
    la_oenb[105],
    la_oenb[104],
    la_oenb[103],
    la_oenb[102],
    la_oenb[101],
    la_oenb[100],
    la_oenb[99],
    la_oenb[98],
    la_oenb[97],
    la_oenb[96],
    la_oenb[95],
    la_oenb[94],
    la_oenb[93],
    la_oenb[92],
    la_oenb[91],
    la_oenb[90],
    la_oenb[89],
    la_oenb[88],
    la_oenb[87],
    la_oenb[86],
    la_oenb[85],
    la_oenb[84],
    la_oenb[83],
    la_oenb[82],
    la_oenb[81],
    la_oenb[80],
    la_oenb[79],
    la_oenb[78],
    la_oenb[77],
    la_oenb[76],
    la_oenb[75],
    la_oenb[74],
    la_oenb[73],
    la_oenb[72],
    la_oenb[71],
    la_oenb[70],
    la_oenb[69],
    la_oenb[68],
    la_oenb[67],
    la_oenb[66],
    la_oenb[65],
    la_oenb[64],
    la_oenb[63],
    la_oenb[62],
    la_oenb[61],
    la_oenb[60],
    la_oenb[59],
    la_oenb[58],
    la_oenb[57],
    la_oenb[56],
    la_oenb[55],
    la_oenb[54],
    la_oenb[53],
    la_oenb[52],
    la_oenb[51],
    la_oenb[50],
    la_oenb[49],
    la_oenb[48],
    la_oenb[47],
    la_oenb[46],
    la_oenb[45],
    la_oenb[44],
    la_oenb[43],
    la_oenb[42],
    la_oenb[41],
    la_oenb[40],
    la_oenb[39],
    la_oenb[38],
    la_oenb[37],
    la_oenb[36],
    la_oenb[35],
    la_oenb[34],
    la_oenb[33],
    la_oenb[32],
    la_oenb[31],
    la_oenb[30],
    la_oenb[29],
    la_oenb[28],
    la_oenb[27],
    la_oenb[26],
    la_oenb[25],
    la_oenb[24],
    la_oenb[23],
    la_oenb[22],
    la_oenb[21],
    la_oenb[20],
    la_oenb[19],
    la_oenb[18],
    la_oenb[17],
    la_oenb[16],
    la_oenb[15],
    la_oenb[14],
    la_oenb[13],
    la_oenb[12],
    la_oenb[11],
    la_oenb[10],
    la_oenb[9],
    la_oenb[8],
    la_oenb[7],
    la_oenb[6],
    la_oenb[5],
    la_oenb[4],
    la_oenb[3],
    la_oenb[2],
    la_oenb[1],
    la_oenb[0]}),
    .rd_data_out({\read_data_from_mem[127] ,
    \read_data_from_mem[126] ,
    \read_data_from_mem[125] ,
    \read_data_from_mem[124] ,
    \read_data_from_mem[123] ,
    \read_data_from_mem[122] ,
    \read_data_from_mem[121] ,
    \read_data_from_mem[120] ,
    \read_data_from_mem[119] ,
    \read_data_from_mem[118] ,
    \read_data_from_mem[117] ,
    \read_data_from_mem[116] ,
    \read_data_from_mem[115] ,
    \read_data_from_mem[114] ,
    \read_data_from_mem[113] ,
    \read_data_from_mem[112] ,
    \read_data_from_mem[111] ,
    \read_data_from_mem[110] ,
    \read_data_from_mem[109] ,
    \read_data_from_mem[108] ,
    \read_data_from_mem[107] ,
    \read_data_from_mem[106] ,
    \read_data_from_mem[105] ,
    \read_data_from_mem[104] ,
    \read_data_from_mem[103] ,
    \read_data_from_mem[102] ,
    \read_data_from_mem[101] ,
    \read_data_from_mem[100] ,
    \read_data_from_mem[99] ,
    \read_data_from_mem[98] ,
    \read_data_from_mem[97] ,
    \read_data_from_mem[96] ,
    \read_data_from_mem[95] ,
    \read_data_from_mem[94] ,
    \read_data_from_mem[93] ,
    \read_data_from_mem[92] ,
    \read_data_from_mem[91] ,
    \read_data_from_mem[90] ,
    \read_data_from_mem[89] ,
    \read_data_from_mem[88] ,
    \read_data_from_mem[87] ,
    \read_data_from_mem[86] ,
    \read_data_from_mem[85] ,
    \read_data_from_mem[84] ,
    \read_data_from_mem[83] ,
    \read_data_from_mem[82] ,
    \read_data_from_mem[81] ,
    \read_data_from_mem[80] ,
    \read_data_from_mem[79] ,
    \read_data_from_mem[78] ,
    \read_data_from_mem[77] ,
    \read_data_from_mem[76] ,
    \read_data_from_mem[75] ,
    \read_data_from_mem[74] ,
    \read_data_from_mem[73] ,
    \read_data_from_mem[72] ,
    \read_data_from_mem[71] ,
    \read_data_from_mem[70] ,
    \read_data_from_mem[69] ,
    \read_data_from_mem[68] ,
    \read_data_from_mem[67] ,
    \read_data_from_mem[66] ,
    \read_data_from_mem[65] ,
    \read_data_from_mem[64] ,
    \read_data_from_mem[63] ,
    \read_data_from_mem[62] ,
    \read_data_from_mem[61] ,
    \read_data_from_mem[60] ,
    \read_data_from_mem[59] ,
    \read_data_from_mem[58] ,
    \read_data_from_mem[57] ,
    \read_data_from_mem[56] ,
    \read_data_from_mem[55] ,
    \read_data_from_mem[54] ,
    \read_data_from_mem[53] ,
    \read_data_from_mem[52] ,
    \read_data_from_mem[51] ,
    \read_data_from_mem[50] ,
    \read_data_from_mem[49] ,
    \read_data_from_mem[48] ,
    \read_data_from_mem[47] ,
    \read_data_from_mem[46] ,
    \read_data_from_mem[45] ,
    \read_data_from_mem[44] ,
    \read_data_from_mem[43] ,
    \read_data_from_mem[42] ,
    \read_data_from_mem[41] ,
    \read_data_from_mem[40] ,
    \read_data_from_mem[39] ,
    \read_data_from_mem[38] ,
    \read_data_from_mem[37] ,
    \read_data_from_mem[36] ,
    \read_data_from_mem[35] ,
    \read_data_from_mem[34] ,
    \read_data_from_mem[33] ,
    \read_data_from_mem[32] ,
    \read_data_from_mem[31] ,
    \read_data_from_mem[30] ,
    \read_data_from_mem[29] ,
    \read_data_from_mem[28] ,
    \read_data_from_mem[27] ,
    \read_data_from_mem[26] ,
    \read_data_from_mem[25] ,
    \read_data_from_mem[24] ,
    \read_data_from_mem[23] ,
    \read_data_from_mem[22] ,
    \read_data_from_mem[21] ,
    \read_data_from_mem[20] ,
    \read_data_from_mem[19] ,
    \read_data_from_mem[18] ,
    \read_data_from_mem[17] ,
    \read_data_from_mem[16] ,
    \read_data_from_mem[15] ,
    \read_data_from_mem[14] ,
    \read_data_from_mem[13] ,
    \read_data_from_mem[12] ,
    \read_data_from_mem[11] ,
    \read_data_from_mem[10] ,
    \read_data_from_mem[9] ,
    \read_data_from_mem[8] ,
    \read_data_from_mem[7] ,
    \read_data_from_mem[6] ,
    \read_data_from_mem[5] ,
    \read_data_from_mem[4] ,
    \read_data_from_mem[3] ,
    \read_data_from_mem[2] ,
    \read_data_from_mem[1] ,
    \read_data_from_mem[0] }),
    .read_value_to_Elpis({\read_value_to_Elpis[31] ,
    \read_value_to_Elpis[30] ,
    \read_value_to_Elpis[29] ,
    \read_value_to_Elpis[28] ,
    \read_value_to_Elpis[27] ,
    \read_value_to_Elpis[26] ,
    \read_value_to_Elpis[25] ,
    \read_value_to_Elpis[24] ,
    \read_value_to_Elpis[23] ,
    \read_value_to_Elpis[22] ,
    \read_value_to_Elpis[21] ,
    \read_value_to_Elpis[20] ,
    \read_value_to_Elpis[19] ,
    \read_value_to_Elpis[18] ,
    \read_value_to_Elpis[17] ,
    \read_value_to_Elpis[16] ,
    \read_value_to_Elpis[15] ,
    \read_value_to_Elpis[14] ,
    \read_value_to_Elpis[13] ,
    \read_value_to_Elpis[12] ,
    \read_value_to_Elpis[11] ,
    \read_value_to_Elpis[10] ,
    \read_value_to_Elpis[9] ,
    \read_value_to_Elpis[8] ,
    \read_value_to_Elpis[7] ,
    \read_value_to_Elpis[6] ,
    \read_value_to_Elpis[5] ,
    \read_value_to_Elpis[4] ,
    \read_value_to_Elpis[3] ,
    \read_value_to_Elpis[2] ,
    \read_value_to_Elpis[1] ,
    \read_value_to_Elpis[0] }),
    .wbs_dat_o({wbs_dat_o[31],
    wbs_dat_o[30],
    wbs_dat_o[29],
    wbs_dat_o[28],
    wbs_dat_o[27],
    wbs_dat_o[26],
    wbs_dat_o[25],
    wbs_dat_o[24],
    wbs_dat_o[23],
    wbs_dat_o[22],
    wbs_dat_o[21],
    wbs_dat_o[20],
    wbs_dat_o[19],
    wbs_dat_o[18],
    wbs_dat_o[17],
    wbs_dat_o[16],
    wbs_dat_o[15],
    wbs_dat_o[14],
    wbs_dat_o[13],
    wbs_dat_o[12],
    wbs_dat_o[11],
    wbs_dat_o[10],
    wbs_dat_o[9],
    wbs_dat_o[8],
    wbs_dat_o[7],
    wbs_dat_o[6],
    wbs_dat_o[5],
    wbs_dat_o[4],
    wbs_dat_o[3],
    wbs_dat_o[2],
    wbs_dat_o[1],
    wbs_dat_o[0]}),
    .wr_data({\core0_to_mem_data[127] ,
    \core0_to_mem_data[126] ,
    \core0_to_mem_data[125] ,
    \core0_to_mem_data[124] ,
    \core0_to_mem_data[123] ,
    \core0_to_mem_data[122] ,
    \core0_to_mem_data[121] ,
    \core0_to_mem_data[120] ,
    \core0_to_mem_data[119] ,
    \core0_to_mem_data[118] ,
    \core0_to_mem_data[117] ,
    \core0_to_mem_data[116] ,
    \core0_to_mem_data[115] ,
    \core0_to_mem_data[114] ,
    \core0_to_mem_data[113] ,
    \core0_to_mem_data[112] ,
    \core0_to_mem_data[111] ,
    \core0_to_mem_data[110] ,
    \core0_to_mem_data[109] ,
    \core0_to_mem_data[108] ,
    \core0_to_mem_data[107] ,
    \core0_to_mem_data[106] ,
    \core0_to_mem_data[105] ,
    \core0_to_mem_data[104] ,
    \core0_to_mem_data[103] ,
    \core0_to_mem_data[102] ,
    \core0_to_mem_data[101] ,
    \core0_to_mem_data[100] ,
    \core0_to_mem_data[99] ,
    \core0_to_mem_data[98] ,
    \core0_to_mem_data[97] ,
    \core0_to_mem_data[96] ,
    \core0_to_mem_data[95] ,
    \core0_to_mem_data[94] ,
    \core0_to_mem_data[93] ,
    \core0_to_mem_data[92] ,
    \core0_to_mem_data[91] ,
    \core0_to_mem_data[90] ,
    \core0_to_mem_data[89] ,
    \core0_to_mem_data[88] ,
    \core0_to_mem_data[87] ,
    \core0_to_mem_data[86] ,
    \core0_to_mem_data[85] ,
    \core0_to_mem_data[84] ,
    \core0_to_mem_data[83] ,
    \core0_to_mem_data[82] ,
    \core0_to_mem_data[81] ,
    \core0_to_mem_data[80] ,
    \core0_to_mem_data[79] ,
    \core0_to_mem_data[78] ,
    \core0_to_mem_data[77] ,
    \core0_to_mem_data[76] ,
    \core0_to_mem_data[75] ,
    \core0_to_mem_data[74] ,
    \core0_to_mem_data[73] ,
    \core0_to_mem_data[72] ,
    \core0_to_mem_data[71] ,
    \core0_to_mem_data[70] ,
    \core0_to_mem_data[69] ,
    \core0_to_mem_data[68] ,
    \core0_to_mem_data[67] ,
    \core0_to_mem_data[66] ,
    \core0_to_mem_data[65] ,
    \core0_to_mem_data[64] ,
    \core0_to_mem_data[63] ,
    \core0_to_mem_data[62] ,
    \core0_to_mem_data[61] ,
    \core0_to_mem_data[60] ,
    \core0_to_mem_data[59] ,
    \core0_to_mem_data[58] ,
    \core0_to_mem_data[57] ,
    \core0_to_mem_data[56] ,
    \core0_to_mem_data[55] ,
    \core0_to_mem_data[54] ,
    \core0_to_mem_data[53] ,
    \core0_to_mem_data[52] ,
    \core0_to_mem_data[51] ,
    \core0_to_mem_data[50] ,
    \core0_to_mem_data[49] ,
    \core0_to_mem_data[48] ,
    \core0_to_mem_data[47] ,
    \core0_to_mem_data[46] ,
    \core0_to_mem_data[45] ,
    \core0_to_mem_data[44] ,
    \core0_to_mem_data[43] ,
    \core0_to_mem_data[42] ,
    \core0_to_mem_data[41] ,
    \core0_to_mem_data[40] ,
    \core0_to_mem_data[39] ,
    \core0_to_mem_data[38] ,
    \core0_to_mem_data[37] ,
    \core0_to_mem_data[36] ,
    \core0_to_mem_data[35] ,
    \core0_to_mem_data[34] ,
    \core0_to_mem_data[33] ,
    \core0_to_mem_data[32] ,
    \core0_to_mem_data[31] ,
    \core0_to_mem_data[30] ,
    \core0_to_mem_data[29] ,
    \core0_to_mem_data[28] ,
    \core0_to_mem_data[27] ,
    \core0_to_mem_data[26] ,
    \core0_to_mem_data[25] ,
    \core0_to_mem_data[24] ,
    \core0_to_mem_data[23] ,
    \core0_to_mem_data[22] ,
    \core0_to_mem_data[21] ,
    \core0_to_mem_data[20] ,
    \core0_to_mem_data[19] ,
    \core0_to_mem_data[18] ,
    \core0_to_mem_data[17] ,
    \core0_to_mem_data[16] ,
    \core0_to_mem_data[15] ,
    \core0_to_mem_data[14] ,
    \core0_to_mem_data[13] ,
    \core0_to_mem_data[12] ,
    \core0_to_mem_data[11] ,
    \core0_to_mem_data[10] ,
    \core0_to_mem_data[9] ,
    \core0_to_mem_data[8] ,
    \core0_to_mem_data[7] ,
    \core0_to_mem_data[6] ,
    \core0_to_mem_data[5] ,
    \core0_to_mem_data[4] ,
    \core0_to_mem_data[3] ,
    \core0_to_mem_data[2] ,
    \core0_to_mem_data[1] ,
    \core0_to_mem_data[0] }));
 core core0 (.clk(clk),
    .hex_req(req_out_core0),
    .is_mem_ready(is_mem_ready),
    .is_mem_req(is_mem_req),
    .is_mem_req_reset(core0_need_reset_mem_req),
    .is_memory_we(core0_is_mem_we),
    .is_print_done(is_ready_print_core0),
    .read_interactive_ready(is_ready_dataout_core0),
    .read_interactive_req(read_interactive_req_core0),
    .rst(reset_core),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .data_from_mem({\read_data_from_mem[127] ,
    \read_data_from_mem[126] ,
    \read_data_from_mem[125] ,
    \read_data_from_mem[124] ,
    \read_data_from_mem[123] ,
    \read_data_from_mem[122] ,
    \read_data_from_mem[121] ,
    \read_data_from_mem[120] ,
    \read_data_from_mem[119] ,
    \read_data_from_mem[118] ,
    \read_data_from_mem[117] ,
    \read_data_from_mem[116] ,
    \read_data_from_mem[115] ,
    \read_data_from_mem[114] ,
    \read_data_from_mem[113] ,
    \read_data_from_mem[112] ,
    \read_data_from_mem[111] ,
    \read_data_from_mem[110] ,
    \read_data_from_mem[109] ,
    \read_data_from_mem[108] ,
    \read_data_from_mem[107] ,
    \read_data_from_mem[106] ,
    \read_data_from_mem[105] ,
    \read_data_from_mem[104] ,
    \read_data_from_mem[103] ,
    \read_data_from_mem[102] ,
    \read_data_from_mem[101] ,
    \read_data_from_mem[100] ,
    \read_data_from_mem[99] ,
    \read_data_from_mem[98] ,
    \read_data_from_mem[97] ,
    \read_data_from_mem[96] ,
    \read_data_from_mem[95] ,
    \read_data_from_mem[94] ,
    \read_data_from_mem[93] ,
    \read_data_from_mem[92] ,
    \read_data_from_mem[91] ,
    \read_data_from_mem[90] ,
    \read_data_from_mem[89] ,
    \read_data_from_mem[88] ,
    \read_data_from_mem[87] ,
    \read_data_from_mem[86] ,
    \read_data_from_mem[85] ,
    \read_data_from_mem[84] ,
    \read_data_from_mem[83] ,
    \read_data_from_mem[82] ,
    \read_data_from_mem[81] ,
    \read_data_from_mem[80] ,
    \read_data_from_mem[79] ,
    \read_data_from_mem[78] ,
    \read_data_from_mem[77] ,
    \read_data_from_mem[76] ,
    \read_data_from_mem[75] ,
    \read_data_from_mem[74] ,
    \read_data_from_mem[73] ,
    \read_data_from_mem[72] ,
    \read_data_from_mem[71] ,
    \read_data_from_mem[70] ,
    \read_data_from_mem[69] ,
    \read_data_from_mem[68] ,
    \read_data_from_mem[67] ,
    \read_data_from_mem[66] ,
    \read_data_from_mem[65] ,
    \read_data_from_mem[64] ,
    \read_data_from_mem[63] ,
    \read_data_from_mem[62] ,
    \read_data_from_mem[61] ,
    \read_data_from_mem[60] ,
    \read_data_from_mem[59] ,
    \read_data_from_mem[58] ,
    \read_data_from_mem[57] ,
    \read_data_from_mem[56] ,
    \read_data_from_mem[55] ,
    \read_data_from_mem[54] ,
    \read_data_from_mem[53] ,
    \read_data_from_mem[52] ,
    \read_data_from_mem[51] ,
    \read_data_from_mem[50] ,
    \read_data_from_mem[49] ,
    \read_data_from_mem[48] ,
    \read_data_from_mem[47] ,
    \read_data_from_mem[46] ,
    \read_data_from_mem[45] ,
    \read_data_from_mem[44] ,
    \read_data_from_mem[43] ,
    \read_data_from_mem[42] ,
    \read_data_from_mem[41] ,
    \read_data_from_mem[40] ,
    \read_data_from_mem[39] ,
    \read_data_from_mem[38] ,
    \read_data_from_mem[37] ,
    \read_data_from_mem[36] ,
    \read_data_from_mem[35] ,
    \read_data_from_mem[34] ,
    \read_data_from_mem[33] ,
    \read_data_from_mem[32] ,
    \read_data_from_mem[31] ,
    \read_data_from_mem[30] ,
    \read_data_from_mem[29] ,
    \read_data_from_mem[28] ,
    \read_data_from_mem[27] ,
    \read_data_from_mem[26] ,
    \read_data_from_mem[25] ,
    \read_data_from_mem[24] ,
    \read_data_from_mem[23] ,
    \read_data_from_mem[22] ,
    \read_data_from_mem[21] ,
    \read_data_from_mem[20] ,
    \read_data_from_mem[19] ,
    \read_data_from_mem[18] ,
    \read_data_from_mem[17] ,
    \read_data_from_mem[16] ,
    \read_data_from_mem[15] ,
    \read_data_from_mem[14] ,
    \read_data_from_mem[13] ,
    \read_data_from_mem[12] ,
    \read_data_from_mem[11] ,
    \read_data_from_mem[10] ,
    \read_data_from_mem[9] ,
    \read_data_from_mem[8] ,
    \read_data_from_mem[7] ,
    \read_data_from_mem[6] ,
    \read_data_from_mem[5] ,
    \read_data_from_mem[4] ,
    \read_data_from_mem[3] ,
    \read_data_from_mem[2] ,
    \read_data_from_mem[1] ,
    \read_data_from_mem[0] }),
    .hex_out({\core0_data_print[31] ,
    \core0_data_print[30] ,
    \core0_data_print[29] ,
    \core0_data_print[28] ,
    \core0_data_print[27] ,
    \core0_data_print[26] ,
    \core0_data_print[25] ,
    \core0_data_print[24] ,
    \core0_data_print[23] ,
    \core0_data_print[22] ,
    \core0_data_print[21] ,
    \core0_data_print[20] ,
    \core0_data_print[19] ,
    \core0_data_print[18] ,
    \core0_data_print[17] ,
    \core0_data_print[16] ,
    \core0_data_print[15] ,
    \core0_data_print[14] ,
    \core0_data_print[13] ,
    \core0_data_print[12] ,
    \core0_data_print[11] ,
    \core0_data_print[10] ,
    \core0_data_print[9] ,
    \core0_data_print[8] ,
    \core0_data_print[7] ,
    \core0_data_print[6] ,
    \core0_data_print[5] ,
    \core0_data_print[4] ,
    \core0_data_print[3] ,
    \core0_data_print[2] ,
    \core0_data_print[1] ,
    \core0_data_print[0] }),
    .mem_addr_out({\core0_to_mem_address[19] ,
    \core0_to_mem_address[18] ,
    \core0_to_mem_address[17] ,
    \core0_to_mem_address[16] ,
    \core0_to_mem_address[15] ,
    \core0_to_mem_address[14] ,
    \core0_to_mem_address[13] ,
    \core0_to_mem_address[12] ,
    \core0_to_mem_address[11] ,
    \core0_to_mem_address[10] ,
    \core0_to_mem_address[9] ,
    \core0_to_mem_address[8] ,
    \core0_to_mem_address[7] ,
    \core0_to_mem_address[6] ,
    \core0_to_mem_address[5] ,
    \core0_to_mem_address[4] ,
    \core0_to_mem_address[3] ,
    \core0_to_mem_address[2] ,
    \core0_to_mem_address[1] ,
    \core0_to_mem_address[0] }),
    .mem_data_out({\core0_to_mem_data[127] ,
    \core0_to_mem_data[126] ,
    \core0_to_mem_data[125] ,
    \core0_to_mem_data[124] ,
    \core0_to_mem_data[123] ,
    \core0_to_mem_data[122] ,
    \core0_to_mem_data[121] ,
    \core0_to_mem_data[120] ,
    \core0_to_mem_data[119] ,
    \core0_to_mem_data[118] ,
    \core0_to_mem_data[117] ,
    \core0_to_mem_data[116] ,
    \core0_to_mem_data[115] ,
    \core0_to_mem_data[114] ,
    \core0_to_mem_data[113] ,
    \core0_to_mem_data[112] ,
    \core0_to_mem_data[111] ,
    \core0_to_mem_data[110] ,
    \core0_to_mem_data[109] ,
    \core0_to_mem_data[108] ,
    \core0_to_mem_data[107] ,
    \core0_to_mem_data[106] ,
    \core0_to_mem_data[105] ,
    \core0_to_mem_data[104] ,
    \core0_to_mem_data[103] ,
    \core0_to_mem_data[102] ,
    \core0_to_mem_data[101] ,
    \core0_to_mem_data[100] ,
    \core0_to_mem_data[99] ,
    \core0_to_mem_data[98] ,
    \core0_to_mem_data[97] ,
    \core0_to_mem_data[96] ,
    \core0_to_mem_data[95] ,
    \core0_to_mem_data[94] ,
    \core0_to_mem_data[93] ,
    \core0_to_mem_data[92] ,
    \core0_to_mem_data[91] ,
    \core0_to_mem_data[90] ,
    \core0_to_mem_data[89] ,
    \core0_to_mem_data[88] ,
    \core0_to_mem_data[87] ,
    \core0_to_mem_data[86] ,
    \core0_to_mem_data[85] ,
    \core0_to_mem_data[84] ,
    \core0_to_mem_data[83] ,
    \core0_to_mem_data[82] ,
    \core0_to_mem_data[81] ,
    \core0_to_mem_data[80] ,
    \core0_to_mem_data[79] ,
    \core0_to_mem_data[78] ,
    \core0_to_mem_data[77] ,
    \core0_to_mem_data[76] ,
    \core0_to_mem_data[75] ,
    \core0_to_mem_data[74] ,
    \core0_to_mem_data[73] ,
    \core0_to_mem_data[72] ,
    \core0_to_mem_data[71] ,
    \core0_to_mem_data[70] ,
    \core0_to_mem_data[69] ,
    \core0_to_mem_data[68] ,
    \core0_to_mem_data[67] ,
    \core0_to_mem_data[66] ,
    \core0_to_mem_data[65] ,
    \core0_to_mem_data[64] ,
    \core0_to_mem_data[63] ,
    \core0_to_mem_data[62] ,
    \core0_to_mem_data[61] ,
    \core0_to_mem_data[60] ,
    \core0_to_mem_data[59] ,
    \core0_to_mem_data[58] ,
    \core0_to_mem_data[57] ,
    \core0_to_mem_data[56] ,
    \core0_to_mem_data[55] ,
    \core0_to_mem_data[54] ,
    \core0_to_mem_data[53] ,
    \core0_to_mem_data[52] ,
    \core0_to_mem_data[51] ,
    \core0_to_mem_data[50] ,
    \core0_to_mem_data[49] ,
    \core0_to_mem_data[48] ,
    \core0_to_mem_data[47] ,
    \core0_to_mem_data[46] ,
    \core0_to_mem_data[45] ,
    \core0_to_mem_data[44] ,
    \core0_to_mem_data[43] ,
    \core0_to_mem_data[42] ,
    \core0_to_mem_data[41] ,
    \core0_to_mem_data[40] ,
    \core0_to_mem_data[39] ,
    \core0_to_mem_data[38] ,
    \core0_to_mem_data[37] ,
    \core0_to_mem_data[36] ,
    \core0_to_mem_data[35] ,
    \core0_to_mem_data[34] ,
    \core0_to_mem_data[33] ,
    \core0_to_mem_data[32] ,
    \core0_to_mem_data[31] ,
    \core0_to_mem_data[30] ,
    \core0_to_mem_data[29] ,
    \core0_to_mem_data[28] ,
    \core0_to_mem_data[27] ,
    \core0_to_mem_data[26] ,
    \core0_to_mem_data[25] ,
    \core0_to_mem_data[24] ,
    \core0_to_mem_data[23] ,
    \core0_to_mem_data[22] ,
    \core0_to_mem_data[21] ,
    \core0_to_mem_data[20] ,
    \core0_to_mem_data[19] ,
    \core0_to_mem_data[18] ,
    \core0_to_mem_data[17] ,
    \core0_to_mem_data[16] ,
    \core0_to_mem_data[15] ,
    \core0_to_mem_data[14] ,
    \core0_to_mem_data[13] ,
    \core0_to_mem_data[12] ,
    \core0_to_mem_data[11] ,
    \core0_to_mem_data[10] ,
    \core0_to_mem_data[9] ,
    \core0_to_mem_data[8] ,
    \core0_to_mem_data[7] ,
    \core0_to_mem_data[6] ,
    \core0_to_mem_data[5] ,
    \core0_to_mem_data[4] ,
    \core0_to_mem_data[3] ,
    \core0_to_mem_data[2] ,
    \core0_to_mem_data[1] ,
    \core0_to_mem_data[0] }),
    .read_interactive_value({\data_out_to_core[31] ,
    \data_out_to_core[30] ,
    \data_out_to_core[29] ,
    \data_out_to_core[28] ,
    \data_out_to_core[27] ,
    \data_out_to_core[26] ,
    \data_out_to_core[25] ,
    \data_out_to_core[24] ,
    \data_out_to_core[23] ,
    \data_out_to_core[22] ,
    \data_out_to_core[21] ,
    \data_out_to_core[20] ,
    \data_out_to_core[19] ,
    \data_out_to_core[18] ,
    \data_out_to_core[17] ,
    \data_out_to_core[16] ,
    \data_out_to_core[15] ,
    \data_out_to_core[14] ,
    \data_out_to_core[13] ,
    \data_out_to_core[12] ,
    \data_out_to_core[11] ,
    \data_out_to_core[10] ,
    \data_out_to_core[9] ,
    \data_out_to_core[8] ,
    \data_out_to_core[7] ,
    \data_out_to_core[6] ,
    \data_out_to_core[5] ,
    \data_out_to_core[4] ,
    \data_out_to_core[3] ,
    \data_out_to_core[2] ,
    \data_out_to_core[1] ,
    \data_out_to_core[0] }));
 custom_sram custom_sram (.clk(clk),
    .csb0_to_sram(csb0_to_sram),
    .spare_wen0_to_sram(spare_wen0_to_sram),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .we(we_to_sram),
    .a({\addr0_to_sram[19] ,
    \addr0_to_sram[18] ,
    \addr0_to_sram[17] ,
    \addr0_to_sram[16] ,
    \addr0_to_sram[15] ,
    \addr0_to_sram[14] ,
    \addr0_to_sram[13] ,
    \addr0_to_sram[12] ,
    \addr0_to_sram[11] ,
    \addr0_to_sram[10] ,
    \addr0_to_sram[9] ,
    \addr0_to_sram[8] ,
    \addr0_to_sram[7] ,
    \addr0_to_sram[6] ,
    \addr0_to_sram[5] ,
    \addr0_to_sram[4] ,
    \addr0_to_sram[3] ,
    \addr0_to_sram[2] ,
    \addr0_to_sram[1] ,
    \addr0_to_sram[0] }),
    .d({\din0_to_sram[31] ,
    \din0_to_sram[30] ,
    \din0_to_sram[29] ,
    \din0_to_sram[28] ,
    \din0_to_sram[27] ,
    \din0_to_sram[26] ,
    \din0_to_sram[25] ,
    \din0_to_sram[24] ,
    \din0_to_sram[23] ,
    \din0_to_sram[22] ,
    \din0_to_sram[21] ,
    \din0_to_sram[20] ,
    \din0_to_sram[19] ,
    \din0_to_sram[18] ,
    \din0_to_sram[17] ,
    \din0_to_sram[16] ,
    \din0_to_sram[15] ,
    \din0_to_sram[14] ,
    \din0_to_sram[13] ,
    \din0_to_sram[12] ,
    \din0_to_sram[11] ,
    \din0_to_sram[10] ,
    \din0_to_sram[9] ,
    \din0_to_sram[8] ,
    \din0_to_sram[7] ,
    \din0_to_sram[6] ,
    \din0_to_sram[5] ,
    \din0_to_sram[4] ,
    \din0_to_sram[3] ,
    \din0_to_sram[2] ,
    \din0_to_sram[1] ,
    \din0_to_sram[0] }),
    .q({\dout0_to_sram[31] ,
    \dout0_to_sram[30] ,
    \dout0_to_sram[29] ,
    \dout0_to_sram[28] ,
    \dout0_to_sram[27] ,
    \dout0_to_sram[26] ,
    \dout0_to_sram[25] ,
    \dout0_to_sram[24] ,
    \dout0_to_sram[23] ,
    \dout0_to_sram[22] ,
    \dout0_to_sram[21] ,
    \dout0_to_sram[20] ,
    \dout0_to_sram[19] ,
    \dout0_to_sram[18] ,
    \dout0_to_sram[17] ,
    \dout0_to_sram[16] ,
    \dout0_to_sram[15] ,
    \dout0_to_sram[14] ,
    \dout0_to_sram[13] ,
    \dout0_to_sram[12] ,
    \dout0_to_sram[11] ,
    \dout0_to_sram[10] ,
    \dout0_to_sram[9] ,
    \dout0_to_sram[8] ,
    \dout0_to_sram[7] ,
    \dout0_to_sram[6] ,
    \dout0_to_sram[5] ,
    \dout0_to_sram[4] ,
    \dout0_to_sram[3] ,
    \dout0_to_sram[2] ,
    \dout0_to_sram[1] ,
    \dout0_to_sram[0] }));
endmodule
