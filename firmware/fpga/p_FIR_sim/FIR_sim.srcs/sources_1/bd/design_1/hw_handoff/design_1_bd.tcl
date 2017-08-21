
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
}


# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports

  # Create instance: CIC25, and set properties
  set CIC25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cic_compiler:4.0 CIC25 ]
  set_property -dict [ list \
CONFIG.Clock_Frequency {125} \
CONFIG.Filter_Type {Decimation} \
CONFIG.Fixed_Or_Initial_Rate {25} \
CONFIG.Input_Data_Width {14} \
CONFIG.Input_Sample_Frequency {125} \
CONFIG.Maximum_Rate {25} \
CONFIG.Minimum_Rate {25} \
CONFIG.Number_Of_Stages {4} \
CONFIG.Output_Data_Width {33} \
CONFIG.SamplePeriod {1} \
 ] $CIC25

  # Create instance: CIC125, and set properties
  set CIC125 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cic_compiler:4.0 CIC125 ]
  set_property -dict [ list \
CONFIG.Clock_Frequency {125} \
CONFIG.Filter_Type {Decimation} \
CONFIG.Fixed_Or_Initial_Rate {125} \
CONFIG.Input_Data_Width {14} \
CONFIG.Input_Sample_Frequency {125} \
CONFIG.Maximum_Rate {125} \
CONFIG.Minimum_Rate {125} \
CONFIG.Number_Of_Stages {4} \
CONFIG.Output_Data_Width {42} \
CONFIG.SamplePeriod {1} \
 ] $CIC125

  # Create instance: COMP1, and set properties
  set COMP1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 COMP1 ]
  set_property -dict [ list \
CONFIG.Clock_Frequency {125} \
CONFIG.CoefficientSource {COE_File} \
CONFIG.Coefficient_File {../../../../../../../pitaya/firmware/fpga/p_chain5/coefData/comp025.coe} \
CONFIG.Coefficient_Fractional_Bits {16} \
CONFIG.Coefficient_Sets {1} \
CONFIG.Coefficient_Sign {Signed} \
CONFIG.Coefficient_Structure {Inferred} \
CONFIG.Coefficient_Width {16} \
CONFIG.ColumnConfig {1} \
CONFIG.Data_Fractional_Bits {7} \
CONFIG.Data_Width {24} \
CONFIG.Decimation_Rate {1} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Filter_Type {Single_Rate} \
CONFIG.Interpolation_Rate {1} \
CONFIG.Number_Channels {1} \
CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
CONFIG.Output_Width {32} \
CONFIG.Quantization {Quantize_Only} \
CONFIG.RateSpecification {Frequency_Specification} \
CONFIG.Sample_Frequency {5} \
CONFIG.Zero_Pack_Factor {1} \
 ] $COMP1

  # Create instance: COMP5, and set properties
  set COMP5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 COMP5 ]
  set_property -dict [ list \
CONFIG.Clock_Frequency {125} \
CONFIG.CoefficientSource {COE_File} \
CONFIG.Coefficient_File {../../../../../../../pitaya/firmware/fpga/p_chain5/coefData/comp125.coe} \
CONFIG.Coefficient_Fractional_Bits {16} \
CONFIG.Coefficient_Sets {1} \
CONFIG.Coefficient_Sign {Signed} \
CONFIG.Coefficient_Structure {Inferred} \
CONFIG.Coefficient_Width {16} \
CONFIG.ColumnConfig {1} \
CONFIG.Data_Fractional_Bits {7} \
CONFIG.Data_Width {24} \
CONFIG.Decimation_Rate {5} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Filter_Type {Decimation} \
CONFIG.Interpolation_Rate {1} \
CONFIG.Number_Channels {1} \
CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
CONFIG.Output_Width {32} \
CONFIG.Quantization {Quantize_Only} \
CONFIG.RateSpecification {Frequency_Specification} \
CONFIG.Sample_Frequency {1} \
CONFIG.Zero_Pack_Factor {1} \
 ] $COMP5

  # Create instance: DEC_SEL, and set properties
  set DEC_SEL [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 DEC_SEL ]
  set_property -dict [ list \
CONFIG.CONST_VAL {2500} \
CONFIG.CONST_WIDTH {32} \
 ] $DEC_SEL

  # Create instance: FIR5flat, and set properties
  set FIR5flat [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 FIR5flat ]
  set_property -dict [ list \
CONFIG.Clock_Frequency {125} \
CONFIG.CoefficientSource {COE_File} \
CONFIG.Coefficient_File {../../../../../../../pitaya/firmware/fpga/p_chain5/coefData/dec5flat.coe} \
CONFIG.Coefficient_Fractional_Bits {17} \
CONFIG.Coefficient_Sets {1} \
CONFIG.Coefficient_Sign {Signed} \
CONFIG.Coefficient_Structure {Inferred} \
CONFIG.Coefficient_Width {16} \
CONFIG.ColumnConfig {7} \
CONFIG.Data_Fractional_Bits {7} \
CONFIG.Data_Width {24} \
CONFIG.Decimation_Rate {5} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Filter_Type {Decimation} \
CONFIG.Interpolation_Rate {1} \
CONFIG.Number_Channels {1} \
CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
CONFIG.Output_Width {32} \
CONFIG.Quantization {Quantize_Only} \
CONFIG.RateSpecification {Frequency_Specification} \
CONFIG.Sample_Frequency {125} \
CONFIG.Zero_Pack_Factor {1} \
 ] $FIR5flat

  # Create instance: FIR5steep, and set properties
  set FIR5steep [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 FIR5steep ]
  set_property -dict [ list \
CONFIG.BestPrecision {false} \
CONFIG.Clock_Frequency {125} \
CONFIG.CoefficientSource {COE_File} \
CONFIG.Coefficient_File {../../../../../../../pitaya/firmware/fpga/p_chain5/coefData/dec5steep.coe} \
CONFIG.Coefficient_Fractional_Bits {17} \
CONFIG.Coefficient_Sets {1} \
CONFIG.Coefficient_Sign {Signed} \
CONFIG.Coefficient_Structure {Inferred} \
CONFIG.Coefficient_Width {16} \
CONFIG.ColumnConfig {21} \
CONFIG.Data_Fractional_Bits {7} \
CONFIG.Data_Width {24} \
CONFIG.Decimation_Rate {5} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Filter_Type {Decimation} \
CONFIG.Interpolation_Rate {1} \
CONFIG.Number_Channels {1} \
CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
CONFIG.Output_Width {32} \
CONFIG.Quantization {Quantize_Only} \
CONFIG.RateSpecification {Frequency_Specification} \
CONFIG.Sample_Frequency {125} \
CONFIG.Zero_Pack_Factor {1} \
 ] $FIR5steep

  # Create instance: HBflat, and set properties
  set HBflat [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 HBflat ]
  set_property -dict [ list \
CONFIG.BestPrecision {false} \
CONFIG.Clock_Frequency {125} \
CONFIG.CoefficientSource {COE_File} \
CONFIG.Coefficient_File {../../../../../../../pitaya/firmware/fpga/p_chain5/coefData/halfband.coe} \
CONFIG.Coefficient_Fractional_Bits {15} \
CONFIG.Coefficient_Sets {1} \
CONFIG.Coefficient_Sign {Signed} \
CONFIG.Coefficient_Structure {Inferred} \
CONFIG.Coefficient_Width {16} \
CONFIG.ColumnConfig {1} \
CONFIG.Data_Fractional_Bits {7} \
CONFIG.Data_Width {24} \
CONFIG.Decimation_Rate {2} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Filter_Type {Decimation} \
CONFIG.Interpolation_Rate {1} \
CONFIG.Number_Channels {1} \
CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
CONFIG.Output_Width {32} \
CONFIG.Quantization {Quantize_Only} \
CONFIG.RateSpecification {Frequency_Specification} \
CONFIG.Sample_Frequency {0.5} \
CONFIG.Zero_Pack_Factor {1} \
 ] $HBflat

  # Create instance: HBsteep, and set properties
  set HBsteep [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 HBsteep ]
  set_property -dict [ list \
CONFIG.BestPrecision {false} \
CONFIG.Clock_Frequency {125} \
CONFIG.CoefficientSource {COE_File} \
CONFIG.Coefficient_File {../../../../../../../pitaya/firmware/fpga/p_chain5/coefData/halfband.coe} \
CONFIG.Coefficient_Fractional_Bits {15} \
CONFIG.Coefficient_Sets {1} \
CONFIG.Coefficient_Sign {Signed} \
CONFIG.Coefficient_Structure {Inferred} \
CONFIG.Coefficient_Width {16} \
CONFIG.ColumnConfig {1} \
CONFIG.Data_Fractional_Bits {7} \
CONFIG.Data_Width {24} \
CONFIG.Decimation_Rate {2} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Filter_Type {Decimation} \
CONFIG.Interpolation_Rate {1} \
CONFIG.Number_Channels {1} \
CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
CONFIG.Output_Width {32} \
CONFIG.Quantization {Quantize_Only} \
CONFIG.RateSpecification {Frequency_Specification} \
CONFIG.Sample_Frequency {0.5} \
CONFIG.Zero_Pack_Factor {1} \
 ] $HBsteep

  # Create instance: MUX0, and set properties
  set MUX0 [ create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 MUX0 ]
  set_property -dict [ list \
CONFIG.C_AXIS_TDATA_WIDTH {24} \
 ] $MUX0

  # Create instance: MUX1, and set properties
  set MUX1 [ create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 MUX1 ]
  set_property -dict [ list \
CONFIG.C_AXIS_NUM_SI_SLOTS {3} \
CONFIG.C_AXIS_TDATA_WIDTH {24} \
 ] $MUX1

  # Create instance: MUX2, and set properties
  set MUX2 [ create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 MUX2 ]
  set_property -dict [ list \
CONFIG.C_AXIS_TDATA_WIDTH {24} \
 ] $MUX2

  # Create instance: MUX3, and set properties
  set MUX3 [ create_bd_cell -type ip -vlnv raphael-frey:user:axis_multiplexer:1.0 MUX3 ]
  set_property -dict [ list \
CONFIG.C_AXIS_NUM_SI_SLOTS {3} \
CONFIG.C_AXIS_TDATA_WIDTH {24} \
 ] $MUX3

  # Create instance: cic125_slice, and set properties
  set cic125_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 cic125_slice ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {7} \
CONFIG.IN1_WIDTH {16} \
CONFIG.IN2_WIDTH {1} \
CONFIG.NUM_PORTS {3} \
 ] $cic125_slice

  # Create instance: cic25_slice, and set properties
  set cic25_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 cic25_slice ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {7} \
CONFIG.IN1_WIDTH {16} \
CONFIG.IN2_WIDTH {1} \
CONFIG.NUM_PORTS {3} \
 ] $cic25_slice

  # Create instance: clk, and set properties
  set clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_gen:1.0 clk ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {125000000} \
 ] $clk

  # Create instance: comp1_slice, and set properties
  set comp1_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 comp1_slice ]
  set_property -dict [ list \
CONFIG.DIN_FROM {30} \
CONFIG.DIN_TO {7} \
CONFIG.DIN_WIDTH {32} \
CONFIG.DOUT_WIDTH {24} \
 ] $comp1_slice

  # Create instance: comp5_slice, and set properties
  set comp5_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 comp5_slice ]
  set_property -dict [ list \
CONFIG.DIN_FROM {30} \
CONFIG.DIN_TO {7} \
CONFIG.DIN_WIDTH {32} \
CONFIG.DOUT_WIDTH {24} \
 ] $comp5_slice

  # Create instance: dec_to_fir_mux_1, and set properties
  set dec_to_fir_mux_1 [ create_bd_cell -type ip -vlnv noah-huesser:user:dec_to_fir_mux:1.0 dec_to_fir_mux_1 ]

  # Create instance: fir5flat_slice, and set properties
  set fir5flat_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 fir5flat_slice ]
  set_property -dict [ list \
CONFIG.DIN_FROM {30} \
CONFIG.DIN_TO {7} \
CONFIG.DIN_WIDTH {32} \
CONFIG.DOUT_WIDTH {24} \
 ] $fir5flat_slice

  # Create instance: fir5steep_slice, and set properties
  set fir5steep_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 fir5steep_slice ]
  set_property -dict [ list \
CONFIG.DIN_FROM {29} \
CONFIG.DIN_TO {6} \
CONFIG.DIN_WIDTH {32} \
CONFIG.DOUT_WIDTH {24} \
 ] $fir5steep_slice

  # Create instance: hbflat_slice, and set properties
  set hbflat_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 hbflat_slice ]
  set_property -dict [ list \
CONFIG.DIN_FROM {29} \
CONFIG.DIN_TO {6} \
CONFIG.DIN_WIDTH {32} \
CONFIG.DOUT_WIDTH {24} \
 ] $hbflat_slice

  # Create instance: hbsteep_slice, and set properties
  set hbsteep_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 hbsteep_slice ]
  set_property -dict [ list \
CONFIG.DIN_FROM {30} \
CONFIG.DIN_TO {7} \
CONFIG.DIN_WIDTH {32} \
CONFIG.DOUT_WIDTH {24} \
 ] $hbsteep_slice

  # Create instance: nocic_slice, and set properties
  set nocic_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 nocic_slice ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {7} \
CONFIG.IN1_WIDTH {16} \
CONFIG.IN2_WIDTH {1} \
CONFIG.NUM_PORTS {3} \
 ] $nocic_slice

  # Create instance: out_slice, and set properties
  set out_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 out_slice ]
  set_property -dict [ list \
CONFIG.DIN_FROM {22} \
CONFIG.DIN_TO {7} \
CONFIG.DIN_WIDTH {24} \
CONFIG.DOUT_WIDTH {16} \
 ] $out_slice

  # Create instance: wavegen, and set properties
  set wavegen [ create_bd_cell -type ip -vlnv xilinx.com:ip:dds_compiler:6.0 wavegen ]
  set_property -dict [ list \
CONFIG.DDS_Clock_Rate {125} \
CONFIG.Frequency_Resolution {0.4} \
CONFIG.Latency {3} \
CONFIG.Noise_Shaping {Auto} \
CONFIG.Output_Frequency1 {0.021} \
CONFIG.Output_Width {8} \
CONFIG.PINC1 {10110000001010010} \
CONFIG.Phase_Width {29} \
 ] $wavegen

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.Latency.VALUE_SRC {DEFAULT} \
 ] $wavegen

  # Create instance: wavegen_slice, and set properties
  set wavegen_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 wavegen_slice ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {14} \
CONFIG.IN1_WIDTH {1} \
CONFIG.IN2_WIDTH {1} \
CONFIG.NUM_PORTS {3} \
 ] $wavegen_slice

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {7} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {7} \
 ] $xlconstant_1

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {7} \
 ] $xlconstant_3

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {2} \
CONFIG.DIN_WIDTH {16} \
CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_0

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {32} \
CONFIG.DIN_TO {17} \
CONFIG.DIN_WIDTH {40} \
CONFIG.DOUT_WIDTH {16} \
 ] $xlslice_7

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {15} \
CONFIG.DIN_WIDTH {16} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {15} \
CONFIG.DIN_WIDTH {16} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {15} \
CONFIG.DIN_WIDTH {16} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {15} \
CONFIG.DIN_WIDTH {16} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {15} \
CONFIG.DIN_WIDTH {16} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {42} \
CONFIG.DIN_TO {27} \
CONFIG.DIN_WIDTH {48} \
CONFIG.DOUT_WIDTH {16} \
 ] $xlslice_17

  # Create port connections
  connect_bd_net -net CIC125_m_axis_data_tvalid [get_bd_pins CIC125/m_axis_data_tvalid] [get_bd_pins COMP5/s_axis_data_tvalid]
  connect_bd_net -net CIC25_m_axis_data_tvalid [get_bd_pins CIC25/m_axis_data_tvalid] [get_bd_pins COMP1/s_axis_data_tvalid]
  connect_bd_net -net COMP1_m_axis_data_tvalid [get_bd_pins COMP1/m_axis_data_tvalid] [get_bd_pins MUX3/Valid1xSI]
  connect_bd_net -net COMP5_m_axis_data_tvalid [get_bd_pins COMP5/m_axis_data_tvalid] [get_bd_pins MUX3/Valid2xSI]
  connect_bd_net -net DEC_SEL_dout [get_bd_pins DEC_SEL/dout] [get_bd_pins dec_to_fir_mux_1/DecRate]
  connect_bd_net -net FIR5flat_m_axis_data_tvalid [get_bd_pins FIR5flat/m_axis_data_tvalid] [get_bd_pins MUX2/Valid1xSI]
  connect_bd_net -net FIR5steep_m_axis_data_tvalid [get_bd_pins FIR5steep/m_axis_data_tvalid] [get_bd_pins MUX1/Valid0xSI]
  connect_bd_net -net FIR_resized1_m_axis_data_tdata [get_bd_pins FIR5flat/m_axis_data_tdata] [get_bd_pins fir5flat_slice/Din]
  connect_bd_net -net FIR_resized2_m_axis_data_tdata [get_bd_pins FIR5steep/m_axis_data_tdata] [get_bd_pins fir5steep_slice/Din]
  connect_bd_net -net FIR_resized3_m_axis_data_tdata [get_bd_pins COMP1/m_axis_data_tdata] [get_bd_pins comp1_slice/Din]
  connect_bd_net -net FIR_resized6_m_axis_data_tdata [get_bd_pins COMP5/m_axis_data_tdata] [get_bd_pins comp5_slice/Din]
  connect_bd_net -net FIR_resized7_m_axis_data_tdata [get_bd_pins HBsteep/m_axis_data_tdata] [get_bd_pins hbsteep_slice/Din]
  connect_bd_net -net HBsteep1_m_axis_data_tvalid [get_bd_pins HBflat/m_axis_data_tvalid] [get_bd_pins MUX1/Valid1xSI]
  connect_bd_net -net HBsteep_m_axis_data_tvalid [get_bd_pins HBsteep/m_axis_data_tvalid] [get_bd_pins MUX0/Valid1xSI]
  connect_bd_net -net MUX0_DataxDO [get_bd_pins MUX0/DataxDO] [get_bd_pins out_slice/Din]
  connect_bd_net -net MUX1_DataxDO [get_bd_pins HBsteep/s_axis_data_tdata] [get_bd_pins MUX0/Data0xDI] [get_bd_pins MUX1/DataxDO]
  connect_bd_net -net MUX1_ValidxSO [get_bd_pins HBsteep/s_axis_data_tvalid] [get_bd_pins MUX0/Valid0xSI] [get_bd_pins MUX1/ValidxSO]
  connect_bd_net -net MUX2_DataxDO [get_bd_pins FIR5steep/s_axis_data_tdata] [get_bd_pins HBflat/s_axis_data_tdata] [get_bd_pins MUX1/Data2xDI] [get_bd_pins MUX2/DataxDO]
  connect_bd_net -net MUX2_ValidxSO [get_bd_pins FIR5steep/s_axis_data_tvalid] [get_bd_pins HBflat/s_axis_data_tvalid] [get_bd_pins MUX1/Valid2xSI] [get_bd_pins MUX2/ValidxSO]
  connect_bd_net -net MUX3_DataxDO [get_bd_pins FIR5flat/s_axis_data_tdata] [get_bd_pins MUX2/Data0xDI] [get_bd_pins MUX3/DataxDO]
  connect_bd_net -net MUX3_ValidxSO [get_bd_pins FIR5flat/s_axis_data_tvalid] [get_bd_pins MUX2/Valid0xSI] [get_bd_pins MUX3/ValidxSO]
  connect_bd_net -net Net [get_bd_pins CIC125/aclk] [get_bd_pins CIC25/aclk] [get_bd_pins COMP1/aclk] [get_bd_pins COMP5/aclk] [get_bd_pins FIR5flat/aclk] [get_bd_pins FIR5steep/aclk] [get_bd_pins HBflat/aclk] [get_bd_pins HBsteep/aclk] [get_bd_pins MUX0/ClkxCI] [get_bd_pins MUX1/ClkxCI] [get_bd_pins MUX2/ClkxCI] [get_bd_pins MUX3/ClkxCI] [get_bd_pins clk/clk] [get_bd_pins wavegen/aclk]
  connect_bd_net -net Net1 [get_bd_pins MUX0/RstxRBI] [get_bd_pins MUX1/RstxRBI] [get_bd_pins MUX2/RstxRBI] [get_bd_pins MUX3/RstxRBI]
  connect_bd_net -net cic125_slice_dout [get_bd_pins COMP5/s_axis_data_tdata] [get_bd_pins cic125_slice/dout]
  connect_bd_net -net cic25_slice_dout [get_bd_pins COMP1/s_axis_data_tdata] [get_bd_pins cic25_slice/dout]
  connect_bd_net -net cic_compiler_0_m_axis_data_tdata [get_bd_pins CIC25/m_axis_data_tdata] [get_bd_pins xlslice_7/Din]
  connect_bd_net -net cic_compiler_1_m_axis_data_tdata [get_bd_pins CIC125/m_axis_data_tdata] [get_bd_pins xlslice_17/Din]
  connect_bd_net -net dec_to_fir_mux_1_Mux0 [get_bd_pins MUX0/SelectxDI] [get_bd_pins dec_to_fir_mux_1/Mux0]
  connect_bd_net -net dec_to_fir_mux_1_Mux1 [get_bd_pins MUX1/SelectxDI] [get_bd_pins dec_to_fir_mux_1/Mux1]
  connect_bd_net -net dec_to_fir_mux_1_Mux2 [get_bd_pins MUX2/SelectxDI] [get_bd_pins dec_to_fir_mux_1/Mux2]
  connect_bd_net -net dec_to_fir_mux_1_Mux3 [get_bd_pins MUX3/SelectxDI] [get_bd_pins dec_to_fir_mux_1/Mux3]
  connect_bd_net -net fir5steep_slice1_Dout [get_bd_pins MUX1/Data1xDI] [get_bd_pins hbflat_slice/Dout]
  connect_bd_net -net hbflat_slice_m_axis_data_tdata [get_bd_pins HBflat/m_axis_data_tdata] [get_bd_pins hbflat_slice/Din]
  connect_bd_net -net nocic_slice_dout [get_bd_pins MUX3/Data0xDI] [get_bd_pins nocic_slice/dout]
  connect_bd_net -net wavegen_m_axis_data_tdata [get_bd_pins wavegen/m_axis_data_tdata] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din]
  connect_bd_net -net wavegen_m_axis_data_tvalid [get_bd_pins CIC125/s_axis_data_tvalid] [get_bd_pins CIC25/s_axis_data_tvalid] [get_bd_pins MUX3/Valid0xSI] [get_bd_pins wavegen/m_axis_data_tvalid]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins CIC125/s_axis_data_tdata] [get_bd_pins CIC25/s_axis_data_tdata] [get_bd_pins nocic_slice/In1] [get_bd_pins wavegen_slice/dout] [get_bd_pins xlslice_13/Din]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins cic25_slice/In0] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins nocic_slice/In0] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins cic125_slice/In0] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins wavegen_slice/In0] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins cic125_slice/In2] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins wavegen_slice/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins wavegen_slice/In2] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins nocic_slice/In2] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins MUX0/Data1xDI] [get_bd_pins hbsteep_slice/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins MUX3/Data2xDI] [get_bd_pins comp5_slice/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins cic125_slice/In1] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins MUX1/Data0xDI] [get_bd_pins fir5steep_slice/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins MUX2/Data1xDI] [get_bd_pins fir5flat_slice/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins cic25_slice/In1] [get_bd_pins xlslice_7/Dout] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins MUX3/Data1xDI] [get_bd_pins comp1_slice/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins cic25_slice/In2] [get_bd_pins xlslice_9/Dout]

  # Create address segments

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.12  2016-01-29 bk=1.3547 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace inst HBflat -pg 1 -lvl 15 -y 300 -defaultsOSRD
preplace inst comp1_slice -pg 1 -lvl 10 -y 120 -defaultsOSRD
preplace inst fir5steep_slice -pg 1 -lvl 16 -y 360 -defaultsOSRD
preplace inst xlslice_0 -pg 1 -lvl 3 -y 80 -defaultsOSRD
preplace inst out_slice -pg 1 -lvl 21 -y 280 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 7 -y 40 -defaultsOSRD
preplace inst FIR5steep -pg 1 -lvl 15 -y 440 -defaultsOSRD
preplace inst dec_to_fir_mux_1 -pg 1 -lvl 10 -y 790 -defaultsOSRD
preplace inst hbflat_slice -pg 1 -lvl 16 -y 460 -defaultsOSRD
preplace inst cic125_slice -pg 1 -lvl 8 -y 290 -defaultsOSRD -resize 160 100
preplace inst xlconstant_1 -pg 1 -lvl 9 -y 380 -defaultsOSRD -resize 100 60
preplace inst nocic_slice -pg 1 -lvl 10 -y 430 -defaultsOSRD -resize 160 100
preplace inst hbsteep_slice -pg 1 -lvl 19 -y 250 -defaultsOSRD -resize 160 60
preplace inst CIC125 -pg 1 -lvl 5 -y 340 -defaultsOSRD -resize 360 140
preplace inst cic25_slice -pg 1 -lvl 8 -y 90 -defaultsOSRD
preplace inst xlslice_10 -pg 1 -lvl 7 -y 340 -defaultsOSRD -resize 140 60
preplace inst xlconstant_3 -pg 1 -lvl 7 -y 240 -defaultsOSRD -resize 100 60
preplace inst xlslice_11 -pg 1 -lvl 3 -y 160 -defaultsOSRD -resize 140 60
preplace inst xlslice_12 -pg 1 -lvl 3 -y 240 -defaultsOSRD
preplace inst MUX0 -pg 1 -lvl 20 -y 260 -defaultsOSRD -resize 245 250
preplace inst COMP1 -pg 1 -lvl 9 -y 120 -defaultsOSRD
preplace inst FIR5flat -pg 1 -lvl 12 -y 470 -defaultsOSRD
preplace inst MUX1 -pg 1 -lvl 17 -y 490 -defaultsOSRD -resize 251 272
preplace inst xlslice_13 -pg 1 -lvl 9 -y 480 -defaultsOSRD -resize 140 60
preplace inst xlslice_7 -pg 1 -lvl 6 -y 140 -defaultsOSRD
preplace inst wavegen -pg 1 -lvl 2 -y 280 -defaultsOSRD
preplace inst MUX2 -pg 1 -lvl 14 -y 440 -defaultsOSRD -resize 257 242
preplace inst HBsteep -pg 1 -lvl 18 -y 290 -defaultsOSRD -resize 360 120
preplace inst wavegen_slice -pg 1 -lvl 4 -y 160 -defaultsOSRD
preplace inst MUX3 -pg 1 -lvl 11 -y 390 -defaultsOSRD -resize 243 244
preplace inst comp5_slice -pg 1 -lvl 10 -y 270 -defaultsOSRD -resize 160 60
preplace inst xlslice_9 -pg 1 -lvl 7 -y 140 -defaultsOSRD
preplace inst clk -pg 1 -lvl 1 -y 290 -defaultsOSRD
preplace inst DEC_SEL -pg 1 -lvl 9 -y 620 -defaultsOSRD
preplace inst COMP5 -pg 1 -lvl 9 -y 270 -defaultsOSRD -resize 360 120
preplace inst fir5flat_slice -pg 1 -lvl 13 -y 440 -defaultsOSRD
preplace inst xlslice_17 -pg 1 -lvl 6 -y 340 -defaultsOSRD -resize 160 60
preplace inst CIC25 -pg 1 -lvl 5 -y 170 -defaultsOSRD
preplace netloc MUX1_ValidxSO 1 17 3 4930 200 NJ 200 NJ
preplace netloc xlconstant_1_dout 1 9 1 NJ
preplace netloc xlslice_12_Dout 1 3 1 NJ
preplace netloc xlslice_14_Dout 1 19 1 NJ
preplace netloc MUX1_DataxDO 1 17 3 4900 190 NJ 190 NJ
preplace netloc xlslice_4_Dout 1 16 1 NJ
preplace netloc MUX2_ValidxSO 1 14 3 3920 530 NJ 530 NJ
preplace netloc MUX3_DataxDO 1 11 3 2970 370 NJ 370 N
preplace netloc xlslice_9_Dout 1 7 1 NJ
preplace netloc FIR_resized3_m_axis_data_tdata 1 9 1 NJ
preplace netloc xlslice_17_Dout 1 6 2 1500 390 NJ
preplace netloc FIR_resized7_m_axis_data_tdata 1 18 1 5330
preplace netloc wavegen_m_axis_data_tvalid 1 2 9 N 290 NJ 290 880 250 NJ 250 NJ 290 NJ 10 NJ 10 NJ 10 NJ
preplace netloc DEC_SEL_dout 1 9 1 2370
preplace netloc fir5steep_slice1_Dout 1 16 1 NJ
preplace netloc xlslice_13_Dout 1 9 1 NJ
preplace netloc xlslice_7_Dout 1 6 2 1500 90 NJ
preplace netloc CIC125_m_axis_data_tvalid 1 5 4 NJ 400 NJ 400 NJ 220 1950
preplace netloc cic125_slice_dout 1 8 1 1940
preplace netloc xlslice_15_Dout 1 10 1 2610
preplace netloc nocic_slice_dout 1 10 1 2600
preplace netloc cic25_slice_dout 1 8 1 1970
preplace netloc xlslice_10_Dout 1 7 1 NJ
preplace netloc dec_to_fir_mux_1_Mux0 1 10 10 NJ 170 NJ 170 NJ 170 NJ 170 NJ 170 NJ 170 NJ 170 NJ 170 NJ 170 5550
preplace netloc FIR5steep_m_axis_data_tvalid 1 15 2 4340 410 NJ
preplace netloc dec_to_fir_mux_1_Mux1 1 10 7 NJ 600 NJ 600 NJ 600 NJ 600 NJ 600 NJ 600 N
preplace netloc FIR5flat_m_axis_data_tvalid 1 12 2 NJ 490 3590
preplace netloc COMP1_m_axis_data_tvalid 1 9 2 NJ 170 2630
preplace netloc FIR_resized6_m_axis_data_tdata 1 9 1 NJ
preplace netloc xlconcat_0_dout 1 4 6 870 90 NJ 90 NJ 430 NJ 430 1960 430 NJ
preplace netloc xlconstant_0_dout 1 7 1 NJ
preplace netloc cic_compiler_0_m_axis_data_tdata 1 5 1 NJ
preplace netloc dec_to_fir_mux_1_Mux2 1 10 4 NJ 560 NJ 560 NJ 530 N
preplace netloc HBsteep1_m_axis_data_tvalid 1 15 2 4340 310 NJ
preplace netloc dec_to_fir_mux_1_Mux3 1 10 1 2630
preplace netloc xlslice_11_Dout 1 3 1 NJ
preplace netloc MUX3_ValidxSO 1 11 3 2980 390 NJ 390 N
preplace netloc wavegen_m_axis_data_tdata 1 2 1 460
preplace netloc FIR_resized1_m_axis_data_tdata 1 12 1 NJ
preplace netloc hbflat_slice_m_axis_data_tdata 1 15 1 4350
preplace netloc Net1 1 10 10 2660 550 NJ 550 NJ 550 3610 590 NJ 580 NJ 580 4590 330 NJ 370 NJ 330 NJ
preplace netloc HBsteep_m_axis_data_tvalid 1 18 2 N 310 NJ
preplace netloc MUX2_DataxDO 1 14 3 3940 520 NJ 520 NJ
preplace netloc xlslice_8_Dout 1 10 1 2650
preplace netloc FIR_resized2_m_axis_data_tdata 1 15 1 4360
preplace netloc Net 1 1 19 200 360 NJ 360 NJ 360 890 430 NJ 420 NJ 420 NJ 420 1960 30 NJ 30 2620 540 2970 570 NJ 570 3600 580 3930 220 NJ 220 4580 310 4920 380 NJ 320 NJ
preplace netloc CIC25_m_axis_data_tvalid 1 5 4 NJ 190 NJ 190 NJ 190 1940
preplace netloc cic_compiler_1_m_axis_data_tdata 1 5 1 NJ
preplace netloc MUX0_DataxDO 1 20 1 N
preplace netloc xlslice_0_Dout 1 3 1 NJ
preplace netloc xlslice_6_Dout 1 13 1 N
preplace netloc COMP5_m_axis_data_tvalid 1 9 2 NJ 320 2590
preplace netloc xlconstant_3_dout 1 7 1 NJ
levelinfo -pg 1 0 100 330 570 770 1090 1390 1610 1840 2170 2480 2820 3180 3490 3770 4140 4460 4750 5130 5440 5710 5960 6070 -top 0 -bot 870
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


