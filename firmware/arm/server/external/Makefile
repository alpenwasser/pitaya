# ---------------------------------------------------------------------------- #
# Master Makefile for building external libraries for server.
#
# Makefile for firmware/arm/server/external
# Location:    firmware/arm/server/external/Makefile
# 
# Author: Raphael Frey <rmfrey@alpenwasser.net>
#
# Date:   2017-05-20
# 
# Call Structure
# . this file
# |
# +---+ OSSL_DIR (OpenSSL)
# |   |
# |   +---- Configure
# |   +---- Makefile
# |
# +---+ ZL_DIR (zlib)
# |   |
# |   +---- configure
# |   +---- Makefile
# |
# +---+ UWS_Makefile (not in UWS_DIR!)
#
# Called by: firmware/arm/server/Makefile
#
# Working Directory: firmware/arm/server/external
# ---------------------------------------------------------------------------- #
CORES     := $(shell nproc 2>/dev/null || echo 1)
PWD       := $(shell pwd)
CROSS=arm-linux-gnueabihf-
BUILD_DIR := build


# NOTE: 
# Versions should be set in firmware/server/Makefile, and the values set
# there will override these values. In case this Makefile is called by
# itself, we provide default values.
OSSL_VER  ?= 1.1.0e
ZL_VER    ?= 1.2.11
OSSL_DIR  := openssl-$(OSSL_VER)
ZL_DIR    := zlib-$(ZL_VER)
UWS_DIR   := uWebSockets# No version required; git clone


OSSL_URL   := https://www.openssl.org/source/openssl-$(OSSL_VER).tar.gz
OSSL_TAR   := openssl-$(OSSL_VER).tar.gz
OSSL_DIR   := openssl-$(OSSL_VER)
OSSL_CONF  := BUILDMACH=i686-pc-linux-gnu TARGETMACH=arm-none-linux-gnueabi \
              ./Configure dist shared --prefix=$(PWD)/$(BUILD_DIR)/openssl
OSSL_FLAGS := $(OSSL_DIR) CC="$(CROSS)gcc" AR="$(CROSS)ar r" \
              RANLIB="$(CROSS)ranlib" -j$(CORES)


ZL_URL     := http://zlib.net/zlib-$(ZL_VER).tar.gz
ZL_TAR     := zlib-$(ZL_VER).tar.gz
ZL_DIR     := zlib-$(ZL_VER)
ZL_CONF    := CC=$(CROSS)gcc LD=$(CROSS)ld AS=$(CROSS)as ./configure \
              --prefix=$(PWD)/$(BUILD_DIR)/zlib


UV_URL     := https://github.com/libuv/libuv
UV_DIR     := libuv
UV_CONF    := ./configure --build=i686-pc-linux-gnu --host=arm-linux-gnueabihf --prefix $(pwd)/../build/uv


UWS_URL    := https://github.com/uWebSockets/uWebSockets.git
UWS_DIR    := uWebSockets
UWS_MF     := $(PWD)/Makefile.uWS.arm


all: openssl zlib uws

openssl: $(BUILD_DIR)
	[ -f $(OSSL_TAR) ] || wget $(OSSL_URL)
	[ -d $(OSSL_DIR) ] || tar xf $(OSSL_TAR)

	cd $(OSSL_DIR) && $(OSSL_CONF)
	make -C $(OSSL_FLAGS)
	make -C $(OSSL_DIR) install

zlib: $(BUILD_DIR)
	[ -f $(ZL_TAR) ] || wget $(ZL_URL)
	[ -d $(ZL_DIR) ] || tar xf $(ZL_TAR)

	cd $(ZL_DIR) && $(ZL_CONF)
	make -C $(ZL_DIR)
	make -C $(ZL_DIR) install

uv: $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/uv
	# TODO

uws: $(BUILD_DIR)
	[ -d $(UWS_DIR) ] || git clone $(UWS_URL)
	make -C $(UWS_DIR) -f $(UWS_MF)
	make -C $(UWS_DIR) -f $(UWS_MF) install

clean:
	make -C $(OSSL_DIR) clean
	make -C $(ZL_DIR) clean
	make -C $(UWS_DIR) -f $(UWS_MF) clean
	rm -rf $(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
