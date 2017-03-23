# FPGA firmware for the Red Pitaya Oscilloscope

This directory contains the firmware for the ZYNQ FPGA.
The base TCL scripts were taken from Pavel Demin and Anton Potocnik, which is always denoted so in the source headers if it is the case. Thank You! to them at this place, since they really unwarngled part of the mess the Red Pitaya software is.

Following up on that we are trying to keep a very ordered structure and document everything as good as possible, following Antons example who did really great tutorials.

`./` refers to the directory this `README.md` resides in.

## Building the project

To create a new Vivado project, fire up Vivado and locate the TCL shell.
Type

```source make_cores.tcl ./cores```
  
which will import all the ./cores directory.
Right after Vivado finished doing it's job – this will open and close several new projects and windows and take a few minutes – type

```source make_project.tcl```
  
which will create a new Vivado project in the `./tmp` directory and route all configured components.

If you add new functionality don't just add it in the UI but in the _TCL_ scripts. This will keep the whole thing organized and procedural.

How a new core can be added is described in the `./cores/README.md`.
