EXT_DIR  = $(shell pwd)/external
OSSL_DIR = $(EXT_DIR)/openssl-1.1.0e
UWS_DIR  = $(EXT_DIR)/uWebSockets
ZL_DIR   = $(EXT_DIR)/zlib-1.2.11

all: external arm

.PHONY: external
external:
	make -C external

arm:
	make -f Makefile.arm all

osx:
	make -f Makefile.osx all

clean:
	make -f Makefile.osx clean
	make -C $(EXT_DIR) clean
