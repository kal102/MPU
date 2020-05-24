
`ifndef MPU_STREAM_SVH_
`define MPU_STREAM_SVH_

`include "mpu_macros.svh"

package mpu_stream_pkg;
  
  import mpu_macros_pkg::*;
  
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
    logic [7:0] error;
    logic [7:0] dim_x;
    logic [7:0] dim_y;
  } cmd_tx_t;
  
  typedef logic [7:0] data_t[$];

  class mpu_stream;

    protected logic [7:0] bytes[$] = {};

    function int get_nr_of_bytes();
      return bytes.size();
    endfunction : get_nr_of_bytes

    function logic [7:0] get_byte();
      return bytes.pop_front();
    endfunction : get_byte
    
    function void put_byte(logic [7:0] data);
      bytes.push_back(data);
    endfunction : put_byte
    
    extern function void print();
    
    extern function void set_command(cmd_rx_t cmd);
    extern function void set_data(data_t data);
    extern function cmd_tx_t get_command();
    extern function data_t get_data();

  endclass : mpu_stream

  function void mpu_stream::print();
    
    automatic int i;
    
    for(i = 0; i < bytes.size(); i++) begin
      $write("%0x", bytes[i]);
    end
    $display;
    
  endfunction : print

  function void mpu_stream::set_command(cmd_rx_t cmd);

    /* Loading command into stream */
    bytes.push_back(cmd.cmd);
    bytes.push_back(cmd.buffer);
    bytes.push_back(cmd.buffer_a_idx);
    bytes.push_back(cmd.buffer_b_idx);
     
    if (cmd.cmd == CMD_LOAD) begin
      /* Matrix dimensions */
      bytes.push_back(cmd.dim_x);
      bytes.push_back(cmd.dim_y);
      bytes.push_back(8'h0);
    end
    else if (cmd.cmd == CMD_MULTIPLY) begin
      /* Additional parameters */
      bytes.push_back(cmd.bias[31:24]);
      bytes.push_back(cmd.bias[23:16]);
      bytes.push_back(cmd.bias[15:8]);
      bytes.push_back(cmd.bias[7:0]);
      bytes.push_back(cmd.activation);
      bytes.push_back(cmd.pooling);
    end

  endfunction : set_command

  function void mpu_stream::set_data(data_t data);

    /* Loading data into stream */
    bytes = {bytes, data};

  endfunction : set_data

  function cmd_tx_t mpu_stream::get_command();
    
    cmd_tx_t cmd;
    
    bytes.pop_front();
    bytes.pop_front();
    bytes.pop_front();
    cmd.error = bytes.pop_front();
    bytes.pop_front();
    cmd.dim_x = bytes.pop_front();
    bytes.pop_front();
    cmd.dim_y = bytes.pop_front();
    
    return cmd;
    
  endfunction : get_command

  function data_t mpu_stream::get_data();
    return bytes;
  endfunction : get_data

endpackage : mpu_stream_pkg

`endif //MPU_STREAM_SVH_

