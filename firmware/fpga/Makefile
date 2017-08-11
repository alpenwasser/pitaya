# --------------------------------------------------------------------------------
# General constants

# Change to adjust the output directory
BUILD = build

# --------------------------------------------------------------------------------
# Constants for the FPGA Core

VIVADO = vivado -nolog -nojournal -mode batch
PART = xc7z010clg400-1

all: all-cores zynq_logger

all-cores:
	$(VIVADO) -source create_cores.tcl -tclargs $(PART) $(BUILD)/cores
	rm -f vivado*
	rm -f webtalk*

axis_to_data_lanes:
	$(VIVADO) -source create_cores.tcl -tclargs $(PART) $(BUILD)/cores axis_to_data_lanes_v1_0
	rm -f vivado*
	rm -f webtalk*

axis_multiplexer:
	$(VIVADO) -source create_cores.tcl -tclargs $(PART) $(BUILD)/cores axis_multiplexer_v1_0
	rm -f vivado*
	rm -f webtalk*

dec_to_fir_mux:
	$(VIVADO) -source create_cores.tcl -tclargs $(PART) $(BUILD)/cores dec_to_fir_mux_v1_0
	rm -f vivado*
	rm -f webtalk*

.PHONY: zynq_logger
zynq_logger:
	cd zynq_logger && make core

project:
	$(VIVADO) -source make_project.tcl -tclargs p_main
	rm -f vivado*
	rm -f webtalk*

projectsim:
	$(VIVADO) -source make_project.tcl -tclargs p_main sim
	rm -f vivado*
	rm -f webtalk*

nofilters:
	$(VIVADO) -source make_project.tcl -tclargs p_nofilters
	rm -f vivado*
	rm -f webtalk*

bcmux:
	$(VIVADO) -source make_project.tcl -tclargs p_bcmux
	rm -f vivado*
	rm -f webtalk*

sim_bcfirmux:
	$(VIVADO) -source make_project.tcl -tclargs p_sim_bcfirmux
	rm -f vivado*
	rm -f webtalk*

bcfirmux:
	$(VIVADO) -source make_project.tcl -tclargs p_bcfirmux
	rm -f vivado*
	rm -f webtalk*

firtest:
	$(VIVADO) -source make_project.tcl -tclargs p_firtest
	rm -f vivado*
	rm -f webtalk*

cictest:
	$(VIVADO) -source make_project.tcl -tclargs p_cictest
	rm -f vivado*
	rm -f webtalk*

clean:
	rm -rf $(BUILD)
	rm -rf .Xil
	rm -rf .tmp_versions

clean_project:
	rm -rf $(BUILD)/p_main
	rm -rf .Xil
	rm -rf .tmp_versions

clean_cores:
	rm -rf $(BUILD)/cores
	rm -rf .Xil
	rm -rf .tmp_versions
