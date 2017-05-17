DOCUMENT := Main
TIMESTAMP := $(shell date '+%Y-%m-%d--%H-%M-%S')
OUT_DIR := build
INTERACTION := batchmode
MINTED_DIR := _minted-Main
TIKZ_DIR := tikzCache
CLASS := alpenthesis
RANDINTS := randInts
CORE_COUNT := 4


default: simple

# Workarounds so that the tikz externalize library will find
# the things it needs to do its magic.
tikzcache:
	@mkdir -p $(OUT_DIR)/$(TIKZ_DIR)
	@mkdir -p $(OUT_DIR)/$(CLASS)
	@ln -fs $(OUT_DIR)/$(TIKZ_DIR) ./$(TIKZ_DIR)
	@ln -fs ../../$(CLASS)/$(CLASS).cls $(OUT_DIR)/$(CLASS)/$(CLASS).cls
	@ln -fs ../../$(CLASS)/$(RANDINTS).tex $(OUT_DIR)/$(CLASS)/$(RANDINTS).tex
	@ln -fs ../$(DOCUMENT).tex $(OUT_DIR)/$(DOCUMENT).tex

# There is  a circular  dependency between tikzpics  and the
# regular targets, so  this target needs to  be run manually
# at the appropriate times (see README.md).
tikz:
	@make -j$(CORE_COUNT) -C $(OUT_DIR) -f $(DOCUMENT).makefile

# Compile document without output.
simple: tikzcache
	@pdflatex -shell-escape -interaction=$(INTERACTION) -output-directory=$(OUT_DIR) $(DOCUMENT)

# Compile document with console output.
debug: tikzcache
	@pdflatex -shell-escape -output-directory=$(OUT_DIR) $(DOCUMENT)

# Make  a  snapshot of  the  current  pdf. Due to  the  tikz
# externalize library  stuff, we  set this  to automatically
# depend on the 'simple' or 'debug' target; instead you must
# ensure that the pdf exists manually.
.PHONY: snapshot
snapshot:
	@cp $(OUT_DIR)/$(DOCUMENT).pdf snapshots/$(DOCUMENT)--$(TIMESTAMP).pdf

# Tidy up, but don't clean out cached files and pdf documents.
tidy:
	@rm -f $(TIKZ_DIR)
	@rm -f $(OUT_DIR)/$(DOCUMENT).tex
	@rm -rf $(OUT_DIR)/alpenthesis
	@rm -f $(OUT_DIR)/Main.aux
	@rm -f $(OUT_DIR)/Main.figlist
	@rm -f $(OUT_DIR)/Main.lof
	@rm -f $(OUT_DIR)/Main.log
	@rm -f $(OUT_DIR)/Main.lol
	@rm -f $(OUT_DIR)/Main.lot
	@rm -f $(OUT_DIR)/Main.makefile
	@rm -f $(OUT_DIR)/Main.mw
	@rm -f $(OUT_DIR)/Main.out
	@rm -f $(OUT_DIR)/Main.toc

# Clean out all the files and symlinks.
clean:
	@mv $(OUT_DIR)/Main.ctr ./
	@rm -rf $(OUT_DIR)/*
	@mv Main.ctr $(OUT_DIR)/
	@rm -f $(TIKZ_DIR)
	@rm -f $(OUT_DIR)/$(DOCUMENT).tex

