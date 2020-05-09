
`ifndef MPU_FRAME_SVH_
`define MPU_FRAME_SVH_

`include "mpu_macros.svh"

package mpu_frame_pkg;
  
  import mpu_macros_pkg::*;
  
  typedef struct
  {
    logic [47:0] dest;
    logic [47:0] src;
  } mac_addr_t;
  
  typedef logic [15:0] length_t;
  
  typedef struct
  {
     logic [7:0] cmd;
     logic [7:0] buffer;
     logic [7:0] buffer_a_idx;
     logic [7:0] buffer_b_idx;
     logic [7:0] dim_x = 0;
     logic [7:0] dim_y = 0;
     logic [31:0] bias = 0;
     logic [7:0] activation = ACTIVATION_NONE;
     logic [7:0] pooling = POOLING_NONE;
  } cmd_rx_t;  
  
  typedef struct
  {
    logic [7:0] frame;
    logic [7:0] dim_x;
    logic [7:0] dim_y;
  } cmd_tx_t;
  
  typedef logic [7:0] payload_t[$];

	class mpu_frame;

 		protected logic [7:0] octets[$] = {};
    const logic [7:0] command_length = 8'd7;

		function int get_nr_of_octets();
			return octets.size();
		endfunction : get_nr_of_octets

		function logic [7:0] get_first_octet();
			return octets.pop_front();
    endfunction : get_first_octet
    
    function void put_new_octet(logic [7:0] octet);
      octets.push_back(octet);
    endfunction : put_new_octet
    
    extern function void print();
    
    extern function void set_addresses(mac_addr_t mac);
		extern function void set_command(cmd_rx_t cmd);
		extern function bit set_payload(payload_t data);
    extern function mac_addr_t get_addresses();
    extern function length_t get_length();
    extern function cmd_tx_t get_command();
    extern function payload_t get_payload();

	endclass : mpu_frame

  function void mpu_frame::print();
    
    automatic int i;
    
    for(i = 0; i < octets.size(); i++) begin
      $write("%0x", octets[i]);
    end
    $display;
    
  endfunction : print

  function void mpu_frame::set_addresses(mac_addr_t mac);

    /* Destination MAC and source MAC fields */
    for (int i = 6; i >= 1; i--)
      octets.push_back(mac.dest[(i*8-1)-:8]);
    for (int i = 6; i >= 1; i--)
      octets.push_back(mac.src[(i*8-1)-:8]);

  endfunction : set_addresses

	function void mpu_frame::set_command(cmd_rx_t cmd);

    length_t length;

    /* Loading command into payload */
		octets.push_back(cmd.cmd);
		octets.push_back(cmd.buffer);
		octets.push_back(cmd.buffer_a_idx);
		octets.push_back(cmd.buffer_b_idx);
     
    if (cmd.cmd == CMD_LOAD) begin
      /* Matrix dimensions */
      octets.push_back(cmd.dim_x);
      octets.push_back(cmd.dim_y);
      octets.push_back(8'h0);
    end
    else if (cmd.cmd == CMD_MULTIPLY) begin
      /* Additional parameters */
      octets.push_back(cmd.bias[31:24]);
      octets.push_back(cmd.bias[23:16]);
      octets.push_back(cmd.bias[15:8]);
      octets.push_back(cmd.bias[7:0]);
  		octets.push_back(cmd.activation);
  		octets.push_back(cmd.pooling);
      /* Length field */
      length = 8'h4 + 8'd6;
      octets.insert(12, length[15:8]);
      octets.insert(13, length[7:0]);
    end

	endfunction : set_command

	function bit mpu_frame::set_payload(payload_t data);

    length_t length;
    
    if (data.size() > (1500 - command_length)) begin
      $display("Too much data for a single Ethernet frame!");
      return 1;
    end

    /* Length field */
    length = command_length + data.size();
		octets.insert(12, length[15:8]);
    octets.insert(13, length[7:0]);
    
    /* Loading data into payload */
		octets = {octets, data};

		return 0;

	endfunction : set_payload

  function mac_addr_t mpu_frame::get_addresses();
    
    mac_addr_t mac;
    
    /* Destination MAC and source MAC fields */
    for (int i = 6; i >= 1; i--)
      mac.dest[(i*8-1)-:8] = octets.pop_front();
    for (int i = 6; i >= 1; i--)
      mac.src[(i*8-1)-:8] = octets.pop_front();
   
    return mac;
    
  endfunction : get_addresses

  function length_t mpu_frame::get_length();
    
    length_t length;
    
    length[15:8] = octets.pop_front();
    length[7:0] = octets.pop_front();
    
    return length;
    
  endfunction : get_length

  function cmd_tx_t mpu_frame::get_command();
    
    cmd_tx_t cmd;
    
    octets.pop_front();
    cmd.frame = octets.pop_front();
    octets.pop_front();
    cmd.dim_x = octets.pop_front();
    octets.pop_front();
    cmd.dim_y = octets.pop_front();
    
    return cmd;
    
  endfunction : get_command

  function payload_t mpu_frame::get_payload();
    return octets;
  endfunction : get_payload

endpackage : mpu_frame_pkg

`endif //MPU_FRAME_SVH_
