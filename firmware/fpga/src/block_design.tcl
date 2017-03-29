
# ==================================================================================================
# block_design.tcl
# Holds the blockdesign for the project
#
# by Noah Huesser <yatekii@yatekii.ch>
# based on Anton Potocnik, 02.10.2016 - 08.01.2017
# based on Pavel Demin's 'red-pitaya-notes-master' git repo
# ==================================================================================================

# ====================================================================================
# IP repos
set currrent_dir [get_property DIRECTORY [current_project]]
set_property  ip_repo_paths  {build/cores $current_dir/../../../../logger} [current_project]
update_ip_catalog

# Create basic Red Pitaya Block Design
source $project_name/basic_red_pitaya_bd.tcl

# ====================================================================================
# IP cores

# Binary Counter - 32bit
#startgroup
#create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0
#set_property -dict [list CONFIG.Output_Width {32}] [get_bd_cells c_counter_binary_0]
#endgroup

# Constant for AXIS aresetn
#startgroup
#create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlc_reset
#endgroup

# ====================================================================================
# RTL modules

# System rocessor Reset
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0

# AXI Interconnect
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0

# Module to convert the ADC AXI Stream data to the data lanes the Logger Core requires
startgroup
create_bd_cell -type ip -vlnv noah-huesser:user:axis_to_data_lanes:1.0 axis_to_data_lanes_0
endgroup

# The Logger module
startgroup
create_bd_cell -type ip -vlnv noah.huesser:user:zynq_logger:1.1 zynq_logger_0
endgroup

# ====================================================================================
# Connections

# Connect ADC to AXIS to Data Lanes
connect_bd_intf_net [get_bd_intf_pins adc/M_AXIS] [get_bd_intf_pins axis_to_data_lanes_0/SI]

# Connect Logger to ZYNQ7 Processing System
connect_bd_net [get_bd_pins zynq_logger_0/MAxiClkxCI] [get_bd_pins processing_system7_0/FCLK_CLK0]
connect_bd_net [get_bd_pins zynq_logger_0/MAxiRstxRBI] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
connect_bd_net [get_bd_pins zynq_logger_0/SAxiAClkxCI] [get_bd_pins processing_system7_0/FCLK_CLK0]
connect_bd_net [get_bd_pins zynq_logger_0/SAxiAResetxRBI] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
connect_bd_net [get_bd_pins zynq_logger_0/ClkxCI] [get_bd_pins axis_to_data_lanes_0/DataClkxCO]

# Logger to Clocking Wizard
connect_bd_net [get_bd_pins axis_to_data_lanes_0/DataClkxCI] [get_bd_pins clk_wiz_adc/clk_out1]

# ADC to Logger
connect_bd_net [get_bd_pins zynq_logger_0/Data0xDI] [get_bd_pins axis_to_data_lanes_0/Data0xDO]
connect_bd_net [get_bd_pins axis_to_data_lanes_0/Data1xDO] [get_bd_pins zynq_logger_0/Data1xDI]
connect_bd_net [get_bd_pins axis_to_data_lanes_0/DataStrobexDO] [get_bd_pins zynq_logger_0/DataStrobexSI]