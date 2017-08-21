# FPGA firmware for the Red Pitaya Oscilloscope

This directory contains the firmware for  the ZYNQ FPGA.  The base TCL scripts
were taken from Pavel Demin and Anton  Potocnik, which is always denoted so in
the source headers if it is the  case. Thank You! to them at this place, since
they really untangled part of the mess the Red Pitaya software is.

We are trying to keep an ordered  structure and document everything as well as
possible, following Anton's example who did really great tutorials.

`./` refers to the directory this `README.md` resides in.

## Building the project

To create a new Vivado project, fire up Vivado and locate the TCL shell.
Type

```source make_cores.tcl ./cores```
  
which will import all the ./cores directory.

Right  after Vivado  finished doing  it's  job –  this will  open and  close
several new projects and windows and take a few minutes – type

```source make_project.tcl```
  
which will create a new Vivado project  in the `./tmp` directory and route all
configured components.

If you  add new functionality  don't just add  it in the  UI but in  the _TCL_
scripts. This will keep the whole thing organized and procedural.

How a new core can be added is described in the `./cores/README.md`.

## NOTE on p_FIR_sim

The  simulations  have  some  absolute  paths in  them  from  when  they  were
run. Adjustments  might be  necessary  when trying  to run  them  on your  own
machine.
