# 'make' builds everything
# 'make clean' deletes everything except source files and Makefile
#
# You need to set NAME, PART and PROC for your project.
# NAME is the base name for most of the generated files.

# solves problem with awk while building linux kernel
# solution taken from http://www.googoolia.com/wp/2015/04/21/awk-symbol-lookup-error-awk-undefined-symbol-mpfr_z_sub/
LD_LIBRARY_PATH =

NAME        = src
PART        = xc7z010clg400-1
PROC        = ps7_cortexa9_0
BUILD_DIR   = build
FPGA_DIR    = ../fpga
FPGA_BUILD := $(FPGA_DIR)/build/src
LOGGER_DIR := $(FPGA_DIR)/zynq_logger

VIVADO = vivado -nolog -nojournal -mode batch
HSI    = hsi -nolog -nojournal -mode batch
RM     = rm -rf

VIVADO_VER  = 2016.4
UBOOT_TAG  := xilinx-v$(VIVADO_VER)
LINUX_TAG  := xilinx-v$(VIVADO_VER)
DTREE_TAG  := xilinx-v$(VIVADO_VER)

UBOOT_DIR := $(BUILD_DIR)/u-boot-xlnx-$(UBOOT_TAG)
LINUX_DIR := $(BUILD_DIR)/linux-xlnx-$(LINUX_TAG)
DTREE_DIR := $(BUILD_DIR)/device-tree-xlnx-$(DTREE_TAG)

UBOOT_TAR := $(BUILD_DIR)/u-boot-xlnx-$(UBOOT_TAG).tar.gz
LINUX_TAR := $(BUILD_DIR)/linux-xlnx-$(LINUX_TAG).tar.gz
DTREE_TAR := $(BUILD_DIR)/device-tree-xlnx-$(DTREE_TAG).tar.gz

UBOOT_URL := https://github.com/Xilinx/u-boot-xlnx/archive/$(UBOOT_TAG).tar.gz
LINUX_URL := https://github.com/Xilinx/linux-xlnx/archive/$(LINUX_TAG).tar.gz
DTREE_URL := https://github.com/Xilinx/device-tree-xlnx/archive/$(DTREE_TAG).tar.gz

LINUX_CFLAGS = "-O2 -march=armv7-a -mcpu=cortex-a9 -mtune=cortex-a9 -mfpu=neon -mfloat-abi=hard"
UBOOT_CFLAGS = "-O2 -march=armv7-a -mcpu=cortex-a9 -mtune=cortex-a9 -mfpu=neon -mfloat-abi=hard"
ARMHF_CFLAGS = "-O2 -march=armv7-a -mcpu=cortex-a9 -mtune=cortex-a9 -mfpu=neon -mfloat-abi=hard"

RTL_TAR := $(BUILD_DIR)/rtl8192cu.tgz
RTL_URL  = https://www.dropbox.com/sh/5fy49wae6xwxa8a/AABNwuLz3dPHK06vEDHmG8mfa/rtl8192cu/rtl8192cu.tgz?dl=1

.PRECIOUS: $(BUILD_DIR)/cores/% $(BUILD_DIR)/%.xpr $(BUILD_DIR)/%.hwdef $(BUILD_DIR)/%.bit $(BUILD_DIR)/%.fsbl/executable.elf $(BUILD_DIR)/%.tree/system.dts

all: boot.bin uImage devicetree.dtb fw_printenv

$(UBOOT_TAR):
	mkdir -p $(@D)
	curl -L $(UBOOT_URL) -o $@

$(LINUX_TAR):
	mkdir -p $(@D)
	curl -L $(LINUX_URL) -o $@

$(DTREE_TAR):
	mkdir -p $(@D)
	curl -L $(DTREE_URL) -o $@

$(RTL_TAR):
	mkdir -p $(@D)
	curl -L $(RTL_URL) -o $@

$(UBOOT_DIR): $(UBOOT_TAR)
	mkdir -p $@
	tar -zxf $< --strip-components=1 --directory=$@
	patch -d $(BUILD_DIR) -p 0 < patches/u-boot-xlnx-$(UBOOT_TAG).patch
	cp patches/zynq_red_pitaya_defconfig $@/configs
	cp patches/zynq-red-pitaya.dts $@/arch/arm/dts
	cp patches/zynq_red_pitaya.h $@/include/configs
	cp patches/u-boot-lantiq.c $@/drivers/net/phy/lantiq.c

$(LINUX_DIR): $(LINUX_TAR) $(RTL_TAR)
	mkdir -p $@
	tar -zxf $< --strip-components=1 --directory=$@
	tar -zxf $(RTL_TAR) --directory=$@/drivers/net/wireless/realtek
	patch -d $(BUILD_DIR) -p 0 < patches/linux-xlnx-$(LINUX_TAG).patch
	cp patches/linux-lantiq.c $@/drivers/net/phy/lantiq.c

$(DTREE_DIR): $(DTREE_TAR)
	mkdir -p $@
	tar -zxf $< --strip-components=1 --directory=$@

uImage: $(LINUX_DIR)
	make -C $< mrproper
	make -C $< ARCH=arm xilinx_zynq_defconfig
	make -C $< ARCH=arm CFLAGS=$(LINUX_CFLAGS) \
	  -j $(shell nproc 2> /dev/null || echo 1) \
	  CROSS_COMPILE=arm-linux-gnueabihf- UIMAGE_LOADADDR=0x8000 uImage
	cp $</arch/arm/boot/uImage $@

u-boot: $(UBOOT_DIR)
	mkdir -p $(BUILD_DIR)
	make -C $< mrproper
	make -C $< ARCH=arm zynq_red_pitaya_defconfig
	make -C $< ARCH=arm CFLAGS=$(UBOOT_CFLAGS) \
	  CROSS_COMPILE=arm-linux-gnueabihf- all
	cp $</u-boot $(BUILD_DIR)/u-boot.elf

fw_printenv:
	make -C $(UBOOT_DIR) ARCH=arm CFLAGS=$(ARMHF_CFLAGS) \
	  CROSS_COMPILE=arm-linux-gnueabihf- env
	cp $(UBOOT_DIR)/tools/env/fw_printenv $@

boot.bin: fsbl bitstream u-boot
	echo "img:{[bootloader] $(FPGA_BUILD)/$(NAME).fsbl/executable.elf $(FPGA_BUILD)/$(NAME).bit $(BUILD_DIR)/u-boot.elf}" > $(BUILD_DIR)/boot.bif
	bootgen -image $(BUILD_DIR)/boot.bif -w -o i $@

devicetree.dtb: devicetree
	$(LINUX_DIR)/scripts/dtc/dtc -I dts -O dtb -o devicetree.dtb \
	  -i $(FPGA_BUILD)/$(NAME).tree $(FPGA_BUILD)/$(NAME).tree/system.dts

cores:
	make -C $(FPGA_DIR) all-cores
	make -C $(FPGA_DIR) zynq_logger

project: 
	make -C $(FPGA_DIR) project

hwdef: project
	mkdir -p $(BUILD_DIR)
	$(VIVADO) -source scripts/hwdef.tcl -tclargs $(FPGA_BUILD) $(NAME)

bitstream:
	mkdir -p $(BUILD_DIR)
	$(VIVADO) -source scripts/bitstream.tcl -tclargs $(FPGA_BUILD) $(NAME)

fsbl: hwdef
	mkdir -p $(BUILD_DIR)/$(NAME).fsbl
	$(HSI) -source scripts/fsbl.tcl -tclargs $(FPGA_BUILD) $(NAME) $(PROC)

devicetree: $(DTREE_DIR)
	mkdir -p $(BUILD_DIR)/$(NAME).dts
	$(HSI) -source scripts/devicetree.tcl -tclargs $(FPGA_BUILD) $(NAME) $(PROC) $(DTREE_DIR)
	patch -d .. fpga/build/src/$(NAME).tree/system.dts arm/patches/devicetree.patch
	patch -d .. fpga/build/src/$(NAME).tree/system.dts arm/patches/logger.patch

kernel_module:
	make -C $(LOGGER_DIR) VIVADO_VER=$(VIVADO_VER) kernel_module

kernel_module_test:
	make -C $(LOGGER_DIR) kernel_module_test

clean:
	$(RM) uImage fw_printenv boot.bin devicetree.dtb $(BUILD_DIR)
	$(RM) .Xil usage_statistics_webtalk.html usage_statistics_webtalk.xml
	$(RM) vivado*.jou vivado*.log
	$(RM) webtalk*.jou webtalk*.log
	make -C $(LOGGER_DIR) clean
	make -C $(FPGA_DIR) clean
