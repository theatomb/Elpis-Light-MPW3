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
 wire is_loading_memory_into_core;
 wire print_hex_enable;
 wire \print_output[0] ;
 wire \print_output[10] ;
 wire \print_output[11] ;
 wire \print_output[12] ;
 wire \print_output[13] ;
 wire \print_output[14] ;
 wire \print_output[15] ;
 wire \print_output[16] ;
 wire \print_output[17] ;
 wire \print_output[18] ;
 wire \print_output[19] ;
 wire \print_output[1] ;
 wire \print_output[20] ;
 wire \print_output[21] ;
 wire \print_output[22] ;
 wire \print_output[23] ;
 wire \print_output[24] ;
 wire \print_output[25] ;
 wire \print_output[26] ;
 wire \print_output[27] ;
 wire \print_output[28] ;
 wire \print_output[29] ;
 wire \print_output[2] ;
 wire \print_output[30] ;
 wire \print_output[31] ;
 wire \print_output[3] ;
 wire \print_output[4] ;
 wire \print_output[5] ;
 wire \print_output[6] ;
 wire \print_output[7] ;
 wire \print_output[8] ;
 wire \print_output[9] ;
 wire read_enable_to_Elpis;
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
 wire reset_core;
 wire rst;

 chip_controller chip_controller (.clk(clk),
    .is_loading_memory_into_core(is_loading_memory_into_core),
    .output_enabled_from_elpis_to_controller(print_hex_enable),
    .read_enable_to_Elpis(read_enable_to_Elpis),
    .reset_core(reset_core),
    .rst(rst),
    .vccd1(vssa1),
    .vssd1(vssd1),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
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
    .output_data_from_elpis_to_controller({\print_output[31] ,
    \print_output[30] ,
    \print_output[29] ,
    \print_output[28] ,
    \print_output[27] ,
    \print_output[26] ,
    \print_output[25] ,
    \print_output[24] ,
    \print_output[23] ,
    \print_output[22] ,
    \print_output[21] ,
    \print_output[20] ,
    \print_output[19] ,
    \print_output[18] ,
    \print_output[17] ,
    \print_output[16] ,
    \print_output[15] ,
    \print_output[14] ,
    \print_output[13] ,
    \print_output[12] ,
    \print_output[11] ,
    \print_output[10] ,
    \print_output[9] ,
    \print_output[8] ,
    \print_output[7] ,
    \print_output[6] ,
    \print_output[5] ,
    \print_output[4] ,
    \print_output[3] ,
    \print_output[2] ,
    \print_output[1] ,
    \print_output[0] }),
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
    wbs_dat_o[0]}));
endmodule
