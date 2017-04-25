# ==================================================================================================
# make_cores.tcl
#
# Simple script for creating and installing all the IPs in a given directory.
# The script must be run from inside the directory it resides.
#
# by Noah Huesser <yatekii@yatekii.ch>
# based on Anton Potocnik, 01.10.2016
# ==================================================================================================

set part_name xc7z010clg400-1

#set cores [lindex $argv 0]
set cores cores

puts "Installing cores from $cores into Vivado..."

if {! [file exists $cores]} {
	puts "Directory $cores was not found. No cores were installed.";
	return
} 

# Generate a the list of IP cores in the $cores directory
cd $cores
set core_names [glob -type d *]
cd ..

puts "$core_names";
#set core_names "axis_to_data_lanes_v1_0";
#set core_names "axis_red_pitaya_adc_v1_0";

# Import Pavel Demin's Red Pitaya cores
foreach core $core_names {
	set argv "$core $part_name"
	puts "Installing $core...";
	source scripts/add_core.tcl
	puts "===========================";
}

update_ip_catalog
