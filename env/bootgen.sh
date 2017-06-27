cp ../firmware/fpga/build/src/src.runs/impl_1/system_wrapper.bit ./
bootgen -image boot.bif -w -o i boot.bin
scp boot.bin root@10.84.130.54:/boot
