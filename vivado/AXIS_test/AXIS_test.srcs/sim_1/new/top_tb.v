`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2020 14:43:34
// Design Name: 
// Module Name: top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_tb();
//  output [31:0]M0_AXIS_TDATA_0;
//  output M0_AXIS_TLAST_0;
//  input M0_AXIS_TREADY_0;
//  output M0_AXIS_TVALID_0;
//  input [31:0]S0_AXIS_TDATA_0;
//  input S0_AXIS_TLAST_0;
//  output S0_AXIS_TREADY_0;
//  input S0_AXIS_TVALID_0;
//  input clock_clk_n;
//  input clock_clk_p;
//  input reset;

  reg clock_clk_n;
  reg clock_clk_p;
  reg reset;

  wire [31:0]M0_AXIS_TDATA_0;
  wire M0_AXIS_TLAST_0;
  reg  M0_AXIS_TREADY_0;
  wire M0_AXIS_TVALID_0;
  
  reg  [31:0]S0_AXIS_TDATA_0;
  reg  S0_AXIS_TLAST_0;
  wire S0_AXIS_TREADY_0;
  reg  S0_AXIS_TVALID_0;

  design_1_wrapper Xdesign_1_wrapper
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

always begin
     #10;
     clock_clk_p = 1'b1;
     clock_clk_n = 1'b0;
     #10;
     clock_clk_p = 1'b0;
     clock_clk_n = 1'b1;
end

initial begin
    M0_AXIS_TREADY_0 = 1'b1;
    S0_AXIS_TDATA_0  = 32'b0;
    S0_AXIS_TLAST_0  =  1'b0;
    S0_AXIS_TVALID_0 =  1'b0;

    reset = 1'b1;
    #100;
    reset = 1'b0;
end

endmodule
