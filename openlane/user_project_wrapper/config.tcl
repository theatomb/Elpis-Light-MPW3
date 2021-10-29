# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

# Base Configurations. Don't Touch
# section begin

# YOU ARE NOT ALLOWED TO CHANGE ANY VARIABLES DEFINED IN THE FIXED WRAPPER CFGS 
source $::env(CARAVEL_ROOT)/openlane/user_project_wrapper_empty/fixed_wrapper_cfgs.tcl

# YOU CAN CHANGE ANY VARIABLES DEFINED IN THE DEFAULT WRAPPER CFGS BY OVERRIDING THEM IN THIS CONFIG.TCL
source $::env(CARAVEL_ROOT)/openlane/user_project_wrapper_empty/default_wrapper_cfgs.tcl

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_project_wrapper
#section end

# User Configurations

## Source Verilog Files
set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_project_wrapper.v"

## Clock configurations
set ::env(CLOCK_PORT) "user_clock2"
set ::env(CLOCK_NET) "mprj.clk"

set ::env(CLOCK_PERIOD) "10"

## Internal Macros
### Macro PDN Connections
set ::env(FP_PDN_MACRO_HOOKS) "\
	mprj vccd1 vssd1"

### Macro Placement
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_proj_example.v \
	$script_dir/../../verilog/rtl/elpis/alu.v \
	$script_dir/../../verilog/rtl/elpis/arbiter.v \
	$script_dir/../../verilog/rtl/elpis/betweenStages.v \
	$script_dir/../../verilog/rtl/elpis/branchComparer.v \
	$script_dir/../../verilog/rtl/elpis/cache.v \
	$script_dir/../../verilog/rtl/elpis/controlunit.v \
	$script_dir/../../verilog/rtl/elpis/core.v \
	$script_dir/../../verilog/rtl/elpis/datapath.v \
	$script_dir/../../verilog/rtl/elpis/decoder.v \
	$script_dir/../../verilog/rtl/elpis/definitions.v \
	$script_dir/../../verilog/rtl/elpis/drivers.v \
	$script_dir/../../verilog/rtl/elpis/forwardingunit.v \
	$script_dir/../../verilog/rtl/elpis/hazardDetectionUnit.v \
	$script_dir/../../verilog/rtl/elpis/hf.v \
	$script_dir/../../verilog/rtl/elpis/IO_arbiter.v \
	$script_dir/../../verilog/rtl/elpis/memory.v \
	$script_dir/../../verilog/rtl/elpis/muldiv.v \
	$script_dir/../../verilog/rtl/elpis/regfile.v \
	$script_dir/../../verilog/rtl/elpis/specialreg.v \
	$script_dir/../../verilog/rtl/elpis/storebuffer.v \
	$script_dir/../../verilog/rtl/elpis/tlb.v \
	$script_dir/../../verilog/rtl/elpis/top.v \
	$script_dir/../../verilog/rtl/elpis/utils.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/user_proj_example.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/user_proj_example.gds"

set ::env(GLB_RT_MAXLAYER) 5

# disable pdn check nodes becuase it hangs with multiple power domains.
# any issue with pdn connections will be flagged with LVS so it is not a critical check.
set ::env(FP_PDN_CHECK_NODES) 0

# The following is because there are no std cells in the example wrapper project.
set ::env(SYNTH_TOP_LEVEL) 1
set ::env(PL_RANDOM_GLB_PLACEMENT) 1

set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 0
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0

set ::env(FP_PDN_ENABLE_RAILS) 0

set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(FILL_INSERTION) 0
set ::env(TAP_DECAP_INSERTION) 0
set ::env(CLOCK_TREE_SYNTH) 0
