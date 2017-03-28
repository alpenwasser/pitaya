# The cores library for the Red Pitaya

All cores in this directory for now have been taken from [Pavel Demins' repo](https://github.com/pavel-demin/red-pitaya-notes) and are licensed under the [MIT license](https://github.com/pavel-demin/red-pitaya-notes/blob/master/LICENSE). Lateron our own cores in VHDL will be added.

`./` points to the directory this `README.md` resides in.

## Adding a new core

To add a new core, create a new directory which should be named `<name>_v<major>_<minor>`. Spaces in `<name>` should be replaced with `_`. Like that the script to install cores (`./make_cores.tcl`) can automatically find them.

Each directory should contain the sources and a TCL script named `core_config.tcl`. That script can use a the function

```core_parameter name display_name description```

to add parameters to the core. Like that generic cores can be easily created.

The newly created core can then easily be added by using the `./make_cores.tcl` install script.
