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
// Byte Endian Converter
//	Convert the input data byte to big or little endian
//	if input is big endian, the output will be little endian
//	if input is little endian, the output will be big endian
//
// Author:
// Cher Jier Yap 	- 05-09-2012 
//   
// Revision:
// 05-09-2012 - intial version

module byte_endian_converter (
	ENABLE,
	DATA_IN,
	DATA_OUT
);

parameter	DATA_WIDTH = 32;				//8, 16, 32, 64

input						ENABLE;
input	[DATA_WIDTH-1:0]	DATA_IN;
output	[DATA_WIDTH-1:0]	DATA_OUT;

generate
	if (DATA_WIDTH == 8) begin 				//no byte endian is required, passthrough
		assign	DATA_OUT = DATA_IN;	
	end			
	else if (DATA_WIDTH == 16) begin
		assign	DATA_OUT = ENABLE? {DATA_IN[7:0], DATA_IN[15:8]} : DATA_IN; 
	end
	else if (DATA_WIDTH == 32) begin
		assign	DATA_OUT = ENABLE? {DATA_IN[7:0], DATA_IN[15:8], DATA_IN[23:16], DATA_IN[31:24]}: DATA_IN;
	end
	else if (DATA_WIDTH == 64) begin
		assign	DATA_OUT = ENABLE? {DATA_IN[7:0], DATA_IN[15:8], DATA_IN[23:16], DATA_IN[31:24], DATA_IN[39:32], DATA_IN[47:40], DATA_IN[55:48], DATA_IN[63:56]}: DATA_IN;
	end
endgenerate

endmodule