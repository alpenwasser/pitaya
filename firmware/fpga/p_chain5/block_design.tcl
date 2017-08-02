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
# Methods

# Slices a 64bit axi dual channel signal into 2 24bit signals
# and combines them to 48bit dual channel
# 25.7 x 2 => 17.7 x2
proc w64to48 {name din dout} {
	# Create slices
	create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ${name}_slice_0
	create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ${name}_slice_1
	set_property -dict [list CONFIG.DIN_WIDTH  {64}] [get_bd_cells ${name}_slice_0]
	set_property -dict [list CONFIG.DIN_FROM   {30}] [get_bd_cells ${name}_slice_0]
	set_property -dict [list CONFIG.DIN_TO     {7}] [get_bd_cells ${name}_slice_0]
	set_property -dict [list CONFIG.DOUT_WIDTH  {24}] [get_bd_cells ${name}_slice_0]
	set_property -dict [list CONFIG.DIN_WIDTH  {64}] [get_bd_cells ${name}_slice_1]
	set_property -dict [list CONFIG.DIN_FROM   {62}] [get_bd_cells ${name}_slice_1]
	set_property -dict [list CONFIG.DIN_TO     {39}] [get_bd_cells ${name}_slice_1]
	set_property -dict [list CONFIG.DOUT_WIDTH  {24}] [get_bd_cells ${name}_slice_1]

	# Create concat
	create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 ${name}_concat_0
	set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells ${name}_concat_0]
	set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells ${name}_concat_0]
	set_property -dict [list CONFIG.NUM_PORTS {2}]            [get_bd_cells ${name}_concat_0]
	set_property -dict [list CONFIG.IN0_WIDTH {24}]           [get_bd_cells ${name}_concat_0]
	set_property -dict [list CONFIG.IN1_WIDTH {24}]           [get_bd_cells ${name}_concat_0]

	# Connect slices with concat
	connect_bd_net [get_bd_pins ${name}_slice_0/Dout] [get_bd_pins ${name}_concat_0/In0]
	connect_bd_net [get_bd_pins ${name}_slice_1/Dout] [get_bd_pins ${name}_concat_0/In1]

	# Connect component to outside
	connect_bd_net [get_bd_pins $din] [get_bd_pins ${name}_slice_0/Din]
	connect_bd_net [get_bd_pins $din] [get_bd_pins ${name}_slice_1/Din]
	connect_bd_net [get_bd_pins $dout] [get_bd_pins ${name}_concat_0/Dout]
}

# ====================================================================================
# RTL modules

if {$sim eq ""} {
 	# Normal project

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

	# The Logger module
	create_bd_cell -type ip -vlnv bastli:user:zynq_logger:1.1 logger
} else {
	# Sim project

	# Create clock
	create_bd_cell -type ip -vlnv xilinx.com:ip:clk_gen:1.0 clk_gen
	set_property -dict [list CONFIG.FREQ_HZ {125000000}] [get_bd_cells clk_gen]

	# Waveform GEN
	create_bd_cell -type ip -vlnv xilinx.com:ip:dds_compiler:6.0 waveform
	set_property -dict [list CONFIG.DDS_Clock_Rate {125} CONFIG.Frequency_Resolution {0.4} CONFIG.Noise_Shaping {Auto} CONFIG.Phase_Width {29} CONFIG.Output_Width {8} CONFIG.Output_Frequency1 {0.02} CONFIG.PINC1 {10100111110001011}] [get_bd_cells waveform]
}

# Module to convert the ADC AXI Stream data to the data lanes the Logger Core requires
create_bd_cell -type ip -vlnv noah-huesser:user:axis_to_data_lanes:1.0 axis2lanes

# Control Logic
set ctrl0 dec_to_fir_mux_0
create_bd_cell -type ip -vlnv noah-huesser:user:dec_to_fir_mux:1.0 $ctrl0

# Constants
set const0 xlconstant_0
set const1 xlconstant_1
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 $const0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 $const1
set_property -dict [list CONFIG.CONST_WIDTH {7}]  [get_bd_cells $const0]
set_property -dict [list CONFIG.CONST_VAL {0}]    [get_bd_cells $const0]
set_property -dict [list CONFIG.CONST_WIDTH {32}] [get_bd_cells $const1]
set_property -dict [list CONFIG.CONST_VAL {625}]    [get_bd_cells $const1]

# Broadcasters
set path_count 2

set stage0_branch_count 2
set stage1_branch_count 3
set stage2_branch_count 2
set stage3_branch_count_start 6
set stage3_branch_count_end 3

# Create Multiplexers
set mux0 axis_multiplexer_0
set mux1 axis_multiplexer_1
set mux2 axis_multiplexer_2
set mux3 axis_multiplexer_3

#set mux4 axis_multiplexer_4
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux0
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux1
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux2
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux3

# Configure Multiplexers
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS $stage0_branch_count]     [get_bd_cells $mux0]
set_property -dict [list CONFIG.C_AXIS_TDATA_WIDTH {48}]                      [get_bd_cells $mux0]
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS $stage1_branch_count]     [get_bd_cells $mux1]
set_property -dict [list CONFIG.C_AXIS_TDATA_WIDTH {48}]                      [get_bd_cells $mux1]
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS $stage2_branch_count]     [get_bd_cells $mux2]
set_property -dict [list CONFIG.C_AXIS_TDATA_WIDTH {48}]                      [get_bd_cells $mux2]
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS $stage3_branch_count_end] [get_bd_cells $mux3]
set_property -dict [list CONFIG.C_AXIS_TDATA_WIDTH {48}]                      [get_bd_cells $mux3]

# Concatenators
set concat0 concat_0
set concat1 concat_1
set concat2 concat_2
set concat3 concat_3
set concat4 concat_4
set concat5 concat_5
set concat6 concat_6
set concat7 concat_7
set concat8 concat_8
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $concat0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $concat1
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $concat2
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $concat3
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $concat4
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $concat5
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $concat6
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $concat7
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $concat8
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells $concat0]
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells $concat0]
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells $concat1]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells $concat1]
set_property -dict [list CONFIG.IN2_WIDTH.VALUE_SRC USER] [get_bd_cells $concat1]
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells $concat2]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells $concat2]
set_property -dict [list CONFIG.IN2_WIDTH.VALUE_SRC USER] [get_bd_cells $concat2]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells $concat3]
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells $concat3]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells $concat4]
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells $concat4]
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells $concat5]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells $concat5]
set_property -dict [list CONFIG.IN2_WIDTH.VALUE_SRC USER] [get_bd_cells $concat5]
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells $concat6]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells $concat6]
set_property -dict [list CONFIG.IN2_WIDTH.VALUE_SRC USER] [get_bd_cells $concat6]
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells $concat7]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells $concat7]
set_property -dict [list CONFIG.IN2_WIDTH.VALUE_SRC USER] [get_bd_cells $concat7]
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells $concat8]
set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells $concat8]
set_property -dict [list CONFIG.IN2_WIDTH.VALUE_SRC USER] [get_bd_cells $concat8]

set_property -dict [list CONFIG.NUM_PORTS {2}]            [get_bd_cells $concat0]
set_property -dict [list CONFIG.IN0_WIDTH {24}]           [get_bd_cells $concat0]
set_property -dict [list CONFIG.IN1_WIDTH {24}]           [get_bd_cells $concat0]
set_property -dict [list CONFIG.NUM_PORTS {3}]            [get_bd_cells $concat1]
set_property -dict [list CONFIG.IN0_WIDTH {7}]            [get_bd_cells $concat1]
set_property -dict [list CONFIG.IN1_WIDTH {16}]           [get_bd_cells $concat1]
set_property -dict [list CONFIG.IN2_WIDTH {1}]            [get_bd_cells $concat1]
set_property -dict [list CONFIG.NUM_PORTS {3}]            [get_bd_cells $concat2]
set_property -dict [list CONFIG.IN0_WIDTH {7}]            [get_bd_cells $concat2]
set_property -dict [list CONFIG.IN1_WIDTH {16}]           [get_bd_cells $concat2]
set_property -dict [list CONFIG.IN2_WIDTH {1}]            [get_bd_cells $concat1]
set_property -dict [list CONFIG.NUM_PORTS {2}]            [get_bd_cells $concat3]
set_property -dict [list CONFIG.IN0_WIDTH {24}]           [get_bd_cells $concat3]
set_property -dict [list CONFIG.IN1_WIDTH {24}]           [get_bd_cells $concat3]
set_property -dict [list CONFIG.NUM_PORTS {2}]            [get_bd_cells $concat4]
set_property -dict [list CONFIG.IN0_WIDTH {24}]           [get_bd_cells $concat4]
set_property -dict [list CONFIG.IN1_WIDTH {24}]           [get_bd_cells $concat4]
set_property -dict [list CONFIG.NUM_PORTS {3}]            [get_bd_cells $concat5]
set_property -dict [list CONFIG.IN0_WIDTH {7}]            [get_bd_cells $concat5]
set_property -dict [list CONFIG.IN1_WIDTH {16}]           [get_bd_cells $concat5]
set_property -dict [list CONFIG.IN2_WIDTH {1}]            [get_bd_cells $concat5]
set_property -dict [list CONFIG.NUM_PORTS {3}]            [get_bd_cells $concat6]
set_property -dict [list CONFIG.IN0_WIDTH {7}]            [get_bd_cells $concat6]
set_property -dict [list CONFIG.IN1_WIDTH {16}]           [get_bd_cells $concat6]
set_property -dict [list CONFIG.IN2_WIDTH {1}]            [get_bd_cells $concat6]
set_property -dict [list CONFIG.NUM_PORTS {3}]            [get_bd_cells $concat7]
set_property -dict [list CONFIG.IN0_WIDTH {7}]            [get_bd_cells $concat7]
set_property -dict [list CONFIG.IN1_WIDTH {16}]           [get_bd_cells $concat7]
set_property -dict [list CONFIG.IN2_WIDTH {1}]            [get_bd_cells $concat7]
set_property -dict [list CONFIG.NUM_PORTS {3}]            [get_bd_cells $concat8]
set_property -dict [list CONFIG.IN0_WIDTH {7}]            [get_bd_cells $concat8]
set_property -dict [list CONFIG.IN1_WIDTH {16}]           [get_bd_cells $concat8]
set_property -dict [list CONFIG.IN2_WIDTH {1}]            [get_bd_cells $concat8]


# Slices
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
set slice13 slice_13
set slice14 slice_14
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $slice0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $slice1
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $slice2
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $slice3
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $slice4
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $slice5
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $slice6
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $slice7
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $slice8
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $slice9
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $slice13
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $slice14
set_property -dict [list CONFIG.DIN_WIDTH  {16}] [get_bd_cells $slice0]
set_property -dict [list CONFIG.DIN_FROM   {15}] [get_bd_cells $slice0]
set_property -dict [list CONFIG.DIN_TO     {15}] [get_bd_cells $slice0]
set_property -dict [list CONFIG.DOUT_WIDTH  {1}] [get_bd_cells $slice0]
set_property -dict [list CONFIG.DIN_WIDTH  {16}] [get_bd_cells $slice1]
set_property -dict [list CONFIG.DIN_FROM   {15}] [get_bd_cells $slice1]
set_property -dict [list CONFIG.DIN_TO     {15}] [get_bd_cells $slice1]
set_property -dict [list CONFIG.DOUT_WIDTH  {1}] [get_bd_cells $slice1]
set_property -dict [list CONFIG.DIN_WIDTH  {16}] [get_bd_cells $slice2]
set_property -dict [list CONFIG.DIN_FROM   {15}] [get_bd_cells $slice2]
set_property -dict [list CONFIG.DIN_TO     {15}] [get_bd_cells $slice2]
set_property -dict [list CONFIG.DOUT_WIDTH  {1}] [get_bd_cells $slice2]
set_property -dict [list CONFIG.DIN_WIDTH  {16}] [get_bd_cells $slice3]
set_property -dict [list CONFIG.DIN_FROM   {15}] [get_bd_cells $slice3]
set_property -dict [list CONFIG.DIN_TO     {15}] [get_bd_cells $slice3]
set_property -dict [list CONFIG.DOUT_WIDTH  {1}] [get_bd_cells $slice3]
set_property -dict [list CONFIG.DIN_WIDTH  {16}] [get_bd_cells $slice4]
set_property -dict [list CONFIG.DIN_FROM   {15}] [get_bd_cells $slice4]
set_property -dict [list CONFIG.DIN_TO     {15}] [get_bd_cells $slice4]
set_property -dict [list CONFIG.DOUT_WIDTH  {1}] [get_bd_cells $slice4]
set_property -dict [list CONFIG.DIN_WIDTH  {16}] [get_bd_cells $slice5]
set_property -dict [list CONFIG.DIN_FROM   {15}] [get_bd_cells $slice5]
set_property -dict [list CONFIG.DIN_TO     {15}] [get_bd_cells $slice5]
set_property -dict [list CONFIG.DOUT_WIDTH  {1}] [get_bd_cells $slice5]
set_property -dict [list CONFIG.DIN_WIDTH  {40}] [get_bd_cells $slice6]
set_property -dict [list CONFIG.DIN_FROM   {32}] [get_bd_cells $slice6]
set_property -dict [list CONFIG.DIN_TO     {17}] [get_bd_cells $slice6]
set_property -dict [list CONFIG.DOUT_WIDTH {16}] [get_bd_cells $slice6]
set_property -dict [list CONFIG.DIN_WIDTH  {40}] [get_bd_cells $slice7]
set_property -dict [list CONFIG.DIN_FROM   {32}] [get_bd_cells $slice7]
set_property -dict [list CONFIG.DIN_TO     {17}] [get_bd_cells $slice7]
set_property -dict [list CONFIG.DOUT_WIDTH {16}] [get_bd_cells $slice7]
set_property -dict [list CONFIG.DIN_WIDTH  {48}] [get_bd_cells $slice8]
set_property -dict [list CONFIG.DIN_FROM   {42}] [get_bd_cells $slice8]
set_property -dict [list CONFIG.DIN_TO     {27}] [get_bd_cells $slice8]
set_property -dict [list CONFIG.DOUT_WIDTH {16}] [get_bd_cells $slice8]
set_property -dict [list CONFIG.DIN_WIDTH  {48}] [get_bd_cells $slice9]
set_property -dict [list CONFIG.DIN_FROM   {42}] [get_bd_cells $slice9]
set_property -dict [list CONFIG.DIN_TO     {27}] [get_bd_cells $slice9]
set_property -dict [list CONFIG.DOUT_WIDTH {16}] [get_bd_cells $slice9]
set_property -dict [list CONFIG.DIN_WIDTH  {32}] [get_bd_cells $slice13]
set_property -dict [list CONFIG.DIN_FROM   {15}] [get_bd_cells $slice13]
set_property -dict [list CONFIG.DIN_TO      {2}] [get_bd_cells $slice13]
set_property -dict [list CONFIG.DOUT_WIDTH {14}] [get_bd_cells $slice13]
set_property -dict [list CONFIG.DIN_WIDTH  {32}] [get_bd_cells $slice14]
set_property -dict [list CONFIG.DIN_FROM   {31}] [get_bd_cells $slice14]
set_property -dict [list CONFIG.DIN_TO     {18}] [get_bd_cells $slice14]
set_property -dict [list CONFIG.DOUT_WIDTH {14}] [get_bd_cells $slice14]
# TODO: adjust for real


# FIR Compilers
set vlnv_fircomp xilinx.com:ip:fir_compiler:7.2
set clk 125
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

set decRate 2
set fs_dec2steep 0.2
set dataWidthIn 24
set fracWidthIn 7
set dataWidthOut 32
set coefWidth 16
set paths $path_count
set fircomp_instance "fir2_steep"
set fircomp_instance_2steep $fircomp_instance
create_bd_cell -type ip -vlnv $vlnv_fircomp $fircomp_instance
set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File $coef_dec2steep] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Type {Decimation}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Decimation_Rate $decRate]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Sample_Frequency $fs_dec2steep]                                       [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.BestPrecision {true}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}]                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Width $dataWidthOut]                                           [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sets {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Channels {1}]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Paths $paths]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}]                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Quantization {Quantize_Only}]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Width $coefWidth]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}]                                     [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Width $dataWidthIn]                                              [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}]                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.M_DATA_Has_TREADY {true}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Fractional_Bits.VALUE_SRC USER] 								  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Fractional_Bits $fracWidthIn] 								      [get_bd_cells $fircomp_instance]

set decRate 2
set fs_dec2flat 0.2
set dataWidthIn 24
set fracWidthIn 7
set dataWidthOut 32
set coefWidth 16
set paths $path_count
set fircomp_instance "fir2_flat"
set fircomp_instance_2flat $fircomp_instance
create_bd_cell -type ip -vlnv $vlnv_fircomp $fircomp_instance
set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File $coef_dec2flat]  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Type {Decimation}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Decimation_Rate $decRate]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Sample_Frequency $fs_dec2flat]                                        [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.BestPrecision {true}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}]                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Width $dataWidthOut]                                           [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sets {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Channels {1}]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Paths $paths]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}]                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Quantization {Quantize_Only}]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Width $coefWidth]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}]                                     [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Width $dataWidthIn]                                              [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}]                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.M_DATA_Has_TREADY {true}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Fractional_Bits.VALUE_SRC USER] 								  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Fractional_Bits $fracWidthIn] 								      [get_bd_cells $fircomp_instance]

set decRate 5
set fs_dec5steep $clk
set dataWidthIn 24
set fracWidthIn 7
set dataWidthOut 32
set coefWidth 16
set paths $path_count
set fircomp_instance "fir5_steep"
set fircomp_instance_5steep $fircomp_instance
create_bd_cell -type ip -vlnv $vlnv_fircomp $fircomp_instance
set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File $coef_dec5steep] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Type {Decimation}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Decimation_Rate $decRate]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Sample_Frequency $fs_dec5steep]                                       [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.BestPrecision {true}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}]                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Width $dataWidthOut]                                           [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sets {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Channels {1}]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Paths $paths]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}]                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Quantization {Quantize_Only}]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Width $coefWidth]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}]                                     [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Width $dataWidthIn]                                              [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}]                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.M_DATA_Has_TREADY {true}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Fractional_Bits.VALUE_SRC USER] 								  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Fractional_Bits $fracWidthIn] 								      [get_bd_cells $fircomp_instance]

set decRate 5
set fs_dec5flat $clk
set dataWidthIn 24
set fracWidthIn 7
set dataWidthOut 32
set coefWidth 16
set paths $path_count
set fircomp_instance "fir5_flat"
set fircomp_instance_5flat $fircomp_instance
create_bd_cell -type ip -vlnv $vlnv_fircomp $fircomp_instance
set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File $coef_dec5flat]  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Type {Decimation}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Decimation_Rate $decRate]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Sample_Frequency $fs_dec5flat]                                        [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.BestPrecision {true}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}]                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Width $dataWidthOut]                                           [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sets {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Channels {1}]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Paths $paths]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}]                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Quantization {Quantize_Only}]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Width $coefWidth]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}]                                     [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Width $dataWidthIn]                                              [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}]                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.M_DATA_Has_TREADY {true}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Fractional_Bits.VALUE_SRC USER] 								  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Fractional_Bits $fracWidthIn] 								      [get_bd_cells $fircomp_instance]

set fs_comp025 5
set dataWidthIn 24
set fracWidthIn 7
set dataWidthOut 32
set coefWidth 16
set paths $path_count
set fircomp_instance "fir1_comp025"
set fircomp_instance_cfir025 $fircomp_instance
create_bd_cell -type ip -vlnv $vlnv_fircomp $fircomp_instance
set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER]                                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File $coef_comp025] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Type {Single_rate}]                                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate 1]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Decimation_Rate 1]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Sample_Frequency $fs_comp025]                                       [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.BestPrecision {true}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}]                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Width $dataWidthOut]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sets {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate {1}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Channels {1}]                                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Paths {2}]                                                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}]                        [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}]                                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Quantization {Quantize_Only}]                                       [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Width $coefWidth]                                       [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}]                                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Width $dataWidthIn]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}]                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.M_DATA_Has_TREADY {true}]                                           [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Fractional_Bits.VALUE_SRC USER] 								[get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Fractional_Bits $fracWidthIn] 								    [get_bd_cells $fircomp_instance]

set fs_comp125 1
set decRate 5
set dataWidthIn 24
set fracWidthIn 7
set dataWidthOut 32
set coefWidth 16
set paths $path_count
set fircomp_instance "fir1_comp125"
set fircomp_instance_cfir125 $fircomp_instance
create_bd_cell -type ip -vlnv $vlnv_fircomp $fircomp_instance
set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File $coef_comp125]   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Type {Decimation}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Decimation_Rate $decRate]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Sample_Frequency $fs_comp125]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.BestPrecision {true}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}]                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Width $dataWidthOut]                                           [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sets {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Channels {1}]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Paths $paths]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}]                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Quantization {Quantize_Only}]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Width $coefWidth]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}]                                     [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Width $dataWidthIn]                                              [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}]                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.M_DATA_Has_TREADY {true}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Fractional_Bits.VALUE_SRC USER] 								  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Fractional_Bits $fracWidthIn] 								      [get_bd_cells $fircomp_instance]

# CIC Compilers
set cic025_0 cic_compiler025_0
set cic025_1 cic_compiler025_1
set cic125_0 cic_compiler125_0
set cic125_1 cic_compiler125_1
create_bd_cell -type ip -vlnv xilinx.com:ip:cic_compiler:4.0 $cic025_0
create_bd_cell -type ip -vlnv xilinx.com:ip:cic_compiler:4.0 $cic025_1
create_bd_cell -type ip -vlnv xilinx.com:ip:cic_compiler:4.0 $cic125_0
create_bd_cell -type ip -vlnv xilinx.com:ip:cic_compiler:4.0 $cic125_1
set_property -dict [list CONFIG.Input_Data_Width.VALUE_SRC USER] [get_bd_cells $cic025_0]
set_property -dict [list CONFIG.Filter_Type {Decimation}]        [get_bd_cells $cic025_0]
set_property -dict [list CONFIG.Number_Of_Stages {4}]            [get_bd_cells $cic025_0]
set_property -dict [list CONFIG.Number_Of_Channels {1}]          [get_bd_cells $cic025_0]
set_property -dict [list CONFIG.Fixed_Or_Initial_Rate {25}]      [get_bd_cells $cic025_0]
set_property -dict [list CONFIG.Input_Sample_Frequency {125}]    [get_bd_cells $cic025_0]
set_property -dict [list CONFIG.Clock_Frequency {125}]           [get_bd_cells $cic025_0]
set_property -dict [list CONFIG.Input_Data_Width {14}]           [get_bd_cells $cic025_0]
set_property -dict [list CONFIG.Quantization {Full_Precision}]   [get_bd_cells $cic025_0]
set_property -dict [list CONFIG.Output_Data_Width {33}]          [get_bd_cells $cic025_0]
set_property -dict [list CONFIG.Use_Xtreme_DSP_Slice {false}]    [get_bd_cells $cic025_0]
set_property -dict [list CONFIG.Minimum_Rate {25}]               [get_bd_cells $cic025_0]
set_property -dict [list CONFIG.Maximum_Rate {25}]               [get_bd_cells $cic025_0]
set_property -dict [list CONFIG.SamplePeriod {1}]                [get_bd_cells $cic025_0]

set_property -dict [list CONFIG.Input_Data_Width.VALUE_SRC USER] [get_bd_cells $cic025_1]
set_property -dict [list CONFIG.Filter_Type {Decimation}]        [get_bd_cells $cic025_1]
set_property -dict [list CONFIG.Number_Of_Stages {4}]            [get_bd_cells $cic025_1]
set_property -dict [list CONFIG.Number_Of_Channels {1}]          [get_bd_cells $cic025_1]
set_property -dict [list CONFIG.Fixed_Or_Initial_Rate {25}]      [get_bd_cells $cic025_1]
set_property -dict [list CONFIG.Input_Sample_Frequency {125}]    [get_bd_cells $cic025_1]
set_property -dict [list CONFIG.Clock_Frequency {125}]           [get_bd_cells $cic025_1]
set_property -dict [list CONFIG.Input_Data_Width {14}]           [get_bd_cells $cic025_1]
set_property -dict [list CONFIG.Quantization {Full_Precision}]   [get_bd_cells $cic025_1]
set_property -dict [list CONFIG.Output_Data_Width {33}]          [get_bd_cells $cic025_1]
set_property -dict [list CONFIG.Use_Xtreme_DSP_Slice {false}]    [get_bd_cells $cic025_1]
set_property -dict [list CONFIG.Minimum_Rate {25}]               [get_bd_cells $cic025_1]
set_property -dict [list CONFIG.Maximum_Rate {25}]               [get_bd_cells $cic025_1]
set_property -dict [list CONFIG.SamplePeriod {1}]                [get_bd_cells $cic025_1]

set_property -dict [list CONFIG.Input_Data_Width.VALUE_SRC USER] [get_bd_cells $cic125_0]
set_property -dict [list CONFIG.Filter_Type {Decimation}]        [get_bd_cells $cic125_0]
set_property -dict [list CONFIG.Number_Of_Stages {4}]            [get_bd_cells $cic125_0]
set_property -dict [list CONFIG.Number_Of_Channels {1}]          [get_bd_cells $cic125_0]
set_property -dict [list CONFIG.Fixed_Or_Initial_Rate {125}]     [get_bd_cells $cic125_0]
set_property -dict [list CONFIG.Input_Sample_Frequency {125}]    [get_bd_cells $cic125_0]
set_property -dict [list CONFIG.Clock_Frequency {125}]           [get_bd_cells $cic125_0]
set_property -dict [list CONFIG.Input_Data_Width {14}]           [get_bd_cells $cic125_0]
set_property -dict [list CONFIG.Quantization {Full_Precision}]   [get_bd_cells $cic125_0]
set_property -dict [list CONFIG.Output_Data_Width {42}]          [get_bd_cells $cic125_0]
set_property -dict [list CONFIG.Use_Xtreme_DSP_Slice {false}]    [get_bd_cells $cic125_0]
set_property -dict [list CONFIG.Minimum_Rate {125}]              [get_bd_cells $cic125_0]
set_property -dict [list CONFIG.Maximum_Rate {125}]              [get_bd_cells $cic125_0]
set_property -dict [list CONFIG.SamplePeriod {1}]                [get_bd_cells $cic125_0]

set_property -dict [list CONFIG.Input_Data_Width.VALUE_SRC USER] [get_bd_cells $cic125_1]
set_property -dict [list CONFIG.Filter_Type {Decimation}]        [get_bd_cells $cic125_1]
set_property -dict [list CONFIG.Number_Of_Stages {4}]            [get_bd_cells $cic125_1]
set_property -dict [list CONFIG.Number_Of_Channels {1}]          [get_bd_cells $cic125_1]
set_property -dict [list CONFIG.Fixed_Or_Initial_Rate {125}]     [get_bd_cells $cic125_1]
set_property -dict [list CONFIG.Input_Sample_Frequency {125}]    [get_bd_cells $cic125_1]
set_property -dict [list CONFIG.Clock_Frequency {125}]           [get_bd_cells $cic125_1]
set_property -dict [list CONFIG.Input_Data_Width {14}]           [get_bd_cells $cic125_1]
set_property -dict [list CONFIG.Quantization {Full_Precision}]   [get_bd_cells $cic125_1]
set_property -dict [list CONFIG.Output_Data_Width {42}]          [get_bd_cells $cic125_1]
set_property -dict [list CONFIG.Use_Xtreme_DSP_Slice {false}]    [get_bd_cells $cic125_1]
set_property -dict [list CONFIG.Minimum_Rate {125}]              [get_bd_cells $cic125_1]
set_property -dict [list CONFIG.Maximum_Rate {125}]              [get_bd_cells $cic125_1]
set_property -dict [list CONFIG.SamplePeriod {1}]                [get_bd_cells $cic125_1]

# ====================================================================================
# Connections

if {$sim eq ""} {
 	# Normal project

 	# Distribute Clocks
 	connect_bd_net [get_bd_pins ps/M_AXI_GP0_ACLK]    [get_bd_pins ps/S_AXI_HP0_ACLK]
	connect_bd_net [get_bd_pins ps/M_AXI_GP0_ACLK]    [get_bd_pins clk_wiz_adc/clk_out1]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins system_rst/slowest_sync_clk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins S2Mconverter/aclk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins M2Sconverter/aclk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins axis2lanes/ClkxCI]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins logger/MAxiClkxCI]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins logger/SAxiAClkxCI]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins logger/ClkxCI]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $mux0/ClkxCI]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $mux1/ClkxCI]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $mux2/ClkxCI]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $mux3/ClkxCI]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $fircomp_instance_2steep/aclk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $fircomp_instance_2flat/aclk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $fircomp_instance_5steep/aclk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $fircomp_instance_5flat/aclk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $fircomp_instance_cfir025/aclk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $fircomp_instance_cfir125/aclk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $cic025_0/aclk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $cic025_1/aclk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $cic125_0/aclk]
	connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $cic125_1/aclk]

	# Distribute Resets
	connect_bd_net [get_bd_pins system_rst/ext_reset_in]         [get_bd_pins clk_wiz_adc/locked]
	connect_bd_net [get_bd_pins system_rst/peripheral_aresetn]   [get_bd_pins axis2lanes/RstxRBI]
	connect_bd_net [get_bd_pins system_rst/peripheral_aresetn]   [get_bd_pins logger/MAxiRstxRBI]
	connect_bd_net [get_bd_pins system_rst/peripheral_aresetn]   [get_bd_pins logger/SAxiAResetxRBI]
	connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins M2Sconverter/aresetn]
	connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins S2Mconverter/aresetn]
	connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins $mux0/RstxRBI]
	connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins $mux1/RstxRBI]
	connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins $mux2/RstxRBI]
	connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins $mux3/RstxRBI]
} else {
	# Sim project

	# Distribute Clocks
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins axis2lanes/ClkxCI]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins waveform/aclk]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $mux0/ClkxCI]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $mux1/ClkxCI]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $mux2/ClkxCI]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $mux3/ClkxCI]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $fircomp_instance_2steep/aclk]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $fircomp_instance_2flat/aclk]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $fircomp_instance_5steep/aclk]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $fircomp_instance_5flat/aclk]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $fircomp_instance_cfir025/aclk]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $fircomp_instance_cfir125/aclk]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $cic025_0/aclk]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $cic025_1/aclk]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $cic125_0/aclk]
	connect_bd_net [get_bd_pins clk_gen/clk] [get_bd_pins $cic125_1/aclk]

	# Distribute Resets
	connect_bd_net [get_bd_pins clk_gen/sync_rst]   [get_bd_pins axis2lanes/RstxRBI]
	connect_bd_net [get_bd_pins clk_gen/sync_rst] [get_bd_pins $mux0/RstxRBI]
	connect_bd_net [get_bd_pins clk_gen/sync_rst] [get_bd_pins $mux1/RstxRBI]
	connect_bd_net [get_bd_pins clk_gen/sync_rst] [get_bd_pins $mux2/RstxRBI]
	connect_bd_net [get_bd_pins clk_gen/sync_rst] [get_bd_pins $mux3/RstxRBI]
}


if {$sim eq ""} {
 	# Normal project
} else {
	# Sim project
}

if {$sim eq ""} {
 	# Normal project

 	# Blinking LED
	connect_bd_net [get_bd_pins Cnt2Hz/Q]   [get_bd_pins Slc2Hz/Din]
	connect_bd_net [get_bd_ports led_o]     [get_bd_pins Slc2Hz/Dout]
	connect_bd_net [get_bd_pins Cnt2Hz/CLK] [get_bd_pins clk_wiz_adc/clk_out1]

 	# ADC to Logger
	connect_bd_net [get_bd_pins logger/Data0xDI]     [get_bd_pins axis2lanes/Data0xDO]
	connect_bd_net [get_bd_pins axis2lanes/Data1xDO] [get_bd_pins logger/Data1xDI]

 	# Clock & DataStrobe to Logger
	connect_bd_net [get_bd_pins logger/DataStrobexSI] [get_bd_pins axis2lanes/DataStrobexDO]

 	# AXI Converters
	connect_bd_intf_net [get_bd_intf_pins M2Sconverter/M_AXI] [get_bd_intf_pins ps/S_AXI_HP0]
	connect_bd_intf_net [get_bd_intf_pins M2Sconverter/S_AXI] [get_bd_intf_pins logger/M0]
	connect_bd_intf_net [get_bd_intf_pins S2Mconverter/S_AXI] [get_bd_intf_pins ps/M_AXI_GP0]
	connect_bd_intf_net [get_bd_intf_pins S2Mconverter/M_AXI] [get_bd_intf_pins logger/S0]

	# ZYNQ7 Processing System to Zynq Logger
	connect_bd_net [get_bd_pins ps/IRQ_F2P] [get_bd_pins logger/IRQxSO]
} else {
	# Sim project
}

# Filter Chain
# Stage 0 (last stage: direct path, Steep Halfband Filter)
# We are connecting the chain backwards from its output
connect_bd_intf_net [get_bd_intf_pins $mux0/MO]                             [get_bd_intf_pins axis2lanes/SI]

# Stage 3 (direct path, cic25, cic125)
connect_bd_net      [get_bd_pins      $concat0/dout]                         [get_bd_pins      $mux3/Data0xDI]

connect_bd_net      [get_bd_pins $concat1/dout]                              [get_bd_pins $concat0/In0]
connect_bd_net      [get_bd_pins $concat2/dout]                              [get_bd_pins $concat0/In1]
connect_bd_net      [get_bd_pins $const0/dout]                               [get_bd_pins $concat1/In0]
connect_bd_net      [get_bd_pins $slice13/Dout]                              [get_bd_pins $concat1/In1]
connect_bd_net      [get_bd_pins $slice0/Dout]                               [get_bd_pins $concat1/In2]
connect_bd_net      [get_bd_pins $const0/dout]                               [get_bd_pins $concat2/In0]
connect_bd_net      [get_bd_pins $slice14/Dout]                              [get_bd_pins $concat2/In1]
connect_bd_net      [get_bd_pins $slice1/Dout]                               [get_bd_pins $concat2/In2]
connect_bd_net      [get_bd_pins $slice13/Dout]                              [get_bd_pins $slice0/Din]
connect_bd_net      [get_bd_pins $slice14/Dout]                              [get_bd_pins $slice1/Din]
connect_bd_net      [get_bd_pins $concat3/dout]                              [get_bd_pins $fircomp_instance_cfir025/s_axis_data_tdata]
connect_bd_net      [get_bd_pins $concat4/dout]                              [get_bd_pins $fircomp_instance_cfir125/s_axis_data_tdata]
connect_bd_net      [get_bd_pins $cic025_0/m_axis_data_tvalid]               [get_bd_pins $fircomp_instance_cfir025/s_axis_data_tvalid]
connect_bd_net      [get_bd_pins $cic125_0/m_axis_data_tvalid]               [get_bd_pins $fircomp_instance_cfir125/s_axis_data_tvalid]
connect_bd_net      [get_bd_pins $concat5/dout]                              [get_bd_pins $concat3/In0]
connect_bd_net      [get_bd_pins $concat6/dout]                              [get_bd_pins $concat3/In1]
connect_bd_net      [get_bd_pins $concat7/dout]                              [get_bd_pins $concat4/In0]
connect_bd_net      [get_bd_pins $concat8/dout]                              [get_bd_pins $concat4/In1]
connect_bd_net      [get_bd_pins $const0/dout]                               [get_bd_pins $concat5/In0]
connect_bd_net      [get_bd_pins $slice6/Dout]                               [get_bd_pins $concat5/In1]
connect_bd_net      [get_bd_pins $slice6/Dout]                               [get_bd_pins $slice2/Din]
connect_bd_net      [get_bd_pins $slice2/Dout]                               [get_bd_pins $concat5/In2]
connect_bd_net      [get_bd_pins $const0/dout]                               [get_bd_pins $concat6/In0]
connect_bd_net      [get_bd_pins $slice7/Dout]                               [get_bd_pins $concat6/In1]
connect_bd_net      [get_bd_pins $slice7/Dout]                               [get_bd_pins $slice3/Din]
connect_bd_net      [get_bd_pins $slice3/Dout]                               [get_bd_pins $concat6/In2]
connect_bd_net      [get_bd_pins $const0/dout]                               [get_bd_pins $concat7/In0]
connect_bd_net      [get_bd_pins $slice8/Dout]                               [get_bd_pins $concat7/In1]
connect_bd_net      [get_bd_pins $slice8/Dout]                               [get_bd_pins $slice4/Din]
connect_bd_net      [get_bd_pins $slice4/Dout]                               [get_bd_pins $concat7/In2]
connect_bd_net      [get_bd_pins $const0/dout]                               [get_bd_pins $concat8/In0]
connect_bd_net      [get_bd_pins $slice9/Dout]                               [get_bd_pins $concat8/In1]
connect_bd_net      [get_bd_pins $slice9/Dout]                               [get_bd_pins $slice5/Din]
connect_bd_net      [get_bd_pins $slice5/Dout]                               [get_bd_pins $concat8/In2]
connect_bd_net      [get_bd_pins $cic025_0/m_axis_data_tdata]               [get_bd_pins $slice6/Din]
connect_bd_net      [get_bd_pins $cic025_1/m_axis_data_tdata]                [get_bd_pins $slice7/Din]
connect_bd_net      [get_bd_pins $cic125_0/m_axis_data_tdata]               [get_bd_pins $slice8/Din]
connect_bd_net      [get_bd_pins $cic125_1/m_axis_data_tdata]                [get_bd_pins $slice9/Din]
connect_bd_net [get_bd_pins $slice13/Dout]                      [get_bd_pins $cic025_0/s_axis_data_tdata]
connect_bd_net [get_bd_pins $slice14/Dout]                      [get_bd_pins $cic025_1/s_axis_data_tdata]
connect_bd_net [get_bd_pins $slice13/Dout]                      [get_bd_pins $cic125_0/s_axis_data_tdata]
connect_bd_net [get_bd_pins $slice14/Dout]                      [get_bd_pins $cic125_1/s_axis_data_tdata]

# ADC TO MUX 3
connect_bd_net      [get_bd_pins waveform/m_axis_data_tvalid]                [get_bd_pins $mux3/Valid0xSI]

# FIR 1 To MUX 3
w64to48 fir1_025_mux3 $fircomp_instance_cfir025/m_axis_data_tdata $mux3/Data1xDI
w64to48 fir1_125_mux3 $fircomp_instance_cfir125/m_axis_data_tdata $mux3/Data2xDI
connect_bd_net      [get_bd_pins $fircomp_instance_cfir025/m_axis_data_tvalid]                [get_bd_pins $mux3/Valid1xSI]
connect_bd_net      [get_bd_pins $fircomp_instance_cfir125/m_axis_data_tvalid]                [get_bd_pins $mux3/Valid2xSI]

# MUX 3 TO FIR 5 FLAT
connect_bd_net      [get_bd_pins $mux3/DataxDO]                [get_bd_pins $fircomp_instance_5flat/s_axis_data_tdata]
connect_bd_net      [get_bd_pins $mux3/ValidxSO]               [get_bd_pins $fircomp_instance_5flat/s_axis_data_tvalid]

# MUX 3 TO MUX 2
connect_bd_net      [get_bd_pins $mux3/DataxDO]                [get_bd_pins $mux2/Data0xDI]
connect_bd_net      [get_bd_pins $mux3/ValidxSO]               [get_bd_pins $mux2/Valid0xSI]

# FIR 5 FLAT TO MUX 2
w64to48 fir5_flat_mux2 $fircomp_instance_5flat/m_axis_data_tdata $mux2/Data1xDI
connect_bd_net      [get_bd_pins $fircomp_instance_5flat/m_axis_data_tvalid] [get_bd_pins $mux2/Valid1xSI]

# MUX 2 TO FIR 5 STEEP
connect_bd_net      [get_bd_pins $mux2/DataxDO]                [get_bd_pins $fircomp_instance_5steep/s_axis_data_tdata]
connect_bd_net      [get_bd_pins $mux2/ValidxSO]               [get_bd_pins $fircomp_instance_5steep/s_axis_data_tvalid]

# MUX 2 TO FIR 2 FLAT
connect_bd_net      [get_bd_pins $mux2/DataxDO]                [get_bd_pins $fircomp_instance_2flat/s_axis_data_tdata]
connect_bd_net      [get_bd_pins $mux2/ValidxSO]               [get_bd_pins $fircomp_instance_2flat/s_axis_data_tvalid]

# MUX 2 TO MUX 1
connect_bd_net      [get_bd_pins $mux2/DataxDO]                [get_bd_pins $mux1/Data0xDI]
connect_bd_net      [get_bd_pins $mux2/ValidxSO]               [get_bd_pins $mux1/Valid0xSI]

# FIR 5 STEEP TO MUX 1
w64to48 fir5_steep_mux1 $fircomp_instance_5steep/m_axis_data_tdata $mux1/Data1xDI
connect_bd_net      [get_bd_pins $fircomp_instance_5steep/m_axis_data_tvalid] [get_bd_pins $mux1/Valid1xSI]

# FIR 2 FLAT TO MUX 1
w64to48 fir2_flat_mux1 $fircomp_instance_2flat/m_axis_data_tdata $mux1/Data2xDI
connect_bd_net      [get_bd_pins $fircomp_instance_2flat/m_axis_data_tvalid] [get_bd_pins $mux1/Valid2xSI]

# MUX 1 TO MUX 0
connect_bd_net      [get_bd_pins $mux1/DataxDO]                [get_bd_pins $mux0/Data0xDI]
connect_bd_net      [get_bd_pins $mux1/ValidxSO]               [get_bd_pins $mux0/Valid0xSI]

# MUX 1 TO FIR 2 STEEP
connect_bd_net      [get_bd_pins $mux1/DataxDO]                [get_bd_pins $fircomp_instance_2steep/s_axis_data_tdata]
connect_bd_net      [get_bd_pins $mux1/ValidxSO]               [get_bd_pins $fircomp_instance_2steep/s_axis_data_tvalid]

# FIR 2 STEEP TO MUX 0
w64to48 fir2_steep_mux0 $fircomp_instance_2steep/m_axis_data_tdata $mux0/Data1xDI
connect_bd_net      [get_bd_pins $fircomp_instance_2steep/m_axis_data_tvalid] [get_bd_pins $mux0/Valid1xSI]

if {$sim eq ""} {
 	# Normal project

 	# ADC Input
 	# TODO:
} else {
	# Sim project

	# ADC Input
	connect_bd_net [get_bd_pins $slice13/Din] [get_bd_pins waveform/m_axis_data_tdata]
	connect_bd_net [get_bd_pins $slice14/Din] [get_bd_pins waveform/m_axis_data_tdata]
	connect_bd_net [get_bd_pins $cic025_0/s_axis_data_tvalid]  [get_bd_pins waveform/m_axis_data_tvalid]
	connect_bd_net [get_bd_pins $cic025_1/s_axis_data_tvalid]  [get_bd_pins waveform/m_axis_data_tvalid]
	connect_bd_net [get_bd_pins $cic125_0/s_axis_data_tvalid]  [get_bd_pins waveform/m_axis_data_tvalid]
	connect_bd_net [get_bd_pins $cic125_1/s_axis_data_tvalid]  [get_bd_pins waveform/m_axis_data_tvalid]
}

# Connect Control Logic
connect_bd_net [get_bd_pins $const1/dout] [get_bd_pins $ctrl0/DecRate]
connect_bd_net [get_bd_pins $ctrl0/Mux0]  [get_bd_pins $mux0/SelectxDI]
connect_bd_net [get_bd_pins $ctrl0/Mux1]  [get_bd_pins $mux1/SelectxDI]
connect_bd_net [get_bd_pins $ctrl0/Mux2]  [get_bd_pins $mux2/SelectxDI]
connect_bd_net [get_bd_pins $ctrl0/Mux3]  [get_bd_pins $mux3/SelectxDI]

if {$sim eq ""} {
 	# Normal project

 	# Assign Address to Logger MMIO Slave
	assign_bd_address [get_bd_addr_segs {logger/S0/Reg }]
} else {
	# Sim project
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

# TODO: figure out what this does
set_property VERILOG_DEFINE {TOOL_VIVADO} [current_fileset]
set_property STRATEGY Flow_PerfOptimized_High [get_runs synth_1]
set_property STRATEGY Performance_NetDelay_high [get_runs impl_1]
# TODO: figure out what this does


save_bd_design
