
# ==================================================================================================
# block_design.tcl
# Holds the blockdesign for the project
#
# by Noah Huesser <yatekii@yatekii.ch>
# based on Anton Potocnik, 02.10.2016 - 08.01.2017
# based on Pavel Demin's 'red-pitaya-notes-master' git repo
# ==================================================================================================

# Create basic Red Pitaya Block Design
source projects/$project_name/basic_red_pitaya_bd.tcl

# ====================================================================================
# IP cores

# Binary Counter - 32bit
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0
set_property -dict [list CONFIG.Output_Width {32}] [get_bd_cells c_counter_binary_0]
endgroup

# Constant for AXIS aresetn
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlc_reset
endgroup

# ====================================================================================
# RTL modules

# signal split
create_bd_cell -type module -reference axis_to_data_lanes adc_to_osc