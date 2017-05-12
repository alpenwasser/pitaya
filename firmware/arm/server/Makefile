TARGET = server
PREFIX = arm-linux-gnueabihf-
BUILD = build
SRCDIR = src
CFLAGS = -I/vagrant/Xilinx/SDK/2016.2/gnu/aarch32/lin/gcc-arm-linux-gnueabi/include -L/vagrant/Xilinx/SDK/2016.2/gnu/aarch32/lin/gcc-arm-linux-gnueabi/lib -Iexternal/uWebSockets/src/ -Lexternal/uWebSockets/ -Lexternal/openssl-1.1.0e/ -Iexternal/openssl-1.1.0e/include/ -std=c++11
#CFLAGS = -I/usr/local/opt/openssl/include -L/usr/local/opt/openssl/lib
#CFLAGS += -DINSTALL_DATADIR=\"$(shell pwd)\"
LFLAGS = -lm -luWS -lz -lpthread -lssl -lcrypto
# $(PREFIX)-
SRC = $(wildcard $(SRCDIR)/*.c)
OBJS = $(subst $(SRCDIR),$(BUILD),$(subst .c,.o,$(SRC)))

all: $(BUILD) $(TARGET)

flash:
	scp build/server rp:/opt/server

$(TARGET): $(OBJS)
	$(PREFIX)g++ $(CFLAGS) $(OBJS) $(LFLAGS) -o $(BUILD)/$(TARGET)

$(BUILD)/%.o: $(SRCDIR)/%.c
	$(PREFIX)g++ $(CFLAGS) -c $< -o $@

$(BUILD)/%.o: $(SRCDIR)/%.c $(SRCDIR)/%.h
	$(PREFIX)g++ $(CFLAGS) -c $< -o $@

$(BUILD):
	mkdir -p $(BUILD)

clean:
	rm -rf $(BUILD)