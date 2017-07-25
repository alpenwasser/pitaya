#!/bin/bash -f
xv_path="/shared/eda/lnx_exe/xilinx/xilinx_vivado_2016.2/Vivado/2016.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim design_1_wrapper_behav -key {Behavioral:sim_1:Functional:design_1_wrapper} -tclbatch design_1_wrapper.tcl -view /home/edu/noah.huesser/repos/FIR_sim/design_1_wrapper_behav.wcfg -log simulate.log
