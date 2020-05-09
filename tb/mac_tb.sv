
`include "src/mac_beh.v"

module mac_tb;
  
  localparam VAR_SIZE = 8;
  localparam ACC_SIZE = 32;
  
  logic signed [(VAR_SIZE-1):0] a, b;
  logic signed [(ACC_SIZE-1):0] acc, bias;
  logic signed [(ACC_SIZE-1):0] result, result_ab;
  logic clk, rst_n;
  integer score;
  
  mac_beh #(.VAR_SIZE(VAR_SIZE), .ACC_SIZE(ACC_SIZE)) m_mac (.acc(acc), .a(a), .b(b), .bias(bias), .clk(clk), .rst_n(rst_n));
  
  initial begin
    clk = 0;
    rst_n = 0;
    bias = 0;
    score = 0;
    $display("---------------------------------------------------");
    repeat(198) clk = #1 !clk;
    #1
    $display($sformatf("Achieved score is %0d/100 (%0d%%)", score, score));
  end
  
  always @(posedge clk) begin
    if (!rst_n)
      result = bias;
    else begin
      result_ab = a * b;
      result = result_ab + result;
    end
  end
  
  always @(negedge clk) begin
    /* Compare accumulator with predicted result */
    if (acc === result) begin
      $display("Test passed!");
      $display($sformatf("A: %0d, B: %0d, Acc: %0d, Reset: %0d, Bias: %0d", a, b, acc, rst_n, bias));
      $display($sformatf("Expected result was: %0d", result));
      score++;
    end
    else begin
      $display("Test failed!");
      $display($sformatf("A: %0d, B: %0d, Acc: %0d, Reset: %0d, Bias: %0d", a, b, acc, rst_n, bias));
      $display($sformatf("Expected result was: %0d", result));
    end
    $display("---------------------------------------------------");
    /* Set new random input values */
    a = $random;
    b = $random;
    bias = $urandom_range(18, 0) - 9;
    rst_n = $urandom;
  end
  
endmodule : mac_tb
