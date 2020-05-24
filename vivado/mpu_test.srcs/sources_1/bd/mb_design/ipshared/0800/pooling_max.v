
module pooling_max #(parameter ACC_SIZE = 32)
(
  output wire signed [(ACC_SIZE-1):0] out,
  input wire signed [(ACC_SIZE-1):0] in_0,
  input wire signed [(ACC_SIZE-1):0] in_1,
  input wire signed [(ACC_SIZE-1):0] in_2,
  input wire signed [(ACC_SIZE-1):0] in_3,
  input wire clk,
  input wire rst_n
);
  
  reg signed [(ACC_SIZE-1):0] row_1;
  reg signed [(ACC_SIZE-1):0] row_2;
  
  always @(posedge clk) begin
    if (!rst_n) begin
      row_1 <= 0;
      row_2 <= 0;
    end
    else begin
      row_1 <= (in_1 > in_0) ? in_1 : in_0;
      row_2 <= (in_3 > in_2) ? in_3 : in_2;
    end
  end
  
  assign out = (row_2 > row_1) ? row_2 : row_1;
  
endmodule