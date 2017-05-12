BUILD = build

OSSL_URL = https://www.openssl.org/source/openssl-1.1.0e.tar.gz
OSSL_TAR = openssl-1.1.0e.tar.gz
OSSL_DIR = openssl-1.1.0e

UWS_URL = https://github.com/uWebSockets/uWebSockets.git
UWS_DIR = uWebSockets

all: openssl uws

uws: $(BUILD)
	git clone $(UWS_URL)
	make -C $(UWS_DIR) -f ../Makefile.uWS.arm

openssl: $(BUILD)
	if [ -f $(OSSL_TAR) ] || wget $(OSSL_URL)
	if [ -f $(OSSL_DIR) ] || tar xvf $(OSSL_TAR)

	export cross=arm-linux-gnueabihf-
	export BUILDMACH=i686-pc-linux-gnu
	export TARGETMACH=arm-none-linux-gnueabi
	cd $(UWS_DIR) && ./Configure dist shared --prefix=${pwd}/$(BUILD)/openssl
	make -C $(OSSL_DIR) clean
	make -C $(OSSL_DIR) CC="${cross}gcc" AR="${cross}ar r" RANLIB="${cross}ranlib" -j4
	make -C $(OSSL_DIR) install

$(BUILD):
	mkdir -p $(BUILD)
