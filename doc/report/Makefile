DOCUMENT := Main
TIMESTAMP := $(shell date '+%Y-%m-%d--%H-%M-%S')
OUT_DIR := build
INTERACTION := batchmode

default: simple

simple:
	@mkdir -p $(OUT_DIR)
	@pdflatex -shell-escape -interaction=$(INTERACTION) -output-directory=$(OUT_DIR) $(DOCUMENT)

.PHONY: snapshot
snapshot: simple
	@cp $(OUT_DIR)/$(DOCUMENT).pdf snapshots/$(DOCUMENT)--$(TIMESTAMP).pdf

clean:
	rm -f $(OUT_DIR)/$(DOCUMENT).aux
	rm -f $(OUT_DIR)/$(DOCUMENT).auxlock
	rm -f $(OUT_DIR)/$(DOCUMENT).log
	rm -f $(OUT_DIR)/$(DOCUMENT).out
	rm -f $(OUT_DIR)/$(DOCUMENT).pdf
	rm -f $(OUT_DIR)/$(DOCUMENT).toc
