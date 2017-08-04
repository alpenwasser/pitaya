# ==================================================================================================
# block_design.tcl
# Holds the blockdesign for the project
#
# by Noah Huesser <yatekii@yatekii.ch>
# by Raphael Frey <rmfrey@alpenwasser.net>
# based on Anton Potocnik, 02.10.2016 - 08.01.2017
# based on Pavel Demin's 'red-pitaya-notes-master' git repo
# ==================================================================================================

# ====================================================================================
#
# 								P R O J E C T   I N I T
#
# ====================================================================================

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
#
# 								   I P   R E P O S
#
# ====================================================================================

# current_dir: resolves to firmware/fpga/build/src
set current_dir [get_property DIRECTORY [current_project]]
set_property  ip_repo_paths  {build/cores zynq_logger/build/fpga} [current_project]
update_ip_catalog

if {$sim eq ""} {
 	# Create basic Red Pitaya Block Design
 	puts "Starting a normal project!"
	source $project_name/basic_red_pitaya_bd.tcl
} else {
	# Create basic Sim Block Design
	puts "Starting a simulation project!"
	source $project_name/basic_sim_bd.tcl
}

# ====================================================================================
#
# 								   I N C L U D E S
#
# ====================================================================================

source $project_name/functions.tcl

# ====================================================================================
#
# 			I N S T A N T I A T E   S P E C I F I C   C O M P O N E N T S
#
# ====================================================================================

if {$sim eq ""} {

 	# FPGA project only clk / rst
 	set clk_src clk_wiz_adc/clk_out1
 	set rst_src system_rst/interconnect_aresetn

 	# Set up processing system (created in basic_red_pitaya_bd.tcl)
 	set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_IRQ_F2P_INTR {1} CONFIG.PCW_CORE0_IRQ_INTR {0}] [get_bd_cells ps]

 	# Instantiate System Processor Reset
	create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 system_rst

	# Instantiate Blinking LED & Slow Clock
	create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 Cnt2Hz
	set_property -dict [list CONFIG.Output_Width {32}] [get_bd_cells Cnt2Hz]
	create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Slc2Hz
	set_property -dict [list CONFIG.DIN_TO {26}] [get_bd_cells Slc2Hz]
	set_property -dict [list CONFIG.DIN_FROM {26}] [get_bd_cells Slc2Hz]
	set_property -dict [list CONFIG.DOUT_WIDTH {1}] [get_bd_cells Slc2Hz]

	# Instantiate and set up AXI Protocol Converters
	create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 M2Sconverter
	set_property -dict [list CONFIG.MI_PROTOCOL.VALUE_SRC USER CONFIG.SI_PROTOCOL.VALUE_SRC USER] [get_bd_cells M2Sconverter]
	set_property -dict [list CONFIG.MI_PROTOCOL.VALUE_SRC USER CONFIG.SI_PROTOCOL.VALUE_SRC USER] [get_bd_cells M2Sconverter]
	set_property -dict [list CONFIG.SI_PROTOCOL {AXI4LITE}] [get_bd_cells M2Sconverter]
	set_property -dict [list CONFIG.MI_PROTOCOL {AXI3}] [get_bd_cells M2Sconverter]
	set_property -dict [list CONFIG.TRANSLATION_MODE {2}] [get_bd_cells M2Sconverter]
	create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 S2Mconverter

	# Instantiate the Logger module
	create_bd_cell -type ip -vlnv bastli:user:zynq_logger:1.1 logger

} else {

	# Sim project only clk / rst
	set clk_src clk_gen/clk
	set rst_src clk_gen/sync_rst

	# Instantiate Clock
	create_bd_cell -type ip -vlnv xilinx.com:ip:clk_gen:1.0 clk_gen
	set_property -dict [list CONFIG.FREQ_HZ {125000000}] [get_bd_cells clk_gen]

	# Instantiate Waveform Generator
	create_bd_cell -type ip -vlnv xilinx.com:ip:dds_compiler:6.0 waveform
	set_property -dict [list CONFIG.DDS_Clock_Rate {125} CONFIG.Frequency_Resolution {0.4} CONFIG.Noise_Shaping {Auto} CONFIG.Phase_Width {29} CONFIG.Output_Width {8} CONFIG.Output_Frequency1 {0.02} CONFIG.PINC1 {10100111110001011}] [get_bd_cells waveform]

}

# ====================================================================================
#
# 			I N S T A N T I A T E   G E N E R A L   C O M P O N E N T S
#
# ====================================================================================

# Instantiate the module to convert the ADC AXI Stream data to the data lanes the Logger Core requires
create_bd_cell -type ip -vlnv noah-huesser:user:axis_to_data_lanes:1.0 axis2lanes

# Instantiate the Control Logic for the muxers for the decimation rate
set ctrl0 dec_to_fir_mux_0
create_bd_cell -type ip -vlnv noah-huesser:user:dec_to_fir_mux:1.0 $ctrl0

# Instantiate NULL Constant with 7 bits
set NULL7 null_7_constant
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 $NULL7
set_property -dict [list CONFIG.CONST_WIDTH {7}]  [get_bd_cells $NULL7]
set_property -dict [list CONFIG.CONST_VAL {0}]    [get_bd_cells $NULL7]

# Instantiate Decimation Rate Constant
set decimation_rate dec_rate_constant
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 $decimation_rate
set_property -dict [list CONFIG.CONST_WIDTH {32}] [get_bd_cells $decimation_rate]
set_property -dict [list CONFIG.CONST_VAL {625}]    [get_bd_cells $decimation_rate]

# Instantiate Multiplexers
set stage0_branch_count 2
set stage1_branch_count 3
set stage2_branch_count 2
set stage3_branch_count_start 6
set stage3_branch_count_end 3
set stagef_branch_count 3

set mux0 axis_multiplexer_0
set mux1 axis_multiplexer_1
set mux2 axis_multiplexer_2
set mux3 axis_multiplexer_3
set muxf axis_multiplexer_f

create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux0
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux1
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux2
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux3
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $muxf

# Configure Multiplexers
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS $stage0_branch_count]     [get_bd_cells $mux0]
set_property -dict [list CONFIG.C_AXIS_TDATA_WIDTH {48}]                      [get_bd_cells $mux0]
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS $stage1_branch_count]     [get_bd_cells $mux1]
set_property -dict [list CONFIG.C_AXIS_TDATA_WIDTH {48}]                      [get_bd_cells $mux1]
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS $stage2_branch_count]     [get_bd_cells $mux2]
set_property -dict [list CONFIG.C_AXIS_TDATA_WIDTH {48}]                      [get_bd_cells $mux2]
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS $stage3_branch_count_end] [get_bd_cells $mux3]
set_property -dict [list CONFIG.C_AXIS_TDATA_WIDTH {48}]                      [get_bd_cells $mux3]
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS $stagef_branch_count]     [get_bd_cells $muxf]
set_property -dict [list CONFIG.C_AXIS_TDATA_WIDTH {32}]                      [get_bd_cells $muxf]

# Instantiate Concatenators
set concat0 concat_0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $concat0
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells $concat0]
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells $concat0]
set_property -dict [list CONFIG.IN2_WIDTH.VALUE_SRC USER] [get_bd_cells $concat0]
set_property -dict [list CONFIG.NUM_PORTS  {3}]           [get_bd_cells $concat0]
set_property -dict [list CONFIG.IN0_WIDTH {14}]           [get_bd_cells $concat0]
set_property -dict [list CONFIG.IN1_WIDTH  {1}]           [get_bd_cells $concat0]
set_property -dict [list CONFIG.IN2_WIDTH  {1}]           [get_bd_cells $concat0]

set concat1 concat_1
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $concat1
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells $concat1]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells $concat1]
set_property -dict [list CONFIG.IN2_WIDTH.VALUE_SRC USER] [get_bd_cells $concat1]
set_property -dict [list CONFIG.NUM_PORTS  {3}]           [get_bd_cells $concat1]
set_property -dict [list CONFIG.IN0_WIDTH {14}]           [get_bd_cells $concat1]
set_property -dict [list CONFIG.IN1_WIDTH  {1}]           [get_bd_cells $concat1]
set_property -dict [list CONFIG.IN2_WIDTH  {1}]           [get_bd_cells $concat1]

set concat2 concat_2
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $concat2
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER]  [get_bd_cells $concat2]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER]  [get_bd_cells $concat2]
set_property -dict [list CONFIG.NUM_PORTS   {2}]           [get_bd_cells $concat2]
set_property -dict [list CONFIG.IN0_WIDTH  {16}]           [get_bd_cells $concat2]
set_property -dict [list CONFIG.IN1_WIDTH  {16}]           [get_bd_cells $concat2]

set concat3 concat_3
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $concat3
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER]  [get_bd_cells $concat3]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER]  [get_bd_cells $concat3]
set_property -dict [list CONFIG.NUM_PORTS   {2}]           [get_bd_cells $concat3]
set_property -dict [list CONFIG.IN0_WIDTH  {16}]           [get_bd_cells $concat3]
set_property -dict [list CONFIG.IN1_WIDTH  {16}]           [get_bd_cells $concat3]


# Instantiate Slices
set slice0 slice_0
set slice1 slice_1
set slice2 slice_2
set slice3 slice_3
set slice4 slice_4
set slice5 slice_5
set slice6 slice_6
set slice7 slice_7
set slice8 slice_8
set slice9 slice_9
set slice10 slice_10
set slice11 slice_11

if {$sim eq ""} {

 	# FPGA project
 	# 2 channel 16bit ADC input => 32bit wide => different signals on channels 0 & 1

 	spawn_slice $slice0 32 13 0 14
	spawn_slice $slice1 32 29 16 14
	spawn_slice $slice2 32 15 15 1
	spawn_slice $slice3 32 31 31 1

} else {

	# Sim project
	# 1 channel 16bit ADC input => 16bit wide => same signal both channels

	spawn_slice $slice0 16 15 2 14
	spawn_slice $slice1 16 15 2 14
	spawn_slice $slice2 16 15 15 1
	spawn_slice $slice3 16 15 15 1

}

spawn_slice $slice4 48 21 6 16
spawn_slice $slice5 48 45 30 16
spawn_slice $slice6 40 32 17 16
spawn_slice $slice7 40 32 17 16
spawn_slice $slice8 48 41 26 16
spawn_slice $slice9 48 41 26 16
spawn_slice $slice10 48 22 7 16
spawn_slice $slice11 48 46 31 16

# ====================================================================================
#
# 			I N S T A N T I A T E   F I R   C O M P O N E N T S
#
# ====================================================================================

# FIR Compiler general settings
set fclk 125
set dataWidthOut 32
set dataWidthIn 24
set fracWidthIn 7
set nPaths 2

# current_dir: resolves to firmware/fpga/build/p_chain5
set coef_dir "${current_dir}/../../p_chain5/coefData"

# Coefficient files
set coef_halfband  "${coef_dir}/halfband.coe"
set coef_dec2steep $coef_halfband
set coef_dec2flat  $coef_halfband
set coef_dec5steep "${coef_dir}/dec5steep.coe"
set coef_dec5flat  "${coef_dir}/dec5flat.coe"
set coef_comp025   "${coef_dir}/comp025.coe"
set coef_comp125   "${coef_dir}/comp125.coe"

set fircomp_instance "fir2_steep"
set fircomp_instance_2steep $fircomp_instance
set decRate 2
set fs 0.2
set coeFile $coef_dec2steep
spawn_fir $fircomp_instance

set fircomp_instance "fir2_flat"
set fircomp_instance_2flat $fircomp_instance
set decRate 2
set fs 0.2
set coeFile $coef_dec2flat
spawn_fir $fircomp_instance

set fircomp_instance "fir5_steep"
set fircomp_instance_5steep $fircomp_instance
set decRate 5
set fs $fclk
set coeFile $coef_dec5steep
spawn_fir $fircomp_instance

set fircomp_instance "fir5_flat"
set fircomp_instance_5flat $fircomp_instance
set decRate 5
set fs $fclk
set coeFile $coef_dec5flat
spawn_fir $fircomp_instance

set fircomp_instance "fir1_comp025"
set fircomp_instance_cfir025 $fircomp_instance
set decRate 1
set fs 5
set coeFile $coef_comp025
spawn_fir $fircomp_instance

set fircomp_instance "fir1_comp125"
set fircomp_instance_cfir125 $fircomp_instance
set decRate 5
set fs 1
set coeFile $coef_comp125
spawn_fir $fircomp_instance

# ====================================================================================
#
# 			I N S T A N T I A T E   C I C   C O M P O N E N T S
#
# ====================================================================================

set cic025_0 cic_compiler025_0
set cic025_1 cic_compiler025_1
set cic125_0 cic_compiler125_0
set cic125_1 cic_compiler125_1

set numStages 4
set decRate 25
set dataWidthOut 33
spawn_cic $cic025_0
spawn_cic $cic025_1

set numStages 4
set decRate 125
set dataWidthOut 42
spawn_cic $cic125_0
spawn_cic $cic125_1

# ====================================================================================
#
# 		C R E A T E   S P E C I F I C   C L K / R S T   C O N N E C T I O N S
#
# ====================================================================================

if {$sim eq ""} {

	# Distribute Clocks for the FPGA Project
 	connect_bd_net [get_bd_pins ps/M_AXI_GP0_ACLK]    [get_bd_pins ps/S_AXI_HP0_ACLK]
	connect_bd_net [get_bd_pins ps/M_AXI_GP0_ACLK]    [get_bd_pins clk_wiz_adc/clk_out1]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins system_rst/slowest_sync_clk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins S2Mconverter/aclk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins M2Sconverter/aclk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins logger/MAxiClkxCI]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins logger/SAxiAClkxCI]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins logger/ClkxCI]

	# Distribute Resets for the FPGA Project
	connect_bd_net [get_bd_pins system_rst/ext_reset_in]         [get_bd_pins clk_wiz_adc/locked]
	connect_bd_net [get_bd_pins system_rst/peripheral_aresetn]   [get_bd_pins logger/MAxiRstxRBI]
	connect_bd_net [get_bd_pins system_rst/peripheral_aresetn]   [get_bd_pins logger/SAxiAResetxRBI]
	connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins M2Sconverter/aresetn]
	connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins S2Mconverter/aresetn]

} else {

	# Distribute Clocks for the Sim Project
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins waveform/aclk]

}

# ====================================================================================
#
# 			C R E A T E   G E N E R A L   C L K / R S T   C O N N E C T I O N S
#
# ====================================================================================

	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins axis2lanes/ClkxCI]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $mux0/ClkxCI]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $mux1/ClkxCI]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $mux2/ClkxCI]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $mux3/ClkxCI]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $muxf/ClkxCI]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $fircomp_instance_2steep/aclk]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $fircomp_instance_2flat/aclk]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $fircomp_instance_5steep/aclk]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $fircomp_instance_5flat/aclk]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $fircomp_instance_cfir025/aclk]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $fircomp_instance_cfir125/aclk]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $cic025_0/aclk]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $cic025_1/aclk]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $cic125_0/aclk]
	connect_bd_net [get_bd_pins $clk_src] [get_bd_pins $cic125_1/aclk]

	# Distribute Resets
	connect_bd_net [get_bd_pins $rst_src]   [get_bd_pins axis2lanes/RstxRBI]
	connect_bd_net [get_bd_pins $rst_src] [get_bd_pins $mux0/RstxRBI]
	connect_bd_net [get_bd_pins $rst_src] [get_bd_pins $mux1/RstxRBI]
	connect_bd_net [get_bd_pins $rst_src] [get_bd_pins $mux2/RstxRBI]
	connect_bd_net [get_bd_pins $rst_src] [get_bd_pins $mux3/RstxRBI]
	connect_bd_net [get_bd_pins $rst_src] [get_bd_pins $muxf/RstxRBI]

# ====================================================================================
#
# 			C R E A T E   S P E C I F I C   R T L   C O N N E C T I O N S
#
# ====================================================================================

if {$sim eq ""} {

	# Blinking LED for the FPGA Project
	connect_bd_net [get_bd_pins Cnt2Hz/Q]   [get_bd_pins Slc2Hz/Din]
	connect_bd_net [get_bd_ports led_o]     [get_bd_pins Slc2Hz/Dout]
	connect_bd_net [get_bd_pins Cnt2Hz/CLK] [get_bd_pins clk_wiz_adc/clk_out1]

 	# axis2lanes to Logger for the FPGA Project
	connect_bd_net [get_bd_pins logger/Data0xDI]     [get_bd_pins axis2lanes/Data0xDO]
	connect_bd_net [get_bd_pins axis2lanes/Data1xDO] [get_bd_pins logger/Data1xDI]

 	# Clock & DataStrobe to Logger for the FPGA Project
	connect_bd_net [get_bd_pins logger/DataStrobexSI] [get_bd_pins axis2lanes/DataStrobexDO]

 	# AXI Converters for the FPGA Project
	connect_bd_intf_net [get_bd_intf_pins M2Sconverter/M_AXI] [get_bd_intf_pins ps/S_AXI_HP0]
	connect_bd_intf_net [get_bd_intf_pins M2Sconverter/S_AXI] [get_bd_intf_pins logger/M0]
	connect_bd_intf_net [get_bd_intf_pins S2Mconverter/S_AXI] [get_bd_intf_pins ps/M_AXI_GP0]
	connect_bd_intf_net [get_bd_intf_pins S2Mconverter/M_AXI] [get_bd_intf_pins logger/S0]

	# ZYNQ7 Processing System to Zynq Logger for the FPGA Project
	connect_bd_net [get_bd_pins ps/IRQ_F2P] [get_bd_pins logger/IRQxSO]

	# ADC to IN for the FPGA Project
	connect_bd_net      [get_bd_pins adc/m_axis_tdata]                [get_bd_pins $slice0/Din]
	connect_bd_net      [get_bd_pins adc/m_axis_tdata]                [get_bd_pins $slice1/Din]
	connect_bd_net      [get_bd_pins adc/m_axis_tdata]                [get_bd_pins $slice2/Din]
	connect_bd_net      [get_bd_pins adc/m_axis_tdata]                [get_bd_pins $slice3/Din]

	connect_bd_net      [get_bd_pins adc/m_axis_tvalid]                [get_bd_pins $cic025_0/s_axis_data_tvalid]
	connect_bd_net      [get_bd_pins adc/m_axis_tvalid]                [get_bd_pins $cic025_1/s_axis_data_tvalid]
	connect_bd_net      [get_bd_pins adc/m_axis_tvalid]                [get_bd_pins $cic125_0/s_axis_data_tvalid]
	connect_bd_net      [get_bd_pins adc/m_axis_tvalid]                [get_bd_pins $cic125_1/s_axis_data_tvalid]
	connect_bd_net      [get_bd_pins adc/m_axis_tvalid]                [get_bd_pins $mux3/Valid0xSI]

} else {

	# WAVEFORM TO IN for the Sim Project
	connect_bd_net      [get_bd_pins waveform/m_axis_data_tdata]                [get_bd_pins $slice0/Din]
	connect_bd_net      [get_bd_pins waveform/m_axis_data_tdata]                [get_bd_pins $slice1/Din]
	connect_bd_net      [get_bd_pins waveform/m_axis_data_tdata]                [get_bd_pins $slice2/Din]
	connect_bd_net      [get_bd_pins waveform/m_axis_data_tdata]                [get_bd_pins $slice3/Din]

	connect_bd_net      [get_bd_pins waveform/m_axis_data_tvalid]                [get_bd_pins $cic025_0/s_axis_data_tvalid]
	connect_bd_net      [get_bd_pins waveform/m_axis_data_tvalid]                [get_bd_pins $cic025_1/s_axis_data_tvalid]
	connect_bd_net      [get_bd_pins waveform/m_axis_data_tvalid]                [get_bd_pins $cic125_0/s_axis_data_tvalid]
	connect_bd_net      [get_bd_pins waveform/m_axis_data_tvalid]                [get_bd_pins $cic125_1/s_axis_data_tvalid]
	connect_bd_net      [get_bd_pins waveform/m_axis_data_tvalid]                [get_bd_pins $mux3/Valid0xSI]

}

# ====================================================================================
#
# 		  C R E A T E   G E N E R A L   F I L T E R   C O N N E C T I O N S
#
# ====================================================================================

# IN TO CIC

connect_bd_net      [get_bd_pins $slice0/Dout]                [get_bd_pins $concat0/In0]
connect_bd_net      [get_bd_pins $slice2/Dout]                [get_bd_pins $concat0/In1]
connect_bd_net      [get_bd_pins $slice2/Dout]                [get_bd_pins $concat0/In2]
connect_bd_net      [get_bd_pins $slice1/Dout]                [get_bd_pins $concat1/In0]
connect_bd_net      [get_bd_pins $slice3/Dout]                [get_bd_pins $concat1/In1]
connect_bd_net      [get_bd_pins $slice3/Dout]                [get_bd_pins $concat1/In2]
connect_bd_net      [get_bd_pins $concat0/dout]                [get_bd_pins $cic025_0/s_axis_data_tdata]
connect_bd_net      [get_bd_pins $concat1/dout]                [get_bd_pins $cic025_1/s_axis_data_tdata]

connect_bd_net      [get_bd_pins $concat0/dout]                [get_bd_pins $cic125_0/s_axis_data_tdata]
connect_bd_net      [get_bd_pins $concat1/dout]                [get_bd_pins $cic125_1/s_axis_data_tdata]

# IN TO MUX 3
w16to17p7x2 intomux3 $concat0/dout $concat1/dout $NULL7/dout $mux3/Data0xDI

# CICs TO FIRs
w16to17p7x2 cic025tocomp $slice6/Dout $slice7/Dout $NULL7/dout $fircomp_instance_cfir025/s_axis_data_tdata
w16to17p7x2 cic125tocomp $slice8/Dout $slice9/Dout $NULL7/dout $fircomp_instance_cfir125/s_axis_data_tdata
connect_bd_net      [get_bd_pins $cic025_0/m_axis_data_tvalid]               [get_bd_pins $fircomp_instance_cfir025/s_axis_data_tvalid]
connect_bd_net      [get_bd_pins $cic125_0/m_axis_data_tvalid]               [get_bd_pins $fircomp_instance_cfir125/s_axis_data_tvalid]
connect_bd_net      [get_bd_pins $cic025_0/m_axis_data_tdata]               [get_bd_pins $slice6/Din]
connect_bd_net      [get_bd_pins $cic025_1/m_axis_data_tdata]                [get_bd_pins $slice7/Din]
connect_bd_net      [get_bd_pins $cic125_0/m_axis_data_tdata]               [get_bd_pins $slice8/Din]
connect_bd_net      [get_bd_pins $cic125_1/m_axis_data_tdata]                [get_bd_pins $slice9/Din]

# FIR 1 TO MUX 3
w64to48 fir1_025_mux3 $fircomp_instance_cfir025/m_axis_data_tdata $mux3/Data1xDI 14
w64to48 fir1_125_mux3 $fircomp_instance_cfir125/m_axis_data_tdata $mux3/Data2xDI 14
connect_bd_net      [get_bd_pins $fircomp_instance_cfir025/m_axis_data_tvalid]                [get_bd_pins $mux3/Valid1xSI]
connect_bd_net      [get_bd_pins $fircomp_instance_cfir125/m_axis_data_tvalid]                [get_bd_pins $mux3/Valid2xSI]

# MUX 3 TO FIR 5 FLAT
connect_bd_net      [get_bd_pins $mux3/DataxDO]                [get_bd_pins $fircomp_instance_5flat/s_axis_data_tdata]
connect_bd_net      [get_bd_pins $mux3/ValidxSO]               [get_bd_pins $fircomp_instance_5flat/s_axis_data_tvalid]

# MUX 3 TO MUX 2
connect_bd_net      [get_bd_pins $mux3/DataxDO]                [get_bd_pins $mux2/Data0xDI]
connect_bd_net      [get_bd_pins $mux3/ValidxSO]               [get_bd_pins $mux2/Valid0xSI]

# FIR 5 FLAT TO MUX 2
w64to48 fir5_flat_mux2 $fircomp_instance_5flat/m_axis_data_tdata $mux2/Data1xDI 14
connect_bd_net      [get_bd_pins $fircomp_instance_5flat/m_axis_data_tvalid] [get_bd_pins $mux2/Valid1xSI]

# MUX 2 TO FIR 5 STEEP
connect_bd_net      [get_bd_pins $mux2/DataxDO]                [get_bd_pins $fircomp_instance_5steep/s_axis_data_tdata]
connect_bd_net      [get_bd_pins $mux2/ValidxSO]               [get_bd_pins $fircomp_instance_5steep/s_axis_data_tvalid]

# MUX 2 TO FIR 2 FLAT
connect_bd_net      [get_bd_pins $mux2/DataxDO]                [get_bd_pins $fircomp_instance_2flat/s_axis_data_tdata]
connect_bd_net      [get_bd_pins $mux2/ValidxSO]               [get_bd_pins $fircomp_instance_2flat/s_axis_data_tvalid]

# MUX 2 TO MUX 1
connect_bd_net      [get_bd_pins $mux2/DataxDO]                [get_bd_pins $mux1/Data2xDI]
connect_bd_net      [get_bd_pins $mux2/ValidxSO]               [get_bd_pins $mux1/Valid2xSI]

# FIR 5 STEEP TO MUX 1
w64to48 fir5_steep_mux1 $fircomp_instance_5steep/m_axis_data_tdata $mux1/Data0xDI 13
connect_bd_net      [get_bd_pins $fircomp_instance_5steep/m_axis_data_tvalid] [get_bd_pins $mux1/Valid0xSI]

# FIR 2 FLAT TO MUX 1
w64to48 fir2_flat_mux1 $fircomp_instance_2flat/m_axis_data_tdata $mux1/Data1xDI 13
connect_bd_net      [get_bd_pins $fircomp_instance_2flat/m_axis_data_tvalid] [get_bd_pins $mux1/Valid1xSI]

# MUX 1 TO MUX 0
connect_bd_net      [get_bd_pins $mux1/DataxDO]                [get_bd_pins $mux0/Data0xDI]
connect_bd_net      [get_bd_pins $mux1/ValidxSO]               [get_bd_pins $mux0/Valid0xSI]

# MUX 1 TO FIR 2 STEEP
connect_bd_net      [get_bd_pins $mux1/DataxDO]                [get_bd_pins $fircomp_instance_2steep/s_axis_data_tdata]
connect_bd_net      [get_bd_pins $mux1/ValidxSO]               [get_bd_pins $fircomp_instance_2steep/s_axis_data_tvalid]

# FIR 2 STEEP TO MUX 0
w64to48 fir2_steep_mux0 $fircomp_instance_2steep/m_axis_data_tdata $mux0/Data1xDI 13
connect_bd_net      [get_bd_pins $fircomp_instance_2steep/m_axis_data_tvalid] [get_bd_pins $mux0/Valid1xSI]

# MUX 0 TO MUX F
connect_bd_net [get_bd_pins $mux0/DataxDO] [get_bd_pins $slice4/Din]
connect_bd_net [get_bd_pins $mux0/DataxDO] [get_bd_pins $slice5/Din]
connect_bd_net [get_bd_pins $slice4/Dout]  [get_bd_pins $concat2/In0]
connect_bd_net [get_bd_pins $slice5/Dout]  [get_bd_pins $concat2/In1]
connect_bd_net [get_bd_pins $mux0/DataxDO] [get_bd_pins $slice10/Din]
connect_bd_net [get_bd_pins $mux0/DataxDO] [get_bd_pins $slice11/Din]
connect_bd_net [get_bd_pins $slice10/Dout]  [get_bd_pins $concat3/In0]
connect_bd_net [get_bd_pins $slice11/Dout]  [get_bd_pins $concat3/In1]
connect_bd_net [get_bd_pins $concat2/dout] [get_bd_pins $muxf/Data0xDI]
connect_bd_net [get_bd_pins $concat3/dout] [get_bd_pins $muxf/Data1xDI]

connect_bd_net      [get_bd_pins $muxf/Valid0xSI] [get_bd_pins $mux0/ValidxSO]
connect_bd_net      [get_bd_pins $muxf/Valid1xSI] [get_bd_pins $mux0/ValidxSO]

# MUX 0 TO OUT
connect_bd_intf_net [get_bd_intf_pins $muxf/MO]                             [get_bd_intf_pins axis2lanes/SI]

# ====================================================================================
#
# 		  						R O U N D   U P
#
# ====================================================================================

# Connect Control Logic
if {$sim eq ""} {
 	# Adjustable rate for the FPGA Project
	connect_bd_net [get_bd_pins logger/DecimationRatexDO] [get_bd_pins $ctrl0/DecRate]
} {
	# Fixed decimation rate for the Simulation
	connect_bd_net [get_bd_pins $decimation_rate/dout] [get_bd_pins $ctrl0/DecRate]
}

connect_bd_net [get_bd_pins $ctrl0/Mux0]  [get_bd_pins $mux0/SelectxDI]
connect_bd_net [get_bd_pins $ctrl0/Mux1]  [get_bd_pins $mux1/SelectxDI]
connect_bd_net [get_bd_pins $ctrl0/Mux2]  [get_bd_pins $mux2/SelectxDI]
connect_bd_net [get_bd_pins $ctrl0/Mux3]  [get_bd_pins $mux3/SelectxDI]
connect_bd_net [get_bd_pins $ctrl0/Muxf]  [get_bd_pins $muxf/SelectxDI]

if {$sim eq ""} {
 	# Assign Address to Logger MMIO Slave for the FPGA Project
	assign_bd_address [get_bd_addr_segs {logger/S0/Reg }]
}

# Pita Basic
generate_target all [get_files  $bd_path/system.bd]
make_wrapper -files [get_files $bd_path/system.bd] -top
add_files -norecurse $bd_path/hdl/system_wrapper.v

# Load RedPitaya constraint files
set files [glob -nocomplain cfg/*.xdc]
if {[llength $files] > 0} {
  add_files -norecurse -fileset constrs_1 $files
}

set_property VERILOG_DEFINE {TOOL_VIVADO} [current_fileset]
set_property STRATEGY Flow_PerfOptimized_High [get_runs synth_1]
set_property STRATEGY Performance_NetDelay_high [get_runs impl_1]

save_bd_design