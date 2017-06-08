set path [pwd]
file mkdir $path/tmp
create_project -force filter $path/tmp/filter -part xc7z010clg400-1
create_bd_design "design_1"
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_compiler_0
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins fir_compiler_0/aclk]                                   
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
make_wrapper -files [get_files $path/filter/filter.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse /home/edu/raphael.frey/filter/filter.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.vhd
update_compile_order -fileset sources_1
set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File {/home/edu/raphael.frey/pitaya/design/filter/coefData/decFIR/r-005--fp-200--fst-220--ap-250--ast-80.coe}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Filter_Type {Decimation}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Decimation_Rate {5}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Sample_Frequency {125}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Clock_Frequency {125}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.BestPrecision {true}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Output_Width {16}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Coefficient_Sets {1}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Interpolation_Rate {1}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Number_Channels {1}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Clock_Frequency {125}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Quantization {Quantize_Only}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Coefficient_Width {16}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Coefficient_Fractional_Bits {17}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Data_Width {16}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}] [get_bd_cells fir_compiler_0]
set_property -dict [list CONFIG.ColumnConfig {31}] [get_bd_cells fir_compiler_0] [get_bd_cells fir_compiler_0]
save_bd_design
reset_run synth_1
launch_runs synth_1
