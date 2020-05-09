//-----------------------------------------------------------------------------
// Title         : prbs23
// Project       : TSE Standalone Reference Design
//-----------------------------------------------------------------------------
// File          : prbs23.v
// Author        : Altera Corporation
//-----------------------------------------------------------------------------
// Functional Description: 
// This module is the Pseudo-Random Bit Sequence 23 Block 
// where g(x) = x^23 + x^18 + x^0
//
// use lsb of m 1st first
// k can be > N, but part of the sequence will be skipped
//
//-------------------------------------------------------------------------------
//
// Copyright 2007 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.  
// This reference design file, and your use thereof, is subject to and governed by
// the terms and conditions of the applicable Altera Reference Design License Agreement.
// By using this reference design file, you indicate your acceptance of such terms and
// conditions between you and Altera Corporation.  In the event that you do not agree with
// such terms and conditions, you may not use the reference design file. Please promptly
// destroy any copies you have made.
//
// This reference design file being provided on an "as-is" basis and as an accommodation 
// and therefore all warranties, representations or guarantees of any kind 
// (whether express, implied or statutory) including, without limitation, warranties of 
// merchantability, non-infringement, or fitness for a particular purpose, are 
// specifically disclaimed.  By making this reference design file available, Altera
// expressly does not recommend, suggest or require that this reference design file be
// used in combination with any other product not provided by Altera

// turn off bogus verilog processor warnings 
// altera message_off 10034 10035 10036 10037 10230 


module prbs23 
(
clk,
rst_n,
load,
enable,
seed,
d,              	// feed from m for prbs generator
m
);

parameter k = 23;       //step value = a^k
parameter N = 23;

input	clk;
input   rst_n;
input	load;
input   enable;
input 	[N-1:0] seed;
input 	[N-1:0] d;
output	[N-1:0] m;

reg   	[N-1:0] m;
reg   	[N-1:0] tmpa;
reg   	[N-1:0] tmpb;
integer i,j;

always @(posedge clk)
begin
    if (!rst_n)
        m <= seed;
    else if (load)
	m <= seed;
    else
    begin
        if (enable)
        begin
            tmpa = d;
            for (i=0; i<k; i=i+1)
            begin
                for (j=0; j<(N-1); j=j+1)
                    tmpb[j] = tmpa[j+1];
                    tmpb[N-1] = tmpa[18] ^ tmpa[0];      //x^23 + x[18] + x[0]
                tmpa = tmpb;
            end
            m <= tmpb;
        end
    end
end

endmodule
