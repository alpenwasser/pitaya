Red Pitaya Custom DAS
=====================

![Oscilloscope Screenshot][scopeScreenShot]

Summary
-------

This project realizes  a system for measuring analog signals  in the kilohertz
to low megahertz  range with a digital signal processing  system in real time,
offering  an affordable  alternative to  expensive oscilloscopes  and spectrum
analyzers. The basic  components of the  system are  a Red Pitaya  STEMlab for
signal acquisition and processing and a personal computer or mobile device for
data visualization and further analysis.

To  allow transmission  over  an  Ethernet connection  and  to improve  signal
quality, the high-rate data stream coming from the STEMlab's analog-to-digital
converter  is   decimated  to  a   lower-rate  signal  using   the  integrated
FPGA. During decimation, the signal passes through one of six filter chains to
attenuate aliasing  effects. 

The chains run on  the STEMlab's FPGA. They are based on  a combination of FIR
and CIC filters, and decimate the incoming 125MHz signal to output frequencies
between  50kHz and  25MHz, depending  on the  chain. They achieve  an aliasing
attenuation of  60dB and exhibit negligible  passband droop. A signal-to-noise
ratio of up to 84dB has been measured.

The decimated signal is then passed on  to an embedded GNU/Linux and sent to a
client over  a network connection. A newly  developed oscilloscope application
allows observation  of the signal  from a  client device.  The  application is
based on JavaScript,  allowing for easy deployment across any  platform with a
modern browser available.

All components created for this project  are provided under the MIT license. A
comprehensive toolchain covering filter design, FPGA tools, embedded GNU/Linux
and front end  development, along with documentation, allows  anyone to extend
and modify the system and to tailor it to their needs.


Project Structure (Major Components Only)
-----------------------------------------

```
.
├── design
│   └── filter: Filter design toolchain (Matlab)
│
├── doc
│   ├── report:         Project Report, Developer Guide, User Guide
│   ├── verification:   Measurement toolchain and results
│   └── vivado-install: Vivado install guide
│
├── env: Toolchain setup. Consult the Developer Guide for details.
│
├── firmware: The things which have to run on the STEMlab
│   ├── arm:  GNU/Linux and server for data transmission
│   ├── bin:  binary blobs for flashing
│   └── fpga: FPGA components: Vivado Projects and IP Cores
│
├── pm: Project Management Stuff
│   └── journal: Project Journal (misc. notes)
│
├── resources: Datasheets, manuals, various other resources.
│
└── scope: Oscilloscope Application
```

[scopeScreenShot]: doc/report/images/gui/scope.png "Screenshot of Scope"
