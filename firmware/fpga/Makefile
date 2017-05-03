# --------------------------------------------------------------------------------
# General constants

# Change to adjust the output directory
BUILD = build

# --------------------------------------------------------------------------------
# Constants for the FPGA Core

VIVADO = vivado -nolog -nojournal -mode batch
PART = xc7z010clg400-1

all: all-cores zynq_logger project

all-cores:
	$(VIVADO) -source create_cores.tcl -tclargs $(PART) $(BUILD)/cores
	rm -f vivado*
	rm -f webtalk*

axis_to_data_lanes:
	$(VIVADO) -source create_cores.tcl -tclargs $(PART) $(BUILD)/cores axis_to_data_lanes_v1_0
	rm -f vivado*
	rm -f webtalk*

.PHONY: zynq_logger
zynq_logger:
	cd zynq_logger && make core

project:
	$(VIVADO) -source make_project.tcl
	rm -f vivado*
	rm -f webtalk*

clean:
	rm -rf $(BUILD)
	rm -rf .Xil
	rm -rf .tmp_versions