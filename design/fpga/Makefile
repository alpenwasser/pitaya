COE_FILE := /home/vagrant/pitaya/design/filter/coefData/decFIR/r-005--fp-200--fst-220--ap-250--ast-80.coe

default:
	vivado -nolog -nojournal -mode batch -source filters.tcl -tclargs $(COE_FILE)
	cp tmp/filter/filter.runs/synth_1/design_1_wrapper_utilization_synth.rpt ./

clean:
	rm -f *.log
	rm -f *.jou
	rm -rf tmp
