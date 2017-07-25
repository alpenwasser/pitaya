
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

  # Create instance: FIR, and set properties
  set FIR [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 FIR ]
  set_property -dict [ list \
CONFIG.Clock_Frequency {125} \
CONFIG.CoefficientSource {COE_File} \
CONFIG.Coefficient_File {../../../../../../../pitaya/design/filter/coefData/decFIR/r-005--fp-200--fst-225--ap-200--ast-60.coe} \
CONFIG.Coefficient_Fractional_Bits {17} \
CONFIG.Coefficient_Sets {1} \
CONFIG.Coefficient_Sign {Signed} \
CONFIG.Coefficient_Structure {Inferred} \
CONFIG.Coefficient_Width {16} \
CONFIG.ColumnConfig {21} \
CONFIG.Data_Fractional_Bits {0} \
CONFIG.Data_Width {14} \
CONFIG.Decimation_Rate {5} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Filter_Type {Decimation} \
CONFIG.Interpolation_Rate {1} \
CONFIG.Number_Channels {1} \
CONFIG.Output_Rounding_Mode {Full_Precision} \
CONFIG.Output_Width {33} \
CONFIG.Quantization {Quantize_Only} \
CONFIG.RateSpecification {Frequency_Specification} \
CONFIG.Sample_Frequency {125} \
CONFIG.Zero_Pack_Factor {1} \
 ] $FIR

  # Create instance: FIR_resized0, and set properties
  set FIR_resized0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 FIR_resized0 ]
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
CONFIG.Data_Fractional_Bits {0} \
CONFIG.Data_Width {16} \
CONFIG.Decimation_Rate {1} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Filter_Type {Single_Rate} \
CONFIG.Interpolation_Rate {1} \
CONFIG.Number_Channels {1} \
CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
CONFIG.Output_Width {17} \
CONFIG.Quantization {Quantize_Only} \
CONFIG.RateSpecification {Frequency_Specification} \
CONFIG.Sample_Frequency {5} \
CONFIG.Zero_Pack_Factor {1} \
 ] $FIR_resized0

  # Create instance: FIR_resized1, and set properties
  set FIR_resized1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 FIR_resized1 ]
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
CONFIG.Data_Fractional_Bits {0} \
CONFIG.Data_Width {16} \
CONFIG.Decimation_Rate {5} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Filter_Type {Decimation} \
CONFIG.Interpolation_Rate {1} \
CONFIG.Number_Channels {1} \
CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
CONFIG.Output_Width {17} \
CONFIG.Quantization {Quantize_Only} \
CONFIG.RateSpecification {Frequency_Specification} \
CONFIG.Sample_Frequency {125} \
CONFIG.Zero_Pack_Factor {1} \
 ] $FIR_resized1

  # Create instance: FIR_resized2, and set properties
  set FIR_resized2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 FIR_resized2 ]
  set_property -dict [ list \
CONFIG.Clock_Frequency {125} \
CONFIG.CoefficientSource {COE_File} \
CONFIG.Coefficient_File {../../../../../../../pitaya/firmware/fpga/p_chain5/coefData/dec5steep.coe} \
CONFIG.Coefficient_Fractional_Bits {17} \
CONFIG.Coefficient_Sets {1} \
CONFIG.Coefficient_Sign {Signed} \
CONFIG.Coefficient_Structure {Inferred} \
CONFIG.Coefficient_Width {16} \
CONFIG.ColumnConfig {21} \
CONFIG.Data_Fractional_Bits {0} \
CONFIG.Data_Width {16} \
CONFIG.Decimation_Rate {5} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Filter_Type {Decimation} \
CONFIG.Interpolation_Rate {1} \
CONFIG.Number_Channels {1} \
CONFIG.Output_Rounding_Mode {Full_Precision} \
CONFIG.Output_Width {35} \
CONFIG.Quantization {Quantize_Only} \
CONFIG.RateSpecification {Frequency_Specification} \
CONFIG.Sample_Frequency {125} \
CONFIG.Zero_Pack_Factor {1} \
 ] $FIR_resized2

  # Create instance: axis_broadcaster_0, and set properties
  set axis_broadcaster_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_0 ]
  set_property -dict [ list \
CONFIG.M00_TDATA_REMAP {tdata[15:0]} \
CONFIG.M01_TDATA_REMAP {tdata[15:0]} \
CONFIG.M_TDATA_NUM_BYTES {2} \
CONFIG.S_TDATA_NUM_BYTES {2} \
 ] $axis_broadcaster_0

  # Create instance: axis_to_data_lanes_0, and set properties
  set axis_to_data_lanes_0 [ create_bd_cell -type ip -vlnv noah-huesser:user:axis_to_data_lanes:1.0 axis_to_data_lanes_0 ]

  # Create instance: cic_compiler_0, and set properties
  set cic_compiler_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cic_compiler:4.0 cic_compiler_0 ]
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
 ] $cic_compiler_0

  # Create instance: clk, and set properties
  set clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_gen:1.0 clk ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {125000000} \
 ] $clk

  # Create instance: correct_sink, and set properties
  set correct_sink [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 correct_sink ]
  set_property -dict [ list \
CONFIG.DIN_FROM {0} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {40} \
 ] $correct_sink

  # Create instance: correct_value, and set properties
  set correct_value [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 correct_value ]
  set_property -dict [ list \
CONFIG.DIN_FROM {39} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {40} \
CONFIG.DOUT_WIDTH {40} \
 ] $correct_value

  # Create instance: wavegen, and set properties
  set wavegen [ create_bd_cell -type ip -vlnv xilinx.com:ip:dds_compiler:6.0 wavegen ]
  set_property -dict [ list \
CONFIG.DDS_Clock_Rate {125} \
CONFIG.Frequency_Resolution {0.4} \
CONFIG.Latency {3} \
CONFIG.Noise_Shaping {Auto} \
CONFIG.Output_Frequency1 {0.02} \
CONFIG.Output_Width {8} \
CONFIG.PINC1 {10100111110001011} \
CONFIG.Phase_Width {29} \
 ] $wavegen

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.Latency.VALUE_SRC {DEFAULT} \
 ] $wavegen

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {14} \
CONFIG.NUM_PORTS {3} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {2} \
CONFIG.DIN_WIDTH {16} \
CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {15} \
CONFIG.DIN_WIDTH {16} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {24} \
CONFIG.DOUT_WIDTH {16} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {15} \
CONFIG.DIN_WIDTH {16} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {24} \
CONFIG.DOUT_WIDTH {16} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {32} \
CONFIG.DIN_TO {17} \
CONFIG.DIN_WIDTH {40} \
CONFIG.DOUT_WIDTH {16} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {24} \
CONFIG.DOUT_WIDTH {16} \
 ] $xlslice_8

  # Create interface connections
  connect_bd_intf_net -intf_net axis_broadcaster_0_M00_AXIS [get_bd_intf_pins FIR/S_AXIS_DATA] [get_bd_intf_pins axis_broadcaster_0/M00_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M01_AXIS [get_bd_intf_pins axis_broadcaster_0/M01_AXIS] [get_bd_intf_pins cic_compiler_0/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net FIR_resized1_m_axis_data_tdata [get_bd_pins FIR_resized1/m_axis_data_tdata] [get_bd_pins xlslice_6/Din]
  connect_bd_net -net FIR_resized1_m_axis_data_tvalid [get_bd_pins FIR_resized1/m_axis_data_tvalid] [get_bd_pins FIR_resized2/s_axis_data_tvalid]
  connect_bd_net -net FIR_resized2_m_axis_data_tdata [get_bd_pins FIR_resized2/m_axis_data_tdata] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net FIR_resized2_m_axis_data_tvalid [get_bd_pins FIR_resized2/m_axis_data_tvalid] [get_bd_pins axis_to_data_lanes_0/AxiTValid]
  connect_bd_net -net FIR_resized3_m_axis_data_tdata [get_bd_pins FIR_resized0/m_axis_data_tdata] [get_bd_pins xlslice_8/Din]
  connect_bd_net -net FIR_resized3_m_axis_data_tvalid [get_bd_pins FIR_resized0/m_axis_data_tvalid] [get_bd_pins FIR_resized1/s_axis_data_tvalid]
  connect_bd_net -net Net [get_bd_pins FIR/aclk] [get_bd_pins FIR_resized0/aclk] [get_bd_pins FIR_resized1/aclk] [get_bd_pins FIR_resized2/aclk] [get_bd_pins axis_broadcaster_0/aclk] [get_bd_pins axis_to_data_lanes_0/ClkxCI] [get_bd_pins cic_compiler_0/aclk] [get_bd_pins clk/clk] [get_bd_pins wavegen/aclk]
  connect_bd_net -net axis_to_data_lanes_0_Data0xDO [get_bd_pins axis_to_data_lanes_0/Data0xDO] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net axis_to_data_lanes_0_Data1xDO [get_bd_pins axis_to_data_lanes_0/Data1xDO] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net cic_compiler_0_m_axis_data_tdata [get_bd_pins cic_compiler_0/m_axis_data_tdata] [get_bd_pins xlslice_7/Din]
  connect_bd_net -net cic_compiler_0_m_axis_data_tvalid [get_bd_pins FIR_resized0/s_axis_data_tvalid] [get_bd_pins cic_compiler_0/m_axis_data_tvalid]
  connect_bd_net -net clk_gen_0_sync_rst [get_bd_pins axis_broadcaster_0/aresetn] [get_bd_pins axis_to_data_lanes_0/RstxRBI] [get_bd_pins clk/sync_rst]
  connect_bd_net -net fir_compiler_0_m_axis_data_tdata [get_bd_pins FIR/m_axis_data_tdata] [get_bd_pins correct_value/Din]
  connect_bd_net -net wavegen_m_axis_data_tdata [get_bd_pins wavegen/m_axis_data_tdata] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_5/Din]
  connect_bd_net -net wavegen_m_axis_data_tvalid [get_bd_pins axis_broadcaster_0/s_axis_tvalid] [get_bd_pins wavegen/m_axis_data_tvalid]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins axis_broadcaster_0/s_axis_tdata] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins correct_sink/Din] [get_bd_pins correct_value/Dout]
  connect_bd_net -net xlslice_0_Dout1 [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins axis_to_data_lanes_0/AxiTDataxDI] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins FIR_resized2/s_axis_data_tdata] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins FIR_resized0/s_axis_data_tdata] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins FIR_resized1/s_axis_data_tdata] [get_bd_pins xlslice_8/Dout]

  # Create address segments

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.12  2016-01-29 bk=1.3547 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace inst axis_broadcaster_0 -pg 1 -lvl 5 -y 240 -defaultsOSRD
preplace inst correct_sink -pg 1 -lvl 15 -y 240 -defaultsOSRD
preplace inst xlslice_0 -pg 1 -lvl 3 -y 40 -defaultsOSRD
preplace inst FIR_resized0 -pg 1 -lvl 8 -y 340 -defaultsOSRD
preplace inst xlslice_1 -pg 1 -lvl 15 -y 320 -defaultsOSRD
preplace inst axis_to_data_lanes_0 -pg 1 -lvl 14 -y 390 -defaultsOSRD
preplace inst FIR_resized1 -pg 1 -lvl 10 -y 330 -defaultsOSRD
preplace inst xlslice_2 -pg 1 -lvl 15 -y 400 -defaultsOSRD
preplace inst FIR -pg 1 -lvl 6 -y 240 -defaultsOSRD
preplace inst cic_compiler_0 -pg 1 -lvl 6 -y 390 -defaultsOSRD
preplace inst FIR_resized2 -pg 1 -lvl 12 -y 330 -defaultsOSRD
preplace inst xlslice_3 -pg 1 -lvl 3 -y 120 -defaultsOSRD
preplace inst xlslice_4 -pg 1 -lvl 13 -y 330 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 4 -y 120 -defaultsOSRD
preplace inst xlslice_5 -pg 1 -lvl 3 -y 200 -defaultsOSRD
preplace inst xlslice_6 -pg 1 -lvl 11 -y 310 -defaultsOSRD
preplace inst xlslice_7 -pg 1 -lvl 7 -y 370 -defaultsOSRD
preplace inst correct_value -pg 1 -lvl 14 -y 240 -defaultsOSRD
preplace inst wavegen -pg 1 -lvl 2 -y 240 -defaultsOSRD
preplace inst xlslice_8 -pg 1 -lvl 9 -y 310 -defaultsOSRD
preplace inst clk -pg 1 -lvl 1 -y 320 -defaultsOSRD
preplace netloc clk_gen_0_sync_rst 1 1 13 NJ 330 NJ 330 NJ 330 870 330 NJ 320 NJ 250 NJ 250 NJ 250 NJ 440 NJ 440 NJ 440 NJ 440 NJ
preplace netloc axis_broadcaster_0_M00_AXIS 1 5 1 N
preplace netloc FIR_resized3_m_axis_data_tvalid 1 8 2 N 360 NJ
preplace netloc FIR_resized3_m_axis_data_tdata 1 8 1 2220
preplace netloc FIR_resized2_m_axis_data_tvalid 1 12 2 3440 280 NJ
preplace netloc xlslice_4_Dout 1 13 1 NJ
preplace netloc xlslice_3_Dout 1 3 1 NJ
preplace netloc wavegen_m_axis_data_tvalid 1 2 3 NJ 250 NJ 240 N
preplace netloc fir_compiler_0_m_axis_data_tdata 1 6 8 NJ 240 NJ 240 NJ 240 NJ 240 NJ 240 NJ 240 NJ 240 NJ
preplace netloc xlslice_7_Dout 1 7 1 1820
preplace netloc FIR_resized1_m_axis_data_tvalid 1 10 2 2840 360 NJ
preplace netloc xlslice_5_Dout 1 3 1 NJ
preplace netloc axis_to_data_lanes_0_Data1xDO 1 14 1 NJ
preplace netloc axis_to_data_lanes_0_Data0xDO 1 14 1 NJ
preplace netloc axis_broadcaster_0_M01_AXIS 1 5 1 1230
preplace netloc xlslice_0_Dout1 1 3 1 NJ
preplace netloc cic_compiler_0_m_axis_data_tdata 1 6 1 NJ
preplace netloc xlconcat_0_dout 1 4 1 860
preplace netloc FIR_resized1_m_axis_data_tdata 1 10 1 2840
preplace netloc wavegen_m_axis_data_tdata 1 2 1 460
preplace netloc xlslice_8_Dout 1 9 1 NJ
preplace netloc FIR_resized2_m_axis_data_tdata 1 12 1 N
preplace netloc Net 1 1 13 200 320 NJ 320 NJ 320 860 340 1240 460 NJ 430 1810 430 NJ 420 2440 420 NJ 420 3040 420 NJ 420 NJ
preplace netloc cic_compiler_0_m_axis_data_tvalid 1 6 2 NJ 320 1810
preplace netloc xlslice_6_Dout 1 11 1 NJ
preplace netloc xlslice_0_Dout 1 14 1 NJ
levelinfo -pg 1 0 100 330 560 760 1050 1420 1710 2020 2320 2640 2940 3240 3540 3800 4040 4140 -top 0 -bot 490
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


