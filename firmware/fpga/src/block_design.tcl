
# ==================================================================================================
# block_design.tcl
# Holds the blockdesign for the project
#
# by Noah Huesser <yatekii@yatekii.ch>
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
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 system_rst

# AXI Interconnect
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect
set_property -dict [list CONFIG.NUM_MI {2}] [get_bd_cells interconnect]
set_property -dict [list CONFIG.NUM_SI {2}] [get_bd_cells interconnect]

# Module to convert the ADC AXI Stream data to the data lanes the Logger Core requires
startgroup
create_bd_cell -type ip -vlnv noah-huesser:user:axis_to_data_lanes:1.0 axis2lanes
endgroup

# The Logger module
startgroup
create_bd_cell -type ip -vlnv noah.huesser:user:zynq_logger:1.1 logger
endgroup

# ====================================================================================
# Connections

# Connect ADC to AXIS to Data Lanes
connect_bd_intf_net [get_bd_intf_pins adc/M_AXIS] [get_bd_intf_pins axis2lanes/SI]

# Connect Logger to ZYNQ7 Processing System
connect_bd_net [get_bd_pins logger/MAxiClkxCI] [get_bd_pins ps/FCLK_CLK0]
connect_bd_net [get_bd_pins logger/MAxiRstxRBI] [get_bd_pins ps/FCLK_RESET0_N]
connect_bd_net [get_bd_pins logger/SAxiAClkxCI] [get_bd_pins ps/FCLK_CLK0]
connect_bd_net [get_bd_pins logger/SAxiAResetxRBI] [get_bd_pins ps/FCLK_RESET0_N]
connect_bd_net [get_bd_pins logger/ClkxCI] [get_bd_pins axis2lanes/DataClkxCO]

# Logger to Clocking Wizard
connect_bd_net [get_bd_pins axis2lanes/DataClkxCI] [get_bd_pins clk_wiz_adc/clk_out1]

# ADC to Logger
connect_bd_net [get_bd_pins logger/Data0xDI] [get_bd_pins axis2lanes/Data0xDO]
connect_bd_net [get_bd_pins axis2lanes/Data1xDO] [get_bd_pins logger/Data1xDI]
connect_bd_net [get_bd_pins axis2lanes/DataStrobexDO] [get_bd_pins logger/DataStrobexSI]

# ZYNQ7 Processing System to Interconnect
connect_bd_intf_net [get_bd_intf_pins ps/S_AXI_HP0] -boundary_type upper [get_bd_intf_pins interconnect/M00_AXI]
connect_bd_intf_net [get_bd_intf_pins ps/M_AXI_GP0] -boundary_type upper [get_bd_intf_pins interconnect/S01_AXI]

# ZYNQ7 Processing System to Zynq Logger
connect_bd_net [get_bd_pins ps/Core0_nIRQ] [get_bd_pins logger/IRQxSO]

# AXI Interconnect Clocks
connect_bd_net [get_bd_pins interconnect/ACLK] [get_bd_pins ps/FCLK_CLK0]
connect_bd_net [get_bd_pins interconnect/S00_ACLK] [get_bd_pins ps/FCLK_CLK0]
connect_bd_net [get_bd_pins interconnect/M00_ACLK] [get_bd_pins ps/FCLK_CLK0]

# AXI Interconnect Resets
connect_bd_net [get_bd_pins interconnect/ARESETN] [get_bd_pins system_rst/interconnect_aresetn]
connect_bd_net [get_bd_pins interconnect/S00_ARESETN] [get_bd_pins system_rst/peripheral_aresetn]
connect_bd_net [get_bd_pins interconnect/M00_ARESETN] [get_bd_pins system_rst/peripheral_aresetn]

# Processing System to System Reset
connect_bd_net [get_bd_pins ps/FCLK_RESET0_N] [get_bd_pins system_rst/aux_reset_in]

# Logger to interconnect
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins interconnect/M01_AXI] [get_bd_intf_pins logger/S0]
connect_bd_intf_net [get_bd_intf_pins logger/M0] -boundary_type upper [get_bd_intf_pins interconnect/S00_AXI]
