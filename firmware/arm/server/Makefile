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
