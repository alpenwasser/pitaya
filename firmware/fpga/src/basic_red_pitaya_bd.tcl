# ==================================================================================================
# basic_red_pitaya_bd.tcl
#
# This script creates a new Vivado project and creates interface pins to the Red Pitaya external hardware.
#
# This script is modification of Pavel Demin's project.tcl and block_design.tcl files
# by Anton Potocnik, 29.11.2016
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

# Load the Red Pitaya ports specifications
source cfg/ports.tcl

# Set the path to the custom IP cores and update the IP catalog
set_property IP_REPO_PATHS build/cores [current_project]
update_ip_catalog

# Load any additional Verilog and VHDL files in the project folder
set files [glob -nocomplain projects/$project_name/*.v projects/$project_name/*.sv rojects/$project_name/*.vhd]
if {[llength $files] > 0} {
  add_files -norecurse $files
}

# ====================================================================================
# Adding Red Pitaya specific IP cores

# Zynq processing system
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {1}] [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.PCW_IMPORT_BOARD_PRESET {cfg/red_pitaya.xml}] [get_bd_cells processing_system7_0]
endgroup

# Buffers for differential IOs - Daisychain
#startgroup
#create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_1
#set_property -dict [list CONFIG.C_SIZE {2}] [get_bd_cells util_ds_buf_1]

#create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_2
#set_property -dict [list CONFIG.C_SIZE {2}] [get_bd_cells util_ds_buf_2]
#set_property -dict [list CONFIG.C_BUF_TYPE {OBUFDS}] [get_bd_cells util_ds_buf_2]
#endgroup

# AXI GPIO IP core
#startgroup
#create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
#set_property -dict [list CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_INPUTS_2 {1}] [get_bd_cells axi_gpio_0]
#endgroup

# axis_red_pitaya_adc
startgroup
create_bd_cell -type ip -vlnv pavel-demin:user:axis_red_pitaya_adc:1.0 axis_red_pitaya_adc_0
endgroup

# axis_red_pitaya_dac
#startgroup
#create_bd_cell -type ip -vlnv pavel-demin:user:axis_red_pitaya_dac:1.0 axis_red_pitaya_dac_0
#endgroup

# clocking_wizard
#startgroup
#create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 clk_wiz_0
#set_property -dict [list CONFIG.PRIM_IN_FREQ.VALUE_SRC USER] [get_bd_cells clk_wiz_0]
#set_property -dict [list CONFIG.PRIM_IN_FREQ {125.000} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250.000} CONFIG.USE_RESET {false} CONFIG.CLKIN1_JITTER_PS {80.0} CONFIG.MMCM_DIVCLK_DIVIDE {1} CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} CONFIG.MMCM_CLKIN1_PERIOD {8.0} CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.000} CONFIG.CLKOUT1_JITTER {104.759} CONFIG.CLKOUT1_PHASE_ERROR {96.948}] [get_bd_cells clk_wiz_0]
#endgroup

# DDS (Sine generator)
#startgroup
#create_bd_cell -type ip -vlnv xilinx.com:ip:dds_compiler:6.0 dds_compiler_0
#set_property -dict [list CONFIG.PartsPresent {Phase_Generator_and_SIN_COS_LUT} CONFIG.Parameter_Entry {System_Parameters} CONFIG.Spurious_Free_Dynamic_Range {84} CONFIG.Frequency_Resolution {0.5} CONFIG.Amplitude_Mode {Unit_Circle} CONFIG.DDS_Clock_Rate {125} CONFIG.Noise_Shaping {Auto} CONFIG.Phase_Width {28} CONFIG.Output_Width {14} CONFIG.Has_Phase_Out {false} CONFIG.DATA_Has_TLAST {Not_Required} CONFIG.S_PHASE_Has_TUSER {Not_Required} CONFIG.M_DATA_Has_TUSER {Not_Required} CONFIG.Latency {8} CONFIG.Output_Frequency1 {3.90625} CONFIG.PINC1 {0}] [get_bd_cells dds_compiler_0]
#endgroup

# ====================================================================================
# Connections 

# Daisy chain
#connect_bd_net [get_bd_ports daisy_p_i] [get_bd_pins util_ds_buf_1/IBUF_DS_P]
#connect_bd_net [get_bd_ports daisy_n_i] [get_bd_pins util_ds_buf_1/IBUF_DS_N]
#connect_bd_net [get_bd_ports daisy_p_o] [get_bd_pins util_ds_buf_2/OBUF_DS_P]
#connect_bd_net [get_bd_ports daisy_n_o] [get_bd_pins util_ds_buf_2/OBUF_DS_N]

# TODO: figure out what this does
#connect_bd_net [get_bd_pins util_ds_buf_1/IBUF_OUT] [get_bd_pins util_ds_buf_2/OBUF_IN]

apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
connect_bd_net [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0]
connect_bd_net [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0]
# TODO: figure out what this does

# ADC
connect_bd_net [get_bd_ports adc_clk_p_i] [get_bd_pins axis_red_pitaya_adc_0/adc_clk_p]
connect_bd_net [get_bd_ports adc_clk_n_i] [get_bd_pins axis_red_pitaya_adc_0/adc_clk_n]
connect_bd_net [get_bd_ports adc_dat_a_i] [get_bd_pins axis_red_pitaya_adc_0/adc_dat_a]
connect_bd_net [get_bd_ports adc_dat_b_i] [get_bd_pins axis_red_pitaya_adc_0/adc_dat_b]
connect_bd_net [get_bd_ports adc_csn_o] [get_bd_pins axis_red_pitaya_adc_0/adc_csn]

# DAC
#connect_bd_net [get_bd_ports dac_clk_o] [get_bd_pins axis_red_pitaya_dac_0/dac_clk]
#connect_bd_net [get_bd_ports dac_rst_o] [get_bd_pins axis_red_pitaya_dac_0/dac_rst]
#connect_bd_net [get_bd_ports dac_sel_o] [get_bd_pins axis_red_pitaya_dac_0/dac_sel]
#connect_bd_net [get_bd_ports dac_wrt_o] [get_bd_pins axis_red_pitaya_dac_0/dac_wrt]
#connect_bd_net [get_bd_ports dac_dat_o] [get_bd_pins axis_red_pitaya_dac_0/dac_dat]
#connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins axis_red_pitaya_dac_0/locked]
#connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins axis_red_pitaya_dac_0/ddr_clk]
#connect_bd_net [get_bd_pins axis_red_pitaya_dac_0/aclk] [get_bd_pins axis_red_pitaya_adc_0/adc_clk]
#connect_bd_intf_net [get_bd_intf_pins dds_compiler_0/M_AXIS_DATA] [get_bd_intf_pins axis_red_pitaya_dac_0/S_AXIS]
#connect_bd_net [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins dds_compiler_0/aclk]
#connect_bd_net [get_bd_pins dds_compiler_0/aclk] [get_bd_pins axis_red_pitaya_adc_0/adc_clk]

# TODO: figure out what this does
#apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_gpio_0/S_AXI]
#set_property offset 0x42000000 [get_bd_addr_segs {processing_system7_0/Data/SEG_axi_gpio_0_Reg}]
#set_property range 4K [get_bd_addr_segs {processing_system7_0/Data/SEG_axi_gpio_0_Reg}]
# TODO: figure out what this does

# ====================================================================================
# Generate output products and wrapper, add constraint 

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
