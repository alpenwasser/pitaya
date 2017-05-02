set project_path [lindex $argv 0]
set project_name [lindex $argv 1]

open_project $project_path/$project_name.xpr

if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
  launch_runs impl_1 -to_step route_design
  wait_on_run impl_1
}

open_run [get_runs impl_1]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

write_bitstream -force -file $project_path/$project_name.bit

close_project
