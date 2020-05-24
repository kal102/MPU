`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2020 17:47:45
// Design Name: 
// Module Name: top
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


module top(
    input clock,
    input reset
    );
  
  wire diff_clock_rtl_clk_n;
  wire diff_clock_rtl_clk_p;
  wire reset_rtl;
    
  mb_design_wrapper mb_design_wrapper_i
       (.diff_clock_rtl_clk_n(diff_clock_rtl_clk_n),
        .diff_clock_rtl_clk_p(diff_clock_rtl_clk_p),
        .reset_rtl(reset_rtl));    
  
  assign diff_clock_rtl_clk_n = !clock;
  assign diff_clock_rtl_clk_p = clock;
  assign reset_rtl = reset;
    
endmodule
