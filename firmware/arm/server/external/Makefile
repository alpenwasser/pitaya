BUILD = build

CORES = 6

OSSL_URL = https://www.openssl.org/source/openssl-1.1.0e.tar.gz
OSSL_TAR = openssl-1.1.0e.tar.gz
OSSL_DIR = openssl-1.1.0e

UWS_URL = https://github.com/uWebSockets/uWebSockets.git
UWS_DIR = uWebSockets

ZLIB_URL = http://zlib.net/zlib-1.2.11.tar.gz
ZLIB_TAR = zlib-1.2.11.tar.gz
ZLIB_DIR = zlib-1.2.11

CROSS=arm-linux-gnueabihf-

uWSMF = ../Makefile.uWS.arm

all: openssl zlib uws

uws: $(BUILD)
	[ -d $(UWS_DIR) ] || git clone $(UWS_URL)
	make -C $(UWS_DIR) -f $(uWSMF)
	make -C $(UWS_DIR) -f $(uWSMF) install

openssl: $(BUILD)
	[ -f $(OSSL_TAR) ] || wget $(OSSL_URL)
	[ -d $(OSSL_DIR) ] || tar xf $(OSSL_TAR)

	cd $(OSSL_DIR) && BUILDMACH=i686-pc-linux-gnu TARGETMACH=arm-none-linux-gnueabi ./Configure dist shared --prefix=$(shell pwd)/$(BUILD)/openssl
	make -C $(OSSL_DIR) CC="$(CROSS)gcc" AR="$(CROSS)ar r" RANLIB="$(CROSS)ranlib" -j$(CORES)
	make -C $(OSSL_DIR) install

zlib: $(BUILD)
	[ -f $(ZLIB_TAR) ] || wget $(ZLIB_URL)
	[ -d $(ZLIB_DIR) ] || tar xf $(ZLIB_TAR)

	cd $(ZLIB_DIR) && CC=$(CROSS)gcc LD=$(CROSS)ld AS=$(CROSS)as ./configure --prefix=$(shell pwd)/$(BUILD)/zlib
	make -C $(ZLIB_DIR)
	make -C $(ZLIB_DIR) install

$(BUILD):
	mkdir -p $(BUILD)

clean:
	make -C $(OSSL_DIR) clean
	make -C $(UWS_DIR) -f $(uWSMF) clean
	make -C $(ZLIB_DIR) clean
	rm -rf $(BUILD)
