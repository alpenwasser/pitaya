DOCUMENT := Main
OUT_DIR := build
SNAP_DIR := snapshots
TIMESTAMP := $(shell date '+%Y-%m-%d--%H-%M-%S')
INTERACTION := batchmode

default: simple

simple:
	@mkdir -p $(OUT_DIR)
	@pdflatex -interaction=$(INTERACTION) -output-directory=$(OUT_DIR) $(DOCUMENT)

debug:
	@mkdir -p $(OUT_DIR)
	@pdflatex -output-directory=$(OUT_DIR) $(DOCUMENT)

.PHONY: snapshot
snapshot: simple
	@mkdir -p $(SNAP_DIR)
	@cp $(OUT_DIR)/$(DOCUMENT).pdf $(SNAP_DIR)/$(DOCUMENT)--$(TIMESTAMP).pdf

clean:
	rm -f $(OUT_DIR)/$(DOCUMENT).aux
	rm -f $(OUT_DIR)/$(DOCUMENT).auxlock
	rm -f $(OUT_DIR)/$(DOCUMENT).log
	rm -f $(OUT_DIR)/$(DOCUMENT).out
	rm -f $(OUT_DIR)/$(DOCUMENT).pdf
