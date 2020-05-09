
module mmu_cell #(parameter VAR_SIZE = 8, parameter ACC_SIZE = 32)
(
  output reg signed [(VAR_SIZE-1):0] a_out,
  output reg signed [(VAR_SIZE-1):0] b_out,
  output reg signed [(ACC_SIZE-1):0] c_out,
  output reg shift_out,
  output reg clear_out,
  input wire signed [(VAR_SIZE-1):0] a_in,
  input wire signed [(VAR_SIZE-1):0] b_in,
  input wire signed [(ACC_SIZE-1):0] c_in,
  input wire signed [(ACC_SIZE-1):0] bias,
  input wire clk,
  input wire rst_n,
  input wire shift_in,
  input wire clear_in
);
  
  wire signed [(ACC_SIZE-1):0] acc;
  wire mac_reset;
  
  mac_beh #(.VAR_SIZE(VAR_SIZE), .ACC_SIZE(ACC_SIZE)) mac (.acc(acc), .a(a_in), .b(b_in), .bias(bias), .clk(clk), .rst_n(mac_reset));
  
  always @(posedge clk) begin
    if (!rst_n) begin
      a_out <= 0;
      b_out <= 0;
      c_out <= 0;
      shift_out <= 0;
      clear_out <= 0;
    end
    else begin
      a_out <= a_in;
      b_out <= b_in;
      c_out <= shift_in ? c_in : acc;
      shift_out <= shift_in;
      clear_out <= clear_in;
    end
  end
  
  assign mac_reset = ((shift_in && !shift_out) || (clear_in && !clear_out)) ? 0 : rst_n;
  
endmodule
