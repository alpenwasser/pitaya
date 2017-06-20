# Must be called with a coefficient file as input argument 0
set coef_file [lindex $argv 0]
#set coef_file /home/vagrant/pitaya/design/filter/coefData/decFIR/r-005--fp-200--fst-220--ap-250--ast-80.coe

# Output Files
set path [pwd]
set proj_name filter
set tmp_dir $path/tmp
file mkdir $tmp_dir
set proj_dir $tmp_dir/$proj_name
set bd_path $proj_dir/$proj_name.srcs/sources_1/bd/design_1/design_1.bd
set wrapper_path $proj_dir/$proj_name.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.vhd

# Hardware Config
set part xc7z010clg400-1
set vlnv_procsys xilinx.com:ip:processing_system7:5.5
set procsys_instance processing_system7_0
set vlnv_fircomp xilinx.com:ip:fir_compiler:7.2
set fircomp_instance fir_compiler_0
set clk 125
set decRate 5
set dataWidth 16
set fracBits 17

# Create Project
create_project -force filter $proj_dir -part $part
set_property target_language VHDL [current_project]

# Create Block Design
create_bd_design "design_1"

# Block Design: Processing System and FIR Compiler
create_bd_cell -type ip -vlnv $vlnv_procsys $procsys_instance
create_bd_cell -type ip -vlnv $vlnv_fircomp $fircomp_instance

# Connect Pins
connect_bd_net [get_bd_pins $procsys_instance/FCLK_CLK0] [get_bd_pins $fircomp_instance/aclk]
connect_bd_net [get_bd_pins $procsys_instance/FCLK_CLK0] [get_bd_pins $procsys_instance/M_AXI_GP0_ACLK]

# Wrapper
make_wrapper -files [get_files $bd_path] -top
add_files -norecurse $wrapper_path
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Configure FIR Compiler
set_property -dict [list CONFIG.Data_Width.VALUE_SRC USER] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.CoefficientSource {COE_File} CONFIG.Coefficient_File $coef_file] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Type {Decimation}] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Decimation_Rate $decRate] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Sample_Frequency $clk] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.BestPrecision {true}] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Rounding_Mode {Truncate_LSBs}] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Output_Width $dataWidth] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sets {1}] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Interpolation_Rate {1}] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Zero_Pack_Factor {1}] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Number_Channels {1}] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.RateSpecification {Frequency_Specification}] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Clock_Frequency $clk] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Sign {Signed}] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Quantization {Quantize_Only}] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Width $dataWidth] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Fractional_Bits $fracBits] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Coefficient_Structure {Inferred}] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Data_Width $dataWidth] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate}] [get_bd_cells $fircomp_instance]
set_property -dict [list CONFIG.ColumnConfig {31}] [get_bd_cells $fircomp_instance] [get_bd_cells $fircomp_instance]
save_bd_design

# Run Synthesis
reset_run synth_1
launch_runs synth_1
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    error "ERROR: synth_1 failed"
}
close_project
