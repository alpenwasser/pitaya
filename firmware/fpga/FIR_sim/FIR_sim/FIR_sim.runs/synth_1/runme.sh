#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/shared/eda/lnx_exe/xilinx/xilinx_vivado_2016.2/SDK/2016.2/bin:/shared/eda/lnx_exe/xilinx/xilinx_vivado_2016.2/Vivado/2016.2/ids_lite/ISE/bin/lin64:/shared/eda/lnx_exe/xilinx/xilinx_vivado_2016.2/Vivado/2016.2/bin
else
  PATH=/shared/eda/lnx_exe/xilinx/xilinx_vivado_2016.2/SDK/2016.2/bin:/shared/eda/lnx_exe/xilinx/xilinx_vivado_2016.2/Vivado/2016.2/ids_lite/ISE/bin/lin64:/shared/eda/lnx_exe/xilinx/xilinx_vivado_2016.2/Vivado/2016.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=/shared/eda/lnx_exe/xilinx/xilinx_vivado_2016.2/Vivado/2016.2/ids_lite/ISE/lib/lin64
else
  LD_LIBRARY_PATH=/shared/eda/lnx_exe/xilinx/xilinx_vivado_2016.2/Vivado/2016.2/ids_lite/ISE/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/edu/noah.huesser/repos/FIR_sim/FIR_sim.runs/synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log design_1_wrapper.vds -m64 -mode batch -messageDb vivado.pb -notrace -source design_1_wrapper.tcl
