
# ==================================================================================================
# block_design.tcl
# Holds the blockdesign for the project
#
# by Noah Huesser <yatekii@yatekii.ch>
# based on Anton Potocnik, 02.10.2016 - 08.01.2017
# based on Pavel Demin's 'red-pitaya-notes-master' git repo
# ==================================================================================================

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

# signal split
add_files -norecurse $project_name/axis_to_data_lanes.vhd
create_bd_cell -type module -reference axis_to_data_lanes adc_to_osc

create_bd_cell -type ip -vlnv noah.huesser:user:zynq_logger:1.1 zynq_logger_0

# interconn

# startgroup
# create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
# endgroup

# connect_bd_intf_net [get_bd_intf_pins processing_system7_0/S_AXI_HP0] -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M00_AXI]
# set_property location {1 93 264} [get_bd_cells zynq_logger_0]
# connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins zynq_logger_0/M0]

# connect_bd_net [get_bd_pins axis_red_pitaya_adc_0/adc_clk] [get_bd_pins zynq_logger_0/ClkxCI]
# connect_bd_net [get_bd_pins zynq_logger_0/MAxiClkxCI] [get_bd_pins processing_system7_0/FCLK_CLK0]
# connect_bd_net [get_bd_pins zynq_logger_0/SAxiAClkxCI] [get_bd_pins processing_system7_0/FCLK_CLK0]
# connect_bd_net [get_bd_pins zynq_logger_0/MAxiRstxRBI] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
# connect_bd_net [get_bd_pins zynq_logger_0/SAxiAResetxRBI] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
# connect_bd_net [get_bd_pins adc_to_osc/DataStrobexDO] [get_bd_pins zynq_logger_0/DataStrobexSI]
# connect_bd_net [get_bd_pins adc_to_osc/DataxDO] [get_bd_pins zynq_logger_0/Data0xDI]
# connect_bd_net [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0]
# connect_bd_net [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins processing_system7_0/FCLK_RESET0_N]