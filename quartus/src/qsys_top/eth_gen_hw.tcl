# TCL File Generated by Component Editor 17.1
# Mon Aug 28 10:31:00 MYT 2017
# DO NOT MODIFY


# 
# eth_gen "eth_gen" v1.0
#  2017.08.28.10:31:00
# eth gen
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module eth_gen
# 
set_module_property DESCRIPTION "eth gen"
set_module_property NAME eth_gen
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "User Logic"
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME eth_gen
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL eth_gen
set_fileset_property quartus_synth ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property quartus_synth ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_gen.v VERILOG PATH ../eth_gen.v TOP_LEVEL_FILE
add_fileset_file crcgen_dat32.v VERILOG PATH ../crcgen_dat32.v
add_fileset_file prbs23.v VERILOG PATH ../prbs23.v
add_fileset_file shiftreg_ctrl.v VERILOG PATH ../shiftreg_ctrl.v
add_fileset_file shiftreg_data.v VERILOG PATH ../shiftreg_data.v
add_fileset_file crc32_gen.v VERILOG PATH ../crc32/crc32_gen.v
add_fileset_file crc32_chk.v VERILOG PATH ../crc32/crc32_chk.v
add_fileset_file crc32_calculator.v VERILOG PATH ../crc32/crc32_calculator.v
add_fileset_file crc32.sdc SDC PATH ../crc32/crc32.sdc
add_fileset_file avalon_st_to_crc_if_bridge.v VERILOG PATH ../crc32/avalon_st_to_crc_if_bridge.v
add_fileset_file bit_endian_converter.v VERILOG PATH ../crc32/bit_endian_converter.v
add_fileset_file byte_endian_converter.v VERILOG PATH ../crc32/byte_endian_converter.v
add_fileset_file crc_checksum_aligner.v VERILOG PATH ../crc32/crc_checksum_aligner.v
add_fileset_file crc_comparator.v VERILOG PATH ../crc32/crc_comparator.v
add_fileset_file crc_ethernet.v VERILOG PATH ../crc32/crc32_lib/crc_ethernet.v
add_fileset_file crc_register.v VERILOG PATH ../crc32/crc32_lib/crc_register.v
add_fileset_file crc32_dat8.v VERILOG PATH ../crc32/crc32_lib/crc32_dat8.v
add_fileset_file crc32_dat16.v VERILOG PATH ../crc32/crc32_lib/crc32_dat16.v
add_fileset_file crc32_dat24.v VERILOG PATH ../crc32/crc32_lib/crc32_dat24.v
add_fileset_file crc32_dat32.v VERILOG PATH ../crc32/crc32_lib/crc32_dat32.v
add_fileset_file crc32_dat32_any_byte.v VERILOG PATH ../crc32/crc32_lib/crc32_dat32_any_byte.v
add_fileset_file crc32_dat40.v VERILOG PATH ../crc32/crc32_lib/crc32_dat40.v
add_fileset_file crc32_dat48.v VERILOG PATH ../crc32/crc32_lib/crc32_dat48.v
add_fileset_file crc32_dat56.v VERILOG PATH ../crc32/crc32_lib/crc32_dat56.v
add_fileset_file crc32_dat64.v VERILOG PATH ../crc32/crc32_lib/crc32_dat64.v
add_fileset_file crc32_dat64_any_byte.v VERILOG PATH ../crc32/crc32_lib/crc32_dat64_any_byte.v
add_fileset_file xor6.v VERILOG PATH ../crc32/crc32_lib/xor6.v

add_fileset sim_verilog SIM_VERILOG "" "Verilog Simulation"
set_fileset_property sim_verilog ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property sim_verilog ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_gen.v VERILOG PATH ../eth_gen.v
add_fileset_file crcgen_dat32.v VERILOG PATH ../crcgen_dat32.v
add_fileset_file prbs23.v VERILOG PATH ../prbs23.v
add_fileset_file shiftreg_ctrl.v VERILOG PATH ../shiftreg_ctrl.v
add_fileset_file shiftreg_data.v VERILOG PATH ../shiftreg_data.v
add_fileset_file crc32_gen.v VERILOG PATH ../crc32/crc32_gen.v
add_fileset_file crc32_chk.v VERILOG PATH ../crc32/crc32_chk.v
add_fileset_file crc32_calculator.v VERILOG PATH ../crc32/crc32_calculator.v
add_fileset_file crc32.sdc SDC PATH ../crc32/crc32.sdc
add_fileset_file avalon_st_to_crc_if_bridge.v VERILOG PATH ../crc32/avalon_st_to_crc_if_bridge.v
add_fileset_file bit_endian_converter.v VERILOG PATH ../crc32/bit_endian_converter.v
add_fileset_file byte_endian_converter.v VERILOG PATH ../crc32/byte_endian_converter.v
add_fileset_file crc_checksum_aligner.v VERILOG PATH ../crc32/crc_checksum_aligner.v
add_fileset_file crc_comparator.v VERILOG PATH ../crc32/crc_comparator.v
add_fileset_file crc_ethernet.v VERILOG PATH ../crc32/crc32_lib/crc_ethernet.v
add_fileset_file crc_register.v VERILOG PATH ../crc32/crc32_lib/crc_register.v
add_fileset_file crc32_dat8.v VERILOG PATH ../crc32/crc32_lib/crc32_dat8.v
add_fileset_file crc32_dat16.v VERILOG PATH ../crc32/crc32_lib/crc32_dat16.v
add_fileset_file crc32_dat24.v VERILOG PATH ../crc32/crc32_lib/crc32_dat24.v
add_fileset_file crc32_dat32.v VERILOG PATH ../crc32/crc32_lib/crc32_dat32.v
add_fileset_file crc32_dat32_any_byte.v VERILOG PATH ../crc32/crc32_lib/crc32_dat32_any_byte.v
add_fileset_file crc32_dat40.v VERILOG PATH ../crc32/crc32_lib/crc32_dat40.v
add_fileset_file crc32_dat48.v VERILOG PATH ../crc32/crc32_lib/crc32_dat48.v
add_fileset_file crc32_dat56.v VERILOG PATH ../crc32/crc32_lib/crc32_dat56.v
add_fileset_file crc32_dat64.v VERILOG PATH ../crc32/crc32_lib/crc32_dat64.v
add_fileset_file crc32_dat64_any_byte.v VERILOG PATH ../crc32/crc32_lib/crc32_dat64_any_byte.v
add_fileset_file xor6.v VERILOG PATH ../crc32/crc32_lib/xor6.v


# 
# parameters
# 
add_parameter state_idle INTEGER 0
set_parameter_property state_idle DEFAULT_VALUE 0
set_parameter_property state_idle DISPLAY_NAME state_idle
set_parameter_property state_idle TYPE INTEGER
set_parameter_property state_idle UNITS None
set_parameter_property state_idle ALLOWED_RANGES -2147483648:2147483647
set_parameter_property state_idle AFFECTS_GENERATION false
set_parameter_property state_idle HDL_PARAMETER true
add_parameter state_dest INTEGER 1
set_parameter_property state_dest DEFAULT_VALUE 1
set_parameter_property state_dest DISPLAY_NAME state_dest
set_parameter_property state_dest TYPE INTEGER
set_parameter_property state_dest UNITS None
set_parameter_property state_dest ALLOWED_RANGES -2147483648:2147483647
set_parameter_property state_dest AFFECTS_GENERATION false
set_parameter_property state_dest HDL_PARAMETER true
add_parameter state_dest_src INTEGER 2
set_parameter_property state_dest_src DEFAULT_VALUE 2
set_parameter_property state_dest_src DISPLAY_NAME state_dest_src
set_parameter_property state_dest_src TYPE INTEGER
set_parameter_property state_dest_src UNITS None
set_parameter_property state_dest_src ALLOWED_RANGES -2147483648:2147483647
set_parameter_property state_dest_src AFFECTS_GENERATION false
set_parameter_property state_dest_src HDL_PARAMETER true
add_parameter state_src INTEGER 3
set_parameter_property state_src DEFAULT_VALUE 3
set_parameter_property state_src DISPLAY_NAME state_src
set_parameter_property state_src TYPE INTEGER
set_parameter_property state_src UNITS None
set_parameter_property state_src ALLOWED_RANGES -2147483648:2147483647
set_parameter_property state_src AFFECTS_GENERATION false
set_parameter_property state_src HDL_PARAMETER true
add_parameter state_len_seq INTEGER 4
set_parameter_property state_len_seq DEFAULT_VALUE 4
set_parameter_property state_len_seq DISPLAY_NAME state_len_seq
set_parameter_property state_len_seq TYPE INTEGER
set_parameter_property state_len_seq UNITS None
set_parameter_property state_len_seq ALLOWED_RANGES -2147483648:2147483647
set_parameter_property state_len_seq AFFECTS_GENERATION false
set_parameter_property state_len_seq HDL_PARAMETER true
add_parameter state_data INTEGER 5
set_parameter_property state_data DEFAULT_VALUE 5
set_parameter_property state_data DISPLAY_NAME state_data
set_parameter_property state_data TYPE INTEGER
set_parameter_property state_data UNITS None
set_parameter_property state_data ALLOWED_RANGES -2147483648:2147483647
set_parameter_property state_data AFFECTS_GENERATION false
set_parameter_property state_data HDL_PARAMETER true
add_parameter state_transition INTEGER 6
set_parameter_property state_transition DEFAULT_VALUE 6
set_parameter_property state_transition DISPLAY_NAME state_transition
set_parameter_property state_transition TYPE INTEGER
set_parameter_property state_transition UNITS None
set_parameter_property state_transition ALLOWED_RANGES -2147483648:2147483647
set_parameter_property state_transition AFFECTS_GENERATION false
set_parameter_property state_transition HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock_reset
# 
add_interface clock_reset clock end
set_interface_property clock_reset clockRate 0
set_interface_property clock_reset ENABLED true
set_interface_property clock_reset EXPORT_OF ""
set_interface_property clock_reset PORT_NAME_MAP ""
set_interface_property clock_reset CMSIS_SVD_VARIABLES ""
set_interface_property clock_reset SVD_ADDRESS_GROUP ""

add_interface_port clock_reset clk clk Input 1


# 
# connection point clock_reset_reset
# 
add_interface clock_reset_reset reset end
set_interface_property clock_reset_reset associatedClock clock_reset
set_interface_property clock_reset_reset synchronousEdges DEASSERT
set_interface_property clock_reset_reset ENABLED true
set_interface_property clock_reset_reset EXPORT_OF ""
set_interface_property clock_reset_reset PORT_NAME_MAP ""
set_interface_property clock_reset_reset CMSIS_SVD_VARIABLES ""
set_interface_property clock_reset_reset SVD_ADDRESS_GROUP ""

add_interface_port clock_reset_reset reset reset Input 1


# 
# connection point avalon_slave
# 
add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock clock_reset
set_interface_property avalon_slave associatedReset clock_reset_reset
set_interface_property avalon_slave bitsPerSymbol 8
set_interface_property avalon_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_slave burstcountUnits WORDS
set_interface_property avalon_slave explicitAddressSpan 0
set_interface_property avalon_slave holdTime 0
set_interface_property avalon_slave linewrapBursts false
set_interface_property avalon_slave maximumPendingReadTransactions 0
set_interface_property avalon_slave maximumPendingWriteTransactions 0
set_interface_property avalon_slave readLatency 0
set_interface_property avalon_slave readWaitTime 1
set_interface_property avalon_slave setupTime 0
set_interface_property avalon_slave timingUnits Cycles
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave ENABLED true
set_interface_property avalon_slave EXPORT_OF ""
set_interface_property avalon_slave PORT_NAME_MAP ""
set_interface_property avalon_slave CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave address address Input 4
add_interface_port avalon_slave write write Input 1
add_interface_port avalon_slave read read Input 1
add_interface_port avalon_slave writedata writedata Input 32
add_interface_port avalon_slave readdata readdata Output 32
set_interface_assignment avalon_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave embeddedsw.configuration.isMemoryDevice false
set_interface_assignment avalon_slave embeddedsw.configuration.isNonVolatileStorage false
set_interface_assignment avalon_slave embeddedsw.configuration.isPrintableDevice false


# 
# connection point avalon_streaming_source
# 
add_interface avalon_streaming_source avalon_streaming start
set_interface_property avalon_streaming_source associatedClock clock_st
set_interface_property avalon_streaming_source dataBitsPerSymbol 8
set_interface_property avalon_streaming_source errorDescriptor ""
set_interface_property avalon_streaming_source firstSymbolInHighOrderBits true
set_interface_property avalon_streaming_source maxChannel 0
set_interface_property avalon_streaming_source readyLatency 0
set_interface_property avalon_streaming_source ENABLED true
set_interface_property avalon_streaming_source EXPORT_OF ""
set_interface_property avalon_streaming_source PORT_NAME_MAP ""
set_interface_property avalon_streaming_source CMSIS_SVD_VARIABLES ""
set_interface_property avalon_streaming_source SVD_ADDRESS_GROUP ""

add_interface_port avalon_streaming_source tx_rdy ready Input 1
add_interface_port avalon_streaming_source tx_wren valid Output 1
add_interface_port avalon_streaming_source tx_data data Output 32
add_interface_port avalon_streaming_source tx_sop startofpacket Output 1
add_interface_port avalon_streaming_source tx_eop endofpacket Output 1
add_interface_port avalon_streaming_source tx_mod empty Output 2
add_interface_port avalon_streaming_source tx_err error Output 1


# 
# connection point clock_st
# 
add_interface clock_st clock end
set_interface_property clock_st clockRate 0
set_interface_property clock_st ENABLED true
set_interface_property clock_st EXPORT_OF ""
set_interface_property clock_st PORT_NAME_MAP ""
set_interface_property clock_st CMSIS_SVD_VARIABLES ""
set_interface_property clock_st SVD_ADDRESS_GROUP ""
