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
ExecStep $xv_path/bin/xelab -wto 6f0bc133ebfd4f9eb8710b42bf6d38e7 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L xpm -L xbip_utils_v3_0_6 -L axi_utils_v2_0_2 -L xbip_pipe_v3_0_2 -L xbip_bram18k_v3_0_2 -L mult_gen_v12_0_11 -L xbip_dsp48_wrapper_v3_0_4 -L xbip_dsp48_addsub_v3_0_2 -L xbip_dsp48_multadd_v3_0_2 -L dds_compiler_v6_0_12 -L fir_compiler_v7_2_6 -L cic_compiler_v4_0_10 -L unisims_ver -L unimacro_ver -L secureip --snapshot design_1_wrapper_behav xil_defaultlib.design_1_wrapper xil_defaultlib.glbl -log elaborate.log