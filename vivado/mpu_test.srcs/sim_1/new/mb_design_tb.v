`timescale 1ns / 1ps

module mb_design_tb;

  reg clk_n, clk_p;
  reg reset;

  // Reset stimulus
  initial begin
    reset = 1'b1;
    #10
    reset = 1'b0;
  end
  
  // Clocks stimulus
  initial begin
    clk_n = 1'b0; //set clk to 0
    clk_p = 1'b1;
  end
  
  always begin
    #5
    clk_n = ~clk_n; //toggle clk every 5 time units
    clk_p = ~clk_p; //toggle clk every 5 time units
  end

  mb_design_wrapper mb_design_inst (
    .diff_clock_rtl_clk_n(clk_n),
    .diff_clock_rtl_clk_p(clk_p),
    .reset_rtl(reset)
  );

endmodule
