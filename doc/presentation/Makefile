TIMESTAMP := $(shell date '+%Y-%m-%d--%H-%M-%S')
OUT_DIR = build
LATEX = xelatex -shell-escape -interaction=batchmode -output-directory=$(OUT_DIR)
DEBUG = xelatex -shell-escape -output-directory=$(OUT_DIR)
DOC = Main
RMR = rm -rf

.DEFAULT_GOAL := simple

build:
	@mkdir -p $(OUT_DIR)

simple: build
	@$(LATEX) $(DOC)

debug: build
	@$(DEBUG) $(DOC)

# Transparencies
trans: build
	@cp $(DOC).tex $(DOC).tex.bak
	@cat $(DOC).tex.bak | \
		sed 's/^\\documentclass{/\\documentclass[trans]{/' | \
		sed 's/^%\?\\addtobeamertemplate{background canvas}{\\transdissolve\[duration=1\]\\hspace{-0.29em}}{}/%\\addtobeamertemplate{background canvas}{\\transdissolve\[duration=1\]\\hspace{-0.29em}}{}/' > $(DOC).tex
	@$(LATEX) $(DOC)
	@$(LATEX) $(DOC) # For correct progress bar
	@cp $(OUT_DIR)/Main.pdf $(OUT_DIR)/transparencies.pdf
	@mv $(DOC).tex.bak $(DOC).tex

# Handout
handout: build
	@cp $(DOC).tex $(DOC).tex.bak
	@cat $(DOC).tex.bak | \
		sed 's/^\\documentclass{/\\documentclass[handout]{/' | \
		sed 's/^%\?\\addtobeamertemplate{background canvas}{\\transdissolve\[duration=1\]\\hspace{-0.29em}}{}/%\\addtobeamertemplate{background canvas}{\\transdissolve\[duration=1\]\\hspace{-0.29em}}{}/' > $(DOC).tex
	@$(LATEX) $(DOC)
	@$(LATEX) $(DOC) # For correct progress bar
	@cp $(OUT_DIR)/Main.pdf $(OUT_DIR)/handout.pdf
	@mv $(DOC).tex.bak $(DOC).tex

# Presentation
presentation: build
	@cp $(DOC).tex $(DOC).tex.bak
	@cat $(DOC).tex.bak | \
		sed 's/^%\?\\addtobeamertemplate{background canvas}{\\transdissolve\[duration=1\]\\hspace{-0.29em}}{}/\\addtobeamertemplate{background canvas}{\\transdissolve\[duration=1\]\\hspace{-0.29em}}{}/' > $(DOC).tex
	@$(LATEX) $(DOC)
	@$(LATEX) $(DOC) # For correct progress bar
	@cp $(OUT_DIR)/Main.pdf $(OUT_DIR)/presentation.pdf
	@mv $(DOC).tex.bak $(DOC).tex

all: handout presentation trans

clean:
	@$(RMR) $(OUT_DIR)

# Clean up, then recompile everything
rebuild: clean all

snapshot: all
	@mkdir -p snapshots
	@mv $(OUT_DIR)/handout.pdf snapshots/$(TIMESTAMP)--handout.pdf
	@mv $(OUT_DIR)/presentation.pdf snapshots/$(TIMESTAMP)--presentation.pdf
	@mv $(OUT_DIR)/transparencies.pdf snapshots/$(TIMESTAMP)--transparencies.pdf
