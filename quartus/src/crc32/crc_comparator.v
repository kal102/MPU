// Copyright 2012 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////
// 
// CRC Comparator
//	Compare the two CRC input value
//	- CRC from Ethernet Packet and CRC Generator
//
// Author:
// Cher Jier Yap 	- 05-09-2012 
//   
// Revision:
// 05-09-2012 - intial version

module crc_comparator (
	CLK,
	RESET_N,
	
	PKT_CRC_VALID_IN,
	PKT_CRC_CHECKSUM_IN,
	
	CRC_GEN_VALID_IN,
	CRC_GEN_CHECKSUM_IN,
	
	CRC_CHK_VALID_OUT,
	CRC_CHK_BAD_STATUS_OUT
);

parameter	CRC_WIDTH = 32;			//CRC32

input						CLK;
input						RESET_N;
	
input						PKT_CRC_VALID_IN;
input	[CRC_WIDTH-1:0]		PKT_CRC_CHECKSUM_IN;
	
input						CRC_GEN_VALID_IN;
input	[CRC_WIDTH-1:0]		CRC_GEN_CHECKSUM_IN;
	
output						CRC_CHK_VALID_OUT;
output						CRC_CHK_BAD_STATUS_OUT;

reg		pkt_crc_ready;
reg		crc_gen_ready;
reg		[CRC_WIDTH-1:0]		pkt_crc_checksum;
reg		[CRC_WIDTH-1:0]		crc_gen_checksum;
reg							CRC_CHK_VALID_OUT;
reg							CRC_CHK_BAD_STATUS_OUT;

always @(posedge CLK or negedge RESET_N)
	if (!RESET_N)
		pkt_crc_ready <= 1'b0;
	else if (PKT_CRC_VALID_IN)
		pkt_crc_ready <= 1'b1;
	else if (pkt_crc_ready && crc_gen_ready)
		pkt_crc_ready <= 1'b0;
		
always @(posedge CLK or negedge RESET_N)
	if (!RESET_N)
		crc_gen_ready <= 1'b0;
	else if (CRC_GEN_VALID_IN)
		crc_gen_ready <= 1'b1;
	else if (pkt_crc_ready && crc_gen_ready)
		crc_gen_ready <= 1'b0;		
	
always @(posedge CLK or negedge RESET_N)
	if (!RESET_N)
		pkt_crc_checksum <= {CRC_WIDTH{1'b0}};
	else if (PKT_CRC_VALID_IN)
		pkt_crc_checksum <= PKT_CRC_CHECKSUM_IN;
		
always @(posedge CLK or negedge RESET_N)
	if (!RESET_N)
		crc_gen_checksum <= {CRC_WIDTH{1'b0}};
	else if (CRC_GEN_VALID_IN)
		crc_gen_checksum <= CRC_GEN_CHECKSUM_IN;		 				

always @(posedge CLK or negedge RESET_N)
	if (!RESET_N)
		CRC_CHK_VALID_OUT <= 1'b0;
	else if (pkt_crc_ready && crc_gen_ready)
		CRC_CHK_VALID_OUT <= 1'b1;
	else
		CRC_CHK_VALID_OUT <= 1'b0;	
	   		
always @(posedge CLK or negedge RESET_N)
	if (!RESET_N) begin
		CRC_CHK_BAD_STATUS_OUT <= 1'b0;
	end
	else if (pkt_crc_ready && crc_gen_ready) begin
		if (pkt_crc_checksum !== crc_gen_checksum)
			CRC_CHK_BAD_STATUS_OUT <= 1'b1;
		else
			CRC_CHK_BAD_STATUS_OUT <= 1'b0;   
	end
	else begin
		CRC_CHK_BAD_STATUS_OUT <= 1'b0;
	end

endmodule