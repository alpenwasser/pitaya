# ---------------------------------------------------------------------------- #
# Master Makefile for building the server.
#
# Makefile for firmware/arm/server
# Location:    firmware/arm/server/Makefile
# 
# Authors: Noah Huesser <yatekii@yatekii.ch>
#          Raphael Frey <rmfrey@alpenwasser.net>
#
# Date:   2017-05-20
# 
# Call Structure
# . this file
# |
# +---+ EXT_DIR
# |   |
# |   +---- EXT_MF     # builds external libraries          (default)
# |
# +---- ARM_MF         # builds the server itself for ARM   (default)
# |
# +---- OSX_MF         # builds the server itself for macOS (optional)
#
# Called by: user
#
# Working Directory: firmware/arm/server
# ---------------------------------------------------------------------------- #
EXT_DIR := $(shell pwd)/external
EXT_MF  := Makefile#     ./external/Makefile
ARM_MF  := Makefile.arm#./Makefile.arm
OSX_MF  := Makefile.osx#./Makefile.osx

# NOTE:
# firmware/arm/server/external/Makefile and
# firmware/arm/server/Makefile.arm have default values set in case they are
# not called from this file. In the interest of everyone's sanity, make sure
# that those values and the ones here are the same.
# These values will override the values in the called Makefiles.
OSSL_VER := 1.1.0e
ZL_VER   := 1.2.11
MF_ARGS  := OSSL_VER=$(OSSL_VER) ZL_VER=$(ZL_VER)

all: external arm

# External libraries
.PHONY: external
external:
	make -C $(EXT_DIR) -f $(EXT_MF) $(MF_ARGS) all

# The server itself, for ARM
arm:
	make -f $(ARM_MF) $(MF_ARGS) all

# The server itself, for macOS
osx:
	make -f $(OSX_MF) all

clean:
	make -f Makefile.osx clean
	make -C $(EXT_DIR) clean
