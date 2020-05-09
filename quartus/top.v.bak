module top (
//Clock and Reset

c10_clk50m,
GTX_CLK,
RX_CLK,
RESET_N,			// USER_PB0
PHY_RESET_N,

// Reset Status
LED_RESET_N,		// USR_LED0
LED_CORE_RESET_N,	// USR_LED1

//MDIO
MDC,
MDIO,

//RGMII 
RGMII_IN,
RGMII_OUT,
RX_CONTROL,
TX_CONTROL,

//MAC Status Signals
SET_1000,			// USER_DIPSW1
SET_10,				// USER_DIPSW0
ENA_10_N,			// USR_LED2
ETH_MODE_N			// USR_LED3


);

input			   c10_clk50m;
output 			GTX_CLK;
input			   RX_CLK;
input 			RESET_N;
output 			PHY_RESET_N;

output 			LED_RESET_N;
output 			LED_CORE_RESET_N;

output 			MDC;
inout 			MDIO;

input 	[3:0] 	RGMII_IN;
output 	[3:0] 	RGMII_OUT;
input 			RX_CONTROL;
output 			TX_CONTROL;

input 			SET_1000;
input 			SET_10;
output 			ENA_10_N;
output 			ETH_MODE_N;


wire 			clk_25M;
wire 			clk_2_5M;
wire 			clk_125M;


wire 			tx_clk;
wire			eth_mode_ena_10_n;


//wire 			RESET_N;
wire 			core_reset_n;

wire 			mdio_in;
wire 			mdio_oen;
wire 			mdio_out;

wire 			ena_10;
wire 			eth_mode;


// Clock and Reset connection
assign PHY_RESET_N = core_reset_n;
assign LED_RESET_N = RESET_N;
assign LED_CORE_RESET_N = ~core_reset_n;

// MDIO ports connection
assign MDIO = mdio_oen ? 1'bz : mdio_out;
assign mdio_in = MDIO;

assign ENA_10_N = ~ena_10;
assign ETH_MODE_N = ~eth_mode;


pll pll_0 (
	
	.areset	(~RESET_N),
	.inclk0	(c10_clk50m),
	.c0		(clk_125M),
	.c1 		(clk_25M),
	.c2 		(clk_2_5M),
	.locked	(core_reset_n)
);



qsys_top qsys_top_0 (
	.eth_tse_0_mac_status_connection_eth_mode	(eth_mode),   	// eth_tse_0_conduit_connection.eth_mode
	.eth_tse_0_mac_status_connection_ena_10   	(ena_10),     	//                                           .ena_10
	.eth_tse_0_mac_rgmii_connection_rgmii_in    (RGMII_IN),   	//                                           .rgmii_in
	.eth_tse_0_mac_mdio_connection_mdc      	(MDC),       	//                                           .mdc
	.eth_tse_0_mac_rgmii_connection_tx_control	(TX_CONTROL), 	//                                           .tx_control
	.eth_tse_0_mac_status_connection_set_1000    (~SET_1000),   	//                                           .set_1000
	.eth_tse_0_mac_mdio_connection_mdio_out  	(mdio_out),   	//                                           .mdio_out
	.eth_tse_0_mac_rgmii_connection_rgmii_out  	(RGMII_OUT),  	//                                           .rgmii_out
	.eth_tse_0_mac_mdio_connection_mdio_oen 	(mdio_oen),   	//                                           .mdio_oen
	.eth_tse_0_mac_status_connection_set_10      (~SET_10),    	//                                           .set_10
	.eth_tse_0_mac_mdio_connection_mdio_in    	(mdio_in),    	//                                           .mdio_in
	.eth_tse_0_mac_rgmii_connection_rx_control  (RX_CONTROL), 	//                                           .rx_control
	.eth_tse_0_mac_misc_connection_xon_gen (1'b0),     
	.eth_tse_0_mac_misc_connection_xoff_gen (1'b0),    
	.eth_tse_0_mac_misc_connection_ff_tx_crc_fwd (1'b0),
	.eth_tse_0_mac_misc_connection_ff_tx_septy	(), 
	.eth_tse_0_mac_misc_connection_tx_ff_uflow	(), 
	.eth_tse_0_mac_misc_connection_ff_tx_a_full	(),
	.eth_tse_0_mac_misc_connection_ff_tx_a_empty  (),
	.eth_tse_0_mac_misc_connection_rx_err_stat	(), 
	.eth_tse_0_mac_misc_connection_rx_frm_type	(), 
	.eth_tse_0_mac_misc_connection_ff_rx_dsav		(),  
	.eth_tse_0_mac_misc_connection_ff_rx_a_full	(),
	.eth_tse_0_mac_misc_connection_ff_rx_a_empty  (),
	.reset_reset_n                                   		(core_reset_n), //                                      reset.reset_n
	.clk_clk                                					(clk_125M),      //                                        clk.clk
	.eth_tse_0_pcs_mac_tx_clock_connection_clk	(tx_clk),
	.eth_tse_0_pcs_mac_rx_clock_connection_clk	(RX_CLK)
	);

ddio_out ddio_out_0 (
	.outclock (tx_clk),
	.dataout (GTX_CLK),
	.aclr (!core_reset_n),
	.datain_h (1'b1),
	.datain_l (1'b0),
	.outclocken (1'b1),
	.oe (1'b1)
);


assign tx_clk =   ( eth_mode ) ? ( clk_125M ) :  // GbE Mode = 125MHz clock
								( ena_10 ) ? ( clk_2_5M ) :    // 10Mb Mode = 2.5MHz clock
								( clk_25M );                  // 100Mb Mode = 25MHz clock
							




endmodule 