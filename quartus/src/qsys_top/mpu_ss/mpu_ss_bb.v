
module mpu_ss (
	clk_clk,
	reset_reset_n,
	tx_mac_misc_connection_ff_tx_crc_fwd,
	tx_mac_misc_connection_ff_tx_septy,
	tx_mac_misc_connection_ff_tx_uflow,
	tx_mac_misc_connection_ff_tx_a_full,
	tx_mac_misc_connection_ff_tx_a_empty,
	transmit_data,
	transmit_endofpacket,
	transmit_error,
	transmit_ready,
	transmit_startofpacket,
	transmit_valid,
	transmit_empty,
	rx_mac_misc_connection_ff_rx_dsav,
	rx_mac_misc_connection_ff_rx_a_empty,
	rx_mac_misc_connection_ff_rx_a_full,
	rx_mac_misc_connection_rx_err_stat,
	rx_mac_misc_connection_rx_frm_type,
	receive_startofpacket,
	receive_valid,
	receive_ready,
	receive_error,
	receive_data,
	receive_endofpacket,
	receive_empty);	

	input		clk_clk;
	input		reset_reset_n;
	output		tx_mac_misc_connection_ff_tx_crc_fwd;
	input		tx_mac_misc_connection_ff_tx_septy;
	input		tx_mac_misc_connection_ff_tx_uflow;
	input		tx_mac_misc_connection_ff_tx_a_full;
	input		tx_mac_misc_connection_ff_tx_a_empty;
	output	[31:0]	transmit_data;
	output		transmit_endofpacket;
	output		transmit_error;
	input		transmit_ready;
	output		transmit_startofpacket;
	output		transmit_valid;
	output	[1:0]	transmit_empty;
	input		rx_mac_misc_connection_ff_rx_dsav;
	input		rx_mac_misc_connection_ff_rx_a_empty;
	input		rx_mac_misc_connection_ff_rx_a_full;
	input	[17:0]	rx_mac_misc_connection_rx_err_stat;
	input	[3:0]	rx_mac_misc_connection_rx_frm_type;
	input		receive_startofpacket;
	input		receive_valid;
	output		receive_ready;
	input	[5:0]	receive_error;
	input	[7:0]	receive_data;
	input		receive_endofpacket;
	input	[1:0]	receive_empty;
endmodule
