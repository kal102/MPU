//-----------------------------------------------------------------------------
// Title         : eth_gen
// Project       : TSE Standalone Reference Design
//-----------------------------------------------------------------------------
// File          : eth_gen.v
// Author        : Altera Corporation
//-----------------------------------------------------------------------------
// Functional Description: 
// This module is the top level of the Ethernet Packet Generator
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


module eth_gen
(
clk,
reset,
address,
write,
read,
writedata,
readdata,
tx_rdy,
tx_data,
tx_wren,
tx_sop,
tx_eop,
tx_mod,
tx_err
);


// State machine parameters
// -------------------------

parameter state_idle = 0;			// Idle State
parameter state_dest = 1;         		// Destination Address(0..31) State
parameter state_dest_src = 2;			// Destination Address(32..47) & Source Address(0..15) State
parameter state_src = 3;			// Source Address(16..47) State
parameter state_len_seq = 4;			// Length(16:0) & Sequence Number State
parameter state_data = 5;			// Data Pattern State
parameter state_transition = 6;			// Transition State 


input 	clk;                        		// TX FIFO interface clock
input 	reset;                      		// Reset signal 
input 	[3:0] address;				// Register Address
input 	write;					// Register Write Strobe
input 	read;					// Register Read Strobe
input 	[31:0] writedata;			// Register Write Data
output 	[31:0] readdata;			// Register Read Data
input 	tx_rdy;					// TX MAC Ready Signal (ff_tx_rdy)
output 	[31:0] tx_data;				// TX Data (ff_tx_data)
output 	tx_wren;				// TX Write Enable (ff_tx_wren)
output 	tx_sop;					// TX Start of Packet (ff_tx_sop)
output 	tx_eop;					// TX End of Packet (ff_tx_eop)
output 	[1:0] tx_mod;				// TX Data Modulo (ff_tx_mod)
output  tx_err;                                 // TX Data Error (ff_tx_err)

reg 	[31:0] readdata;
reg 	[31:0] tx_data;
reg 	tx_wren;
reg 	tx_sop;
reg 	tx_eop;
reg 	[1:0] tx_mod;

// Ethernet Generator Control Registers
// -------------------------------------

reg 	[31:0] number_packet;			// Register to store number of packets to be transmitted
reg 	[31:0] config_setting;			// Register to configure setting: data pattern type, length
reg	[31:0] rand_seed0; 			// Register to program seed number for prbs generator [31:0]
reg	[31:0] rand_seed1;			// Register to program seed number for prbs generator [45:32]
reg 	[31:0] source_addr0;			// Register to program MAC source address [31:0]
reg 	[31:0] source_addr1;			// Register to program MAC source address [47:32]
reg 	[31:0] destination_addr0;		// Register to program MAC destination address [31:0]
reg 	[31:0] destination_addr1;		// Register to program MAC destination address [47:32]
reg	[31:0] operation;			// Register to configure the operation of generator: Start, Stop and Done status
reg	[31:0] packet_tx_count;			// Register to count number of successfully transmitted packets 

wire 	[15:0] config_setting_wire;
wire 	[15:0] rand_seed1_wire;
wire 	[15:0] source_addr1_wire;
wire 	[15:0] destination_addr1_wire;
wire	[28:0] operation_wire;

wire 	pattern_sel;				// Select what type of data pattern: random or incremental
wire 	length_sel;				// Select what type of packet length: random or fixed
wire 	[13:0] pkt_length;			// Fixed payload length for every packet
wire 	start;					// Start operation for Ethernet Generator
wire 	stop;					// Stop operation for Ethernet Generator
wire 	[47:0] d_addr;				// Destination MAC address
wire 	[47:0] s_addr;				// Source MAC address
wire	[45:0] random_seed;			// Random seed number for PRBS generator

// FSM States
// ----------

wire 	S_IDLE;
wire 	S_DEST;
wire 	S_DEST_SRC;
wire 	S_SRC;
wire 	S_LEN_SEQ;
wire 	S_DATA;
wire 	S_TRANSITION;
reg 	[2:0] ns;
reg 	[2:0] ps;

// Avalon-ST signals to CRC generator
// -----------------------------------

reg	[31:0] tx_data_reg;
reg	tx_wren_reg;
reg	tx_sop_reg;
reg	tx_eop_reg;
reg	[1:0] tx_mod_reg;
reg	tx_eop_buffer; //nga
reg 	crc_valid_buffer; //nga
reg	tx_rdy_buffer; //nga
// Merging packet with CRC related signals
// ----------------------------------------

wire	crcvalid;
wire 	[31:0] checksum;
reg	[31:0] checksum_reg;
reg	[31:0] checksum_reg_buffer;
reg	[1:0] crcvalid_count;
wire 	[31:0] tx_data_out;
wire 	[4:0] tx_ctrl_out;
reg	tx_eop_out;
reg	[1:0] tx_mod_out;

// Other control signals
// ----------------------

wire 	[45:0] tx_prbs;
reg 	[15:0] byte_count;
reg 	[31:0] data_pattern;
reg 	[15:0] length;
reg 	[15:0] seq_num;
wire 	[2:0] mod;


// Ethernet Packet Generator Registers :- 

// number_packet register
// ------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			number_packet <= 32'h0;
		else if (write & address == 4'h0)
			number_packet <= writedata;
	end
	
// config_setting register
// -------------------------

assign config_setting_wire = 16'h0;

always @ (config_setting_wire)
	begin
		config_setting[31:16] = config_setting_wire;
	end

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			config_setting[15:0] <= 16'h0;
		else if (write & address == 4'h1)
			config_setting[15:0] <= writedata[15:0];
	end

assign length_sel = config_setting[0];
assign pkt_length = config_setting[14:1];
assign pattern_sel = config_setting[15];

// rand_seed0 register
// -----------------------
	
always @ (posedge clk or posedge reset)
	begin
		if (reset)
			rand_seed0 <= 32'h0;
		else if (write & address == 4'h2)
			rand_seed0 <= writedata;
	end

// rand_seed1 register
// -----------------------
	
assign rand_seed1_wire = 16'h0;

always @ (rand_seed1_wire)
	begin
		rand_seed1[31:16] = rand_seed1_wire;
	end

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			rand_seed1[15:0] <= 16'h0;
		else if (write & address == 4'h3)
			rand_seed1[15:0] <= writedata[15:0];
	end

assign random_seed = {rand_seed1[13:0], rand_seed0[31:0]};

// source_addr0 register
// -----------------------
	
always @ (posedge clk or posedge reset)
	begin
		if (reset)
			source_addr0 <= 32'h0;
		else if (write & address == 4'h4)
			source_addr0 <= writedata;
	end

// source_addr1 register
// -----------------------
	
assign source_addr1_wire = 16'h0;

always @ (source_addr1_wire)
	begin
		source_addr1[31:16] = source_addr1_wire;
	end

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			source_addr1[15:0] <= 16'h0;
		else if (write & address == 4'h5)
			source_addr1[15:0] <= writedata[15:0];
	end

assign s_addr = {source_addr1[15:0], source_addr0[31:0]};

// destination_addr0 register
// ----------------------------
	
always @ (posedge clk or posedge reset)
	begin
		if (reset)
			destination_addr0 <= 32'h0;
		else if (write & address == 4'h6)
			destination_addr0 <= writedata;
	end

// destination_addr1 register
// ----------------------------
	
assign destination_addr1_wire = 16'h0;

always @ (destination_addr1_wire)
	begin
		destination_addr1[31:16] = destination_addr1_wire;
	end

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			destination_addr1[15:0] <= 16'h0;
		else if (write & address == 4'h7)
			destination_addr1[15:0] <= writedata[15:0];
	end

assign d_addr = {destination_addr1[15:0], destination_addr0[31:0]};

// operation register
// ---------------------
	
assign operation_wire = 29'h0;

always @ (operation_wire)
	begin
		operation[31:3] = operation_wire;
	end

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			operation[2:0] <= 3'b000;
		else if (write & address == 4'h8)
			operation[1:0] <= writedata[1:0];
		else if (start) 
			operation[2:0] <= 3'b000;
		else if (packet_tx_count == number_packet) 
			operation[2] <= 1'b1;
	end

assign start = operation[0];
assign stop = operation[1];

// packet_tx_count register
// ------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			packet_tx_count <= 32'h0;
		else if (start)
			packet_tx_count <= 32'h0;
		else if (tx_rdy & S_TRANSITION)
			packet_tx_count <= packet_tx_count + 32'h1;
	end
	
// Output MUX of registers into readdata bus
// ------------------------------------------

always @ (read or address or number_packet or config_setting or rand_seed0 or rand_seed1 or source_addr0 or source_addr1 or 
	  destination_addr0 or destination_addr1 or operation or packet_tx_count)
	begin
		readdata = 32'h0;
		if (read)
		begin
			case (address)
				4'h0: readdata = number_packet;
				4'h1: readdata = config_setting;
				4'h2: readdata = rand_seed0;
				4'h3: readdata = rand_seed1;
				4'h4: readdata = source_addr0;
				4'h5: readdata = source_addr1;
				4'h6: readdata = destination_addr0;
				4'h7: readdata = destination_addr1;
				4'h8: readdata = operation;
				4'h9: readdata = packet_tx_count;
				default: readdata = 32'h0;
			endcase
		end
	end


// Supports a maximum bus width of 46 bits for pseudo random data pattern
// -----------------------------------------------------------------------

prbs23 prbs_tx0
(
    .clk        (clk),
    .rst_n      (~reset),
	.load	    (start),
    .enable     (tx_rdy & (S_LEN_SEQ | S_DATA)),
	.seed	    (random_seed[22:0]),
    .d          (tx_prbs[22:0]),
    .m          (tx_prbs[22:0])
);

prbs23 prbs_tx1
(
    .clk        (clk),
    .rst_n      (~reset),
	.load	    (start),
    .enable     (tx_rdy & (S_LEN_SEQ | S_DATA)),
	.seed	    (random_seed[45:23]),
    .d          (tx_prbs[45:23]),
    .m	    	(tx_prbs[45:23])
);


// FSM State Machine for Generator
// --------------------------------
	
always @ (posedge clk or posedge reset)
	begin
		if (reset)
			ps <= state_idle;
		else if (start)
			ps <= state_dest;
		else
			ps <= ns;
	end

always @ (ps or start or stop or tx_rdy or byte_count or packet_tx_count or number_packet)
	begin
		case (ps)
			state_idle:
			begin
				if (start)
					ns = state_dest;
				else 
					ns = state_idle;
			end
			state_dest:
			begin
				if (tx_rdy)
					ns = state_dest_src;
				else 
					ns = state_dest;
			end
			state_dest_src:
			begin
				if (tx_rdy)
					ns = state_src;
				else
					ns = state_dest_src;
			end
			state_src:
			begin
				if (tx_rdy)
					ns = state_len_seq;
				else
					ns = state_src;
			end
			state_len_seq:
			begin
				if (tx_rdy & (byte_count == 16'h0))
					ns = state_transition;
				else if  (tx_rdy)
					ns = state_data;
				else
					ns = state_len_seq;
			end
			state_data:
			begin
				if  (tx_rdy & (byte_count[15] | byte_count == 16'h0))
					ns = state_transition;
				else
					ns = state_data;
			end
			state_transition:
			begin
				if  (tx_rdy & ~stop & packet_tx_count < number_packet)
					ns = state_dest;
				else if (stop | packet_tx_count == number_packet)
					ns = state_idle;
				else
					ns = state_transition;
			end
			default:
					ns = state_idle;
		endcase
	end		
	
assign S_IDLE = (ns == state_idle) ? 1'b1 : 1'b0;
assign S_DEST = (ns == state_dest) ? 1'b1 : 1'b0;
assign S_DEST_SRC = (ns == state_dest_src) ? 1'b1 : 1'b0;
assign S_SRC = (ns == state_src) ? 1'b1 : 1'b0;
assign S_LEN_SEQ = (ns == state_len_seq) ? 1'b1 : 1'b0;
assign S_DATA = (ns == state_data) ? 1'b1 : 1'b0;
assign S_TRANSITION = (ns == state_transition) ? 1'b1 : 1'b0;

// Length is used to store the payload length size. Payload length smaller than 46 will have zeros data padded 
// Allowable fixed payload length: 6 -> 9582
// Allowable random payload length: 6 -> 1500
// --------------------------------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			length <= 16'h0;
		else if (S_DEST_SRC & ~length_sel & (pkt_length < 14'h0018))
			length <= 16'h0;
		else if (S_DEST_SRC & ~length_sel & (pkt_length > 14'h2580))
			length <= 16'h2568;
		else if (S_DEST_SRC & ~length_sel)
			length <= {2'b00, pkt_length - 14'h18};
		else if (S_DEST_SRC & length_sel)
			length <= (tx_prbs[42:32] % 16'h05D7);
	end

// Byte_count is used to keep track of how many bytes of data payload being generated out	
// --------------------------------------------------------------------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			byte_count <= 16'h0;
		else if (S_SRC)
			byte_count <= length;
		else if (S_DATA & tx_rdy)
			byte_count <= byte_count - 16'h4;
	end

// Seq_num is inserted into the first 2 bytes of data payload of every packet
// ---------------------------------------------------------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			seq_num <= 16'h0;
		else if (start)
			seq_num <= 16'h0;
		else if (S_TRANSITION & tx_rdy)
			seq_num <= seq_num + 16'h1;
	end	

// Generation of incremental data or pseudo random data 
// -----------------------------------------------------
 
always @ (posedge clk or posedge reset)
	begin
		if (reset)
			data_pattern <= 32'h0;
		else if (S_IDLE & ~pattern_sel)
			data_pattern <= 32'h00010203;
		else if (S_DATA & ~pattern_sel & tx_rdy & data_pattern == 32'hFCFDFEFF)
			data_pattern <= 32'h00010203;
		else if (S_DATA & ~pattern_sel & tx_rdy)
			data_pattern <= data_pattern + 32'h04040404;
		else if ((S_LEN_SEQ | S_DATA) & pattern_sel & tx_rdy)
			data_pattern <= tx_prbs[31:0];
	end

// Avalon-ST tx_data interface to CRC generator
// ---------------------------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			tx_data_reg <= 32'h0;
		else if (S_DEST)
			tx_data_reg <= {d_addr[7:0], d_addr[15:8], d_addr[23:16], d_addr[31:24]};
		else if (S_DEST_SRC)
			tx_data_reg <= {d_addr[39:32], d_addr[47:40], s_addr[7:0], s_addr[15:8]};
		else if (S_SRC)
			tx_data_reg <= {s_addr[23:16], s_addr[31:24], s_addr[39:32], s_addr[47:40]};
		else if (S_LEN_SEQ)
			tx_data_reg <= {byte_count + 16'h6, seq_num};
		else if (S_DATA & tx_rdy)
			tx_data_reg <= data_pattern;
	end
	
// Avalon-ST tx_wren interface to CRC generator
// ---------------------------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			tx_wren_reg <= 1'b0;
		else if (S_IDLE | S_TRANSITION)
			tx_wren_reg <= 1'b0;
		else 
			tx_wren_reg <= 1'b1;
	end
	
// Avalon-ST tx_sop interface to CRC generator
// ---------------------------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			tx_sop_reg <= 1'b0;
		else if (S_DEST)
			tx_sop_reg <= 1'b1;
		else
			tx_sop_reg <= 1'b0;
	end
	
// Avalon-ST tx_eop interface to CRC generator
// ---------------------------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			tx_eop_reg <= 1'b0;
		else if (S_LEN_SEQ & (byte_count == 0))
			tx_eop_reg <= 1'b1;
		else if (S_DATA & tx_rdy & (byte_count <= 4))
			tx_eop_reg <= 1'b1;
		else if (S_TRANSITION)
			tx_eop_reg <= 1'b0;
	end

// Avalon-ST tx_mod interface to CRC generator
// ---------------------------------------------

assign mod = 3'h4 - length[1:0];

always @ (posedge clk or posedge reset) 	
	begin 
		if (reset)
			tx_mod_reg <= 2'b00;
		else if (S_DATA & tx_rdy & (byte_count <= 4))
			tx_mod_reg <= mod[1:0];
		else if (S_TRANSITION)
			tx_mod_reg <= 2'b00;
	end	

// Using CRC Compiler to generate checksum and append it to EOP
// -------------------------------------------------------------
	
crcgen_dat32 crcgen_inst
(
	.clk 		(clk),
	.data 		(tx_data_reg),
	.datavalid 	(tx_wren_reg & tx_rdy),
	.empty 		(tx_mod_reg),
	.endofpacket 	(tx_eop_reg),
	.reset_n 	(~reset),
	.startofpacket 	(tx_sop_reg),
	.checksum 	(checksum),
	.crcvalid 	(crcvalid)
);

// Using RAM based shift register to delay packet payload sending to TSE TX FIFO
// interface for CRC checksum merging at EOP 
// -------------------------------------------------------------------------------

shiftreg_data shiftreg_data_inst 
(
	.clken		(tx_rdy),
	.clock		(clk),
	.shiftin	(tx_data_reg),
	.shiftout	(tx_data_out),
	.taps		()
);

// Using RAM based shift register to store and delay control signals
// ------------------------------------------------------------------

shiftreg_ctrl shiftreg_ctrl_inst 
(
	.clken		(tx_rdy),
	.clock		(clk),
	.shiftin	({tx_wren_reg, tx_sop_reg, tx_eop_reg, tx_mod_reg}),
	.shiftout	(tx_ctrl_out),
	.taps		()
);

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			crcvalid_count <= 2'b00;
		else if (crcvalid )
			crcvalid_count <= crcvalid_count + 2'b01;
		else if ((tx_rdy & tx_eop) | (tx_eop_buffer & crc_valid_buffer))
			crcvalid_count <= crcvalid_count - 2'b01;
	end

	//nga
always @ (posedge clk or posedge reset)
	begin
		if (reset)
			tx_eop_buffer <= 1'b0;
		else if (tx_rdy)
			tx_eop_buffer <= tx_eop;
	end


always @ (posedge clk or posedge reset)
	begin
		if (reset)
			crc_valid_buffer <= 1'b0;
		else if (tx_rdy)
			crc_valid_buffer <= crcvalid;
	end	



//=============	
always @ (posedge clk or posedge reset)
	begin
		if (reset)
			checksum_reg <= 32'h0;
		else if (crcvalid)
			checksum_reg <= checksum;
	end

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			checksum_reg_buffer <= 32'h0;
		else if (crcvalid & (crcvalid_count == 2'b01))
			checksum_reg_buffer <= checksum_reg;
	end

// Avalon-ST tx_data interface to TSE TX FIFO interface
// -----------------------------------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			tx_data <= 32'h0;
		else if (tx_rdy & crcvalid & (tx_ctrl_out[2:0] == 3'b101))
			tx_data <= {tx_data_out[31:8], checksum[31:24]};
		else if (tx_rdy & crcvalid & (tx_ctrl_out[2:0] == 3'b110))
			tx_data <= {tx_data_out[31:16], checksum[31:16]};
		else if (tx_rdy & crcvalid & (tx_ctrl_out[2:0] == 3'b111))
			tx_data <= {tx_data_out[31:24], checksum[31:8]};
		else if (tx_rdy & ~crcvalid & (tx_ctrl_out[2:0] == 3'b101))
			tx_data <= {tx_data_out[31:8], checksum_reg[31:24]};
		else if (tx_rdy & ~crcvalid & (tx_ctrl_out[2:0] == 3'b110))
			tx_data <= {tx_data_out[31:16], checksum_reg[31:16]};
		else if (tx_rdy & ~crcvalid & (tx_ctrl_out[2:0] == 3'b111))
			tx_data <= {tx_data_out[31:24], checksum_reg[31:8]};
		else if (tx_rdy & tx_eop_out & (crcvalid_count == 2'b10) & (tx_mod_out == 2'b01))
			tx_data <= {checksum_reg_buffer[23:0], 8'h0};
		else if (tx_rdy & tx_eop_out & (crcvalid_count == 2'b10) & (tx_mod_out == 2'b10))
			tx_data <= {checksum_reg_buffer[15:0], 16'h0};
		else if (tx_rdy & tx_eop_out & (crcvalid_count == 2'b10) & (tx_mod_out == 2'b11))
			tx_data <= {checksum_reg_buffer[7:0], 24'h0};
		else if (tx_rdy & tx_eop_out & (crcvalid_count == 2'b10) & (tx_mod_out == 2'b00))
			tx_data <= checksum_reg_buffer;
		else if (tx_rdy & tx_eop_out & (tx_mod_out == 2'b01))
			tx_data <= {checksum_reg[23:0], 8'h0};
		else if (tx_rdy & tx_eop_out & (tx_mod_out == 2'b10))
			tx_data <= {checksum_reg[15:0], 16'h0};
		else if (tx_rdy & tx_eop_out & (tx_mod_out == 2'b11))
			tx_data <= {checksum_reg[7:0], 24'h0};
		else if (tx_rdy & tx_eop_out & (tx_mod_out == 2'b00))
			tx_data <= checksum_reg;
		else if (tx_rdy)
			tx_data <= tx_data_out;
	end

// Avalon-ST tx_sop interface to TSE TX FIFO interface
// -----------------------------------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			tx_sop <= 1'b0;
		else if (tx_rdy) 
			tx_sop <= tx_ctrl_out[3];
	end

// Avalon-ST tx_wren interface to TSE TX FIFO interface
// -----------------------------------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			tx_wren <= 1'b0;
		else if (tx_rdy)
			tx_wren <= tx_ctrl_out[4] | tx_eop_out;
	end

// Avalon-ST tx_eop interface to TSE TX FIFO interface
// -----------------------------------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			tx_eop_out <= 1'b0;
		else if (tx_rdy)
			tx_eop_out <= tx_ctrl_out[2];
	end

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			tx_eop <= 1'b0;
		else if (tx_rdy)
			tx_eop <= tx_eop_out;
	end




// Avalon-ST tx_mod interface to TSE TX FIFO interface
// -----------------------------------------------------

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			tx_mod_out <= 2'b00;
		else if (tx_rdy)
			tx_mod_out <= tx_ctrl_out[1:0];
	end

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			tx_mod <= 2'b00;
		else if (tx_rdy)
			tx_mod <= tx_mod_out;
	end

// Avalon-ST tx_err interface to TSE TX FIFO interface
// -----------------------------------------------------

assign tx_err = 1'b0;

endmodule
