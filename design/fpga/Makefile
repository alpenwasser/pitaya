# ---------------------------------------------------------------------------- #
# Makefile for FPGA Filter Resource Testing
#
# Makefile for design/fpga/
# Location:    design/fpga/Makefile
#
# Authors: Raphael Frey <rmfrey@alpenwasser.net>
#
# Date:   2017-06-20
#
# Called by: user
#
# Working Directory: design/fpga/
# ---------------------------------------------------------------------------- #
COE_FILE ?= $(shell pwd)/../filter/coefData/decFIR/r-005--fp-200--fst-220--ap-250--ast-60.coe
VIVADO := vivado -nolog -nojournal -mode batch

RM := rm -f
RMR := rm -rf

.DEFAULT: all

all:
	$(VIVADO) -source vivadoDispatcher.tcl

decFIR:
	$(VIVADO) -source filters.tcl -tclargs $(COE_FILE)

clean:
	$(RM) *.log
	$(RM) *.jou
	$(RMR) tmp
