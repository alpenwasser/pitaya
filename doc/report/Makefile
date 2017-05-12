DOCUMENT := Main
TIMESTAMP := $(shell date '+%Y-%m-%d--%H-%M-%S')

default: simple

simple:
	@pdflatex -shell-escape $(DOCUMENT)

.PHONY: snapshot
snapshot: simple
	@cp $(DOCUMENT).pdf snapshots/$(DOCUMENT)--$(TIMESTAMP).pdf
