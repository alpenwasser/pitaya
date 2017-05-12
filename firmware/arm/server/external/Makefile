BUILD = build

OSSL_URL = https://www.openssl.org/source/openssl-1.1.0e.tar.gz
OSSL_TAR = openssl-1.1.0e.tar.gz
OSSL_DIR = openssl-1.1.0e

UWS_URL = https://github.com/uWebSockets/uWebSockets.git
UWS_DIR = uWebSockets

ZLIB_URL = http://zlib.net/zlib-1.2.11.tar.gz
ZLIB_TAR = zlib-1.2.11.tar.gz
ZLIB_DIR = zlib-1.2.11

all: openssl uws

uws: $(BUILD)
	[ -d $(UWS_DIR) ] || git clone $(UWS_URL)
	make -C $(UWS_DIR) -f ../Makefile.uWS.arm

openssl: $(BUILD)
	[ -f $(OSSL_TAR) ] || wget $(OSSL_URL)
	[ -d $(OSSL_DIR) ] || tar xf $(OSSL_TAR)

	export cross=arm-linux-gnueabihf-
	export BUILDMACH=i686-pc-linux-gnu
	export TARGETMACH=arm-none-linux-gnueabi
	cd $(OSSL_DIR) && ./Configure dist shared --prefix=$(shell pwd)/$(BUILD)/openssl
	make -C $(OSSL_DIR) clean
	make -C $(OSSL_DIR) CC="${cross}gcc" AR="${cross}ar r" RANLIB="${cross}ranlib" -j4
	make -C $(OSSL_DIR) install

zlib: $(BUILD)
	[ -f $(OSSL_TAR) ] || wget $(ZLIB_URL)
	[ -d $(ZLIB_DIR) ] || tar xf $(ZLIB_TAR)

	cd $(ZLIB_DIR)
	export INSTALLDIR=/vagrant/Xilinx/SDK/2016.2/gnu/aarch32/lin/gcc-arm-linux-gnueabi
	export CROSS=arm-linux-gnueabihf
	export CC=${CROSS}-gcc
	export LD=${CROSS}-ld
	export AS=${CROSS}-as
	cd $(ZLIB_DIR) && ./configure --prefix=/vagrant/Xilinx/SDK/2016.2/gnu/aarch32/lin/gcc-arm-linux-gnueabi
	make -C $(ZLIB_DIR)
	make -C $(ZLIB_DIR) install

$(BUILD):
	mkdir -p $(BUILD)
