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

set cores [lindex $argv 0]
puts "Installing cores from $cores into Vivado..."

if {! [file exists $cores]} {
	puts "Directory $cores was not found. No cores were installed.";
	return
} 

# Generate a the list of IP cores in the $cores directory
cd $cores
set core_names [glob -type d *]
cd ..

# Import cores
foreach core $core_names {
	set argv "$core $part_name"
	puts "Installing $core...";
	source scripts/add_core.tcl
	puts "===========================";
}