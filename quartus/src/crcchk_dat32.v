module crcchk_dat32 (
	clk,
	data,
	datavalid,
	empty,
	endofpacket,
	reset_n,
	startofpacket,
	crcbad,
	crcvalid);


	input		clk;
	input	[31:0]	data;
	input		datavalid;
	input	[1:0]	empty;
	input		endofpacket;
	input		reset_n;
	input		startofpacket;
	output		crcbad;
	output		crcvalid;

	
crc32_chk #(
	.DATA_WIDTH (32),
	.EMPTY_WIDTH (2),
	.CRC_WIDTH	(32),
	.REVERSE_DATA (1),
	.CRC_OUT_LATENCY (0),
	.CRC_PIPELINE_MODE (1)
)

crc32_chk_inst (
	.CLK	(clk),
	.RESET_N (reset_n),
	
	.AVST_VALID (datavalid),
	.AVST_SOP (startofpacket),
	.AVST_DATA (data),
	.AVST_EOP (endofpacket),
	.AVST_EMPTY (empty),
	
	.CRC_VALID (crcvalid),
	.CRC_BAD (crcbad)		
);

endmodule