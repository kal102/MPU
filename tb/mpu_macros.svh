
`ifndef MPU_MACROS_SVH_
`define MPU_MACROS_SVH_

package mpu_macros_pkg;

  parameter int VAR_SIZE = 8;
  parameter int ACC_SIZE = 24;
  parameter int MMU_SIZE = 10;
  parameter int MATRIX_SIZE = MMU_SIZE;
  parameter int BUFFER_CNT = 4;

  /* MPU commands */
  parameter [7:0] CMD_NONE = 8'h0;
  parameter [7:0] CMD_LOAD = 8'h1;
  parameter [7:0] CMD_MULTIPLY = 8'h2;

  /* Buffer */
  parameter [7:0] BUFFER_A = 8'h0;
  parameter [7:0] BUFFER_B = 8'h1;

  /* MAC default addresses */
  parameter [47:0] MAC_MPU = 48'h5044332211EE;
  parameter [47:0] MAC_HOST = 48'hDC0EA1F0573B;

  /* Activation functions */
  parameter [7:0] ACTIVATION_NONE = 8'h0;
  parameter [7:0] ACTIVATION_RELU = 8'h1;

  /* Pooling functions */
  parameter [7:0] POOLING_NONE = 8'h0;
  parameter [7:0] POOLING_MAX = 8'h1;
  
  /* Frame types */
  parameter [2:0] FRAME_NONE = 3'b000;
  parameter [2:0] FRAME_DATA = 3'b001;
  parameter [2:0] FRAME_ERR_DIM = 3'b011;
  parameter [2:0] FRAME_ERR_CMD = 3'b010;
  parameter [2:0] FRAME_ERR_FRAME = 3'b110;
  
  /* Stream types */
  parameter [1:0] STREAM_NONE = 2'b00;
  parameter [1:0] STREAM_DATA = 2'b01;
  parameter [1:0] STREAM_ERR_DIM = 2'b11;
  parameter [1:0] STREAM_ERR_CMD = 2'b10;
  
endpackage : mpu_macros_pkg

`endif //MPU_MACROS_SVH_
