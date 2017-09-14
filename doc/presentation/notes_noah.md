# FPGA
- ADC of Pavel Demin Used
- ZYNQ Logger (previous project)
- Enables the User with Various Triggers
- Kernel module to control
- Ported to 16 Bits
- New Logic to Control Sampling Rate

## Filter Chains
- Chain of various Xilinx Blocks
- Bit Growth \& Bit Alignment
- Dynamic Range

## Why Use A Self Compiled Linux?}^
- Compiler/Kernel Versions known
- Automated Service Setup during Build Time
- Automated Deployment of Applications
- State Rescuing

## Solution
- Xilinx ARM Linux
- Ubuntu
- Red Pitaya Patches
- Server Application

## Server
- WebSockets (uWS, C++17)
- Talks to Kernel Module, Sends to Web
- Kernel Module Serves RAM \& Interfaces the FPGA

## GUI, Scope Features

### Scope Features
- General scoping functionality
- Highly modular and extensible
- Display data in time and frequency space
- Calculate power in an interval
- Auto-detect the SNR
