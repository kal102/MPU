#Create PLL reference clock
create_clock -name {CLKIN_50} -period "50 MHz" [get_ports {c10_clk50m}]

#Virtual clock for input constraints
create_clock -name rx_virtual_clk_125 -period 8
create_clock -name rx_virtual_clk_25 -period 40
create_clock -name rx_virtual_clk_2p5 -period 400

#Define RGMII RX clocks from PHY
create_clock -period 8 -waveform { 2 6 } -name  {rgmii_rx_clk_125} [get_ports RX_CLK]
create_clock -period 40 -waveform { 10 30 } -name  {rgmii_rx_clk_25} [get_ports RX_CLK] -add
create_clock -period 400 -waveform { 100 300 } -name  {rgmii_rx_clk_2p5} [get_ports RX_CLK] -add

#Define PLL clocks
create_generated_clock -name pll_0|altpll_component|auto_generated|pll1|clk[0] \
-source [get_pins {pll_0|altpll_component|auto_generated|pll1|inclk[0]}] \
-duty_cycle 50.000 -multiply_by 5 -divide_by 2  \
-master_clock {CLKIN_50} \
[get_pins {pll_0|altpll_component|auto_generated|pll1|clk[0]}] 

create_generated_clock -name pll_0|altpll_component|auto_generated|pll1|clk[1] \
-source [get_pins {pll_0|altpll_component|auto_generated|pll1|inclk[0]}] \
-duty_cycle 50.000 -multiply_by 1 -divide_by 2 \
-master_clock {CLKIN_50} \
[get_pins {pll_0|altpll_component|auto_generated|pll1|clk[1]}] 

create_generated_clock -name pll_0|altpll_component|auto_generated|pll1|clk[2] \
-source [get_pins {pll_0|altpll_component|auto_generated|pll1|inclk[0]}] \
-duty_cycle 50.000 -multiply_by 1 -divide_by 20 \
-master_clock {CLKIN_50} \
[get_pins {pll_0|altpll_component|auto_generated|pll1|clk[2]}] 


#create_generated_clock -name pll_0|altpll_component|auto_generated|pll1|clk[3] \
#-source [get_pins {pll_0|altpll_component|auto_generated|pll1|inclk[0]}] \
#-duty_cycle 50.000 -multiply_by 5 -divide_by 2  \
#-phase 9\
#-master_clock {CLKIN_50} \
#[get_pins {pll_0|altpll_component|auto_generated|pll1|clk[3]}] 




#-source [get_pins {tx_clk_shift~1|combout}]  
#-source [get_pins {tx_clk|combout}]  
#Define RGMII TX clocks to PHY

create_generated_clock -name rgmii_125_tx_clk \
-source [get_pins {tx_clk|combout}]   \
-master_clock [get_clocks {pll_0|altpll_component|auto_generated|pll1|clk[0]}] \
[get_ports GTX_CLK]


create_generated_clock -name rgmii_25_tx_clk \
-source [get_pins {tx_clk|combout}]    \
-master_clock [get_clocks {pll_0|altpll_component|auto_generated|pll1|clk[1]}] \
[get_ports GTX_CLK] \
-add

create_generated_clock -name rgmii_2_5_tx_clk \
-source [get_pins {tx_clk|combout}]    \
-master_clock [get_clocks {pll_0|altpll_component|auto_generated|pll1|clk[2]}] \
[get_ports GTX_CLK] \
-add

#Derive clock uncertainty
derive_clock_uncertainty


#if {$::quartus(nameofexecutable) == "quartus_fit"} {
#  set_clock_uncertainty -from pll_0|altpll_component|auto_generated|pll1|clk[3] -to rgmii_125_tx_clk -hold -add -100ps
#}

#if {$::quartus(nameofexecutable) == "quartus_fit"} {
#	set_max_delay -from qsys_top:qsys_top_0|qsys_top_eth_tse_0:eth_tse_0|altera_eth_tse_mac:i_tse_mac|altera_tse_mac_control:U_MAC_CONTROL|altera_tse_register_map:U_REG|ena_10 -to RGMII_OUT[*] -1.0ns
#	set_min_delay -from qsys_top:qsys_top_0|qsys_top_eth_tse_0:eth_tse_0|altera_eth_tse_mac:i_tse_mac|altera_tse_mac_control:U_MAC_CONTROL|altera_tse_register_map:U_REG|ena_10 -to RGMII_OUT[*] -8.0ns
	
#	set_max_delay -from qsys_top:qsys_top_0|qsys_top_eth_tse_0:eth_tse_0|altera_eth_tse_mac:i_tse_mac|altera_tse_mac_control:U_MAC_CONTROL|altera_tse_register_map:U_REG|ena_10 -to TX_CONTROL  -1.0ns
#	set_min_delay -from qsys_top:qsys_top_0|qsys_top_eth_tse_0:eth_tse_0|altera_eth_tse_mac:i_tse_mac|altera_tse_mac_control:U_MAC_CONTROL|altera_tse_register_map:U_REG|ena_10 -to TX_CONTROL  -8.0ns
#}

# RGMII TX channel
# Output Delay Constraints (Edge Aligned, Same Edge Capture)
# +---------------------------------------------------

set output_max_delay  -1.0 
set output_min_delay  -3.0

post_message -type info "Output Max Delay = $output_max_delay"
post_message -type info "Output Min Delay = $output_min_delay"

set_output_delay -clock rgmii_125_tx_clk -max $output_max_delay [get_ports "RGMII_OUT* TX_CONTROL"]
set_output_delay -clock rgmii_125_tx_clk -max $output_max_delay [get_ports "RGMII_OUT* TX_CONTROL"] -clock_fall -add_delay
set_output_delay -clock rgmii_125_tx_clk -min $output_min_delay [get_ports "RGMII_OUT* TX_CONTROL"] -add_delay
set_output_delay -clock rgmii_125_tx_clk -min $output_min_delay [get_ports "RGMII_OUT* TX_CONTROL"] -clock_fall -add_delay

set_output_delay -clock rgmii_25_tx_clk -max $output_max_delay [get_ports "RGMII_OUT* TX_CONTROL"] -add_delay
set_output_delay -clock rgmii_25_tx_clk -max $output_max_delay [get_ports "RGMII_OUT* TX_CONTROL"] -clock_fall -add_delay
set_output_delay -clock rgmii_25_tx_clk -min $output_min_delay [get_ports "RGMII_OUT* TX_CONTROL"] -add_delay
set_output_delay -clock rgmii_25_tx_clk -min $output_min_delay [get_ports "RGMII_OUT* TX_CONTROL"] -clock_fall -add_delay

set_output_delay -clock rgmii_2_5_tx_clk -max $output_max_delay [get_ports "RGMII_OUT* TX_CONTROL"] -add_delay
set_output_delay -clock rgmii_2_5_tx_clk -max $output_max_delay [get_ports "RGMII_OUT* TX_CONTROL"] -clock_fall -add_delay
set_output_delay -clock rgmii_2_5_tx_clk -min $output_min_delay [get_ports "RGMII_OUT* TX_CONTROL"] -add_delay
set_output_delay -clock rgmii_2_5_tx_clk -min $output_min_delay [get_ports "RGMII_OUT* TX_CONTROL"] -clock_fall -add_delay

# Set multicycle paths to align the launch edge with the latch edge

set_multicycle_path -setup -end -rise_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[0]] -rise_to [get_clocks rgmii_125_tx_clk] 0
set_multicycle_path -setup -end -fall_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[0]] -fall_to [get_clocks rgmii_125_tx_clk] 0
set_multicycle_path -hold -end -rise_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[0]] -rise_to [get_clocks rgmii_125_tx_clk] -1
set_multicycle_path -hold -end -fall_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[0]] -fall_to [get_clocks rgmii_125_tx_clk] -1

set_multicycle_path -setup -end -rise_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[1]] -rise_to [get_clocks rgmii_25_tx_clk] 0
set_multicycle_path -setup -end -fall_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[1]] -fall_to [get_clocks rgmii_25_tx_clk] 0
set_multicycle_path -hold -end -rise_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[1]] -rise_to [get_clocks rgmii_25_tx_clk] -1
set_multicycle_path -hold -end -fall_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[1]] -fall_to [get_clocks rgmii_25_tx_clk] -1

set_multicycle_path -setup -end -rise_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[2]] -rise_to [get_clocks rgmii_2_5_tx_clk] 0
set_multicycle_path -setup -end -fall_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[2]] -fall_to [get_clocks rgmii_2_5_tx_clk] 0
set_multicycle_path -hold -end -rise_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[2]] -rise_to [get_clocks rgmii_2_5_tx_clk] -1
set_multicycle_path -hold -end -fall_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[2]] -fall_to [get_clocks rgmii_2_5_tx_clk] -1

# Set false paths to remove irrelevant setup and hold analysis
set_false_path -fall_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[0]] -rise_to [get_clocks rgmii_125_tx_clk] -setup
set_false_path -rise_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[0]] -fall_to [get_clocks rgmii_125_tx_clk] -setup
set_false_path -fall_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[0]] -fall_to [get_clocks rgmii_125_tx_clk] -hold
set_false_path -rise_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[0]] -rise_to [get_clocks rgmii_125_tx_clk] -hold

set_false_path -fall_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[1]] -rise_to [get_clocks rgmii_25_tx_clk] -setup
set_false_path -rise_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[1]] -fall_to [get_clocks rgmii_25_tx_clk] -setup
set_false_path -fall_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[1]] -fall_to [get_clocks rgmii_25_tx_clk] -hold
set_false_path -rise_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[1]] -rise_to [get_clocks rgmii_25_tx_clk] -hold

set_false_path -fall_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[2]] -rise_to [get_clocks rgmii_2_5_tx_clk] -setup
set_false_path -rise_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[2]] -fall_to [get_clocks rgmii_2_5_tx_clk] -setup
set_false_path -fall_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[2]] -fall_to [get_clocks rgmii_2_5_tx_clk] -hold
set_false_path -rise_from [get_clocks pll_0|altpll_component|auto_generated|pll1|clk[2]] -rise_to [get_clocks rgmii_2_5_tx_clk] -hold


# RGMII RX channel
# Input Delay Constraints (Center aligned, Same Edge Analysis)
# 125MHz input constraints
set input_max_delay_125 0.5
set input_min_delay_125 -0.5

post_message -type info "Input Max Delay for 125MHz domain= $input_max_delay_125"
post_message -type info "Input Min Delay for 125MHz domain= $input_min_delay_125"

set_input_delay -max [expr $input_max_delay_125 ] -clock [get_clocks rx_virtual_clk_125] [get_ports "RGMII_IN* RX_CONTROL"]
set_input_delay -max [expr $input_max_delay_125 ] -clock [get_clocks rx_virtual_clk_125] [get_ports "RGMII_IN* RX_CONTROL"] -clock_fall -add_delay
set_input_delay -min [expr $input_min_delay_125 ] -clock [get_clocks rx_virtual_clk_125] [get_ports "RGMII_IN* RX_CONTROL"] -add_delay
set_input_delay -min [expr $input_min_delay_125 ] -clock [get_clocks rx_virtual_clk_125] [get_ports "RGMII_IN* RX_CONTROL"] -clock_fall -add_delay

# Set false paths to remove irrelevant setup and hold analysis
set_false_path -fall_from [get_clocks rx_virtual_clk_125] -rise_to [get_clocks {rgmii_rx_clk_125}] -setup
set_false_path -rise_from [get_clocks rx_virtual_clk_125] -fall_to [get_clocks {rgmii_rx_clk_125}] -setup
set_false_path -fall_from [get_clocks rx_virtual_clk_125] -fall_to [get_clocks {rgmii_rx_clk_125}] -hold
set_false_path -rise_from [get_clocks rx_virtual_clk_125] -rise_to [get_clocks {rgmii_rx_clk_125}] -hold

# 25MHz input constraints
set input_max_delay_25 8.5
set input_min_delay_25 -8.5

post_message -type info "Input Max Delay for 25MHz domain = $input_max_delay_25"
post_message -type info "Input Min Delay for 25MHz domain = $input_min_delay_25"

set_input_delay -max [expr $input_max_delay_25 ] -clock [get_clocks rx_virtual_clk_25] [get_ports "RGMII_IN* RX_CONTROL"] -add_delay
set_input_delay -max [expr $input_max_delay_25 ] -clock [get_clocks rx_virtual_clk_25] [get_ports "RGMII_IN* RX_CONTROL"] -clock_fall -add_delay
set_input_delay -min [expr $input_min_delay_25 ] -clock [get_clocks rx_virtual_clk_25] [get_ports "RGMII_IN* RX_CONTROL"] -add_delay
set_input_delay -min [expr $input_min_delay_25 ] -clock [get_clocks rx_virtual_clk_25] [get_ports "RGMII_IN* RX_CONTROL"] -clock_fall -add_delay

# Set false paths to remove irrelevant setup and hold analysis
set_false_path -fall_from [get_clocks rx_virtual_clk_25] -rise_to [get_clocks {rgmii_rx_clk_25}] -setup
set_false_path -rise_from [get_clocks rx_virtual_clk_25] -fall_to [get_clocks {rgmii_rx_clk_25}] -setup
set_false_path -fall_from [get_clocks rx_virtual_clk_25] -fall_to [get_clocks {rgmii_rx_clk_25}] -hold
set_false_path -rise_from [get_clocks rx_virtual_clk_25] -rise_to [get_clocks {rgmii_rx_clk_25}] -hold

# 2.5MHz input constraints
set input_max_delay_2p5 98.5
set input_min_delay_2p5 -98.5

post_message -type info "Input Max Delay for 2.5MHz domain = $input_max_delay_2p5"
post_message -type info "Input Min Delay for 2.5MHz domain = $input_min_delay_2p5"

set_input_delay -max [expr $input_max_delay_2p5 ] -clock [get_clocks rx_virtual_clk_2p5] [get_ports "RGMII_IN* RX_CONTROL"] -add_delay
set_input_delay -max [expr $input_max_delay_2p5 ] -clock [get_clocks rx_virtual_clk_2p5] [get_ports "RGMII_IN* RX_CONTROL"] -clock_fall -add_delay
set_input_delay -min [expr $input_min_delay_2p5 ] -clock [get_clocks rx_virtual_clk_2p5] [get_ports "RGMII_IN* RX_CONTROL"] -add_delay
set_input_delay -min [expr $input_min_delay_2p5 ] -clock [get_clocks rx_virtual_clk_2p5] [get_ports "RGMII_IN* RX_CONTROL"] -clock_fall -add_delay

# Set false paths to remove irrelevant setup and hold analysis
set_false_path -fall_from [get_clocks rx_virtual_clk_2p5] -rise_to [get_clocks {rgmii_rx_clk_2p5}] -setup
set_false_path -rise_from [get_clocks rx_virtual_clk_2p5] -fall_to [get_clocks {rgmii_rx_clk_2p5}] -setup
set_false_path -fall_from [get_clocks rx_virtual_clk_2p5] -fall_to [get_clocks {rgmii_rx_clk_2p5}] -hold
set_false_path -rise_from [get_clocks rx_virtual_clk_2p5] -rise_to [get_clocks {rgmii_rx_clk_2p5}] -hold

#Remove irrelevant clock domain crossing analysis
set_clock_groups -exclusive -group {pll_0|altpll_component|auto_generated|pll1|clk[0] rgmii_125_tx_clk rx_virtual_clk_125 rgmii_rx_clk_125} -group {pll_0|altpll_component|auto_generated|pll1|clk[1] rgmii_25_tx_clk rx_virtual_clk_25 rgmii_rx_clk_25} -group {pll_0|altpll_component|auto_generated|pll1|clk[2] rgmii_2_5_tx_clk rx_virtual_clk_2p5 rgmii_rx_clk_2p5}

#cut paths between unrelated clock domains
set_false_path -from [get_ports {MDIO}]
set_false_path -from [get_ports {RESET_N}]
set_false_path -from [get_ports {SET_10}]
set_false_path -from [get_ports {SET_1000}]
set_false_path -from [get_ports {altera_reserved_tdi}]
set_false_path -from [get_ports {altera_reserved_tms}]

set_false_path -to [get_ports {MDIO}]
set_false_path -to [get_ports {MDC}]
set_false_path -to [get_ports {ETH_MODE_N}]
set_false_path -to [get_keepers {ENA_10_N}]
set_false_path -to [get_ports {LED_CORE_RESET_N}]
set_false_path -to [get_ports {LED_RESET_N}]
set_false_path -to [get_ports {PHY_RESET_N}]
set_false_path -to [get_keepers {altera_reserved_tdo}]


