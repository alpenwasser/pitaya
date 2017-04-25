# ==================================================================================================
# ports.tcl
#
# This script specifies pins to the Red Pitaya external hardware.
#
# by Noah Huesser <yatekii@yatekii.ch>
# based on Anton Potocnik, 02.10.2016 - 08.01.2017
# based on Pavel Demin's 'red-pitaya-notes-master' git repo
# ==================================================================================================

# ADC ports
create_bd_port -dir I -from 13 -to 0 adc_dat_a_i
create_bd_port -dir I -from 13 -to 0 adc_dat_b_i

create_bd_port -dir I adc_clk_p_i
create_bd_port -dir I adc_clk_n_i

create_bd_port -dir O adc_enc_p_o
create_bd_port -dir O adc_enc_n_o

create_bd_port -dir O adc_csn_o

# DAC ports
create_bd_port -dir O -from 13 -to 0 dac_dat_o

create_bd_port -dir O dac_clk_o
create_bd_port -dir O dac_rst_o
create_bd_port -dir O dac_sel_o
create_bd_port -dir O dac_wrt_o

# PWM ports
create_bd_port -dir O -from 3 -to 0 dac_pwm_o

# XADC ports
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux0
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux1
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux9
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux8

# Expansion connector ports
create_bd_port -dir IO -from 7 -to 0 exp_p_tri_io
create_bd_port -dir IO -from 7 -to 0 exp_n_tri_io

# SATA connector ports
# create_bd_port -dir O -from 1 -to 0 daisy_p_o
# create_bd_port -dir O -from 1 -to 0 daisy_n_o

# create_bd_port -dir I -from 1 -to 0 daisy_p_i
# create_bd_port -dir I -from 1 -to 0 daisy_n_i

# LED ports
create_bd_port -dir O -from 7 -to 0 led_o