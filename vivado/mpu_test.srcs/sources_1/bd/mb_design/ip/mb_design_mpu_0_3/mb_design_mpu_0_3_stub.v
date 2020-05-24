// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sun May 24 17:28:34 2020
// Host        : LEN running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/Lukasz/workspace/mpu/vivado/mpu_test.srcs/sources_1/bd/mb_design/ip/mb_design_mpu_0_3/mb_design_mpu_0_3_stub.v
// Design      : mb_design_mpu_0_3
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "top,Vivado 2019.1" *)
module mb_design_mpu_0_3(clk, rst_n, axis_in_tdata, axis_in_tvalid, 
  axis_in_tready, axis_in_tlast, axis_out_tdata, axis_out_tvalid, axis_out_tready, 
  axis_out_tlast)
/* synthesis syn_black_box black_box_pad_pin="clk,rst_n,axis_in_tdata[31:0],axis_in_tvalid,axis_in_tready,axis_in_tlast,axis_out_tdata[31:0],axis_out_tvalid,axis_out_tready,axis_out_tlast" */;
  input clk;
  input rst_n;
  input [31:0]axis_in_tdata;
  input axis_in_tvalid;
  output axis_in_tready;
  input axis_in_tlast;
  output [31:0]axis_out_tdata;
  output axis_out_tvalid;
  input axis_out_tready;
  output axis_out_tlast;
endmodule
