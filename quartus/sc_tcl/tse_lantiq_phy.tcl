# =======================================================================================
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

# Define Variable
# ===============
set jtag_master [lindex [get_service_paths master] 0];

# PHY Variable
set PHY_ADDR 						0;	# PHY Address

# PHY MII Control Register 
set PHY_RGMII_TX_TIMING_CTRL_ON 	1;	# Enable RGMII TX Timing Control
set PHY_RGMII_RX_TIMING_CTRL_ON 	1;	# Enable RGMII RX Timing Control
										

set MII_Interface_Mode 					0;	
										# 0 (default) = RGMII to Copper
										# 1 = SGMII to Copper
										# 2 = RMII to Copper
										# 4 = GMII/MII to Copper
										
# Register Address Offset
# PHY 
# Port 0
#STD Registers
set MDIO_ADDR1_ADDRESS			0x040;
set STD_CTRL					0x280;
set STD_STAT					0x284;
set STD_PHYID1					0x288;
set STD_PHYID2					0x28C;
set STD_AN_ADV					0x290;
set STD_AN_LPA					0x294;
set STD_AN_EXP					0x298;
set STD_AN_NPTX					0x29C;
set STD_AN_NPRX					0x2A0;					
set STD_GCTRL					0x2A4;
set STD_GSTAT					0x2A8;
set STD_MMDCTRL 				0x2B4;
set STD_MMDDATA					0x2B8;
set STD_XSTAT					0x2BC;
#PHY Registers
set PHY_PHYPERF					0x2C0;
set PHY_PHYSTAT1				0x2C4;
set PHY_PHYSTAT2				0x2C8;
set PHY_PHYCTL1					0x2CC;
set PHY_PHYCTL2					0x2D0;
set PHY_ERRCNT					0x2D4;
set PHY_EECTRL					0x2D8;
set PHY_MIICTRL					0x2DC;
set PHY_MIISTAT					0x2E0;
set PHY_IMASK					0x2E4;
set PHY_ISTAT					0x2E8;  		


# PHYVariable
set quad_phy_register_value_temp 		0; 

# Starting Marvell PHY Configuration System Console
# =================================================
puts "=============================================================================="
puts "          Starting Lantiq PHY Configuration System Console                   "
puts "==============================================================================\n\n"

# Open JTAG Master Service
# ========================
open_service master $jtag_master;
puts "\nInfo: Opened JTAG Master Service\n\n";

# Configure Ethernet PHY On Board
# ===============================================
puts "\nInfo: Configure On Board Ethernet PHY Chip\n\n";
if { $PHY_ENABLE == 1} {
	puts "Configure PHY.";	
	master_write_32 $jtag_master $MDIO_ADDR1_ADDRESS $PHY_ADDR;
	set quad_phy_register_value_temp 0;
	
	###Apply software reset
	puts "Info: Applying Software Reset on Lantiq PHY ";
	set quad_phy_register_value_temp [master_read_32 $jtag_master $STD_CTRL 1];
	set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x8000}];
	master_write_32 $jtag_master $STD_CTRL $quad_phy_register_value_temp;
	puts "Info: Check the software reset value of control and status PHY registers ";
	puts "PHY read Control Register	= [master_read_32 $jtag_master $STD_CTRL 1]";
	puts "PHY read Status Register	= [master_read_32 $jtag_master $STD_STAT 1]";
	#puts "PHY read PHY ID1 Register	= [master_read_32 $jtag_master $STD_PHYID1 1]";
	#puts "PHY read PHY ID2 Register	= [master_read_32 $jtag_master $STD_PHYID2 1]";
	#puts "PHY read AN Advertisement Register   = [master_read_32 $jtag_master $STD_AN_ADV 1]";
	#puts "PHY read AN LP Ability Register      = [master_read_32 $jtag_master $STD_AN_LPA 1]";
	#puts "PHY read AN Expansion Register       = [master_read_32 $jtag_master $STD_AN_EXP 1]";
	#puts "PHY read AN Next Page TX Register    = [master_read_32 $jtag_master $STD_AN_NPTX 1]";
	#puts "PHY read AN LP Next Page RX Register = [master_read_32 $jtag_master $STD_AN_NPRX 1]";
	#puts "PHY read 1000BASE-T Control Register = [master_read_32 $jtag_master $STD_GCTRL 1]";
	#puts "PHY read 1000BASE-T Status Register  = [master_read_32 $jtag_master $STD_GSTAT 1]";
	#puts "PHY read MMD Access Control Register= [master_read_32 $jtag_master $STD_MMDCTRL 1]";
	#puts "PHY read MMD Access Data Register= [master_read_32 $jtag_master $STD_MMDDATA 1]";
	#puts "PHY read Extended Status  Register= [master_read_32 $jtag_master $STD_XSTAT 1]";
	#puts "PHY read Physical Layer Performance Status Reg= [master_read_32 $jtag_master $PHY_PHYPERF 1]";
	#puts "PHY read Physical Layer 1 Register= [master_read_32 $jtag_master $PHY_PHYSTAT1 1]";
	#puts "PHY read Physical Layer 2 Register= [master_read_32 $jtag_master $PHY_PHYSTAT2 1]";
	#puts "PHY read Physical Layer Control 1 Register= [master_read_32 $jtag_master $PHY_PHYCTL1 1]";
	#puts "PHY read Physical Layer Control 2 Register= [master_read_32 $jtag_master $PHY_PHYCTL2 1]";
	#puts "PHY read Error Counter Register = [master_read_32 $jtag_master $PHY_ERRCNT 1]";
	#puts "PHY read EEPRM Control Register= [master_read_32 $jtag_master $PHY_EECTRL 1]";
	#puts "PHY read MII Control	= [master_read_32 $jtag_master $PHY_MIICTRL 1]";
	#puts "PHY read MII Status Register    = [master_read_32 $jtag_master $PHY_MIISTAT 1]";
	#puts "PHY read Interrupt Mask Register= [master_read_32 $jtag_master $PHY_IMASK 1]";
	#puts "PHY read Interrupt Status Register= [master_read_32 $jtag_master $PHY_ISTAT 1]";
	
	
	#### PHY Control Register (REG 0)
	set quad_phy_register_value_temp [master_read_32 $jtag_master $STD_CTRL 1];
	set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp & 0x8EBF}];
	
		if { $PHY_ENABLE_AN == 1} {
		set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x1000}];
		puts "Enable PHY Auto-Negotiation";
	} else {
		set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0000}];
		puts "Disable PHY Auto-Negotiation";
	}


	switch -exact -- $PHY_ETH_SPEED {
	10 { set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0000}];
	puts "Set PHY SPEED to 10Mbps";
	}
	100 { set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x2000}]; 
	puts "Set PHY SPEED to 100Mbps";
	}
	1000 { set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0040}];
	puts "Set PHY SPEED to 1000Mbps"; 
	}
	default { 
	set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0040}];
	puts "Set PHY SPEED to default value (1000Mbps)"
	}
	};


	if { $PHY_COPPER_DUPLEX == 1} {
		set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0100}];
		puts "Enable PHY In Full Duplex Mode";
	} else {
		puts "Enable PHY In Half Duplex Mode";
	}
	master_write_32 $jtag_master $STD_CTRL $quad_phy_register_value_temp;
	
	puts "PHY read Control Register			= [master_read_32 $jtag_master $STD_CTRL 1]";
	
	

	if { $PHY_COLLISION_TEST == 1} {
	   set quad_phy_register_value_temp [master_read_32 $jtag_master $STD_CTRL 1];
		set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0080}];
		master_write_32 $jtag_master $STD_CTRL $quad_phy_register_value_temp;
		puts "Enable PHY Collision Test";
	} else {
		puts "Disable PHY Collision Test";
	}
	puts "PHY read Control Register			= [master_read_32 $jtag_master $STD_CTRL 1]";
	
	#### PHY AN Advertisement Register 
	set quad_phy_register_value_temp [master_read_32 $jtag_master $STD_AN_ADV 1];
	set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp & 0xFE1F}];

	switch -exact -- $PHY_ETH_SPEED {
		10 { 
			if { $PHY_COPPER_DUPLEX == 1} {
				set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0040}];
				puts "Advertise PHY 10BASE-TX Full Duplex";
			} else {
				set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0020}];
				puts "Advertise PHY 10BASE-TX Half Duplex";
			}
		}
		100 { 
			if { $PHY_COPPER_DUPLEX == 1} {
				set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0100}];
				puts "Advertise PHY 100BASE-TX Full Duplex";
			} else {
				set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0080}];
				puts "Advertise PHY 100BASE-TX Half Duplex";
			}
		}
		default { 
			
		}
	};

	master_write_32 $jtag_master $STD_AN_ADV $quad_phy_register_value_temp;
	puts "PHY read AN Advertisement Register		= [master_read_32 $jtag_master $STD_AN_ADV 1]";

	#### PHY 1000BASE-T Control Register
	set quad_phy_register_value_temp [master_read_32 $jtag_master $STD_GCTRL 1];
	set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp & 0xFCFF}];

	switch -exact -- $PHY_ETH_SPEED {
		1000 { 
			if { $PHY_COPPER_DUPLEX == 1} {
				set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0200}];
				puts "Advertise PHY 1000BASE-T Full Duplex";
			} else {


				set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0100}];
				puts "Advertise PHY 1000BASE-T Half Duplex";
			}
		}
		default { 
			
		}
	};
	
	master_write_32 $jtag_master $STD_GCTRL $quad_phy_register_value_temp;
	puts "PHY read 1000BASE-T Control Register		= [master_read_32 $jtag_master $STD_GCTRL 1]";
	puts "PHY read 1000BASE-T Status Register		= [master_read_32 $jtag_master $STD_GSTAT 1]";

	

	switch -exact -- $MII_Interface_Mode {
	0 { set quad_phy_register_value_temp 0x0000;
	puts "Set PHY MII_Interface_Mode for RGMII to Copper ";
	}
	1 { set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0001}]; 
	puts "Set PHY MII_Interface_Mode for SGMII to Copper";
	}
	2 { set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0002}];
	puts "Set PHY MII_Interface_Mode for RMII to Copper"; 
	}
	4 { set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0004}];
	puts "Set PHY MII_Interface_Mode for GMII/MII to Copper"; 
	}
	default { 
	set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0000}];
	puts "Set PHY MII_Interface_Mode to default mode (RGMII to Copper Without)"
	}
	};

	master_write_32 $jtag_master $PHY_MIICTRL $quad_phy_register_value_temp;
	puts "PHY read MII Control	= [master_read_32 $jtag_master $PHY_MIICTRL 1]";
	
	#### PHY MII Control Register
	if {$MII_Interface_Mode == 0} {
		if { ($PHY_RGMII_TX_TIMING_CTRL_ON == 1) && ($PHY_RGMII_RX_TIMING_CTRL_ON == 1) } {
			puts "Set RGMII TX and RX Timing Control";
			set quad_phy_register_value_temp [master_read_32 $jtag_master $PHY_MIICTRL 1];
			set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp & 0xFF7D}];
			set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x1400}];
			master_write_32 $jtag_master $PHY_MIICTRL $quad_phy_register_value_temp;
			puts "PHY read MII Control	= [master_read_32 $jtag_master $PHY_MIICTRL 1]";
		} elseif { ($PHY_RGMII_TX_TIMING_CTRL_ON == 1) && ($PHY_RGMII_RX_TIMING_CTRL_ON == 0) } {
			puts "Set RGMII TX Timing Control";
			set quad_phy_register_value_temp [master_read_32 $jtag_master $PHY_MIICTRL 1];
			set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp & 0xFF7D}];
			set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x0400}];
			master_write_32 $jtag_master $PHY_MIICTRL $quad_phy_register_value_temp;
			puts "PHY read MII Control	= [master_read_32 $jtag_master $PHY_MIICTRL 1]";
		} elseif { ($PHY_RGMII_TX_TIMING_CTRL_ON == 0) && ($PHY_RGMII_RX_TIMING_CTRL_ON == 1) } {
			puts "Set RGMII RX Timing Control";
			set quad_phy_register_value_temp [master_read_32 $jtag_master $PHY_MIICTRL 1];
			set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp & 0xFF7D}];
			set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp | 0x1000}];
			master_write_32 $jtag_master $PHY_MIICTRL $quad_phy_register_value_temp;
			puts "PHY read MII Control	= [master_read_32 $jtag_master $PHY_MIICTRL 1]";
		} else {
			puts "Info: No RGMII Timing Control being set";
		}
	}
	
	#### PHY MII Status and Status Register 
	set PHY_TIMEOUT 8000;
	set PHY_COUNT_TEMP 0;
	set quad_phy_register_value_temp 0;
	while { ($quad_phy_register_value_temp == 0x00000000) && ($PHY_COUNT_TEMP < $PHY_TIMEOUT) } {
		set quad_phy_register_value_temp [master_read_32 $jtag_master $STD_STAT 1];
		set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp & 0x0004}];
		
		if {($quad_phy_register_value_temp == 0x0004) && ($PHY_COUNT_TEMP < $PHY_TIMEOUT)} {
			puts "PHY Link Up.";
		}
		
		set PHY_COUNT_TEMP [expr {$PHY_COUNT_TEMP + 1}];
		
		if {$PHY_COUNT_TEMP == $PHY_TIMEOUT} {
			puts "PHY Link Down!";
		}
	}

	set PHY_COUNT_TEMP 0;
	set quad_phy_register_value_temp 0;
	while { ($quad_phy_register_value_temp == 0x00000000) && ($PHY_COUNT_TEMP < $PHY_TIMEOUT) } {
		set quad_phy_register_value_temp [master_read_32 $jtag_master $STD_STAT 1];
		set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp & 0x0020}];
		
		if {($quad_phy_register_value_temp == 0x0020) && ($PHY_COUNT_TEMP < $PHY_TIMEOUT)} {
			puts "Auto-negotiation completed";
		}
		
		set PHY_COUNT_TEMP [expr {$PHY_COUNT_TEMP + 1}];
		
		if {$PHY_COUNT_TEMP == $PHY_TIMEOUT} {
			puts "Auto-negotiation failed";
		}
	}

	set quad_phy_register_value_temp [master_read_32 $jtag_master $PHY_MIISTAT 1];
	set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp & 0x0008}];
	
	if { $quad_phy_register_value_temp == 0x0008} {
		puts "PHY operating in Full Duplex mode.";
	} else {
		puts "PHY operating in Half Duplex mode.";
	}

	set quad_phy_register_value_temp [master_read_32 $jtag_master $PHY_MIISTAT 1];
	set quad_phy_register_value_temp [expr {$quad_phy_register_value_temp & 0x0003}];

	if { $quad_phy_register_value_temp == 0x0000 } {
		puts "PHY operating Speed 10Mbps";
	} elseif { $quad_phy_register_value_temp == 0x0001 } {
		puts "PHY operating Speed 100Mbps";
	} elseif { $quad_phy_register_value_temp == 0x0002 } {
		puts "PHY operating Speed 1000Mbps";
	} else {
		puts "PHY operating Speed is on FRE mode!";
	}
	
		
	
	
}

close_service master $jtag_master;
puts "\nInfo: Closed JTAG Master Service\n\n";
