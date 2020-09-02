//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Sat Aug 22 14:51:14 2020
//Host        : DESKTOP-A70U0DK running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (M0_AXIS_TDATA_0,
    M0_AXIS_TLAST_0,
    M0_AXIS_TREADY_0,
    M0_AXIS_TVALID_0,
    S0_AXIS_TDATA_0,
    S0_AXIS_TLAST_0,
    S0_AXIS_TREADY_0,
    S0_AXIS_TVALID_0,
    clock_clk_n,
    clock_clk_p,
    reset);
  output [31:0]M0_AXIS_TDATA_0;
  output M0_AXIS_TLAST_0;
  input M0_AXIS_TREADY_0;
  output M0_AXIS_TVALID_0;
  input [31:0]S0_AXIS_TDATA_0;
  input S0_AXIS_TLAST_0;
  output S0_AXIS_TREADY_0;
  input S0_AXIS_TVALID_0;
  input clock_clk_n;
  input clock_clk_p;
  input reset;

  wire [31:0]M0_AXIS_TDATA_0;
  wire M0_AXIS_TLAST_0;
  wire M0_AXIS_TREADY_0;
  wire M0_AXIS_TVALID_0;
  wire [31:0]S0_AXIS_TDATA_0;
  wire S0_AXIS_TLAST_0;
  wire S0_AXIS_TREADY_0;
  wire S0_AXIS_TVALID_0;
  wire clock_clk_n;
  wire clock_clk_p;
  wire reset;

  design_1 design_1_i
       (.M0_AXIS_TDATA_0(M0_AXIS_TDATA_0),
        .M0_AXIS_TLAST_0(M0_AXIS_TLAST_0),
        .M0_AXIS_TREADY_0(M0_AXIS_TREADY_0),
        .M0_AXIS_TVALID_0(M0_AXIS_TVALID_0),
        .S0_AXIS_TDATA_0(S0_AXIS_TDATA_0),
        .S0_AXIS_TLAST_0(S0_AXIS_TLAST_0),
        .S0_AXIS_TREADY_0(S0_AXIS_TREADY_0),
        .S0_AXIS_TVALID_0(S0_AXIS_TVALID_0),
        .clock_clk_n(clock_clk_n),
        .clock_clk_p(clock_clk_p),
        .reset(reset));
endmodule
