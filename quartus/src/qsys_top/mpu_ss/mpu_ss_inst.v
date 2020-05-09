	mpu_ss u0 (
		.clk_clk                              (<connected-to-clk_clk>),                              //                    clk.clk
		.reset_reset_n                        (<connected-to-reset_reset_n>),                        //                  reset.reset_n
		.tx_mac_misc_connection_ff_tx_crc_fwd (<connected-to-tx_mac_misc_connection_ff_tx_crc_fwd>), // tx_mac_misc_connection.ff_tx_crc_fwd
		.tx_mac_misc_connection_ff_tx_septy   (<connected-to-tx_mac_misc_connection_ff_tx_septy>),   //                       .ff_tx_septy
		.tx_mac_misc_connection_ff_tx_uflow   (<connected-to-tx_mac_misc_connection_ff_tx_uflow>),   //                       .ff_tx_uflow
		.tx_mac_misc_connection_ff_tx_a_full  (<connected-to-tx_mac_misc_connection_ff_tx_a_full>),  //                       .ff_tx_a_full
		.tx_mac_misc_connection_ff_tx_a_empty (<connected-to-tx_mac_misc_connection_ff_tx_a_empty>), //                       .ff_tx_a_empty
		.transmit_data                        (<connected-to-transmit_data>),                        //               transmit.data
		.transmit_endofpacket                 (<connected-to-transmit_endofpacket>),                 //                       .endofpacket
		.transmit_error                       (<connected-to-transmit_error>),                       //                       .error
		.transmit_ready                       (<connected-to-transmit_ready>),                       //                       .ready
		.transmit_startofpacket               (<connected-to-transmit_startofpacket>),               //                       .startofpacket
		.transmit_valid                       (<connected-to-transmit_valid>),                       //                       .valid
		.transmit_empty                       (<connected-to-transmit_empty>),                       //                       .empty
		.rx_mac_misc_connection_ff_rx_dsav    (<connected-to-rx_mac_misc_connection_ff_rx_dsav>),    // rx_mac_misc_connection.ff_rx_dsav
		.rx_mac_misc_connection_ff_rx_a_empty (<connected-to-rx_mac_misc_connection_ff_rx_a_empty>), //                       .ff_rx_a_empty
		.rx_mac_misc_connection_ff_rx_a_full  (<connected-to-rx_mac_misc_connection_ff_rx_a_full>),  //                       .ff_rx_a_full
		.rx_mac_misc_connection_rx_err_stat   (<connected-to-rx_mac_misc_connection_rx_err_stat>),   //                       .rx_err_stat
		.rx_mac_misc_connection_rx_frm_type   (<connected-to-rx_mac_misc_connection_rx_frm_type>),   //                       .rx_frm_type
		.receive_startofpacket                (<connected-to-receive_startofpacket>),                //                receive.startofpacket
		.receive_valid                        (<connected-to-receive_valid>),                        //                       .valid
		.receive_ready                        (<connected-to-receive_ready>),                        //                       .ready
		.receive_error                        (<connected-to-receive_error>),                        //                       .error
		.receive_data                         (<connected-to-receive_data>),                         //                       .data
		.receive_endofpacket                  (<connected-to-receive_endofpacket>),                  //                       .endofpacket
		.receive_empty                        (<connected-to-receive_empty>)                         //                       .empty
	);

