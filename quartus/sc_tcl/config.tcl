
# ALTERA Confidential and Proprietary
# Copyright 2010 (c) Altera Corporation
# All rights reserved
#
# Project     : Triple Speed Ethernet Hardware Test By Using System Console
#
# Description : Triple Speed Ethernet MAC + Intel XWAY PHY Configuration Setting Script
#
# Revision Control Information
#
# Author      : IP Apps
# Revision    : #2
# Date        : 2018/9/13
# ======================================================================================

# TSE MAC Configuration Setting
# =============================
set MAC_SCRATCH		0xaaaaaaaa;
# COMMAND_CONFIG
set ENA_TX 				1;
set ENA_RX 				1;
set XON_GEN 			0;
set ETH_SPEED 			1;	# 10/100Mbps = 0 & 1000Mbps = 1
set PROMIS_EN			1;
set PAD_EN 				1;
set CRC_FWD 			0;
set PAUSE_FWD 			0;
set PAUSE_IGNORE		0;
set TX_ADDR_INS 		0;
set HD_ENA 				0;
set EXCESS_COL 		0;
set LATE_COL			0;
set SW_RESET 			0;
set MHASH_SEL			0;
set LOOP_ENA			0;	#0;
set TX_ADDR_SEL 		0x0;
set MAGIC_ENA			0;
set SLEEP	 			0;
set WAKEUP 				0;
set XOFF_GEN 			0;
set CTRL_FRM_ENA 		0;
set NO_LGTH_CHECK		0;
set ENA_10 				0; # 100Mbps = 0 & 10Mbps = 1
set RX_ERR_DISC 		0;
set DISABLE_RD_TIMEOUT	0;
set CNT_RESET			0;

set MAC_0 				0x22334450;
set MAC_1 				0x0000EE11;
set FRM_LENGTH  		1518;	#9600;
set PAUSE_QUANT  		65535;
set RX_SECTION_EMPTY 	4080;
set RX_SECTION_FULL  	0;
set TX_SECTION_EMPTY 	4080;
set TX_SECTION_FULL  	0;
set RX_ALMOST_EMPTY 	8;
set RX_ALMOST_FULL  	8;
set TX_ALMOST_EMPTY  	8;
set TX_ALMOST_FULL 		3;
set MDIO_ADDR0  		0;
set MDIO_ADDR1  		0;

set TX_IPG_LENGTH 		12;

set TX_OMIT_CRC 		0;

set TX_SHIFT16 			0;
set RX_SHIFT16 			0;

# Marvell PHY Configuration Setting
# =================================
# PHY MISC
set PHY_ENABLE 			1;		# Enable PHY Port 0

# PHY Configuration
set PHY_ETH_SPEED 		1000;	# 10Mbps or 100Mbps or 1000Mbps
set PHY_ENABLE_AN 		1;		# Enable PHY Auto-Negotiation
set PHY_COPPER_DUPLEX	1;		# FD = 1 and HD = 0
set PHY_COLLISION_TEST  0;    #Enable PHY Collision test =1

source tse_mac_config.tcl
source tse_lantiq_phy.tcl
