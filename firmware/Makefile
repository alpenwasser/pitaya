# ---------------------------------------------------------------------------- #
# Master Makefile for firmware
#
# Makefile for firmware/
# Location:    firmware/Makefile
# 
# Authors: Raphael Frey <rmfrey@alpenwasser.net>
#
# Date:   2017-05-21
# 
# Call Structure
# . this file
# |
# +---+ FPGA_DIR
# |   |
# |   +---- FPGA_MF       # builds cores and logger
# |   |
# |   +---+ LOGGER_DIR
# |       |
# |       +---- LOGGER_MF # builds kernel module and test
# |
# +---+ ARM_DIR
#     |
#     +---- ARM_MF        # builds linux
#     |
#     +---+ SERVER_DIR
#         |
#         +---- SERVER_MF # builds server
#  
#  
#
# Called by: user
#
# Working Directory: firmware/
# ---------------------------------------------------------------------------- #

ARM_DIR     = arm
FPGA_DIR    = fpga
SERVER_DIR := $(ARM_DIR)/server
LOGGER_DIR := $(FPGA_DIR)/zynq_logger

VIVADO_VER  = 2016.4

.DEFAULT: init

init: cores linux kernel_module kernel_module_test server

cores:
	make -C $(FPGA_DIR) all-cores
	make -C $(FPGA_DIR) zynq_logger

linux:
	make -C $(ARM_DIR) VIVADO_VER=$(VIVADO_VER) boot.bin
	make -C $(ARM_DIR) VIVADO_VER=$(VIVADO_VER) uImage
	make -C $(ARM_DIR) VIVADO_VER=$(VIVADO_VER) devicetree.dtb
	make -C $(ARM_DIR) VIVADO_VER=$(VIVADO_VER) fw_printenv

kernel_module:
	make -C $(LOGGER_DIR) VIVADO_VER=$(VIVADO_VER) kernel_module

kernel_module_test:
	make -C $(LOGGER_DIR) kernel_module_test

server:
	make -C $(SERVER_DIR) all

project: cores
	make -C $(FPGA_DIR) project

clean:
	make -C $(ARM_DIR) clean
	make -C $(FPGA_DIR) clean
	make -C $(SERVER_DIR) clean
