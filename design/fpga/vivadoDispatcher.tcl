set path [pwd]
set report_dir $path/reports
set report_src tmp/filter/filter.runs/synth_1/design_1_wrapper_utilization_synth.rpt
set decFIR_dir $path/../filter/coefData/decFIR

cd $decFIR_dir
set coe_files [glob -type f *]
cd $path

# from firmware/fpga/design_cores.tcl
foreach coe_file $coe_files {
    set argv "$decFIR_dir/$coe_file"
    source filters.tcl
    set report_target decFIR--$coe_file
    regsub coe $report_target rpt report_target
    file copy -force $report_src $report_dir/$report_target
}
