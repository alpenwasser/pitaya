# ==================================================================================================
# block_design.tcl
# Holds the blockdesign for the project
#
# by Noah Huesser <yatekii@yatekii.ch>
# by Raphael Frey <rmfrey@alpenwasser.net>
# based on Anton Potocnik, 02.10.2016 - 08.01.2017
# based on Pavel Demin's 'red-pitaya-notes-master' git repo
# ==================================================================================================

# Create the directory where the main block design will reside in
set part_name xc7z010clg400-1
set bd_path build/$project_name/$project_name.srcs/sources_1/bd/system

# Delete previous project files
file delete -force build/$project_name

# Create a new project
create_project $project_name build/$project_name -part $part_name -force

# Create a new block design for the toplevel
create_bd_design system

# ====================================================================================
# IP repos
# current_dir: resolves to firmware/fpga/build/src
set current_dir [get_property DIRECTORY [current_project]]
set_property  ip_repo_paths  {build/cores zynq_logger/build/fpga} [current_project]
update_ip_catalog

# Create basic Red Pitaya Block Design
source $project_name/basic_red_pitaya_bd.tcl

# ====================================================================================
# RTL modules

# Set up processing system
set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_IRQ_F2P_INTR {1} CONFIG.PCW_CORE0_IRQ_INTR {0}] [get_bd_cells ps]

# System processor Reset
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 system_rst

# Blinking LED & slow clock
create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 Cnt2Hz
set_property -dict [list CONFIG.Output_Width {32}] [get_bd_cells Cnt2Hz]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Slc2Hz
set_property -dict [list CONFIG.DIN_TO {26}] [get_bd_cells Slc2Hz]
set_property -dict [list CONFIG.DIN_FROM {26}] [get_bd_cells Slc2Hz]
set_property -dict [list CONFIG.DOUT_WIDTH {1}] [get_bd_cells Slc2Hz]

# AXI Protocol Converters
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 M2Sconverter
set_property -dict [list CONFIG.MI_PROTOCOL.VALUE_SRC USER CONFIG.SI_PROTOCOL.VALUE_SRC USER] [get_bd_cells M2Sconverter]
set_property -dict [list CONFIG.MI_PROTOCOL.VALUE_SRC USER CONFIG.SI_PROTOCOL.VALUE_SRC USER] [get_bd_cells M2Sconverter]
set_property -dict [list CONFIG.SI_PROTOCOL {AXI4LITE}] [get_bd_cells M2Sconverter]
set_property -dict [list CONFIG.MI_PROTOCOL {AXI3}] [get_bd_cells M2Sconverter]
set_property -dict [list CONFIG.TRANSLATION_MODE {2}] [get_bd_cells M2Sconverter]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 S2Mconverter

# Module to convert the ADC AXI Stream data to the data lanes the Logger Core requires
create_bd_cell -type ip -vlnv noah-huesser:user:axis_to_data_lanes:1.0 axis2lanes
set_property -dict [list CONFIG.Decimation {25}] [get_bd_cells axis2lanes]

# The Logger module
create_bd_cell -type ip -vlnv bastli:user:zynq_logger:1.1 logger

# Multiplexers
set mux0 axis_multiplexer_0
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux0

# Broadcaster
set cast0 axis_broadcaster_0

create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 $cast0
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES.VALUE_SRC USER CONFIG.S_TDATA_NUM_BYTES.VALUE_SRC USER CONFIG.HAS_TREADY.VALUE_SRC USER] [get_bd_cells $cast0]
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {4} CONFIG.S_TDATA_NUM_BYTES {4} CONFIG.M00_TDATA_REMAP {tdata[31:0]} CONFIG.M01_TDATA_REMAP {tdata[31:0]}] [get_bd_cells $cast0]

# ====================================================================================
# Connections

# Distribute Clocks
connect_bd_net [get_bd_pins system_rst/slowest_sync_clk] [get_bd_pins clk_wiz_adc/clk_out1]
connect_bd_net [get_bd_pins S2Mconverter/aclk] [get_bd_pins clk_wiz_adc/clk_out1]
connect_bd_net [get_bd_pins M2Sconverter/aclk] [get_bd_pins clk_wiz_adc/clk_out1]
connect_bd_net [get_bd_pins axis2lanes/ClkxCI] [get_bd_pins clk_wiz_adc/clk_out1]
connect_bd_net [get_bd_pins logger/MAxiClkxCI] [get_bd_pins clk_wiz_adc/clk_out1]
connect_bd_net [get_bd_pins logger/SAxiAClkxCI] [get_bd_pins clk_wiz_adc/clk_out1]
connect_bd_net [get_bd_pins logger/ClkxCI] [get_bd_pins clk_wiz_adc/clk_out1]
connect_bd_net [get_bd_pins ps/M_AXI_GP0_ACLK] [get_bd_pins ps/S_AXI_HP0_ACLK]
connect_bd_net [get_bd_pins ps/M_AXI_GP0_ACLK] [get_bd_pins clk_wiz_adc/clk_out1]
connect_bd_net [get_bd_pins system_rst/ext_reset_in] [get_bd_pins clk_wiz_adc/locked]

# Distribute Resets
connect_bd_net [get_bd_pins system_rst/peripheral_aresetn] [get_bd_pins axis2lanes/RstxRBI]
connect_bd_net [get_bd_pins logger/MAxiRstxRBI] [get_bd_pins system_rst/peripheral_aresetn]
connect_bd_net [get_bd_pins logger/SAxiAResetxRBI] [get_bd_pins system_rst/peripheral_aresetn]
connect_bd_net [get_bd_pins M2Sconverter/aresetn] [get_bd_pins system_rst/interconnect_aresetn]
connect_bd_net [get_bd_pins S2Mconverter/aresetn] [get_bd_pins system_rst/interconnect_aresetn]

# Blinking LED
connect_bd_net [get_bd_pins Cnt2Hz/Q] [get_bd_pins Slc2Hz/Din]
connect_bd_net [get_bd_ports led_o] [get_bd_pins Slc2Hz/Dout]
connect_bd_net [get_bd_pins Cnt2Hz/CLK] [get_bd_pins clk_wiz_adc/clk_out1]

# Connect ADC to AXIS to Data Lanes
#connect_bd_intf_net [get_bd_intf_pins adc/M_AXIS] [get_bd_intf_pins axis2lanes/SI]

# ADC to Logger
connect_bd_net [get_bd_pins logger/Data0xDI] [get_bd_pins axis2lanes/Data0xDO]
connect_bd_net [get_bd_pins axis2lanes/Data1xDO] [get_bd_pins logger/Data1xDI]

# ZYNQ7 Processing System to Zynq Logger
connect_bd_net [get_bd_pins ps/IRQ_F2P] [get_bd_pins logger/IRQxSO]

# Clock & DataStrobe to Logger
connect_bd_net [get_bd_pins logger/DataStrobexSI] [get_bd_pins axis2lanes/DataStrobexDO]

# AXI Converters
connect_bd_intf_net [get_bd_intf_pins M2Sconverter/M_AXI] [get_bd_intf_pins ps/S_AXI_HP0]
connect_bd_intf_net [get_bd_intf_pins M2Sconverter/S_AXI] [get_bd_intf_pins logger/M0]
connect_bd_intf_net [get_bd_intf_pins S2Mconverter/S_AXI] [get_bd_intf_pins ps/M_AXI_GP0]
connect_bd_intf_net [get_bd_intf_pins S2Mconverter/M_AXI] [get_bd_intf_pins logger/S0]

# Filter Chain
connect_bd_intf_net [get_bd_intf_pins adc/M_AXIS] [get_bd_intf_pins $cast0/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins $cast0/M00_AXIS] [get_bd_intf_pins $mux0/SI0]
connect_bd_intf_net [get_bd_intf_pins $mux0/MO] [get_bd_intf_pins axis2lanes/SI]
# clock and reset for broadcaster
connect_bd_net [get_bd_pins $cast0/aclk] [get_bd_pins clk_wiz_adc/clk_out1]
connect_bd_net [get_bd_pins $cast0/aresetn] [get_bd_pins S2Mconverter/aresetn]
# clock and reset for multiplexer
connect_bd_net [get_bd_pins $mux0/ClkxCI] [get_bd_pins clk_wiz_adc/clk_out1]
connect_bd_net [get_bd_pins $mux0/RstxRBI] [get_bd_pins system_rst/interconnect_aresetn]

# Assign Address to Logger MMIO Slave
assign_bd_address [get_bd_addr_segs {logger/S0/Reg }]

# Pita Basic
generate_target all [get_files  $bd_path/system.bd]
make_wrapper -files [get_files $bd_path/system.bd] -top
add_files -norecurse $bd_path/hdl/system_wrapper.v

# Load RedPitaya constraint files
set files [glob -nocomplain cfg/*.xdc]
if {[llength $files] > 0} {
  add_files -norecurse -fileset constrs_1 $files
}

# TODO: figure out what this does
set_property VERILOG_DEFINE {TOOL_VIVADO} [current_fileset]
set_property STRATEGY Flow_PerfOptimized_High [get_runs synth_1]
set_property STRATEGY Performance_NetDelay_high [get_runs impl_1]
# TODO: figure out what this does


save_bd_design
