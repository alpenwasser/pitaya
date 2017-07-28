# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_AXIS_NUM_SI_SLOTS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXIS_TDATA_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_AXIS_NUM_SI_SLOTS { PARAM_VALUE.C_AXIS_NUM_SI_SLOTS } {
	# Procedure called to update C_AXIS_NUM_SI_SLOTS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXIS_NUM_SI_SLOTS { PARAM_VALUE.C_AXIS_NUM_SI_SLOTS } {
	# Procedure called to validate C_AXIS_NUM_SI_SLOTS
	return true
}

proc update_PARAM_VALUE.C_AXIS_TDATA_WIDTH { PARAM_VALUE.C_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXIS_TDATA_WIDTH { PARAM_VALUE.C_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_AXIS_TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_AXIS_TDATA_WIDTH PARAM_VALUE.C_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXIS_NUM_SI_SLOTS { MODELPARAM_VALUE.C_AXIS_NUM_SI_SLOTS PARAM_VALUE.C_AXIS_NUM_SI_SLOTS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXIS_NUM_SI_SLOTS}] ${MODELPARAM_VALUE.C_AXIS_NUM_SI_SLOTS}
}

