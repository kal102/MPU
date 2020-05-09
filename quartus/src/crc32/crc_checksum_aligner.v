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
// CRC Checksum Aligner
//	Main to match the same latancy performance with CRC Compiler (Generator only)
//
// Author:
// Cher Jier Yap 	- 05-09-2012 
//   
// Revision:
// 05-09-2012 - intial version
// 06-09-2012 - CRC_ENA_IN naming change to PKT_TRANSFER_STATUS_IN to avoid confusion with the CRC_ENA output from CRC_ethernet.v
//					Main reason is that PKT_TRANSFER_STATUS_IN cannot have deassertion during a packet transfer but CRC_ENA from CRC_ethernet.v
//					allow deassertion during pkt transfer. 
// 13-09-2012 - PKT_TRANSFER_STATUS_IN input drop due to the CRC_Ethernet.v now able to perform init and crc calculation (EOP) at the same clock cycle
//			  - PKT_TRANSFER_STATUS_IN change to CRC_CHECKSUM_LATCH_IN which is only valid for 1 clock cycle to latch the CRC output  					
// 14-09-2012 - Enhancement:
//					1. Re-architecture the crc_checksum_aligner where variable latency can define through parameter

module	crc_checksum_aligner (
	CLK,
	RESET_N,
	
	CRC_CHECKSUM_LATCH_IN,
	CRC_CHECKSUM_IN,
	
	CRC_VALID_OUT,
	CRC_CHECKSUM_OUT
);

parameter	CRC_WIDTH = 32;
parameter	LATENCY = 0;

input					CLK;
input					RESET_N;
	
input					CRC_CHECKSUM_LATCH_IN;
input	[CRC_WIDTH-1:0]	CRC_CHECKSUM_IN;
	
output					CRC_VALID_OUT;
output	[CRC_WIDTH-1:0]	CRC_CHECKSUM_OUT;

generate
	if (LATENCY == 0) begin
		assign CRC_VALID_OUT = CRC_CHECKSUM_LATCH_IN;  	
		assign CRC_CHECKSUM_OUT = CRC_CHECKSUM_IN; 	
				
	end
	else begin
		reg						crc_valid_delay	[0:LATENCY-1];
		reg		[CRC_WIDTH-1:0]	crc_checksum_delay [0:LATENCY-1];
		
		integer i;
    	always @(posedge CLK or negedge RESET_N)
    		if (!RESET_N) begin
    			for (i=0; i<LATENCY; i=i+1) begin
    				crc_valid_delay[i] <= 1'b0;
    				crc_checksum_delay[i] <= {CRC_WIDTH{1'b0}};
    			end
    		end
    		else begin
    			crc_valid_delay[0] <= CRC_CHECKSUM_LATCH_IN;
    			crc_checksum_delay[0] <= CRC_CHECKSUM_IN;
    				
    			for (i=0; i<LATENCY-1; i=i+1) begin
    				crc_valid_delay[i+1] <= crc_valid_delay[i];
    				crc_checksum_delay[i+1] <= crc_checksum_delay[i]; 
    			end
    		end	
    		
		assign CRC_VALID_OUT = crc_valid_delay[LATENCY-1]; 	
    	assign CRC_CHECKSUM_OUT = crc_checksum_delay[LATENCY-1]; 			
	end
endgenerate	

endmodule