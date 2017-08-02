# ==================================================================================================
# make_project.tcl
#
# A simple script for creating a Vivado project from the project/ folder 
#
# by Noah Huesser <yatekii@yatekii.ch>
# by Raphael Frey <rmfrey@alpenwasser.net>
# based on Anton Potocnik, 02.10.2016 - 08.01.2017
# based on Pavel Demin's 'red-pitaya-notes-master' git repo
# ==================================================================================================

set project_name [lindex $argv 0]
set sim [lindex $argv 1]

source $project_name/block_design.tcl
