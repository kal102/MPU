//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Sun May 24 17:22:18 2020
//Host        : LEN running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target mb_design_wrapper.bd
//Design      : mb_design_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module mb_design_wrapper
   (clk_rtl,
    reset_rtl);
  input clk_rtl;
  input reset_rtl;

  wire clk_rtl;
  wire reset_rtl;

  mb_design mb_design_i
       (.clk_rtl(clk_rtl),
        .reset_rtl(reset_rtl));
endmodule
