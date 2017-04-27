# ==================================================================================================
# make_project.tcl
#
# A simple script for creating a Vivado project from the project/ folder 
#
# by Noah Huesser <yatekii@yatekii.ch>
# based on Anton Potocnik, 02.10.2016 - 08.01.2017
# based on Pavel Demin's 'red-pitaya-notes-master' git repo
# ==================================================================================================

set project_name "src"

source $project_name/block_design.tcl

# changes in gui
# regenerate_bd_layout
# create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0
# startgroup
# current_project src
# endgroup
# delete_bd_objs [get_bd_nets clk_wiz_adc_clk_out1]
# connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins adc/aclk]
# delete_bd_objs [get_bd_intf_nets adc_M_AXIS]
# set_property location {2 434 -67} [get_bd_cells axis_clock_converter_0]
# connect_bd_intf_net [get_bd_intf_pins axis2lanes/SI] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
# connect_bd_intf_net [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins adc/M_AXIS]
# connect_bd_net [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins system_rst/peripheral_aresetn]
# connect_bd_net [get_bd_pins axis_clock_converter_0/m_axis_aresetn] [get_bd_pins system_rst/peripheral_aresetn]
# current_project adc_test
# current_project src
# connect_bd_net [get_bd_pins axis_clock_converter_0/m_axis_aclk] [get_bd_pins ps/FCLK_CLK0]
# connect_bd_net [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins clk_wiz_adc/clk_out1]