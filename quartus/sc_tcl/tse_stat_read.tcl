# =======================================================================================
# ALTERA Confidential and Proprietary
# Copyright 2010 (c) Altera Corporation
# All rights reserved
#
# Project     : Triple Speed Ethernet Hardware Test By Using System Console
# 
# Description : Ethernet Generator/Monitor Configuration Setting Top Script
#
# Revision Control Information
#
# Author      : IP Apps
# Revision    : #1
# Date        : 2010/11/10
# ======================================================================================

set jtag_master [lindex [get_service_paths master] 0];

open_service master $jtag_master;
puts "\nInfo: Opened JTAG Master Service\n\n";

puts "TSE MAC Statistics Counters Map\n";
puts "==============================\n";
puts "\n";
puts "Addr\t Name\t\t\t\t Read Value\n";
puts "----\t ----\t\t\t\t ----------\n";



for {set AddressOffset 0x68} {$AddressOffset < 0xE4} {incr AddressOffset 0x4} {

set AddressOffset_hex [format "%#x" $AddressOffset];

switch -exact -- $AddressOffset_hex {
0x68 { set mac_register_name "aFramesTransmittedOK\t" }
0x6c { set mac_register_name "aFramesReceivedOK\t\t" }
0x70 { set mac_register_name "aFrameCheckSequenceErrors\t" }
0x74 { set mac_register_name "aAlignmentErrors\t\t" }
0x78 { set mac_register_name "aOctetsTransmittedOK\t" }
0x7c { set mac_register_name "aOctetsReceivedOK\t\t" }
0x80 { set mac_register_name "aTxPAUSEMACCtrlFrames\t" }
0x84 { set mac_register_name "aRxPAUSEMACCtrlFrames\t" }
0x88 { set mac_register_name "ifInErrors\t\t" }
0x8c { set mac_register_name "ifOutErrors\t\t" }
0x90 { set mac_register_name "ifInUcastPkts\t\t" }
0x94 { set mac_register_name "ifInMulticastPkts\t\t" }
0x98 { set mac_register_name "ifInBroadcastPkts\t\t" }
0x9c { set mac_register_name "ifOutDiscards\t\t" }
0xa0 { set mac_register_name "ifOutUcastPkts\t\t" }
0xa4 { set mac_register_name "ifOutMulticastPkts\t\t" }
0xa8 { set mac_register_name "ifOutBroadcastPkts\t\t" }
0xac { set mac_register_name "etherStatsDropEvents\t" }
0xb0 { set mac_register_name "etherStatsOctets\t\t" }
0xb4 { set mac_register_name "etherStatsPkts\t\t" }
0xb8 { set mac_register_name "etherStatsUndersizePkts\t" }
0xbc { set mac_register_name "etherStatsOversizePkts\t" }
0xc0 { set mac_register_name "etherStatsPkts64Octets\t" }
0xc4 { set mac_register_name "etherStatsPkts65to127Octets\t" }
0xc8 { set mac_register_name "etherStatsPkts128to255Octets\t" }
0xcc { set mac_register_name "etherStatsPkts256to511Octets\t" }
0xd0 { set mac_register_name "etherStatsPkts512to1023Octets\t" }
0xd4 { set mac_register_name "etherStatsPkts1024to1518Octets" }
0xd8 { set mac_register_name "etherStatsPkts1519toXOctets\t" }
0xdc { set mac_register_name "etherStatsJabbers\t\t" }
0xe0 { set mac_register_name "etherStatsFragments\t\t" }
default { set mac_register_name "Unknown" }
};

	
set mac_register_read_value [master_read_32 $jtag_master $AddressOffset 1];


puts "$AddressOffset_hex\t $mac_register_name\t $mac_register_read_value\n";


};

close_service master $jtag_master;
puts "\nInfo: Closed JTAG Master Service\n\n";