Firmware for Red Pitaya
=======================

This directory contains the firmware modules to be run on the Red Pitaya.
The main components are:

- The logger module (`fpga/zynq_logger`): An FPGA component for acquiring data 
from a sources. Consists of the FPGA block as well as a Linux kernel module to
read the data from the FPGA block.
- A GNU/Linux operating system (`arm`): The OS which runs on the Red Pitaya.
- A server application (`arm/server`): A server which reads data from the
Linux kernel module and can be connected to from a web interface.

Building
========

## From a Clean Slate
When starting from a fresh repository, or a cleaned directory:

```
make init
```

This will call the appropriate targets in each component's Makefile
in the correct order:

- `make cores`
- `make linux`
- `make kernel_module`
- `make kernel_module_test`
- `make server`


## Partial Targets

```
make cores
```

Builds the IP cores.


```
make linux
```

Builds the Linux OS without rebuilding the IP cores.


```
make kernel_module
```

Builds the kernel module. Linux must exist at this point.


```
make kernel_module_test
```

Builds a test case for the kernel module. Linux must exist at this point.

```
make server
```

Builds the server. Standalone target.

```
make clean
```

Cleans out everything.


Build Times
===========

Macbook Pro, Intel i7-4770HQ (Turbo on), 4C assigned to buildbox:

```
make init  1038.40s user 681.94s system 131% cpu 21:46.73 total
make server  223.69s user 1372.28s system 128% cpu 20:41.91 total
```


TODO
====

Make the thing smarter so it only builds what's needed when it is needed.
