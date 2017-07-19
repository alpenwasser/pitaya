DOCUMENT := Main
TIMESTAMP := $(shell date '+%Y-%m-%d--%H-%M-%S')
INTERACTION := batchmode
CLASS := alpenthesis
RANDINTS := randInts
CORE_COUNT := $(shell nproc 2>/dev/null || echo 1)
OUT_DIR := build
TIKZ_DIR := tikzCache
META_DIR := meta
BUNDLE_CFG := $(META_DIR)/bundledoc.cfg
CODE_DIR := code
CHUNK_DIR := chunks

# Generate host-specific identifiers, or
# default ones if unailable.
# http://stackoverflow.com/a/20566812
ifneq ("$(wildcard meta/machine-id)","")
	# file exists
	HOST_ID := $(shell cat meta/machine-id)
else
	# file does not exist
	HOST_ID := $(shell date +%s)
endif
ifneq ("$(wildcard meta/hostname)","")
	HOST_NAME := $(shell cat meta/hostname)
else
	HOST_NAME := unknown_host
endif


default: simple

# Workarounds so that the tikz externalize library will find
# the things it needs to do its magic.
tikzcache:
	@mkdir -p $(OUT_DIR)/$(TIKZ_DIR)
	@mkdir -p $(OUT_DIR)/$(CLASS)
	@[ -L $(OUT_DIR)/$(CHUNK_DIR) ] || ln -s ../$(CHUNK_DIR) $(OUT_DIR)/$(CHUNK_DIR)
	@[ -L $(OUT_DIR)/$(CODE_DIR) ] || ln -s ../$(CODE_DIR) $(OUT_DIR)/$(CODE_DIR)
	@[ -L ./$(TIKZ_DIR) ] || ln -s $(OUT_DIR)/$(TIKZ_DIR) ./$(TIKZ_DIR)
	@[ -L $(OUT_DIR)/$(CLASS)/$(CLASS).cls ] || ln -s ../../$(CLASS)/$(CLASS).cls $(OUT_DIR)/$(CLASS)/$(CLASS).cls
	@[ -L $(OUT_DIR)/$(CLASS)/$(RANDINTS).tex ] || ln -s ../../$(CLASS)/$(RANDINTS).tex $(OUT_DIR)/$(CLASS)/$(RANDINTS).tex
	@[ -L $(OUT_DIR)/$(DOCUMENT).tex ] || ln -s ../$(DOCUMENT).tex $(OUT_DIR)/$(DOCUMENT).tex

# There is  a circular  dependency between tikzpics  and the
# regular targets, so  this target needs to  be run manually
# at the appropriate times (see README.md).
tikz:
	@make -j$(CORE_COUNT) -C $(OUT_DIR) -f $(DOCUMENT).makefile

.PHONY: meta
meta:
	@mkdir -p $(META_DIR)
	@cp $(OUT_DIR)/$(DOCUMENT).ctr $(META_DIR)/$(DOCUMENT).ctr.$(HOST_ID)
	@echo "%% host name: $(HOST_NAME)" >> $(META_DIR)/$(DOCUMENT).ctr.$(HOST_ID)

index:
	@makeindex -o $(OUT_DIR)/$(DOCUMENT).ind $(OUT_DIR)/$(DOCUMENT).idx

# Compile document without output.
simple: tikzcache
	@pdflatex -shell-escape -interaction=$(INTERACTION) -output-directory=$(OUT_DIR) $(DOCUMENT)

# Compile document with console output.
debug: tikzcache
	@pdflatex -shell-escape -output-directory=$(OUT_DIR) $(DOCUMENT)

# Run bibtex. This requires the auxiliary file to exist, so
# either the simple or debug targets to have been run before,
# but if those targets are added as prerequisites, they are
# run each time, which is stupid. Hence, they are left out
# and the onus is put on the user.
bib:
	@bibtex $(OUT_DIR)/$(DOCUMENT).aux

# Make  a  snapshot of  the  current  pdf. Due to  the  tikz
# externalize library  stuff, we  set this  to automatically
# depend on the 'simple' or 'debug' target; instead you must
# ensure that the pdf exists manually.
.PHONY: snapshot
snapshot:
	@cp $(OUT_DIR)/$(DOCUMENT).pdf snapshots/$(DOCUMENT)--$(TIMESTAMP).pdf

# Collect  all necessary TeX  and project files  and archive
# them. See README.md .
bundle:
	@cat $(OUT_DIR)/$(DOCUMENT).dep | grep -v $(DOCUMENT) > $(OUT_DIR)/$(DOCUMENT).dep.2
	@mv $(OUT_DIR)/$(DOCUMENT).dep.2 $(OUT_DIR)/$(DOCUMENT).dep
	@bundledoc --texfile=$(DOCUMENT).tex --config=$(BUNDLE_CFG) ./$(OUT_DIR)/$(DOCUMENT).dep
	@tar -C $(META_DIR) -xf $(OUT_DIR)/$(DOCUMENT).tar
	@rm $(OUT_DIR)/$(DOCUMENT).tar
	@cp -r $(CODE_DIR) $(META_DIR)/$(DOCUMENT)
	@cp Makefile $(META_DIR)/$(DOCUMENT)
	@tar -C $(META_DIR) -cf - $(DOCUMENT) | xz --best > $(META_DIR)/$(DOCUMENT)--$(TIMESTAMP).tar.xz 
	@rm -r $(META_DIR)/$(DOCUMENT)

# Tidy up, but don't clean out cached files and pdf documents.
tidy:
	@rm -f $(TIKZ_DIR)
	@rm -f $(OUT_DIR)/$(CODE_DIR)
	@rm -f $(OUT_DIR)/$(DOCUMENT).tex
	@rm -rf $(OUT_DIR)/alpenthesis
	@rm -f $(OUT_DIR)/$(DOCUMENT).aux
	@rm -f $(OUT_DIR)/$(DOCUMENT).figlist
	@rm -f $(OUT_DIR)/$(DOCUMENT).lof
	@rm -f $(OUT_DIR)/$(DOCUMENT).log
	@rm -f $(OUT_DIR)/$(DOCUMENT).lol
	@rm -f $(OUT_DIR)/$(DOCUMENT).lot
	@rm -f $(OUT_DIR)/$(DOCUMENT).makefile
	@rm -f $(OUT_DIR)/$(DOCUMENT).mw
	@rm -f $(OUT_DIR)/$(DOCUMENT).out
	@rm -f $(OUT_DIR)/$(DOCUMENT).toc
	@rm -f $(OUT_DIR)/$(DOCUMENT).ind
	@rm -f $(OUT_DIR)/$(DOCUMENT).ilg
	@rm -f $(OUT_DIR)/$(DOCUMENT).idx
	@rm -f $(OUT_DIR)/$(DOCUMENT).dep

# Clean out all the files and symlinks.
clean:
	@mv $(OUT_DIR)/$(DOCUMENT).ctr ./
	@rm -rf $(OUT_DIR)/*
	@mv $(DOCUMENT).ctr $(OUT_DIR)/
	@rm -f $(TIKZ_DIR)
	@rm -f $(OUT_DIR)/$(DOCUMENT).tex
