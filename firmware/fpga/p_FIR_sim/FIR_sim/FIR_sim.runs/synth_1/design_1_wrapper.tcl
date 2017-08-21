# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7z010clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.cache/wt [current_project]
set_property parent.project_path /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths /home/edu/noah.huesser/repos/pitaya/firmware/fpga/build/cores [current_project]
add_files /home/edu/noah.huesser/repos/pitaya/design/filter/coefData/decFIR/r-005--fp-200--fst-225--ap-200--ast-60.coe
add_files /home/edu/noah.huesser/repos/pitaya/design/filter/coefData/decFIR/r-005--fp-200--fst-300--ap-050--ast-60.coe
add_files /home/edu/noah.huesser/repos/pitaya/firmware/fpga/p_chain5/coefData/dec5steep.coe
add_files /home/edu/noah.huesser/repos/pitaya/firmware/fpga/p_chain5/coefData/dec5flat.coe
add_files /home/edu/noah.huesser/repos/pitaya/firmware/fpga/p_chain5/coefData/comp025.coe
add_files /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/design_1.bd
set_property used_in_implementation false [get_files -all /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/ip/design_1_fir_compiler_0_0/fir_compiler_v7_2_6/constraints/fir_compiler_v7_2.xdc]
set_property used_in_implementation false [get_files -all /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/ip/design_1_fir_compiler_0_0/design_1_fir_compiler_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/ip/design_1_dds_compiler_0_1/design_1_dds_compiler_0_1_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/ip/design_1_axis_broadcaster_0_0/design_1_axis_broadcaster_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/ip/design_1_FIR_resized_0/fir_compiler_v7_2_6/constraints/fir_compiler_v7_2.xdc]
set_property used_in_implementation false [get_files -all /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/ip/design_1_FIR_resized_0/design_1_FIR_resized_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/ip/design_1_FIR_resized1_0/fir_compiler_v7_2_6/constraints/fir_compiler_v7_2.xdc]
set_property used_in_implementation false [get_files -all /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/ip/design_1_FIR_resized1_0/design_1_FIR_resized1_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/ip/design_1_cic_compiler_0_0/design_1_cic_compiler_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/ip/design_1_FIR_resized1_1/fir_compiler_v7_2_6/constraints/fir_compiler_v7_2.xdc]
set_property used_in_implementation false [get_files -all /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/ip/design_1_FIR_resized1_1/design_1_FIR_resized1_1_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/design_1_ooc.xdc]
set_property is_locked true [get_files /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/design_1.bd]

read_verilog -library xil_defaultlib /home/edu/noah.huesser/repos/FIR_sim/FIR_sim.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top design_1_wrapper -part xc7z010clg400-1


write_checkpoint -force -noxdef design_1_wrapper.dcp

catch { report_utilization -file design_1_wrapper_utilization_synth.rpt -pb design_1_wrapper_utilization_synth.pb }