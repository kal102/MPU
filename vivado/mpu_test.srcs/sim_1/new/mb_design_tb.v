`timescale 1ns / 1ps

module mb_design_tb;

  reg clk;
  reg reset;
  wire [7:0] leds_tri_o;

  // Reset stimulus
  initial begin
    reset = 1'b1;
    #10
    reset = 1'b0;
  end
  
  // Clocks stimulus
  initial begin
    clk = 1'b0; //set clk to 0
  end
  
  always begin
    #5 clk = ~clk; //toggle clk every 5 time units
  end

  mb_design_wrapper mb_design_inst (
    .clk_rtl(clk),
    .leds_tri_o(leds_tri_o),
    .reset(reset)
  );

endmodule
