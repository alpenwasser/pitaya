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

# The Logger module
create_bd_cell -type ip -vlnv bastli:user:zynq_logger:1.1 logger

# Create Multiplexers
set mux0 axis_multiplexer_0
set mux1 axis_multiplexer_1
set mux2 axis_multiplexer_2
set mux3 axis_multiplexer_3
set mux4 axis_multiplexer_4
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux0
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux1
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux2
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux3
create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 $mux4
# Configure Multiplexers
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS {2}] [get_bd_cells $mux0]
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS {3}] [get_bd_cells $mux1]
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS {2}] [get_bd_cells $mux2]
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS {3}] [get_bd_cells $mux3]
set_property -dict [list CONFIG.C_AXIS_NUM_SI_SLOTS {2}] [get_bd_cells $mux4]

# Broadcasters
set cast0 axis_broadcaster_0
set cast1 axis_broadcaster_1
set cast2 axis_broadcaster_2
set cast3 axis_broadcaster_3
set cast4 axis_broadcaster_4
set cast5 axis_broadcaster_5

create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 $cast0
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 $cast1
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 $cast2
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 $cast3
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 $cast4
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 $cast5

set_property -dict [list CONFIG.NUM_MI {2}] [get_bd_cells $cast0]
set_property -dict [list CONFIG.NUM_MI {3}] [get_bd_cells $cast1]
set_property -dict [list CONFIG.NUM_MI {2}] [get_bd_cells $cast2]
set_property -dict [list CONFIG.NUM_MI {3}] [get_bd_cells $cast3]
set_property -dict [list CONFIG.NUM_MI {2}] [get_bd_cells $cast4]
set_property -dict [list CONFIG.NUM_MI {2}] [get_bd_cells $cast5]

set_property -dict [list CONFIG.M_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells $cast0]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells $cast0]
set_property -dict [list CONFIG.HAS_TREADY.VALUE_SRC USER]        [get_bd_cells $cast0]
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells $cast1]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells $cast1]
set_property -dict [list CONFIG.HAS_TREADY.VALUE_SRC USER]        [get_bd_cells $cast1]
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells $cast2]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells $cast2]
set_property -dict [list CONFIG.HAS_TREADY.VALUE_SRC USER]        [get_bd_cells $cast2]
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells $cast3]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells $cast3]
set_property -dict [list CONFIG.HAS_TREADY.VALUE_SRC USER]        [get_bd_cells $cast3]
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells $cast4]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells $cast4]
set_property -dict [list CONFIG.HAS_TREADY.VALUE_SRC USER]        [get_bd_cells $cast4]

set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {4}]            [get_bd_cells $cast0]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES {4}]            [get_bd_cells $cast0]
set_property -dict [list CONFIG.M00_TDATA_REMAP {tdata[31:0]}]    [get_bd_cells $cast0]
set_property -dict [list CONFIG.M01_TDATA_REMAP {tdata[31:0]}]    [get_bd_cells $cast0]
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {4}]            [get_bd_cells $cast1]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES {4}]            [get_bd_cells $cast1]
set_property -dict [list CONFIG.M00_TDATA_REMAP {tdata[31:0]}]    [get_bd_cells $cast1]
set_property -dict [list CONFIG.M01_TDATA_REMAP {tdata[31:0]}]    [get_bd_cells $cast1]
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {4}]            [get_bd_cells $cast2]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES {4}]            [get_bd_cells $cast2]
set_property -dict [list CONFIG.M00_TDATA_REMAP {tdata[31:0]}]    [get_bd_cells $cast2]
set_property -dict [list CONFIG.M01_TDATA_REMAP {tdata[31:0]}]    [get_bd_cells $cast2]
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {4}]            [get_bd_cells $cast3]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES {4}]            [get_bd_cells $cast3]
set_property -dict [list CONFIG.M00_TDATA_REMAP {tdata[31:0]}]    [get_bd_cells $cast3]
set_property -dict [list CONFIG.M01_TDATA_REMAP {tdata[31:0]}]    [get_bd_cells $cast3]
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {4}]            [get_bd_cells $cast4]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES {4}]            [get_bd_cells $cast4]
set_property -dict [list CONFIG.M00_TDATA_REMAP {tdata[31:0]}]    [get_bd_cells $cast4]
set_property -dict [list CONFIG.M01_TDATA_REMAP {tdata[31:0]}]    [get_bd_cells $cast4]
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {2}]            [get_bd_cells $cast5]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES {4}]            [get_bd_cells $cast5]
set_property -dict [list CONFIG.M00_TDATA_REMAP {tdata[31:16]}]   [get_bd_cells $cast5]
set_property -dict [list CONFIG.M01_TDATA_REMAP {tdata[15:0]}]    [get_bd_cells $cast5]

# Combiner
set combiner0 axis_combiner_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_combiner:1.1 $combiner0
set_property -dict [list CONFIG.TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells $combiner0]
set_property -dict [list CONFIG.TDATA_NUM_BYTES {2}]            [get_bd_cells $combiner0]

# CIC Compilers
set cic0 cic_compiler_0
set cic1 cic_compiler_1
create_bd_cell -type ip -vlnv xilinx.com:ip:cic_compiler:4.0 $cic0
create_bd_cell -type ip -vlnv xilinx.com:ip:cic_compiler:4.0 $cic1

set_property -dict [list CONFIG.Input_Data_Width.VALUE_SRC USER] [get_bd_cells $cic0]
set_property -dict [list CONFIG.Filter_Type {Decimation}]        [get_bd_cells $cic0]
set_property -dict [list CONFIG.Number_Of_Stages {4}]            [get_bd_cells $cic0]
set_property -dict [list CONFIG.Number_Of_Channels {1}]          [get_bd_cells $cic0]
set_property -dict [list CONFIG.Fixed_Or_Initial_Rate {25}]      [get_bd_cells $cic0]
set_property -dict [list CONFIG.Input_Sample_Frequency {125}]    [get_bd_cells $cic0]
set_property -dict [list CONFIG.Clock_Frequency {125}]           [get_bd_cells $cic0]
set_property -dict [list CONFIG.Input_Data_Width {16}]           [get_bd_cells $cic0]
set_property -dict [list CONFIG.Quantization {Truncation}]       [get_bd_cells $cic0]
set_property -dict [list CONFIG.Output_Data_Width {16}]          [get_bd_cells $cic0]
set_property -dict [list CONFIG.Use_Xtreme_DSP_Slice {false}]    [get_bd_cells $cic0]
set_property -dict [list CONFIG.Minimum_Rate {25}]               [get_bd_cells $cic0]
set_property -dict [list CONFIG.Maximum_Rate {25}]               [get_bd_cells $cic0]
set_property -dict [list CONFIG.Input_Sample_Frequency {125}]    [get_bd_cells $cic0]
set_property -dict [list CONFIG.SamplePeriod {1}]                [get_bd_cells $cic0]

set_property -dict [list CONFIG.Input_Data_Width.VALUE_SRC USER] [get_bd_cells $cic1]
set_property -dict [list CONFIG.Filter_Type {Decimation}]        [get_bd_cells $cic1]
set_property -dict [list CONFIG.Number_Of_Stages {4}]            [get_bd_cells $cic1]
set_property -dict [list CONFIG.Number_Of_Channels {1}]          [get_bd_cells $cic1]
set_property -dict [list CONFIG.Fixed_Or_Initial_Rate {25}]      [get_bd_cells $cic1]
set_property -dict [list CONFIG.Input_Sample_Frequency {125}]    [get_bd_cells $cic1]
set_property -dict [list CONFIG.Clock_Frequency {125}]           [get_bd_cells $cic1]
set_property -dict [list CONFIG.Input_Data_Width {16}]           [get_bd_cells $cic1]
set_property -dict [list CONFIG.Quantization {Truncation}]       [get_bd_cells $cic1]
set_property -dict [list CONFIG.Output_Data_Width {16}]          [get_bd_cells $cic1]
set_property -dict [list CONFIG.Use_Xtreme_DSP_Slice {false}]    [get_bd_cells $cic1]
set_property -dict [list CONFIG.Minimum_Rate {25}]               [get_bd_cells $cic1]
set_property -dict [list CONFIG.Maximum_Rate {25}]               [get_bd_cells $cic1]
set_property -dict [list CONFIG.Input_Sample_Frequency {125}]    [get_bd_cells $cic1]
set_property -dict [list CONFIG.SamplePeriod {1}]                [get_bd_cells $cic1]


# FIR CompilerS
set vlnv_fircomp xilinx.com:ip:fir_compiler:7.2
set clk 125
set fs_dec5steep $clk
set fs_dec5flat $clk
set fs_comp025 5
set fs_comp125 1
set fs_dec2flat 0.2
set fs_dec2steep 0.2
set dataWidth 16
set fracBits 8
# current_dir: resolves to firmware/fpga/build/src
set coef_dir "${current_dir}/../../src/coefData"
# Coefficient files
set coef_comp025   "${coef_dir}/comp025.coe"
set coef_comp125   "${coef_dir}/comp125.coe"
set coef_dec5flat  "${coef_dir}/dec5flat.coe"
set coef_dec5steep "${coef_dir}/dec5steep.coe"
set coef_halfband  "${coef_dir}/halfband.coe"
set coef_dec2flat  $coef_halfband
set coef_dec2steep $coef_halfband

set fircomp_instance "fir5_steep"
set fircomp_instance_5steep $fircomp_instance
create_bd_cell -type ip -vlnv $vlnv_fircomp $fircomp_instance
set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File $coef_dec5steep] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Type {Decimation}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Decimation_Rate 5]                                                    [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Sample_Frequency $fs_dec5steep]                                       [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.BestPrecision {true}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}]                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Width $dataWidth]                                              [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sets {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Channels {1}]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Paths {2}]                                                     [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}]                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Quantization {Quantize_Only}]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Width $dataWidth]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Fractional_Bits $fracBits]                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}]                                     [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Width $dataWidth]                                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}]                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.ColumnConfig {31}] [get_bd_cells $fircomp_instance]                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.M_DATA_Has_TREADY {true}]                                             [get_bd_cells $fircomp_instance]

set fircomp_instance "fir5_flat"
set fircomp_instance_5flat $fircomp_instance
create_bd_cell -type ip -vlnv $vlnv_fircomp $fircomp_instance
set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File $coef_dec5flat]  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Type {Decimation}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Decimation_Rate 5]                                                    [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Sample_Frequency $fs_dec5flat]                                        [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.BestPrecision {true}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}]                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Width $dataWidth]                                              [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sets {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Channels {1}]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Paths {2}]                                                     [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}]                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Quantization {Quantize_Only}]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Width $dataWidth]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Fractional_Bits $fracBits]                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}]                                     [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Width $dataWidth]                                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}]                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.ColumnConfig {31}] [get_bd_cells $fircomp_instance]                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.M_DATA_Has_TREADY {true}]                                             [get_bd_cells $fircomp_instance]


set fircomp_instance "fir2_steep"
set fircomp_instance_2steep $fircomp_instance
create_bd_cell -type ip -vlnv $vlnv_fircomp $fircomp_instance
set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File $coef_dec2steep] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Type {Decimation}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Decimation_Rate 2]                                                    [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Sample_Frequency $fs_dec2steep]                                       [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.BestPrecision {true}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}]                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Width $dataWidth]                                              [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sets {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Channels {1}]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Paths {2}]                                                     [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}]                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Quantization {Quantize_Only}]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Width $dataWidth]                                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Fractional_Bits $fracBits]                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}]                                     [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Width $dataWidth]                                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}]                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.ColumnConfig {31}] [get_bd_cells $fircomp_instance]                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.M_DATA_Has_TREADY {true}]                                             [get_bd_cells $fircomp_instance]

set fircomp_instance "fir2_flat"
set fircomp_instance_2flat $fircomp_instance
create_bd_cell -type ip -vlnv $vlnv_fircomp $fircomp_instance
set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER]                                           [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File $coef_dec2flat] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Type {Decimation}]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Decimation_Rate 2]                                                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Sample_Frequency $fs_dec2flat]                                       [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.BestPrecision {true}]                                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}]                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Width $dataWidth]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sets {1}]                                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate {1}]                                              [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}]                                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Channels {1}]                                                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Paths {2}]                                                    [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}]                         [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}]                                           [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Quantization {Quantize_Only}]                                        [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Width $dataWidth]                                        [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Fractional_Bits $fracBits]                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}]                                    [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Width $dataWidth]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}]                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.ColumnConfig {31}] [get_bd_cells $fircomp_instance]                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.M_DATA_Has_TREADY {true}]                                            [get_bd_cells $fircomp_instance]


set fircomp_instance "fir5_comp025"
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
set_property -dict [list CONFIG.Output_Width $dataWidth]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sets {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate {1}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Channels {1}]                                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Paths {2}]                                                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}]                        [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}]                                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Quantization {Quantize_Only}]                                       [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Width $dataWidth]                                       [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Fractional_Bits $fracBits]                              [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}]                                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Width $dataWidth]                                              [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}]                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.ColumnConfig {31}] [get_bd_cells $fircomp_instance]                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.M_DATA_Has_TREADY {true}]                                           [get_bd_cells $fircomp_instance]


set fircomp_instance "fir5_comp125"
set fircomp_instance_cfir125 $fircomp_instance
create_bd_cell -type ip -vlnv $vlnv_fircomp $fircomp_instance
set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER]                                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File $coef_comp125] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Type {Decimation}]                                           [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Decimation_Rate 5]                                                  [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Sample_Frequency $fs_comp125]                                       [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.BestPrecision {true}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}]                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Width $dataWidth]                                            [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sets {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate {1}]                                             [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Channels {1}]                                                [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Paths {2}]                                                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}]                        [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk]                                               [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}]                                          [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Quantization {Quantize_Only}]                                       [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Width $dataWidth]                                       [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Fractional_Bits $fracBits]                              [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}]                                   [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Width $dataWidth]                                              [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}]                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.ColumnConfig {31}] [get_bd_cells $fircomp_instance]                 [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.M_DATA_Has_TREADY {true}]                                           [get_bd_cells $fircomp_instance]
# ====================================================================================
# Connections

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
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $combiner0/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $mux0/ClkxCI]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $mux1/ClkxCI]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $mux2/ClkxCI]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $mux3/ClkxCI]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $mux4/ClkxCI]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $cast0/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $cast1/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $cast2/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $cast3/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $cast4/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $cast5/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $cic0/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $cic1/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $fircomp_instance_5steep/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $fircomp_instance_5flat/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $fircomp_instance_2steep/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $fircomp_instance_2flat/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $fircomp_instance_cfir025/aclk]
connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins $fircomp_instance_cfir125/aclk]

# Distribute Resets
connect_bd_net [get_bd_pins system_rst/ext_reset_in]         [get_bd_pins clk_wiz_adc/locked]
connect_bd_net [get_bd_pins system_rst/peripheral_aresetn]   [get_bd_pins axis2lanes/RstxRBI]
connect_bd_net [get_bd_pins system_rst/peripheral_aresetn]   [get_bd_pins logger/MAxiRstxRBI]            
connect_bd_net [get_bd_pins system_rst/peripheral_aresetn]   [get_bd_pins logger/SAxiAResetxRBI]         
connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins M2Sconverter/aresetn]          
connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins S2Mconverter/aresetn]          
connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins $combiner0/aresetn]            
connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins $mux0/RstxRBI]
connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins $mux1/RstxRBI]
connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins $mux2/RstxRBI]
connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins $mux3/RstxRBI]
connect_bd_net [get_bd_pins system_rst/interconnect_aresetn] [get_bd_pins $mux4/RstxRBI]
connect_bd_net [get_bd_pins S2Mconverter/aresetn]            [get_bd_pins $cast0/aresetn]
connect_bd_net [get_bd_pins S2Mconverter/aresetn]            [get_bd_pins $cast1/aresetn]
connect_bd_net [get_bd_pins S2Mconverter/aresetn]            [get_bd_pins $cast2/aresetn]
connect_bd_net [get_bd_pins S2Mconverter/aresetn]            [get_bd_pins $cast3/aresetn]
connect_bd_net [get_bd_pins S2Mconverter/aresetn]            [get_bd_pins $cast4/aresetn]
connect_bd_net [get_bd_pins S2Mconverter/aresetn]            [get_bd_pins $cast5/aresetn]

# Blinking LED
connect_bd_net [get_bd_pins Cnt2Hz/Q]   [get_bd_pins Slc2Hz/Din]
connect_bd_net [get_bd_ports led_o]     [get_bd_pins Slc2Hz/Dout]
connect_bd_net [get_bd_pins Cnt2Hz/CLK] [get_bd_pins clk_wiz_adc/clk_out1]

# ADC to Logger
connect_bd_net [get_bd_pins logger/Data0xDI]     [get_bd_pins axis2lanes/Data0xDO]
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
connect_bd_intf_net [get_bd_intf_pins adc/M_AXIS]        [get_bd_intf_pins $cast4/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins $cast4/M00_AXIS]   [get_bd_intf_pins $mux4/SI0]
connect_bd_intf_net [get_bd_intf_pins $cast4/M01_AXIS]   [get_bd_intf_pins $cast5/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins $cast5/M00_AXIS]   [get_bd_intf_pins $cic0/S_AXIS_DATA]
connect_bd_intf_net [get_bd_intf_pins $cast5/M01_AXIS]   [get_bd_intf_pins $cic1/S_AXIS_DATA]
connect_bd_intf_net [get_bd_intf_pins $cic0/M_AXIS_DATA] [get_bd_intf_pins $combiner0/S00_AXIS]
connect_bd_intf_net [get_bd_intf_pins $cic1/M_AXIS_DATA] [get_bd_intf_pins $combiner0/S01_AXIS]
connect_bd_intf_net [get_bd_intf_pins $combiner0/M_AXIS] [get_bd_intf_pins $mux4/SI1]
connect_bd_intf_net [get_bd_intf_pins $mux4/MO]          [get_bd_intf_pins $cast3/S_AXIS]

connect_bd_intf_net [get_bd_intf_pins $cast3/M00_AXIS]                       [get_bd_intf_pins $mux3/SI0]
connect_bd_intf_net [get_bd_intf_pins $cast3/M01_AXIS]                       [get_bd_intf_pins $fircomp_instance_cfir025/S_AXIS_DATA]
connect_bd_intf_net [get_bd_intf_pins $fircomp_instance_cfir025/M_AXIS_DATA] [get_bd_intf_pins $mux3/SI1]
connect_bd_intf_net [get_bd_intf_pins $cast3/M02_AXIS]                       [get_bd_intf_pins $fircomp_instance_cfir125/S_AXIS_DATA]
connect_bd_intf_net [get_bd_intf_pins $fircomp_instance_cfir125/M_AXIS_DATA] [get_bd_intf_pins $mux3/SI2]
connect_bd_intf_net [get_bd_intf_pins $mux3/MO]                              [get_bd_intf_pins $cast2/S_AXIS]

connect_bd_intf_net [get_bd_intf_pins $cast2/M00_AXIS]                     [get_bd_intf_pins $mux2/SI0]
connect_bd_intf_net [get_bd_intf_pins $cast2/M01_AXIS]                     [get_bd_intf_pins $fircomp_instance_5flat/S_AXIS_DATA]
connect_bd_intf_net [get_bd_intf_pins $fircomp_instance_5flat/M_AXIS_DATA] [get_bd_intf_pins $mux2/SI1]
connect_bd_intf_net [get_bd_intf_pins $mux2/MO]                            [get_bd_intf_pins $cast1/S_AXIS]

connect_bd_intf_net [get_bd_intf_pins $cast1/M00_AXIS]                      [get_bd_intf_pins $mux1/SI0]
connect_bd_intf_net [get_bd_intf_pins $cast1/M01_AXIS]                      [get_bd_intf_pins $fircomp_instance_2flat/S_AXIS_DATA]
connect_bd_intf_net [get_bd_intf_pins $fircomp_instance_2flat/M_AXIS_DATA]  [get_bd_intf_pins $mux1/SI1]
connect_bd_intf_net [get_bd_intf_pins $cast1/M02_AXIS]                      [get_bd_intf_pins $fircomp_instance_5steep/S_AXIS_DATA]
connect_bd_intf_net [get_bd_intf_pins $fircomp_instance_5steep/M_AXIS_DATA] [get_bd_intf_pins $mux1/SI2]
connect_bd_intf_net [get_bd_intf_pins $mux1/MO]                             [get_bd_intf_pins $cast0/S_AXIS]

connect_bd_intf_net [get_bd_intf_pins $cast0/M00_AXIS]                      [get_bd_intf_pins $mux0/SI0]
connect_bd_intf_net [get_bd_intf_pins $cast0/M01_AXIS]                      [get_bd_intf_pins $fircomp_instance_2steep/S_AXIS_DATA]
connect_bd_intf_net [get_bd_intf_pins $fircomp_instance_2steep/M_AXIS_DATA] [get_bd_intf_pins $mux0/SI1]
connect_bd_intf_net [get_bd_intf_pins $mux0/MO]                             [get_bd_intf_pins axis2lanes/SI]

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
