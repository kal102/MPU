
module mac_cell #(parameter VAR_SIZE = 8, parameter ACC_SIZE = 24)
(
  output reg signed [(VAR_SIZE-1):0] a_out,
  output reg signed [(VAR_SIZE-1):0] b_out,
  output reg signed [(ACC_SIZE-1):0] c_out,
  output reg shift_out,
  output reg clear_out,
  input wire signed [(VAR_SIZE-1):0] a_in,
  input wire signed [(VAR_SIZE-1):0] b_in,
  input wire signed [(ACC_SIZE-1):0] c_in,
  input wire clk,
  input wire shift_in,
  input wire clear_in
);
  
  reg signed [(ACC_SIZE-1):0] c_nxt;
  reg signed [(2*VAR_SIZE-1):0] ab;
  
  always @(posedge clk) begin
    a_out <= a_in;
    b_out <= b_in;
    c_out <= c_nxt;
    shift_out <= shift_in;
    clear_out <= clear_in;
  end
  
  always @* begin
    ab = a_in * b_in;
    if (clear_in)
      c_nxt = 0;
    else if (shift_in)
      c_nxt = c_in;
    else
      c_nxt = ab + c_out;
  end
  
endmodule



