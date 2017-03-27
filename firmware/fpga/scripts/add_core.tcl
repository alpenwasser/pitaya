# ==================================================================================================
# make_project.tcl
#
# A simple script for creating a Vivado project from the project/ folder 
#
# by Noah Huesser <yatekii@yatekii.ch>
# based on Anton Potocnik
# based on Pavel Demin's 'red-pitaya-notes-master' git repo
# ==================================================================================================

# Get core name and FPGA name
set core_name [lindex $argv 0]
set part_name [lindex $argv 1]

# Uncomment the following two lines to test cores
# set core_name axi_axis_reader_v1_0
# set part_name xc7z010clg400-1

# Extract core name and version from fully qualified core name
set elements [split $core_name _]
set name [join [lrange $elements 0 end-2] _]
set version [string trimleft [join [lrange $elements end-1 end] .] v]

# Delete all existing files and directories with the same core name and version
file delete -force build/cores/$core_name build/cores/$name.cache build/cores/$name.hw build/cores/$name.xpr build/cores/$name.sim

# Create a project which is used to build the core
create_project -part $part_name $name build/cores

# Add all files the core consists of
add_files -norecurse [glob cores/$core_name/*.v]

# Package a new IP
ipx::package_project -import_files -root_dir build/cores/$core_name

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
