#-----------------------------------------------------------
# Vivado v2016.2 (64-bit)
# SW Build 1577090 on Thu Jun  2 16:32:35 MDT 2016
# IP Build 1577682 on Fri Jun  3 12:00:54 MDT 2016
# Start of session at: Tue Jun 27 07:53:41 2017
# Process ID: 8906
# Current directory: /home/edu/raphael.frey/pitaya/firmware/fpga/build/src
# Command line: vivado src.xpr
# Log file: /home/edu/raphael.frey/pitaya/firmware/fpga/build/src/vivado.log
# Journal file: /home/edu/raphael.frey/pitaya/firmware/fpga/build/src/vivado.jou
#-----------------------------------------------------------
start_gui
open_project src.xpr
update_compile_order -fileset sources_1
open_bd_design {/home/edu/raphael.frey/pitaya/firmware/fpga/build/src/src.srcs/sources_1/bd/system/system.bd}
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:cic_compiler:4.0 cic_compiler_0
endgroup
set_property location {4 754 463} [get_bd_cells cic_compiler_0]
set_property location {0.5 171 -163} [get_bd_cells cic_compiler_0]
startgroup
set_property -dict [list CONFIG.Filter_Type {Decimation} CONFIG.Number_Of_Stages {3} CONFIG.Number_Of_Channels {2} CONFIG.Sample_Rate_Changes {Programmable} CONFIG.Fixed_Or_Initial_Rate {125} CONFIG.Minimum_Rate {25} CONFIG.Maximum_Rate {1250} CONFIG.RateSpecification {Frequency_Specification} CONFIG.Input_Sample_Frequency {125} CONFIG.Use_Xtreme_DSP_Slice {true} CONFIG.Input_Sample_Frequency {125} CONFIG.Clock_Frequency {250.0000000} CONFIG.SamplePeriod {1} CONFIG.Output_Data_Width {49}] [get_bd_cells cic_compiler_0]
endgroup
startgroup
set_property -dict [list CONFIG.Input_Data_Width.VALUE_SRC USER] [get_bd_cells cic_compiler_0]
set_property -dict [list CONFIG.Number_Of_Channels {1} CONFIG.Clock_Frequency {125} CONFIG.Input_Data_Width {16} CONFIG.Quantization {Truncation} CONFIG.Output_Data_Width {16} CONFIG.Use_Xtreme_DSP_Slice {false} CONFIG.Input_Sample_Frequency {125}] [get_bd_cells cic_compiler_0]
endgroup
copy_bd_objs /  [get_bd_cells {cic_compiler_0}]
set_property location {2 484 -148} [get_bd_cells cic_compiler_1]
delete_bd_objs [get_bd_intf_nets adc_M_AXIS]
set_property location {2 410 337} [get_bd_cells adc]
set_property location {2.5 698 292} [get_bd_cells adc]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_0
endgroup
delete_bd_objs [get_bd_cells axis_switch_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_interconnect:2.1 axis_interconnect_0
endgroup
startgroup
set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI {1} CONFIG.ENABLE_ADVANCED_OPTIONS {0} CONFIG.ARB_ALGORITHM {0}] [get_bd_cells axis_interconnect_0]
endgroup
set_property location {1 180 -211} [get_bd_cells axis_interconnect_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0
endgroup
delete_bd_objs [get_bd_cells axis_interconnect_0]
set_property location {1.5 393 29} [get_bd_cells axis_subset_converter_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_combiner:1.1 axis_combiner_0
endgroup
set_property location {2 441 -115} [get_bd_cells axis_combiner_0]
set_property location {1 412 -146} [get_bd_cells axis_combiner_0]
startgroup
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES.VALUE_SRC USER CONFIG.M_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells axis_subset_converter_0]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES {4} CONFIG.M_TDATA_NUM_BYTES {2} CONFIG.TDATA_REMAP {tdata[15:0]}] [get_bd_cells axis_subset_converter_0]
endgroup
copy_bd_objs /  [get_bd_cells {axis_subset_converter_0}]
set_property location {1 358 187} [get_bd_cells axis_subset_converter_1]
set_property -dict [list CONFIG.TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells axis_combiner_0]
set_property -dict [list CONFIG.TDATA_NUM_BYTES {2}] [get_bd_cells axis_combiner_0]
set_property screensize {366 150} [get_bd_cells axis_combiner_0]
set_property -dict [list CONFIG.TDATA_NUM_BYTES {1}] [get_bd_cells axis_combiner_0]
startgroup
set_property -dict [list CONFIG.TDATA_NUM_BYTES {2} CONFIG.NUM_SI {2}] [get_bd_cells axis_combiner_0]
endgroup
set_property -dict [list CONFIG.TDATA_REMAP {tdata[31:16]}] [get_bd_cells axis_subset_converter_1]
connect_bd_intf_net [get_bd_intf_pins adc/M_AXIS] [get_bd_intf_pins axis_subset_converter_1/S_AXIS]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_0
endgroup
delete_bd_objs [get_bd_cells axis_subset_converter_0]
delete_bd_objs [get_bd_intf_nets adc_M_AXIS] [get_bd_cells axis_subset_converter_1]
startgroup
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES.VALUE_SRC USER CONFIG.S_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells axis_broadcaster_0]
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {2} CONFIG.S_TDATA_NUM_BYTES {4} CONFIG.M01_TDATA_REMAP {tdata[31:16]} CONFIG.M00_TDATA_REMAP {tdata[15:0]}] [get_bd_cells axis_broadcaster_0]
endgroup
connect_bd_intf_net [get_bd_intf_pins axis_broadcaster_0/M00_AXIS] [get_bd_intf_pins axis_combiner_0/S00_AXIS]
connect_bd_intf_net [get_bd_intf_pins axis_broadcaster_0/M01_AXIS] [get_bd_intf_pins axis_combiner_0/S01_AXIS]
set_property location {1 120 -145} [get_bd_cells axis_broadcaster_0]
set_property location {1 119 -113} [get_bd_cells axis_broadcaster_0]
set_property location {1 138 -127} [get_bd_cells axis_broadcaster_0]
startgroup
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {4} CONFIG.M00_TDATA_REMAP {tdata[31:0]} CONFIG.M01_TDATA_REMAP {tdata[31:0]}] [get_bd_cells axis_broadcaster_0]
endgroup
delete_bd_objs [get_bd_intf_nets axis_broadcaster_0_M01_AXIS]
delete_bd_objs [get_bd_intf_nets axis_broadcaster_0_M00_AXIS]
startgroup
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells axis_broadcaster_0]
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {2} CONFIG.M01_TDATA_REMAP {tdata[31:16]} CONFIG.M00_TDATA_REMAP {tdata[15:0]}] [get_bd_cells axis_broadcaster_0]
endgroup
set_property location {2 534 -352} [get_bd_cells axis_combiner_0]
set_property location {3 868 -35} [get_bd_cells cic_compiler_1]
connect_bd_intf_net [get_bd_intf_pins axis_broadcaster_0/M00_AXIS] [get_bd_intf_pins cic_compiler_0/S_AXIS_DATA]
connect_bd_intf_net [get_bd_intf_pins axis_broadcaster_0/M01_AXIS] [get_bd_intf_pins cic_compiler_1/S_AXIS_DATA]
set_property location {4.5 1145 -131} [get_bd_cells axis_combiner_0]
connect_bd_intf_net [get_bd_intf_pins cic_compiler_0/M_AXIS_DATA] [get_bd_intf_pins axis_combiner_0/S00_AXIS]
connect_bd_intf_net [get_bd_intf_pins cic_compiler_1/M_AXIS_DATA] [get_bd_intf_pins axis_combiner_0/S01_AXIS]
connect_bd_net [get_bd_pins axis_combiner_0/aclk] [get_bd_pins clk_wiz_adc/clk_out1]
connect_bd_net [get_bd_pins cic_compiler_1/aclk] [get_bd_pins clk_wiz_adc/clk_out1]
connect_bd_net [get_bd_pins cic_compiler_0/aclk] [get_bd_pins cic_compiler_1/aclk]
connect_bd_net [get_bd_pins axis_broadcaster_0/aclk] [get_bd_pins clk_wiz_adc/clk_out1]
connect_bd_intf_net [get_bd_intf_pins adc/M_AXIS] [get_bd_intf_pins axis_broadcaster_0/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins axis_combiner_0/M_AXIS] [get_bd_intf_pins fir_compiler_0/S_AXIS_DATA]
regenerate_bd_layout
copy_bd_objs /  [get_bd_cells {fir_compiler_0}]
set_property location {6 1551 496} [get_bd_cells fir_compiler_1]
set_property name compensator [get_bd_cells fir_compiler_1]
delete_bd_objs [get_bd_intf_nets axis_combiner_0_M_AXIS]
set_property name firdec [get_bd_cells fir_compiler_0]
connect_bd_intf_net [get_bd_intf_pins compensator/S_AXIS_DATA] [get_bd_intf_pins axis_combiner_0/M_AXIS]
connect_bd_intf_net [get_bd_intf_pins firdec/S_AXIS_DATA] [get_bd_intf_pins compensator/M_AXIS_DATA]
connect_bd_net [get_bd_pins compensator/aclk] [get_bd_pins firdec/aclk]
regenerate_bd_layout
startgroup
set_property -dict [list CONFIG.Sample_Rate_Changes {Fixed} CONFIG.Minimum_Rate {125} CONFIG.Maximum_Rate {125} CONFIG.Input_Sample_Frequency {125} CONFIG.Clock_Frequency {125} CONFIG.SamplePeriod {1} CONFIG.Output_Data_Width {37}] [get_bd_cells cic_compiler_1]
endgroup
startgroup
set_property -dict [list CONFIG.Sample_Rate_Changes {Fixed} CONFIG.Minimum_Rate {125} CONFIG.Maximum_Rate {125} CONFIG.Input_Sample_Frequency {125} CONFIG.Clock_Frequency {125} CONFIG.SamplePeriod {1} CONFIG.Output_Data_Width {37}] [get_bd_cells cic_compiler_0]
endgroup
set_property location {4 830 227} [get_bd_cells cic_compiler_1]
regenerate_bd_layout
startgroup
set_property -dict [list CONFIG.Number_Of_Stages {4} CONFIG.Output_Data_Width {44}] [get_bd_cells cic_compiler_0]
endgroup
startgroup
set_property -dict [list CONFIG.Number_Of_Stages {4} CONFIG.Output_Data_Width {44}] [get_bd_cells cic_compiler_1]
endgroup
startgroup
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File {/home/edu/raphael.frey/pitaya/design/filter/coefData/compCIC/r-125--fp-0016--fst-0020--ap-250--ast-60--dl-1.coe} CONFIG.Filter_Type {Single_Rate} CONFIG.Sample_Frequency {1} CONFIG.Coefficient_Sets {1} CONFIG.Interpolation_Rate {1} CONFIG.Decimation_Rate {1} CONFIG.Zero_Pack_Factor {1} CONFIG.Number_Channels {1} CONFIG.RateSpecification {Frequency_Specification} CONFIG.Clock_Frequency {125} CONFIG.Coefficient_Sign {Signed} CONFIG.Quantization {Quantize_Only} CONFIG.Coefficient_Width {16} CONFIG.Coefficient_Fractional_Bits {16} CONFIG.Coefficient_Structure {Inferred} CONFIG.Data_Width {16} CONFIG.Output_Width {16} CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} CONFIG.ColumnConfig {1}] [get_bd_cells compensator]
endgroup
startgroup
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File {/home/edu/raphael.frey/pitaya/design/filter/coefData/decFIR/r-005--fp-400--fst-475--ap-250--ast-60.coe} CONFIG.Sample_Frequency {1} CONFIG.Coefficient_Sets {1} CONFIG.Clock_Frequency {125} CONFIG.Coefficient_Sign {Signed} CONFIG.Quantization {Quantize_Only} CONFIG.Coefficient_Width {16} CONFIG.Coefficient_Fractional_Bits {16} CONFIG.Coefficient_Structure {Inferred} CONFIG.Data_Width {16} CONFIG.Output_Width {16} CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} CONFIG.ColumnConfig {1}] [get_bd_cells firdec]
endgroup
save_bd_design
reset_run synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
reset_run synth_1
startgroup
set_property -dict [list CONFIG.Output_Data_Width {16}] [get_bd_cells cic_compiler_0]
endgroup
startgroup
set_property -dict [list CONFIG.Output_Data_Width {16}] [get_bd_cells cic_compiler_1]
endgroup
save_bd_design
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
reset_run synth_1
startgroup
set_property -dict [list CONFIG.Decimation {1}] [get_bd_cells axis2lanes]
endgroup
launch_runs impl_1 -to_step write_bitstream
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
reset_run synth_1
startgroup
endgroup
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
open_run impl_1
open_bd_design {/home/edu/raphael.frey/pitaya/firmware/fpga/build/src/src.srcs/sources_1/bd/system/system.bd}
delete_bd_objs [get_bd_intf_nets axis_broadcaster_0_M00_AXIS]
delete_bd_objs [get_bd_intf_nets cic_compiler_0_M_AXIS_DATA]
delete_bd_objs [get_bd_intf_nets cic_compiler_1_M_AXIS_DATA]
delete_bd_objs [get_bd_intf_nets axis_broadcaster_0_M01_AXIS]
delete_bd_objs [get_bd_intf_nets adc_M_AXIS]
delete_bd_objs [get_bd_intf_nets axis_combiner_0_M_AXIS]
set_property location {3 496 284} [get_bd_cells adc]
regenerate_bd_layout
connect_bd_intf_net [get_bd_intf_pins adc/M_AXIS] [get_bd_intf_pins compensator/S_AXIS_DATA]
regenerate_bd_layout
save_bd_design
reset_run synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
reset_run synth_1
startgroup
set_property -dict [list CONFIG.Decimation {125}] [get_bd_cells axis2lanes]
endgroup
startgroup
set_property -dict [list CONFIG.Sample_Frequency {125} CONFIG.Clock_Frequency {125} CONFIG.Coefficient_Width {16} CONFIG.Coefficient_Structure {Inferred} CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} CONFIG.ColumnConfig {28}] [get_bd_cells compensator]
endgroup
startgroup
set_property -dict [list CONFIG.Filter_Type {Decimation} CONFIG.Decimation_Rate {125} CONFIG.Interpolation_Rate {1} CONFIG.Zero_Pack_Factor {1} CONFIG.Number_Channels {1} CONFIG.RateSpecification {Frequency_Specification} CONFIG.Sample_Frequency {125} CONFIG.Clock_Frequency {125} CONFIG.Coefficient_Width {16} CONFIG.Coefficient_Structure {Inferred} CONFIG.Data_Width {16} CONFIG.Output_Width {16} CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} CONFIG.ColumnConfig {1}] [get_bd_cells compensator]
endgroup
startgroup
endgroup
startgroup
set_property -dict [list CONFIG.Decimation {1}] [get_bd_cells axis2lanes]
endgroup
save_bd_design
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
delete_bd_objs [get_bd_intf_nets adc_M_AXIS]
connect_bd_intf_net [get_bd_intf_pins adc/M_AXIS] [get_bd_intf_pins axis_broadcaster_0/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins axis_broadcaster_0/M00_AXIS] [get_bd_intf_pins axis_combiner_0/S00_AXIS]
connect_bd_intf_net [get_bd_intf_pins axis_broadcaster_0/M01_AXIS] [get_bd_intf_pins axis_combiner_0/S01_AXIS]
connect_bd_intf_net [get_bd_intf_pins axis_combiner_0/M_AXIS] [get_bd_intf_pins compensator/S_AXIS_DATA]
regenerate_bd_layout
save_bd_design
reset_run synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
reset_run synth_1
connect_bd_net [get_bd_pins axis_combiner_0/aresetn] [get_bd_pins system_rst/peripheral_aresetn]
connect_bd_net [get_bd_pins axis_broadcaster_0/aresetn] [get_bd_pins system_rst/peripheral_aresetn]
regenerate_bd_layout
save_bd_design
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
startgroup
set_property -dict [list CONFIG.HAS_ACLKEN {false} CONFIG.HAS_ARESETN {true}] [get_bd_cells cic_compiler_0]
endgroup
startgroup
set_property -dict [list CONFIG.Use_Xtreme_DSP_Slice {false}] [get_bd_cells cic_compiler_0]
endgroup
startgroup
set_property -dict [list CONFIG.HAS_ARESETN {true}] [get_bd_cells cic_compiler_1]
endgroup
connect_bd_net [get_bd_pins cic_compiler_1/aresetn] [get_bd_pins system_rst/peripheral_aresetn]
connect_bd_net [get_bd_pins cic_compiler_0/aresetn] [get_bd_pins system_rst/peripheral_aresetn]
delete_bd_objs [get_bd_intf_nets axis_broadcaster_0_M00_AXIS]
delete_bd_objs [get_bd_intf_nets axis_broadcaster_0_M01_AXIS]
connect_bd_intf_net [get_bd_intf_pins cic_compiler_0/S_AXIS_DATA] [get_bd_intf_pins axis_broadcaster_0/M00_AXIS]
connect_bd_intf_net [get_bd_intf_pins cic_compiler_1/S_AXIS_DATA] [get_bd_intf_pins axis_broadcaster_0/M01_AXIS]
connect_bd_intf_net [get_bd_intf_pins cic_compiler_0/M_AXIS_DATA] [get_bd_intf_pins axis_combiner_0/S00_AXIS]
connect_bd_intf_net [get_bd_intf_pins cic_compiler_1/M_AXIS_DATA] [get_bd_intf_pins axis_combiner_0/S01_AXIS]
regenerate_bd_layout
save_bd_design
reset_run synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
reset_run synth_1
startgroup
endgroup
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
startgroup
set_property -dict [list CONFIG.Filter_Type {Single_Rate} CONFIG.Sample_Frequency {1} CONFIG.Interpolation_Rate {1} CONFIG.Decimation_Rate {1} CONFIG.Zero_Pack_Factor {1} CONFIG.Number_Channels {1} CONFIG.RateSpecification {Frequency_Specification} CONFIG.Clock_Frequency {125} CONFIG.Coefficient_Width {16} CONFIG.Coefficient_Structure {Inferred} CONFIG.Data_Width {16} CONFIG.Output_Width {16} CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} CONFIG.ColumnConfig {1}] [get_bd_cells compensator]
endgroup
save_bd_design
reset_run synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
open_run synth_1 -name synth_1
open_bd_design {/home/edu/raphael.frey/pitaya/firmware/fpga/build/src/src.srcs/sources_1/bd/system/system.bd}
startgroup
set_property -dict [list CONFIG.Output_Data_Width {44}] [get_bd_cells cic_compiler_0]
endgroup
startgroup
set_property -dict [list CONFIG.Output_Data_Width {44}] [get_bd_cells cic_compiler_1]
endgroup
startgroup
set_property -dict [list CONFIG.Quantization {Truncation} CONFIG.Output_Data_Width {40}] [get_bd_cells cic_compiler_0]
endgroup
startgroup
set_property -dict [list CONFIG.Output_Data_Width {40}] [get_bd_cells cic_compiler_1]
endgroup
startgroup
set_property -dict [list CONFIG.TDATA_NUM_BYTES {5}] [get_bd_cells axis_combiner_0]
endgroup
undo
undo
undo
undo
undo
startgroup
set_property -dict [list CONFIG.Output_Data_Width {40}] [get_bd_cells cic_compiler_0]
endgroup
startgroup
set_property -dict [list CONFIG.Output_Data_Width {40}] [get_bd_cells cic_compiler_1]
endgroup
startgroup
set_property -dict [list CONFIG.TDATA_NUM_BYTES {5}] [get_bd_cells axis_combiner_0]
endgroup
startgroup
set_property -dict [list CONFIG.Coefficient_File {/home/edu/raphael.frey/pitaya/design/filter/coefData/decFIR/r-005--fp-200--fst-275--ap-250--ast-60.coe} CONFIG.Coefficient_Sets {1} CONFIG.Coefficient_Sign {Signed} CONFIG.Quantization {Quantize_Only} CONFIG.Coefficient_Width {16} CONFIG.Coefficient_Fractional_Bits {17} CONFIG.Coefficient_Structure {Inferred} CONFIG.Data_Width {16} CONFIG.Output_Width {16}] [get_bd_cells firdec]
endgroup
startgroup
set_property -dict [list CONFIG.Coefficient_Width {40} CONFIG.Data_Width {33} CONFIG.Output_Width {40} CONFIG.Coefficient_Fractional_Bits {41} CONFIG.Coefficient_Structure {Inferred} CONFIG.Output_Rounding_Mode {Truncate_LSBs} CONFIG.Output_Width {40}] [get_bd_cells compensator]
endgroup
startgroup
set_property -dict [list CONFIG.Coefficient_Width {32} CONFIG.Data_Width {40} CONFIG.Output_Width {40} CONFIG.Coefficient_Fractional_Bits {33} CONFIG.Coefficient_Structure {Inferred} CONFIG.Data_Width {40} CONFIG.Output_Rounding_Mode {Truncate_LSBs} CONFIG.Output_Width {40}] [get_bd_cells compensator]
endgroup
startgroup
endgroup
startgroup
set_property -dict [list CONFIG.Coefficient_Width {32} CONFIG.Data_Width {40} CONFIG.Coefficient_Fractional_Bits {33} CONFIG.Coefficient_Structure {Inferred} CONFIG.Data_Width {40} CONFIG.Output_Rounding_Mode {Truncate_LSBs} CONFIG.Output_Width {16}] [get_bd_cells firdec]
endgroup
save_bd_design
reset_run synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
