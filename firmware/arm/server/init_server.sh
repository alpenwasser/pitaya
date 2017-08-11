#!/usr/bin/env bash

echo 3 > /proc/sys/kernel/printk
insmod /opt/logger/zynq_logger_main.ko
LD_LIBRARY_PATH=/opt/server/ /opt/server/server