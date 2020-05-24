# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ACC_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FIFO_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MMU_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "VAR_SIZE" -parent ${Page_0}


}

proc update_PARAM_VALUE.ACC_SIZE { PARAM_VALUE.ACC_SIZE } {
	# Procedure called to update ACC_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACC_SIZE { PARAM_VALUE.ACC_SIZE } {
	# Procedure called to validate ACC_SIZE
	return true
}

proc update_PARAM_VALUE.FIFO_SIZE { PARAM_VALUE.FIFO_SIZE } {
	# Procedure called to update FIFO_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIFO_SIZE { PARAM_VALUE.FIFO_SIZE } {
	# Procedure called to validate FIFO_SIZE
	return true
}

proc update_PARAM_VALUE.MMU_SIZE { PARAM_VALUE.MMU_SIZE } {
	# Procedure called to update MMU_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMU_SIZE { PARAM_VALUE.MMU_SIZE } {
	# Procedure called to validate MMU_SIZE
	return true
}

proc update_PARAM_VALUE.VAR_SIZE { PARAM_VALUE.VAR_SIZE } {
	# Procedure called to update VAR_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VAR_SIZE { PARAM_VALUE.VAR_SIZE } {
	# Procedure called to validate VAR_SIZE
	return true
}


proc update_MODELPARAM_VALUE.VAR_SIZE { MODELPARAM_VALUE.VAR_SIZE PARAM_VALUE.VAR_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VAR_SIZE}] ${MODELPARAM_VALUE.VAR_SIZE}
}

proc update_MODELPARAM_VALUE.ACC_SIZE { MODELPARAM_VALUE.ACC_SIZE PARAM_VALUE.ACC_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACC_SIZE}] ${MODELPARAM_VALUE.ACC_SIZE}
}

proc update_MODELPARAM_VALUE.MMU_SIZE { MODELPARAM_VALUE.MMU_SIZE PARAM_VALUE.MMU_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMU_SIZE}] ${MODELPARAM_VALUE.MMU_SIZE}
}

proc update_MODELPARAM_VALUE.FIFO_SIZE { MODELPARAM_VALUE.FIFO_SIZE PARAM_VALUE.FIFO_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_SIZE}] ${MODELPARAM_VALUE.FIFO_SIZE}
}

