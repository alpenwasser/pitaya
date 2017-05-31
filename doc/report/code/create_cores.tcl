# ==================================================================================================
# make_cores.tcl
#
# Simple script for creating and installing all the IPs in a given directory.
# The script must be run from inside the directory it resides.
#
# by Noah Huesser <yatekii@yatekii.ch>
# based on Anton Potocnik, 01.10.2016
# ==================================================================================================

set part_name [lindex $argv 0]
set build_location [lindex $argv 1]
if {[llength $argv] > 2} {
	set core_names [lindex $argv 2]
}

#set cores [lindex $argv 0]
set cores cores

if {$rdi::mode != "batch"} {[puts "Installing cores from $cores into Vivado..."]}

if {! [file exists $cores]} {
	puts "Directory $cores was not found. No cores were installed.";
	return
} 

# Generate a the list of IP cores in the $cores directory if we didn't receive names
if {! [info exists core_names]} {
	cd $cores
	set core_names [glob -type d *]
	cd ..
}

#set core_names "axis_to_data_lanes_v1_0";
#set core_names "axis_red_pitaya_adc_v1_0";

# Import Pavel Demin's Red Pitaya cores
foreach core $core_names {
	set argv "$part_name $build_location $core"
	if {$rdi::mode != "batch"} {[puts "Installing $core..."]}
	source scripts/add_core.tcl
	if {$rdi::mode != "batch"} {[puts "==========================="]}
}