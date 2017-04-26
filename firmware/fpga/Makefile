# --------------------------------------------------------------------------------
# General constants

# Change to adjust the output directory
BUILD = build

# --------------------------------------------------------------------------------
# Constants for the FPGA Core

VIVADO = vivado -nolog -nojournal -mode batch
PART = xc7z010clg400-1
CORES = $(sort $(dir $(wildcard ../Test/*/)))

all: core kernel_module kernel_module_test

all-cores:
	$(VIVADO) -source create_cores.tcl -tclargs $(PART) $(BUILD)/cores

axis_to_data_lanes:
	$(VIVADO) -source create_cores.tcl -tclargs $(PART) $(BUILD)/cores axis_to_data_lanes_v1_0

clean:
	rm -rf $(BUILD)
	rm -rf .Xil
	rm -rf .tmp_versions