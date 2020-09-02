//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Fri Aug 28 20:33:06 2020
//Host        : DESKTOP-A70U0DK running 64-bit major release  (build 9200)
//Command     : generate_target mb_design_wrapper.bd
//Design      : mb_design_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module mb_design_wrapper
   (clk_rtl,
    leds_tri_o,
    reset);
  input clk_rtl;
  output [7:0]leds_tri_o;
  input reset;

  wire clk_rtl;
  wire [7:0]leds_tri_o;
  wire reset;

  mb_design mb_design_i
       (.clk_rtl(clk_rtl),
        .leds_tri_o(leds_tri_o),
        .reset(reset));
endmodule
