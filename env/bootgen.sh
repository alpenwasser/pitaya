cp ../firmware/fpga/build/p_chain5/p_chain5.runs/impl_1/system_wrapper.bit ./
bootgen -image boot.bif -w -o i boot.bin
echo "Generated bitstream; starting scp"
scp boot.bin root@10.84.130.54:/boot
