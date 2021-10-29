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

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) alu

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/elpis/definitions.v \
	$script_dir/../../verilog/rtl/elpis/alu.v"


set ::env(DESIGN_IS_CORE) 0

set ::env(CLOCK_TREE_SYNTH) 0
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_NET) "clk"
set ::env(CLOCK_PERIOD) "10"

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 1200 1200"

#set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(PL_BASIC_PLACEMENT) 1
set ::env(PL_TARGET_DENSITY) 0.1
set ::env(FP_CORE_UTIL) "50"

#set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) 0

#Core worked alone with this, crash at step 15 instead of 11. [ERROR GRT-0167] Invalid 2D tree for net _17248_. It also worked with core and & mem(128) togetther without any crash message
#set ::env(PL_TARGET_DENSITY) 0.1
#set ::env(FP_CORE_UTIL) "5"
#set ::env(CLOCK_PERIOD) "550"

#Memory worked alone with this
#set ::env(PL_TARGET_DENSITY) 0.3
#set ::env(FP_CORE_UTIL) "5"

# Maximum layer used for routing is metal 4.
# This is because this macro will be inserted in a top level (user_project_wrapper) 
# where the PDN is planned on metal 5. So, to avoid having shorts between routes
# in this macro and the top level metal 5 stripes, we have to restrict routes to metal4.  
set ::env(GLB_RT_MAXLAYER) 5

# You can draw more power domains if you need to 
set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]

set ::env(DIODE_INSERTION_STRATEGY) 4 
# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 1

set ::env(ROUTING_CORES) 6
