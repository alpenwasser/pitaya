# ==================================================================================================
# make_project.tcl
#
# A simple script for creating a Vivado project from the project/ folder 
#
# by Noah Huesser <yatekii@yatekii.ch>
# based on Anton Potocnik
# based on Pavel Demin's 'red-pitaya-notes-master' git repo
# ==================================================================================================

set part_name [lindex $argv 0]
set build_location [lindex $argv 1]
set core_name [lindex $argv 2]

# Extract core name and version from fully qualified core name
set elements [split $core_name _]
set name [join [lrange $elements 0 end-2] _]
puts $argv
set version [string trimleft [join [lrange $elements end-1 end] .] v]

# Delete all existing files and directories with the same core name and version
file delete -force $build_location/$core_name $build_location/$name.cache $build_location/$name.hw $build_location/$name.xpr $build_location/$name.sim

# Create a project which is used to build the core
create_project -force -part $part_name $name $build_location


# Add all files the core consists of
set verilog_files [glob -nocomplain cores/$core_name/*.v]
set vhdl_files [glob -nocomplain cores/$core_name/*.vhd]
set tb_files [glob -nocomplain cores/$core_name/tb/*.vhd]
if {[file exists $verilog_files]} {add_files -fileset sources_1 -norecurse $verilog_files}
if {[file exists $vhdl_files]} {
    add_files -fileset sources_1 -norecurse $vhdl_files
    set_property file_type {VHDL 2008} [get_files $vhdl_files]
}
if {[file exists $tb_files]} {
    add_files -fileset sim_1 -norecurse $tb_files
    set_property file_type {VHDL 2008} [get_files $tb_files]
}

# Package a new IP
ipx::package_project -import_files -root_dir $build_location/$core_name

# Remember core to set properties
set core [ipx::current_core]

# Set core properties
set_property VERSION $version $core
set_property NAME $name $core
set_property LIBRARY {user} $core
set_property SUPPORTED_FAMILIES {zynq Production} $core

# Sets core properties and will be called from inside the specific core_config.tcl comming with each core
proc core_parameter {name display_name description} {
  set core [ipx::current_core]

  set parameter [ipx::get_user_parameters $name -of_objects $core]
  set_property DISPLAY_NAME $display_name $parameter
  set_property DESCRIPTION $description $parameter

  set parameter [ipgui::get_guiparamspec -name $name -component $core]
  set_property DISPLAY_NAME $display_name $parameter
  set_property TOOLTIP $description $parameter
}

# Set core specific properties
source cores/$core_name/core_config.tcl

# Remove command to set core properties
rename core_parameter {}

# Store all files and close project
ipx::create_xgui_files $core
ipx::update_checksums $core
ipx::save_core $core

close_project
