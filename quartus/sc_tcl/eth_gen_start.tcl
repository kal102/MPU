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

# Ethernet Generator Configuration Setting
# =============================
set number_packet		1000;		# Number of packets
set eth_gen 			1;				# Off = 0 & On = 1
set length_sel 			1;				# Fixed = 0	& Random = 1
set pkt_length 			1500;			# Ranges from 24 to 9600
set pattern_sel 		1;				# Incremental = 0 & Random = 1
set rand_seed 			0x123456789ABC;	# random seed
set source_addr 		0xEE1122334450;	# MAC destination address
set destination_addr 	0x3B57F0A10EDC;	# MAC source address

source eth_gen_mon.tcl;
