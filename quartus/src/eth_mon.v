//-----------------------------------------------------------------------------
// Title         : eth_mon
// Project       : TSE Standalone Reference Design
//-----------------------------------------------------------------------------
// File          : eth_mon.v
// Author        : Altera Corporation
//-----------------------------------------------------------------------------
// Functional Description: 
// This module is the top level of the Ethernet Packet Monitor
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


module eth_mon 
(
clk,
reset,
address,
write,
read,
writedata,
readdata,
rx_data,
rx_dval,
rx_sop,
rx_eop,
rx_mod,
rx_err,
rx_rdy
);


input 	clk;					// RX FIFO interface clock
input 	reset;					// Reset Signal
input 	[2:0] address;				// Register Address
input 	write;					// Register Write Strobe
input 	read;					// Register Read Strobe
input 	[31:0] writedata;			// Register Write Data
output 	[31:0] readdata;			// Register Read Data
input 	[31:0] rx_data;				// RX Data (ff_rx_data)
input 	rx_dval;				// RX Data Valid (ff_rx_dval)
input 	rx_sop;					// RX Start of Packet (ff_rx_sop)
input 	rx_eop;					// RX End of Packet (ff_rx_eop)
input 	[1:0] rx_mod;				// RX Data Modulo (ff_rx_mod)
input 	[5:0] rx_err;				// RX Error (rx_err)
output 	rx_rdy;					// RX Application Ready (ff_rx_rdy) 

reg	[31:0] readdata;
reg 	rx_rdy;

// Ethernet Monitor Control Registers
// -------------------------------------

reg 	[31:0] number_packet;			// Register to store number of packets to be received
reg	[31:0] packet_rx_ok;			// Register to count packets received without error
reg	[31:0] packet_rx_error;			// Register to count packets received with error
reg	[63:0] byte_rx_count;			// Register to count number of bytes being received 
reg	[63:0] cycle_rx_count;			// Register to count number of cycle starting from first byte received 
reg 	[31:0] receive_ctrl_status;		// Register to reflect status of the received packets

wire 	[21:0] receive_ctrl_status_wire;
wire 	start;
wire 	stop;
wire 	rx_done;

// CRC status signals
// ----------------------

wire 	crcbad;
wire 	crcvalid;


// Ethernet Packet Monitor Registers :- 

// number_packet register
// ------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			number_packet <= 32'h0;
		else if (write & address == 3'h0)
			number_packet <= writedata;
	end
	
// packet_rx_ok register
// -----------------------
	
always @ (posedge clk or posedge reset)
	begin
		if (reset)
			packet_rx_ok <= 32'h0;
		else if (start)
			packet_rx_ok <= 32'h0;
		else if (~stop & crcvalid & ~crcbad)
			packet_rx_ok <= packet_rx_ok + 32'h1;
	end

// packet_rx_error register
// -------------------------
	
always @ (posedge clk or posedge reset)
	begin
		if (reset)
			packet_rx_error <= 32'h0;
		else if (start)
			packet_rx_error <= 32'h0;
		else if (~stop & crcvalid & crcbad)
			packet_rx_error <= packet_rx_error + 32'h1;
	end

// byte_rx_count register
// -----------------------
	
always @ (posedge clk or posedge reset)
	begin
		if (reset)
			byte_rx_count <= 64'h0;
		else if (start)
			byte_rx_count <= 64'h0;
		else if (~stop & rx_dval & rx_eop & rx_mod == 2'b01)
			byte_rx_count <= byte_rx_count + 64'h3;
		else if (~stop & rx_dval & rx_eop & rx_mod == 2'b10)
			byte_rx_count <= byte_rx_count + 64'h2;
		else if (~stop & rx_dval & rx_eop & rx_mod == 2'b11)
			byte_rx_count <= byte_rx_count + 64'h1;
		else if (~stop & rx_dval)
			byte_rx_count <= byte_rx_count + 64'h4;
	end

// cycle_rx_count register
// -----------------------
	
always @ (posedge clk or posedge reset)
	begin
		if (reset)
			cycle_rx_count <= 64'h0;
		else if (start)
			cycle_rx_count <= 64'h0;
		else if (~stop & ~rx_done & byte_rx_count > 64'h0)
			cycle_rx_count <= cycle_rx_count + 64'h1;
	end

// receive_ctrl_status register
// ----------------------------
	
assign receive_ctrl_status_wire = 22'h0;

always @ (receive_ctrl_status_wire)
	begin
		receive_ctrl_status[31:10] = receive_ctrl_status_wire;
	end

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			receive_ctrl_status[9:0] <= 10'h0;
		else if (write & address == 3'h7)
			receive_ctrl_status[1:0] <= writedata[1:0];
		else if (start)
			receive_ctrl_status[2:0] <= 3'b000;
		else if (rx_eop)
			receive_ctrl_status[9:4] <= rx_err[5:0];
		else if (crcvalid)
			receive_ctrl_status[3] <= crcbad;
		else if ((packet_rx_ok + packet_rx_error) == number_packet)
			receive_ctrl_status[2] <= 1'b1;
	end

assign start = receive_ctrl_status[0];
assign stop = receive_ctrl_status[1];
assign rx_done = receive_ctrl_status[2];

// Output MUX of registers into readdata bus
// ------------------------------------------

always @ (read or address or number_packet or packet_rx_ok or packet_rx_error or receive_ctrl_status)
	begin	
		readdata = 0;
		if (read)
		begin
			case (address)
				3'h0: readdata = number_packet;
				3'h1: readdata = packet_rx_ok;
				3'h2: readdata = packet_rx_error;
				3'h3: readdata = byte_rx_count[31:0];
				3'h4: readdata = byte_rx_count[63:32];
				3'h5: readdata = cycle_rx_count[31:0];
				3'h6: readdata = cycle_rx_count[63:32];
				3'h7: readdata = receive_ctrl_status;
				default: readdata = 32'h0;
			endcase
		end
	end


// Avalon-ST rx_rdy interface to TSE RX FIFO interface
// ------------------------------------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			rx_rdy <= 1'b0;
		else 
			rx_rdy <= 1'b1;
	end


// Using CRC Compiler Checker to verify the data payload of the incoming packets
// --------------------------------------------------------------------------------
	
crcchk_dat32 crcchk_inst 
(
	.clk (clk),
	.data (rx_data),
	.datavalid (rx_dval),
	.empty (rx_mod),
	.endofpacket (rx_eop),
	.reset_n (~reset),
	.startofpacket (rx_sop),
	.crcbad (crcbad),
	.crcvalid (crcvalid)
);

endmodule
