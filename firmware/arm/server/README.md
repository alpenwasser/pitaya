Server Application for Red Pitaya
=================================

The server runs on the Red Pitaya and provides the interface to which the
scope web client connects.

Build Tree Structure
====================

```
.
├── Makefile       # Master Makefile. Calls external/Makefile, Makefile.arm
├── Makefile.arm   # Makefile for building server for ARM
├── Makefile.osx   # Makefile for building server for macOS (testing only)
└── external
    ├── Makefile   # Master Makefile for external libraries
    │              # calls openssl/Configure, openssl/Makefile,
    │              #       zlib/configure, zlib/Makefile,
    │              #       Makefile.uWS.arm
    ├── openssl
    │   ├── Configure
    │   └── Makefile
    ├── zlib-1.2.11.tar.gz
    │    ├── configure
    │    └── Makefile
    ├── uWebSockets
    └── Makefile.uWS.arm # Makefile for uWebSockets for ARM
```

Building
========

## Everything

```
make all
```

This will first build the external libraries and then the server for ARM.

## External Libs Only

In `external/` directory, call

```
make all
```
or for the partial targets
```
make openssl
make zlib
make uws
```

**NOTE:** uws requires openssl and zlib, so those must have been built
previously.


Compile Times
=============

To give you a rough idea of how long this can take:

## Host 1: 10 PC/20 LC, Xeon X5680 (3.33 GHz)

```
./
make -f Makefile.new arm    4.62s user    4.21s system  62% cpu      14.130 total
make -f Makefile.new all  317.56s user 3386.06s system 103% cpu   59:48.98  total
make all                  330.97s user 3491.08s system 100% cpu 1:03:41.79  total


./external

make -f Makefile.new openssl  293.16s user 3524.51s system 101% cpu 1:02:28.29 total
make -f Makefile.new zlib      13.89s user   35.84s system  54% cpu    1:31.91 total
make -f Makefile.new uws       18.67s user   30.76s system  59% cpu    1:23.01 total
```
