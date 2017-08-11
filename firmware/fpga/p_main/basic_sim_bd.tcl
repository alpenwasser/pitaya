# ==================================================================================================
# basic_red_pitaya_bd.tcl
#
# This script creates a new Vivado project and creates interface pins to the Red Pitaya external hardware.
#
# This script is modification of Pavel Demin's project.tcl and block_design.tcl files
# by Anton Potocnik, 29.11.2016
# based on Pavel Demin's 'red-pitaya-notes-master' git repo
# ==================================================================================================

# Load any additional Verilog and VHDL files in the project folder
set files [glob -nocomplain $project_name/*.v $project_name/*.sv $project_name/*.vhd]
if {[llength $files] > 0} {
  add_files -norecurse $files
}

# Load WCFG
add_files -fileset sim_1 -norecurse $project_name/system_wrapper_behav.wcfg
set_property xsim.view $project_name/system_wrapper_behav.wcfg [get_filesets sim_1]

set_property -name {xsim.simulate.runtime} -value {200us} -objects [get_filesets sim_1]

# ====================================================================================
# Adding Simulation IP Cores

