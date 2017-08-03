# ====================================================================================
#
# 								F U N C T I O N S
#
# ====================================================================================

proc spawn_slice {name in from to out} {
	create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $name
	set_property -dict [list CONFIG.DIN_WIDTH    $in] [get_bd_cells $name]
	set_property -dict [list CONFIG.DIN_FROM   $from] [get_bd_cells $name]
	set_property -dict [list CONFIG.DIN_TO       $to] [get_bd_cells $name]
	set_property -dict [list CONFIG.DOUT_WIDTH  $out] [get_bd_cells $name]
}

# Slices a 64bit axi dual channel signal into 2 24bit signals
# and combines them to 48bit dual channel
# 25.7 x 2 => 17.7 x2
proc w64to48 {name din dout} {
	# Create slices
	spawn_slice ${name}_slice_0 64 30 7 24
	spawn_slice ${name}_slice_1 64 62 39 24

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

# Padds a 16 bit value to 17.7 with a sign extend bit and 7 0 valued fractional bits
proc concat_w16to17p7 {name} {
	create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 ${name}
	set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells ${name}]
	set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells ${name}]
	set_property -dict [list CONFIG.NUM_PORTS  {3}]           [get_bd_cells ${name}]
	set_property -dict [list CONFIG.IN0_WIDTH  {7}]           [get_bd_cells ${name}]
	set_property -dict [list CONFIG.IN1_WIDTH {16}]           [get_bd_cells ${name}]
	set_property -dict [list CONFIG.IN2_WIDTH  {1}]           [get_bd_cells ${name}]
}

# Gets the MSB bit of 16
# Used for sign extension
proc slice_top_of_16 {name} {
	spawn_slice ${name} 16 15 15 1
}

# Slices a 16bit CIC output and extends it to 17.7
# Combines two CIC outputs into one FIR input
proc w16to17p7x2 {name din0 din1 dinNULL7 dout} {
	# Create slices

	slice_top_of_16 ${name}_slice_0
	slice_top_of_16 ${name}_slice_1

	# Create concats
	concat_w16to17p7 ${name}_concat_0
	concat_w16to17p7 ${name}_concat_1

	create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 ${name}_concat_2
	set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells ${name}_concat_2]
	set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells ${name}_concat_2]
	set_property -dict [list CONFIG.NUM_PORTS  {2}]           [get_bd_cells ${name}_concat_2]
	set_property -dict [list CONFIG.IN0_WIDTH {24}]           [get_bd_cells ${name}_concat_2]
	set_property -dict [list CONFIG.IN1_WIDTH {24}]           [get_bd_cells ${name}_concat_2]

	# Connect slices with concat
	connect_bd_net [get_bd_pins ${name}_slice_0/Dout] [get_bd_pins ${name}_concat_0/In2]
	connect_bd_net [get_bd_pins ${name}_slice_1/Dout] [get_bd_pins ${name}_concat_1/In2]

	# Connect concats with concat
	connect_bd_net [get_bd_pins ${name}_concat_0/Dout] [get_bd_pins ${name}_concat_2/In0]
	connect_bd_net [get_bd_pins ${name}_concat_1/Dout] [get_bd_pins ${name}_concat_2/In1]

	# Connect component to outside
	connect_bd_net [get_bd_pins $dinNULL7] [get_bd_pins ${name}_concat_0/In0]
	connect_bd_net [get_bd_pins $dinNULL7] [get_bd_pins ${name}_concat_1/In0]
	connect_bd_net [get_bd_pins $din0] [get_bd_pins ${name}_concat_0/In1]
	connect_bd_net [get_bd_pins $din1] [get_bd_pins ${name}_concat_1/In1]
	connect_bd_net [get_bd_pins $din0] [get_bd_pins ${name}_slice_0/Din]
	connect_bd_net [get_bd_pins $din1] [get_bd_pins ${name}_slice_1/Din]
	connect_bd_net [get_bd_pins $dout] [get_bd_pins ${name}_concat_2/Dout]
}

# Instantiates a new FIR compiler
# Necessary global vars:
#	set decRate 2
#	set fs 0.2
#	set fclk 125000000
#	set dataWidthOut 32
#	set dataWidthIn 24
#	set fracWidthIn 7
#	set nPaths 2
#	set coeFile "string"
proc spawn_fir {name} {
	create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 $name
	set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER]                                            [get_bd_cells $name]
	set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File $::coeFile]      [get_bd_cells $name]
	if {$::decRate ne 1} {
		set_property -dict [list CONFIG.Filter_Type {Decimation}]                                             [get_bd_cells $name]
		set_property -dict [list CONFIG.Decimation_Rate $::decRate]                                             [get_bd_cells $name]
	} {
		set_property -dict [list CONFIG.Filter_Type {Single_Rate}]                                             [get_bd_cells $name]
	}
	set_property -dict [list CONFIG.Sample_Frequency $::fs]                                                 [get_bd_cells $name]
	set_property -dict [list CONFIG.Clock_Frequency $::fclk]                                                [get_bd_cells $name]
	set_property -dict [list CONFIG.BestPrecision {true}]                                                 [get_bd_cells $name]
	set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}]                                 [get_bd_cells $name]
	set_property -dict [list CONFIG.Output_Width $::dataWidthOut]                                           [get_bd_cells $name]
	set_property -dict [list CONFIG.Coefficient_Sets {1}]                                                 [get_bd_cells $name]
	set_property -dict [list CONFIG.Interpolation_Rate {1}]                                               [get_bd_cells $name]
	set_property -dict [list CONFIG.Zero_Pack_Factor {1}]                                                 [get_bd_cells $name]
	set_property -dict [list CONFIG.Number_Channels {1}]                                                  [get_bd_cells $name]
	set_property -dict [list CONFIG.Number_Paths $::nPaths]                                                 [get_bd_cells $name]
	set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}]                          [get_bd_cells $name]
	set_property -dict [list CONFIG.Coefficient_Sign {Signed}]                                            [get_bd_cells $name]
	set_property -dict [list CONFIG.Quantization {Quantize_Only}]                                         [get_bd_cells $name]
#	set_property -dict [list CONFIG.Coefficient_Width $coefWidth]                                         [get_bd_cells $name]
	set_property -dict [list CONFIG.Coefficient_Structure {Inferred}]                                     [get_bd_cells $name]
	set_property -dict [list CONFIG.Data_Width $::dataWidthIn]                                              [get_bd_cells $name]
	set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}]                   [get_bd_cells $name]
	set_property -dict [list CONFIG.Data_Fractional_Bits.VALUE_SRC USER] 								  [get_bd_cells $name]
	set_property -dict [list CONFIG.Data_Fractional_Bits $::fracWidthIn] 								      [get_bd_cells $name]
	set_property -dict [list CONFIG.M_DATA_Has_TREADY {false}]                                            [get_bd_cells $name]
}

# Instantiates a new CIC compiler
# Necessary global vars:
#	set numStages 4
#	set decRate 25
#	set dataWidthOut 33
proc spawn_cic {name} {
	create_bd_cell -type ip -vlnv xilinx.com:ip:cic_compiler:4.0 $name
	set_property -dict [list CONFIG.Input_Data_Width.VALUE_SRC USER] [get_bd_cells $name]
	set_property -dict [list CONFIG.Filter_Type {Decimation}]        [get_bd_cells $name]
	set_property -dict [list CONFIG.Number_Of_Stages $::numStages]            [get_bd_cells $name]
	set_property -dict [list CONFIG.Number_Of_Channels {1}]          [get_bd_cells $name]
	set_property -dict [list CONFIG.Fixed_Or_Initial_Rate $::decRate]      [get_bd_cells $name]
	set_property -dict [list CONFIG.Input_Sample_Frequency {125}]    [get_bd_cells $name]
	set_property -dict [list CONFIG.Clock_Frequency {125}]           [get_bd_cells $name]
	set_property -dict [list CONFIG.Input_Data_Width {14}]           [get_bd_cells $name]
	set_property -dict [list CONFIG.Quantization {Full_Precision}]   [get_bd_cells $name]
	set_property -dict [list CONFIG.Output_Data_Width $::dataWidthOut]          [get_bd_cells $name]
	set_property -dict [list CONFIG.Use_Xtreme_DSP_Slice {false}]    [get_bd_cells $name]
	set_property -dict [list CONFIG.Minimum_Rate $::decRate]               [get_bd_cells $name]
	set_property -dict [list CONFIG.Maximum_Rate $::decRate]               [get_bd_cells $name]
	set_property -dict [list CONFIG.SamplePeriod {1}]                [get_bd_cells $name]
}